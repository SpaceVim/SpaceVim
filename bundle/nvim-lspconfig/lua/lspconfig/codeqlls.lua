local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'codeqlls'

local root_pattern = util.root_pattern 'qlpack.yml'

configs[server_name] = {
  default_config = {
    cmd = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q' },
    filetypes = { 'ql' },
    root_dir = function(fname)
      return root_pattern(fname) or util.path.dirname(fname)
    end,
    log_level = vim.lsp.protocol.MessageType.Warning,
    before_init = function(initialize_params)
      initialize_params['workspaceFolders'] = {
        {
          name = 'workspace',
          uri = initialize_params['rootUri'],
        },
      }
    end,
    settings = {
      search_path = vim.empty_dict(),
    },
  },
  docs = {
    description = [[
Reference:
https://help.semmle.com/codeql/codeql-cli.html

Binaries:
https://github.com/github/codeql-cli-binaries
        ]],
    default_config = {
      settings = {
        search_path = [[list containing all search paths, eg: '~/codeql-home/codeql-repo']],
      },
    },
  },
  on_new_config = function(config)
    if type(config.settings.search_path) == 'table' and not vim.tbl_isempty(config.settings.search_path) then
      local search_path = '--search-path='
      for _, path in ipairs(config.settings.search_path) do
        search_path = search_path .. vim.fn.expand(path) .. ':'
      end
      config.cmd = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q', search_path }
    else
      config.cmd = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q' }
    end
  end,
}
