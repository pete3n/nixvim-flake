# All additional configuration related to editing additional files
# (hex, git, etc.)
{ pkgs, config, ... }:
{
  extraPackages = with pkgs; [
    git
    xxd
  ];


  plugins = {
    hex.enable = true;
    undotree.enable = true;
    fugitive.enable = true;
		diffview.enable = true;
    git-worktree = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable; # TS dependency
    };
    gitsigns.enable = true;
    neogit.enable = true;

  };


  keymaps = [
    {
      key = "<leader>u";
      mode = "n";
      action = "<cmd>UndotreeToggle<CR>";
      options = {
        desc = "undotree toggle";
      };
    }
    {
      key = "<leader>gf";
      mode = "n";
      action = "<cmd>Git<CR>";
      options = {
        desc = "git fugitive";
      };
    }
    {
      key = "<leader>gn";
      mode = "n";
      action = "<cmd>Neogit<CR>";
      options = {
        desc = "neogit";
      };
    }
    {
      key = "<leader>ga";
      mode = "n";
      action = "<cmd>AdvancedGitSearch<CR>";
      options = {
        desc = "advanced search";
      };
    }
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
  ];

  extraConfigLuaPost = # lua
    ''
			-- Remove overlapping keymap from fugitive if it exists
			local function rm_fugitive_keymap_overlap()
				if vim.fn.mapcheck("y<C-G>", "n") ~= "" then
					vim.keymap.del("n", "y<C-G>")
				end
			end

			vim.schedule(rm_fugitive_keymap_overlap)

			if pcall(require, "which-key") then
				local wk = require("which-key")
				
				wk.add({
					{ "<leader>g", group = "git", icon = " ", },
					{ "<leader>gf", group = "git fugitive", icon = " ", },
					{ "<leader>gn", group = "neogit", icon = "󰊢 ", },
					{ "<leader>gs", icon = " ", desc = "status", },
					{ "<leader>gb", icon = " ", desc = "branches", },
					{ "<leader>ga", icon = " ", desc = "advanced search", },
				})
			end
    '';
}
