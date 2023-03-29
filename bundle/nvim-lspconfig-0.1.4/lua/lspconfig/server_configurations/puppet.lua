local util = require 'lspconfig.util'

local root_files = {
  'manifests',
  '.puppet-lint.rc',
  'hiera.yaml',
  '.git',
}

return {
  default_config = {
    cmd = { 'puppet-languageserver', '--stdio' },
    filetypes = { 'puppet' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
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
