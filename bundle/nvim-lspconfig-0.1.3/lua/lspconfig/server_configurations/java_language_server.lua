local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'java' },
    root_dir = util.root_pattern('build.gradle', 'pom.xml', '.git'),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/georgewfraser/java-language-server

Java language server

Point `cmd` to `lang_server_linux.sh` or the equivalent script for macOS/Windows provided by java-language-server
]],
  },
}
