local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'docker-compose-langserver', '--stdio' },
    filetypes = { 'yaml' },
    root_dir = util.root_pattern 'docker-compose.yaml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/microsoft/compose-language-service
This project contains a language service for Docker Compose.

`compose-language-service` can be installed via `npm`:

```sh
npm install @microsoft/compose-language-service
```
]],
    default_config = {
      root_dir = [[root_pattern("docker-compose.yaml")]],
    },
  },
}
