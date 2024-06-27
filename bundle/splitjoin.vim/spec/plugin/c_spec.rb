require 'spec_helper'

describe "c" do
  let(:filename) { 'test.c' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  specify "if_clause" do
    set_file_contents "if (val1 && val2 || val3);"

    vim.search 'if'
    split

    assert_file_contents <<~EOF
      if (val1
          && val2
          || val3);
    EOF

    join

    assert_file_contents "if (val1 && val2 || val3);"
  end

  specify "function_call" do
    set_file_contents "myfunction(lots, of, different, parameters)"

    vim.search '('
    split

    assert_file_contents <<~EOF
      myfunction(lots,
          of,
          different,
          parameters)
    EOF

    join

    assert_file_contents "myfunction(lots, of, different, parameters)"
  end

  specify "ignores strings" do
    set_file_contents "\"myfunction(several, parameters)\""

    vim.search '('
    split

    assert_file_contents "\"myfunction(several, parameters)\""
  end

  specify "ignores comments" do
    set_file_contents "/* myfunction(several, parameters) */"

    vim.search '('
    split

    assert_file_contents "/* myfunction(several, parameters) */"
  end
end
