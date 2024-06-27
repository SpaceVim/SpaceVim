require 'spec_helper'

describe "R" do
  let(:filename) { 'test.r' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  after :each do
    vim.command('silent! unlet g:r_indent_align_args')
  end

  specify "function calls with align_args = 0" do
    vim.command('let g:r_indent_align_args = 0')

    set_file_contents 'print(1, a = 2, 3)'
    vim.search('1,')
    split

    assert_file_contents <<~EOF
      print(
        1,
        a = 2,
        3
      )
    EOF

    join

    assert_file_contents 'print(1, a = 2, 3)'
  end

  specify "function calls with align_args = 1" do
    vim.command('let g:r_indent_align_args = 1')

    set_file_contents 'print(1, a = 2, 3)'
    vim.search('1,')
    split

    assert_file_contents <<~EOF
      print(1,
            a = 2,
            3)
    EOF

    join

    assert_file_contents 'print(1, a = 2, 3)'
  end

  specify "function calls with nested calls" do
    vim.command('let g:r_indent_align_args = 1')
    set_file_contents 'print(1, c(1, 2, 3), 3)'

    # On start of nested function
    vim.search('c(')
    split

    assert_file_contents <<~EOF
      print(1,
            c(1, 2, 3),
            3)
    EOF

    join

    assert_file_contents 'print(1, c(1, 2, 3), 3)'

    # Inside nested function
    vim.search('c(')
    vim.search('1,')
    split

    assert_file_contents <<~EOF
      print(1, c(1,
                 2,
                 3), 3)
    EOF

    join

    assert_file_contents 'print(1, c(1, 2, 3), 3)'
  end
end
