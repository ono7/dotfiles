local P = {}

-- NOTE(jlima): Absolute path expansion avoids relying on external shell env during I/O operations.
local HOOKS_PATH = vim.fn.expand("~/.dotfiles/hooks.json")

local function load_hooks()
  local uv = vim.uv or vim.loop
  local fd, err = uv.fs_open(HOOKS_PATH, "r", 438)
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
  if not ok or type(parsed) ~= "table" then
    return {}
  end

  return parsed
end

local function save_hooks(hooks)
  local encoded = vim.json.encode(hooks)
  local dir = vim.fs.dirname(HOOKS_PATH)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local uv = vim.uv or vim.loop
  -- NOTE(jlima): O_TRUNC | O_CREAT | O_WRONLY guarantees atomic file recreation without leftover byte tails.
  local fd, err = uv.fs_open(HOOKS_PATH, "w", 438)
  if not fd then
    vim.notify(string.format("Failed to open hooks file: %s", err), vim.log.levels.ERROR)
    return false
  end

  uv.fs_write(fd, encoded, 0)
  uv.fs_close(fd)
  return true
end

local function execute_command(bufnr)
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

  -- NOTE(jlima): Temporarily scope lcd to file directory so wildcards expand matching :T's working directory without leaking state.
  local expanded_cmd
  vim.api.nvim_buf_call(bufnr, function()
    local saved_cwd = vim.fn.getcwd()
    vim.cmd.lcd(buf_dir)
    expanded_cmd = vim.fn.expandcmd(raw_cmd)
    vim.cmd.lcd(saved_cwd)
  end)

  if expanded_cmd and expanded_cmd ~= "" then
    -- NOTE(jlima): Chaining cd before execution ensures an existing terminal process synchronizes CWD without scraping terminal buffer state.
    local escaped_dir = vim.fn.fnameescape(buf_dir)
    vim.cmd(string.format("T cd %s && %s", escaped_dir, expanded_cmd))
  end
end

function P.save_and_execute()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].buftype == "" and vim.bo[bufnr].modified then
    vim.cmd("silent update")
  end

  execute_command(bufnr)
end

function P.setup()
  if P.loaded then
    return
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

    -- NOTE(jlima): Passing no arguments presents an interactive edit prompt with existing command; empty input clears.
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
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("HRun", function()
    P.save_and_execute()
  end, {})

  P.loaded = true
end

return P
