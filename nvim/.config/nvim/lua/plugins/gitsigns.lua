local status_ok, my_gitsigns = pcall(require, "gitsigns")

if not status_ok then
  print("gitsigns not loaded - plugins/gitsigns.lua")
  return
end

my_gitsigns.setup({
  on_attach = function(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "<leader>sp", gs.preview_hunk)
    map("n", "<leader>sb", function()
      gs.blame_line({ full = true })
    end)
    map("n", "<leader>sd", gs.diffthis)
    map("n", "<leader>sD", function()
      gs.diffthis("~")
    end)
  end,
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
})
