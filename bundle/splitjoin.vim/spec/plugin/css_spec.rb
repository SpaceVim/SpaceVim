require 'spec_helper'

describe "css" do
  let(:filename) { 'test.css' }

  before :each do
    vim.set 'expandtab'
    vim.set 'shiftwidth', 2
  end

  specify "single-line style definitions" do
    set_file_contents <<~EOF
      a { color: #0000FF; text-decoration: underline; }
    EOF

    split

    assert_file_contents <<~EOF
      a {
        color: #0000FF;
        text-decoration: underline;
      }
    EOF

    join

    assert_file_contents <<~EOF
      a { color: #0000FF; text-decoration: underline; }
    EOF
  end

  specify "empty single-line style definitions (regression)" do
    set_file_contents <<~EOF
      body {

      }
    EOF

    join
    assert_file_contents 'body {}'

    split
    assert_file_contents <<~EOF
      body {

      }
    EOF

    set_file_contents <<~EOF
      body {
      }
    EOF

    join
    assert_file_contents 'body {}'
  end

  specify "multiline selectors" do
    set_file_contents <<~EOF
      h1, h2, h3 {
        font-size: 18px;
        font-weight: bold;
      }
    EOF

    split

    assert_file_contents <<~EOF
      h1,
      h2,
      h3 {
        font-size: 18px;
        font-weight: bold;
      }
    EOF

    join

    assert_file_contents <<~EOF
      h1, h2, h3 {
        font-size: 18px;
        font-weight: bold;
      }
    EOF
  end
end
