local M = {}

function M.setup()
  -- Check if already loaded
  if M.loaded then
    return
  end

  local term_size = 5

  vim.api.nvim_create_user_command("M", function(args)
    -- Create the buffer
    local terminal_buf = vim.api.nvim_create_buf(false, true)

    -- Create horizontal split at the bottom
    vim.cmd("belowright " .. term_size .. "split")

    -- Get the window ID of the new split and set its buffer
    local win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win_id, terminal_buf)

    -- Set up the job output handling
    local append_data = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(terminal_buf, -1, -1, false, data)
      end
    end

    vim.fn.jobstart(args.args, {
      stdout_buffered = false,
      on_stdout = append_data,
      on_stderr = append_data,
    })
  end, { nargs = "*" })

  M.loaded = true
end

return M
