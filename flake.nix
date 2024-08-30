{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-parts,
    ...
  } @ inputs: let
    config = import ./config;
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

        asmLspOverlay = final: prev: {
          asm-lsp = prev.asm-lsp.overrideAttrs (oldAttrs: rec {
            nativeBuildInputs =
              oldAttrs.nativeBuildInputs
              ++ final.lib.optionals final.stdenv.isDarwin [
                final.darwin.apple.sdk.frameworks.CoreFoundation
                final.darwin.apple.sdk.frameworks.CoreServices
                final.darwin.apple.sdk.frameworks.SystemConfiguration
              ];

            platforms = final.lib.platforms.linux ++ final.lib.platforms.darwin;
          });
        };

        pkgsWithOverlay = import nixpkgs {
          inherit system;
          overlays = [asmLspOverlay];
        };
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNvim {
            inherit nvim;
            name = "A nixvim configuration";
          };
        };

        packages = with pkgsWithOverlay; {
          default = nvim;
        };

        devShells.default = pkgs.mkShellNoCC {
          shellHook = ''
            echo Welcome to a Neovim dev environment powered by Nixvim -- https://github.com/nix-community/nixvim
            PS1="Nixvim: \\w \$ "
            alias vim='nvim'
          '';
          packages = with pkgsWithOverlay; [
            nvim
          ];
        };
      };
    };
}
