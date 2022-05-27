local util = require 'lspconfig.util'

local bin_name = 'ansible-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    settings = {
      ansible = {
        python = {
          interpreterPath = 'python',
        },
        ansibleLint = {
          path = 'ansible-lint',
          enabled = true,
        },
        ansible = {
          path = 'ansible',
        },
        executionEnvironment = {
          enabled = false,
        },
      },
    },
    filetypes = { 'yaml.ansible' },
    root_dir = util.root_pattern('ansible.cfg', '.ansible-lint'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ansible/ansible-language-server

Language server for the ansible configuration management tool.

`ansible-language-server` can be installed via `npm`:

```sh
npm install -g @ansible/ansible-language-server
```
]],
  },
}
