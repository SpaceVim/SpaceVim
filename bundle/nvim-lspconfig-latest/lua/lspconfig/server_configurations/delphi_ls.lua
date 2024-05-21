local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'DelphiLSP.exe' },
    filetypes = { 'pascal' },
    root_dir = util.root_pattern '*.dpr',
    single_file_support = false,
  },
  docs = {
    description = [[
Language server for Delphi from Embarcadero.
https://marketplace.visualstudio.com/items?itemName=EmbarcaderoTechnologies.delphilsp

Note, the '*.delphilsp.json' file is required, more details at:
https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Using_DelphiLSP_Code_Insight_with_Other_Editors

Below, you'll find a sample configuration for the lazy manager.
When on_attach is triggered, it signals DelphiLSP to load settings from a configuration file.
Without this step, DelphiLSP initializes but remains non-functional:

```lua
"neovim/nvim-lspconfig",
lazy = false,
config = function()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require("lspconfig")

  lspconfig.delphi_ls.setup({
    capabilities = capabilities,

    on_attach = function(client)
      local lsp_config = vim.fs.find(function(name)
        return name:match(".*%.delphilsp.json$")
      end, { type = "file", path = client.config.root_dir, upward = false })[1]

      if lsp_config then
        client.config.settings = { settingsFile = lsp_config }
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      else
        vim.notify_once("delphi_ls: '*.delphilsp.json' config file not found")
      end
    end,
  })
end,
```
]],
  },
}
