local M = {}
function M.setup()
  if M.loaded then
    return
  end
  local term_size = 10
  vim.api.nvim_create_user_command("M", function(args)
    -- Close any existing scratch buffer first
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "nofile" and not vim.bo[buf].buflisted then
        vim.api.nvim_win_close(win, true)
      end
    end

    if #args.args == 0 then
      vim.schedule(function()
        print("missing cmd")
      end)
      return
    end
    local cmd_str = args.args:gsub("%%", vim.fn.expand("%:p"))
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
        vim.schedule(function()
          local terminal_buf = vim.api.nvim_create_buf(false, true)
          vim.bo[terminal_buf].bufhidden = "wipe"
          vim.bo[terminal_buf].buflisted = false
          vim.bo[terminal_buf].buftype = "nofile"
          vim.cmd("belowright " .. term_size .. "split")
          local win_id = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win_id, terminal_buf)
          vim.api.nvim_buf_set_lines(terminal_buf, 0, -1, false, lines)
        end)
      end
    end
    local job_id = vim.fn.jobstart({ "sh", "-c", cmd_str }, {
      stdout_buffered = true,
      on_stdout = append_data,
      on_stderr = append_data,
      on_exit = on_exit,
    })
    vim.schedule(function()
      print(string.format("< job_id: %s, finished >", job_id))
    end)
  end, { nargs = "*" })
  M.loaded = true
end
return M
