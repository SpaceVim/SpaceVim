require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = Pathname.new(File.expand_path('.'))

  config.start_vim do
    vim = Vimrunner.start_gvim
    vim.add_plugin(plugin_path, 'plugin/splitjoin.vim')

    # Up-to-date filetype support:
    vim.prepend_runtimepath(plugin_path.join('spec/support/rust.vim'))
    vim.prepend_runtimepath(plugin_path.join('spec/support/vim-javascript'))
    vim.prepend_runtimepath(plugin_path.join('spec/support/vim-elm-syntax'))
    vim.prepend_runtimepath(plugin_path.join('spec/support/vim-elixir'))
    vim.prepend_runtimepath(plugin_path.join('spec/support/R-Vim-runtime'))

    # Alignment tool for alignment tests:
    vim.add_plugin(plugin_path.join('spec/support/tabular'), 'plugin/Tabular.vim')

    # bootstrap filetypes
    vim.command 'autocmd BufNewFile,BufRead *.rs set filetype=rust'
    vim.command 'autocmd BufNewFile,BufRead *.elm set filetype=elm'
    vim.command 'autocmd BufNewFile,BufRead *.ex set filetype=elixir'

    if vim.echo('exists(":packadd")').to_i > 0
      vim.command('packadd matchit')
    else
      vim.command('runtime macros/matchit.vim')
    end

    vim
  end
end

RSpec.configure do |config|
  tmp_dir = File.expand_path(File.dirname(__FILE__) + '/../tmp')

  config.include Support::Vim
  config.example_status_persistence_file_path = tmp_dir + '/examples.txt'
end
