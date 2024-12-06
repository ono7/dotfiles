return {
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      picker = "telescope",

      -- See Setup section below
    })
    local opts = { noremap = true, silent = false }

    -- Create a new note after asking for its title.
    -- vim.api.nvim_set_keymap("n", "zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)

    vim.keymap.set("n", "zn", function()
      local title = vim.fn.input("Title: ")
      if #title < 4 then
        print("Title should be 4+ chars")
        return
      end
      vim.cmd('ZkNew { title = "' .. title .. '" }')
    end, opts)

    -- Open notes.
    vim.api.nvim_set_keymap("n", "zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
    -- Open notes associated with the selected tags.
    vim.api.nvim_set_keymap("n", "zt", "<Cmd>ZkTags<CR>", opts)

    -- Search for the notes matching a given query.
    vim.api.nvim_set_keymap(
      "n",
      "zf",
      "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
      opts
    )
    -- Search for the notes matching the current visual selection.
    vim.api.nvim_set_keymap("v", "zf", ":'<,'>ZkMatch<CR>", opts)
  end,
}
