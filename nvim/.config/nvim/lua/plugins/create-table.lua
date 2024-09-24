function csv_to_markdown_table(opts)
  local start_line, end_line
  if opts.range == 0 then
    -- No visual selection, use current line
    start_line = vim.fn.line(".")
    end_line = start_line
  else
    -- Visual selection
    start_line = opts.line1
    end_line = opts.line2
  end

  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Transform lines into markdown table rows
  local table_rows = {}
  if #lines > 1 then
    -- Multiple lines selected
    for i, line in ipairs(lines) do
      local columns = vim.split(line, ",")
      if #columns == 1 then
        print("use: commas to separate table columts 'a, b, c'")
        goto continue
      end
      -- Trim whitespace from each column
      for j, col in ipairs(columns) do
        columns[j] = col:match("^%s*(.-)%s*$")
      end
      local markdown_row = "| " .. table.concat(columns, " | ") .. " |"
      table.insert(table_rows, markdown_row)

      -- Add separator row after headers
      if i == 1 then
        local separator = "|" .. string.rep(" --- |", #columns)
        table.insert(table_rows, separator)
      end
    end
  else
    -- Single line
    local line = lines[1]
    if not line:match("^|.*|$") then
      -- If not already a table, preserve original separators
      local columns = {}
      for col in line:gmatch("[^,]+") do
        table.insert(columns, col:match("^%s*(.-)%s*$"))
      end
      if #columns == 1 then
        -- If no commas found, split by spaces
        columns = vim.split(line, "%s+")
      end
      table_rows = { "| " .. table.concat(columns, " | ") .. " |" }
    else
      -- If already a table, leave as is
      table_rows = { line }
    end
  end

  -- Replace the selected lines with the markdown table
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, table_rows)
  ::continue::
end

-- Create a command to call the function
vim.api.nvim_create_user_command("Table", csv_to_markdown_table, { range = true })
