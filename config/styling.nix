# All configuration related to styling
{ pkgs, ... }:
{
  extraPackages = with pkgs; [ jetbrains-mono ];

  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
      transparent = true;
    };
  };

  plugins = {

    notify = {
      enable = true;
      timeout = 5000;
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          icons_enabled = true;
          theme = "onedark";
          globalstatus = true;
        };
      };
    };

    noice = {
      enable = true;
      settings = {
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
      luaConfig.post =
        # lua
        ''
					local dismiss_noice = function()
							require("noice").cmd("dismiss")
					end

					local toggle_noice = function()
						local noice_paused = false
						if noice_paused then
							vim.notify("Resuming Noice notifications")
							require("noice").enable()
							noice_paused = false
							vim.notify("Noice resumed")
						else
							print("Pausing Noice notifications")
							require("noice").cmd("dismiss")
							noice_paused = true
							vim.notify("Noice paused")
						end
					end

					local redisplay_last_noice = function()
							vim.cmd("Noice last")
					end

					if pcall(require, "which-key") then
						local wk = require("which-key")
							wk.add({
							{ "<leader>e", group = "event notifications", icon = "󰍢 " },
							{ "<leader>ed", dismiss_noice, desc = "dismiss notification", 
								icon = "🔕", mode = { "n", "v", "o" }},
							{ "<leader>eh", "<cmd>NoiceHistory<CR>", desc = "notification history", 
								icon = "󰋚 ", mode = { "n", "v", "o" }},
							{ "<leader>em", "<cmd>messages<CR>", desc = "messages",
								icon = "󰵅 ", mode = { "n", "v", "o" }},
							{ "<leader>et", toggle_noice, desc = "toggle notifications", 
								icon = "󰔡 ", mode = "n" },
							{ "<leader>er", redisplay_last_noice, 
								desc = "re-display previous notification", icon = "🔔", 
								mode = { "n", "v", "o" }},
							})
						end

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
    };
  };
}
