return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "qwen2.5-coder-custom", -- The default model to use.
    quit_map = "q", -- set keymap to close the response window
    retry_map = "<c-r>", -- set keymap to re-send the current prompt
    accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
    host = "100.64.0.150", -- The host running the Ollama service.
    port = "11434", -- The port on which the Ollama service is listening.
    display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
    show_prompt = true, -- Shows the prompt submitted to Ollama.
    show_model = true, -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = false, -- Never closes the window automatically.
    file = false, -- Write the payload to a temporary file to keep the command short.
    hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
    -- init = function(options)
    --   pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    -- end,
    init = nil,
    -- Function to initialize Ollama
    command = function(options)
      local body = { model = options.model, stream = true }
      return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
    end,
    -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
    -- This can also be a command string.
    -- The executed command must return a JSON object with { response, context }
    -- (context property is optional).
    -- list_models = '<omitted lua function>', -- Retrieves a list of model names
    debug = false, -- Prints errors and the command which is run.
  },
  config = function()
    require("gen").prompts["Elaborate_Text"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize in architecture and design patterns, Elaborate the following text:\n$text",
      replace = true,
    }
    require("gen").prompts["Fix_Code"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize in architecture and design patterns, Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```",
    }
    require("gen").prompts["DevOps"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize in architecture and design patterns. You offer help with cloud technologies like: Ansible, Golang, Docker, python. You answer with code examples when possible. $input:\n$text",
      replace = true,
    }
    require("gen").prompts["Commit"] = {
      prompt = "You are Qwen, created by Alibaba Cloud. You are a helpful assistant. you specialize in architecture and design patterns. you perform code analysis and you create git commit messages efficiently, provide summary of changes with enough detail to uderstand the context but not too much, only provide the commit message using proper commit etiquette and never wrap it in markdown code blocks. $input:\n$text",
      replace = true,
    }
    require("gen").setup({

      model = "qwen2.5-coder-custom", -- The default model to use.
      quit_map = "q", -- set keymap to close the response window
      retry_map = "<c-r>", -- set keymap to re-send the current prompt
      accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
      host = "100.64.0.150", -- The host running the Ollama service.
      port = "11434", -- The port on which the Ollama service is listening.
      display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = false, -- Shows the prompt submitted to Ollama.
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false, -- Never closes the window automatically.
      file = false, -- Write the payload to a temporary file to keep the command short.
      hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
      -- init = function(options)
      --   pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      -- end,
      init = nil,
      -- Function to initialize Ollama
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false, -- Prints errors and the command which is run.
    })
  end,
}
