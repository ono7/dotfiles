local P = {}
local monitor_file = nil
local monitor_cmd = nil

local function execute_command()
  if monitor_cmd then
    vim.cmd("M " .. monitor_cmd)
  end
end

local function setup_autocommand()
  local group = vim.api.nvim_create_augroup("FileMonitorGroup", { clear = true })

  if monitor_file then
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = group,
      pattern = monitor_file,
      callback = function()
        execute_command()
      end,
    })
  end
end

function P.setup()
  if P.loaded then
    return
  end

  vim.api.nvim_create_user_command("P", function(args)
    if #args.args == 0 then
      -- Clear the monitoring when :P is called without arguments
      monitor_file = nil
      monitor_cmd = nil
      setup_autocommand()
      print("File monitoring cleared")
      return
    end

    -- Get the current buffer's file path
    monitor_file = vim.api.nvim_buf_get_name(0)
    monitor_cmd = args.args

    setup_autocommand()
    print(string.format("Monitoring %s for changes. Will execute: M %s", monitor_file, monitor_cmd))

    -- Execute the command immediately once
    execute_command()
  end, { nargs = "*" })

  P.loaded = true
end

return P
