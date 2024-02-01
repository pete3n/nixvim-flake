{pkgs, ...}: {
  plugins.treesitter = {
    enable = true;
    indent = true;
    incrementalSelection = {
      enable = true;
      keymaps = {
        initSelection = "<C-space>";
        nodeIncremental = "<C-space>";
        nodeDecremental = "<bs>";
      };
    };
  };

  plugins.treesitter-textobjects = {
    enable = true;
    extraOptions = {
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "a=" = {
            query = "@assignment.outer";
            desc = "Select [a]round outer part of an [=] assignment";
          };
          "i=" = {
            query = "@assignment.inner";
            desc = "Select [i]nner part of an [=] assignment";
          };
          "l=" = {
            query = "@assignment.lhs";
            desc = "Select [l]eft hand side of an [=] assignment";
          };
          "r=" = {
            query = "@assignment.rhs";
            desc = "Select [r]ight hand side of an [=] assignment";
          };
          "aa" = {
            query = "@parameter.outer";
            desc = "Select [a]round the outer part of a p[a]rameter";
          };
          "ia" = {
            query = "@parameter.inner";
            desc = "Select the [i]nner part of a p[a]rameter";
          };
          "ai" = {
            query = "@conditional.outer";
            desc = "Select [a]round the outer part of a cond[i]tional";
          };
          "ii" = {
            query = "@conditional.inner";
            desc = "Select the [i]nner part of a cond[i]tional";
          };
          "al" = {
            query = "@loop.outer";
            desc = "Select [a]round the outer part of a [l]oop";
          };
          "il" = {
            query = "@loop.inner";
            desc = "Select the [i]nner part of a [l]oop";
          };
          "af" = {
            query = "@call.outer";
            desc = "Select [a]round the outer part of a function call";
          };
          "if" = {
            query = "@call.inner";
            desc = "Select the [i]nner part of a function call";
          };
          "am" = {
            query = "@function.outer";
            desc = "Select [a]round the outer part of [m]ethod or function";
          };
          "im" = {
            query = "@function.inner";
            desc = "Select the [i]nner part of a [m]ethod or function";
          };
          "ac" = {
            query = "@class.outer";
            desc = "Select [a]round the outer part of a [c]lass";
          };
          "ic" = {
            query = "@class.inner";
            desc = "Select the [i]nner part of a [c]lass";
          };
        };
      };

      swap = {
        enable = true;
        swap_next = {
          "<leader>na" = "@parameter.inner";
          "<leader>nm" = "@function.outer";
        };
        swap_previous = {
          "<leader>pa" = "@parameter.inner";
          "<leader>pm" = "@parameter.outer";
        };
      };

      move = {
        enable = true;
        set_jumps = true;
        goto_next_start = {
          "]f" = {
            query = "@call.outer";
            desc = "Next [f]unction call start";
          };
          "]m" = {
            query = "@function.outer";
            desc = "Next [m]ethod or function def start";
          };
          "]c" = {
            query = "@class.outer";
            desc = "Next [c]lass start";
          };
          "]i" = {
            query = "@conditional.outer";
            desc = "Next cond[i]tional start";
          };
          "]l" = {
            query = "@loop.outer";
            desc = "Next [l]oop start";
          };
          "]s" = {
            query = "@scope";
            query_group = "locals";
            desc = "Next [s]cope";
          };
          "]z" = {
            query = "@fold";
            query_group = "folds";
            desc = "Next [f]old";
          };
        };

        goto_previous_start = {
          "[f" = {
            query = "@call.outer";
            desc = "Prev [f]unction call start";
          };
          "[m" = {
            query = "@function.outer";
            desc = "Prev [m]ethod or function def start";
          };
          "[c" = {
            query = "@class.outer";
            desc = "Prev [c]lass start";
          };
          "[i" = {
            query = "@conditional.outer";
            desc = "Prev cond[i]tional start";
          };
          "[l" = {
            query = "@loop.outer";
            desc = "Prev [l]oop start";
          };
        };

        goto_next_end = {
          "]F" = {
            query = "@call.outer";
            desc = "Next [f]unction call end";
          };
          "]M" = {
            query = "@function.outer";
            desc = "Next [m]ethod or function def end";
          };
          "]C" = {
            query = "@class.outer";
            desc = "Next [c]lass end";
          };
          "]I" = {
            query = "@conditional.outer";
            desc = "Next cond[i]tional end";
          };
          "]L" = {
            query = "@loop.outer";
            desc = "Next [l]oop end";
          };
        };

        goto_previous_end = {
          "[F" = {
            query = "@call.outer";
            desc = "Prev [f]unction call end";
          };
          "[M" = {
            query = "@function.outer";
            desc = "Prev [m]ethod or function def end";
          };
          "[C" = {
            query = "@class.outer";
            desc = "Prev [c]lass end";
          };
          "[I" = {
            query = "@conditional.outer";
            desc = "Prev cond[i]tional end";
          };
          "[L" = {
            query = "@loop.outer";
            desc = "Prev [l]oop end";
          };
        };
      };
    };
  };
}
