# All configuration related to navigating files
{ lib, config, ... }:
{
  plugins = {
    oil.enable = true;
    nvim-tree.enable = true;
    harpoon = {
      enable = true; # The name, is the harpoon-maker-agen
    };
  };

  keymaps = lib.concatLists [
    (
      if config.plugins.oil.enable then
        [
          {
            key = "<leader>nv";
            mode = "n";
            action = "<cmd>Oil<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "view filetree";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.nvim-tree.enable then
        [
          {
            key = "<leader>nt";
            mode = "n";
            action = "<cmd>NvimTreeToggle<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "toggle filetree";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.harpoon.enable then
        [
          {
            key = "<leader>na";
            mode = "n";
            action = ":lua require('harpoon.mark').add_file()<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "add file to 󱡅 harpoon (󱁐 a)";
            };
          }
          {
            key = "<leader>a";
            mode = "n";
            action = ":lua require('harpoon.mark').add_file()<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "add file to 󱡅 harpoon";
            };
          }
          {
            key = "<leader>ne";
            mode = "n";
            action = ":lua require('harpoon.ui').toggle_quick_menu()<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon menu (󰘴 E)";
            };
          }
          {
            key = "<C-e>";
            mode = "n";
            action = ":lua require('harpoon.ui').toggle_quick_menu()<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon menu";
            };
          }
          {
            key = "<leader>n1";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(1)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 1 (󰘴 H)";
            };
          }
          {
            key = "<C-h>";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(1)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 1";
            };
          }
          {
            key = "<leader>n2";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(2)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 2 (󰘴 T)";
            };
          }
          {
            key = "<C-t>";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(2)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 2";
            };
          }
          {
            key = "<leader>n3";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(3)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 3 (󰘴 N)";
            };
          }
          {
            key = "<C-n>";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(3)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 3";
            };
          }
          {
            key = "<leader>n4";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(4)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 4 (󰘴 S)";
            };
          }
          {
            key = "<C-s>";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(4)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 4";
            };
          }
          {
            key = "<leader>n5";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(5)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 5";
            };
          }
          {
            key = "<leader>n6";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(6)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 6";
            };
          }
          {
            key = "<leader>n7";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(7)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 7";
            };
          }
          {
            key = "<leader>n8";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(8)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 8";
            };
          }
          {
            key = "<leader>n9";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(9)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 9";
            };
          }
          {
            key = "<leader>n0";
            mode = "n";
            action = ":lua require('harpoon.ui').nav_file(10)<CR>";
            options = {
              silent = true;
              noremap = true;
              desc = "harpoon file 10";
            };
          }
        ]
      else
        [ ]
    )
  ];

  extraConfigLuaPost = # lua
    ''
            if pcall(require, "which-key") then
            	local wk = require("which-key")
            		wk.add({ 
      						{ "<leader>n", group = "navigating", icon = " " },
            			{ "<leader>a", icon = " ", },
            			{ "<leader>nv", icon = "󰏇 ", },
            			{ "<leader>nt", icon = " ", },
            			{ "<leader>na", icon = " ", },
            			{ "<leader>ne", icon = "󰮫 ", },
            			{ "<C-e>", icon = "󰮫 ", },
            			{ "<leader>n1", icon = "󱡅 ", },
            			{ "<C-H>", icon = "󱡅 ", },
            			{ "<leader>n2", icon = "󱡅 ", },
            			{ "<C-t>", icon = "󱡅 ", },
            			{ "<leader>n3", icon = "󱡅 ", },
            			{ "<C-n>", icon = "󱡅 ", },
            			{ "<leader>n4", icon = "󱡅 ", },
            			{ "<C-s>", icon = "󱡅 ", },
            			{ "<leader>n5", icon = "󱡅 ", },
            			{ "<leader>n6", icon = "󱡅 ", },
            			{ "<leader>n7", icon = "󱡅 ", },
            			{ "<leader>n8", icon = "󱡅 ", },
            			{ "<leader>n9", icon = "󱡅 ", },
            			{ "<leader>n0", icon = "󱡅 ", }
            		})
            end
    '';
}
