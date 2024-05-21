local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'perl',
      '-MPerl::LanguageServer',
      '-e',
      'Perl::LanguageServer::run',
      '--',
      '--port 13603',
      '--nostdio 0',
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
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
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
