local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.cucumber_language_server = {
  default_config = {
    cmd = { 'cucumber-language-server', '--stdio' },
    filetypes = { 'cucumber' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/cucumber/common/main/language-server/javascript/package.json',
    description = [[
https://cucumber.io
https://github.com/cucumber/common
https://www.npmjs.com/package/@cucumber/language-server

Language server for Cucumber.

`cucumber-language-server` can be installed via `npm`:
```sh
npm install -g @cucumber/language-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
-- vim:et ts=2 sw=2
