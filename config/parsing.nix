# All configuration related to parsing languages (Treesitter)
# TODO: Separate keymaps from wk dependency
{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    nix-prefetch-git
    jq
  ];

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "ninjection";
      version = "unstable-2025-06-10";

      src = pkgs.fetchFromGitHub {
        owner = "pete3n";
        repo = "ninjection.nvim";
        rev = "be097364dbf78df336c9b7d4dbf15d3952b1564f";
				hash = "sha256-QarhxLu4Q1lLkh6QSfU3zTJCU1OaUEvY0Cek+7yBK70=";
      };

      dependencies = [
        pkgs.vimPlugins.nvim-lspconfig
        pkgs.vimPlugins.nvim-treesitter
      ];

      #nvimRequireCheck = [ "ninjection" ];

      meta = {
        description = "Edit injected languages with Treesitter and LSP support";
        homepage = "https://github.com/pete3n/ninjection.nvim";
        license = pkgs.lib.licenses.mit;
      };
    })
  ];

  #    (pkgs.vimUtils.buildVimPlugin {
  #      name = "nix-prefetch.nvim";
  #      src = pkgs.fetchFromGitHub {
  #        owner = "pete3n";
  #        repo = "nix-prefetch.nvim";
  #        rev = "fa50db7784bb96f50f969bf1e2aed3e3aab7d764";
  #        hash = "sha256-C3Fgi0trkTx/2jutz1IHpUDrHrZ1taBD/LsI6vxy4qs=";
  #      };
  #    })

  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        auto_install = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "grm";
            node_incremental = "grn";
          };
        };
      };
      luaConfig.post = # lua
        ''
          local function contains(tbl, value)
          	for _, v in ipairs(tbl) do
          		if v == value then
          			return true
          		end
          	end
          	return false
          end

          -- Variable to track the current InspectTree window.
          local inspect_tree_win = nil

          local function inspect_tree_toggle()
          	-- If we have a recorded window and it’s still valid, close it.
          	if inspect_tree_win and vim.api.nvim_win_is_valid(inspect_tree_win) then
          		vim.api.nvim_win_close(inspect_tree_win, true)
          		inspect_tree_win = nil
          		return
          	end

          	-- Otherwise, open a new inspect tree window.
          	local wins_before = vim.api.nvim_list_wins()
          	vim.cmd("InspectTree")
          	-- Schedule a function to run after the command takes effect.
          	vim.schedule(function()
          		local wins_after = vim.api.nvim_list_wins()
          		for _, win in ipairs(wins_after) do
          			if not contains(wins_before, win) then
          				inspect_tree_win = win
          				break
          			end
          		end
          	end)
          end
          vim.api.nvim_create_user_command("InspectTreeToggle", inspect_tree_toggle, {})

          if wk_available then
          	wk.add({
          		{ "<leader>pi", "<cmd>InspectTreeToggle<CR>", desc = "toggle inspect tree", icon = "󰔡 " },
          		{ "<leader>pne", "<Plug>(NinjectionEdit)", desc = "ninject edit" },
          		{ "<leader>pnf", "<Plug>(NinjectionFormat)", desc = "ninject format" },
          		{ "<leader>pnv", "<Plug>(NinjectionSelect)", desc = "ninject select" },
          		{ "<leader>pnr", "<Plug>(NinjectionReplace)", desc = "ninject replace" },
          		{ "<leader>pu", "<cmd>NPUpdateRepo<CR>", desc = "update nix-prefetch" },
          	})
          end
        '';
    };

    treesitter-context = {
      enable = true;
      settings = {
        line_numbers = true;
        min_window_height = 0;
        max_lines = 0;
        mode = "topline";
        multiline_threshold = 20;
        separator = "-";
        trim_scope = "inner";
        zindex = 20;
      };
      luaConfig.post = # lua
        ''
          -- Function to temporarily show/hide the context window
          -- Returns nil context to force TS Context to close the window
          local ts_context = require("treesitter-context")
          local context = require("treesitter-context.context")
          local render = require("treesitter-context.render")

          _G.ts_context_display = true

          local original_get = context.get
          context.get = function(bufnr, winid)
          	if not _G.ts_context_display then
          		-- Return no context: this will trigger update_single_context to close the window.
          		return nil, {}
          	end

          	return original_get(bufnr, winid)
          end

          vim.api.nvim_create_user_command("TSContextToggleDisplay", function()
          	_G.ts_context_display = not _G.ts_context_display
          	local cur_win = vim.api.nvim_get_current_win()
          	if not _G.ts_context_display then
          		pcall(render.close, cur_win)
          		vim.notify("Treesitter Context hidden", vim.log.levels.INFO)
          	else
          		vim.notify("Treesitter Context enabled; move the cursor to refresh", vim.log.levels.INFO)
          	end
          end, {})

          if wk_available then
          	wk.add({
          		{
          			"<leader>pc",
          			"<cmd>TSContextToggleDisplay<CR>",
          			desc = "toggle treesitter-context display",
          			mode = "n",
          			icon = "󰔡 ",
          		},
          		{
          			"<leader>un",
          			"<cmd>NPUpdateRepo<CR>",
          			desc = "update github repo info",
          			mode = "n",
          			icon = "󰚰 ",
          		},
          	})
          end
        '';
    };

    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "a=" = {
            query = "@assignment.outer";
            desc = "select around outer part of an [=] assignment";
          };
          "i=" = {
            query = "@assignment.inner";
            desc = "select inner part of an [=] assignment";
          };
          "l=" = {
            query = "@assignment.lhs";
            desc = "select left hand side of an [=] assignment";
          };
          "r=" = {
            query = "@assignment.rhs";
            desc = "select [r]ight hand side of an [=] assignment";
          };
          "aa" = {
            query = "@parameter.outer";
            desc = "select around the outer part of a parameter";
          };
          "ia" = {
            query = "@parameter.inner";
            desc = "select the inner part of a parameter";
          };
          "ai" = {
            query = "@conditional.outer";
            desc = "select around the outer part of a conditional";
          };
          "ii" = {
            query = "@conditional.inner";
            desc = "select the inner part of a conditional";
          };
          "al" = {
            query = "@loop.outer";
            desc = "select around the outer part of a loop";
          };
          "il" = {
            query = "@loop.inner";
            desc = "select the inner part of a loop";
          };
          "af" = {
            query = "@call.outer";
            desc = "select around the outer part of a function call";
          };
          "if" = {
            query = "@call.inner";
            desc = "select the inner part of a function call";
          };
          "am" = {
            query = "@function.outer";
            desc = "select around the outer part of method or function";
          };
          "im" = {
            query = "@function.inner";
            desc = "select the inner part of a method or function";
          };
          "ac" = {
            query = "@class.outer";
            desc = "select around the outer part of a class";
          };
          "ic" = {
            query = "@class.inner";
            desc = "select the inner part of a class";
          };
        };
      };

      swap = {
        enable = true;
        swapNext = {
          "<leader>ppi" = "@parameter.inner";
          "<leader>ppo" = "@parameter.outer";
          "<leader>pfi" = "@function.innter";
          "<leader>pfo" = "@function.outer";
        };
        swapPrevious = {
          "<leader>ppI" = "@parameter.inner";
          "<leader>ppO" = "@parameter.outer";
          "<leader>pfI" = "@function.innter";
          "<leader>pfO" = "@function.outer";
        };
      };

      move = {
        enable = true;
        setJumps = true;
        gotoNextStart = {
          "]F" = {
            query = "@call.outer";
            desc = "next function call start";
          };
          "]M" = {
            query = "@function.outer";
            desc = "next method or function def start";
          };
          "]C" = {
            query = "@class.outer";
            desc = "next class start";
          };
          "]I" = {
            query = "@conditional.outer";
            desc = "next conditional start";
          };
          "]L" = {
            query = "@loop.outer";
            desc = "next loop start";
          };
        };

        gotoPreviousStart = {
          "[F" = {
            query = "@call.outer";
            desc = "prev function call start";
          };
          "[M" = {
            query = "@function.outer";
            desc = "prev method or function def start";
          };
          "[C" = {
            query = "@class.outer";
            desc = "prev class start";
          };
          "[I" = {
            query = "@conditional.outer";
            desc = "prev conditional start";
          };
          "[L" = {
            query = "@loop.outer";
            desc = "prev loop start";
          };
        };

        gotoNextEnd = {
          "]f" = {
            query = "@call.outer";
            desc = "next function call end";
          };
          "]m" = {
            query = "@function.outer";
            desc = "next method or function def end";
          };
          "]c" = {
            query = "@class.outer";
            desc = "next class end";
          };
          "]i" = {
            query = "@conditional.outer";
            desc = "next conditional end";
          };
          "]l" = {
            query = "@loop.outer";
            desc = "next loop end";
          };
        };

        gotoPreviousEnd = {
          "[f" = {
            query = "@call.outer";
            desc = "prev function call end";
          };
          "[m" = {
            query = "@function.outer";
            desc = "prev method or function def end";
          };
          "[c" = {
            query = "@class.outer";
            desc = "prev class end";
          };
          "[i" = {
            query = "@conditional.outer";
            desc = "prev conditional end";
          };
          "[l" = {
            query = "@loop.outer";
            desc = "prev loop end";
          };
        };

      };
    };

    treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = false;
      highlightDefinitions.enable = true;
      navigation = {
        enable = true;
      };
      smartRename = {
        enable = true;
        keymaps = {
          smartRename = "grr";
        };
      };
    };
  };
  extraConfigLuaPost = # lua
    ''
      if wk_available then
      	wk.add({
      		{ "<leader>p", group = "parsing", icon = " " },
      		{ "<leader>pp", group = "paramater swap", icon = "󰓡 " },
      		{ "<leader>pf", group = "function swap", icon = "󰓡 " },
      		{ "<leader>ppi", desc = "swap next inner parameter" },
      		{ "<leader>ppo", desc = "swap next outer parameter" },
      		{ "<leader>ppI", desc = "swap prev inner parameter" },
      		{ "<leader>ppO", desc = "swap prev outer parameter" },
      		{ "<leader>pfi", desc = "swap next inner function" },
      		{ "<leader>pfo", desc = "swap next outer function" },
      		{ "<leader>pfI", desc = "swap prev inner function" },
      		{ "<leader>pfO", desc = "swap prev outer function" },
      	})
      end
    '';
}
