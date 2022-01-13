local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.perlpls = {
  default_config = {
    cmd = { 'pls' },
    settings = {
      perl = {
        perlcritic = { enabled = false },
      },
    },
    filetypes = { 'perl' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/FractalBoy/perl-language-server/master/client/package.json',
    description = [[
https://github.com/FractalBoy/perl-language-server
https://metacpan.org/pod/PLS

`PLS`, another language server for Perl.

To use the language server, ensure that you have PLS installed and that it is in your path
]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}
