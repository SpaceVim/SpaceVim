local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = 'ansiblels'

configs[server_name] = {
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
      },
    },
    filetypes = { 'yaml' },
    root_dir = function(fname)
      return util.root_pattern { '*.yml', '*.yaml' }(fname)
    end,
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
