{ pkgs, ... }:
{
  imports = [
    ./treesitter.nix
    ./keymaps.nix
  ];

  extraPackages = with pkgs; [
    # Formatters
    nixfmt-rfc-style
    shfmt
    stylua
  ];

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

  # Basic Neovim options
  opts = {
    number = true;
    relativenumber = true;
  };
}
