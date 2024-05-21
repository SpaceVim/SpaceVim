local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ember-language-server', '--stdio' },
    filetypes = { 'handlebars', 'typescript', 'javascript', 'typescript.glimmer', 'javascript.glimmer' },
    root_dir = util.root_pattern('ember-cli-build.js', '.git'),
  },
  docs = {
    description = [[
https://github.com/ember-tooling/ember-language-server

`ember-language-server` can be installed via `npm`:

```sh
npm install -g @ember-tooling/ember-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("ember-cli-build.js", ".git")]],
    },
  },
}
