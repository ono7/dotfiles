return {
  "echasnovski/mini.ai",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  enabled = true,
  config = function()
    local treesitter = require("mini.ai").gen_spec.treesitter

    require("mini.ai").setup({
      custom_textobjects = {
        -- Whole buffer
        e = function()
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,

        -- Current line
        j = function(args)
          local index_of_first_non_whitespace_character = string.find(vim.fn.getline("."), "%S")
          local col = args == "i" and index_of_first_non_whitespace_character or 1

          return {
            from = { line = vim.fn.line("."), col = col },
            to = { line = vim.fn.line("."), col = math.max(vim.fn.getline("."):len(), 1) },
          }
        end,

        -- Function definition (needs treesitter queries with these captures)
        m = treesitter({ a = "@function.outer", i = "@function.inner" }),

        o = treesitter({
          a = { "@conditional.outer", "@loop.outer" },
          i = { "@conditional.inner", "@loop.inner" },
        }),
      },
    })
  end,
}
