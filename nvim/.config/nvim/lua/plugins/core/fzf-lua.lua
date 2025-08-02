return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      fzf_colors = true,
      {
        "fzf-native",
        winopts = {
          -- -- preview = { default = "bat" },
        },
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      keymap = {
        fzf = {
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-k"] = "up",
          ["ctrl-j"] = "down",
          ["ctrl-q"] = "select-all+accept",
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
        git_icons = true,
        file_icons = true,
        color_icons = true,
      },
    })

    local k = vim.keymap.set

    k("n", "<leader>b", fzf.buffers, { desc = "[S]earch existing [B]uffers" })
    -- k("n", "<leader>gc", fzf.git_commits, { desc = "Search [G]it [C]ommits" })
    -- k("n", "<leader>gcf", fzf.git_bcommits, { desc = "Search [G]it [C]ommits for current [F]ile" })
    -- k("n", "<leader>tgb", fzf.git_branches, { desc = "Search [G]it [B]ranches" })
    -- k("n", "<leader>gs", fzf.git_status, { desc = "Search [G]it [S]tatus (diff view)" })
    k("n", "<leader>vc", function()
      require("fzf-lua").files({
        cwd = vim.fn.expand("~/.dotfiles"),
        prompt = "Dotfiles> ",
        previewer = false,
        winopts = {
          title = " Dotfiles ",
          title_pos = "center",
        },
      })
    end, { desc = "Search dotfiles" })
    k("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })
    k("n", "<leader>scw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
    k("n", "<leader>g", fzf.live_grep, { desc = "[S]earch by [G]rep" })
    -- k("n", "<leader>fd", fzf.diagnostics_document, { desc = "[S]earch [D]iagnostics" })
    -- k("n", "<leader>fr", fzf.resume, { desc = "[S]earch [R]esume" })
    -- k("n", "<leader>ft", function()
    --   fzf.grep({ cmd = "rg --column --line-number", search = "TODO", prompt = "Todos> " })
    -- end, { desc = "Find todos" })

    -- find files
    k("n", "<C-f>", function()
      local current_file_dir = vim.fn.expand("%:p:h")
      require("fzf-lua").files({
        cwd = current_file_dir,
        prompt = "Files (current dir)> ",
        previewer = false,
        winopts = {
          title = " Files in " .. vim.fn.fnamemodify(current_file_dir, ":t") .. " ",
          title_pos = "center",
        },
      })
    end, { desc = "Find files in current file's directory" })

    -- git files
    k({ "n", "x" }, "<leader>ff", function()
      require("fzf-lua").git_files({
        prompt = "Git Files> ",
        previewer = false,
        git_command = "git ls-files --exclude-standard --cached --others",
        winopts = {
          title = " Git Files + Untracked ",
          title_pos = "center",
        },
      })
    end, { desc = "All git files including untracked" })

    -- oldfiles
    k("n", "<C-r>", function()
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
        winopts = {
          title = " Recent Files ",
          title_pos = "center",
        },
      })
    end, { desc = "Recent files (no git)" })

    -- live grep
    k("n", "<leader>g", function()
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
          "--glob=!.collections",
          "--glob=!.git",
          "--glob=!tags",
        }, " "),
        no_ignore = false,
        hidden = true,
        winopts = {
          title = " Live Grep ",
          title_pos = "center",
        },
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
-- return {
--   "ibhagwan/fzf-lua",
--   -- optional for icon support
--   -- dependencies = { "nvim-tree/nvim-web-devicons" },
--   -- or if using mini.icons/mini.nvim
--   dependencies = { "echasnovski/mini.icons" },
--   keymap = {
--     fzf = {
--       -- use cltr-q to select all items and convert to quickfix list
--       ["ctrl-q"] = "select-all+accept",
--     },
--   },
--   opts = {
--     oldfiles = {
--       include_current_session = true,
--     },
--     previewers = {
--       builtin = {
--         syntax_limit_b = 1024 * 100, -- 100KB
--       },
--     },
--     grep = {
--       rg_glob = true, -- enable glob parsing
--       glob_flag = "--iglob", -- case insensitive globs
--       glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
--     },
--   },
-- }

-- keymap("n", "<leader>fm", fzf.marks, { desc = "[S]earch [M]arks" })
-- keymap("n", "<leader>gf", fzf.git_files, { desc = "Search [G]it [F]iles" })
-- keymap("n", "<leader>vs", fzf.dotfiles, { desc = "Seach dotfiles" })
-- keymap("n", "<leader>fo", fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- keymap("n", "<leader>qf", fzf.quickfix, { desc = "Show quick fix list" })
-- keymap("n", "<leader>a", function()
--   fzf.lsp_document_symbols({
--     symbol_types = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Property" },
--   })
-- end, { desc = "[S]each LSP document [S]ymbols" })
