# Nixvim Dev-shell Environment

This is a Nix flake configuration built with the [Nixvim project](https://github.com/nix-community/nixvim)
It is fully configured with LSPs, linters, formatters, debuggers, styling, and
popular navigation plugins. See

## Setup
This flake can be built with the Nix package manager or with a NixOS system
configured with flake support. [Follow these instrutions](https://nixos.org/download#download-nix)
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

## Styling
- Theme is [Tokyo Night](https://github.com/folke/tokyonight.nvim) with 
[noice](https://github.com/folke/noice.nvim) UI from @folke
- [lualine](https://github.com/nvim-lualine/lualine.nvim) with onedark theme

![NixVim Demo](nixvim.gif)


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
particular, I'd like to thank @vimjoyer for piquing my interest in Nixvim with [his video](https://youtu.be/b641h63lqy0)
and @GaetanLepage for maintining the Nixvim project. 
