local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'dfy', 'dafny' },
    root_dir = function(fname)
      util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
    NeoVim support for the Dafny language server.
    Please follow the instructions and compile the language server from source:
    https://github.com/dafny-lang/language-server-csharp

    Note that there is no default cmd set. You must set it yourself. The recommended way is to use `{"dotnet", "<Path to your language server>"}`.
]],
  },
}
