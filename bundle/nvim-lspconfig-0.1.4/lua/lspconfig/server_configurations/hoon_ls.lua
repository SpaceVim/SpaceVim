local util = require 'lspconfig.util'

local bin_name = 'hoon-language-server'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'hoon' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/urbit/hoon-language-server

A language server for Hoon.

The language server can be installed via `npm install -g @hoon-language-server`

Start a fake ~zod with `urbit -F zod`.
Start the language server at the Urbit Dojo prompt with: `|start %language-server`
]],
  },
}
