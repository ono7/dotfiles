return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      -- NOTE(jlima): Strictly cap buffer parsing size to eliminate diff overhead on large files
      max_file_length = 4000,
      -- NOTE(jlima): Throttle diff recalculation passes after buffer write/change events
      update_debounce = 200,
      -- NOTE(jlima): Moderate git directory watcher interval to avoid event-loop saturation
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Next git hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Prev git hunk" })

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage selected hunk" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset selected hunk" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage entire buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset entire buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Blame line detail" })

        map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff against index" })

        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { desc = "Diff against last commit" })

        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, { desc = "Populate quickfix with all repo hunks" })
        map("n", "<leader>hq", gitsigns.setqflist, { desc = "Populate quickfix with buffer hunks" })

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle inline git blame" })
        map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff highlighting" })

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select git hunk" })
      end,
    })
  end,
}
