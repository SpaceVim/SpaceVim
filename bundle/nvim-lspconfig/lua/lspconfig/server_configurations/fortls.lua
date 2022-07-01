local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'fortls',
      '--notify_init',
      '--hover_signature',
      '--hover_language=fortran',
      '--use_signature_help',
    },
    filetypes = { 'fortran' },
    root_dir = function(fname)
      return util.root_pattern '.fortls'(fname) or util.find_git_ancestor(fname)
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/gnikit/fortls

fortls is a Fortran Language Server, the server can be installed via pip

```sh
pip install fortls
```

Settings to the server can be passed either through the `cmd` option or through
a local configuration file e.g. `.fortls`. For more information
see the `fortls` [documentation](https://gnikit.github.io/fortls/options.html).
    ]],
    default_config = {
      root_dir = [[root_pattern(".fortls")]],
    },
  },
}
