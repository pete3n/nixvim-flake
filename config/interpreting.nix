# All configuration related to LSPs
{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    asm-lsp
    bash-language-server
		cargo
    cmake-language-server
    go
    gopls
    lua-language-server
    marksman
    nixd
    nodePackages."@prisma/language-server"
    python312Packages.python-lsp-server
    ruff
    rust-analyzer
		rustc
    superhtml
    typescript
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
    zig
    zls
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    typescript-tools-nvim
		webapi-vim
  ];

	plugins.rustaceanvim = {
		enable = true;
		settings.server = {
			default_settings = {
				rust-analyzer = {
					cargo = {
						buildScripts.enable = true;
						features = "all";
					};

					diagnostics = {
						enable = true;
						styleLints.enable = true;
					};

					checkOnSave = true;
					check = {
						command = "clippy";
						features = "all";
					};

					files = {
						excludeDirs = [
							".cargo"
							".direnv"
							".git"
							"node_modules"
							"target"
						];
					};

					inlayHints = {
						bindingModeHints.enable = true;
						closureStyle = "rust_analyzer";
						closureReturnTypeHints.enable = "always";
						discriminantHints.enable = "always";
						expressionAdjustmentHints.enable = "always";
						implicitDrops.enable = true;
						lifetimeElisionHints.enable = "always";
						rangeExclusiveHints.enable = true;
					};

					procMacro = {
						enable = true;
					};

					rustc.source = "discover";
				};
			};
		};
	};
  plugins.lsp = {
    servers = {
      # TODO: Fix this https://github.com/bergercookie/asm-lsp/issues/193
      asm_lsp.enable = true;
      bashls.enable = true;
      clangd.enable = true;
      cmake.enable = true;
      cssls.enable = true;
      eslint.enable = true;
      gopls.enable = true;
      jsonls.enable = true;
      lua_ls.enable = true;
      nixd.enable = true;
      prismals = {
        enable = true;
        package = pkgs.nodePackages."@prisma/language-server";
      };
      pylsp = {
        enable = true;
        package = pkgs.python312Packages.python-lsp-server;
      };
      ruff.enable = true;
			#rust_analyzer = {
      #  enable = true;
      #  installCargo = true;
      #  installRustc = true;
      #};
      superhtml.enable = true;
      ts_ls.enable = true;
      yamlls.enable = true;
      zls.enable = true;
    };
  };

  extraConfigLuaPost =
    # lua
    ''
      -- Common LSP key mappings
      -- Extra nvim-lspconfig configuration
      local function set_cmn_lsp_keybinds()
      	local lsp_keybinds = {
					{
						key = "<leader>ia",
						action = vim.lsp.buf.code_action,
						options = {
							buffer = 0,
							desc = "code action",
						},
					},
      		{
      			key = "<leader>ii",
      			action = vim.lsp.buf.hover,
      			options = {
      				buffer = 0,
      				desc = "hover token info <S-K>",
      			},
      		},
      		{
      			key = "<leader>ij",
      			action = vim.diagnostic.goto_prev,
      			options = {
      				buffer = 0,
      				desc = "go to previous diagnostic",
      			},
      		},
					{
						key = "<leader>ik",
						action = vim.diagnostic.goto_next,
						options = {
							buffer = 0,
							desc = "go to next diagnostic",
						},
					},
					{
						key = "<leader>iq",
						action = vim.diagnostic.setqflist,
						options = {
							buffer = 0,
							desc = "diagnostics quickfix list",
						},
					},
					{
						key = "<leader>ir",
						action = vim.lsp.buf.rename,
						options = {
							buffer = 0,
							desc = "rename variable <S-R>",
						},
					},
      		{
      			key = "<leader>r",
      			action = vim.lsp.buf.rename,
      			options = {
      				buffer = 0,
      				desc = "rename variable",
      			},
      		},
      		{
      			key = "gd",
      			action = vim.lsp.buf.definition,
      			options = {
      				buffer = 0,
      				desc = "go to to definition",
      			},
      		},
      		{
      			key = "gi",
      			action = vim.lsp.buf.implementation,
      			options = {
      				buffer = 0,
      				desc = "go to implementation",
      			},
      		},
      		{
      			key = "gy",
      			action = vim.lsp.buf.type_definition,
      			options = {
      				buffer = 0,
      				desc = "go to type definition",
      			},
      		}
      	}

      	for _, bind in ipairs(lsp_keybinds) do
      		vim.keymap.set("n", bind.key, bind.action, bind.options)
      	end
      end

      if pcall(require, "which-key") then
      	local wk = require("which-key")
      	wk.add ({
      		{"<leader>i", group = "interpreting", icon = " "},
      		{"<leader>ia", icon = " ", desc = "accept code action", },
      		{"<leader>ik", icon = "󰮰 ", desc = "goto next diagnostic", },
      		{"<leader>ij", icon = "󰮰 ", desc = "goto prev diagnostic", },
      		{"<leader>iq", icon = "󰑮 ", desc = "populate quickfix list", },
      		{"<leader>ir", icon = "󰑕 ", desc = "rename variable <S-R>", },
      		{"<leader>ig", group = "goto", icon = " "},
      		{"<leader>igd", "gd", desc = "goto definition (gd)" };
      		{"<leader>igy", "gy", desc = "goto type definition (gy)" };
      		{"<leader>igi", "gi", desc = "goto implementation (gi)" };
      	})
      end
      	
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Individual LSP configs
      -- asm LSP
      require("lspconfig").asm_lsp.setup({
      capabilities = capabilities,
      filetypes = { "asm" },

      -- Fix for missing root dir
      -- Always assume PWD is project root
      root_dir = function(fname)
      	return vim.loop.cwd()
      end,
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Bash LSP
      require("lspconfig").bashls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- clang LSP
      require("lspconfig").clangd.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- cmake LSP
      require("lspconfig").cmake.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- CSS LSP
      require("lspconfig").cssls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- golang lsp
      require("lspconfig").gopls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- HTML lsp
      require("lspconfig").superhtml.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- JSON lsp
      require("lspconfig").jsonls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Lua LSP
      require("lspconfig").lua_ls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Markdown LSP
      require("lspconfig").marksman.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Nix LSP
      require("lspconfig").nixd.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      settings = {
      	nixd = {
      		formatting = {
      			command = { "nixfmt" },
      		},
      	},
      },
      })

      -- Prisma LSP
      require("lspconfig").prismals.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Ruff
      require("lspconfig").ruff.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Python LSP
      require("lspconfig").pylsp.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      -- Rust LSP
      --require("lspconfig").rust_analyzer.setup({
      --root_dir = function(fname)
      --	return vim.loop.cwd()
      --end,
      --settings = {
      --	['rust_analyzer'] = {
      --		cargo = {
      --			allFeatures = true,
      --		},
      --	},
      --},
      --on_attach = function()
      --	set_cmn_lsp_keybinds()
      --end,
      --})

      -- Typescript/Javascript LSP
      require("lspconfig").ts_ls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })

      require("typescript-tools").setup {
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      settings = {
      	-- spawn additional tsserver instance to calculate diagnostics on it
      	separate_diagnostic_server = true,
      	-- "change"|"insert_leave" determine when the client asks the server about diagnostic
      	publish_diagnostic_on = "insert_leave",
      	-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
      	-- "remove_unused_imports"|"organize_imports") -- or string "all"
      	-- to include all supported code actions
      	-- specify commands exposed as code_actions
      	expose_as_code_action = {},
      	-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      	-- not exists then standard path resolution strategy is applied
      	tsserver_path = nil,
      	-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      	-- (see 💅 `styled-components` support section)
      	tsserver_plugins = {},
      	-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      	-- memory limit in megabytes or "auto"(basically no limit)
      	tsserver_max_memory = "auto",
      	-- described below
      	tsserver_format_options = {},
      	tsserver_file_preferences = {},
      	-- locale of all tsserver messages, supported locales you can find here:
      	-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      	tsserver_locale = "en",
      	-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      	complete_function_calls = false,
      	include_completions_with_insert_text = true,
      	-- CodeLens
      	-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      	-- possible values: ("off"|"all"|"implementations_only"|"references_only")
      	code_lens = "off",
      	-- by default code lenses are displayed on all referencable values and for some of you it can
      	-- be too much this option reduce count of them by removing member references from lenses
      	disable_member_code_lens = true,
      	-- JSXCloseTag
      	-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
      	-- that maybe have a conflict if enable this feature. )
      	jsx_close_tag = {
      		enable = false,
      		filetypes = { "javascriptreact", "typescriptreact" },
      	}
      },
      }

      -- YAML LSP
      require("lspconfig").yamlls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })
      -- Zig LSP
      require("lspconfig").zls.setup({
      on_attach = function()
      	set_cmn_lsp_keybinds()
      end,
      })
    '';
}
