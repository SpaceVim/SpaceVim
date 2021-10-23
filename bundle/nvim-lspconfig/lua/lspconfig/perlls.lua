local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.perlls = {
  default_config = {
    cmd = {
      'perl',
      '-MPerl::LanguageServer',
      '-e',
      'Perl::LanguageServer::run',
      '--',
      '--port 13603',
      '--nostdio 0',
      '--version 2.1.0',
    },
    settings = {
      perl = {
        perlCmd = 'perl',
        perlInc = ' ',
        fileFilter = { '.pm', '.pl' },
        ignoreDirs = '.git',
      },
    },
    filetypes = { 'perl' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or vim.fn.getcwd()
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/richterger/Perl-LanguageServer/master/clients/vscode/perl/package.json',
    description = [[
https://github.com/richterger/Perl-LanguageServer/tree/master/clients/vscode/perl

`Perl-LanguageServer`, a language server for Perl.

To use the language server, ensure that you have Perl::LanguageServer installed and perl command is on your path.
]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}
