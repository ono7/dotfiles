-- local silent, k = { silent = true }, vim.keymap.set
-- local ui = require("harpoon.ui")
-- local mark = require("harpoon.mark")
--
-- k("n", "mm", mark.add_file)
--
-- k("n", "<m-h>", ui.toggle_quick_menu)
-- k("n", "<m-n>", function() ui.nav_file(1) end, silent)
-- k("n", "<m-e>", function() ui.nav_file(2) end, silent)
-- k("n", "<m-i>", function() ui.nav_file(3) end, silent)
-- k("n", "<m-o>", function() ui.nav_file(4) end, silent)

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "mm", function() harpoon:list():add() end)
vim.keymap.set("n", "<m-m>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<m-n>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<m-e>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<m-i>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<m-o>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

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
