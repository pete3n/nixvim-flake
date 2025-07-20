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
    (lib.optionals config.plugins.diffview.enable [
      {
        key = "<leader>gd";
        mode = "n";
        action = "<cmd>DiffviewFileHistory<CR>";
        options = {
          desc = "diffview file history";
        };
      }
    ])
    (lib.optionals config.plugins.fugitive.enable [
      {
        key = "<leader>gf";
        mode = "n";
        action = "<cmd>Git<CR>";
        options = {
          desc = "git fugitive";
        };
      }
    ])
    (lib.optionals config.plugins.neogit.enable [
      {
        key = "<leader>gn";
        mode = "n";
        action = "<cmd>Neogit<CR>";
        options = {
          desc = "neogit";
        };
      }
    ])
    (lib.optionals config.plugins.undotree.enable [
      {
        key = "<leader>u";
        mode = "n";
        action = "<cmd>UndotreeToggle<CR>";
        options = {
          desc = "undotree toggle";
        };
      }
    ])
    (lib.optionals config.plugins.telescope.enable [
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
    ])
    # Cross-map the advanced_git_search telescope extension from the searching group
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
  ];

  extraConfigLuaPost = lib.concatStringsSep "\n" [
		# lua
    ''
      if wk_available then
				local keymaps = {}
				
				-- Unconditional git group mapping
				table.insert(keymaps, { "<leader>g", group = "git", icon = " ", })

				-- Conditional mappings
				if pcall(require, "diffview") then
					table.insert(keymaps, { "<leader>gd", icon = " ", desc = "diffview", })
				end

				if pcall(require, "fugitive") then
					table.insert(keymaps, { "<leader>gf", icon = " ", desc = "git fugitive", })
				end

				if pcall(require, "neogit") then
					table.insert(keymaps, { "<leader>gn", icon = "󰊢 ", desc = "neogit", })
				end

				if pcall(require, "telescope.builtin.git_status") then
					table.insert(keymaps, { "<leader>gs", icon = " ", desc = "status", })
				end

				if pcall(require, "telescope.builtin.git_branches") then
					table.insert(keymaps, { "<leader>gb", icon = " ", desc = "branches", })
				end

				if pcall(telescope.load_extension, "advanced_git_search") then
					table.insert(keymaps, { "<leader>ga", icon = " ", desc = "advanced search", })
				end

				wk.add(keymaps)
      end
    '' 
		(if config.plugins.fugitive.enable then 
		# lua
		''
			-- Remove fugitive overlap mapping
			local function rm_fugitive_keymap_overlap()
				if vim.fn.mapcheck("y<C-G>", "n") ~= "" then
					vim.keymap.del("n", "y<C-G>")
				end
			end

			vim.schedule(rm_fugitive_keymap_overlap)
		''
      else "")
		];
}
