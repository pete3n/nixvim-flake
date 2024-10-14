{ ... }:
{
  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
      transparent = true;
    };
  };
  plugins = {
    notify.enable = true;
    lualine = {
      enable = true;
      iconsEnabled = false;
      globalstatus = true;
      theme = "onedark";
    };
    noice = {
      enable = true;
      presets = {
        bottom_search = true;
      };
      cmdline.format = {
        cmdline = {
          icon = ">";
        };
        search_down = {
          icon = "🔍⌄";
        };
        search_up = {
          icon = "🔍⌃";
        };
        filter = {
          icon = "$";
        };
        lua = {
          icon = "☾";
        };
        help = {
          icon = "?";
        };
      };
      format = {
        level = {
          icons = {
            error = "✖";
            warn = "▼";
            info = "●";
          };
        };
      };
      popupmenu = {
        kindIcons = false;
      };
      extraOptions = {
        inc_rename.cmdline.format.IncRename = {
          icon = "⟳";
        };
      };
    };
  };
  extraConfigLua =
    # lua
    ''
      			-- Noice recommended config
      			require("noice").setup({
      				lsp = {
      					override = {
      						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      						["vim.lsp.util.stylize_markdown"] = true,
      						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      					},
      				},
      			})
      			-- Show @recording in the statusline
      			-- see: https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
            require("lualine").setup({
              sections = {
                lualine_x = {
                  {
                    require("noice").api.statusline.mode.get,
                    cond = require("noice").api.statusline.mode.has,
                    color = { fg = "#ff9e64" },
                  }
                },
              },
            })
    '';
}
