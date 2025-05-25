vim.api.nvim_create_user_command("RuffCheck", function()
  vim.fn.jobstart({ "ruff", "check", "--output-format=json", "." }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data or #data == 0 then
        return
      end

      local json_str = table.concat(data, "\n"):gsub("^%s*(.-)%s*$", "%1")
      if json_str == "" then
        vim.fn.setqflist({})
        return
      end

      local ok, issues = pcall(vim.json.decode, json_str)
      if not ok or not issues then
        return
      end

      local qf_list = {}
      for _, issue in ipairs(issues) do
        table.insert(qf_list, {
          filename = issue.filename,
          lnum = issue.location.row,
          col = issue.location.column,
          text = string.format("[%s] %s", issue.code, issue.message),
        })
      end

      vim.fn.setqflist(qf_list, "r")
      if #qf_list > 0 then
        vim.cmd("copen")
      end
    end,
  })
end, {})
