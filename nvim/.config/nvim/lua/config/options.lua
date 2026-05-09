-- 1. Performance & Loader (Top of file)
vim.loader.enable(true)

-- 2. Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 3. General Behavior
vim.opt.background = "dark"
vim.opt.bufhidden = "hide"
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.mouse = "n"
vim.opt.autochdir = false
vim.opt.autoread = true
vim.opt.updatetime = 300
vim.opt.timeout = false
vim.opt.timeoutlen = 300

-- 4. Shada (Shared Data) Optimized for Speed
vim.opt.shada = "'100,<50,s10,:1000,/1000,h,r/COMMIT_EDITMSG,r/git-rebase-todo,!"

-- 5. Search & Matching
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.g.matchparen_timeout = 10
vim.g.matchparen_insert_timeout = 10

-- 6. Undo Configuration
local undo_dir = vim.fn.expand(vim.env.HOME .. "/.undo")
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- 7. Formatting & Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.formatoptions = "qlj"
vim.opt.joinspaces = false

-- 8. UI Customization (Tabline, Winbar, Statusline)
vim.opt.showtabline = 1
vim.opt.tabline = "%!v:lua.MyTabLine()"
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.showcmd = false
vim.opt.showmode = true
vim.opt.shortmess = "aoOstTWICcF" -- 'F' hides extra file info
vim.opt.showbreak = [[↪ ]]
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "▶",
  fold = " ",
  diff = "╱",
  vert = "│",
  eob = " ",
  msgsep = "‾",
  stl = " ",
}

function _G.MyTabLine()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
    s = s .. (i == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#")
    s = s .. " " .. i .. ":" .. filename .. " "
  end
  return s .. "%#TabLineFill#"
end

function _G.winbar_path()
  local filepath = vim.fn.expand("%:.")
  return (filepath ~= "") and vim.fn.pathshorten(filepath, 4) or ""
end
-- vim.opt.winbar = "%=" .. "%{v:lua.winbar_path()}"

-- 9. Splitting & Scrolling
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.splitkeep = "screen"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.sidescroll = 3
vim.opt.smoothscroll = false -- Perf optimization for long lines

-- 10. Performance & Memory
vim.opt.swapfile = false
vim.opt.directory = "~/.tmp"
vim.opt.synmaxcol = 200
vim.opt.lazyredraw = false -- Neovim 0.11+ preferred false
vim.opt.scrollback = 100000 -- Keeping the high limit for logs
vim.opt.maxmempattern = 2000

-- 11. Diff Options
vim.opt.diffopt:remove("inline:char")
vim.opt.diffopt:append({
  "vertical",
  "algorithm:histogram",
  "context:5",
  "linematch:60",
  "inline:word",
})

-- 12. Display & Appearance
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes:1"
vim.opt.pumheight = 5
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.cursorlineopt = "number"
vim.opt.ambiwidth = "single"
vim.opt.title = true
vim.opt.titlestring = ""
vim.opt.linespace = 10

-- 13. System / Path
vim.opt.path = ".,**"
vim.opt.shell = "zsh"
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("_")
vim.opt.iskeyword:remove("-")
vim.opt.sessionoptions:remove("terminal")

-- 14. Language Support
vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,9"

-- 15. Folding (Preserved logic)
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 2
vim.opt.foldenable = false
vim.g.markdown_folding = 1
vim.api.nvim_set_hl(0, "Folded", {})

_G.better_fold_text = function()
  local start = vim.v.foldstart
  local finish = vim.v.foldend
  local line = vim.fn.getline(start):gsub("^%s+", "")
  local indent = string.rep(" ", vim.fn.indent(start))
  local max = 60
  if #line > max then
    line = line:sub(1, max) .. "…"
  end
  return string.format("%s▏ ▶ %s   · %d lines", indent, line, (finish - start + 1))
end
vim.opt.foldtext = "v:lua.better_fold_text()"

-- 16. Legacy / Vimscript (Preserved Rg logic)
vim.cmd([[
function! ToggleFolding()
  if &foldmethod ==# 'manual'
    setlocal foldmethod=indent foldenable foldlevel=1
    echo "Folding enabled (methods folded, classes open)"
  else
    setlocal nofoldenable foldmethod=manual
    echo "Folding disabled"
  endif
endfunction
nnoremap <silent> gz :call ToggleFolding()<CR>

if executable('rg')
  let &grepprg = 'rg --vimgrep --no-heading --smart-case --pcre2'
  let &grepformat = '%f:%l:%c:%m'
endif

function! Rg(args) abort
  let l:pattern = substitute(a:args, '|', '\\|', 'g')
  execute "silent! grep!" l:pattern
  copen
endfunction
command! -nargs=+ -complete=file Rg call Rg(<q-args>)
]])

_G.statusline_git_branch = function()
  if vim.fn.exists("*FugitiveHead") == 0 then
    return ""
  end
  local branch = vim.fn.FugitiveHead()
  return branch ~= "" and ("  " .. branch .. " ") or ""
end

local parts = {
  "%<%f %h%w%m%r ", -- Truncation point, file path, and flags
  "%{% v:lua.require('vim._core.util').term_exitcode() %}", -- Terminal exit code
  "%=", -- Alignment separator 1
  "%{%v:lua.statusline_git_branch()%}", -- Fugitive Branch
  "%=", -- Alignment separator 2
  "%{% luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ')%}", -- UI progress
  "%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}", -- Command tracking
  "%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}", -- Keymap name
  "%{% &busy > 0 ? '◐ ' : '' %}", -- Busy indicator
  "%{% luaeval('(package.loaded[''vim.diagnostic''] and next(vim.diagnostic.count()) and vim.diagnostic.status() .. '' '') or '''' ') %}", -- Diagnostics
  "%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}", -- Ruler (Line, Column, Percentage)
}

vim.opt.ruler = true
vim.opt.statusline = table.concat(parts)
