local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pyre', 'persistent' },
    filetypes = { 'python' },
    root_dir = util.root_pattern '.pyre_configuration',
  },
  docs = {
    description = [[
https://pyre-check.org/

`pyre` a static type checker for Python 3.

`pyre` offers an extremely limited featureset. It currently only supports diagnostics,
which are triggered on save.

Do not report issues for missing features in `pyre` to `lspconfig`.

]],
  },
}
