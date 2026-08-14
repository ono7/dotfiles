return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },

  -- Global keymaps to launch or close Diffview from anywhere in Neovim
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
  },

  opts = function()
    local actions = require("diffview.actions")

    return {
      enhanced_diff_hl = true, -- Highlights slightly better than default Neovim

      view = {
        -- Default view configuration
        merge_tool = {
          -- You can configure the layout here (e.g., "diff3_mixed" or "diff4_mixed")
          layout = "diff3_mixed",
        },
      },

      -- Explicitly map the conflict resolution keys for the merge tool
      keymaps = {
        merge_tool = {
          { "n", "co", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
          { "n", "ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
          { "n", "ca", actions.conflict_choose("all"), { desc = "Choose ALL" } },
          { "n", "dx", actions.conflict_choose("none"), { desc = "Choose NONE" } },
          { "n", "1", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
          { "n", "2", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
        },
      },
    }
  end,
}
