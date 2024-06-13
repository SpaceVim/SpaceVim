local util = require 'lspconfig.util'

local bin_name = 'svelteserver'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'svelte' },
    root_dir = util.root_pattern('package.json', '.git'),
  },
  docs = {
    description = [[
https://github.com/sveltejs/language-tools/tree/master/packages/language-server

`svelte-language-server` can be installed via `npm`:
```sh
npm install -g svelte-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", ".git")]],
    },
  },
}
