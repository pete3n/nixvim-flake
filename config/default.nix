{pkgs, ...}: {
  imports = [
    ./keymaps.nix
    ./style.nix
    ./telescope.nix
    ./treesitter.nix
    ./harpoon.nix
    ./folds.nix
    ./lsp.nix
    ./completion.nix
    ./format.nix
    ./lint.nix
  ];

  config = {
    globals = {
      mapleader = " ";
    };

    options = {
      number = true;
      colorcolumn = "80";
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      wrap = false;
      swapfile = false; #Undotree
      backup = false; #Undotree
      undofile = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      foldlevelstart = 99;
    };

    plugins = {
      gitsigns.enable = true;
      oil.enable = true;
      undotree.enable = true;
      fugitive.enable = true;
      nvim-tree.enable = true;
    };
  };
}
