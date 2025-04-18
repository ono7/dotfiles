return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
  settings = {
    ansible = {
      python = {
        interpreterPath = "python",
      },
      playbook = {
        arguments = { "--syntax-check" },
      },
      ansible = {
        path = "ansible",
      },
      executionEnvironment = {
        enabled = false,
      },
      validation = {
        lint = {
          enabled = true,
          path = "ansible-lint",
        },
      },
    },
  },
}
