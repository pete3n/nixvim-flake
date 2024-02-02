{pkgs, ...}: {
  plugins.lsp = {
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
        installCargo = true;
        installRustc = true;
      };
      tsserver.enable = true;
      yamlls.enable = true;
      zls.enable = true;
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    typescript-tools-nvim
  ];
  extraConfigLua = ''
      -- Extra nvim-lspconfig configuration

      -- Common LSP key mappings
      local function set_cmn_lsp_keybinds()
      	local lsp_keybinds = {
      		{
      			key = "K",
      			action = vim.lsp.buf.hover,
      			options = {
      				buffer = 0,
      				desc = "hover [K]noledge with LSP",
      			},
      		},
      		{
      			key = "gd",
      			action = vim.lsp.buf.definition,
      			options = {
      				buffer = 0,
      				desc = "[g]o to [d]efinition with LSP",
      			},
      		},
      		{
      			key = "gt",
      			action = vim.lsp.buf.type_definition,
      			options = {
      				buffer = 0,
      				desc = "[g]o to [t]ype definition with LSP",
      			},
      		},
      		{
      			key = "gi",
      			action = vim.lsp.buf.implementation,
      			options = {
      				buffer = 0,
      				desc = "[g]o to [i]mplementation with LSP",
      			},
      		},
      		{
      			key = "<leader>dj",
      			action = vim.diagnostic.goto_next,
      			options = {
      				buffer = 0,
      				desc = "Go to next [d]iagnostic with LSP",
      			},
      		},
      		{
      			key = "<leader>dk",
      			action = vim.diagnostic.goto_prev,
      			options = {
      				buffer = 0,
      				desc = "Go to previous [d]iagnostic with LSP",
      			},
      		},
      		{
      			key = "<leader>r",
      			action = vim.lsp.buf.rename,
      			options = {
      				buffer = 0,
      				desc = "[r]ename variable with LSP",
      			},
      		},
      	}

      	for _, bind in ipairs(lsp_keybinds) do
      		vim.keymap.set("n", bind.key, bind.action, bind.options)
      	end
      end

     -- Additional lsp-config
     local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
     capabilities.textDocument.completion.completionItem.snippetSupport = true

     -- Individual LSP configs
      -- asm LSP
      require("lspconfig").asm_lsp.setup({
      	capabilities = capabilities,
      	filetypes = { "asm" },

      	-- Fix for missing root dir
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
      require("lspconfig").html.setup({
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
      })

      -- Prisma LSP
      require("lspconfig").prismals.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Python LSP
      require("lspconfig").ruff_lsp.setup({
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Rust LSP
     require("lspconfig").rust_analyzer.setup({
         root_dir = function(fname)
                 return vim.loop.cwd()
         end,
         settings = {
             ['rust-analyzer'] = {
                 cargo = {
                     allFeatures = true,
                 },
             },
         },
      	on_attach = function()
      		set_cmn_lsp_keybinds()
      	end,
      })

      -- Typescript/Javascript LSP
      require("lspconfig").tsserver.setup({
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
