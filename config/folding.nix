{ ... }:
{
  plugins.nvim-ufo = {
    enable = true;
    settings = {
      provider_selector =
        # lua
        ''
          function(bufnr, filetype, buftype)
           			return { 'lsp', 'indent' }
           		end
        '';
    };
    luaConfig.pre =
      # lua
      ''
        -- Configuration for UFO folds
        vim.keymap.set('n', 'zj', function()
        	local winid = require('ufo').peekFoldedLinesUnderCursor()
        	if not winid then
        		vim.lsp.buf.hover()
        	end
        end, { desc = "Pee[k] fold" })
      '';
  };
}
