{ pkgs, ... }:
{
  imports = [
    ./completing.nix
    ./folding.nix
    ./keymapping.nix
    ./parsing.nix
    ./styling.nix
  ];

  extraPackages = with pkgs; [
    nixfmt-rfc-style
    shfmt
    stylua
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

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          bash = [ "shfmt" ];
        };
      };
      luaConfig.pre =
        # lua
        ''
          -- Formatting function for conform
          _G.format_with_conform = function()
          	local conform = require("conform")
          	conform.format({
          		lsp_fallback = true,
          		async = false,
          		timeout_ms = 2000,
          	})
          end
        '';
    };

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
