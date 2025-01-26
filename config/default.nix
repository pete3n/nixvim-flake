{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    # Formatters
    nixfmt-rfc-style
    shfmt
    stylua
  ];

  colorschemes.gruvbox.enable = true;

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

    treesitter = {
      enable = true;

      settings = {
        # Disable automatic grammar installation
        auto_install = false;

        # Ensure specific parsers are installed
        ensure_installed = [
          "git_config"
          "git_rebase"
          "gitattributes"
          "gitcommit"
          "gitignore"
          "nix"
          "lua"
          "bash"
        ];

        # Enable highlighting
        highlight = {
          enable = true;
        };

        # Enable incremental selection
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };
      };

      luaConfig.post =
        # lua
        ''
          do
            local ts = require("vim.treesitter.language")
            ts.register("bash", "nix")
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
