/*
  	All configuration related to top-level keymapping
   	Function specific keymapping (completing, debugging, etc.)
   	is found in the associated configuration files
*/

{ config, lib, ... }:
# All conditional options for conditional keymaps are defined here.
let
  global_km = # lua
    ''
			local km = Snacks.keymap.set
			km({ "i", "c", "x" }, "<C-_>", function()
				require("which-key").show()
			end, { desc = "Open Key Hints", silent = true })

			km({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'",
				{ desc = "Down", expr = true, silent = true })
			km({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'",
				{ desc = "Down", expr = true, silent = true })
			km({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
			km({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

			km({ "n" }, "<leader><Tab><Tab>", ":tabnew<CR>", { desc = "New Tab" })
			km({ "n" }, "<leader><Tab>d", ":tabclose<CR>", { desc = "Close Tab" })
			km({ "n" }, "<leader><Tab>]", ":tabnext<CR>", { desc = "Next Tab" })
			km({ "n" }, "<leader><Tab>[", ":tabprevious<CR>", { desc = "Previous Tab" })
			km({ "n" }, "<leader><Tab>l", ":tablast<CR>", { desc = "Last Tab" })
			km({ "n" }, "<leader><Tab>f", ":tabfirst<CR>", { desc = "First Tab" })
			km({ "n" }, "<leader><Tab>o", ":tabonly<CR>", { desc = "Close Other Tabs" })

			km({ "n", "v" }, "<leader>y", "\"+y", { desc = "Yank to System Clipboard" })
			km({ "v" }, "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down" })
			km({ "v" }, "K", ":m '>-2<CR>gv=gv", { desc = "Move Line Up" })
			km({ "n" }, "J", "mzJ\`z", { desc = "Grab Next line" })
			km({ "x" }, "<leader>p", "\"_dP", { desc = "Preserve Put" })
			km({ "n" }, "Q", "<nop>", { desc = "(disabled)" })

			km({ "n" }, "<leader>wz", ":lua Snacks.zen()<CR>", { desc = "Zen Mode" })

			-- LSP related keymaps
			km("n", "<leader>ca", vim.lsp.buf.code_action, {
				lsp = { method = "textDocument/codeAction" },
				desc = "Code Action",
			})
			km("n", "<leader>ch", vim.lsp.buf.hover, {
				lsp = { method = "textDocument/hover" },
				desc = "Hover Info",
			})
			km({ "n" }, "<leader>cp", vim.diagnostic.goto_prev, {
				desc = "Goto Prev Diagnostic",
			})
			km({ "n" }, "<leader>cn", vim.diagnostic.goto_next, {
				desc = "Goto Next Diagnostic",
			})
			km({ "n" }, "<leader>cq", vim.diagnostic.setqflist, {
				desc = "Set Diagnostic Quickfix List",
			})
			km("n", "<leader>cr", vim.lsp.buf.rename, {
				lsp = { method = "textDocument/rename" },
				desc = "Rename Variable",
			})
			km("n", "gd", vim.lsp.buf.definition, {
				lsp = { method = "textDocument/definition" },
				desc = "Go to definition",
			})
			km("n", "gi", vim.lsp.buf.implementation, {
				lsp = { method = "textDocument/implementation" },
				desc = "Go to implementation",
			})
			km("n", "gy", vim.lsp.buf.type_definition, {
				lsp = { method = "textDocument/typeDefinition" },
				desc = "Go to type definition",
			})
    '';
  luasnipEnabled = config.plugins.luasnip.enable or false;
  luasnip_km = # lua
    ''
      local ls = require("luasnip")

      km({ "i", "s" }, "<C-k>", function()
      	if ls.expand_or_jumpable() then
      		ls.expand_or_jump()
      	end
      end, {
      	desc = "expand or jump to next snippet",
      })

      km({ "i", "s" }, "<C-j>", function()
      	if ls.jumpable(-1) then
      		ls.jump(-1)
      	end
      end, {
      	desc = "jump back",
      })
    '';
in
{
  /*
    	which-key is used project wide to create help-menu icons and entries for
    	keymaps. All keymap commands are defined outside of which-key to allow
    	which-key to be disabled or removed without breaking core-functionality.

    	Default keymaps for normal, insert, and visual modes are also mapped
    	into apropriate top-level groups (searching, parsing, folding, etc.)
    	to provide easy reference. The faster or default keymaps are preserved
    	and displayed in the description.

    	Keymaps for insert and visual mode are also displayed as hints in the
    	normal mode menu.
  */
  # Create define which-key as available for the rest of the config
  extraConfigLuaPre = (
    if config.plugins.which-key.enable then # lua
      ''
        local wk_available, wk = pcall(require, "which-key")
      ''
    # lua
    else
      ''
        local wk_available = false
      ''
  );

  plugins = {
    snacks = {
      enable = true;
      settings.keymap.enabled = true;
      luaConfig.post = global_km + lib.optionalString luasnipEnabled luasnip_km;
    };

    which-key = {
      enable = true;
      settings = {
        delay = 500;
      };
      luaConfig.post = # lua
        ''
          wk.add({
          	{ "j", icon = " ", desc = "Down", },
          	{ "<Down>", icon = " ", desc = "Down", },
          	{ "k", icon = " ", desc = "Up", },
          	{ "<Down>", icon = " ", desc = "Up", },
          	{ "<C-h>", icon = " 󰓩 ", desc = "Got to Left Window", },
          	{ "<C-j>", icon = " 󰓩 ", desc = "Got to Lower Window", },
          	{ "<C-k>", icon = " 󰓩 ", desc = "Got to Upper Window", },
          	{ "<C-l>", icon = " 󰓩 ", desc = "Got to Right Window", },
          	{ "<leader>y", icon = "", desc = "yank to system clipboard ( + register)", },
          	{ "y", icon = " ", desc = "yank to \" register", },
          	{ "u", icon = "󰕌 ", desc = "undo", },
          	{ "U", icon = "󰑎 ", desc = "redo", },
          	{ "J", icon = "󱞿 ", desc = "move line down", },
          	{ "<C-y>", icon = "", desc = "toggle verticle column", },
          	{ "h", icon = " ", desc = "Left", },
          	{ "l", icon = " ", desc = "Right", },
          	{ "_", icon = "󰞓 ", desc = "Start of Line (whitespace, with count)", },
          	{ "^", icon = "󰞓 ", desc = "Start of Line (whitespace, single-line)", },
          	{ "0", icon = "󰞓 ", desc = "Start of Line (absolute, single-line)", },
          	{ "$", icon = "󰞔 ", desc = "End of Line", },
          	{ "<", icon = "󰞗 ", desc = "Indent Left", },
          	{ ">", icon = "󰞘 ", desc = "Indent Right", },
          	{ "G", icon = "󰞒 ", desc = "Last Line", },
          	{ "~", icon = "󰬵 ", desc = "Toggle case", },
          	{ "{", icon = "󰉸 ", desc = "Prev empty line", },
          	{ "}", icon = "󰉸 ", desc = "Next empty line", },

          	-- Tab group
          	{ "<leader><Tab>", group = "Tabs", icon = "󰓩 ", },
          	{ "<leader><Tab>", group = "Tabs", proxy = "<Tab>", },
          	{ "<leader><Tab><Tab>", icon = "󰓩 ", desc = "New Tab", },
          	{ "<leader><Tab>d", icon = "󰱝 ", desc = "Close Tab", },
          	{ "<leader><Tab>]", icon = " ", desc = "Next Tab (gt)", },
          	{ "<leader><Tab>[", icon = " ", desc = "Prev Tab (gT)", },
          	{ "<leader><Tab>f", icon = "󰞓 ", desc = "First Tab", },
          	{ "<leader><Tab>l", icon = "󰞔 ", desc = "Last Tab", },
          	{ "<leader><Tab>o", icon = "o󰱝 ", desc = "Close Other Tabs", },

          	-- Windows group - built-in
          	{ "<leader>w", group = "Windows", proxy = "<C-w>", icon = "󰖲 ", },
						{ "<leader>wz", icon = "Z", },
          	{ "<leader>o", group = "Options", icon = " ", },

          	-- Global group
          	{ "g", group = "Global", icon = " ", },
          	{ "gg", icon = "󰞒 ", desc = "First Line", },

						-- Code Actions Group
						{ "<leader>c", group = "Code Actions", icon = " " },
						{ "<leader>ca", icon = " ", desc = "Accept Code Action", },
						{ "<leader>cn", icon = "󰮰 ", desc = "Next Diagnostic", },
						{ "<leader>cp", icon = "󰮰 ", desc = "Prev Diagnostic", },
						{ "<leader>cq", icon = "󰑮 ", desc = "Set Quickfix List", },
						{ "<leader>cr", icon = "󰑕 ", desc = "Rename Variable", },
						{ "<leader>cg", group = "Goto", icon = " " },
						{ "<leader>cgd", "gd", desc = "Goto Definition (gd)" },
						{ "<leader>cgD", "gD", desc = "Goto Declaration (gD)" },
						{ "<leader>cgy", "gy", desc = "Goto T[y]pe Definition (gy)" },
						{ "<leader>cgi", "gi", desc = "Goto Implementation (gi)" },
						{ "<leader>cgi", "gr", desc = "References (gr)" },
          })
        '';
    };
    mini = {
      enable = true;
      modules = {
        icons.enable = true;
        doc.enable = true;
        comment = {
          disable_default_keymaps = true;
        };
      };
    };

  };
}
