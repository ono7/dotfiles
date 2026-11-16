-- 1. GLOBAL DIFF CONFIGURATION (Always Active)
vim.opt.diffopt = {
  "vertical", -- Split diffs vertically
  "filler", -- Show filler lines to keep sync
  "closeoff", -- Exit diff mode if only one diff window remains
  "context:5", -- 5 lines of context around hunks
  "internal", -- Use Neovim internal diff engine
  "algorithm:histogram", -- Superior hunk alignment
  "indent-heuristic", -- Anchor diffs to indentation boundaries
  "linematch:60", -- Precise intra-line character diffing
  "followwrap", -- Synchronize scrolling on wrapped lines
}

-- 2. DYNAMIC DIFF MODE HOOK (Runs when diff mode starts/stops)
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    local is_diff = vim.opt_local.diff:get()

    if is_diff then
      -- Space-saving UI adjustments for side-by-side comparison
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.numberwidth = 1
      vim.opt_local.number = true
      vim.opt_local.wrap = false

      -- Buffer-local hunk jumps: only active inside diff buffers
      -- Preserves global ]d, ]q, ]m outside of diffs
      vim.keymap.set("n", "]", "]c", { buffer = true, desc = "Next diff hunk" })
      vim.keymap.set("n", "[", "[c", { buffer = true, desc = "Prev diff hunk" })
      vim.keymap.set("n", "dp", "<cmd>diffput<CR>", { buffer = true, desc = "Diff Put" })
      vim.keymap.set("n", "dg", "<cmd>diffget<CR>", { buffer = true, desc = "Diff Get" })
    else
      -- Restore defaults when exiting diff mode
      vim.opt_local.signcolumn = "auto"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.numberwidth = 4
      vim.opt_local.number = true

      pcall(vim.keymap.del, "n", "]", { buffer = true })
      pcall(vim.keymap.del, "n", "[", { buffer = true })
      pcall(vim.keymap.del, "n", "dp", { buffer = true })
      pcall(vim.keymap.del, "n", "dg", { buffer = true })
    end
  end,
})
