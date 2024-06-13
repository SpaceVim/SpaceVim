local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_dir = util.root_pattern 'Dockerfile',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/rcjsuen/dockerfile-language-server-nodejs

`docker-langserver` can be installed via `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Dockerfile")]],
    },
  },
}
