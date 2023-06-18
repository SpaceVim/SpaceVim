local MODREV, SPECREV = 'scm', '-1'
rockspec_format = '3.0'
package = 'nvim-treesitter'
version = MODREV .. SPECREV

description = {
  summary = 'Nvim Treesitter configurations and abstraction layer',
  labels = { 'neovim' },
  homepage = 'https://github.com/nvim-treesitter/nvim-treesitter',
  license = 'Apache-2.0',
}

dependencies = {
  'lua >= 5.1',
}

source = {
  url = 'git://github.com/nvim-treesitter/nvim-treesitter',
}

build = {
  type = 'make',
  install_variables = {
    INST_PREFIX='$(PREFIX)',
    INST_BINDIR='$(BINDIR)',
    INST_LIBDIR='$(LIBDIR)',
    INST_LUADIR='$(LUADIR)',
    INST_CONFDIR='$(CONFDIR)',
  },
  copy_directories = {
    'autoload',
    'doc',
    'plugin',
    'queries'
  }
}
