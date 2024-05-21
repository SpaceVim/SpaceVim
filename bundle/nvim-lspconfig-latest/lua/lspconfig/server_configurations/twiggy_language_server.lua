local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'twiggy-language-server', '--stdio' },
    filetypes = { 'twig' },
    root_dir = util.root_pattern('composer.json', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/moetelo/twiggy

`twiggy-language-server` can be installed via `npm`:
```sh
npm install -g twiggy-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("composer.json", ".git")]],
    },
  },
}
