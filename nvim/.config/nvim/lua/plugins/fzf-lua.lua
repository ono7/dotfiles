return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",
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
      border = { "─", "─", "─", "", "", "", "", "" },
      scrollbar = false,
      preview = {
        layout = "horizontal",
        horizontal = "right:50%",
        border = "noborder",
        scrollbar = false,
      },
      fullscreen = false,
    }

    fzf.setup({
      win_bg = "Normal",
      fzf_colors = {
        ["hl"] = { "fg", "FzfLuaFzfMatch" },
        ["hl+"] = { "fg", "FzfLuaFzfMatch" },
        ["pointer"] = { "fg", "FzfLuaFzfPointer" },
        ["bg+"] = { "bg", "Visual" },
        ["fg+"] = { "fg", "Normal" },
        ["marker"] = { "fg", "FzfLuaFzfMarker" },
      },
      winopts = winopts,
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100,
        },
      },
      zoxide = {
        formatter = false,
        scope = "global",
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
          ["default"] = function(selected, opts)
            if not selected[1] then
              return
            end

            local file = require("fzf-lua.path").entry_to_file(selected[1], opts).path
            if not file then
              return
            end

            local target_path = vim.fs.normalize(vim.fn.fnamemodify(file, ":p"))

            -- NOTE(jlima): Switch to existing tabpage/window if buffer is already opened anywhere across tabs.
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
                if buf_name == target_path then
                  vim.api.nvim_set_current_tabpage(tab)
                  vim.api.nvim_set_current_win(win)
                  return
                end
              end
            end

            -- NOTE(jlima): Reuse the initial unnamed scratch buffer instead of leaving an orphaned first tab.
            local is_empty_buffer = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""

            if is_empty_buffer then
              vim.cmd.edit(vim.fn.fnameescape(target_path))
            else
              vim.cmd.tabedit(vim.fn.fnameescape(target_path))
            end
          end,
          ["ctrl-q"] = fzf.actions.file_sel_to_qf,
          ["ctrl-s"] = fzf.actions.file_split,
          ["ctrl-v"] = fzf.actions.file_vsplit,
          ["ctrl-d"] = function(selected, opts)
            if not selected[1] then
              return
            end
            local file = require("fzf-lua.path").entry_to_file(selected[1], opts).path
            vim.cmd("vert diffsplit " .. vim.fn.fnameescape(file))
          end,
          ["ctrl-y"] = function(selected, opts)
            if not selected[1] then
              return
            end
            local file = require("fzf-lua.path").entry_to_file(selected[1], opts).path
            vim.fn.setreg("+", file)
            vim.notify("Copied: " .. file, vim.log.levels.INFO)
          end,
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
        previewer = false,
        stat_file = true,
      },
      grep = {
        cmd = "rg --line-number --column --no-heading --color=always --smart-case",
        rg_opts = '--hidden --glob "!node_modules/*" --glob "!.cache/*" --glob "!.git/*" --glob "!.venv/*"',
      },
      live_grep = {
        cmd = "rg --line-number --column --no-heading --color=always --smart-case",
        rg_opts = '--hidden --glob "!node_modules/*" --glob "!.cache/*" --glob "!.git/*" --glob "!.venv/*"',
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
        fd_opts = "--type f --hidden --exclude .git",
        prompt = "Dotfiles> ",
        previewer = false,
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Dotfiles "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Search dotfiles" })

    k("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })

    k("n", "<c-f>", function()
      local current_dir = vim.fn.expand("%:p:h")
      require("fzf-lua").files({
        prompt = "Files (local dir)> ",
        cwd = (current_dir ~= "" and vim.fn.isdirectory(current_dir) == 1) and current_dir or vim.uv.cwd(),
        fd_opts = "--type f --hidden --exclude .git",
        previewer = false,
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Dotfiles "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Find files in current file's directory" })

    k("n", "<M-f>", function()
      local current_dir = vim.fn.expand("%:p:h")
      require("fzf-lua").files({
        prompt = "Files (local dir)> ",
        cwd = (current_dir ~= "" and vim.fn.isdirectory(current_dir) == 1) and current_dir or vim.uv.cwd(),
        fd_opts = "--type f --hidden --exclude .git",
        previewer = false,
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Files (local dir) "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Find files in current file's directory" })

    k({ "n", "x" }, "<leader>f", function()
      require("fzf-lua").git_files({
        prompt = "Git Files> ",
        previewer = false,
        git_command = "git ls-files --exclude-standard --cached --others",
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Git Files + Untracked "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "All git files including untracked" })

    k("n", "<M-r>", function()
      require("fzf-lua").oldfiles({
        prompt = "Recent Project Files> ",
        formatter = "path.filename_first",
        previewer = false,
        cwd = vim.uv.cwd(),
        file_ignore_patterns = {
          "COMMIT_EDITMSG",
          "MERGE_MSG",
          "git%-rebase%-todo",
          "%.git/",
          "fugitive:",
        },
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Recent Project Files "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Recent files (current project)" })

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
        previewer = false,
        winopts = function()
          local opts = vim.tbl_deep_extend("force", {}, winopts)
          opts.title = " Live Rg -uu "
          opts.title_pos = "center"
          return opts
        end,
      })
    end, { desc = "Live grep with rg" })

    k("n", "<M-z>", fzf.zoxide, { desc = "Search [Z]oxide directories" })

    k("n", "<leader>s/", function()
      fzf.live_grep({ buffers_only = true, prompt = "Live Grep in Open Files> " })
    end, { desc = "[S]earch [/] in Open Files" })

    k("n", "<leader>/", function()
      fzf.blines({ previewer = false })
    end, { desc = "Fuzzily search in current buffer" })
  end,
}
