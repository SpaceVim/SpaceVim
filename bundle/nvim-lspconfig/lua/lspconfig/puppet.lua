local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'puppet'
local bin_name = 'puppet-languageserver'

local root_files = {
  'manifests',
  '.puppet-lint.rc',
  'hiera.yaml',
  '.git',
}

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'puppet' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/puppetlabs/puppet-vscode/main/package.json',
    description = [[
LSP server for Puppet.

Installation:

- Clone the editor-services repository:
    https://github.com/puppetlabs/puppet-editor-services

- Navigate into that directory and run: `bundle install`

- Install the 'puppet-lint' gem: `gem install puppet-lint`

- Add that repository to $PATH.

- Ensure you can run `puppet-languageserver` from outside the editor-services directory.
]],
    default_config = {
      root_dir = [[root_pattern("manifests", ".puppet-lint.rc", "hiera.yaml", ".git")]],
    },
  },
}
