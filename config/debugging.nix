# All configuration related to debugging code
{
  pkgs,
  lib,
  config,
  ...
}:
{
  extraPackages =
    (with pkgs; [
      bashdb
      delve
      gcc14
      go
      lldb_19
			vscode-extensions.vadimcn.vscode-lldb
      llvmPackages_19.bintools-unwrapped
      python314Full
    ])
    ++ (
      if pkgs.stdenv.isDarwin then
        null
      else
        [
          pkgs.gdb
          pkgs.rr
        ]
    ); # gdb and rr not supported on Darwin

  extraPlugins = [ pkgs.vimPlugins.nvim-nio ];
	
	plugins.rustaceanvim.settings.dap.autoloadConfigurations = true;

  plugins.dap = {
    enable = true;
    extensions = {
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      dap-go.enable = true;
      dap-python.enable = true;
    };
  };

  keymaps = lib.concatLists [
    (
      if config.plugins.dap.enable then
        [
          {
            key = "<leader>db";
            mode = "n";
            action = "<cmd>lua require'dap'.toggle_breakpoint()<CR>";
            options = {
              silent = true;
              desc = "toggle breakpoint";
            };
          }
          {
            key = "<leader>dB";
            mode = "n";
            action = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
            options = {
              silent = true;
              desc = "set breakpoint";
            };
          }
          {
            key = "<leader>de";
            mode = "n";
            action = "<cmd>lua require'dap'.repl.open()<CR>";
            options = {
              silent = true;
              desc = "open repl";
            };
          }
          {
            key = "<leader>dp";
            mode = "n";
            action = "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>";
            options = {
              silent = true;
              desc = "log point message";
            };
          }
          {
            key = "<leader>de";
            mode = "n";
            action = "<cmd>lua require'dap'.terminate()<CR>";
            options = {
              silent = true;
              desc = "log point message";
            };
          }
          {
            key = "<F5>";
            mode = "n";
            action = "<cmd>lua require'dap'.continue()<CR>";
            options = {
              silent = true;
              desc = "continue debugging";
            };
          }
          {
            key = "<leader>dj";
            mode = "n";
            action = "<cmd>DapContinue<CR>";
            options = {
              silent = true;
              desc = "continue debugging (F5)";
            };
          }
          {
            key = "<F10>";
            mode = "n";
            action = "<cmd>lua require'dap'.step_over()<CR>";
            options = {
              silent = true;
              desc = "step over";
            };
          }
          {
            key = "<leader>dk";
            mode = "n";
            action = "<cmd>lua require'dap'.step_over()<CR>";
            options = {
              silent = true;
              desc = "step over (F10)";
            };
          }
          {
            key = "<F11>";
            mode = "n";
            action = "<cmd>lua require'dap'.step_into()<CR>";
            options = {
              silent = true;
              desc = "step into";
            };
          }
          {
            key = "<leader>dl";
            mode = "n";
            action = "<cmd>lua require'dap'.step_into()<CR>";
            options = {
              silent = true;
              desc = "step into (F11)";
            };
          }
          {
            key = "<F12>";
            mode = "n";
            action = "<cmd>lua require'dap'.step_out()<CR>";
            options = {
              silent = true;
              desc = "step out";
            };
          }
          {
            key = "<leader>dh";
            mode = "n";
            action = "<cmd>lua require'dap'.step_out()<CR>";
            options = {
              silent = true;
              desc = "step out (F12)";
            };
          }
          {
            key = "<leader>dr";
            mode = "n";
            action = "<cmd>lua require'dap'.run_to_cursor()<CR>";
            options = {
              silent = true;
              desc = "step out (F12)";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.dap.extensions.dap-go.enable then
        [
          {
            key = "<leader>dgt";
            mode = "n";
            action = ":lua require'dap-go'.debug_test()<CR>";
            options = {
              silent = true;
              desc = "go debug test";
            };
          }
          {
            key = "<leader>dgl";
            mode = "n";
            action = ":lua require'dap-go'.debug_last()<CR>";
            options = {
              silent = true;
              desc = "go debug last";
            };
          }
        ]
      else
        [ ]
    )
    (
      if config.plugins.dap.extensions.dap-ui.enable then
        [
          {
            key = "<leader>du";
            mode = "n";
            action.__raw = "function() require('dapui').open() end";
            options = {
              silent = true;
              desc = "open dapui";
            };
          }
          {
            key = "<leader>dU";
            mode = "n";
            action.__raw = "function() require('dapui').close() end";
            options = {
              silent = true;
              desc = "close dapui";
            };
          }
          {
            key = "<leader>d=";
            mode = "n";
            action.__raw = "function() require('dapui').eval(nil, { enter = true }) end";
            options = {
              silent = true;
              desc = "eval ( 󱁐 = )";
            };
          }
          {
            key = "<leader>=";
            mode = "n";
            action.__raw = "function() require('dapui').eval(nil, { enter = true }) end";
            options = {
              silent = true;
              desc = "debugging eval";
            };
          }
        ]
      else
        [ ]
    )
  ];
  #extraPlugins = with pkgs.vimPlugins; [ nvim-gdb ];

  extraConfigLuaPost = # lua
    ''
      -- Conditional configuration for dap and dapui
      local dap_deps, dap, dapui = pcall(function() 
      	return require("dap"), require("dapui") 
      end)

      if dap_deps then
      	local dap = require("dap")
      	local dapui = require("dapui")

      	dap.set_log_level('DEBUG')

      	dap.adapters.lldb = {
      			type = 'executable',
      			command = 'lldb-dap', 
      			name = 'lldb'
      	}

      	dap.adapters.gdb = {
      			type = "executable",
      			command = "gdb",
      			args = { "-i", "dap" }
      	}

      	dap.listeners.before.attach.dapui_config = function()
      		dapui.open()
      	end
      	dap.listeners.before.launch.dapui_config = function()
      		dapui.open()
      	end
      	dap.listeners.before.event_terminated.dapui_config = function()
      		dapui.close()
      	end
      	dap.listeners.before.event_exited.dapui_config = function()
      		dapui.close()
      	end

      	dap.configurations.c = {
      		{
      			name = "Launch",
      			type = "gdb",
      			request = "launch",
      			program = function()
      				return vim.fn.input('Path of the executable: ', vim.fn.getcwd() .. '/', 'file')
      			end,
      			cwd = "''${workspaceFolder}",
      		},
      	}

      	--dap.configurations.rust = {
      	--	{
      	--		name = "Launch (LLDB)",
      	--		type = "lldb",
      	--		request = "launch",
      	--		program = function()
      	--			return vim.fn.input('Path of the executable: ', vim.fn.getcwd() .. '/', 'file')
      	--		end,
      	--		cwd = "''${workspaceFolder}",
				--		stopOnEntry = false;
      	--	},
      	--}

      	dap.configurations.zig = {
      		{
      			name = 'Launch',
      			type = 'lldb',
      			request = 'launch',
      			program = function()
      				return vim.fn.input('Root path of executable: ', vim.fn.getcwd() .. '/', 'file')
      					end,
      			cwd = "''${workspaceFolder}",
      			stopOnEntry = false,
      			args = {},
      		},
      	}
      	-- Conditionally map telescope dap extension keys					
      	if pcall(require, "telescope") then
      		local telescope = require("telescope")
      		local telescope_help = 'Keymaps <C-/> (Insert) or ? (Normal)';

      		if pcall(telescope.load_extension, "dap") then
      			local wk_available, wk = pcall(require, "which-key")
      			local telescope_dap_functions = {
      				{ key = "<leader>dsb", icon = " ", desc = "breakpoints", action = "list_breakpoints", 
      					prompt = "DAP Breakpoints: " .. telescope_help },
      				{ key = "<leader>dsc", icon = " ", desc = "commands", action = "commands", 
      					prompt = "DAP Commands: " .. telescope_help },
      				{ key = "<leader>dsf", icon = "󰋴 ", desc = "frames", action = "frames", 
      					prompt = "DAP Frames: " .. telescope_help },
      				{ key = "<leader>dso", icon = " ", desc = "configurations", action = "configurations", 
      					prompt = "DAP Configurations: " .. telescope_help },
      				{ key = "<leader>dsv", icon = "󰫧 ", desc = "variables", action = "variables", 
      					prompt = "DAP Variables: " .. telescope_help },
      			}
      			local function setup_dap_functions(key, action, prompt, desc, icon)
      				if telescope.extensions.dap then
      					vim.keymap.set("n", key, function()
      						telescope.extensions.dap[action]({ prompt_title = prompt })
      					end, { desc = desc })
      				end

      				if wk_available then
      					wk.add({ 
      						{ "<leader>ds", group = "searching", icon = " "},
      						{ key, icon = icon, desc = desc },
      					})
      				end
      			end

      			for _, func in ipairs(telescope_dap_functions) do
      				setup_dap_functions(func.key, func.action, func.prompt, func.desc, func.icon)
      			end
      		end
      	end

      	if pcall(require, "which-key") then
      		local wk = require("which-key")
      		wk.add ({
      			{ "<leader>d", group = "debugging", icon = "󰃤 "},
						{ "<leader>dg", group = "go", icon = " "},
      		})
      	end
      end
    '';
}
