local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'helm_ls', 'serve' },
    filetypes = { 'helm' },
    root_dir = util.root_pattern 'Chart.yaml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/mrjosh/helm-ls

Helm Language server. (This LSP is in early development)

`helm Language server` can be installed by following the instructions [here](https://github.com/mrjosh/helm-ls).

The default `cmd` assumes that the `helm_ls` binary can be found in `$PATH`.

If need Helm file highlight use [vim-helm](https://github.com/towolf/vim-helm) plugin.
]],
    default_config = {
      root_dir = [[root_pattern("Chart.yaml")]],
    },
  },
}
