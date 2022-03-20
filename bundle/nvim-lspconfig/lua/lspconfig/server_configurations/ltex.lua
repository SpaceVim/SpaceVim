local util = require 'lspconfig.util'

local language_id_mapping = {
  bib = 'bibtex',
  plaintex = 'tex',
  rnoweb = 'sweave',
  rst = 'restructuredtext',
  tex = 'latex',
  xhtml = 'xhtml',
}

local bin_name = 'ltex-ls'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

return {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'bib', 'gitcommit', 'markdown', 'org', 'plaintex', 'rst', 'rnoweb', 'tex' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    get_language_id = function(_, filetype)
      local language_id = language_id_mapping[filetype]
      if language_id then
        return language_id
      else
        return filetype
      end
    end,
  },
  docs = {
    description = [=[
https://github.com/valentjn/ltex-ls

LTeX Language Server: LSP language server for LanguageTool 🔍✔️ with support for LaTeX 🎓, Markdown 📝, and others

To install, download the latest [release](https://github.com/valentjn/ltex-ls/releases) and ensure `ltex-ls` is on your path.

To support org files or R sweave, users can define a custom filetype autocommand (or use a plugin which defines these filetypes):

```lua
vim.cmd [[ autocmd BufRead,BufNewFile *.org set filetype=org ]]
```
]=],
  },
}
