local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'quick-lint-js', '--lsp-server' },
    filetypes = { 'javascript', 'typescript' },
    root_dir = util.root_pattern('package.json', 'jsconfig.json', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://quick-lint-js.com/

quick-lint-js finds bugs in JavaScript programs.

See installation [instructions](https://quick-lint-js.com/install/)
]],
  },
}
