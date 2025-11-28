-- Configuration file for the 'ayu' colorscheme with custom overrides.
-- Final, verified version implementing all aesthetic choices, including the FidgetBorder and FzfLua fixes.

-- Conditional logic for terminals that don't support true color (termguicolors=false)
if vim.env.TERM_PROGRAM == "otherfake stub" then
  vim.opt.termguicolors = false
  -- [Cterm overrides remain here as they cannot be moved to the Lua overrides table]
  vim.cmd([[
    set t_Co=16
    hi! Comment ctermfg=8 ctermbg=NONE guifg=#384057 guibg=NONE
    hi! link LineNr Comment
    hi! clear Error
    hi! clear ModeMsg
    hi! clear DiffDelete
    hi! clear FoldColumn
    hi! clear SignColumn
    hi! CursorLineFold guibg=NONE guifg=NONE ctermbg=NONE
    hi! SignColumn guibg=NONE guifg=NONE ctermbg=NONE
    hi! FoldColumn guibg=NONE guifg=NONE ctermbg=NONE
    hi! clear DiffAdd
    hi! DiffChange ctermbg=52 ctermfg=NONE guibg=#3a1e1e guifg=NONE
    hi! DiffText term=bold ctermbg=3 ctermfg=0 guifg=#000000 guibg=#e1ca97
    hi! DiffAdd term=bold gui=bold ctermfg=14 ctermbg=NONE guibg=NONE guifg=#93b5b3
    hi DiffChange ctermbg=NONE ctermfg=11 guibg=#0F1724 guifg=#ffff00
    hi! clear ErrorMsg
    hi! clear MatchParen
    hi! Visual term=reverse cterm=reverse gui=reverse
    hi! MatchParen guibg=#384057 ctermbg=8
    hi! Search term=reverse cterm=reverse gui=reverse
    hi! PmenuSel term=reverse cterm=reverse gui=reverse
    hi! Pmenu term=reverse cterm=reverse gui=reverse
    hi! clear Pmenu
    hi! Normal guibg=NONE guifg=NONE ctermbg=NONE
    hi! link LineNr Comment
    hi! link DiffDelete Comment
    hi! link SpecialKey Comment
    hi! link Folded Comment
    hi! link VertSplit Comment
    hi! link MsgSeparator Comment
    hi! link WinSeparator Comment
    hi! link EndOfBuffer Comment
    hi! link StatusLineNC Comment
  ]])
  return {}
else
  -- True color (termguicolors) configuration
  return {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup({
        overrides = {
          -- 1. CORE COLORS & COMFORT
          Normal = { bg = "#151F2D", fg = "#BEBEBC" },
          Visual = { bg = "#1E2E45" },

          Comment = { fg = "#5F6C77", italic = true },
          LineNr = { fg = "#3A4555" },

          FidgetBorder = { fg = "#151F2D", bg = "#151F2D" },
          FzfLuaSelection = { bg = "#1E2E45" },
          FzfLuaCursor = { bg = "#1E2E45" },

          -- 2. UTILITY & BACKGROUND ELEMENTS
          NormalFloat = { bg = "none" },
          CursorLine = { bg = "none" },
          CursorColumn = { bg = "none" },
          ColorColumn = { bg = "none" },
          SignColumn = { bg = "none" },
          Folded = { bg = "none" },
          FoldColumn = { bg = "none" },
          EndOfBuffer = { fg = "#151f2d", bg = "none" },

          VertSplit = { link = "Normal" },
          WinSeparator = { link = "Normal" },
          WinBar = { bg = "none" },
          WinBarNC = { fg = "#5a6b85", bg = "none" },

          -- 3. MINIMAL SYNTAX COLORS
          String = { fg = "#8ca64a" },
          Statement = { fg = "#C07035", italic = false },
          Type = { fg = "#7aa7d8" },
          Function = { fg = "#AABFD9" },
          Special = { fg = "#D89F5C" },

          -- 4. ALERTS & MATCHING
          Question = { fg = "#aad94c" },
          Todo = { fg = "#d35a63" },
          MatchParen = { fg = "#000000", bg = "#AAD94C" },
          StatusLine = { bg = "none" },
          StatusLineNC = { bg = "none" },

          -- 5. DIFF & GIT (FINAL FIXES)
          DiffAdd = { fg = "#BEBEBC", bg = "#1C2E2E" },  -- Subtle Blue-Green BG
          DiffAdded = { link = "DiffAdd" },
          DiffChange = {},                               -- Subtle Blue-Grey BG (Line Change)
          DiffText = { fg = "#BEBEBC", bg = "#2A3245" }, -- Clear BG for Word Change
          DiffDelete = { fg = "#222A38", bg = "none" },  -- **FIXED**: Deleted text is dark and very subtle
          DiffRemoved = { fg = "#d35a63", bg = "none" },

          -- 6. RESET/NEUTRAL GROUPS (Your explicit overrides to limit color)
          Operator = { link = "Normal" },

          -- NEUTRALIZE PUNCTUATION GROUPS
          Delimiter = { link = "Normal" },
          ["@punctuation.bracket"] = { fg = "#BEBEBC" },
          ["@punctuation.delimiter"] = { fg = "#BEBEBC" },
          ["@operator"] = { fg = "#BEBEBC" },

          -- 7. TREE-SITTER / FINE-GRAINED
          ["@variable.field"] = { fg = "#AABFD9" },
          ["@parameter"] = { fg = "#AABFD9" },

          ["@variable.parameter"] = { link = "Normal" },
          ["@variable.member"] = { link = "Normal" },
          ["@variable"] = { link = "Normal" },
          ["@property"] = { link = "Normal" },
          ["@function.builtin"] = { link = "Normal" },
          ["@constant.builtin"] = { link = "Normal" },

          ["@property.yaml"] = { link = "LspDiagnosticsError" },
          ["@module"] = { link = "Normal" },
          ["@markup.raw"] = { link = "Normal" },
          ["@constructor"] = { link = "Normal" },
          ["@constructor.python"] = { link = "Normal" },
          ["@function.method"] = { italic = false },

          ["@lsp.typedecl"] = { fg = "#7aa7d8" },
          ["@lsp.type.comment"] = { fg = "#5F6C77", italic = true },

          NonText = { fg = "#5a6b85" },
          FloatBorder = { link = "Comment", bold = true },
          Search = { link = "Visual" },
          IncSearch = { link = "Visual" },
          NormalNC = { link = "Normal" },
        },
      })

      -- Load the colorscheme AFTER the overrides are set
      vim.cmd([[colorscheme ayu-dark]])

      -- External hlset calls (These must remain external)
      vim.api.nvim_set_hl(0, "Cursor", { bg = "#00f6ff", fg = "#000000" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#b396b8", bold = true, italic = false })

      -- Explicit Link commands (kept external for clarity and stability)
      vim.api.nvim_set_hl(0, "OilFile", { link = "Normal" })
      vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
      vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
      vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
    end,
  }
end
