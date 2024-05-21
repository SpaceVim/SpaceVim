local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'elp', 'server' },
    filetypes = { 'erlang' },
    root_dir = util.root_pattern('rebar.config', 'erlang.mk', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://whatsapp.github.io/erlang-language-platform

ELP integrates Erlang into modern IDEs via the language server protocol and was
inspired by rust-analyzer.
]],
    default_config = {
      root_dir = [[root_pattern('rebar.config', 'erlang.mk', '.git')]],
    },
  },
}
