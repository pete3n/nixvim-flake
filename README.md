# Nixvim Dev-shell Environment

This is a Nix flake configuration for Neovim built with the [Nixvim project](https://github.com/nix-community/nixvim)
It is fully configured with LSPs, linters, formatters, debuggers, styling, and
popular navigation plugins. 

## Setup
This flake can be built with the Nix package manager or with a NixOS system
configured with flake support. [Follow these instructions](https://nixos.org/download#download-nix)
 to download and install the Nix package manager for your system. 

Once you have the package manager installed, enable flak support by adding 
the following line to ~/.config/nix/nix.conf or /etc/nix/nix.conf: 
```
experimental-features = nix-command flakes
```
You will need to restart your shell or terminal session for the setting to take effect.

Clone this repo:
```
git clone https://github.com/pete3n/nixvim-flake.git
```

Enter the dev-shell environment with:
```
nix develop
```
or run neovim directly with:
```
nix run .
```
## Styling
- Theme is [Tokyo Night](https://github.com/folke/tokyonight.nvim) with 
[noice](https://github.com/folke/noice.nvim) UI from [@folke](https://github.com/folke)
- [lualine](https://github.com/nvim-lualine/lualine.nvim) with onedark theme

![NixVim Demo](nixvim.gif)

## Language Support
____________________________________________
| Language   | LSP | Lint | Format | Debug |
|------------|:---:|:----:|:------:|:-----:|
| ASM        |  ✔  |      |   ✔    |  ✔*   |
| C          |  ✔  |  ✔   |   ✔    |  ✔*   |
| Cmake      |  ✔  |      |   ✔    |       |
| C++        |  ✔  |  ✔   |   ✔    |  ✔*   |
| CSS        |  ✔  |  ✔   |   ✔    |       |
| Go         |  ✔  |  ✔   |   ✔    |  ✔    |
| HTML       |  ✔  |  ✔   |   ✔    |       |
| Lua        |  ✔  |  ✔   |   ✔    |       |
| JSON       |  ✔  |  ✔   |   ✔    |       |
| Markdown   |  ✔  |  ✔   |   ✔    |       |
| Nix        |  ✔  |  ✔   |   ✔    |       |
| Prisma     |  ✔  |      |   ✔    |       |
| Python     |  ✔  |  ✔   |   ✔    |  ✔    |
| Rust       |  ✔  |  ✔   |   ✔    |  ✔    |
| Shell      |  ✔  |  ✔   |   ✔    |  ✔*   |
| TypeScript |  ✔  |  ✔   |   ✔    |       |
| YAML       |  ✔  |  ✔   |   ✔    |       |
| Zig        |  ✔  |      |   ✔    |  ✔    |
--------------------------------------------
*Debugging is with a GDB/LLDB/BASHDB wrapper through [nvim-gdb](https://github.com/sakhnik/nvim-gdb)
I have been unable to get DAP working correctly for these languages.

## Plugins
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - nvim-cmp source for buffer words
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) - nvim-cmp source for cmdline
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - nvim-cmp source for LSP client
- [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua) - nvim-cmp source for lua
- [cmp-path](https://github.com/hrsh7th/cmp-path) - nvim-cmp source for path
- [conform](https://github.com/stevearc/conform.nvim) - Formatter plugin
- [fugitive](https://github.com/tpope/vim-fugitive) - Git wrapper
- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) - Git integration for buffers
- [harpoon](https://github.com/ThePrimeagen/harpoon) - Fast file/buffer switching
- [lualine](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [luasnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [noice](https://github.com/folke/noice.nvim) - Experimental messaging, cmdline, and popupmenu UI
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Code completion
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) - go configuration extension for DAP
- [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python) - python configuration extension for DAP
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - nvim-dap UI
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) - debugger virtual text
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug adapter protocol client
- [nvim-gdb](https://github.com/sakhnik/nvim-gdb) - Wrapper for GDB, LLDB, BashDB, and PDB/PDB+
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Async linter plugin
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Language Server Protocol config tool
- [nvim-notify](https://github.com/rcarriga/nvim-notify) - Notification manager
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) - File explorer sidebar
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) - Ultra Fold in Neovim
- [oil](https://github.com/stevearc/oil.nvim) - File explorer
- [telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzyfinder
- [treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Syntax aware text-objects
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file) - Parsing system interface
- [typescript-tools-nvim](https://github.com/pmizio/typescript-tools.nvim) - lua Typescript LS replacement
- [undotree](https://github.com/mbbill/undotree) - Undo history visualizer

## Resources
Much of the configuration for this flake was gleaned from numerous instructional
videos and howto guides for Neovim including:

- Keymaps and Harpoon configuration from [ThePrimeagen's video](https://www.youtube.com/watch?v=w7i4amO_zaE)
- LSP setup guide with [TJ DeVries and Bashbunni](https://youtu.be/puWgHa7k3SY?list=PL3PYGQRVAjrMxP5HK45CTnR7Yv-QYR1Qp)
- Linting and Formatting from [Josean Martinez](https://youtu.be/ybUE4D80XSk)
- Telescope and Treesitter setup again [with TJ DeVries](https://youtu.be/stqUbv-5u2s)
- In-depth [Treesitter configuration with Josean Martinez](https://www.youtube.com/watch?v=CEMPq_r8UYQ&list=LL&index=1&t=40s)
- Completions with nvim-cmp [from TJ again](https://youtu.be/_DnmphIwnjo)
- Debugging with DAP with [TJ and Bashbunni](https://youtu.be/0moS8UHupGc)

## Thanks
Big shout out to the Nix and Neovim community for all the awesome plugins, documentation,
videos, and support. There are too many people to thank, but for this project in
particular, I'd like to thank [@vimjoyer](https://github.com/vimjoyer) for piquing 
my interest in Nixvim with [his video](https://youtu.be/b641h63lqy0) and [@GaetanLepage](https://github.com/GaetanLepage) 
for maintining the Nixvim project. 
