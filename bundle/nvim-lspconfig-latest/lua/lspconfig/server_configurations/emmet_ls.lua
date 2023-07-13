local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'emmet-ls', '--stdio' },
    filetypes = {
      'astro',
      'css',
      'eruby',
      'html',
      'htmldjango',
      'javascriptreact',
      'less',
      'pug',
      'sass',
      'scss',
      'svelte',
      'typescriptreact',
      'vue',
    },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/aca/emmet-ls

Package can be installed via `npm`:
```sh
npm install -g emmet-ls
```
]],
    default_config = {
      root_dir = 'git root',
      single_file_support = true,
    },
  },
}
