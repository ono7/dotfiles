local curl = require('plenary.curl')
local jira_main = require('jira-base')

local function clone_issue(issue_key, num_clones)
  if not jira_main.setup() then
    return
  end

  -- Encode credentials
  local auth = vim.base64.encode(jira_main.config.jira_email .. ':' .. jira_main.config.jira_api_token)

  -- First, get the issue details
  local response = curl.get(jira_main.config.jira_url .. '/rest/api/2/issue/' .. issue_key, {
    headers = {
      Authorization = 'Basic ' .. auth,
      ['Content-Type'] = 'application/json',
    },
  })

  if response.status ~= 200 then
    jira_main.display_message('Failed to fetch issue details. Status: ' .. response.status, vim.log.levels.ERROR)
    return
  end

  local issue = vim.fn.json_decode(response.body)

  -- Prepare the payload for cloning
  local clone_payload = {
    fields = {
      project = { key = issue.fields.project.key },
      summary = issue.fields.summary .. " (Clone)",
      issuetype = { id = issue.fields.issuetype.id },
      assignee = { name = jira_main.config.jira_email:match("(.+)@") }, -- Assign to current user
      description = issue.fields.description
    }
  }

  -- Clone the issue the specified number of times
  for i = 1, num_clones do
    local clone_response = curl.post(jira_main.config.jira_url .. '/rest/api/2/issue', {
      body = vim.fn.json_encode(clone_payload),
      headers = {
        Authorization = 'Basic ' .. auth,
        ['Content-Type'] = 'application/json',
      },
    })

    if clone_response.status ~= 201 then
      jira_main.display_message('Failed to clone issue. Status: ' .. clone_response.status, vim.log.levels.ERROR)
    else
      local new_issue = vim.fn.json_decode(clone_response.body)
      jira_main.display_message('Created clone: ' .. new_issue.key, vim.log.levels.INFO)
    end
  end
end

-- Function to handle the JiraClone command
local function jira_clone_command(args)
  if #args ~= 2 then
    jira_main.display_message("Usage: JiraClone <issue-key> <number-of-clones>", vim.log.levels.ERROR)
    return
  end

  local issue_key = args[1]
  local num_clones = tonumber(args[2])

  if not num_clones or num_clones < 1 then
    jira_main.display_message("Number of clones must be a positive integer", vim.log.levels.ERROR)
    return
  end

  clone_issue(issue_key, num_clones)
end

-- New command to clone issues
vim.api.nvim_create_user_command('JiraClone', function(opts)
  jira_clone_command(opts.fargs)
end, { nargs = '+' })

return {
  clone_issue = clone_issue
}
