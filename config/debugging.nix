# All configuration related to debugging code
{ pkgs, ... }:
{
  extraPackages =
    (with pkgs; [
      bashdb
      delve
      lldb_19
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

  keymaps = [
    {
      key = "<leader>db";
      mode = "n";
      action = ":lua require'dap'.toggle_breakpoint()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "toggle breakpoint";
      };
    }
    {
      key = "<leader>dB";
      mode = "n";
      action = ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "set breakpoint";
      };
    }
    {
      key = "<leader>dg";
      mode = "n";
      action = ":lua require'dap-go'.debug_test()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "go debug test";
      };
    }
    {
      key = "<leader>de";
      mode = "n";
      action = ":lua require'dap'.repl.open()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "open repl";
      };
    }
    {
      key = "<leader>dp";
      mode = "n";
      action = ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "log point message";
      };
    }
    {
      key = "<F5>";
      mode = "n";
      action = ":lua require'dap'.continue()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "continue debugging";
      };
    }
    {
      key = "<leader>dj";
      mode = "n";
      action = ":lua require'dap'.continue()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "continue debugging (F5)";
      };
    }
    {
      key = "<F10>";
      mode = "n";
      action = ":lua require'dap'.step_over()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "step over";
      };
    }
    {
      key = "<leader>dk";
      mode = "n";
      action = ":lua require'dap'.step_over()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "step over (F10)";
      };
    }
    {
      key = "<F11>";
      mode = "n";
      action = ":lua require'dap'.step_into()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "step into";
      };
    }
    {
      key = "<leader>dl";
      mode = "n";
      action = ":lua require'dap'.step_into()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "step into (F11)";
      };
    }
    {
      key = "<F12>";
      mode = "n";
      action = ":lua require'dap'.step_out()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "step out";
      };
    }
    {
      key = "<leader>dh";
      mode = "n";
      action = ":lua require'dap'.step_out()<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "step out (F12)";
      };
    }
  ];

  plugins.dap = {
    enable = true;
    extensions = {
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      dap-go.enable = true;
      dap-python.enable = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [ nvim-gdb ];

  extraConfigLuaPost = # lua
    ''
               local dap, dapui = require("dap"), require("dapui")
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

              dap.configurations.rust = {
            	{
            		name = 'Launch',
            		type = 'lldb',
            		request = 'launch',
            		program = function()
            			return vim.fn.input('Path of the executable: ', vim.fn.getcwd() .. '/', 'file')
            		end,
            		cwd = "''${workspaceFolder}",
            		stopOnEntry = false,
            		args = {},
            	},
            }

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

      			if pcall(require, "which-key") then
      				local wk = require("which-key")
      				wk.add ({
      					{ "<leader>d", group = "debugging", icon = "󰃤 "},
      				})
      			end
    '';
}
