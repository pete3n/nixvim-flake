{pkgs, ...}: {
  plugins.lint = {
    enable = true;
    lintersByFt = {
      c = ["clangtidy"];
      cpp = ["clangtidy"];
      gitcommit = ["commitlint"];
      javascript = ["eslint_d"];
      javascriptreact = ["eslint_d"];
      json = ["jsonlint"];
      lua = ["luacheck"];
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

    vim.keymap.set("n", "<leader>l", function()
    	lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  '';
}
