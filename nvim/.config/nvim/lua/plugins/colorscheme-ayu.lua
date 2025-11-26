-- if vim.env.TERM_PROGRAM == "Apple_Terminal" then
if vim.env.TERM_PROGRAM == "otherfake stub" then
  vim.opt.termguicolors = false
  vim.cmd([[
  set t_Co=16
  hi! Comment ctermfg=8 ctermbg=NONE guifg=#384057 guibg=NONE
  hi! link LineNr Comment
  hi! clear Error
  hi! clear ModeMsg
  hi! clear DiffDelete
  hi! clear FoldColumn
  hi! clear SignColumn
  hi! clear CursorLineFold
  hi! link CursorLine Normal
  hi! CursorLineFold guibg=NONE guifg=NONE ctermbg=NONE
  hi! SignColumn guibg=NONE guifg=NONE ctermbg=NONE
  hi! FoldColumn guibg=NONE guifg=NONE ctermbg=NONE
  hi! clear DiffAdd
  " hi! DiffChange term=bold ctermbg=0 guibg=NONE
  hi! DiffChange ctermbg=52  ctermfg=NONE guibg=#3a1e1e guifg=NONE
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
  return {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = false,  -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        terminal = true, -- Set
        overrides = {

          Normal = { bg = "#151F2D", fg = "#BEBEBC" },
          MatchParen = { fg = "#000000", bg = "#ffffff" },
          NormalFloat = { bg = "none" },
          ColorColumn = { bg = "none" },
          SignColumn = { bg = "none" },
          -- Question = { fg = "#7DAA52" },
          -- Question = { fg = "#9aae46" },
          String = { fg = "#9aae46" },
          Question = { fg = "#aad94c" },
          Todo = { fg = "#d35a63" },
          -- Comment = { fg = "#2d3239", italic = false },
          Comment = { fg = "#3D4249", italic = true },
          Folded = { bg = "none" },
          EndOfBuffer = { fg = "#151f2d", bg = "none" },
          FoldColumn = { bg = "none" },
          LineNr = { fg = "#2A2F38" },
          CursorLine = { bg = "none" },
          CursorColumn = { bg = "none" },
          WinBar = { bg = "none" },
          Statement = { fg = "#d27a3b", italic = false },
          VertSplit = { link = "Normal" },
          WinSeparator = { bg = "none" },
          Visual = { bg = "#1E2E45" },
          ["@punctuation.bracket"] = { link = "Todo" },
        },
      })
      -- Updated highlights using new color scheme
      vim.cmd([[colorscheme ayu-dark]])
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { fg = "#b396b8", bold = true, italic = false })
      vim.api.nvim_set_hl(0, "@text.todo", { link = "ErrorMsg" })
      vim.api.nvim_set_hl(0, "OilFile", { link = "Normal" })
      vim.api.nvim_set_hl(0, "@text.danger", { link = "ErrorMsg" })
      vim.api.nvim_set_hl(0, "@text.note", { link = "Normal" })
      vim.api.nvim_set_hl(0, "Function", { link = "Normal" })
      vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#5a6b85", bg = "none" })
      vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#2d3a44", bold = false })
      vim.api.nvim_set_hl(0, "DiffChange", {})
      vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#9cbf9c", bold = true })
      vim.api.nvim_set_hl(0, "diffAdded", { fg = "#9cbf9c", bold = true })
      vim.api.nvim_set_hl(0, "@punctuation.delimiter", {})
      vim.api.nvim_set_hl(0, "Search", { link = "PmenuSel" })
      vim.api.nvim_set_hl(0, "IncSearch", { link = "PmenuSel" })
      vim.api.nvim_set_hl(0, "StatusLine", {})
      vim.api.nvim_set_hl(0, "StatusLineNC", {})
      vim.api.nvim_set_hl(0, "@variable.builtin", {})
      vim.api.nvim_set_hl(0, "NeoTreeNormal", {})
      vim.api.nvim_set_hl(0, "NormalFloat", {})
      vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment", bold = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "SpellCap" })
      vim.api.nvim_set_hl(0, "cmpDoc", {})
      -- vim.api.nvim_set_hl(0, "Cursor", { fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "Cursor", { bg = "#00f6ff", fg = "#000000" }) -- electric cyan
      vim.api.nvim_set_hl(0, "NonText", { fg = "#5a6b85" })
      vim.api.nvim_set_hl(0, "MoreMsg", {})
      vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultError", { link = "DiagnosticError" })
      vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultWarning", { link = "DiagnosticWarn" })
      vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultInformation", { link = "DiagnosticInfo" })
      vim.api.nvim_set_hl(0, "LspDiagnosticsDefaultHint", { link = "DiagnosticHint" })
      vim.api.nvim_set_hl(0, "diffAdded", { fg = "#82a382", bold = true })
      vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#bb7e78", bold = true })
      vim.api.nvim_set_hl(0, "Special", {})
      -- vim.api.nvim_set_hl(0, "String", {})
      -- vim.api.nvim_set_hl(0, "@string", {})
      vim.api.nvim_set_hl(0, "@variable", {})
      vim.api.nvim_set_hl(0, "@property", {})
      vim.api.nvim_set_hl(0, "@property.yaml", { link = "LspDiagnosticsError" })
      vim.api.nvim_set_hl(0, "Operator", {})
      vim.api.nvim_set_hl(0, "@constant.builtin", {})
      vim.api.nvim_set_hl(0, "@function.builtin", {})
      vim.api.nvim_set_hl(0, "ModeMsg", {})
      vim.api.nvim_set_hl(0, "Constant", {})
      -- vim.api.nvim_set_hl(0, "@string.special.path.gitignore", {})
      vim.api.nvim_set_hl(0, "@variable.parameter", {})
      vim.api.nvim_set_hl(0, "@variable.member", {})
      vim.api.nvim_set_hl(0, "@parameter", {})
      vim.api.nvim_set_hl(0, "@module", {})
      vim.api.nvim_set_hl(0, "@markup.raw", {})
      vim.api.nvim_set_hl(0, "@constructor", {})
      vim.api.nvim_set_hl(0, "@constructor.python", {})
      -- vim.api.nvim_set_hl(0, "@string.documentation", {})
      vim.api.nvim_set_hl(0, "Boolean", {})
      vim.api.nvim_set_hl(0, "@function.method", { italic = false })
      -- vim.api.nvim_set_hl(0, "@string.yaml", {})
      vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { link = "Visual" })
      vim.api.nvim_set_hl(0, "@type", { link = "Question" })
      vim.api.nvim_set_hl(0, "FidgetBorder", { fg = "#1A2230", bg = "#0A0E14" })
    end,
  }
end
