local util = require 'lspconfig.util'

local workspace_folders = {}

return {
  default_config = {
    cmd = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q' },
    filetypes = { 'ql' },
    root_dir = util.root_pattern 'qlpack.yml',
    log_level = vim.lsp.protocol.MessageType.Warning,
    before_init = function(initialize_params)
      table.insert(workspace_folders, { name = 'workspace', uri = initialize_params['rootUri'] })
      initialize_params['workspaceFolders'] = workspace_folders
    end,
    settings = {
      search_path = vim.empty_dict(),
    },
  },
  docs = {
    description = [[
Reference:
https://codeql.github.com/docs/codeql-cli/

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
        table.insert(workspace_folders, {
          name = 'workspace',
          uri = string.format('file://%s', path),
        })
      end
      config.cmd = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q', search_path }
    else
      config.cmd = { 'codeql', 'execute', 'language-server', '--check-errors', 'ON_CHANGE', '-q' }
    end
  end,
}
