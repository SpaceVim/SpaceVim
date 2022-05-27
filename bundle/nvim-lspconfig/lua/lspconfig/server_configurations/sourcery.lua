local util = require 'lspconfig/util'

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
}

return {
  default_config = {
    cmd = { 'sourcery', 'lsp' },
    filetypes = { 'python' },
    init_options = {
      editor_version = 'vim',
      extension_version = 'vim.lsp',
      token = nil,
    },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  on_new_config = function(new_config, _)
    if not new_config.init_options.token then
      local notify = vim.notify_once or vim.notify
      notify('[lspconfig] The authentication token must be provided in config.init_options', vim.log.levels.ERROR)
    end
  end,
  docs = {
    description = [[
https://github.com/sourcery-ai/sourcery

Refactor Python instantly using the power of AI.

It requires the initializationOptions param to be populated as shown below and will respond with the list of ServerCapabilities that it supports.

init_options = {
    --- The Sourcery token for authenticating the user.
    --- This is retrieved from the Sourcery website and must be
    --- provided by each user. The extension must provide a
    --- configuration option for the user to provide this value.
    token = <YOUR_TOKEN>

    --- The extension's name and version as defined by the extension.
    extension_version = 'vim.lsp'

    --- The editor's name and version as defined by the editor.
    editor_version = 'vim'
}
]],
  },
}
