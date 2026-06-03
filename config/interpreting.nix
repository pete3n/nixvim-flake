# All configuration related to LSPs
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
  extraPackages =
    with pkgs;
    [
      asm-lsp
      bash-language-server
      cargo
      cmake-language-server
      go
      gopls
      marksman
      ruff
      rust-analyzer
      rustc
      superhtml
      typescript
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      zig
      zls
    ]
    ++ lib.optional ls.lua.enable lua-language-server
    ++ lib.optional ls.nix.enable pkgs.nixd;

  extraPlugins = with pkgs.vimPlugins; [
    nvim-lspconfig
    typescript-tools-nvim
    webapi-vim
  ];

  diagnostic.settings = {
    virtual_lines = {
      current_line = true;
    };
    virtual_text = false;
  };

  lsp = {
    servers = {
      "*" = {
        enable = true;
        config = {
          capabilities = {
            textDocument = {
              semanticTokens = {
                multilineTokenSupport = true;
              };
            };
          };
          root_markers = [
            ".git"
          ];
        };
      };
      # TODO: Fix this https://github.com/bergercookie/asm-lsp/issues/193
      asm_lsp = {
        enable = true;
      };
      bashls = {
        enable = true;
      };
      clangd = {
        enable = true;
      };
      cmake = {
        enable = true;
      };
      cssls = {
        enable = true;
      };
      eslint = {
        enable = true;
      };
      gopls = {
        enable = true;
      };
      jsonls = {
        enable = true;
      };
      lua_ls = mkIf ls.lua.enable {
        enable = true;
        config = {
          cmd = [
            "lua-language-server"
          ];
          filetypes = [
            "lua"
          ];
          root_markers = [
            ".git"
            "lua_ls_config.json"
            "init.lua"
          ];
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false;
              };
              telemetry = {
                enable = false;
              };
              diagnostics = {
                globals = [ "vim" ];
              };
            };
          };
        };
      };
      nixd = mkIf ls.nix.enable {
        enable = true;
        config = {
          cmd = [ "nixd" ];
          filetypes = [ "nix" ];
          root_markers = [
            "flake.nix"
            "default.nix"
            ".git"
          ];

          settings = {
            nixd = {
              nixpkgs = {
                expr = # nix
                  ''
                    import <nixpkgs> { }
                  '';
              };
              formatting = {
                command = [ "nixfmt" ];
              };
              options = {
                nixos = {
                  expr = # nix
                    ''
                      (builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations."framework16".options
                    '';
                };
                home_manager = {
                  expr = # nix
                    ''
                      (builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."pete@framework16".options
                    '';
                };
              };
            };
          };
        };
      };

      ruff = {
        enable = true;
        config = {
          filetypes = [ "python" ];
        };
      };
      rust_analyzer = {
        enable = true;
        config = {
          installCargo = true;
          installRustc = true;
        };
      };
      superhtml = {
        enable = true;
      };
      ts_ls = {
        enable = true;
      };
      yamlls = {
        enable = true;
      };
      zls = {
        enable = true;
      };
    };
  };

  plugins = {
    lspconfig.enable = true;
    rustaceanvim = {
      enable = true;
      settings.server = {
        default_settings = {
          rust-analyzer = {
            cargo = {
              buildScripts.enable = true;
              features = "all";
            };

            diagnostics = {
              enable = true;
              styleLints.enable = true;
            };

            checkOnSave = true;
            check = {
              command = "clippy";
              features = "all";
            };

            files = {
              excludeDirs = [
                ".cargo"
                ".direnv"
                ".git"
                "node_modules"
                "target"
              ];
            };

            inlayHints = {
              bindingModeHints.enable = true;
              closureStyle = "rust_analyzer";
              closureReturnTypeHints.enable = "always";
              discriminantHints.enable = "always";
              expressionAdjustmentHints.enable = "always";
              implicitDrops.enable = true;
              lifetimeElisionHints.enable = "always";
              rangeExclusiveHints.enable = true;
            };

            procMacro = {
              enable = true;
            };

            rustc.source = "discover";
          };
        };
      };
    };
    none-ls = {
      enable = true;
      sources = {
        diagnostics = {
          checkmake.enable = true;
        };
      };
    };
    lazydev.enable = true;

  };

  extraConfigLuaPost = # lua
    ''
      require("typescript-tools").setup {
      	settings = {
      		-- spawn additional tsserver instance to calculate diagnostics on it
      		separate_diagnostic_server = true,
      		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
      		publish_diagnostic_on = "insert_leave",
      		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
      		-- "remove_unused_imports"|"organize_imports") -- or string "all"
      		-- to include all supported code actions
      		-- specify commands exposed as code_actions
      		expose_as_code_action = {},
      		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      		-- not exists then standard path resolution strategy is applied
      		tsserver_path = nil,
      		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      		-- (see 💅 `styled-components` support section)
      		tsserver_plugins = {},
      		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      		-- memory limit in megabytes or "auto"(basically no limit)
      		tsserver_max_memory = "auto",
      		-- described below
      		tsserver_format_options = {},
      		tsserver_file_preferences = {},
      		-- locale of all tsserver messages, supported locales you can find here:
      		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      		tsserver_locale = "en",
      		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      		complete_function_calls = false,
      		include_completions_with_insert_text = true,
      		-- CodeLens
      		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
      		code_lens = "off",
      		-- by default code lenses are displayed on all referencable values and for some of you it can
      		-- be too much this option reduce count of them by removing member references from lenses
      		disable_member_code_lens = true,
      		-- JSXCloseTag
      		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
      		-- that maybe have a conflict if enable this feature. )
      		jsx_close_tag = {
      			enable = false,
      			filetypes = { "javascriptreact", "typescriptreact" },
      		}
      	},
      }
    '';
}
