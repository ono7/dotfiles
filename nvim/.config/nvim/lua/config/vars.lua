local g = vim.g

--- nvim-completion ---
g.completion_sorting = "length"

--- lsp ---
g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

--- Navigation ---
g.tmux_navigator_disable_when_zoomed = 1

--- Syntax & Language Handling ---
g.vimsyn_noerror = 1
g.asmsyntax = "nasm"
g.java_ignore_javadoc = 1

--- Markdown ---
g.markdown_fenced_languages = {
  "html",
  "python",
  "sh",
  "bash=sh",
  "nasm",
  "vim",
  "php",
  "javascript",
  "typescript",
  "lua",
  "terraform=tf",
  "sql",
  "yaml",
  "json",
  "go",
}

-- Ensure these match your preference in options.lua
g.vim_markdown_folding_disabled = 1
g.markdown_folding = 0
g.buftabline_show = 0

--- Python Indentation Logic ---
g.pyindent_continue = "&sw"
g.pyindent_open_paren = "0"
g.pyindent_nested_paren = "&sw"

--- Clipboard/Yank ---
g.miniyank_maxitems = 10
