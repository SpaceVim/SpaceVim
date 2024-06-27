require 'spec_helper'

describe "html" do
  let(:filename) { 'test.html' }

  after :each do
    vim.command('silent! unlet g:splitjoin_html_attributes_bracket_on_new_line')
    vim.command('silent! unlet g:splitjoin_html_attributes_hanging')
  end

  def simple_test(joined_html, split_html)
    set_file_contents joined_html
    split
    remove_indentation

    assert_file_contents split_html

    vim.normal 'gg'
    join
    remove_indentation

    assert_file_contents joined_html
  end

  specify "tags in other content" do
    set_file_contents 'One <div class="foo">Two</div> Three'
    vim.search 'div'
    split
    remove_indentation

    assert_file_contents <<~EOF
      One <div class="foo">
      Two
      </div> Three
    EOF

    vim.search 'div'
    join
    remove_indentation

    assert_file_contents 'One <div class="foo">Two</div> Three'
  end

  specify "tags" do
    joined_html = '<div class="foo">bar</div>'

    split_html = <<~EOF
      <div class="foo">
      bar
      </div>
    EOF

    simple_test(joined_html, split_html)
  end

  specify "attributes" do
    joined_html = '<div id="test" token class="foo bar baz" style="width: 500px; height: 500px">'
    split_html = <<~EOF
      <div
      id="test"
      token
      class="foo bar baz"
      style="width: 500px; height: 500px">
    EOF

    simple_test(joined_html, split_html)
  end

  specify "attributes in self-closing tags" do
    joined_html = '<div id="test"/>'
    split_html = <<~EOF
      <div
      id="test"/>
    EOF

    simple_test(joined_html, split_html)
  end

  specify "attributes in self-closing tags with bracket on new line" do
    vim.command('let g:splitjoin_html_attributes_bracket_on_new_line = 1')

    joined_html = '<div id="test" />'
    split_html = <<~EOF
      <div
      id="test"
      />
    EOF

    simple_test(joined_html, split_html)
  end

  specify "attributes with bracket on new line" do
    vim.command('let g:splitjoin_html_attributes_bracket_on_new_line = 1')

    joined_html = <<~EOF
      <div id="test">
      </div>
    EOF
    split_html = <<~EOF
      <div
      id="test"
      >
      </div>
    EOF

    simple_test(joined_html, split_html)
  end

  specify "hanging attributes" do
    vim.command('let g:splitjoin_html_attributes_hanging = 1')

    joined_html = <<~EOF
      <button class="button control" @click="save" v-if="admin">
      Save
      </button>
    EOF
    split_html = <<~EOF
      <button class="button control"
      @click="save"
      v-if="admin">
      Save
      </button>
    EOF

    simple_test(joined_html, split_html)
  end

  specify "brackets within strings" do
    joined_html = <<~EOF
      <label for="{{ $input->id }}" class="mt-2">
    EOF
    split_html = <<~EOF
      <label
      for="{{ $input->id }}"
      class="mt-2">
    EOF

    simple_test(joined_html, split_html)
  end
end
