require 'spec_helper'

describe "JSX" do
  let(:filename) { 'test.jsx' }

  def setup_filetype
    vim.set(:filetype, 'javascriptreact')
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  after :each do
    vim.command('silent! unlet g:splitjoin_html_attributes_bracket_on_new_line')
  end

  describe "self-closing tags" do
    specify "basic" do
      set_file_contents '<Button />;'
      setup_filetype

      vim.search 'Button'
      split
      remove_indentation

      assert_file_contents <<~EOF
        <Button>
        </Button>;
      EOF

      join

      assert_file_contents '<Button />;'
    end

    specify "joining on a single line" do
      set_file_contents 'let button = <Button prop="value"></Button>;'
      setup_filetype

      vim.search 'Button'
      join
      remove_indentation

      assert_file_contents <<~EOF
        let button = <Button prop="value" />;
      EOF
    end

    specify "with attributes" do
      set_file_contents '<Button foo="bar" bar="baz" />;'
      setup_filetype

      vim.search 'Button'
      split
      remove_indentation

      assert_file_contents <<~EOF
        <Button
        foo="bar"
        bar="baz" />;
      EOF

      split
      remove_indentation

      assert_file_contents <<~EOF
        <Button
        foo="bar"
        bar="baz">
        </Button>;
      EOF

      vim.search '<Button'
      join
      remove_indentation

      assert_file_contents <<~EOF
        <Button foo="bar" bar="baz">
        </Button>;
      EOF

      join
      remove_indentation

      assert_file_contents '<Button foo="bar" bar="baz" />;'
    end
  end

  describe "JSX expressions" do
    specify "self-closing tag with a let statement" do
      set_file_contents 'let button = <Button />;'
      setup_filetype

      vim.search 'Button'
      split
      remove_indentation

      assert_file_contents <<~EOF
        let button = (
        <Button />
        );
      EOF

      vim.search('button = \zs(')
      join

      assert_file_contents 'let button = <Button />;'
    end

    specify "simple tag with a return statement" do
      set_file_contents <<~EOF
        function button() {
          return <Button></Button>;
        }
      EOF
      setup_filetype

      vim.search '<Button'
      split
      remove_indentation

      assert_file_contents <<~EOF
        function button() {
        return (
        <Button></Button>
        );
        }
      EOF

      vim.search('return \zs(')
      join

      assert_file_contents <<~EOF
        function button() {
          return <Button></Button>;
        }
      EOF
    end

    specify "tag with attributes in a lambda" do
      set_file_contents '() => <Button foo="bar" />'
      setup_filetype

      vim.search '<Button'
      split
      remove_indentation

      assert_file_contents <<~EOF
        () => (
        <Button foo="bar" />
        )
      EOF

      vim.search('() => \zs(')
      join

      assert_file_contents '() => <Button foo="bar" />'
    end

    specify "variable assignment with a lambda" do
      set_file_contents <<~EOF
        const foo: Bar = (args) => {
          return <Component prop={args.prop} />;
        };
      EOF
      setup_filetype

      vim.search 'args'
      join

      assert_file_contents <<~EOF
        const foo: Bar = (args) => <Component prop={args.prop} />;
      EOF
    end
  end

  describe "Lambdas in tags" do
    # Reference: https://github.com/AndrewRadev/splitjoin.vim/issues/182
    specify "doesn't get confused by =>" do
      vim.command('let g:splitjoin_html_attributes_bracket_on_new_line = 1')

      set_file_contents <<~EOF
        return (
          <Tag category={ C } onClick={ () => toggleCategory(C) } />
        );
      EOF
      setup_filetype

      vim.search 'category'
      split
      remove_indentation

      assert_file_contents <<~EOF
        return (
        <Tag
        category={ C }
        onClick={ () => toggleCategory(C) }
        />
        );
      EOF

      vim.search 'Tag'
      join
      remove_indentation

      assert_file_contents <<~EOF
        return (
        <Tag category={ C } onClick={ () => toggleCategory(C) } />
        );
      EOF
    end
  end
end
