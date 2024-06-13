local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ansible-language-server', '--stdio' },
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
    filetypes = { 'yaml', 'yaml.ansible' },
    root_dir = util.root_pattern('ansible.cfg', '.ansible-lint'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ansible/ansible-language-server

Language server for the ansible configuration management tool.

`ansible-language-server` can be installed via `yarn`:
```sh
yarn global add ansible-language-server
```
]],
  },
}
