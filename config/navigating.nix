# All configuration related to navigating files
{ lib, config, ... }:
{
  plugins = {
    oil.enable = true;
    nvim-tree.enable = true;
    harpoon.enable = true; # The name, is the harpoon-maker-agen
  };

  keymaps = lib.concatLists [
    (lib.optionals config.plugins.oil.enable [
      {
        key = "<leader>nv";
        mode = "n";
        action = "<cmd>Oil<CR>";
        options = {
          silent = true;
          desc = "view filetree";
        };
      }
    ])
    (lib.optionals config.plugins.nvim-tree.enable [
      {
        key = "<leader>nt";
        mode = "n";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          silent = true;
          desc = "toggle filetree";
        };
      }
    ])
    (lib.optionals config.plugins.harpoon.enable [
      {
        key = "<leader>na";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():add()<CR>";
        options = {
          silent = false;
          desc = "add file to 󱡅 harpoon (󱁐 a)";
        };
      }
      {
        key = "<leader>a";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():add()<CR>";
        options = {
          silent = false;
          desc = "add file to 󱡅 harpoon";
        };
      }
      {
        key = "<leader>ne";
        mode = "n";
        action = "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>";
        options = {
          silent = true;
          desc = "harpoon menu (󰘴 E)";
        };
      }
      {
        key = "<C-e>";
        mode = "n";
        action = "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>";
        options = {
          silent = true;
          desc = "harpoon menu";
        };
      }
      {
        key = "<leader>n1";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(1)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 2 (󰘴 H)";
        };
      }
      {
        key = "<C-h>";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(1)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 1";
        };
      }
      {
        key = "<leader>n2";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(2)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 2 (󰘴 T)";
        };
      }
      {
        key = "<C-t>";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(2)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 2";
        };
      }
      {
        key = "<leader>n3";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(3)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 3 (󰘴 N)";
        };
      }
      {
        key = "<C-n>";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(3)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 3";
        };
      }
      {
        key = "<leader>n4";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(4)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 4 (󰘴 S)";
        };
      }
      {
        key = "<C-s>";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(4)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 4";
        };
      }
      {
        key = "<leader>n5";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(5)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 5";
        };
      }
      {
        key = "<leader>n6";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(6)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 6";
        };
      }
      {
        key = "<leader>n7";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(7)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 7";
        };
      }
      {
        key = "<leader>n8";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(8)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 8";
        };
      }
      {
        key = "<leader>n9";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(9)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 9";
        };
      }
      {
        key = "<leader>n0";
        mode = "n";
        action = "<cmd>lua require('harpoon'):list():select(0)<CR>";
        options = {
          silent = true;
          desc = "harpoon file 10";
        };
      }
    ])
  ];

  extraConfigLuaPost = # lua
    ''
      if wk_available then
      	local keymaps = {}

      	-- Unconditional searching group mapping
      	table.insert(keymaps, { "<leader>n", group = "navigating", icon = " " })

      	-- Conditionall map harpoon icons
      	if pcall(require, "harpoon") then
      		table.insert(keymaps, { "<leader>a", icon = " " })
      		table.insert(keymaps, { "<leader>na", icon = " " })
      		table.insert(keymaps, { "<leader>ne", icon = "󰮫 ", })
      		table.insert(keymaps, { "<C-e>", icon = "󰮫 ", })
      		table.insert(keymaps, { "<leader>n1", icon = "󱡅 ", })
      		table.insert(keymaps, { "<C-h>", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n2", icon = "󱡅 ", })
      		table.insert(keymaps, { "<C-t>", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n3", icon = "󱡅 ", })
      		table.insert(keymaps, { "<C-n>", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n4", icon = "󱡅 ", })
      		table.insert(keymaps, { "<C-s>", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n5", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n6", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n7", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n8", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n9", icon = "󱡅 ", })
      		table.insert(keymaps, { "<leader>n0", icon = "󱡅 ", })
      	end

      	-- Conditionall map oil icon
      	if pcall(require, "oil") then
      		table.insert(keymaps, { "<leader>nv", icon = "󰏇 ", })
      	end

      	-- Conditionall map nvim-tree icon
      	if pcall(require, "nvim-tree") then
      		table.insert(keymaps, { "<leader>nt", icon = " ", })
      	end

      	wk.add(keymaps)
      end
    '';
}
