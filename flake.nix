{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-parts,
    ...
  } @ inputs: let
    config = import ./config; # import the module directly
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
          inherit pkgs;
          module = config;
        };
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };

        packages = {
          default = nvim;
        };

        devShells.default = pkgs.mkShellNoCC {
          shellHook = ''
            echo Entering Nixvim dev environment
            PS1="Nixvim: \\w \$ "
          '';
          packages = with pkgs; [
            nvim
            alejandra
            asmfmt
            astyle
            black
            cmake-format
            gofumpt
            golines
            gotools
            isort
            nodePackages.prettier
            prettierd
            shfmt
            stylua
            commitlint
            eslint_d
            hadolint
            html-tidy
            luajitPackages.luacheck
            nodePackages.jsonlint
            pylint
            ruff
            shellcheck
            vale
            yamllint
            tmux-sessionizer
            asm-lsp
            cargo
            clang-tools
            fd
            ripgrep
            go
            rustc
          ];
        };
      };
    };
}
