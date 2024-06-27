require 'spec_helper'

describe "vim" do
  let(:filename) { "test.vim" }

  before :each do
    vim.set 'expandtab'
    vim.set 'shiftwidth', 2
  end

  after :each do
    vim.command('silent! unlet g:splitjoin_vim_split_whitespace_after_backslash')
  end

  specify ":if commands" do
    contents = <<~EOF
      if condition == 1
        return 0
      endif
    EOF

    set_file_contents contents

    join
    assert_file_contents "if condition == 1 | return 0 | endif"

    split
    assert_file_contents contents
  end

  specify "backslashes with a preceding space" do
    set_file_contents <<~EOF
      let foo = 2 + 2
    EOF

    vim.search('+')
    split

    assert_file_contents <<~EOF
      let foo = 2
            \\ + 2
    EOF

    join

    assert_file_contents <<~EOF
      let foo = 2 + 2
    EOF
  end

  specify "backslashes without a space" do
    set_file_contents <<~EOF
      let foo = 2+2
    EOF

    vim.search('+')
    split

    assert_file_contents <<~EOF
      let foo = 2
            \\+2
    EOF

    join

    assert_file_contents <<~EOF
      let foo = 2+2
    EOF
  end
end
