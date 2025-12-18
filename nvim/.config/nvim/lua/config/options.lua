vim.opt.completeopt = { "menu", "menuone", "fuzzy" }
vim.opt.complete = { ".", "w", "b" }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.background = "dark"
vim.opt.bufhidden = "hide"

-- Don't store terminal buffers in sessions
vim.opt.sessionoptions:remove("terminal")

vim.opt.path = ".,**"
-- vim.opt_local.path = ".,**"
-- vim.opt.path = ".,**,**/.*/**"
vim.opt.shell = "zsh"

-- vim.opt.shada = "'100,<2000,s200,:200,/200,h,f1,r/COMMIT_EDITMSG$"

vim.opt.shada = "'100,<2000,s200,:1000,/1000,h,f1,r/COMMIT_EDITMSG,r/git-rebase-todo,!"

vim.opt.showtabline = 1
vim.opt.tabline = "%!v:lua.MyTabLine()"

-- Enable search highlight only while searching
vim.opt.hlsearch = false

function _G.MyTabLine()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"

    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. " " .. i .. ":" .. filename .. " "
  end

  s = s .. "%#TabLineFill#"
  return s
end

function _G.winbar_path()
  local filepath = vim.fn.expand("%:.") -- relative path
  if filepath == "" then
    return ""
  end
  -- if filepath:sub(1, #vim.env.HOME) == vim.env.HOME then
  --   filepath = "~" .. filepath:sub(#vim.env.HOME + 1)
  -- end
  return vim.fn.pathshorten(filepath, 4)
end

-- Undo configuration
vim.opt.undodir = vim.env.HOME .. "/.undo"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- single width icons/font
vim.opt.ambiwidth = "single"

-- Create undo directory if it doesn't exist
local undo_dir = vim.fn.expand(vim.env.HOME .. "/.undo")
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

vim.opt_local.winbar = "%=" .. "%{v:lua.winbar_path()}"

-- local term_group = vim.api.nvim_create_augroup("TermWinbar", { clear = true })
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = term_group,
--   desc = "Disable winbar in terminal buffers",
--   callback = function()
--     vim.opt_local.winbar = nil
--   end,
-- })

vim.g.matchparen_timeout = 10
vim.g.matchparen_insert_timeout = 10

vim.opt.scrollback = 100000
vim.opt.autochdir = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.breakindent = true

vim.opt.cursorcolumn = false
vim.opt.guicursor = ""
vim.opt.cursorline = false
vim.opt.cursorlineopt = "number"
vim.opt.diffopt = "vertical,filler,context:5,internal,algorithm:histogram,indent-heuristic,linematch:60,closeoff"
vim.opt.directory = "~/.tmp"

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

-- Clear the Folded highlight group completely
vim.api.nvim_set_hl(0, "Folded", {})

_G.better_fold_text = function()
  local start = vim.v.foldstart
  local finish = vim.v.foldend
  local line = vim.fn.getline(start)

  local indent = string.rep(" ", vim.fn.indent(start))
  line = line:gsub("^%s+", "")

  local max = 60
  if #line > max then
    line = line:sub(1, max) .. "…"
  end

  local count = finish - start + 1
  local bar = "▏" -- thin vertical bar
  local icon = "▶" -- clean fold arrow

  return string.format("%s%s %s  %s%s", indent, bar, icon, line, "  · " .. count .. " lines")
end

vim.opt.foldtext = "v:lua.better_fold_text()"
vim.opt.fillchars:append({ fold = " " })

vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 2
-- vim.opt.foldenable = true
vim.opt.foldenable = false

vim.cmd([[
function! ToggleFolding()
  if &foldmethod ==# 'manual'
    " indent-based folding, show level 1 (classes), fold level 2+ (methods)
    setlocal foldmethod=indent foldenable foldlevel=1
    echo "Folding enabled (methods folded, classes open)"
  else
    setlocal nofoldenable foldmethod=manual
    echo "Folding disabled"
  endif
endfunction

nnoremap <silent> gz :call ToggleFolding()<CR>
]])

vim.g.markdown_folding = 1 -- enable markdown folding

vim.opt.formatoptions = "qlj" -- TODO: overwritten in my_cmds.lua

vim.cmd([[
" supported patterns, basically everything, must wrap pattren in single quotes
" :Rg 'jlima|test|type \S+ struct'
" :Rg -t go '^type (?![jJ]ob)\w+' -- only match go file types, -t go -t py can be chained
" *********** FLAGS **********
" -uuu  flag support
" -u (.gitignore)
" -uu (hidden + .gitignore),
" -uuu (Binaries + hidden + .gitignore) DO NOT USE THIS!
" :Rg -u -w 'testing|jlima' --- multiple flag are also supported
" :Rg -uu 'jlima|test|type \S+ struct'
" :Rg -uu \"test\" -> will match "test"
" negative lookaround
" :Rg '^from (?!unittest)\w+ import' -- anything but
" :Rg '^from (?!unittest|ansible|pytest)\w+ import' --anything but
" positive lookaround (behind)
" (?<=user_id: )\d+ -- matches only \d+
" positive lookaround (ahead)
if executable('rg')
  let &grepprg = 'rg --vimgrep --no-heading --smart-case --pcre2'
  let &grepformat = '%f:%l:%c:%m'
else
  let &grepprg = 'grep -nHIRE $* .'
  let &grepformat = '%f:%l:%m'
endif

" this is the best part of my config
function! Rg(args) abort
  " escape the | properly, :Rg -uu 'from (?!ansible|pytest)\w+ import'
  let l:pattern = substitute(a:args, '|', '\\|', 'g')
  execute "silent! grep!" l:pattern
  copen
endfunction

command! -nargs=+ -complete=file Rg call Rg(<q-args>)
]])

-- in term set line spacing x/y to 0/0
vim.opt.linespace = 10

vim.opt.hidden = true
vim.opt.history = 1000
-- vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:remove("_")
vim.opt.joinspaces = false

vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = true

vim.cmd([[
set statusline=%{repeat('─',winwidth('.'))}
]])

vim.opt.list = false -- set on demand
vim.opt.listchars = [[tab:  ,trail:•,nbsp:·,conceal: ]]
vim.opt.magic = true
vim.opt.maxmempattern = 2000
vim.opt.mousemodel = "extend"
vim.opt.mouse = "n"
vim.opt.nrformats = "bin,hex"
vim.opt.fileformats = "unix"
vim.opt.fileformat = "unix"
vim.opt.nrformats = "bin,hex,alpha"

vim.opt.numberwidth = 1
vim.opt.signcolumn = "yes:1"
-- vim.opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum}%s"
vim.opt.pumheight = 5
vim.opt.relativenumber = false
vim.opt.number = false
vim.opt.laststatus = 0
vim.opt.ruler = true
vim.opt.complete = ".,w,b"
vim.opt.shortmess = "aoOstTWICc" -- F dont show file info when editing file, useful when statusline is enabled already
vim.opt.showbreak = [[↪ ]]
vim.opt.showmatch = true -- matchparen
vim.opt.matchtime = 0
vim.opt.showtabline = 1
vim.opt.scrollback = 1000
vim.opt.sidescrolloff = 5
vim.opt.scrolloff = 5
vim.opt.sidescroll = 3
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.spelllang = "en_us"
vim.opt.spellsuggest = "best,5"
vim.opt.spellsuggest = "best,9"
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.opt.splitkeep = "screen"
vim.opt.swapfile = false
vim.opt.synmaxcol = 200 -- for performace
vim.opt.tags = [[./tags,tags;~]] -- search upwards until ~ (homedir)
vim.opt.textwidth = 80
vim.opt.timeout = false -- remove timeout for partially typed commands
vim.opt.timeoutlen = 300
vim.opt.title = true
vim.opt.titlestring = ""
vim.opt.lazyredraw = true -- Don't redraw during macros
vim.opt.updatetime = 250 -- Faster CursorHold events
vim.opt.smoothscroll = false -- disable for performance
