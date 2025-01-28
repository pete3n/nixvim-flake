{ ... }:
{
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      auto_install = true;
      indent.enable = true;
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<C-space>";
          node_incremental = "<C-space>";
          node_decremental = "<bs>";
        };
      };
    };
  };

  plugins.treesitter-textobjects = {
    enable = true;
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
      swapNext = {
        "<leader>na" = "@parameter.inner";
        "<leader>nm" = "@function.outer";
      };
      swapPrevious = {
        "<leader>pa" = "@parameter.inner";
        "<leader>pm" = "@parameter.outer";
      };
    };

    move = {
      enable = true;
      setJumps = true;
      gotoNextStart = {
        "]F" = {
          query = "@call.outer";
          desc = "Next [f]unction call start";
        };
        "]M" = {
          query = "@function.outer";
          desc = "Next [m]ethod or function def start";
        };
        "]C" = {
          query = "@class.outer";
          desc = "Next [c]lass start";
        };
        "]I" = {
          query = "@conditional.outer";
          desc = "Next cond[i]tional start";
        };
        "]L" = {
          query = "@loop.outer";
          desc = "Next [l]oop start";
        };
      };

      gotoPreviousStart = {
        "[F" = {
          query = "@call.outer";
          desc = "Prev [f]unction call start";
        };
        "[M" = {
          query = "@function.outer";
          desc = "Prev [m]ethod or function def start";
        };
        "[C" = {
          query = "@class.outer";
          desc = "Prev [c]lass start";
        };
        "[I" = {
          query = "@conditional.outer";
          desc = "Prev cond[i]tional start";
        };
        "[L" = {
          query = "@loop.outer";
          desc = "Prev [l]oop start";
        };
      };

      gotoNextEnd = {
        "]f" = {
          query = "@call.outer";
          desc = "Next [f]unction call end";
        };
        "]m" = {
          query = "@function.outer";
          desc = "Next [m]ethod or function def end";
        };
        "]c" = {
          query = "@class.outer";
          desc = "Next [c]lass end";
        };
        "]i" = {
          query = "@conditional.outer";
          desc = "Next cond[i]tional end";
        };
        "]l" = {
          query = "@loop.outer";
          desc = "Next [l]oop end";
        };
      };

      gotoPreviousEnd = {
        "[f" = {
          query = "@call.outer";
          desc = "Prev [f]unction call end";
        };
        "[m" = {
          query = "@function.outer";
          desc = "Prev [m]ethod or function def end";
        };
        "[c" = {
          query = "@class.outer";
          desc = "Prev [c]lass end";
        };
        "[i" = {
          query = "@conditional.outer";
          desc = "Prev cond[i]tional end";
        };
        "[l" = {
          query = "@loop.outer";
          desc = "Prev [l]oop end";
        };
      };
    };
  };
}
