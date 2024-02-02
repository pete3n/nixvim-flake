{pkgs, ...}: {
  plugins.lint = {
    enable = true;
    lintersByFt = {
      c = ["clangtidy"];
      cpp = ["clangtidy"];
      css = ["eslint_d"];
      gitcommit = ["commitlint"];
      go = ["golangcilint"];
      javascript = ["eslint_d"];
      javascriptreact = ["eslint_d"];
      json = ["jsonlint"];
      lua = ["luacheck"];
      markdownlint = ["markdownlint"];
      nix = ["nix"];
      python = ["ruff"];
      sh = ["shellcheck"];
      typescript = ["eslint_d"];
      typescriptreact = ["eslint_d"];
      yaml = ["yamllint"];
    };
  };
  extraConfigLua = ''
      -- Linting function
      local lint = require("lint")
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      	group = lint_augroup,
      	callback = function()
      		lint.try_lint()
      	end,
      })

    local lint_progress = function()
    local linters = require("lint").get_running()
    if #linters == 0 then
    		return "󰦕"
    end
    	return "󱉶 " .. table.concat(linters, ", ")
    end

      vim.keymap.set("n", "<leader>l", function()
      	lint.try_lint()
      end, { desc = "Trigger linting for current file" })
  '';
}
