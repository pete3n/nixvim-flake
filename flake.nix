{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, nixvim, flake-parts, ... } @ inputs: let
    config = import ./config; # import the module directly

    # Define the custom Neovim wrapper
    customNeovimWrapper = { pkgs, ... }: let
      neovimDeps = with pkgs; [
        alejandra asmfmt astyle black cmake-format gofumpt golines gotools isort 
        nodePackages.prettier prettierd shfmt stylua commitlint eslint_d hadolint 
        html-tidy luajitPackages.luacheck nodePackages.jsonlint pylint ruff 
        shellcheck vale yamllint tmux-sessionizer asm-lsp cargo clang-tools go rustc
      ];
    depsPath = builtins.concatStringsSep ":" (map (dep: "${dep}/bin") neovimDeps);
    in pkgs.writeShellScriptBin "neovim-with-deps" ''
        export PATH=${depsPath}:"$PATH"
        exec ${pkgs.neovim}/bin/nvim "$@"
    '';
    in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, system, ... }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};

        # Use the custom Neovim wrapper
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = config;
        };
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };

        packages = {
          # Provide the custom Neovim wrapper as a package
          default = customNeovimWrapper { pkgs = pkgs; };
        };
      };
    };
}

