local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
}

local token_in_auth_file = function()
  local is_windows = vim.fn.has 'win32' == 1
  local path_sep = is_windows and '\\' or '/'

  local config_home = is_windows and vim.fn.getenv 'APPDATA' or vim.fn.expand '~/.config'
  local auth_file_path = config_home .. path_sep .. 'sourcery' .. path_sep .. 'auth.yaml'

  if vim.fn.filereadable(auth_file_path) == 1 then
    local content = vim.fn.readfile(auth_file_path)
    for _, line in ipairs(content) do
      if line:match 'sourcery_token: (.+)' then
        return true
      end
    end
  end

  return false
end

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
    if not new_config.init_options.token and not token_in_auth_file() then
      local notify = vim.notify_once or vim.notify
      notify(
        '[lspconfig] The authentication token must be provided in config.init_options or configured via "sourcery login"',
        vim.log.levels.ERROR
      )
    end
  end,
  docs = {
    description = [[
https://github.com/sourcery-ai/sourcery

Refactor Python instantly using the power of AI.

It requires the init_options param to be populated as shown below and will respond with the list of ServerCapabilities that it supports:

```lua
require'lspconfig'.sourcery.setup {
    init_options = {
        --- The Sourcery token for authenticating the user.
        --- This is retrieved from the Sourcery website and must be
        --- provided by each user. The extension must provide a
        --- configuration option for the user to provide this value.
        token = <YOUR_TOKEN>,

        --- The extension's name and version as defined by the extension.
        extension_version = 'vim.lsp',

        --- The editor's name and version as defined by the editor.
        editor_version = 'vim',
    },
}
```

Alternatively, you can login to sourcery by running `sourcery login` with sourcery-cli.
]],
  },
}
