local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mlir-lsp-server' },
    filetypes = { 'mlir' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#mlir-lsp-language-server--mlir-lsp-server=

The Language Server for the LLVM MLIR language

`mlir-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
  },
}
