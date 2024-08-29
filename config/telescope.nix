{pkgs, ...}: {
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>?" = {
        action = "oldfiles";
        options = {
          desc = "[?] Find recently opened files";
        };
      };
      "<leader><space>" = {
        action = "buffers";
        options = {
          desc = "[ ] Find existing buffers";
        };
      };
      "<leader>/" = {
        action = "current_buffer_fuzzy_find";
        options = {
          desc = "[/] Fuzzily search in current buffer]";
        };
      };
      "<leader>sf" = {
        action = "find_files";
        options = {
          desc = "[s]earch [f]iles";
        };
      };
      "<leader>sh" = {
        action = "help_tags";
        options = {
          desc = "[s]earch [h]elp";
        };
      };
      "<leader>sw" = {
        action = "grep_string";
        options = {
          desc = "[s]earch current [w]ord";
        };
      };
      "<leader>sg" = {
        action = "live_grep";
        options = {
          desc = "[s]earch by [g]rep";
        };
      };
      "<leader>sd" = {
        action = "diagnostics";
        options = {
          desc = "[s]earch [d]iagnotics";
        };
      };
      "<leader>sk" = {
        action = "keymaps";
        options = {
          desc = "[s]earch [k]eymaps";
        };
      };
    };
  };
}
