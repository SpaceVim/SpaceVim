local util = require 'lspconfig.util'

local bin_name = 'ds-pinyin-lsp'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.exe'
end

local function ds_pinyin_lsp_off(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local ds_pinyin_lsp_client = util.get_active_client_by_name(bufnr, 'ds_pinyin_lsp')
  if ds_pinyin_lsp_client then
    ds_pinyin_lsp_client.notify('$/turn/completion', {
      ['completion_on'] = false,
    })
  else
    vim.notify 'notification $/turn/completion is not supported by any servers active on the current buffer'
  end
end

local function ds_pinyin_lsp_on(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local ds_pinyin_lsp_client = util.get_active_client_by_name(bufnr, 'ds_pinyin_lsp')
  if ds_pinyin_lsp_client then
    ds_pinyin_lsp_client.notify('$/turn/completion', {
      ['completion_on'] = true,
    })
  else
    vim.notify 'notification $/turn/completion is not supported by any servers active on the current buffer'
  end
end

return {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'markdown', 'org' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    init_options = {
      completion_on = true,
      show_symbols = true,
      show_symbols_only_follow_by_hanzi = false,
      show_symbols_by_n_times = 0,
      match_as_same_as_input = true,
      match_long_input = true,
      max_suggest = 15,
    },
  },
  commands = {
    DsPinyinCompletionOff = {
      function()
        ds_pinyin_lsp_off(0)
      end,
      description = 'Turn off the ds-pinyin-lsp completion',
    },
    DsPinyinCompletionOn = {
      function()
        ds_pinyin_lsp_on(0)
      end,
      description = 'Turn on the ds-pinyin-lsp completion',
    },
  },
  docs = {
    description = [=[
https://github.com/iamcco/ds-pinyin-lsp
Dead simple Pinyin language server for input Chinese without IME(input method).
To install, download the latest [release](https://github.com/iamcco/ds-pinyin-lsp/releases) and ensure `ds-pinyin-lsp` is on your path.
And make ensure the database file `dict.db3` is also downloaded. And put the path to `dict.dbs` in the following code.

```lua

require('lspconfig').ds_pinyin_lsp.setup {
    init_options = {
        db_path = "your_path_to_database"
    }
}

```
]=],
  },
}
