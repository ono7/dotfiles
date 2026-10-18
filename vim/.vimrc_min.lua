local create_augroup = vim.api.nvim_create_augroup

local opt = { noremap = true }
local silent = { noremap = true, silent = true }

local k = vim.keymap.set
vim.g.mapleader = " "
vim.cmd([[
" ==============================================================================
" Streamlined Server vimrc
" Baseline derived from :mkexrc state with Emacs keybindings
" ==============================================================================

" --- State & File I/O Invariants (Zero Disk Writes) ---
syntax off
set noswapfile
set nobackup
set nowritebackup
set noundofile
set updatecount=0
set nobreakindent

" --- Core Baseline ---
set noloadplugins
set background=light
set termguicolors
set helplang=en
set encoding=utf-8
set laststatus=0
set shortmess=aoOstTWICcF

" --- Input & Screen Refresh Invariants ---
set ttyfast
set notimeout
set ttimeout
set ttimeoutlen=10
set backspace=indent,eol,start
set guicursor=a:block-blinkon0

" --- Cleaned Baseline Mappings ---
nnoremap Y y$
nnoremap & :&&<CR>
nnoremap <silent> <space><space> <cmd>set hlsearch!<cr>
nmap <C-W><C-D> <C-W>d
xnoremap <silent> <expr> @ mode() ==# 'V' ? ':normal! @' . getcharstr() . '<CR>' : '@'
xnoremap <silent> <expr> Q mode() ==# 'V' ? ':normal! @' . reg_recorded() . '<CR>' : 'Q'

" ==============================================================================
" Emacs Keybindings
" ==============================================================================

" --- Insert Mode Motions ---
inoremap <C-a> <C-o>^
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-p> <Up>
inoremap <C-n> <Down>

inoremap <M-b> <C-o>b
inoremap <M-f> <C-o>e<Right>
inoremap <M-a> <C-o>{
inoremap <M-e> <C-o>}

command! D bd!

" --- Insert Mode Editing & Deletions ---
inoremap <C-d> <C-g>u<Del>
inoremap <C-h> <C-g>u<BS>
inoremap <expr> <C-k> col('.') >= col('$') ? "\<C-g>u\<Del>" : "\<C-g>u\<C-o>D"
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <M-d> <C-g>u<C-\><C-o>dw
inoremap <M-BS> <C-g>u<C-w>
inoremap <C-BS> <C-g>u<C-w>
inoremap <C-y> <C-r>"
inoremap <C-S-e> <Esc>Go

" --- Command-Line Mode Motions & Deletions ---
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-BS> <C-w>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-d> <S-Right><C-w>
cnoremap <expr> <C-f> getcmdpos() > strlen(getcmdline()) ? &cedit : "\<Right>"
cnoremap <expr> <C-k> repeat("\<Del>", strlen(getcmdline()) - getcmdpos() + 1)
cnoremap <expr> <C-u> repeat("\<BS>", getcmdpos() - 1)

nnoremap <silent> <leader><leader> :set hlsearch!<CR>
nnoremap <leader>a ggVG
nnoremap gm :lcd %:p:h<CR>:!git add %:t && git commit -m "<C-r>=expand('%:t')<CR>: "<Left>

" --- Window Navigation ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-w>q <C-w>c
nnoremap <C-w><C-q> <C-w>c

nnoremap j gj
nnoremap k gk

" NOTE(jlima): sacrifice insert-mode register paste (<C-r>) for directional search navigation
inoremap <C-r> <C-o>?
inoremap <C-s> <C-o>/
nnoremap <C-r> ?
nnoremap <C-s> /

" Select re-previous selection
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

function! DuplicateAndMark() abort
  let l:c = col('.')
  execute "normal! yyP"
  call cursor(line('.'), l:c)
  execute "normal! j"
  redraw
  echo "Mark set"
endfunction

inoremap <silent> <C-,> <C-o>:call DuplicateAndMark()<CR>
nnoremap <silent> <C-,> <cmd>call DuplicateAndMark()<CR>

cnoreabbrev qq qa!

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap > >gv
vnoremap < <gv
xnoremap p "_dP

function! s:CleanAndSave() abort
  let l:save = winsaveview()
  keeppatterns %s/\v\s*\r+$\vert{}\s+$//e
  keeppatterns %s#\($\n\s*\)\+\%$##e
  call winrestview(l:save)
endfunction

augroup CoreAutoCmds
  autocmd!
  autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | setlocal noundofile nofoldenable syntax=OFF | endif
  autocmd BufWritePre * if line('$') < 5000 | call s:CleanAndSave() | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
augroup END


function! WrapSelection(left, right)
    let save_reg = @"
    normal! `
    call search('\S', 'c')
    let start_pos = getpos('.')
    normal! `>
    let end_pos = getpos('.')

    call setpos('.', end_pos)
    execute "normal! a" . a:right
    call setpos('.', start_pos)
    execute "normal! i" . a:left
    let @" = save_reg
    startinsert
endfunction

command! Mktags call system('ctags -R .')
cabbrev <expr> w!! (getcmdtype() == ':' && getcmdline() == 'w!!') ? 'w !sudo tee > /dev/null %' : 'w!!'

xnoremap ' :<C-u>call WrapSelection("'", "'")<CR>
" this overrides the " register key
vnoremap " :<C-u>call WrapSelection('"', '"')<CR>
xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>

augroup FileTypeSettings
  autocmd!
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  autocmd FileType typescript,javascript,markdown,json,yaml,yml,html,css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType go,make setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
  autocmd FileType sh,bash,zsh,jinja,jinja2 setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

if executable('prettier')
  autocmd BufWritePre *.md,*.json,*.yaml,*.yml,*.css,*.html,*.js,*.ts,*.jsx,*.tsx silent! execute '!prettier --write %' | edit!
endif

augroup _quickfix
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
  autocmd QuickFixCmdPost [^l]* cwindow 6
  autocmd QuickFixCmdPost    l* lwindow 6
augroup END

augroup _resize
  autocmd!
  autocmd VimResized * :wincmd =
augroup END

" --- Ripgrep / Grep Integration ---
if executable('rg')
  let &grepprg = 'rg --vimgrep --no-heading --smart-case --pcre2'
  let &grepformat = '%f:%l:%c:%m'
else
  let &grepprg = 'grep -nHIRE $* .'
  let &grepformat = '%f:%l:%m'
endif

function! Rg(args) abort
  let l:pattern = substitute(a:args, '|', '\\|', 'g')
  execute "silent! grep!" l:pattern
  copen
  redraw!
endfunction
command! -nargs=+ -complete=file Rg call Rg(<q-args>)

function! s:SmartEnter() abort
  let col = col('.')
  if col == 1
    return "\<CR>"
  endif

  let char = getline('.')[col - 2]
  if char == '{' || char == '[' || char == '('
    let close = char == '{' ? '}' : char == '[' ? ']' : ')'
    return "\<CR>" . close . "\<Esc>O"
  endif

  return "\<CR>"
endfunction

inoremap <expr> <CR> <SID>SmartEnter()
]])

if vim.opt.termguicolors then
  -- if truecolor is supported, lets make it better for neovim
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

-- 1. GLOBAL DIFF CONFIGURATION (Always Active)
vim.opt.diffopt = {
  "vertical", -- Split diffs vertically
  "filler", -- Show filler lines to keep sync
  "closeoff", -- Exit diff mode if only one diff window remains
  "context:5", -- 5 lines of context around hunks
  "internal", -- Use Neovim internal diff engine
  "algorithm:histogram", -- Superior hunk alignment
  "indent-heuristic", -- Anchor diffs to indentation boundaries
  "linematch:60", -- Precise intra-line character diffing
  "followwrap", -- Synchronize scrolling on wrapped lines
}

-- 2. DYNAMIC DIFF MODE HOOK (Runs when diff mode starts/stops)
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  callback = function()
    local is_diff = vim.opt_local.diff:get()

    if is_diff then
      -- Space-saving UI adjustments for side-by-side comparison
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.numberwidth = 1
      vim.opt_local.number = true
      vim.opt_local.wrap = false

      -- Buffer-local hunk jumps: only active inside diff buffers
      -- Preserves global ]d, ]q, ]m outside of diffs
      vim.keymap.set("n", "]", "]c", { buffer = true, desc = "Next diff hunk" })
      vim.keymap.set("n", "[", "[c", { buffer = true, desc = "Prev diff hunk" })
      vim.keymap.set("n", "dp", "<cmd>diffput<CR>", { buffer = true, desc = "Diff Put" })
      vim.keymap.set("n", "dg", "<cmd>diffget<CR>", { buffer = true, desc = "Diff Get" })
    else
      -- Restore defaults when exiting diff mode
      vim.opt_local.signcolumn = "auto"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.numberwidth = 4
      vim.opt_local.number = true

      pcall(vim.keymap.del, "n", "]", { buffer = true })
      pcall(vim.keymap.del, "n", "[", { buffer = true })
      pcall(vim.keymap.del, "n", "dp", { buffer = true })
      pcall(vim.keymap.del, "n", "dg", { buffer = true })
    end
  end,
})

--- commands

local opts = { silent = true }
local term_size = 12

---------------------------------------------------------------------------
-- TAB-LOCAL STATE & HELPERS
---------------------------------------------------------------------------
local tab_state = {}

local function get_normal_wins()
  return vim.tbl_filter(function(win)
    return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))
end

local function get_tab_state()
  local tab = vim.api.nvim_get_current_tabpage()
  if not tab_state[tab] then
    tab_state[tab] = {
      buf = nil,
      win = nil,
      job = nil,
      last_win = nil,
      last_cursor = nil,
      height = term_size,
    }
  end
  return tab_state[tab]
end

local function close_quickfix()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.win_gettype(win) == "quickfix" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

local function hide_transients()
  local state = get_tab_state()
  local closed_terminal = false

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype
      local wt = vim.fn.win_gettype(win)

      if bt == "terminal" or wt == "quickfix" or ft == "fugitive" or ft == "oil" then
        if #get_normal_wins() > 1 then
          if bt == "terminal" then
            state.height = vim.api.nvim_win_get_height(win)
            closed_terminal = true
          end
          pcall(vim.api.nvim_win_hide, win)
        end
      end
    end
  end

  if closed_terminal and state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
    vim.api.nvim_set_current_win(state.last_win)
  end
end

local function run_fd_filtered(input, max_results)
  local parts = vim.split(input, "!", { plain = true })
  local pattern = parts[1] ~= "" and parts[1] or ".*"

  local limit_flag = max_results and string.format("--max-results %d", max_results) or ""
  local cmd = string.format("fd --type f --hidden --exclude .git -p %s %s", limit_flag, vim.fn.shellescape(pattern))
  local results = vim.fn.systemlist(cmd)

  for i = 2, #parts do
    local exclude = parts[i]
    if exclude ~= "" then
      results = vim.tbl_filter(function(item)
        return not item:find(exclude, 1, true) and not item:match(exclude)
      end, results)
    end
  end

  return results
end

---------------------------------------------------------------------------
-- AUTOCMDS
---------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter", "WinEnter" }, {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.b.lualine_disable = true
      vim.opt_local.statusline = "%#Normal# "
    end
  end,
})

vim.api.nvim_create_autocmd("TabClosed", {
  group = vim.api.nvim_create_augroup("TabTerminalCleanup", { clear = true }),
  callback = function()
    local valid_tabs = vim.api.nvim_list_tabpages()
    local valid_set = {}
    for _, t in ipairs(valid_tabs) do
      valid_set[t] = true
    end

    for tab_id, state in pairs(tab_state) do
      if not valid_set[tab_id] then
        if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
          vim.api.nvim_buf_delete(state.buf, { force = true })
        end
        tab_state[tab_id] = nil
      end
    end
  end,
})

---------------------------------------------------------------------------
-- KEYMAPS
---------------------------------------------------------------------------
vim.keymap.set("n", "<C-/>", hide_transients, opts)
vim.keymap.set("n", "<C-_>", hide_transients, opts)
vim.keymap.set("t", "<C-/>", function()
  hide_transients()
  vim.cmd("stopinsert")
end, opts)
vim.keymap.set("t", "<C-_>", function()
  hide_transients()
  vim.cmd("stopinsert")
end, opts)

vim.keymap.set("n", "<C-t>", "<cmd>T<CR>", opts)

---------------------------------------------------------------------------
-- USER COMMANDS
---------------------------------------------------------------------------
vim.api.nvim_create_user_command("T", function(opts_args)
  local cmd = opts_args.args
  local state = get_tab_state()

  close_quickfix()

  local function save_editor_pos()
    state.last_win = vim.api.nvim_get_current_win()
    state.last_cursor = vim.api.nvim_win_get_cursor(0)
  end

  local function restore_editor_pos()
    if state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
      vim.api.nvim_set_current_win(state.last_win)
      if state.last_cursor then
        pcall(vim.api.nvim_win_set_cursor, state.last_win, state.last_cursor)
      end
    end
  end

  if state.buf == nil or not vim.api.nvim_buf_is_valid(state.buf) then
    save_editor_pos()
    vim.opt_local.winbar = nil

    vim.cmd("botright split")
    vim.wo.winfixheight = true
    vim.cmd("resize " .. state.height)

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()

    vim.cmd.term()

    state.buf = vim.api.nvim_get_current_buf()
    state.win = vim.api.nvim_get_current_win()
    state.job = vim.b.terminal_job_id

    vim.wo.statusline = "%#Normal# "
    vim.b[state.buf].lualine_disable = true

    vim.fn.chansend(state.job, "cd " .. vim.fn.shellescape(current_dir) .. "\n")
    if cmd ~= "" then
      vim.fn.chansend(state.job, cmd .. "\n")
    end

    vim.cmd("startinsert")
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == state.buf then
      state.height = vim.api.nvim_win_get_height(win)

      if #get_normal_wins() > 1 then
        pcall(vim.api.nvim_win_hide, win)
      else
        vim.cmd("enew")
      end

      restore_editor_pos()
      vim.cmd("echo ''")
      return
    end
  end

  save_editor_pos()

  vim.cmd("botright split")
  vim.wo.winfixheight = true
  vim.cmd("resize " .. state.height)

  vim.api.nvim_win_set_buf(0, state.buf)
  state.win = vim.api.nvim_get_current_win()

  vim.wo.statusline = "%#Normal# "

  if cmd ~= "" then
    vim.fn.chansend(state.job, cmd .. "\n")
  end

  vim.cmd("startinsert")
end, { nargs = "*" })

vim.api.nvim_create_user_command("GitOpen", function(opts_args)
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local file = vim.fn.expand("%:p"):gsub(vim.pesc(git_root .. "/"), "")
  local line = vim.fn.line(".")

  local repo_url = vim.fn.system("git -C " .. git_root .. " config --get remote.origin.url")
  local forced_branch = #opts_args.args > 0 and opts_args.args or nil
  local branch = forced_branch or vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local commit_hash = vim.fn.system("git rev-parse HEAD"):gsub("\n", "")
  local git_ref = branch == "HEAD" and commit_hash or branch

  local ssh_url_captures = { string.find(repo_url, ".*@(.*)[:/]([^/]*)/([^%s/]*)") }
  local _, _, host, user, repo = unpack(ssh_url_captures)
  repo = repo:gsub(".git$", "")

  local github_repo_url = string.format("https://%s/%s/%s", vim.uri_encode(host), vim.uri_encode(user), vim.uri_encode(repo))
  local github_file_url = string.format("%s/blob/%s/%s#L%s", vim.uri_encode(github_repo_url), vim.uri_encode(git_ref), vim.uri_encode(file), line)
  vim.fn.system("open " .. github_file_url)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Cd", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local start_dir = buf_name ~= "" and vim.fs.dirname(buf_name) or vim.fn.getcwd()

  local git_marker = vim.fs.find(".git", { path = start_dir, upward = true })[1]

  if git_marker then
    local root = vim.fs.dirname(git_marker)
    vim.cmd.lcd(root)
  else
    print("not a git repo")
  end
end, {})

vim.api.nvim_create_user_command("F", function(opts_cmd)
  local is_empty_buffer = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""

  -- NOTE(jlima): Reuse the initial unnamed scratch buffer instead of creating an orphaned first tab.
  if is_empty_buffer then
    vim.cmd.edit(vim.fn.fnameescape(opts_cmd.args))
  else
    vim.cmd.tabedit(vim.fn.fnameescape(opts_cmd.args))
  end
end, {
  nargs = 1,
  complete = function(lead)
    local parts = vim.split(lead, "!", { plain = true })
    local pattern = parts[1] ~= "" and parts[1] or ".*"

    local cmd = string.format("fd --type f --hidden --exclude .git -p --max-results 100 %s", vim.fn.shellescape(pattern))
    local results = vim.fn.systemlist(cmd)

    for i = 2, #parts do
      local exclude = parts[i]
      if exclude ~= "" then
        results = vim.tbl_filter(function(item)
          return not item:find(exclude, 1, true) and not item:match(exclude)
        end, results)
      end
    end

    return results
  end,
  desc = "Fast regex find: :F <pattern>!<exclude>",
})

vim.api.nvim_create_user_command("FT", function(opts_cmd)
  local files = run_fd_filtered(opts_cmd.args, nil)

  if #files == 0 then
    vim.notify("No files matched: " .. opts_cmd.args, vim.log.levels.WARN)
    return
  end

  local max_tabs = vim.o.tabpagemax
  if #files > max_tabs then
    local confirm = vim.fn.confirm(string.format("Found %d matches. Open first %d in tabs?", #files, max_tabs), "&Yes\n&No", 2)
    if confirm ~= 1 then
      return
    end
  end

  for i, file in ipairs(files) do
    if i > max_tabs then
      break
    end

    local is_empty_buffer = i == 1 and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""

    if is_empty_buffer then
      vim.cmd.edit(vim.fn.fnameescape(file))
    else
      vim.cmd.tabedit(vim.fn.fnameescape(file))
    end
  end
end, {
  nargs = 1,
  complete = function(lead)
    return run_fd_filtered(lead, 50)
  end,
  desc = "Open all regex matches in separate tabs: :FT <pattern>!<exclude>",
})

vim.api.nvim_create_user_command("Da", function(opts_cmd)
  local arg = vim.trim(opts_cmd.args)
  local raw_patterns = arg ~= "" and vim.split(arg, "|", { trimempty = true }) or {}

  local include_pats = {}
  local exclude_pats = {}

  for _, pat in ipairs(raw_patterns) do
    local trimmed = vim.trim(pat)
    if trimmed:sub(1, 1) == "!" then
      local stripped = vim.trim(trimmed:sub(2))
      if stripped ~= "" then
        table.insert(exclude_pats, stripped)
      end
    elseif trimmed ~= "" then
      table.insert(include_pats, trimmed)
    end
  end

  -- NOTE(jlima): Use nvim_get_option_value with pcall to prevent fatal __index errors on unlisted or dead bufs.
  local bufs = vim.tbl_filter(function(b)
    if not vim.api.nvim_buf_is_valid(b) then
      return false
    end
    local ok, listed = pcall(vim.api.nvim_get_option_value, "buflisted", { buf = b })
    return ok and listed
  end, vim.api.nvim_list_bufs())

  local function test_match(str, pat)
    if not str or str == "" then
      return false
    end
    local ok, match = pcall(string.find, str, pat)
    if ok and match ~= nil then
      return true
    end
    return str:lower():find(pat:lower(), 1, true) ~= nil
  end

  local targets = {}
  for _, buf in ipairs(bufs) do
    local full_path = vim.api.nvim_buf_get_name(buf)
    local rel_path = full_path ~= "" and vim.fn.fnamemodify(full_path, ":.") or ""
    local buf_name = vim.fn.bufname(buf)

    -- Check exclusion rules first
    local is_excluded = false
    for _, pat in ipairs(exclude_pats) do
      if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
        is_excluded = true
        break
      end
    end

    if not is_excluded then
      if #include_pats == 0 then
        -- NOTE(jlima): If no positive patterns exist, treat all non-excluded buffers as targets.
        table.insert(targets, buf)
      else
        for _, pat in ipairs(include_pats) do
          if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
            table.insert(targets, buf)
            break
          end
        end
      end
    end
  end

  if #targets == 0 then
    vim.notify("No buffers matched" .. (arg ~= "" and (": " .. arg) or ""), vim.log.levels.WARN)
    return
  end

  local closed = 0
  local skipped_modified = 0

  for _, buf in ipairs(targets) do
    -- NOTE(jlima): Verify buffer validity before checking modification state; deleting prior buffers can invalidate siblings.
    if vim.api.nvim_buf_is_valid(buf) then
      local ok_mod, is_modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = buf })
      if not opts_cmd.bang and ok_mod and is_modified then
        skipped_modified = skipped_modified + 1
      else
        local ok = pcall(vim.api.nvim_buf_delete, buf, { force = opts_cmd.bang })
        if ok then
          closed = closed + 1
        end
      end
    end
  end

  if skipped_modified > 0 then
    vim.notify(string.format("Closed %d buffer(s). Skipped %d modified buffer(s) (use :Da! to force).", closed, skipped_modified), vim.log.levels.WARN)
  else
    vim.notify(string.format("Closed %d buffer(s).", closed), vim.log.levels.INFO)
  end
end, {
  bang = true,
  nargs = "?",
  complete = function(lead)
    local prefix, current_lead = lead:match("^(.*|)(.*)$")
    prefix = prefix or ""
    current_lead = current_lead or lead

    -- Preserve leading ! for completion
    local excl_prefix = current_lead:match("^%s*(!)") or ""
    local query = current_lead:sub(#excl_prefix + 1)

    local bufs = vim.tbl_filter(function(b)
      if not vim.api.nvim_buf_is_valid(b) then
        return false
      end
      local ok, listed = pcall(vim.api.nvim_get_option_value, "buflisted", { buf = b })
      return ok and listed
    end, vim.api.nvim_list_bufs())

    local candidates = {}
    for _, buf in ipairs(bufs) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local rel = vim.fn.fnamemodify(name, ":.")
        if query == "" or rel:find(query, 1, true) then
          table.insert(candidates, prefix .. excl_prefix .. rel)
        end
      end
    end
    return candidates
  end,
  desc = "Close buffers matching pattern(s); prefix with '!' to exclude",
})

local ft_overrides_group = create_augroup("FileTypeOverrides", { clear = true })

--- autocmds
vim.api.nvim_create_autocmd("FileType", {
  group = ft_overrides_group, -- or vim.api.nvim_create_augroup("GlobalCommentFormat", { clear = true })
  callback = function()
    local cs = vim.bo.commentstring
    if cs ~= "" and cs:find("%%s") then
      -- Normalize so there is always a single space surrounding %s
      -- Converts '"%s"' -> '" %s"' or '/*%s*/' -> '/* %s */'
      local normalized = cs:gsub("%s*%%s%s*", " %%s ")
      vim.bo.commentstring = vim.trim(normalized)
    end
  end,
})

local general_group = create_augroup("GeneralAutocmds", { clear = true })

vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = general_group,
  callback = function(args)
    local key_opts = { buffer = args.buf, nowait = true, silent = true }

    vim.keymap.set("n", "<C-f>", "<Nop>", key_opts)
    vim.keymap.set("n", "<C-t>", "<Nop>", key_opts)
    vim.keymap.set("n", "<C-v>", "<C-v>", key_opts)
    vim.keymap.set("n", "q", "<C-c>", key_opts)
  end,
})

local quickfix_group = create_augroup("AutoOpenQuickfix", { clear = true })
-- Automatically open quickfix list after search commands
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = quickfix_group,
  pattern = "[^l]*",
  callback = function()
    local qf = vim.fn.getqflist()
    if #qf > 0 then
      vim.cmd("copen")
    else
      vim.cmd("cclose")
      print("Build successful")
    end
  end,
})

-- NOTE(jlima): Use :x! to preserve mtime on untouched buffers while forcing write if modified
vim.keymap.set("i", "<C-x>", "<Esc>:x!<CR>", { silent = true, desc = "Exit insert mode and save/quit" })

-- 2. Map <leader>w to a raw write.

-- save and clean up file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("CleanOnWrite", { clear = true }),
  callback = function(args)
    -- Short-circuit immediately on massive files
    if vim.b[args.buf].large_file then
      return
    end

    local save = vim.fn.winsaveview()

    -- Remove trailing whitespace, trailing tabs, and Windows ^M characters
    vim.cmd([[keeppatterns %s/\v\s*\r+$\vert{}\s+$//e]])

    -- Remove empty lines at the end of the file
    vim.cmd([[keeppatterns %s#\($\n\s*\)\+\%$##e]])

    -- Convert remaining tabs to spaces
    if vim.bo[args.buf].expandtab then
      vim.cmd([[retab!]])
    end

    vim.fn.winrestview(save)
  end,
})

vim.keymap.set("n", "<leader>w", function()
  if not check_buf(0) then
    vim.notify("Save first..", vim.log.levels.WARN)
    return
  end
  vim.cmd([[:write ++p]])
end, { silent = true, desc = "Write file (creates parent dirs)" })

vim.keymap.set("n", "<M-w>", function()
  if not check_buf(0) then
    vim.notify("Save first..", vim.log.levels.WARN)
    return
  end
  vim.cmd([[:write ++p]])
end, { silent = true, desc = "Write file (creates parent dirs)" })

-- Toggle quickfix list
k("n", "<c-/>", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, silent)

-- --- Custom Auto-Pair Engine ---

local my_pair_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ["<"] = ">",
  ["'"] = "'",
  ['"'] = '"',
  ["`"] = "`",
}

-- NOTE(jlima): Permitted right-hand characters that allow bracket pair expansion.
local r_bracket_map = {
  [")"] = true,
  ["]"] = true,
  ["}"] = true,
  [">"] = true,
  [" "] = true,
  ["\t"] = true,
}

-- NOTE(jlima): Strict whitespace-only guard for quotes to prevent spurious pairs inside existing syntax.
local r_quote_ws_map = {
  [""] = true,
  [" "] = true,
  ["\t"] = true,
}

-- NOTE(jlima): Permitted left-hand characters that allow quote pair expansion.
-- Includes literal prefix tokens (f, r, b, u) for Python/Rust strings and pipeline operators.
local l_quote_prefix_map = {
  [""] = true,
  [" "] = true,
  ["\t"] = true,
  ["("] = true,
  ["["] = true,
  ["{"] = true,
  ["<"] = true,
  ["="] = true,
  [":"] = true,
  [","] = true,
  ["|"] = true,
  ["!"] = true,
  ["+"] = true,
  ["-"] = true,
  ["*"] = true,
  ["/"] = true,
  ["&"] = true,
  ["~"] = true,
  ["%"] = true,
  -- String literal prefixes
  ["f"] = true,
  ["F"] = true,
  ["r"] = true,
  ["R"] = true,
  ["b"] = true,
  ["B"] = true,
  ["u"] = true,
  ["U"] = true,
}

-- NOTE(jlima): Reads an exact 2-byte buffer window around the cursor via one call to avoid allocating entire minified lines.
local function get_adjacent_chars()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local start_col = col > 0 and (col - 1) or 0
  local text = vim.api.nvim_buf_get_text(0, row, start_col, row, col + 1, {})[1] or ""

  local prev_char = ""
  local next_char = ""

  if col == 0 then
    next_char = text:sub(1, 1)
  else
    prev_char = text:sub(1, 1)
    next_char = text:sub(2, 2)
  end

  return prev_char, next_char, col
end

vim.keymap.set("i", "<BS>", function()
  local prev_char, next_char, col = get_adjacent_chars()
  if col == 0 then
    return "<BS>"
  end

  -- NOTE(jlima): Strictly deletes paired tokens only; no whitespace handling.
  if my_pair_map[prev_char] and my_pair_map[prev_char] == next_char then
    return "<BS><Del>"
  end

  return "<BS>"
end, { expr = true, replace_keycodes = true, noremap = true })

vim.keymap.set("i", "<C-S-e>", "<Esc>Go", { noremap = true, silent = true, desc = "Jump to end of file and insert new line" })

local function handle_close(char)
  local _, next_char = get_adjacent_chars()
  if next_char == char then
    return "<Right>"
  end
  return char
end

local function handle_open(char, close_char)
  local prev_char, next_char = get_adjacent_chars()

  if char == "{" and prev_char == "{" and next_char == "}" then
    return "{  }<C-g>U<Left><Left>"
  end

  local is_allowed = (next_char == "") or r_bracket_map[next_char]

  -- NOTE(jlima): Strict exception to support Ansible Jinja "{{  }}".
  -- ONLY "{" is permitted to auto-close inside quotes.
  if char == "{" and (next_char == '"' or next_char == "'") then
    is_allowed = true
  end

  if not is_allowed then
    return char
  end

  return char .. close_char .. "<C-g>U<Left>"
end

local function handle_quote(char)
  local prev_char, next_char = get_adjacent_chars()

  -- Overtype: step over if cursor is immediately before matching quote
  if next_char == char then
    return "<Right>"
  end

  -- NOTE(jlima): Reject quote expansion when preceded by non-whitelisted characters (prevents contraction bugs).
  if not l_quote_prefix_map[prev_char] then
    return char
  end

  -- NOTE(jlima): Restrict quote auto-pairing strictly to EOL or whitespace.
  if not r_quote_ws_map[next_char] then
    return char
  end

  return char .. char .. "<C-g>U<Left>"
end

vim.keymap.set("i", "{", function()
  return handle_open("{", "}")
end, { expr = true, noremap = true })

-- vim.keymap.set("i", "(", function()
--   return handle_open("(", ")")
-- end, { expr = true, noremap = true })

-- vim.keymap.set("i", "[", function()
--   return handle_open("[", "]")
-- end, { expr = true, noremap = true })

vim.keymap.set("i", "}", function()
  return handle_close("}")
end, { expr = true, noremap = true })

vim.keymap.set("i", ")", function()
  return handle_close(")")
end, { expr = true, noremap = true })

vim.keymap.set("i", "]", function()
  return handle_close("]")
end, { expr = true, noremap = true })

-- vim.keymap.set("i", '"', function()
--   return handle_quote('"')
-- end, { expr = true, noremap = true })

-- vim.keymap.set("i", "'", function()
--   return handle_quote("'")
-- end, { expr = true, noremap = true })

vim.keymap.set("i", "`", function()
  return handle_quote("`")
end, { expr = true, noremap = true })

vim.keymap.set("i", "<CR>", function()
  local prev_char, next_char, col = get_adjacent_chars()
  if col == 0 or next_char == "" then
    return "<CR>"
  end

  local pair = prev_char .. next_char
  if pair == "{}" or pair == "()" or pair == "[]" then
    return "<CR><C-o>O"
    -- return "<CR><Esc>O"
  end

  return "<CR>"
end, { expr = true, noremap = true })

-- NOTE(jlima): Use :x! to preserve mtime on untouched buffers while forcing write if modified
vim.keymap.set("i", "<C-x>", "<Esc>:x!<CR>", { silent = true, desc = "Exit insert mode and save/quit" })

--- visual selection search ---
k("v", "<enter>", [[y/\V<C-r>=escape(@",'/\')<CR><CR>]], silent)

-- notes
k("n", "<leader>n", "<cmd>e ~/notes.md<cr>", silent)

--- keep cursor in same position when yanking in visual
k("x", "y", [[ygv<Esc>]], silent)

k({ "x", "n" }, "<leader>p", '"+p', opt)

-- fix rsi issues with insert mode
local imap = function(lhs, rhs, desc)
  vim.keymap.set("i", lhs, rhs, { noremap = true, silent = true, nowait = true, desc = desc })
end

-- Line navigation
imap("<C-a>", "<C-o>_", "Move to beginning of line")
imap("<C-e>", "<End>", "Move to end of line")

-- Character / Word navigation
imap("<C-b>", "<Left>", "Move backward one character")
imap("<C-f>", "<Right>", "Move forward one character")
imap("<C-p>", "<Up>", "Move up one character")
imap("<C-n>", "<Down>", "Move down one character")
imap("<M-b>", "<C-Left>", "Move backward one word")
imap("<M-f>", "<C-Right>", "Move forward one word")

-- Deletion
imap("<C-d>", "<Del>", "Delete forward character")
imap("<C-k>", "<C-o>D", "Kill line forward")
imap("<C-u>", "<C-u>", "Kill line backward")
imap("<M-d>", "<C-o>dw", "Delete word forward")

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

vim.api.nvim_create_user_command("F", function(opts_cmd)
  local is_empty_buffer = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""

  -- NOTE(jlima): Reuse the initial unnamed scratch buffer instead of creating an orphaned first tab.
  if is_empty_buffer then
    vim.cmd.edit(vim.fn.fnameescape(opts_cmd.args))
  else
    vim.cmd.tabedit(vim.fn.fnameescape(opts_cmd.args))
  end
end, {
  nargs = 1,
  complete = function(lead)
    local parts = vim.split(lead, "!", { plain = true })
    local pattern = parts[1] ~= "" and parts[1] or ".*"

    local cmd = string.format("fd --type f --hidden --exclude .git -p --max-results 100 %s", vim.fn.shellescape(pattern))
    local results = vim.fn.systemlist(cmd)

    for i = 2, #parts do
      local exclude = parts[i]
      if exclude ~= "" then
        results = vim.tbl_filter(function(item)
          return not item:find(exclude, 1, true) and not item:match(exclude)
        end, results)
      end
    end

    return results
  end,
  desc = "Fast regex find: :F <pattern>!<exclude>",
})

vim.api.nvim_create_user_command("FT", function(opts_cmd)
  local files = run_fd_filtered(opts_cmd.args, nil)

  if #files == 0 then
    vim.notify("No files matched: " .. opts_cmd.args, vim.log.levels.WARN)
    return
  end

  local max_tabs = vim.o.tabpagemax
  if #files > max_tabs then
    local confirm = vim.fn.confirm(string.format("Found %d matches. Open first %d in tabs?", #files, max_tabs), "&Yes\n&No", 2)
    if confirm ~= 1 then
      return
    end
  end

  for i, file in ipairs(files) do
    if i > max_tabs then
      break
    end

    local is_empty_buffer = i == 1 and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""

    if is_empty_buffer then
      vim.cmd.edit(vim.fn.fnameescape(file))
    else
      vim.cmd.tabedit(vim.fn.fnameescape(file))
    end
  end
end, {
  nargs = 1,
  complete = function(lead)
    return run_fd_filtered(lead, 50)
  end,
  desc = "Open all regex matches in separate tabs: :FT <pattern>!<exclude>",
})

vim.api.nvim_create_user_command("Da", function(opts_cmd)
  local arg = vim.trim(opts_cmd.args)
  local raw_patterns = arg ~= "" and vim.split(arg, "|", { trimempty = true }) or {}

  local include_pats = {}
  local exclude_pats = {}

  for _, pat in ipairs(raw_patterns) do
    local trimmed = vim.trim(pat)
    if trimmed:sub(1, 1) == "!" then
      local stripped = vim.trim(trimmed:sub(2))
      if stripped ~= "" then
        table.insert(exclude_pats, stripped)
      end
    elseif trimmed ~= "" then
      table.insert(include_pats, trimmed)
    end
  end

  -- NOTE(jlima): Use nvim_get_option_value with pcall to prevent fatal __index errors on unlisted or dead bufs.
  local bufs = vim.tbl_filter(function(b)
    if not vim.api.nvim_buf_is_valid(b) then
      return false
    end
    local ok, listed = pcall(vim.api.nvim_get_option_value, "buflisted", { buf = b })
    return ok and listed
  end, vim.api.nvim_list_bufs())

  local function test_match(str, pat)
    if not str or str == "" then
      return false
    end
    local ok, match = pcall(string.find, str, pat)
    if ok and match ~= nil then
      return true
    end
    return str:lower():find(pat:lower(), 1, true) ~= nil
  end

  local targets = {}
  for _, buf in ipairs(bufs) do
    local full_path = vim.api.nvim_buf_get_name(buf)
    local rel_path = full_path ~= "" and vim.fn.fnamemodify(full_path, ":.") or ""
    local buf_name = vim.fn.bufname(buf)

    -- Check exclusion rules first
    local is_excluded = false
    for _, pat in ipairs(exclude_pats) do
      if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
        is_excluded = true
        break
      end
    end

    if not is_excluded then
      if #include_pats == 0 then
        -- NOTE(jlima): If no positive patterns exist, treat all non-excluded buffers as targets.
        table.insert(targets, buf)
      else
        for _, pat in ipairs(include_pats) do
          if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
            table.insert(targets, buf)
            break
          end
        end
      end
    end
  end

  if #targets == 0 then
    vim.notify("No buffers matched" .. (arg ~= "" and (": " .. arg) or ""), vim.log.levels.WARN)
    return
  end

  local closed = 0
  local skipped_modified = 0

  for _, buf in ipairs(targets) do
    -- NOTE(jlima): Verify buffer validity before checking modification state; deleting prior buffers can invalidate siblings.
    if vim.api.nvim_buf_is_valid(buf) then
      local ok_mod, is_modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = buf })
      if not opts_cmd.bang and ok_mod and is_modified then
        skipped_modified = skipped_modified + 1
      else
        local ok = pcall(vim.api.nvim_buf_delete, buf, { force = opts_cmd.bang })
        if ok then
          closed = closed + 1
        end
      end
    end
  end

  if skipped_modified > 0 then
    vim.notify(string.format("Closed %d buffer(s). Skipped %d modified buffer(s) (use :Da! to force).", closed, skipped_modified), vim.log.levels.WARN)
  else
    vim.notify(string.format("Closed %d buffer(s).", closed), vim.log.levels.INFO)
  end
end, {
  bang = true,
  nargs = "?",
  complete = function(lead)
    local prefix, current_lead = lead:match("^(.*|)(.*)$")
    prefix = prefix or ""
    current_lead = current_lead or lead

    -- Preserve leading ! for completion
    local excl_prefix = current_lead:match("^%s*(!)") or ""
    local query = current_lead:sub(#excl_prefix + 1)

    local bufs = vim.tbl_filter(function(b)
      if not vim.api.nvim_buf_is_valid(b) then
        return false
      end
      local ok, listed = pcall(vim.api.nvim_get_option_value, "buflisted", { buf = b })
      return ok and listed
    end, vim.api.nvim_list_bufs())

    local candidates = {}
    for _, buf in ipairs(bufs) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local rel = vim.fn.fnamemodify(name, ":.")
        if query == "" or rel:find(query, 1, true) then
          table.insert(candidates, prefix .. excl_prefix .. rel)
        end
      end
    end
    return candidates
  end,
  desc = "Close buffers matching pattern(s); prefix with '!' to exclude",
})
