local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'foam-ls', '--stdio' },
    filetypes = { 'foam', 'OpenFOAM' },
    root_dir = function(fname)
      return util.search_ancestors(fname, function(path)
        if util.path.exists(util.path.join(path, 'system', 'controlDict')) then
          return path
        end
      end)
    end,
  },
  docs = {
    description = [[
https://github.com/FoamScience/foam-language-server

`foam-language-server` can be installed via `npm`
```sh
npm install -g foam-language-server
```
]],
  },
}
