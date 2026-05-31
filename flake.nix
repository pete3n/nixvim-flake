{
  description = "A cross-platform NixVim flake with package, dev-shell, and Docker image outputs";

  inputs = {
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixvim,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin" # Not tested on bare metal
      ];

      config = import ./config;

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      overlaysBySystem = forAllSystems (
        system:
        [
          (final: prev: {
            bashdb = prev.bashdb.overrideAttrs (oldAttrs: {
              meta = oldAttrs.meta // {
                platforms = final.lib.platforms.linux ++ final.lib.platforms.darwin;
              };
            });
          })

          (final: prev: {
            mbake = nixpkgs-unstable.legacyPackages.${system}.mbake;
          })

        ]
				# Fix for building rustfmt on Darwin
        ++ nixpkgs.lib.optional (system == "aarch64-darwin" || system == "x86_64-darwin") (
          final: prev: {
            rustfmt = prev.rustfmt.overrideAttrs (old: {
              RUSTFLAGS = "-C link-arg=-Wl,-headerpad_max_install_names";
            });
          }
        )
      );
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = overlaysBySystem.${system};
          };

          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = pkgs;
            module = config;
          };

          isLinux = pkgs.stdenv.isLinux;
        in
        {
          default = nvim;
        }
        // pkgs.lib.optionalAttrs isLinux {
          dockerImage = pkgs.dockerTools.buildImage {
            name = "nixvim-dev-container";
            tag = "v26.05";
            copyToRoot = pkgs.buildEnv {
              name = "nixvim-docker-root";
              paths = [
                nvim
                pkgs.git
                pkgs.curl
                pkgs.bashInteractive
              ];
            };
            config = {
              Cmd = [ "${nvim}/bin/nvim" ];
              Env = [
                "HOME=/root"
                "TERM=xterm-256color"
                "VIMRUNTIME=${nvim}/share/nvim/runtime"
              ];
            };
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = overlaysBySystem.${system};
          };
          nvim = self.packages.${system}.default;
          runtimePath = "${nvim}/share/nvim/runtime";
        in
        {
          default = pkgs.mkShell {
            name = "Nixvim 26.05 dev-shell";

            buildInputs = with pkgs; [
              lua-language-server
              luajitPackages.busted
              luajitPackages.luacheck
              mbake
              nil
              nvim
              stylua
            ];

            shellHook = ''
              echo "[devShell] Configuring Neovim dev environment"
              export VIMRUNTIME="${runtimePath}"
              export NVIM_RTP="${runtimePath}"
              export NVIM_PACKPATH="${runtimePath}"
              export LUA_PATH="./lua/?.lua;./lua/?/init.lua;./plugin/?.lua;./plugin/?/init.lua;$LUA_PATH"
              echo "[devShell] VIMRUNTIME=$VIMRUNTIME"
              echo "[devShell] LUA_PATH=$LUA_PATH"

              alias vim=nvim
            '';
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          nvim = self.packages.${system}.default;
          nixvimLib = nixvim.lib.${system};
        in
        {
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        }
      );

      formatter = forAllSystems (system: (import nixpkgs { inherit system; }).nixfmt);
    };
}
