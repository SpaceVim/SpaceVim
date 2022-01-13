local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'

local name = 'java_language_server'

configs[name] = {
  default_config = {
    filetypes = { 'java' },
    root_dir = lspconfig.util.root_pattern('build.gradle', 'pom.xml', '.git'),
    settings = {},
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/georgewfraser/java-language-server/master/package.json',
    description = [[
https://github.com/georgewfraser/java-language-server

Java language server

Point `cmd` to `lang_server_linux.sh` or the equivalent script for macOS/Windows provided by java-language-server
]],
  },
}
