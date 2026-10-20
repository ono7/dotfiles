local core_group = vim.api.nvim_create_augroup("CoreSystemAutoCmds", { clear = true })
local tab_state = {}
local term_size = 12

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
			local b = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[b].filetype
			local bt = vim.bo[b].buftype
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

vim.api.nvim_create_autocmd("TabClosed", {
	group = core_group,
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

-- Terminal Drawer (:T)
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

	local function send_terminal_cmd(job, payload)
		if not payload or payload == "" then
			return
		end
		-- NOTE(jlima): Ctrl-C kills active foreground jobs, Ctrl-U purges buffered readline input
		vim.fn.chansend(job, "\x03\x15")
		vim.defer_fn(function()
			-- NOTE(jlima): 20ms yields event loop so PTY line discipline finishes signal dispatch
			if pcall(vim.fn.jobwait, { job }, 0) and vim.fn.jobwait({ job }, 0)[1] == -1 then
				vim.fn.chansend(job, payload .. "\n")
			end
		end, 20)
	end

	local is_alive = state.buf
		and vim.api.nvim_buf_is_valid(state.buf)
		and state.job
		and pcall(vim.fn.jobwait, { state.job }, 0)
		and vim.fn.jobwait({ state.job }, 0)[1] == -1

	if not is_alive then
		if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
			pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
		end

		save_editor_pos()
		vim.opt_local.winbar = nil
		vim.cmd("botright split")
		vim.wo.winfixheight = true
		vim.cmd("resize " .. state.height)

		local current_file = vim.api.nvim_buf_get_name(0)
		local current_dir = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()

		vim.cmd.term()

		state.buf = vim.api.nvim_get_current_buf()
		state.win = vim.api.nvim_get_current_win()
		state.job = vim.b.terminal_job_id
		vim.wo.statusline = "%#Normal# "

		vim.fn.chansend(state.job, "cd " .. vim.fn.shellescape(current_dir) .. "\n")
		if cmd ~= "" then
			vim.fn.chansend(state.job, cmd .. "\n")
			-- NOTE(jlima): Retain editor focus when executed via automated runner hook
			restore_editor_pos()
		else
			vim.cmd("startinsert")
		end
		return
	end

	local visible_win = nil
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_buf(win) == state.buf then
			visible_win = win
			break
		end
	end

	if visible_win then
		state.height = vim.api.nvim_win_get_height(visible_win)
		-- NOTE(jlima): Toggle closed ONLY when :T is called without an execution argument.
		if cmd == "" then
			if #get_normal_wins() > 1 then
				pcall(vim.api.nvim_win_hide, visible_win)
			else
				vim.cmd("enew")
			end
			restore_editor_pos()
			return
		end

		send_terminal_cmd(state.job, cmd)
		return
	end

	save_editor_pos()
	vim.cmd("botright split")
	vim.wo.winfixheight = true
	vim.cmd("resize " .. state.height)
	vim.api.nvim_win_set_buf(0, state.buf)
	state.win = vim.api.nvim_get_current_win()
	vim.wo.statusline = "%#Normal# "

	if cmd ~= "" then
		send_terminal_cmd(state.job, cmd)
		restore_editor_pos()
	else
		vim.cmd("startinsert")
	end
end, { nargs = "*" })

-- Transient keymaps
local map = vim.keymap.set
local silent = { noremap = true, silent = true }

map("n", "<C-t>", "<cmd>T<CR>", silent)
map("t", "<c-x>", [[<c-\><c-n>]], silent)
map("t", "<c-t>", [[<c-\><c-n><cmd>T<CR>]], silent)

map("n", "<C-/>", hide_transients, silent)
map("n", "<C-_>", hide_transients, silent)
map("t", "<C-/>", function()
	hide_transients()
	vim.cmd("stopinsert")
end, silent)
map("t", "<C-_>", function()
	hide_transients()
	vim.cmd("stopinsert")
end, silent)

-- Quickfix Toggle
map("n", "<c-/>", function()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
			break
		end
	end
	if qf_exists then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, silent)

-- Filetype Execution Runner Hooks
local HOOKS_PATH = vim.fn.expand("~/.dotfiles/hooks.json")

local function load_hooks()
	local uv = vim.uv or vim.loop
	local fd = uv.fs_open(HOOKS_PATH, "r", 438)
	if not fd then
		return {}
	end

	local stat = uv.fs_fstat(fd)
	local data = stat and uv.fs_read(fd, stat.size, 0) or ""
	uv.fs_close(fd)

	if not data or data == "" then
		return {}
	end
	local ok, parsed = pcall(vim.json.decode, data)
	return (ok and type(parsed) == "table") and parsed or {}
end

local function save_hooks(hooks)
	local encoded = vim.json.encode(hooks)
	local dir = vim.fs.dirname(HOOKS_PATH)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local uv = vim.uv or vim.loop
	local fd, err = uv.fs_open(HOOKS_PATH, "w", 438)
	if not fd then
		vim.notify(string.format("Failed to open hooks file: %s", err), vim.log.levels.ERROR)
		return false
	end

	uv.fs_write(fd, encoded, 0)
	uv.fs_close(fd)
	return true
end

local function execute_hook_command(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local ft = vim.bo[bufnr].filetype
	local hooks = load_hooks()
	local raw_cmd = hooks[ft]
	if not raw_cmd or raw_cmd == "" then
		vim.notify(string.format("No hook configured for filetype '%s'.", ft), vim.log.levels.WARN)
		return
	end

	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	local buf_dir = buf_name ~= "" and vim.fs.dirname(buf_name) or vim.fn.getcwd()

	local expanded_cmd
	vim.api.nvim_buf_call(bufnr, function()
		local saved_cwd = vim.fn.getcwd()
		vim.cmd.lcd(buf_dir)
		expanded_cmd = vim.fn.expandcmd(raw_cmd)
		vim.cmd.lcd(saved_cwd)
	end)

	if expanded_cmd and expanded_cmd ~= "" then
		local escaped_dir = vim.fn.fnameescape(buf_dir)
		vim.cmd(string.format("T cd %s && %s", escaped_dir, expanded_cmd))
	end
end

local function save_and_execute_hook()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].buftype == "" and vim.bo[bufnr].modified then
		if vim.api.nvim_buf_get_name(bufnr) == "" then
			vim.notify("Cannot save and execute: buffer has no file name.", vim.log.levels.ERROR)
			return
		end
		vim.cmd("silent update")
	end
	execute_hook_command(bufnr)
end

vim.api.nvim_create_user_command("H", function(args)
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	if ft == "" then
		vim.notify("Cannot register hook: buffer has no filetype.", vim.log.levels.WARN)
		return
	end

	local hooks = load_hooks()
	local function apply_hook(input)
		if input == nil then
			return
		end
		local cleaned = vim.trim(input)
		if cleaned == "" then
			hooks[ft] = nil
			save_hooks(hooks)
			print(string.format("[%s] Compiler cleared.", ft))
			return
		end
		hooks[ft] = cleaned
		save_hooks(hooks)
		print(string.format("[%s] Compiler configured: %s", ft, cleaned))
	end

	if #args.args == 0 then
		vim.ui.input({
			prompt = string.format("[%s] Edit Hook (empty to clear): ", ft),
			default = hooks[ft] or "",
		}, function(input)
			apply_hook(input)
		end)
	else
		apply_hook(args.args)
	end
end, { nargs = "*", desc = "Configure or clear runner hook for current filetype" })

vim.api.nvim_create_user_command("HRun", save_and_execute_hook, { desc = "Save and run filetype hook" })
map("n", "<leader>r", save_and_execute_hook, { noremap = true, silent = true, desc = "Save and run filetype hook" })

-- Fuzzy Find (:F, :FT)
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

vim.api.nvim_create_user_command("F", function(opts_cmd)
	local is_empty = vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""
	if is_empty then
		vim.cmd.edit(vim.fn.fnameescape(opts_cmd.args))
	else
		vim.cmd.tabedit(vim.fn.fnameescape(opts_cmd.args))
	end
end, {
	nargs = 1,
	complete = function(lead)
		return run_fd_filtered(lead, 100)
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
		local confirm =
			vim.fn.confirm(string.format("Found %d matches. Open first %d in tabs?", #files, max_tabs), "&Yes\n&No", 2)
		if confirm ~= 1 then
			return
		end
	end

	for i, file in ipairs(files) do
		if i > max_tabs then
			break
		end
		local is_empty = i == 1 and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified and vim.bo.buftype == ""
		if is_empty then
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

-- Delete All Matching Buffers (:Da)
vim.api.nvim_create_user_command("Da", function(opts_cmd)
	local arg = vim.trim(opts_cmd.args)
	local raw_patterns = arg ~= "" and vim.split(arg, "|", { trimempty = true }) or {}
	local include_pats, exclude_pats = {}, {}

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
		return (ok and match ~= nil) or str:lower():find(pat:lower(), 1, true) ~= nil
	end

	local targets = {}
	for _, buf in ipairs(bufs) do
		local full_path = vim.api.nvim_buf_get_name(buf)
		local rel_path = full_path ~= "" and vim.fn.fnamemodify(full_path, ":.") or ""
		local buf_name = vim.fn.bufname(buf)

		local is_excluded = false
		for _, pat in ipairs(exclude_pats) do
			if test_match(rel_path, pat) or test_match(buf_name, pat) or test_match(full_path, pat) then
				is_excluded = true
				break
			end
		end

		if not is_excluded then
			if #include_pats == 0 then
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

	local closed, skipped_modified = 0, 0
	for _, buf in ipairs(targets) do
		if vim.api.nvim_buf_is_valid(buf) then
			local ok_mod, is_modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = buf })
			if not opts_cmd.bang and ok_mod and is_modified then
				skipped_modified = skipped_modified + 1
			else
				if pcall(vim.api.nvim_buf_delete, buf, { force = opts_cmd.bang }) then
					closed = closed + 1
				end
			end
		end
	end

	if skipped_modified > 0 then
		vim.notify(
			string.format(
				"Closed %d buffer(s). Skipped %d modified buffer(s) (use :Da! to force).",
				closed,
				skipped_modified
			),
			vim.log.levels.WARN
		)
	else
		vim.notify(string.format("Closed %d buffer(s).", closed), vim.log.levels.INFO)
	end
end, {
	bang = true,
	nargs = "?",
	desc = "Close buffers matching pattern(s); prefix with '!' to exclude",
})

vim.api.nvim_create_user_command("D", "bdelete!", {})
vim.api.nvim_create_user_command("Cd", function()
	local name = vim.api.nvim_buf_get_name(0)
	local start = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
	local git = vim.fs.find(".git", { path = start, upward = true })[1]
	if git then
		vim.cmd.lcd(vim.fs.dirname(git))
	else
		print("not a git repo")
	end
end, {})

vim.api.nvim_create_user_command("Take", function(opts)
	local path = vim.fn.fnamemodify(opts.args:gsub("%s+", "-"), ":p")
	vim.fn.mkdir(path, "p")
	vim.cmd.lcd(vim.fn.fnameescape(path))
end, { nargs = "+", complete = "dir" })

-- Native Search and Wrap Helpers
vim.cmd([[
  function! CopyMatches(reg)
    let hits = []
    %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
    let reg = empty(a:reg) ? 'c' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
  endfunction
  command! -register Cm call CopyMatches(<q-reg>)

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

  xnoremap ' :<C-u>call WrapSelection("'", "'")<CR>
  xnoremap ` :<C-u>call WrapSelection('`', '`')<CR>
  xnoremap ( :<C-u>call WrapSelection('(', ')')<CR>
  xnoremap [ :<C-u>call WrapSelection('[', ']')<CR>

  function! DuplicateAndMark()
    let l:c = col('.')
    execute "normal! yyP"
    call cursor(line('.'), l:c)
    execute "normal! j"
    redraw
    echo "Mark set"
  endfunction

  inoremap <silent> <C-,> <C-o>:call DuplicateAndMark()<CR>
  nnoremap <silent> <C-,> <cmd>call DuplicateAndMark()<CR>

  function! Rg(args) abort
    let l:pattern = substitute(a:args, '|', '\\|', 'g')
    execute "silent! grep!" l:pattern
    copen
  endfunction
  command! -nargs=+ -complete=file Rg call Rg(<q-args>)
]])
