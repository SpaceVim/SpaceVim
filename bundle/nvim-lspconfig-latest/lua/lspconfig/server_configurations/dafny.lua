local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'dafny', 'server' },
    filetypes = { 'dfy', 'dafny' },
    root_dir = function(fname)
      util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
    Support for the Dafny language server.

    The default `cmd` uses "dafny server", which works on Dafny 4.0.0+. For
    older versions of Dafny, you can compile the language server from source at
    [dafny-lang/language-server-csharp](https://github.com/dafny-lang/language-server-csharp)
    and set `cmd = {"dotnet", "<Path to your language server>"}`.
    ]],
  },
}
