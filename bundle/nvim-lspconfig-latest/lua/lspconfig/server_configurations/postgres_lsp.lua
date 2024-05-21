local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'postgres_lsp' },
    filetypes = { 'sql' },
    root_dir = util.root_pattern 'root-file.txt',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/supabase/postgres_lsp

A Language Server for Postgres
        ]],
    default_config = {
      root_dir = [[util.root_pattern 'root-file.txt']],
    },
  },
}
