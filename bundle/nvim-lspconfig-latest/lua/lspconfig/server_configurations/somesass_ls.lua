local util = require 'lspconfig.util'

return {
  default_config = {
    name = 'somesass_ls',
    cmd = { 'some-sass-language-server', '--stdio' },
    filetypes = { 'scss', 'sass' },
    root_dir = util.root_pattern('.git', '.package.json'),
    single_file_support = true,
    settings = {
      somesass = {
        suggestAllFromOpenDocument = true,
      },
    },
  },
  docs = {
    description = [[

https://github.com/wkillerud/some-sass/tree/main/packages/language-server

`some-sass-language-server` can be installed via `npm`:

```sh
npm i -g some-sass-language-server
```

The language server provides:

- Full support for @use and @forward, including aliases, prefixes and hiding.
- Workspace-wide code navigation and refactoring, such as Rename Symbol.
- Rich documentation through SassDoc.
- Language features for %placeholder-selectors, both when using them and writing them.
- Suggestions and hover info for built-in Sass modules, when used with @use.

]],
    default_config = {
      root_dir = [[root_pattern("package.json", ".git") or bufdir]],
    },
  },
}
