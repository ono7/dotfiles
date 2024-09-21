local function create_table_from_line()
  -- Get the current line
  local line = vim.api.nvim_get_current_line()

  -- Split the line by commas (allowing for optional spaces after the commas)
  local items = vim.split(line, ",%s*")

  -- Create the table header
  local table_header = "| " .. table.concat(items, " | ") .. " |"

  -- Create the separator line
  local separator = "|" .. string.rep("-|", #items)

  -- Get the current cursor position
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  -- Replace the current line with the table header
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { table_header })

  -- Insert the separator line below
  vim.api.nvim_buf_set_lines(0, row, row, false, { separator })
end

-- Create the command
vim.api.nvim_create_user_command("Table", create_table_from_line, {})
