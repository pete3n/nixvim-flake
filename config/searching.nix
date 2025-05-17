#All configuration related to searching (Telescope)
{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Help string to display on the Telescope prompt_titles
  telescope_help = "Keymaps <C-/> (Insert) or ? (Normal)";
in
{
  extraPackages = with pkgs; [
    fd
    fzf
    ripgrep
    zoxide
  ];

  extraPlugins =
    [
      pkgs.vimPlugins.advanced-git-search-nvim
      pkgs.vimPlugins.telescope-dap-nvim
      pkgs.vimPlugins.telescope-zoxide
    ]
    ++ [
      (pkgs.vimUtils.buildVimPlugin {
        name = "telescope-cc";
        src = pkgs.fetchFromGitHub {
          owner = "olacin";
          repo = "telescope-cc.nvim";
          rev = "c3cf3489178f945e3efdf0bd15bfb8c353279755";
          hash = "sha256-5l606k9jG1LKKwL5lCy45ZSWiEStbuqm1/tBQXOBpGA=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "telescope-repo";
        src = pkgs.fetchFromGitHub {
          owner = "cljoly";
          repo = "telescope-repo.nvim";
          rev = "a5395a4bf0fd742cc46b4e8c50e657062f548ba9";
          hash = "sha256-cIovB45hfG4lDK0VBIgK94dk2EvGXZtfAJETkQ+lrcw=";
        };
      })
    ];

  plugins = {
    web-devicons.enable = true;
    telescope = {
      enable = true;
      extensions = {
        file-browser.enable = true;
        fzf-native.enable = true;
        live-grep-args.enable = true;
        ui-select.enable = true;
        undo.enable = true;
      };
      enabledExtensions = [
        "advanced_git_search"
        "conventional_commits"
        "dap"
        "live_grep_args"
        "noice"
        "repo"
        "zoxide"
      ];

      luaConfig.post = # lua
        ''
          -- Thanks TJ: https://www.youtube.com/watch?v=xdXE1tOT-qg
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local make_entry = require("telescope.make_entry")
          local conf = require("telescope.config").values

          local find_in_dirs = function(opts)
          	-- TODO: Parse directories with escaped spaces
          	opts = opts or {}
          	vim.ui.input({ prompt = "Enter search directories (space-separated): " }, function(input)
          		if input then
          			local dirs = {}
          			for dir in input:gmatch("%S+") do
          				table.insert(dirs, dir)
          			end

          			if #dirs == 0 then
          				vim.uv.cwd()
          			end

          			require("telescope.builtin").find_files({ search_dirs = dirs,
          				prompt_title = opts.prompt_title})
          		else
          			print("No directories provided.")
          		end
          	end)
          end
          require("telescope.builtin").find_in_dirs = find_in_dirs

					-- TODO: Fix directory input bug
          local find_mg_in_dirs = function(opts)
          	-- TODO: Parse directories with escaped spaces
          	opts = opts or {}
          	vim.ui.input({ prompt = "Enter grep directories (space-separated): " }, function(input)
          		if input then
          			local dirs = {}
          			for dir in input:gmatch("%S+") do
          				table.insert(dirs, dir)
          			end

          			if #dirs == 0 then
          				vim.uv.cwd()
          			end

          			require("telescope.builtin").live_multigrep({ 
          				prompt_title = opts.prompt_title, search_dirs = dirs })
          		else
          			print("No directories provided.")
          		end
          	end)
          end
          require("telescope.builtin").find_mg_in_dirs = find_mg_in_dirs

          local find_scripts = function(opts)
          	opts = opts or {}
          	local scriptnames_output = vim.api.nvim_exec('scriptnames', true)
          	local file_paths = {}


          	for line in scriptnames_output:gmatch("[^\r\n]+") do
          		-- Match optional leading spaces, digits, colon, spaces, and capture the path
          		local path = line:match("^%s*%d+:%s*(.+)")
          		if path then
          			table.insert(file_paths, path)
          		else
          			print("Could not parse line: " .. line)
          		end
          	end

          	local finder = require('telescope.finders').new_table {
          		results = file_paths,
          		entry_maker = function(entry)
          			return {
          				value = entry,
          				display = entry,
          				ordinal = entry,
          			}
          		end,
          	}

          	require('telescope.pickers').new(opts, {
          		prompt_title = "Neovim Scripts",
          		finder = finder,
          		sorter = require('telescope.config').values.generic_sorter(opts),
          		attach_mappings = function(_, map)
          			map('i', '<CR>', function(prompt_bufnr)
          				local selection = require('telescope.actions.state').get_selected_entry()
          				require('telescope.actions').close(prompt_bufnr)
          				vim.cmd("edit " .. selection.value)
          			end)
          			return true
          		end,
          	}):find()
          end
          require('telescope.builtin').find_scripts = find_scripts

          local find_project_files = function(opts)
          	opts = opts or {}
          	local is_inside_work_tree = {}

          	local cwd = vim.fn.getcwd()
          	if is_inside_work_tree[cwd] == nil then
          		vim.fn.system("git rev-parse --is-inside-work-tree")
          		is_inside_work_tree[cwd] = vim.v.shell_error == 0
          	end

          	if is_inside_work_tree[cwd] then
          		opts.prompt_title = "Git Files: ${telescope_help}"
          		require("telescope.builtin").git_files(opts)
          	else
          		opts.prompt_title = "Find Files: ${telescope_help}" 
          		require("telescope.builtin").find_files(opts)
          	end
          end
          require("telescope.builtin").find_project_files = find_project_files

          local live_multigrep = function(opts)
          	opts = opts or {}
          	opts.cwd = opts.cwd or vim.uv.cwd()

          	local finder = finders.new_async_job {
          		command_generator = function(prompt)
          			if not prompt or prompt == "" then
          				return nil
          			end

          			local pieces = vim.split(prompt, "  ")
          			local args = { "rg" }
          			if pieces[1] then
          				table.insert(args, "-e")
          				table.insert(args, pieces[1])
          			end

          			if pieces[2] then
          				table.insert(args, "-g")
          				table.insert(args, pieces[2])
          			end

          			return vim.tbl_flatten({
          				args,
          				{ 
          					"--color=never", 
          					"--no-heading", 
          					"--with-filename", 
          					"--line-number", 
          					"--column", 
          					"--smart-case",
          				},
          			})
          		end,
          		entry_maker = make_entry.gen_from_vimgrep(opts),
          		cwd = opts.cwd,
          	}

          	pickers.new(opts, {
          		debounce = 100,
          		prompt_title = opts.prompt_title,
          		finder = finder,
          		previewer = conf.grep_previewer(opts),
          		sorter = require("telescope.sorters").empty(),
          	}):find()
          end
          require("telescope.builtin").live_multigrep = live_multigrep

          -- Conditionally map telescope extension keys
          local telescope = require("telescope")

          local telescope_extensions = {
          	{ ext = "advanced_git_search", key = "<leader>sG", icon = " ", 
          		desc = "git advanced search", action = "show_custom_functions", 
          		prompt = "Advanced Git: ${telescope_help}" },
          	{ ext = "conventional_commits", key = "<leader>sC", icon = "󱖪 ", 
          		desc = "conventional commits", action = "conventional_commits",
          		prompt = "Conventional Commit Messages: ${telescope_help}" },
          	{ ext = "file_browser", key = "<leader>sB", icon = " ", 
          		desc = "file browser", action = "file_browser", 
          		prompt = "File Browser: ${telescope_help}" },
          	{ ext = "live_grep_args", key = "<leader>sL", icon = "󰑑 ", 
          		desc = "live grep args", action = "live_grep_args", 
          		prompt = "Live Grep Args: ${telescope_help}" },
          	{ ext = "repo", key = "<leader>sr", icon = "󰳐 ", 
          		desc = "git repos", action = "list", 
          		prompt = "Git Repos: ${telescope_help}" },
          	{ ext = "undo", key = "<leader>su", icon = " ", 
          		desc = "undo history", action = "undo", 
          		prompt = "Undo History: ${telescope_help}" },
          	{ ext = "zoxide", key = "<leader>sz", icon = "󰬡 ", 
          		desc = "zoxide list", action = "list", 
          		prompt = "Zoxide List: ${telescope_help}" }
          }

          local function map_telescope_extensions(ext, key, action, prompt, desc, icon)
          	if pcall(telescope.load_extension, ext) then
          		vim.keymap.set("n", key, function()
          			telescope.extensions[ext][action]({ prompt_title = prompt })
          		end, { desc = desc })

          		if wk_available then
          			wk.add({ 
          				{ key, icon = icon, desc = desc } 
          			})
          		end
          	end
          end

          for _, ext in ipairs(telescope_extensions) do
          	map_telescope_extensions(ext.ext, ext.key, ext.action, ext.prompt, ext.desc, ext.icon)
          end

          -- Conditionally map telescope dap extension keys					
          if pcall(telescope.load_extension, "dap") then

          		if wk_available then
          			wk.add({ 
          				{ "<leader>se", group = "debugging search", icon = " "},
          			})
          		end
						
          	local telescope_dap_extension_keymaps = {
          		{ key = "<leader>seb", icon = " ", desc = "breakpoints", action = "list_breakpoints", 
          			prompt = "DAP Breakpoints: ${telescope_help}" },
          		{ key = "<leader>sec", icon = " ", desc = "commands", action = "commands", 
          			prompt = "DAP Commands: ${telescope_help}" },
          		{ key = "<leader>sef", icon = "󰋴 ", desc = "frames", action = "frames", 
          			prompt = "DAP Frames: ${telescope_help}" },
          		{ key = "<leader>seo", icon = " ", desc = "configurations", action = "configurations", 
          			prompt = "DAP Configurations: ${telescope_help}" },
          		{ key = "<leader>sev", icon = "󰫧 ", desc = "variables", action = "variables", 
          			prompt = "DAP Variables: ${telescope_help}" },
          	}
          	local function setup_dap_functions(key, action, prompt, desc, icon)
          		if telescope.extensions.dap then
          			vim.keymap.set("n", key, function()
          				telescope.extensions.dap[action]({ prompt_title = prompt })
          			end, { desc = desc })
          		end

          		if wk_available then
          			wk.add({ 
          				{ key, icon = icon, desc = desc },
          			})
          		end
          	end

          	for _, func in ipairs(telescope_dap_extension_keymaps) do
          		setup_dap_functions(func.key, func.action, func.prompt, func.desc, func.icon)
          	end
          end

          -- Conditionally map all other searching keys for which-key
					if wk_available then
          	wk.add ({
          		-- Searching group 
          		{"<leader>s", group = "searching", icon = " ", },
          		{"<leader>s/", icon = "󱈅 ", desc = "current buffer fzf (/)", },
          		{"<leader>s?", icon = "󱩾 ", desc = "recent files (?)", },
          		{"<leader>s<space>", icon = "󱈆 ", desc = "buffer names (󱁐)", },
          		{"<leader>sb", icon = "", desc = "git branch", },
          		{"<leader>sc", icon = "", desc = "commands", },
          		{"<leader>sd", icon = " ", desc = "diagnostics", },
          		{"<leader>sf", icon = " ", desc = "files in dirs", },
          		{"<leader>sg", icon = " ", desc = "git status", },
          		{"<leader>sh", icon = "󰋖 ", desc = "help", },
          		{"<leader>sk", icon = " ", desc = "keymaps", },
          		{"<leader>sl", icon = "󰑑 ", desc = "live grep", },
          		{"<leader>sm", icon = "󱈧 ", desc = "multi grep", },
          		{"<leader>sM", icon = " ", desc = "multi grep in dirs", },
          		{"<leader>sp", icon = " ", desc = "project files", },
          		{"<leader>ss", icon = " ", desc = "symbols", },
          		{"<leader>sS", icon = "󰯃 ", desc = "neovim scripts", },
          		{"<leader>sw", icon = " ", desc = "current word", },
          	})
          end
        '';
    };
    neoclip = {
      enable = true;
      luaConfig.post = # lua
        ''
          if pcall(require, "telescope") then
          	vim.keymap.set("n", "<leader>sn", function() 
          		require('telescope').extensions.neoclip.default({
          			prompt_title = "Neoclip Registers: ${telescope_help}" 
          		})
          	end)
          	if wk_available then
          		wk.add ({
          			{"<leader>sn", icon = "󱘞 ", desc = "neoclip", },
          		})
          	end
          end
        '';
    };
  };

  keymaps =
    [
      # Unconditional searching keymaps
      {
        key = "<C-j>";
        mode = "n";
        action = "<cmd>cnext<CR>zz";
        options = {
          desc = "next quickfix";
        };
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<cmd>cprev<CR>zz";
        options = {
          silent = true;
          desc = "prev quickfix";
        };
      }
      {
        key = "<leader>k";
        mode = "n";
        action = "<cmd>lnext<CR>zz";
        options = {
          silent = true;
          desc = "next quickfix location";
        };
      }
      {
        key = "<leader>j";
        mode = "n";
        action = "<cmd>lprev<CR>zz";
        options = {
          silent = true;
          desc = "prev quickfix location";
        };
      }
      {
        key = "n";
        mode = "n";
        action = "nzzzv";
        options = {
          silent = true;
          desc = "next match (center cursor)";
        };
      }
      {
        key = "N";
        mode = "n";
        action = "Nzzzv";
        options = {
          silent = true;
          desc = "previous match (center cursor)";
        };
      }
    ]
    # Telescope keymaps, these are defined using global keymaps since the
    # telescope plugin keymapping doesn't support raw lua
    ++ (lib.optionals config.plugins.telescope.enable [
      {
        key = "<leader>?";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").oldfiles({
            		prompt_title = "Recent Files: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "recent files";
        };
      }
      {
        key = "<leader><space>";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").buffers({
            		prompt_title = "Buffers: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "[ ] buffer names";
        };
      }
      {
        key = "<leader>/";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").current_buffer_fuzzy_find({
            		prompt_title = "Buffer Fuzzy Find: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "[/] current buffer forward";
        };
      }
      {
        key = "<leader>sc";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").commands({ 
            		prompt_title = "Commands: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "commands";
        };
      }
      {
        key = "<leader>sd";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").diagnostics({
            		prompt_title = "Diagnostics: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "diagnostics";
        };
      }
      {
        key = "<leader>sh";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").help_tags({
            		prompt_title = "Help: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "help";
        };
      }
      {
        key = "<leader>sk";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").keymaps({
            		prompt_title = "Keymaps: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "keymaps";
        };
      }
      {
        key = "<leader>sl";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").live_grep({
            		prompt_title = "Live Grep: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "live grep";
        };
      }
      {
        key = "<leader>sw";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").grep_string({
            		prompt_title = "Current Word: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "current word";
        };
      }
      {
        key = "<leader>s/";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").current_buffer_fuzzy_find({
            		prompt_title = "Buffer Fuzzy Find: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "project files";
        };
      }
      {
        key = "<leader>s?";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").oldfiles({
            		prompt_title = "Recent Files: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "recent files";
        };
      }
      {
        key = "<leader>s<space>";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").git_branches({ 
            		prompt_title = "Git Branches: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "buffers";
        };
      }
      {
        key = "<leader>sb";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").git_branches({ 
            		prompt_title = "Git Branches: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "git branch";
        };
      }
      {
        key = "<leader>sf";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").find_in_dirs({ 
            		prompt_title = "Find Files: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "files in dirs";
        };
      }
      {
        key = "<leader>sg";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").git_status({ 
            		prompt_title = "Git Status: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "git status";
        };
      }
      {
        key = "<leader>sm";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").live_multigrep({ 
            		prompt_title = "Multi Grep (󱁐 󱁐 between args): ${telescope_help}" })
            	end
          '';
        options = {
          desc = "multi grep";
        };
      }
      {
        key = "<leader>sM";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").find_mg_in_dirs({
            		prompt_title = "Multi Grep (󱁐 󱁐 between args): ${telescope_help}" })
            	end
          '';
        options = {
          desc = "multi grep in dirs";
        };
      }
      {
        key = "<leader>sp";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").find_project_files({
            		prompt_title = "Project Files: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "project files";
        };
      }
      {
        key = "<leader>ss";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").lsp_document_symbols({
            		prompt_title = "Document Symbols: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "neovim scripts";
        };
      }{
        key = "<leader>sS";
        mode = "n";
        action.__raw = # lua
          ''
            	function() require("telescope.builtin").find_scripts({
            		prompt_title = "Neovim Scripts: ${telescope_help}" })
            	end
          '';
        options = {
          desc = "neovim scripts";
        };
      }
    ]);
  # Non-telescope based searching keymaps
  extraConfigLuaPost = # lua
    ''
			if wk_available then
      	wk.add ({
      		-- Normal mode group
      		{"/", icon = "󱈅 ", desc = "search current buffer", },
      		{"<leader><space>", icon = "󱈆 ", desc = "search buffer names", },

      		-- Quickfixing group
      		{"<leader>q", icon = "󰑮 ", group = "quickfixing", },
      		{"<leader>qk", icon = " ", "<cmd>cnext<CR>", desc= "next quickfix (^ K)", },
      		{"<leader>qj", icon = " ", "<cmd>cprev<CR>", desc= "prev quickfix (^ J)", },
      	})
      end
    '';
}
