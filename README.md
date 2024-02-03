# Nixvim Dev-shell Environment

This is a Nix flake configuration built with the [Nixvim project](https://github.com/nix-community/nixvim)
It is fully configured with LSPs, linters, formatters, debuggers, styling, and
popular navigation plugins. See

## Setup

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

## Plugins

## Styling

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

