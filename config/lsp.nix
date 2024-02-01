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
        installCargo = false;
        installRustc = false;
      };
      tsserver.enable = true;
      yamlls.enable = true;
      zls.enable = true;
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
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
     			key = "<leader>dn",
     			action = vim.diagnostic.goto_next,
     			options = {
     				buffer = 0,
     				desc = "Go to [n]ext [d]iagnostic with LSP",
     			},
     		},
     		{
     			key = "<leader>dp",
     			action = vim.diagnostic.goto_prev,
     			options = {
     				buffer = 0,
     				desc = "Go to [p]revious [d]iagnostic with LSP",
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

     local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
    local util = require("lspconfig")
     capabilities.textDocument.completion.completionItem.snippetSupport = true

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
    capabilities = capabilities,
    filetypes = {"rust"},
    root_dir = util.root_pattern("Cargo.toml"),
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
