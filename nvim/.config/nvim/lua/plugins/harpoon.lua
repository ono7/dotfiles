local opts = { noremap = true, silent = true }

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = true,
  config = function()
    local harpoon = require("harpoon")

    local function get_git_root()
      local cwd = vim.uv.cwd() or vim.fn.getcwd()
      local git_dir = vim.fs.root(cwd, ".git")
      return git_dir or cwd
    end

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return get_git_root()
        end,
      },
    })

    vim.keymap.set("n", "ma", function()
      harpoon:list():add()
      vim.notify("harpoon: file added")
    end, opts)

    vim.keymap.set("n", "mm", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, opts)

    vim.keymap.set({ "n", "i" }, "<M-1>", function() harpoon:list():select(1) end, opts)
    vim.keymap.set({ "n", "i" }, "<M-2>", function() harpoon:list():select(2) end, opts)
    vim.keymap.set({ "n", "i" }, "<M-3>", function() harpoon:list():select(3) end, opts)
    vim.keymap.set({ "n", "i" }, "<M-4>", function() harpoon:list():select(4) end, opts)

    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })
      end,
    })
  end,
}
