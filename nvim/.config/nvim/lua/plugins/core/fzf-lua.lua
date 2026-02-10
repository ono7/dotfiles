return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    local fzf = require("fzf-lua")
    local winopts = {
      on_create = function()
        -- Prevents 'esc' delay by making it immediate in the terminal
        vim.keymap.set("t", "<Esc>", "<C-c>", { buffer = true, silent = true })
      end,
      height = 0.45,
      width = 1,
      row = 1,
      col = 0,

      -- FIX 1: Manually force ONLY the top border line.
      -- The order is: { top, right, bottom, left, topleft, topright, botright, botleft }
      -- We use "─" for top, and empty strings "" for everything else.
      border = { "─", "─", "─", "", "", "", "", "" },

      -- Optional: removes the scrollbar on the right edge
      scrollbar = false,

      preview = {
        layout = "horizontal",
        horizontal = "right:50%",

        -- FIX 2: Remove border from the preview window completely
        border = "noborder",

        -- Optional: Add a left border if you want a visual line between Picker and Preview:
        -- border = { "", "", "", "│", "", "", "", "" },

        scrollbar = false,
      },
      fullscreen = false,
    }
    fzf.setup({
      win_bg = "Normal",
      fzf_colors = {
        ["bg+"] = { "bg", "Visual" },
        ["fg+"] = { "fg", "Normal" },
      },
      winopts = winopts,
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100,
        },
      },
      zoxide = {
        winopts = {
          preview = { hidden = true },
        },
      },
      keymap = {
        fzf = {
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-k"] = "up",
          ["ctrl-a"] = "toggle-all",
          ["ctrl-j"] = "down",
          ["ctrl-q"] = "select-all+accept",
          ["ctrl-w"] = "select-all+accept",
        },
      },
      actions = {
        files = {
          ["default"] = fzf.actions.file_switch_or_edit,
          ["ctrl-q"] = fzf.actions.file_sel_to_qf,
          ["enter"] = fzf.actions.file_switch_or_edit,
          ["ctrl-s"] = fzf.actions.file_split,
          ["ctrl-v"] = fzf.actions.file_vsplit,
          ["ctrl-t"] = fzf.actions.file_tabedit,
        },
      },
      files = {
        fd_opts = "--type f --hidden --exclude node_modules --exclude .git --exclude .venv",
      },
      oldfiles = {
        include_current_session = true,
        sort_lastused = true,
        stat_file = true,
      },
      buffers = {
        sort_lastused = true,
        previewer = true,
      },
      grep = {
        cmd = "rg --line-number --column --no-heading --color=always --smart-case",
        rg_opts = '--hidden --glob "!node_modules/*" --glob "!.cache/*" --glob "!.git/*" --glob "!.venv/*"',
      },
      live_grep = {
        cmd = "rg --line-number --column --no-heading --color=always --smart-case",
        rg_opts = '--hidden --glob "!node_modules/*" --glob "!.git/*" --glob "!.venv/*"',
      },
      git = {
        files = {},
      },
      fzf_opts = {
        ["--tiebreak"] = "index",
      },
      defaults = {
        git_icons = false,
        file_icons = true,
        color_icons = true,
        formatter = "path.filename_first",
      },
    })

    local k = vim.keymap.set
    vim.api.nvim_set_hl(0, "FzfLuaBackdrop", { link = "Normal" })

    k("n", "<leader>b", fzf.buffers, { desc = "[S]earch existing [B]uffers" })

    k("n", "<leader>vc", function()
      require("fzf-lua").files({
        cwd = vim.fn.expand("~/.dotfiles"),
        fd_opts = "--type f --hidden --follow --exclude .git",
        prompt = "Dotfiles> ",
        previewer = true,
        winopts = function()
          -- FIX 3: Use deep_extend to copy options so we don't break the global config
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Dotfiles "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Search dotfiles" })

    k("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })
    -- k("n", "<leader>scw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
    k("n", "<leader>g", fzf.live_grep, { desc = "[S]earch by [G]rep" })
    -- k("n", "<c-d>", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })

    -- find files
    k("n", "<c-f>", function()
      require("fzf-lua").files({
        prompt = "Files (current dir)> ",
        fd_opts = "--type f --hidden --follow --exclude .git",
        previewer = true,
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Find files in current file's directory" })

    -- git files
    k({ "n", "x" }, "<leader>f", function()
      require("fzf-lua").git_files({
        prompt = "Git Files> ",
        previewer = true,
        git_command = "git ls-files --exclude-standard --cached --others",
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Git Files + Untracked "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "All git files including untracked" })

    -- oldfiles
    k("n", "<c-r>", function()
      require("fzf-lua").oldfiles({
        prompt = "Recent Files> ",
        -- FIX 2: Enabled previewer here
        previewer = true,
        file_ignore_patterns = {
          "COMMIT_EDITMSG",
          "MERGE_MSG",
          "git%-rebase%-todo",
          "%.git/",
          "fugitive:",
        },
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Recent Files "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Recent files (no git)" })

    -- live grep
    k("n", "<leader>l", function()
      require("fzf-lua").live_grep({
        prompt = "Rg(-uu)> ",
        rg_opts = table.concat({
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-u",
          "--glob=!venv",
          "--glob=!.venv",
          "--glob=!.collections",
          "--glob=!.git",
          "--glob=!tags",
        }, " "),
        no_ignore = false,
        hidden = true,
        previewer = true,
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Live Rg -uu "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Live grep with rg" })

    k("n", "<leader>s/", function()
      fzf.live_grep({ buffers_only = true, prompt = "Live Grep in Open Files> " })
    end, { desc = "[S]earch [/] in Open Files" })

    k("n", "<leader>/", function()
      fzf.blines({ previewer = false })
    end, { desc = "Fuzzily search in current buffer" })
  end,
}
