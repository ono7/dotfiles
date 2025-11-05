return {

  "dcampos/nvim-snippy",
  opts = {},
  config = function()
    -- local snippy = require("snippy")
    -- snippy.setup({
    --   snippet_dirs = "~/.config/nvim/snippets",
    --   mappings = {
    --     is = {
    --       ["<Tab>"] = "expand_or_advance",
    --       ["<S-Tab>"] = "previous",
    --     },
    --     x = {
    --       ["<leader>d"] = "cut_text",
    --     },
    --   },
    -- })

    -- local snippy_ok, snippy = pcall(require, "snippy")
    --
    -- if not snippy_ok then
    --   print("Error in pcall snippy -> ~/.config/nvim/lua/plugins/lsp/cmp.lua")
    --   return
    -- end

    require("snippy").setup({
      snippet_dirs = "~/.config/nvim/snippets",
      mappings = {
        is = {
          ["<Tab>"] = "expand_or_advance",
          -- ["<S-Tab>"] = "previous",
        },
        x = {
          ["<leader>d"] = "cut_text",
        },
      },
    })
  end,
}

--     snippy.setup({
--       snippet_dirs = "~/.config/nvim/snippets",
--       mappings = {
--         is = {
--           ["<Tab>"] = "expand_or_advance",
--           ["<S-Tab>"] = "previous",
--         },
--         x = {
--           ["<leader>d"] = "cut_text",
--         },
--       },
--     })
--   end,
-- }

-- --- snippets
-- local snippy_ok, snippy = pcall(require, "snippy")
--
-- if not snippy_ok then
--   print("Error in pcall snippy -> ~/.config/nvim/lua/plugins/lsp/cmp.lua")
--   return
-- end
--
-- snippy.setup({
--   snippet_dirs = "~/.config/nvim/snippets",
--   -- scopes = {
--   --   _ = {},
--   --   markdown = { "markdown" },
--   -- },
--   mappings = {
--     is = {
--       ["<Tab>"] = "expand_or_advance",
--       ["<S-Tab>"] = "previous",
--     },
--     x = {
--       ["<leader>d"] = "cut_text",
--     },
--   },
-- })
