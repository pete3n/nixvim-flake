# All configuration related to folding code blocks
{ ... }:
{
  plugins.nvim-ufo = {
    enable = true;
    settings = {
      provider_selector = # lua
        ''
					function(bufnr, filetype, buftype)
						return { 'lsp', 'indent' }
					end
        '';
    };
    luaConfig.post =
      # lua
      ''
				local peek_fold = function()
					local winid = require('ufo').peekFoldedLinesUnderCursor()
					if not winid then
						vim.lsp.buf.hover()
					end
				end

				if pcall(require, "which-key") then
					local wk = require ("which-key")
					wk.add({
						{ "z", group = "folding", icon = "󰅪"},
						{ "<leader>z", group = "folding", proxy = "z", icon = "󰅪", };
					})
				end
      '';
  };

  keymaps = [
    {
      key = "zj";
      mode = "n";
      action = "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>";
      options = {
        desc = "Peek folded lines";
      };
    }
  ];
}
