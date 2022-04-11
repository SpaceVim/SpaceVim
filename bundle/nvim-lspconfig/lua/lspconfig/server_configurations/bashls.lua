local util = require 'lspconfig.util'

local bin_name = 'bash-language-server'
local cmd = { bin_name, 'start' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'start' }
end

return {
  default_config = {
    cmd = cmd,
    cmd_env = {
      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      GLOB_PATTERN = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
    filetypes = { 'sh' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/mads-hartmann/bash-language-server

`bash-language-server` can be installed via `npm`:
```sh
npm i -g bash-language-server
```

Language server for bash, written using tree sitter in typescript.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
