# Imports for all configuration files, top-level Neovim options and globals
{ ... }:
{
  imports = [
    ./modules/languages.nix
    ./completing.nix
    ./debugging.nix
    ./editing.nix
    ./folding.nix
    ./formatting.nix
    ./keymapping.nix
    ./linting.nix
    ./navigating.nix
    ./parsing.nix
    ./searching.nix
    ./interpreting.nix
    ./styling.nix
  ];

  language_support = {
    lua.enable = true;
    nix.enable = true;
    python = {
      enable = true;
      versions = [ "3.14" ];
    };

  };

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

  # Disable formatting on-save by default.
  extraConfigLua = # lua
    ''
      	vim.api.nvim_create_autocmd("VimEnter", {
      		callback = function()
      			vim.cmd("FormatDisable")
      		end,
      	})
    '';
}
