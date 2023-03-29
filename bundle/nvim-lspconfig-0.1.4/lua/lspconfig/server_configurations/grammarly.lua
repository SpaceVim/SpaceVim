local util = require 'lspconfig.util'

local bin_name = 'grammarly-languageserver'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    handlers = {
      ['$/updateDocumentState'] = function()
        return ''
      end,
    },
    init_options = {
      clientId = 'client_BaDkMgx4X19X9UxxYRCXZo',
    },
  },
  docs = {
    description = [[
https://github.com/znck/grammarly

`grammarly-languageserver` can be installed via `npm`:

```sh
npm i -g grammarly-languageserver
```

WARNING: Since this language server uses Grammarly's API, any document you open with it running is shared with them. Please evaluate their [privacy policy](https://www.grammarly.com/privacy-policy) before using this.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
