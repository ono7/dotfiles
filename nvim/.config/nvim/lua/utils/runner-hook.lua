-- First module (P)
local P = {}
local monitor_file = nil
local monitor_cmd = nil

local function execute_command()
  if monitor_cmd then
    -- Using schedule_wrap to avoid "Press ENTER" prompt from multiple messages
    vim.schedule(function()
      vim.cmd("M " .. monitor_cmd)
    end)
  end
end

local function setup_autocommand()
  local group = vim.api.nvim_create_augroup("FileMonitorGroup", { clear = true })
  if monitor_file then
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = group,
      pattern = monitor_file,
      callback = function()
        -- Delay the execution slightly to allow the "file written" message to clear
        vim.defer_fn(function()
          execute_command()
        end, 10)
      end,
    })
  end
end

function P.setup()
  if P.loaded then
    return
  end

  vim.api.nvim_create_user_command("H", function(args)
    if #args.args == 0 then
      monitor_file = nil
      monitor_cmd = nil
      setup_autocommand()
      vim.schedule(function()
        vim.notify("Hook cleared")
      end)
      return
    end

    monitor_file = vim.api.nvim_buf_get_name(0)
    monitor_cmd = args.args
    setup_autocommand()

    -- Schedule the print message
    vim.schedule(function()
      vim.notify(string.format("CMD Hook: %s\nMonitoring %s for changes.", monitor_cmd, monitor_file))
    end)

    -- Execute the command immediately once
    execute_command()
  end, { nargs = "*" })

  P.loaded = true
end

return P
