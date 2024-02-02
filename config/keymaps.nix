{pkgs, ...}: {
  keymaps = [
    {
      key = "<leader>pv";
      mode = "n";
      action = "<cmd>Oil<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[p]roject [v]iew";
      };
    }
    {
      key = "<leader>u";
      mode = "n";
      action = "<cmd>UndotreeToggle<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[u]ndotree toggle";
      };
    }
    {
      key = "<leader>gs";
      mode = "n";
      action = "<cmd>Git<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[g]it [s]tatus";
      };
    }
    {
      key = "<C-y>";
      mode = "n";
      action = ":set cursorcolumn!<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Toggle vertical column because [Y]AML sucks";
      };
    }
    {
      key = "J";
      mode = "v";
      action = ":m '>+1<CR>gv=gv";
      options = {
        silent = true;
        noremap = true;
        desc = "Shift line down 1 in visual mode";
      };
    }
    {
      key = "K";
      mode = "v";
      action = ":m '<-2<CR>gv=gv";
      options = {
        silent = true;
        noremap = true;
        desc = "Shift line up 1 in visual mode";
      };
    }
    {
      key = "J";
      mode = "n";
      action = "mzJ\`z"; # Keep cursor to the left
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<C-d>";
      mode = "n";
      action = "<C-d>zz"; # Keep cursor in middle
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<C-u>";
      mode = "n";
      action = "<C-u>zz"; # Keep cursor in middle
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "n";
      mode = "n";
      action = "nzzzv"; # Keep cursor in middle
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "N";
      mode = "n";
      action = "Nzzzv";
      options = {
        silent = true;
        noremap = true;
      };
    }
    {
      key = "<leader>p";
      mode = "x";
      action = "\"_dP";
      options = {
        silent = true;
        noremap = true;
        desc = "[p]reserve put";
      };
    }
    {
      key = "<leader>y";
      mode = ["n" "v"];
      action = "\"+y";
      options = {
        silent = true;
        noremap = true;
        desc = "[y]ank to system clipboard";
      };
    }
    {
      key = "<leader>Y";
      mode = "n";
      action = "\"+Y";
      options = {
        silent = true;
        noremap = true;
        desc = "[Y]ank line to system clipboard";
      };
    }
    {
      key = "Q";
      mode = "n";
      action = "<nop>";
      options = {
        silent = true;
        noremap = true;
        desc = "Don't";
      };
    }
    {
      key = "<C-f>";
      mode = "n";
      action = "<cmd>!tmux neww tmux-sessionizer<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[f]ind and switch tmux session";
      };
    }
    {
      key = "<C-k>";
      mode = "n";
      action = "<cmd>cnext<CR>zz";
      options = {
        silent = true;
        noremap = true;
        desc = "Next quickfix";
      };
    }
    {
      key = "<C-j>";
      mode = "n";
      action = "<cmd>cprev<CR>zz";
      options = {
        silent = true;
        noremap = true;
        desc = "Prev quickfix";
      };
    }
    {
      key = "<leader>k";
      mode = "n";
      action = "<cmd>lnext<CR>zz";
      options = {
        silent = true;
        noremap = true;
        desc = "Next quickfix location";
      };
    }
    {
      key = "<leader>j";
      mode = "n";
      action = "<cmd>lprev<CR>zz";
      options = {
        silent = true;
        noremap = true;
        desc = "Prev quickfix location";
      };
    }
    {
      key = "<leader>mp";
      mode = ["n" "v"];
      action = ":lua _G.format_with_conform()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[m]ake [p]retty by formatting";
      };
    }
    {
      key = "<leader>da";
      mode = "n";
      action = ":lua vim.lsp.buf.code_action()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[d]iagnostic changes [a]ccepted";
      };
    }
    {
      key = "<leader>t";
      mode = "n";
      action = "<cmd>NvimTreeToggle<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Toggle nvim [t]ree";
      };
    }

    # DAP Debugging
    {
      key = "<leader>b";
      mode = "n";
      action = ":lua require'dap'.toggle_breakpoint()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Toggle DAP [b]reakpoint";
      };
    }
    {
      key = "<leader>B";
      mode = "n";
      action = ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Set DAP [B]reakpoint";
      };
    }
    {
      key = "<leader>dtg";
      mode = "n";
      action = ":lua require'dap-go'.debug_test()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "DAP [d]ebug [t]est for (g)o";
      };
    }
    {
      key = "<leader>de";
      mode = "n";
      action = ":lua require'dap'.repl.open()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[d]ap r[e]pl open";
      };
    }
    {
      key = "<leader>lp";
      mode = "n";
      action = ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[l]og DAP [p]oint message";
      };
    }
    {
      key = "<F5>";
      mode = "n";
      action = ":lua require'dap'.continue()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Continue DAP debug";
      };
    }
    {
      key = "<F10>";
      mode = "n";
      action = ":lua require'dap'.step_over()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Step over DAP debug";
      };
    }
    {
      key = "<F11>";
      mode = "n";
      action = ":lua require'dap'.step_into()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Step into DAP debug";
      };
    }
    {
      key = "<F12>";
      mode = "n";
      action = ":lua require'dap'.step_out()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Stepout of DAP debug";
      };
    }
  ];
}
