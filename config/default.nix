{ pkgs, ... }:
{
  imports = [
    ./completing.nix
    ./folding.nix
    ./formatting.nix
    ./keymapping.nix
    ./parsing.nix
    ./styling.nix
  ];

  globals = {
    mapleader = " ";
  };

  opts = {
    number = true;
    colorcolumn = "80";
    relativenumber = true;
    shiftwidth = 2;
    tabstop = 2;
    wrap = false;
    swapfile = false; # Undotree
    backup = false; # Undotree
    undofile = true;
    hlsearch = false;
    incsearch = true;
    termguicolors = true;
    scrolloff = 8;
    signcolumn = "yes";
    updatetime = 50;
    foldlevelstart = 99;
  };

  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
      transparent = true;
    };
  };

  # Enable Treesitter for syntax highlighting
  plugins = {

    # Enable LSP support and configure nixd
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        bashls.enable = true;
        lua_ls.enable = true;
      };
    };
  };
}
