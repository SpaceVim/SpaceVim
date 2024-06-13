local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ember-language-server', '--stdio' },
    filetypes = { 'handlebars', 'typescript', 'javascript' },
    root_dir = util.root_pattern('ember-cli-build.js', '.git'),
  },
  docs = {
    description = [[
https://github.com/lifeart/ember-language-server

`ember-language-server` can be installed via `npm`:

```sh
npm install -g @lifeart/ember-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("ember-cli-build.js", ".git")]],
    },
  },
}
