vim.api.nvim_create_user_command("Ruf", function(opts)
  local target = opts.fargs[1] or "."
  target = vim.fn.expand(target)

  vim.fn.jobstart({ "ruff", "check", "--output-format=json", target }, {
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
        local short_filename = issue.filename:match("([^/]+/[^/]+)$") or issue.filename
        local bufnr = vim.fn.bufnr(issue.filename, true)
        local code = issue.code or "SYNTAX"
        table.insert(qf_list, {
          bufnr = bufnr,
          filename = short_filename,
          lnum = issue.location.row,
          col = issue.location.column,
          text = string.format("[%s] %s", code, issue.message),
        })
      end
      vim.fn.setqflist(qf_list, "r")
      if #qf_list > 0 then
        vim.cmd("copen 7")
      end
    end,
  })
end, { nargs = "?" })
