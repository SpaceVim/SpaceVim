local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mlir-pdll-lsp-server' },
    filetypes = { 'pdll' },
    root_dir = function(fname)
      return util.root_pattern 'pdll_compile_commands.yml'(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://mlir.llvm.org/docs/Tools/MLIRLSP/#pdll-lsp-language-server--mlir-pdll-lsp-server

The Language Server for the LLVM PDLL language

`mlir-pdll-lsp-server` can be installed at the llvm-project repository (https://github.com/llvm/llvm-project)
]],
  },
}
