return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  enabled = true,
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    })

    vim.keymap.set("n", "ma", function()
      harpoon:list():add()
    end)
    vim.keymap.set("n", "mm", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<M-1>", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<M-2>", function()
      harpoon:list():select(2)
    end)
    vim.keymap.set("n", "<M-3>", function()
      harpoon:list():select(3)
    end)
    vim.keymap.set("n", "<M-4>", function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
    -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

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
