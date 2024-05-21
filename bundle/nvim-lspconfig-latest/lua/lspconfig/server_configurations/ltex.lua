local util = require 'lspconfig.util'

local language_id_mapping = {
  bib = 'bibtex',
  plaintex = 'tex',
  rnoweb = 'rsweave',
  rst = 'restructuredtext',
  tex = 'latex',
  pandoc = 'markdown',
  text = 'plaintext',
}

local bin_name = 'ltex-ls'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

local filetypes = {
  'bib',
  'gitcommit',
  'markdown',
  'org',
  'plaintex',
  'rst',
  'rnoweb',
  'tex',
  'pandoc',
  'quarto',
  'rmd',
  'context',
  'html',
  'xhtml',
  'mail',
  'text',
}

local function get_language_id(_, filetype)
  local language_id = language_id_mapping[filetype]
  if language_id then
    return language_id
  else
    return filetype
  end
end
local enabled_ids = {}
do
  local enabled_keys = {}
  for _, ft in ipairs(filetypes) do
    local id = get_language_id({}, ft)
    if not enabled_keys[id] then
      enabled_keys[id] = true
      table.insert(enabled_ids, id)
    end
  end
end

return {
  default_config = {
    cmd = { bin_name },
    filetypes = filetypes,
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    get_language_id = get_language_id,
    settings = {
      ltex = {
        enabled = enabled_ids,
      },
    },
  },
  docs = {
    description = [=[
https://github.com/valentjn/ltex-ls

LTeX Language Server: LSP language server for LanguageTool 🔍✔️ with support for LaTeX 🎓, Markdown 📝, and others

To install, download the latest [release](https://github.com/valentjn/ltex-ls/releases) and ensure `ltex-ls` is on your path.

This server accepts configuration via the `settings` key.

```lua
  settings = {
		ltex = {
			language = "en-GB",
		},
	},
```

To support org files or R sweave, users can define a custom filetype autocommand (or use a plugin which defines these filetypes):

```lua
vim.cmd [[ autocmd BufRead,BufNewFile *.org set filetype=org ]]
```
]=],
  },
}
