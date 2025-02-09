# All additional configuration related to editing additional files
# (hex, git, etc.)
{
  pkgs,
  config,
  lib,
  ...
}:
{
  extraPackages = with pkgs; [
    git
    xxd
  ];

  plugins = {
    diffview.enable = true;
    fugitive.enable = true;
    git-worktree = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable; # TS dependency
    };
    gitsigns.enable = true;
    hex.enable = true;
    neogit.enable = true;
    undotree.enable = true;
    vim-dadbod.enable = true;
    vim-dadbod-ui.enable = config.plugins.vim-dadbod.enable; # Depedency
  };

  keymaps = lib.concatLists [
    (
      if config.plugins.diffview.enable then
        [
          {
            key = "<leader>gd";
            mode = "n";
            action = "<cmd>DiffviewFileHistory<CR>";
            options = {
              desc = "diffview file history";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.fugitive.enable then
        [
          {
            key = "<leader>gf";
            mode = "n";
            action = "<cmd>Git<CR>";
            options = {
              desc = "git fugitive";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.neogit.enable then
        [
          {
            key = "<leader>gn";
            mode = "n";
            action = "<cmd>Neogit<CR>";
            options = {
              desc = "neogit";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.undotree.enable then
        [
          {
            key = "<leader>u";
            mode = "n";
            action = "<cmd>UndotreeToggle<CR>";
            options = {
              desc = "undotree toggle";
            };
          }
        ]
      else
        [ ]
    )
    (
      if builtins.elem "advanced_git_search" config.plugins.telescope.enabledExtensions then
        [
          {
            key = "<leader>ga";
            mode = "n";
            action = "<cmd>AdvancedGitSearch<CR>";
            options = {
              desc = "advanced search";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.telescope.enable then
        [
          {
            key = "<leader>gs";
            mode = "n";
            action = ":lua require('telescope.builtin').git_status()<CR>";
            options = {
              desc = "git status";
            };
          }
          {
            key = "<leader>gb";
            mode = "n";
            action = ":lua require('telescope.builtin').git_branches()<CR>";
            options = {
              desc = "git branch";
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
      		{ "<leader>g", group = "git", icon = " ", },
      		{ "<leader>gd", icon = " ", desc = "diffview", },
      		{ "<leader>gf", icon = " ", desc = "git fugitive", },
      		{ "<leader>gn", icon = "󰊢 ", desc = "neogit", },
      		{ "<leader>gs", icon = " ", desc = "status", },
      		{ "<leader>gb", icon = " ", desc = "branches", },
      		{ "<leader>ga", icon = " ", desc = "advanced search", },
      	})
      end
    ''
    # Only delete fugitive overlap keys if it is enabled 
    + (
      if config.plugins.fugitive.enable then # lua
        ''
          local function rm_fugitive_keymap_overlap()
          	if vim.fn.mapcheck("y<C-G>", "n") ~= "" then
          		vim.keymap.del("n", "y<C-G>")
          	end
          end

          vim.schedule(rm_fugitive_keymap_overlap)
        ''
      else
        ""
    );
}
