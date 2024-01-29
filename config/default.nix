{ pkgs, ...}:
{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
  ];

  colorschemes.tokyonight = {
    enable = true;
  };
  #viAlias = true;
  #vimAlias = true;
  #options = {
  #  number = true;
  #  relativenumber = true;
  #  shiftwidth = 2;
  #};

  plugins = {
    telescope.enable = true;
    oil.enable = true;
    treesitter.enable = true;
    lsp = {
      # enable = true;
      servers = {
	#asm-lsp.enable = true;
	bashls.enable = true;
	clangd.enable = true;
	cmake.enable = true;
	cssls.enable = true;
	#dockerls.enable = true;
	eslint.enable = true;
	gopls.enable = true;
	html.enable = true;
	jsonls.enable = true;
	kotlin-language-server.enable = true;
	lua-ls.enable = true;
	#marksman.enable = true;
	nixd.enable = true;
	prismals.enable = true;
	ruff-lsp.enable = true;
	rust-analyzer = {
	  enable = true;
	  installCargo = true;
	  installRustc = true;
	};
	tsserver.enable = true;
	yamlls.enable = true;
	zls.enable = true; 
      };
    };
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
  ];
 # extraConfigLua = ''
 #   require
 # '';
}
