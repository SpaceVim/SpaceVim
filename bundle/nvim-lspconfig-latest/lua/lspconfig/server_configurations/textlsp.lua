local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'textlsp' },
    filetypes = { 'text', 'tex', 'org' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    settings = {
      textLSP = {
        analysers = {
          -- by default all analysers are disabled in textLSP, since many of them
          -- need custom settings. See github page. LanguageTool is enaled here
          -- only for a quick test.
          languagetool = {
            enabled = true,
            check_text = {
              on_open = true,
              on_save = true,
              on_change = false,
            },
          },
        },
        documents = {
          org = {
            org_todo_keywords = {
              'TODO',
              'IN_PROGRESS',
              'DONE',
            },
          },
        },
      },
    },
  },
  docs = {
    description = [[
https://github.com/hangyav/textLSP

`textLSP` is an LSP server for text spell and grammar checking with various AI tools.
It supports multiple text file formats, such as LaTeX, Org or txt.

For the available text analyzer tools and their configuration, see the [GitHub](https://github.com/hangyav/textLSP) page.
By default, all analyzers are disabled in textLSP, since most of them need special settings.
For quick testing, LanguageTool is enabled in the default `nvim-lspconfig` configuration.

To install run: `pip install textLSP`
]],
  },
}
