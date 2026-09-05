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

    -- NOTE(jlima): Scope nvim_buf_call strictly to expansion so it does not pull window focus back from the terminal.
    local expanded_cmd
    vim.api.nvim_buf_call(bufnr, function()
      expanded_cmd = vim.fn.expandcmd(raw_cmd)
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

    -- NOTE(jlima): Passing no arguments clears the hook exclusively for current filetype.
    if #args.args == 0 then
      ft_commands[ft] = nil
      vim.schedule(function()
        print(string.format("Compiler cleared for filetype: %s", ft))
      end)
      return
    end

    ft_commands[ft] = args.args

    vim.schedule(function()
      print(string.format("[%s] Compiler configured: %s (triggers on save)", ft, ft_commands[ft]))
    end)
  end, { nargs = "*" })

  P.loaded = true
end

return P
