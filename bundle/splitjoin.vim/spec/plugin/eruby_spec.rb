require 'spec_helper'

describe "eruby" do
  let(:filename) { 'test.erb' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  after :each do
    vim.command('silent! unlet g:splitjoin_ruby_trailing_comma')
  end

  specify "method options with a trailing comma" do
    vim.command('let g:splitjoin_ruby_trailing_comma = 1')

    set_file_contents <<~EOF
      <%= link_to "Home", "/", remote: true, confirm: "Y?" %>
    EOF

    vim.search 'Home'
    split

    assert_file_contents <<~EOF
      <%= link_to "Home", "/", {
        remote: true,
        confirm: "Y?",
      } %>
    EOF

    vim.search 'Home'
    join

    assert_file_contents <<~EOF
      <%= link_to "Home", "/", { remote: true, confirm: "Y?" } %>
    EOF
  end
end
