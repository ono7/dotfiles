return {
  "David-Kunz/gen.nvim",
  config = function()
    require("gen").prompts["Teach"] = {
      prompt = [[You are Qwen, created by Alibaba Cloud. You are a helpful assistant. You specialize in software architecture and design patterns, Elaborate the following text:

Before providing the solution, I will:
1. Break down the problem systematically using these steps:
   - Input/Output analysis
   - Example cases and edge cases
   - Problem constraints and requirements
   - Core patterns or algorithms that apply

2. Provide my solution in this format:
   - Step-by-step problem decomposition
   - Pseudocode implementation
   - Actual code with detailed comments
   - Time/space complexity analysis
   - Alternative approaches and their trade-offs

3. Explain my problem-solving strategy by:
   - Identifying common programming patterns used
   - Highlighting key decision points
   - Explaining why certain approaches were chosen
   - Discussing potential optimizations

4. Include test cases that:
   - Cover normal scenarios
   - Handle edge cases
   - Demonstrate boundary conditions

Now, please help me solve this programming problem:

$text"]],
      replace = false,
    }
    require("gen").prompts["Elaborate_Text"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize in software architecture and design patterns, Elaborate the following text:\n$text",
      replace = true,
    }
    require("gen").prompts["Fix_Code"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize in software architecture and design patterns, Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```",
    }
    require("gen").prompts["DevOps"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize software architecture and design patterns. You offer help with cloud technologies like: Ansible, Golang, Docker, python. You answer with code examples when possible. $input:\n$text",
      replace = true,
    }
    require("gen").prompts["Commit"] = {
      -- prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize software architecture and design patterns. you perform code analysis and you create git commit messages efficiently, provide summary of changes with enough detail to uderstand the context but not too much, only provide the commit message using proper commit etiquette and never wrap it in markdown code blocks. $input:\n$text",
      prompt = "You are an expert in writing clear and concise Git commit messages. Given the following code diff from a Git repository, please generate a meaningful commit message that accurately describes the changes made, only provide the commit message and no additional chatter, always use Conventional Commits style. $input:\n$text?",
      replace = true,
    }
    require("gen").setup({

      model = "qwen2.5-coder-custom",
      quit_map = "q",
      retry_map = "<c-r>",
      accept_map = "<c-cr>",
      host = "100.64.0.150",
      -- port = "11434",
      port = "8443",
      display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = false,
      show_model = false,
      no_auto_close = false,
      file = false,
      hidden = false,
      -- open external process with lua
      -- init = function(options)
      --   pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      -- end,
      init = nil,

      command = function(options)
        local body = { model = options.model, stream = true }
        -- return "curl --silent --no-buffer -X POST http://"
        return "curl -k --silent --no-buffer -X POST https://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,

      debug = false,
    })
  end,
}
