# All configuration related to completing code/text
{ ... }:
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
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-space>" = "cmp.mapping.complete()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
        };
        sources = [
          { name = "nvim_lua"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "luasnip"; }
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
          -- Extra options for cmp-cmdline setup
          local cmp = require("cmp")
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
        '';
    };

    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    cmp-ai.enable = false;
    luasnip.enable = true;
  };
}
