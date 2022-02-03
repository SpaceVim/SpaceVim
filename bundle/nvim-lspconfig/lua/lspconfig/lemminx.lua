local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'lemminx'
configs[server_name] = {
  default_config = {
    filetypes = { 'xml', 'xsd', 'svg' },
    root_dir = function(filename)
      return util.root_pattern '.git'(filename) or util.path.dirname(filename)
    end,
  },
  docs = {
    description = [[
https://github.com/eclipse/lemminx

The easiest way to install the server is to get a binary at https://download.jboss.org/jbosstools/vscode/stable/lemminx-binary/ and place it in your PATH.

**By default, lemminx doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of your unzipped lemminx.

```lua
require'lspconfig'.lemminx.setup{
    cmd = { "/path/to/lemminx/lemminx" };
    ...
}

NOTE to macOS users: Binaries from unidentified developers are blocked by default. If you trust the downloaded binary from jboss.org, run it once, cancel the prompt, then remove the binary from Gatekeeper quarantine with `xattr -d com.apple.quarantine lemminx`. It should now run without being blocked.

]],
  },
}

-- vim:et ts=2 sw=2
