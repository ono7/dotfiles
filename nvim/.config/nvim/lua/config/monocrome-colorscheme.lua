-- Clear all highlights first
local function clear_highlights()
  local highlights_to_clear = vim.fn.getcompletion("", "highlight")
  for _, group in ipairs(highlights_to_clear) do
    vim.cmd("highlight clear " .. group)
  end
end

-- Set colorscheme
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "minimal"

-- Only run if in a GUI or terminal with true color support
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Clear existing highlights
clear_highlights()

-- Set transparent background
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NonText guibg=NONE ctermbg=NONE")
vim.cmd("highlight LineNr guibg=NONE ctermbg=NONE")
vim.cmd("highlight Folded guibg=NONE ctermbg=NONE")
vim.cmd("highlight EndOfBuffer guibg=NONE ctermbg=NONE")

vim.api.nvim_set_hl(0, "Visual", { bg = "#243d61" })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#243d61" })
vim.api.nvim_set_hl(0, "CurSearch", { link = "Visual" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#454660" })
vim.api.nvim_set_hl(0, "Search", { bg = "#243d61" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#313244" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#313244", fg = "#8186a1" })
vim.api.nvim_set_hl(0, "MatchParen", { bg = "#3d3d5c", bold = true })
vim.api.nvim_set_hl(0, "Repeat", { italic = true })
vim.api.nvim_set_hl(0, "Conditional", { italic = true })

--- lsp
vim.api.nvim_set_hl(0, "@function.builtin", { italic = true })
vim.api.nvim_set_hl(0, "@keyword.function", { italic = true })

--- diagnostics
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = false, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = false, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = false, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = false, bold = false })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { underline = false, bold = false, italic = true })

--- diff
vim.api.nvim_set_hl(0, "diffAdded", { fg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#fa5057", bold = true })

--- telescope

vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#f38ba8", bg = "none", bold = true })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { link = "Title" })
vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#f38ba8", bold = true })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#243d61" })
