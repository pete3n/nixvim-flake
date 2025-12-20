{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;

  supportedPythonVersions = [
    "2.7"
    "3.10"
    "3.14"
    "3.15"
  ];
in
{
  options.language_support = {
    lua.enable = mkEnableOption "Lua language support";
    nix.enable = mkEnableOption "Nix language support";
    rust.enable = mkEnableOption "Rust language support";
    python = {
      enable = mkEnableOption "Python language support";

      versions = mkOption {
        type = types.listOf (types.enum supportedPythonVersions);
        default = [ "3.14" ];
        example = [
          "2.7"
          "3.10"
        ];
        description = ''
          					List of Python versions to support. This is used to determine which
          					Python interpreters and packages are installed/configured.
          			'';
      };

      debugPkgs = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          Derived list of Python debug-related packages for the configured versions.
          This is configured automatically by the versions option.
        '';
      };
    };
  };

  config.language_support =
    let
      ls = config.language_support;

      pythonInterp =
        version:
        {
          "2.7" = pkgs.python27;
          "3.10" = pkgs.python310;
          "3.14" = pkgs.python314;
          "3.15" = pkgs.python315;
        }
        .${version};

      pythonPkgsForVersion =
        version:
        let
          py_pkgs = pythonInterp version;
        in
        {
          debug = [
            py_pkgs
          ];
        };

      pythonAllVersions =
        if ls.python.enable then builtins.map pythonPkgsForVersion ls.python.versions else [ ];

      pythonDebugPkgs = lib.concatMap (p: p.debug) pythonAllVersions;
    in
    {
      python = {
        debugPkgs = pythonDebugPkgs;
      };
    };
}
