local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'clojure-lsp' },
    filetypes = { 'clojure', 'edn' },
    root_dir = util.root_pattern('project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git'),
  },
  docs = {
    description = [[
https://github.com/snoe/clojure-lsp

Clojure Language Server
]],
    default_config = {
      root_dir = [[root_pattern("project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git")]],
    },
  },
}
