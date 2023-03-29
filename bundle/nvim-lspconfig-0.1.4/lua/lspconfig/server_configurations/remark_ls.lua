local util = require 'lspconfig.util'

local bin_name = 'remark-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/remarkjs/remark-language-server

`remark-language-server` can be installed via `npm`:
```sh
npm install -g remark-language-server
```

`remark-language-server` uses the same
[configuration files](https://github.com/remarkjs/remark/tree/main/packages/remark-cli#example-config-files-json-yaml-js)
as `remark-cli`.

This uses a plugin based system. Each plugin needs to be installed locally using `npm` or `yarn`.

For example, given the following `.remarkrc.json`:

```json
{
  "presets": [
    "remark-preset-lint-recommended"
  ]
}
```

`remark-preset-lint-recommended` needs to be installed in the local project:

```sh
npm install remark-preset-lint-recommended
```

]],
  },
}
