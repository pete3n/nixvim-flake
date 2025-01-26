{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfgConnect = config.services.lte-modem-connect;

  customUdhcpcScript =
    pkgs.writeScript "udhcpc-custom-script.sh"
    # bash
      
      ''
        # udhcpc script to set a lower metric for the LTE connection
        #!/bin/sh

        DEFAULT_SCRIPT="${pkgs.busybox}/default.script"
        IP_CMD="${pkgs.iproute2}/sbin/ip"
        case "$1" in
          bound|renew)

            $DEFAULT_SCRIPT "$@"
            # Adjust the metric of the default route
            $IP_CMD route del default via $router dev $interface
            $IP_CMD route add default via $router dev $interface metric 4000

            ;;
          *)
            $DEFAULT_SCRIPT "$@"
            ;;
        esac
      '';
in
{

  options.services.lte-modem-connect = {
    enable = lib.mkEnableOption "LTE Modem connect service";

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Autostart service on boot; default true";
    };

    autoconnect = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically reconnect if connection lost; default true";
    };

    apn = lib.mkOption {
      type = lib.types.str;
      default = "globalnet";
      description = "The APN for the LTE modem; default to globalnet";
    };

    ipType = lib.mkOption {
      type = lib.types.enum [
        "4"
        "6"
      ];
      default = "4";
      description = "IP version to use for the modem connection; default IPv4";
    };

    useQosHeader = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "QoS header option for connection; Default net-no-qos-header";
    };

    useRawIp = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable or disable raw IP mode for the LTE modem; default true";
    };

    routeWifi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Keep default gateway through wifi if it is up";
    };
  };

  config = lib.mkIf cfgConnect.enable {
    # Ensure the device shows up as a network device
    #hardware.usb-modeswitch.enable = true;    

    environment.systemPackages = with pkgs; [
      libqmi # Install qualcomm tools sytem-wide for troubleshooting
      socat
      minicom
      atinout
      (busybox.override { enableAppletSymlinks = false; }) # Install Busybox for udhcpc don't install symlinks that overwrite system bins
    ];

    # Triggered by udev when device present to allow conditional start of other
    # services that rely on the modem presence
    systemd.services.lte-modem-detect = {
      description = "LTE Modem Detection Service";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/true"; # No-op command
        RemainAfterExit = true;
      };
    };

    systemd.services.lte-modem-connect = {
      description = "LTE modem connection service";
      requires = [ "lte-modem-detect.service" ];
      after = [
        "lte-modem-detect.service"
        "network.target"
      ];
      wantedBy = lib.optional (cfgConnect.autostart) "multi-user.target";
      serviceConfig = {
        ExecStart =
          let
            raw_ip_mode = "${if cfgConnect.useRawIp then "net-raw-ip|" else ""}";
            raw_ip_flag = "${if cfgConnect.useRawIp then "Y" else "N"}";
            autoconnect_option = "${
              if cfgConnect.autoconnect then "--wds-set-autoconnect-settings=enabled" else ""
            }";
            qos_header_option = "${if cfgConnect.useQosHeader then "net-qos-header" else "net-no-qos-header"}";
            device_open_net_arg = "'${raw_ip_mode}${qos_header_option}'";
            script = pkgs.writeScript "cfgConnect.lte-modem" 
	    # bash
	    ''
              qmicli=${pkgs.libqmi}/bin/qmicli
              ip=${pkgs.iproute2}/bin/ip
              awk=${pkgs.gawk}/bin/awk
              ipcalc=${pkgs.ipcalc}/bin/ipcalc
              udhcpc=${pkgs.busybox}/bin/udhcpc

              sleep 30
              for dev in /sys/class/usbmisc/*; do
                  if [[ -e "$dev/device/driver" && $(readlink "$dev/device/driver") == */qmi_wwan ]]; then
                      device="/dev/$(basename $dev)"
                      break
                  fi
              done

              if [[ -z "$device" ]]; then
                  echo "No USB Modem found"
                  exit 1
              fi

              iface=$($qmicli -d $device --get-wwan-iface)
              if [ -z "$iface" ]; then
                  echo "LTE Modem interface not found"
                  exit 1
              fi
              echo "Detected IP interface $iface"
              $ip link set $iface down
              echo ${raw_ip_flag} > /sys/class/net/$iface/qmi/raw_ip
              $ip link set $iface up

              if [[ -n ${autoconnect_option} ]]; then
                  echo "Setting autoconnect"
                  $qmicli -p -d $device ${autoconnect_option}
              fi

              echo "Opening connection"
              $qmicli -p -d $device --device-open-net=${device_open_net_arg} --wds-start-network="apn='${cfgConnect.apn}',ip-type=${cfgConnect.ipType}" --client-no-release-cid
              sleep 5
              connection_status=$($qmicli -p -d $device --wds-get-packet-service-status | grep -o 'connected') 

              if [[ -z $connection_status ]]; then 
                  echo "Modem $device failed to connect"
                  exit 1
              else
                  sleep 3
                  $udhcpc -q -f -v -i $iface -s ${customUdhcpcScript}
              fi
            '';
          in
          "${pkgs.bash}/bin/bash ${script}";
      };
    };

    services.udev.extraRules = ''
      KERNEL=="cdc-wdm[0-9]*", SUBSYSTEMS=="usb", DRIVERS=="qmi_wwan", ACTION=="add", ENV{SYSTEMD_WANTS}+="detect-lte-modem.service" TAG+="systemd"
    '';
  };
}
