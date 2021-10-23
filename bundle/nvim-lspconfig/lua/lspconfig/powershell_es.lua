local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'powershell_es'
local temp_path = vim.fn.stdpath 'cache'

local function make_cmd(bundle_path)
  if bundle_path ~= nil then
    local command_fmt =
      [[%s/PowerShellEditorServices/Start-EditorServices.ps1 -BundledModulesPath %s -LogPath %s/powershell_es.log -SessionDetailsPath %s/powershell_es.session.json -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
    local command = command_fmt:format(bundle_path, bundle_path, temp_path, temp_path)
    return { 'pwsh', '-NoLogo', '-NoProfile', '-Command', command }
  end
end

configs[server_name] = {
  default_config = {
    on_new_config = function(new_config, _)
      local bundle_path = new_config.bundle_path
      new_config.cmd = make_cmd(bundle_path)
    end,
    filetypes = { 'ps1' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
  },
  docs = {
    description = [[
https://github.com/PowerShell/PowerShellEditorServices

Language server for PowerShell.

To install, download and extract PowerShellEditorServices.zip
from the [releases](https://github.com/PowerShell/PowerShellEditorServices/releases).
To configure the language server, set the property `bundle_path` to the root
of the extracted PowerShellEditorServices.zip.

The default configuration doesn't set `cmd` unless `bundle_path` is specified.

```lua
require'lspconfig'.powershell_es.setup{
  bundle_path = 'c:/w/PowerShellEditorServices',
}
```

If necessary, specific `cmd` can be defined instead of `bundle_path`.
See [PowerShellEditorServices](https://github.com/PowerShell/PowerShellEditorServices#stdio)
to learn more.

```lua
require'lspconfig'.powershell_es.setup{
  cmd = {'pwsh', '-NoLogo', '-NoProfile', '-Command', "c:/PSES/Start-EditorServices.ps1 ..."}
}
```
]],
    default_config = {
      root_dir = 'git root or current directory',
    },
  },
}
