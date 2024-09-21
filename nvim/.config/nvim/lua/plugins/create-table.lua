function csv_to_markdown_table()
  -- Get the start and end line numbers of the visual selection
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Transform lines into markdown table rows
  local table_rows = {}
  for _, line in ipairs(lines) do
    local columns = vim.split(line, ",")
    local markdown_row = "| " .. table.concat(columns, " | ") .. " |"
    table.insert(table_rows, markdown_row)
  end

  -- Replace the selected lines with the markdown table
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, table_rows)
end

-- Create a command to call the function
vim.api.nvim_create_user_command("CsvToMarkdownTable", csv_to_markdown_table, { range = true })
