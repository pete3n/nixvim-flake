# All configuration related formatting languages
{
  lib,
  config,
  pkgs,
  ...
}:
let
  ls = config.language_support;
  inherit (lib) mkIf;
in
{
  extraPackages = with pkgs; [
    mbake # Makefile formatter - TODO: implement
    python311Packages.pylatexenc
  ];

  # Show whitespace for stupid languages that are sensitive to whitespace.
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [
        "make"
        "yaml"
        "python"
      ];
      command = ''
        setlocal list
        setlocal listchars=tab:▸\ ,trail:·,extends:…,precedes:…,nbsp:␣
      '';
    }
  ];

  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save =
          # lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              local function on_format(err)
                if err and err:match("timeout$") then
                  slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              return { timeout_ms = 2000, lsp_fallback = true }, on_format
             end
          '';

        format_after_save =
          # lua
          ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              return { lsp_fallback = true }
            end
          '';
        notify_on_error = true;
        formatters_by_ft =
          {
            asm = [ "asmfmt" ];
            c = [ "astyle" ];
            cpp = [ "astyle" ];
            css = [
              "prettierd"
              "prettier"
            ];
            cmake = [ "cmake-format" ];
            go = [
              "goimports"
              "gofumpt"
              "golines"
            ];
            html = [
              "prettierd"
              "prettier"
            ];
            javascript = [
              "prettierd"
              "prettier"
            ];
            javascriptreact = [ "prettier" ];
            json = [ "prettier" ];
            markdown = [ "prettier" ];
            python = [
              "isort"
              "ruff_format"
            ];
            # rust = [ "rustfmt" ];
            sh = [ "shfmt" ];
            text = [ "par" ];
            typescript = [
              "prettierd"
              "prettier"
            ];
            typescriptreact = [ "prettier" ];
            yaml = [
              "prettierd"
              "prettier"
            ];
          }
          // (mkIf ls.lua.enable {
            lua = [ "stylua" ];
          })
          // (mkIf ls.nix.enable {
            nix = [ "nixfmt" ];
          });

        formatters = {
          asmfmt = {
            command = "${lib.getExe pkgs.asmfmt}";
            stdin = true;
          };
          astyle = {
            command = "${lib.getExe pkgs.astyle}";
          };

          cmake-format = {
            command = "${lib.getExe pkgs.cmake-format}";
          };

          gofumpt = {
            command = "${lib.getExe pkgs.gofumpt}";
          };

          golines = {
            command = "${lib.getExe' pkgs.golines "golines"}";
          };

          goimports = {
            command = "${lib.getExe' pkgs.gotools "goimports"}";
          };

          isort = {
            command = "${lib.getExe pkgs.isort}";
          };

          par = {
            command = "${lib.getExe pkgs.par}";
            args = [ "80" ];
            stdin = true;
          };

          prettier = {
            command = "${lib.getExe pkgs.nodePackages.prettier}";
          };

          prettierd = {
            command = "${lib.getExe pkgs.prettierd}";
          };

          ruff = {
            command = "${lib.getExe pkgs.ruff}";
          };

          rustfmt = {
            command = "${lib.getExe pkgs.rustfmt}";
          };

            shfmt = {
              command = "${lib.getExe pkgs.shfmt}";
            };
          }
          // (mkIf ls.lua.enable {
            stylua = {
              command = "${lib.getExe pkgs.stylua}";
              args = [
                "--search-parent-directories"
                "--stdin-filepath"
                "$FILENAME"
                "--"
                "-"
              ];
              stdin = true;
            };
          })
          // (mkIf ls.nix.enable {
            nixfmt = {
              command = "${lib.getExe pkgs.nixfmt}";
            };
          });
      };
    };
    render-markdown.enable = true;
  };

  keymaps = [
    {
      key = "<leader>ff";
      mode = [
        "n"
        "v"
      ];
      action = ":lua _G.format_with_conform()<CR>";
      options = {
        silent = true;
        desc = "format with conform";
      };
    }
    {
      key = "<leader>ft";
      mode = "n";
      action = "<cmd>FormatToggle!<CR>";
      options = {
        silent = true;
        desc = "toggle format-on-save";
      };
    }
    {
      key = "<leader>fT";
      mode = "n";
      action = "<cmd>FormatToggle<CR>";
      options = {
        silent = true;
        desc = "toggle format-on-save globally";
      };
    }
    {
      key = "<leader>fr";
      mode = "n";
      action = "<cmd>RenderMarkdown toggle<CR>";
      options = {
        silent = true;
        desc = "render markdown toggle";
      };
    }
  ];

  extraConfigLuaPost = # lua
    ''
      slow_format_filetypes = {}

      vim.api.nvim_create_user_command("FormatDisable", function(args)
      	if args.bang then
      		-- FormatDisable! will disable formatting just for this buffer
      		vim.b.disable_autoformat = true
      	else
      		vim.g.disable_autoformat = true
      	end
      end, {
      	desc = "Disable autoformat-on-save",
      	bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
      	vim.b.disable_autoformat = false
      	vim.g.disable_autoformat = false
      end, {
      	desc = "Re-enable autoformat-on-save",
      })
      vim.api.nvim_create_user_command("FormatToggle", function(args)
      	local new_state
      	if args.bang then
      		-- Toggle formatting for current buffer
      		vim.b.disable_autoformat = not vim.b.disable_autoformat
      		new_state = vim.b.disable_autoformat and "disabled" or "enabled"
      		vim.notify("Format on-save for current buffer: " .. new_state)
      	else
      		-- Toggle formatting globally
      		vim.g.disable_autoformat = not vim.g.disable_autoformat
      		new_state = vim.g.disable_autoformat and "disabled" or "enabled"
      		vim.notify("Format on-save globally: " .. new_state)
      	end
      end, {
      	desc = "Toggle autoformat-on-save",
      	bang = true,
      })

      -- On-demand formatting function for conform
      _G.format_with_conform = function()
      	local conform = require("conform")
      	conform.format({
      		lsp_fallback = true,
      		async = false,
      		timeout_ms = 2000,
      	})
      end

      if wk_available then
      	wk.add({
      		{ "<leader>f", group = "formatting", icon = "󰉢 " },
      		{ "<leader>ff", icon = "󰉢 ", desc = "format with conform", },
      		{ "<leader>ft", icon = "󰔡 ", desc = "toggle format on-save" },
      		{ "<leader>fT", icon = "󰔡 ", desc = "toggle format on-save globally" },
      		{ "<leader>fr", icon = " ", desc = "render markdown toggle", },
      	})
      end
    '';
}
