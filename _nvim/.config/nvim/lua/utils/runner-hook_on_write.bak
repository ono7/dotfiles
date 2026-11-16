local P = {}

-- NOTE(jlima): Track registered monitor commands keyed deterministically by filetype.
local ft_commands = {}

local function execute_command(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local ft = vim.bo[bufnr].filetype
  local raw_cmd = ft_commands[ft]
  if not raw_cmd or raw_cmd == "" then
    return
  end

  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
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
      vim.cmd("T " .. expanded_cmd)
    end
  end)
end

local function setup_autocommand()
  local group = vim.api.nvim_create_augroup("FileMonitorGroup", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype
      if ft_commands[ft] then
        vim.defer_fn(function()
          execute_command(bufnr)
        end, 10)
      end
    end,
  })
end

function P.setup()
  if P.loaded then
    return
  end

  setup_autocommand()

  vim.api.nvim_create_user_command("H", function(args)
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype

    if ft == "" then
      vim.notify("Cannot register hook: buffer has no filetype.", vim.log.levels.WARN)
      return
    end

    local function apply_hook(input)
      if input == nil then
        return
      end

      local cleaned = vim.trim(input)
      if cleaned == "" then
        ft_commands[ft] = nil
        print(string.format("[%s] Compiler cleared.", ft))
        return
      end

      ft_commands[ft] = cleaned
      print(string.format("[%s] Compiler configured: %s (triggers on save)", ft, ft_commands[ft]))
    end

    -- NOTE(jlima): Passing no arguments presents an interactive edit prompt with existing command; empty input clears.
    if #args.args == 0 then
      vim.ui.input({
        prompt = string.format("[%s] Edit Hook (empty to clear): ", ft),
        default = ft_commands[ft] or "",
      }, function(input)
        apply_hook(input)
      end)
    else
      apply_hook(args.args)
    end
  end, { nargs = "*" })

  P.loaded = true
end

return P
