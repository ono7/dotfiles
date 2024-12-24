local M = {}

function M.setup()
  if M.loaded then
    return
  end

  local term_size = 5
  vim.api.nvim_create_user_command("M", function(args)
    if #args.args == 0 then
      print("no command provided")
      return
    end

    local terminal_buf = vim.api.nvim_create_buf(false, true)

    vim.bo[terminal_buf].bufhidden = "wipe"
    vim.bo[terminal_buf].buflisted = false
    vim.bo[terminal_buf].buftype = "nofile"

    vim.cmd("belowright " .. term_size .. "split")
    local win_id = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win_id, terminal_buf)

    local lines = {}
    local append_data = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(lines, line)
          end
        end
      end
    end

    local on_exit = function()
      if #lines > 0 then
        vim.api.nvim_buf_set_lines(terminal_buf, 0, -1, false, lines)
        vim.api.nvim_win_set_cursor(win_id, { #lines, 0 })
      end
    end

    local job_id = vim.fn.jobstart(args.args, {
      stdout_buffered = true,
      on_stdout = append_data,
      on_stderr = "#### ERROR ####\n" .. append_data,
      on_exit = on_exit,
    })
  end, { nargs = "*" })

  M.loaded = true
end

return M
