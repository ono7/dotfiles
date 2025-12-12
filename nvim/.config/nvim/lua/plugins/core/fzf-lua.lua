return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    local fzf = require("fzf-lua")

    local winopts = {
      height = 0.85,
      width = 0.80,
      row = 0.35,
      col = 0.50,
      split = "belowright new",
      preview = {
        -- "horizontal" places the preview to the right of the list.
        -- "vertical" places the preview above or below the list.
        layout = "horizontal",
        horizontal = "right:50%", -- Preview takes 50% of the split width
      },
      -- Optional: Ensure the window doesn't behave like a float
      fullscreen = false,
      -- preview = {
      --   default = "builtin",
      --   layout = "flex",
      -- },
    }

    fzf.setup({
      win_bg = "Normal",
      -- Define the highlight groups
      fzf_colors = {
        ["bg+"] = { "bg", "Visual" }, -- Selected line background
        ["fg+"] = { "fg", "Normal" }, -- Selected line foreground

        -- other notes for future reference
        -- ["fg"]          = { "fg", "CursorLine" },
        -- ["bg"]          = { "bg", "Normal" },
        -- ["hl"]          = { "fg", "Comment" },

        -- THIS determines the selected line background
        -- It says: "Use the 'bg' color from the 'Visual' highlight group for fzf's 'bg+'"
        -- ["bg+"] = { "bg", "Visual" },

        -- THIS determines the text color of the selected line
        -- ["fg+"] = { "fg", "Visual" },

        -- THIS determines the highlight of the MATCHED text on the selected line
        -- ["hl+"] = { "fg", "Special" },

        -- ["info"]        = { "fg", "PreProc" },
        -- ["prompt"]      = { "fg", "Conditional" },
        -- ["pointer"]     = { "fg", "Exception" },
        -- ["marker"]      = { "fg", "Keyword" },
        -- ["spinner"]     = { "fg", "Label" },
        -- ["header"]      = { "fg", "Comment" },
        -- ["gutter"]      = { "bg", "Normal" },
      },
      winopts = winopts,
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      -- this should work with others as well to disable previews
      -- previews are enabled because we are injecting the builtin previewers above
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
        -- -- previewer = "bat",
      },
      oldfiles = {
        include_current_session = true,
        sort_lastused = true,
        stat_file = true,
      },
      buffers = {
        sort_lastused = true,
        previewer = false,
      },
      grep = {
        cmd = "rg --line-number --column --no-heading --color=always --smart-case",
        rg_opts = '--hidden --glob "!node_modules/*" --glob "!.cache/*" --glob "!.git/*" --glob "!.venv/*"',
        -- previewer = "bat",
      },
      live_grep = {
        cmd = "rg --line-number --column --no-heading --color=always --smart-case",
        rg_opts = '--hidden --glob "!node_modules/*" --glob "!.git/*" --glob "!.venv/*"',
        -- previewer = "bat",
      },
      git = {
        files = {
          -- previewer = "bat",
        },
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
    -- k("n", "<leader>z", fzf.zoxide, { desc = "change projects using zoxide and fzflua" })

    -- k("n", "<leader>z", function()
    --   require("fzf-lua").zoxide({ previewer = false })
    -- end)

    k("n", "<leader>vc", function()
      winopts.title = " Dotfiles "
      winopts.title_pos = "center"
      require("fzf-lua").files({
        cwd = vim.fn.expand("~/.dotfiles"),
        winopts = winopts,
        prompt = "Dotfiles> ",
        previewer = false,
      })
    end, { desc = "Search dotfiles" })

    k("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })
    k("n", "<leader>scw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
    k("n", "<leader>g", fzf.live_grep, { desc = "[S]earch by [G]rep" })
    -- reserve c-s for :Rg
    -- k("n", "<c-s>", fzf.lsp_document_symbols, { desc = "[S]earch [D]iagnostics" })
    k("n", "<c-d>", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })

    -- find files
    k("n", "<c-f>", function()
      -- local current_file_dir = vim.fn.expand("%:p:h")
      require("fzf-lua").files({
        -- cwd = current_file_dir,
        prompt = "Files (current dir)> ",
        previewer = false,
        winopts = function()
          local opts = winopts
          -- opts.title = " Files in " .. vim.fn.fnamemodify(current_file_dir, ":t") .. " "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Find files in current file's directory" })

    -- git files
    k({ "n", "x" }, "<leader>f", function()
      require("fzf-lua").git_files({
        prompt = "Git Files> ",
        previewer = false,
        git_command = "git ls-files --exclude-standard --cached --others",
        winopts = function()
          local opts = winopts
          opts.title = " Git Files + Untracked "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "All git files including untracked" })

    -- oldfiles
    -- k("n", nv("r"), function()
    k("n", "<c-r>", function()
      require("fzf-lua").oldfiles({
        prompt = "Recent Files> ",
        previewer = false,
        file_ignore_patterns = {
          "COMMIT_EDITMSG",
          "MERGE_MSG",
          "git%-rebase%-todo",
          "%.git/",
          "fugitive:",
        },
        winopts = function()
          local opts = winopts
          opts.title = " Recent Files "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Recent files (no git)" })

    -- live grep
    k("n", "<leader>l", function()
      require("fzf-lua").live_grep({
        prompt = "Live Grep> ",
        -- previewer = false,
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
        winopts = function()
          local opts = winopts
          opts.title = " Live Grep "
          opts.title_pos = "center"
          opts.width = 0.95 -- 95% of the editor width
          opts.height = 0.95 -- 95% of the editor height
          return opts
        end,
      })
    end, { desc = "Live grep with rg" })

    -- k("n", "<leader><leader>", fzf.buffers, { desc = "Find existing buffers" })
    k("n", "<leader>s/", function()
      fzf.live_grep({ buffers_only = true, prompt = "Live Grep in Open Files> " })
    end, { desc = "[S]earch [/] in Open Files" })
    k("n", "<leader>/", function()
      fzf.blines({ previewer = false })
    end, { desc = "Fuzzily search in current buffer" })
  end,
}
