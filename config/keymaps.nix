{pkgs, ...}: {
  keymaps = [
    {
      key = "<leader>pv";
      mode = "n";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "[p]roject [v]iew";
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
    {
      key = "<leader>t";
      mode = ["n"];
      action = "<cmd>NvimTreeToggle<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Toggle nvim [t]ree";
      };
    }
  ];
}
