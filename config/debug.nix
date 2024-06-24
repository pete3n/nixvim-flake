{pkgs, ...}: {
  plugins.dap = {
    enable = true;
    extensions = {
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      dap-go.enable = true;
      dap-python.enable = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    nvim-gdb
  ];

  extraConfigLua =
    /*
    lua
    */
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

        local dap = require('dap')
        dap.set_log_level('DEBUG')

        dap.adapters.lldb = {
            type = 'executable',
            command = '${pkgs.lldb_17}/bin/lldb-vscode', -- adjust as needed, must be absolute path
            name = 'lldb'
        }

        local dap = require("dap")
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" }
        }

        local dap = require("dap")
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

        local dap = require('dap')
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
    '';
}
