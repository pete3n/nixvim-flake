{ lib, pkgs, ... }:
{
  # Auto formate on save toggle functions from: https://github.com/dc-tec/nixvim
  extraConfigLuaPre =
    # lua
    ''
      local slow_format_filetypes = {}

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
        if args.bang then
          -- Toggle formatting for current buffer
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          -- Toggle formatting globally
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, {
        desc = "Toggle autoformat-on-save",
        bang = true,
      })
    '';

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

              return { timeout_ms = 200, lsp_fallback = true }, on_format
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
        formatters_by_ft = {
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
          lua = [ "stylua" ];
          markdown = [ "prettier" ];
          nix = [ "nixfmt-rfc-style" ];
          python = [
            "isort"
            "black"
          ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
          typescript = [
            "prettierd"
            "prettier"
          ];
          typescriptreact = [ "prettier" ];
          yaml = [
            "prettierd"
            "prettier"
          ];
        };
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

          black = {
            command = "${lib.getExe pkgs.black}";
          };

          nixfmt-rfc-style = {
            command = "${lib.getExe pkgs.nixfmt-rfc-style}";
          };

          prettier = {
            command = "${lib.getExe pkgs.nodePackages.prettier}";
          };

          prettierd = {
            command = "${lib.getExe pkgs.prettierd}";
          };

          rustfmt = {
            command = "${lib.getExe pkgs.rustfmt}";
          };

          shfmt = {
            command = "${lib.getExe pkgs.shfmt}";
          };

          stylua = {
            command = "${lib.getExe pkgs.stylua}";
          };
        };
      };
    };
  };
}
