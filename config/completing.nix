# All configuration related to completing code/text

{
  config,
  lib,
  ...
}:
let
  ls = config.language_support;
  enableIf = cond: cfg: lib.mkIf cond cfg;
in
{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
        };
        appearance = {
          nerd_font_variant = "mono";
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
          per_filetype = {
            sql = [
              "snippets"
              "dadbod"
              "buffer"
            ];
          };
        };
        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 300;
          };
        };
        fuzzy = {
          implementation = "prefer_rust_with_warning";
        };
      };
    };
    luasnip = enableIf ls.lua.enable {
      enable = true;
    };
    friendly-snippets.enable = true;
    lspkind.enable = true;
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
      };
			luaConfig.post = #lua 
			  ''
			    local npairs = require("nvim-autopairs")
			    local Rule = require("nvim-autopairs.rule")
			    -- Auto terminate Nix assigments with ;			
			    npairs.add_rules({
			    	Rule("= {", " };", "nix")
			    			:use_key("{"),
			    	Rule("={", "};", "nix")
			    			:use_key("{"),
			    
			    	Rule("= [", " ];", "nix")
			    			:use_key("["),
			    	Rule("=[", "];", "nix")
			    			:use_key("["),
			    })
			  '';
    };
    vim-dadbod-completion.enable = config.plugins.vim-dadbod.enable; # Dependency
    vim-dadbod-ui.enable = config.plugins.vim-dadbod.enable; # Dependency
  };

  keymaps = lib.concatLists [
    (lib.optionals config.plugins.luasnip.enable [
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
    ])
  ];
}
