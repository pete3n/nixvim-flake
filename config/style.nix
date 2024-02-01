{pkgs, ...}: {
  colorschemes.tokyonight = {
    enable = true;
    style = "night";
    transparent = true;
  };
  plugins = {
    lualine = {
      enable = true;
      iconsEnabled = false;
      globalstatus = true;
      theme = "onedark";
    };

    noice = {
      enable = true;
      presets = {
        bottom_search = true;
      };
    };
    notify.enable = true;
  };
  extraConfigLua = ''
    -- Noice recommended config
    require("noice").setup({
    lsp = {
    	override = {
    		["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    		["vim.lsp.util.stylize_markdown"] = true,
    		["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    	},
    },
    })
  '';
}
