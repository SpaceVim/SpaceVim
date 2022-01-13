local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.hie = {
  default_config = {
    cmd = { 'hie-wrapper', '--lsp' },
    filetypes = { 'haskell' },
    root_dir = util.root_pattern('stack.yaml', 'package.yaml', '.git'),
  },

  docs = {
    package_json = 'https://raw.githubusercontent.com/alanz/vscode-hie-server/master/package.json',
    description = [[
https://github.com/haskell/haskell-ide-engine

the following init_options are supported (see https://github.com/haskell/haskell-ide-engine#configuration):
```lua
init_options = {
  languageServerHaskell = {
    hlintOn = bool;
    maxNumberOfProblems = number;
    diagnosticsDebounceDuration = number;
    liquidOn = bool (default false);
    completionSnippetsOn = bool (default true);
    formatOnImportOn = bool (default true);
    formattingProvider = string (default "brittany", alternate "floskell");
  }
}
```
        ]],

    default_config = {
      root_dir = [[root_pattern("stack.yaml", "package.yaml", ".git")]],
    },
  },
}
