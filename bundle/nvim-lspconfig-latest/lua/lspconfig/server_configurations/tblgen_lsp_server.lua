local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tblgen-lsp-server' },
    filetypes = { 'tablegen' },
    root_dir = function(fname)
      return util.root_pattern 'tablegen_compile_commands.yml'(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#tablegen-lsp-language-server--tblgen-lsp-server

The Language Server for the LLVM TableGen language

`tblgen-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
  },
}
