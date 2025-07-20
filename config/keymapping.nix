/*
  	All configuration related to top-level keymapping
   	Function specific keymapping (completing, debugging, etc.)
   	is found in the associated configuration files
*/
{ config, ... }:
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
  plugins = {
    which-key = {
      enable = true;
      settings = {
        delay = 500;
        spec = [
          {
            __unkeyed = "<C-R>";
            mode = "n";
            desc = "(insert mode) open registers";
          }
        ];
      };
      luaConfig.post = # lua
        ''
          wk.add({
          	{ "<C-L>", icon = "󰞋 ", desc = "Help", "<cmd>help<CR>", },
          	{ "<leader>y", icon = "", desc = "yank to system clipboard ( + register)", },
          	{ "y", icon = " ", desc = "yank to \" register", },
          	{ "u", icon = "󰕌 ", desc = "undo", },
          	{ "U", icon = "󰑎 ", desc = "redo", },
          	{ "J", icon = "󱞿 ", desc = "move line down", },
          	{ "<C-y>", icon = "", desc = "toggle verticle column", },
          	{ "h", icon = " ", desc = "Left", },
          	{ "j", icon = " ", desc = "Down", },
          	{ "k", icon = " ", desc = "Up", },
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
          	{ "<Tab>", group = "tabs", icon = "󰓩 ", },
          	{ "<leader><Tab>", group = "tabs", proxy = "<Tab>", },
          	{ "<Tab>n", icon = "󰓩 ", desc = "new tab", },
          	{ "<Tab>q", icon = "󰱝 ", desc = "close tab", },
          	{ "<Tab>l", icon = " ", desc = "next tab (gt)", },
          	{ "<Tab>h", icon = " ", desc = "prev tab (gT)", },

          	-- Windows group - built-in
          	{ "<leader>w", group = "windows", proxy = "<C-w>", icon = "󰖲 ", },

          	{ "<leader>o", group = "options", icon = " ", },

          	-- Global group
          	{ "g", group = "Global", icon = " ", },
          	{ "gg", icon = "󰞒 ", desc = "First Line", },
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

  keymaps = [
    {
      key = "<Tab>n";
      mode = "n";
      action = ":tabnew<CR>";
      options = {
        silent = true;
        desc = "new tab";
      };
    }
    {
      key = "<Tab>q";
      mode = "n";
      action = ":close<CR>";
      options = {
        silent = true;
        desc = "close tab";
      };
    }
    {
      key = "<Tab>l";
      mode = "n";
      action = ":tabnext<CR>";
      options = {
        silent = true;
        desc = "next tab";
      };
    }
    {
      key = "<Tab>h";
      mode = "n";
      action = ":tabprevious<CR>";
      options = {
        silent = true;
        desc = "previous tab";
      };
    }
    {
      key = "u";
      mode = [
        "n"
        "v"
      ];
      action = ":undo<CR>";
      options = {
        silent = true;
        desc = "undo";
      };
    }
    {
      key = "U";
      mode = [
        "n"
        "v"
      ];
      action = ":redo<CR>";
      options = {
        silent = true;
        desc = "redo";
      };
    }
    {
      key = "<leader>y";
      mode = [
        "n"
        "v"
      ];
      action = "\"+y";
      options = {
        desc = "yank to system clipboard ( + register)";
      };
    }
    {
      key = "<C-y>";
      mode = "n";
      action = ":set cursorcolumn!<CR>";
      options = {
        silent = true;
        desc = "toggle vertical column";
      };
    }
    {
      key = "J";
      mode = "v";
      action = ":m '>+1<CR>gv=gv";
      options = {
        silent = true;
        desc = "move line down";
      };
    }
    {
      key = "K";
      mode = "v";
      action = ":m '<-2<CR>gv=gv";
      options = {
        silent = true;
        desc = "move line up";
      };
    }
    {
      key = "J";
      mode = "n";
      action = "mzJ\`z";
      options = {
        silent = true;
        desc = "grab next line";
      };
    }
    # Disabled because of conflict with the which-key menu scrolling
    #{
    #  key = "<C-d>";
    #  mode = "n";
    #  action = "<C-d>zz"; # Scroll down and keep cursor in middle
    #  options = {
    #    silent = true;
    #    noremap = true;
    #  };
    #}
    #{
    #  key = "<C-u>";
    #  mode = "n";
    #  action = "<C-u>zz"; # Scroll up and keep cursor in middle
    #  options = {
    #    silent = true;
    #    noremap = true;
    #  };
    #}
    {
      key = "<leader>p";
      mode = "x";
      action = "\"_dP";
      options = {
        silent = true;
        desc = "preserve put";
      };
    }
    {
      key = "Q";
      mode = "n";
      action = "<nop>";
      options = {
        silent = true;
        desc = "(disabled)";
      };
    }
  ];

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
}
