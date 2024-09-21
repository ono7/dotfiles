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
  for _, line in ipairs(lines) do
    local columns = vim.split(line, ",")
    -- Trim whitespace from each column
    for i, col in ipairs(columns) do
      columns[i] = col:match("^%s*(.-)%s*$")
    end
    local markdown_row = "| " .. table.concat(columns, " | ") .. " |"
    table.insert(table_rows, markdown_row)
  end

  -- Replace the selected lines with the markdown table
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, table_rows)
end

-- Create a command to call the function
vim.api.nvim_create_user_command("Table", csv_to_markdown_table, { range = true })
