local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'glsl_analyzer' },
    filetypes = { 'glsl', 'vert', 'tesc', 'tese', 'frag', 'geom', 'comp' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    capabilities = {},
  },
  docs = {
    description = [[
https://github.com/nolanderc/glsl_analyzer

Language server for GLSL
    ]],
  },
}
