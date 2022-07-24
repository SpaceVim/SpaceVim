local util = require 'lspconfig.util'

local bin_name = 'emmet-ls'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/aca/emmet-ls

Package can be installed via `npm`:
```sh
npm install -g emmet-ls
```
]],
    default_config = {
      root_dir = 'git root',
      single_file_support = true,
    },
  },
}
