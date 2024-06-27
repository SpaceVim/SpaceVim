require 'spec_helper'

describe "javascript" do
  let(:filename) { 'test.js' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  describe "fat-arrow functions" do
    specify "no arguments, no curly braces, semicolon at the end" do
      set_file_contents 'let foo = () => "bar";'

      vim.search '()'
      split

      assert_file_contents <<~EOF
        let foo = () => {
          return "bar";
        };
      EOF

      join

      assert_file_contents 'let foo = () => "bar";'
    end

    specify "no arguments, curly braces, semicolon at the end" do
      set_file_contents 'let foo = () => { return "bar"; };'

      vim.search '()'
      split

      assert_file_contents <<~EOF
        let foo = () => {
          return "bar";
        };
      EOF

      join

      assert_file_contents 'let foo = () => "bar";'
    end

    specify "arguments, curly braces, semicolon at the end" do
      set_file_contents 'let foo = (one, two) => { return "bar"; };'

      vim.search '(one, two)'
      split

      assert_file_contents <<~EOF
        let foo = (one, two) => {
          return "bar";
        };
      EOF

      join

      assert_file_contents 'let foo = (one, two) => "bar";'
    end

    specify "arguments, no curly braces, no semicolon at the end" do
      set_file_contents 'let foo = arg => foo(arg)'

      vim.search 'arg'
      split

      assert_file_contents <<~EOF
        let foo = arg => {
          return foo(arg)
        }
      EOF

      join

      assert_file_contents 'let foo = arg => foo(arg)'
    end

    specify "one argument, curly braces, no semicolon at the end" do
      set_file_contents 'let foo = arg => { return "bar" }'

      vim.search 'arg'
      split

      assert_file_contents <<~EOF
        let foo = arg => {
          return "bar"
        }
      EOF

      join

      assert_file_contents 'let foo = arg => "bar"'
    end

    specify "in a function call, semicolon at the end" do
      set_file_contents 'foo(bar => "baz");'

      vim.search 'bar'
      split

      assert_file_contents <<~EOF
        foo(bar => {
          return "baz";
        });
      EOF

      join

      assert_file_contents 'foo(bar => "baz");'
    end

    specify "in a list, no semicolon at the end" do
      set_file_contents 'let foo = [bar => "baz"]'

      vim.search 'bar'
      split

      assert_file_contents <<~EOF
        let foo = [bar => {
          return "baz"
        }]
      EOF

      join

      assert_file_contents 'let foo = [bar => "baz"]'
    end

    specify "in an object" do
      set_file_contents 'let foo = {"key": bar => "baz"};'

      vim.search 'bar'
      split

      assert_file_contents <<~EOF
        let foo = {
        "key": bar => "baz"
        };
      EOF

      join

      assert_file_contents 'let foo = { "key": bar => "baz" };'
    end

    specify "gives priority to objects in argument list" do
      set_file_contents 'const func = ({ a, b, c }) => a + b'

      vim.search 'b,'
      split

      assert_file_contents <<~EOF
        const func = ({
          a,
          b,
          c
        }) => a + b
      EOF
    end

    specify "separated by a comma" do
      set_file_contents 'var foo = [callback => callback(one, two), three]'

      vim.search 'callback =>'
      split

      assert_file_contents <<~EOF
        var foo = [callback => {
          return callback(one, two)
        }, three]
      EOF
    end

    specify "object body in round brackets" do
      set_file_contents '[1, 2, 3].map(n => ({ square: n * n }));'

      vim.search 'n =>'
      split

      assert_file_contents <<~EOF
        [1, 2, 3].map(n => {
          return { square: n * n };
        });
      EOF

      vim.search 'n =>'
      join

      assert_file_contents '[1, 2, 3].map(n => ({ square: n * n }));'
    end
  end

  specify "object literals" do
    set_file_contents "{ one: two, 'three': four }"

    vim.search '{'
    split

    # Fix issue with inconsistent indenting
    vim.normal 'gg<G'
    vim.write

    assert_file_contents <<~EOF
      {
      one: two,
      'three': four
      }
    EOF

    join

    assert_file_contents "{ one: two, 'three': four }"
  end

  specify "lists" do
    set_file_contents "[ 'one', 'two', 'three', 'four' ]"

    vim.search '['
    split

    assert_file_contents <<~EOF
      [
        'one',
        'two',
        'three',
        'four'
      ]
    EOF

    join

    assert_file_contents "['one', 'two', 'three', 'four']"
  end

  specify "lists (with trailing comma)" do
    set_file_contents <<~EOF
      [
        'one',
        'two',
      ]
    EOF

    join

    assert_file_contents "['one', 'two']"
  end

  specify "functions" do
    set_file_contents "var foo = function() { return 'bar'; };"

    vim.search 'function'
    split

    assert_file_contents <<~EOF
      var foo = function() {
        return 'bar';
      };
    EOF

    set_file_contents <<~EOF
      var foo = function() {
        one();
        two();
        return 'bar';
      };
    EOF

    join

    assert_file_contents "var foo = function() { one(); two(); return 'bar'; };"
  end

  specify "named functions" do
    set_file_contents <<~EOF
      function example() {
        return 'bar';
      };
    EOF

    join

    assert_file_contents <<~EOF
      function example() { return 'bar'; };
    EOF
  end

  specify "one-line ifs" do
    joined_if = "if (isTrue()) do();"
    split_if  = "if (isTrue()) {\n  do();\n}"

    set_file_contents(joined_if)
    split
    assert_file_contents(split_if)
    join
    assert_file_contents(joined_if)
  end

  specify "arguments" do
    joined_args = "var x = foo(arg1, arg2, 'arg3', 'arg4');"
    split_args  = <<~EOF
      var x = foo(
        arg1,
        arg2,
        'arg3',
        'arg4'
      );
    EOF

    set_file_contents(split_args)
    join
    assert_file_contents(joined_args)
    split
    assert_file_contents(split_args)
  end

  specify "arguments racing with others" do
    joined_args = "function test(arg1, arg2, arg3) { return true; };"
    split_args_once  = <<~EOF
      function test(arg1, arg2, arg3) {
        return true;
      };
    EOF

    # Spec failing due to an unrelated bug with semicola - fixed with
    # the next commit
    split_args_twice = <<~EOF
      function test(
        arg1,
        arg2,
        arg3
      ) {
        return true;
      };
    EOF
    set_file_contents(joined_args)
    split
    assert_file_contents(split_args_once)
    split
    assert_file_contents(split_args_twice)
    join
    assert_file_contents(split_args_once)
    join
    assert_file_contents(joined_args)
  end
end
