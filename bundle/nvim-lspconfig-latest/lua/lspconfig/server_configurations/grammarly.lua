local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'grammarly-languageserver', '--stdio' },
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
