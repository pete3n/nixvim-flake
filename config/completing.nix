# All configuration related to completing code/text
{ config, lib, ... }:
{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand =
            # lua
            ''
              function(args) require('luasnip').lsp_expand(args.body) end
            '';
        };
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-y>" = "cmp.mapping (cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true }, {'i','c'})";
          "<C-e>" = "cmp.mapping.close()";
        };
        sources = [
          { name = "luasnip"; }
          { name = "nvim_lua"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        window.documentation.border = [
          "╭"
          "─"
          "╮"
          "│"
          "╯"
          "─"
          "╰"
          "│"
        ];
      };
      luaConfig.post =
        # lua
        ''
					if pcall(require, "vim-dadbod-completion") then
						-- Setup vim-dadbod
						cmp.setup.filetype({ "sql" }, {
							sources = {
								{ name = "vim-dadbod-completion" },
								{ name = "buffer" },
							},
						})
					end

					-- Extra options for cmp-cmdline setup
					cmp.setup.cmdline(":", {
						mapping = cmp.mapping.preset.cmdline(),
						sources = cmp.config.sources({
							{ name = "path" },
						}, {
							{
								name = "cmdline",
								option = {
									ignore_cmds = { "Man", "!" },
								},
							},
						}),
					})

					if pcall(require, "which-key") then
						local wk = require "which-key"

						wk.add ({
							{"<leader>c", group = "completing", icon = "󰈼", mode = { "n", "c", "i" }, },
							{"<leader>ck", icon = "󰞘 ", desc = "expand or jump to next snippet (^ K)", 
									mode = { "n", "c", "i", }, },
							{"<leader>cj", icon = "󰞗 ", desc = "jump back (^ J)", mode = { "n", "c", "i" }, },
							{"<leader>cn", icon = " ", desc = "next completion (^ N)", mode = { "n", "c", "i" }, },
							{"<leader>cp", icon = " ", desc = "prev completion (^ P)", mode = { "n", "c", "i" }, },
							{"<leader>cy", icon = "󰿄 ", desc = "confirm completion (^ Y)", mode = { "n", "c", "i" }, },
							{"<leader>ce", icon = "󰜺 ", desc = "close completions (^ E)", mode = { "n", "c", "i" }, },
							{"<C-K>", icon = "󰞘 ", desc = "expand or jump to next snippet", mode = { "c", "i" }, },
							{"<C-J>", icon = "󰞗 ", desc = "jump back", mode = { "c", "i" }, },
							{"<C-N>", icon = " ", desc = "next completion", mode = { "c", "i" }, },
							{"<C-P>", icon = " ", desc = "prev completion", mode = { "c", "i" }, },
							{"<C-Y>", icon = "󰿄 ", desc = "confirm completion ", mode = { "c", "i" }, },
							{"<C-E>", icon = "󰜺 ", desc = "close completions", mode = { "c", "i" }, },
						})
					end
        '';
    };

    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    cmp-ai.enable = false;
    luasnip.enable = true;
    friendly-snippets.enable = true;
    lspkind.enable = true;
    vim-dadbod-completion.enable = config.plugins.vim-dadbod.enable; # Dependency
  };

  keymaps = lib.concatLists [
    (
      if config.plugins.luasnip.enable then
        [
          {
            key = "<C-K>";
            mode = [
              "i"
              "s"
            ];
            action.__raw = # lua
              ''
                function() 
                	if require("luasnip").expand_or_jumpable() then 
                		require("luasnip").expand_or_jump() 
                	end
                end
              '';
            options = {
              desc = "expand or jump to next snippet";
              silent = true;
            };
          }
          {
            key = "<C-J>";
            mode = [
              "i"
              "s"
            ];
            action.__raw = # lua
              ''
                function() 
                	if require("luasnip").jumpable(-1) then 
                		require("luasnip").jump(-1) 
                	end
                end
              '';
            options = {
              desc = "jump back";
              silent = true;
            };
          }
        ]
      else
        [ ]
    )
  ];
}
