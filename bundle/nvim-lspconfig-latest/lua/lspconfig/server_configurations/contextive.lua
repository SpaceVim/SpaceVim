local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'Contextive.LanguageServer' },
    root_dir = util.root_pattern('.contextive', '.git'),
  },
  docs = {
    description = [[
https://github.com/dev-cycles/contextive

Language Server for Contextive.

Contextive allows you to define terms in a central file and provides auto-completion suggestions and hover panels for these terms wherever they're used.

To install the language server, you need to download the appropriate [GitHub release asset](https://github.com/dev-cycles/contextive/releases/) for your operating system and architecture.

After the download unzip the Contextive.LanguageServer binary and copy the file into a folder that is included in your system's PATH.
]],
  },
}
