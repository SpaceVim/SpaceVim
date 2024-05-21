local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_dir = util.find_git_ancestor,
    single_file_support = false,
  },
  docs = {
    description = [[
https://github.com/Myriad-Dreamin/tinymist
An integrated language service for Typst [taɪpst]. You can also call it "微霭" [wēi ǎi] in Chinese.
    ]],
  },
}
