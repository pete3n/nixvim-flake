{
  pkgs,
  lib,
  ...
}: {
  environment.packages = with pkgs; [
    # Formatters
    alejandra
    asmfmt
    astyle
    black
    cmake-format
    gofumpt
    golines
    gotools
    isort
    nodePackages.prettier
    prettierd
    shfmt
    stylua
    # Linters
    commitlint
    eslint_d
    hadolint
    html-tidy
    luajitPackages.luacheck
    nodePackages.jsonlint
    pylint
    ruff
    shellcheck
    vale
    yamllint

    # Lang tools/compilers
    tmux-sessionizer
    asm-lsp
    cargo
    clang-tools
    go
    rustc
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

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

    colorschemes.tokyonight = {
      enable = true;
      style = "night";
      transparent = true;
    };

    keymaps = [
      {
        key = "<leader>pv";
        mode = "n";
        action = "<cmd>Oil<CR>";
        options = {
          desc = "[p]rimeagen [v]im remap";
        };
      }
      {
        key = "<leader>u";
        mode = "n";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          desc = "[u]ndotree toggle";
        };
      }
      {
        key = "<leader>gs";
        mode = "n";
        action = "<cmd>Git<CR>";
        options = {
          desc = "[g]it [s]tatus";
        };
      }
      {
        key = "<C-y>";
        mode = "n";
        action = ":set cursorcolumn!<CR>";
        options = {
          silent = true;
          desc = "Toggle vertical column because [Y]AML sucks";
        };
      }
      {
        key = "J";
        mode = "v";
        action = ":m '>+1<CR>gv=gv";
        options = {
          silent = true;
          desc = "Shift line down 1 in visual mode";
        };
      }
      {
        key = "K";
        mode = "v";
        action = ":m '>-2<CR>gv=gv";
        options = {
          silent = true;
          desc = "Shift line up 1 in visual mode";
        };
      }
      {
        mode = "n";
        key = "J";
        action = "mzJ\`z"; # Keep cursor to the left
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz"; # Keep cursor in middle
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz"; # Keep cursor in middle
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv"; # Keep cursor in middle
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options = {
          silent = true;
        };
      }
      {
        mode = "x";
        key = "<leader>p";
        action = "\"_dP";
        options = {
          silent = true;
          desc = "[p]reserve put";
        };
      }
      {
        mode = ["n" "v"];
        key = "<leader>y";
        action = "\"+y";
        options = {
          silent = true;
          desc = "[y]ank to system clipboard";
        };
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = "\"+Y";
        options = {
          silent = true;
          desc = "[Y]ank line to system clipboard";
        };
      }
      {
        mode = "n";
        key = "Q";
        action = "<nop>";
        options = {
          desc = "Don't";
        };
      }
      {
        mode = "n";
        key = "<C-f>";
        action = "<cmd>!tmux neww tmux-sessionizer<CR>";
        options = {
          silent = true;
          desc = "[f]ind and switch tmux session";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>cnext<CR>zz";
        options = {
          silent = true;
          desc = "Next quickfix";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>cprev<CR>zz";
        options = {
          silent = true;
          desc = "Prev quickfix";
        };
      }
      {
        mode = "n";
        key = "<leader>k";
        action = "<cmd>lnext<CR>zz";
        options = {
          silent = true;
          desc = "Next quickfix location";
        };
      }
      {
        mode = "n";
        key = "<leader>j";
        action = "<cmd>lprev<CR>zz";
        options = {
          silent = true;
          desc = "Prev quickfix location";
        };
      }
      {
        key = "<leader>mp";
        mode = ["n" "v"];
        action = ":lua _G.format_with_conform()<CR>";
        options = {
          silent = true;
          desc = "[m]ake [p]retty by formatting";
        };
      }
      {
        key = "<leader>da";
        mode = ["n"];
        action = ":lua vim.lsp.buf.code_action()<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[d]iagnostic changes [a]ccepted";
        };
      }
    ];

    plugins = {
      lualine = {
        enable = true;
        iconsEnabled = false;
        globalstatus = true;
        theme = "onedark";
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>?" = {
            action = "oldfiles";
            desc = "[?] Find recently opened files";
          };
          "<leader><space>" = {
            action = "buffers";
            desc = "[ ] Find existing buffers";
          };
          "<leader>/" = {
            action = "current_buffer_fuzzy_find";
            desc = "[/] Fuzzily search in current buffer]";
          };
          "<leader>sf" = {
            action = "find_files";
            desc = "[s]earch [f]iles";
          };
          "<leader>sh" = {
            action = "help_tags";
            desc = "[s]earch [h]elp";
          };
          "<leader>sw" = {
            action = "grep_string";
            desc = "[s]earch current [w]ord";
          };
          "<leader>sg" = {
            action = "live_grep";
            desc = "[s]earch by [g]rep";
          };
          "<leader>sd" = {
            action = "diagnostics";
            desc = "[s]earch [d]iagnotics";
          };
          "<leader>sk" = {
            action = "keymaps";
            desc = "[s]earch [k]eymaps";
          };
        };
      };

      treesitter = {
        enable = true;
        indent = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<C-space>";
            nodeIncremental = "<C-space>";
            nodeDecremental = "<bs>";
          };
        };
      };

      treesitter-textobjects = {
        enable = true;
        extraOptions = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "a=" = {
                query = "@assignment.outer";
                desc = "Select [a]round outer part of an [=] assignment";
              };
              "i=" = {
                query = "@assignment.inner";
                desc = "Select [i]nner part of an [=] assignment";
              };
              "l=" = {
                query = "@assignment.lhs";
                desc = "Select [l]eft hand side of an [=] assignment";
              };
              "r=" = {
                query = "@assignment.rhs";
                desc = "Select [r]ight hand side of an [=] assignment";
              };
              "aa" = {
                query = "@parameter.outer";
                desc = "Select [a]round the outer part of a p[a]rameter";
              };
              "ia" = {
                query = "@parameter.inner";
                desc = "Select the [i]nner part of a p[a]rameter";
              };
              "ai" = {
                query = "@conditional.outer";
                desc = "Select [a]round the outer part of a cond[i]tional";
              };
              "ii" = {
                query = "@conditional.inner";
                desc = "Select the [i]nner part of a cond[i]tional";
              };
              "al" = {
                query = "@loop.outer";
                desc = "Select [a]round the outer part of a [l]oop";
              };
              "il" = {
                query = "@loop.inner";
                desc = "Select the [i]nner part of a [l]oop";
              };
              "af" = {
                query = "@call.outer";
                desc = "Select [a]round the outer part of a function call";
              };
              "if" = {
                query = "@call.inner";
                desc = "Select the [i]nner part of a function call";
              };
              "am" = {
                query = "@function.outer";
                desc = "Select [a]round the outer part of [m]ethod or function";
              };
              "im" = {
                query = "@function.inner";
                desc = "Select the [i]nner part of a [m]ethod or function";
              };
              "ac" = {
                query = "@class.outer";
                desc = "Select [a]round the outer part of a [c]lass";
              };
              "ic" = {
                query = "@class.inner";
                desc = "Select the [i]nner part of a [c]lass";
              };
            };
          };

          swap = {
            enable = true;
            swap_next = {
              "<leader>na" = "@parameter.inner";
              "<leader>nm" = "@function.outer";
            };
            swap_previous = {
              "<leader>pa" = "@parameter.inner";
              "<leader>pm" = "@parameter.outer";
            };
          };

          move = {
            enable = true;
            set_jumps = true;
            goto_next_start = {
              "]f" = {
                query = "@call.outer";
                desc = "Next [f]unction call start";
              };
              "]m" = {
                query = "@function.outer";
                desc = "Next [m]ethod or function def start";
              };
              "]c" = {
                query = "@class.outer";
                desc = "Next [c]lass start";
              };
              "]i" = {
                query = "@conditional.outer";
                desc = "Next cond[i]tional start";
              };
              "]l" = {
                query = "@loop.outer";
                desc = "Next [l]oop start";
              };
              "]s" = {
                query = "@scope";
                query_group = "locals";
                desc = "Next [s]cope";
              };
              "]z" = {
                query = "@fold";
                query_group = "folds";
                desc = "Next [f]old";
              };
            };

            goto_previous_start = {
              "[f" = {
                query = "@call.outer";
                desc = "Prev [f]unction call start";
              };
              "[m" = {
                query = "@function.outer";
                desc = "Prev [m]ethod or function def start";
              };
              "[c" = {
                query = "@class.outer";
                desc = "Prev [c]lass start";
              };
              "[i" = {
                query = "@conditional.outer";
                desc = "Prev cond[i]tional start";
              };
              "[l" = {
                query = "@loop.outer";
                desc = "Prev [l]oop start";
              };
            };

            goto_next_end = {
              "]F" = {
                query = "@call.outer";
                desc = "Next [f]unction call end";
              };
              "]M" = {
                query = "@function.outer";
                desc = "Next [m]ethod or function def end";
              };
              "]C" = {
                query = "@class.outer";
                desc = "Next [c]lass end";
              };
              "]I" = {
                query = "@conditional.outer";
                desc = "Next cond[i]tional end";
              };
              "]L" = {
                query = "@loop.outer";
                desc = "Next [l]oop end";
              };
            };

            goto_previous_end = {
              "[F" = {
                query = "@call.outer";
                desc = "Prev [f]unction call end";
              };
              "[M" = {
                query = "@function.outer";
                desc = "Prev [m]ethod or function def end";
              };
              "[C" = {
                query = "@class.outer";
                desc = "Prev [c]lass end";
              };
              "[I" = {
                query = "@conditional.outer";
                desc = "Prev cond[i]tional end";
              };
              "[L" = {
                query = "@loop.outer";
                desc = "Prev [l]oop end";
              };
            };
          };
        };
      };

      noice = {
        enable = true;
        presets = {
          bottom_search = true;
        };
      };
      notify.enable = true;
      gitsigns.enable = true;
      harpoon.enable = true; # The name, is the harpoon-maker-agen
      oil.enable = true;
      undotree.enable = true;
      fugitive.enable = true;
      nvim-tree.enable = true;
      nvim-ufo = {
        enable = true;
        providerSelector = ''
          function(bufnr, filetype, buftype)
           			return { 'lsp', 'indent' }
           		end
        '';
      };

      lsp = {
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          cssls.enable = true;
          gopls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          prismals.enable = true;
          ruff-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          tsserver.enable = true;
          yamlls.enable = true;
          zls.enable = true;
        };
      };

      # LSP autocompletion
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-space>" = "cmp.mapping.complete()";
          "<C-y>" = {
            action = "cmp.mapping.confirm({
							select = true, behavior = cmp.ConfirmBehavior.Insert })";
          };
        };
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
        sources = [
          {name = "nvim_lua";}
          {name = "nvim_lsp";}
          {name = "cmdline";}
          {name = "path";}
          {name = "luasnip";}
          {name = "buffer";}
        ];
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-cmdline.enable = true;
      cmp-path.enable = true;
      luasnip.enable = true;

      # Formatters
      conform-nvim = {
        enable = true;
        formattersByFt = {
          asm = ["asmfmt"];
          c = ["astyle"];
          cpp = ["astyle"];
          css = ["prettierd" "prettier"];
          cmake = ["cmake_format"];
          go = ["goimports" "gofumpt" "golines"];
          html = ["prettierd" "prettier"];
          javascript = ["prettierd" "prettier"];
          javascriptreact = ["prettier"];
          json = ["prettier"];
          lua = ["stylua"];
          markdown = ["prettier"];
          nix = ["alejandra"];
          python = ["isort" "black"];
          sh = ["shfmt"];
          typescript = ["prettierd" "prettier"];
          typescriptreact = ["prettier"];
          yaml = ["prettierd" "prettier"];
        };
        formatters = {
          asmfmt = {
            command = "asmfmt";
            stdin = true;
          };
        };
        formatOnSave = {
          lspFallback = true;
          timeoutMs = 2000;
        };
      };

      # Linters
      lint = {
        enable = true;
        lintersByFt = {
          c = ["clangtidy"];
          cpp = ["clangtidy"];
          gitcommit = ["commitlint"];
          javascript = ["eslint_d"];
          javascriptreact = ["eslint_d"];
          json = ["jsonlint"];
          lua = ["luacheck"];
          nix = ["nix"];
          python = ["ruff"];
          sh = ["shellcheck"];
          typescript = ["eslint_d"];
          typescriptreact = ["eslint_d"];
          yaml = ["yamllint"];
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];

    extraConfigLuaPre = ''
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

    extraConfigLua = ''
      -- Primeagen Harpoon config
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
      vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)


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

             -- Configuration for UFO folds
             require('ufo').setup({
             	provider_selector = function(bufnr, filetype, buftype)
             		return { 'lsp', 'indent' }
             	end
             })
             vim.keymap.set('n', 'zK', function()
             	local winid = require('ufo').peekFoldedLinesUnderCursor()
             	if not winid then
             		vim.lsp.buf.hover()
             	end
             end, { desc = "Pee[k] fold" })

                -- Linting function
             local lint = require("lint")
             local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

             vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
             	group = lint_augroup,
             	callback = function()
             		lint.try_lint()
             	end,
             })

             vim.keymap.set("n", "<leader>l", function()
             	lint.try_lint()
             end, { desc = "Trigger linting for current file" })

             -- Extra options for cmp-cmdline setup
             local cmp = require('cmp')
             cmp.setup.cmdline(':', {
             	mapping = cmp.mapping.preset.cmdline(),
             	sources = cmp.config.sources({
             		{ name = 'path' }
             	}, {
             		{
             			name = 'cmdline',
             			option = {
             				ignore_cmds = { 'Man', '!' }
             			}
             		}
             	})
             })

             -- Extra nvim-lspconfig configuration

             -- Common LSP key mappings
             local function set_cmn_lsp_keybinds()
             	local lsp_keybinds = {
             		{ key = "K", action = vim.lsp.buf.hover, options = {
             			buffer = 0, desc = "hover [K]noledge with LSP" }
             		},
             		{ key = "gd", action = vim.lsp.buf.definition, options = {
             			buffer = 0, desc = "[g]o to [d]efinition with LSP" }
             		},
             		{ key = "gt", action = vim.lsp.buf.type_definition, options = {
             			buffer = 0, desc = "[g]o to [t]ype definition with LSP" }
             		},
             		{ key = "gi", action = vim.lsp.buf.implementation, options = {
             			buffer = 0, desc = "[g]o to [i]mplementation with LSP" }
             		},
             		{ key = "<leader>dn", action = vim.diagnostic.goto_next, options = {
             			buffer = 0, desc = "Go to [n]ext [d]iagnostic with LSP" }
             		},
             		{ key = "<leader>dp", action = vim.diagnostic.goto_prev, options = {
             			buffer = 0, desc = "Go to [p]revious [d]iagnostic with LSP" }
             		},
             		{ key = "<leader>r", action = vim.lsp.buf.rename, options = {
             			buffer = 0, desc = "[r]ename variable with LSP" }
             		},
             	}

             	for _, bind in ipairs(lsp_keybinds) do
             			vim.keymap.set("n", bind.key, bind.action, bind.options)
             	end
             end

             local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

             capabilities.textDocument.completion.completionItem.snippetSupport = true

             -- asm LSP
             require'lspconfig'.asm_lsp.setup{
             	capabilities = capabilities,
             	filetypes = { 'asm' };

             	-- Fix for missing root dir
             	root_dir = function(fname)
             		return vim.loop.cwd()
             	end,
             	on_attach = function()
             		set_cmn_lsp_keybinds()
             	end,
             }

             -- Bash LSP
             require'lspconfig'.bashls.setup{
             	on_attach = function()
             		set_cmn_lsp_keybinds()
             	end,
             }

             -- clang LSP
             require'lspconfig'.clangd.setup{
             	on_attach = function()
             		set_cmn_lsp_keybinds()
             	end,
             }

             -- cmake LSP
             require'lspconfig'.cmake.setup{
             	on_attach = function()
             		set_cmn_lsp_keybinds()
             	end,
             }

             -- CSS LSP
             require'lspconfig'.cssls.setup{
             	on_attach = function()
             		set_cmn_lsp_keybinds()
             	end,
             }

             -- golang lsp
             require'lspconfig'.gopls.setup{
             	on_attach = function()
             		set_cmn_lsp_keybinds()
             	end,
              }

                -- HTML lsp
                require'lspconfig'.html.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
             }

                -- JSON lsp
                require'lspconfig'.jsonls.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                	 }

                	 -- Lua LSP
                	 require'lspconfig'.lua_ls.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }

                	 -- Nix LSP
                	 require'lspconfig'.nixd.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }

                -- Prisma LSP
                require'lspconfig'.prismals.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }

                -- Python LSP
                require'lspconfig'.ruff_lsp.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }

                -- Rust LSP
                require'lspconfig'.rust_analyzer.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }

                -- Typescript/Javascript LSP
                require'lspconfig'.tsserver.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }

                -- YAML LSP
                require'lspconfig'.yamlls.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }
                -- Zig LSP
                require'lspconfig'.zls.setup{
                	on_attach = function()
                		set_cmn_lsp_keybinds()
                	end,
                }
    '';
  };
}
