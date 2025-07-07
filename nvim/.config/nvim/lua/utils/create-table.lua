local M = {}

function M.setup()
  -- Check if already loaded
  if M.loaded then
    return
  end

  local function csv_to_markdown_table(opts)
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
          print("use: commas to separate table columns 'a, b, c'")
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
    ::continue::
    -- Join the table rows into a single string
    local markdown_table = table.concat(table_rows, "\n")
    -- Use Prettier to format the markdown table
    local formatted_table = vim.fn.system('prettier --parser markdown', markdown_table)
    -- Split the formatted table back into lines
    local formatted_lines = vim.split(formatted_table, "\n")
    -- Remove any trailing empty lines
    while #formatted_lines > 0 and formatted_lines[#formatted_lines] == "" do
      table.remove(formatted_lines)
    end
    -- Replace the selected lines with the formatted markdown table
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, formatted_lines)
  end

  -- Function to format Markdown selection
  local function format_markdown_selection(start_line, end_line)
    -- Get the selected lines
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    -- Join the lines into a single string
    local markdown_text = table.concat(lines, "\n")
    -- Use Prettier to format the markdown
    local formatted_text = vim.fn.system('prettier --parser markdown', markdown_text)
    -- Split the formatted text back into lines
    local formatted_lines = vim.split(formatted_text, "\n")
    -- Remove any trailing empty lines
    while #formatted_lines > 0 and formatted_lines[#formatted_lines] == "" do
      table.remove(formatted_lines)
    end
    -- Replace the selected lines with the formatted markdown
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, formatted_lines)
  end

  -- Create commands to call the functions
  vim.api.nvim_create_user_command("Table", csv_to_markdown_table, { range = true })
  vim.api.nvim_create_user_command("FormatMarkdown", function(opts)
    format_markdown_selection(opts.line1, opts.line2)
  end, { range = true })

  M.loaded = true
end

return M
