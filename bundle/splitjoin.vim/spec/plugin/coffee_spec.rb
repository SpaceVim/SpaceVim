require 'spec_helper'

# Note: Coffeescript is not a built-in filetype, so these specs work with no
# automatic indentation. It's still possible that bugs would creep in due when
# real indentation is factored in, though I've attempted to minimize the
# effects of that.
#
describe "coffee" do
  let(:filename) { 'test.coffee' }

  # Coffee is not built-in, so let's set it up manually
  def setup_coffee_filetype
    vim.set(:filetype, 'coffee')
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  specify "functions" do
    set_file_contents "(foo, bar) -> console.log foo"
    setup_coffee_filetype

    split

    assert_file_contents <<~EOF
      (foo, bar) ->
        console.log foo
    EOF

    join

    assert_file_contents "(foo, bar) -> console.log foo"
  end

  specify "postfix if-clauses" do
    set_file_contents "console.log bar if foo?"
    setup_coffee_filetype

    split

    assert_file_contents <<~EOF
      if foo?
        console.log bar
    EOF

    join

    assert_file_contents "console.log bar if foo?"
  end

  specify "suffix if-clauses" do
    set_file_contents "if foo? then console.log bar"
    setup_coffee_filetype

    split

    assert_file_contents <<~EOF
      if foo?
        console.log bar
    EOF

    join

    assert_file_contents "console.log bar if foo?"
  end

  specify "ternary operator" do
    set_file_contents <<~EOF
      do ->
        foo = if bar? then 'baz' else 'qux'
    EOF
    setup_coffee_filetype

    vim.search 'foo'
    split

    assert_file_contents <<~EOF
      do ->
        if bar?
          foo = 'baz'
        else
          foo = 'qux'
    EOF

    vim.search 'bar'
    join

    set_file_contents <<~EOF
      do ->
        foo = if bar? then 'baz' else 'qux'
    EOF
  end

  specify "joining ternary operator without any assignment magic" do
    set_file_contents <<~EOF
      if bar?
        foo = "baz"
      else
        baz = "qux"
    EOF
    setup_coffee_filetype

    vim.search 'bar'
    join

    assert_file_contents <<~EOF
      if bar? then foo = "baz" else baz = "qux"
    EOF
  end

  specify "object literals" do
    set_file_contents 'one = { one: "two", three: "four" }'
    setup_coffee_filetype

    split

    assert_file_contents <<~EOF
      one =
        one: "two"
        three: "four"
    EOF

    join

    assert_file_contents 'one = { one: "two", three: "four" }'
  end

  specify "function calls with object literals" do
    set_file_contents 'foo = functionCall(one, two, three: four, five: six)'
    setup_coffee_filetype

    split

    assert_file_contents <<~EOF
      foo = functionCall one, two,
        three: four
        five: six
    EOF

    join

    assert_file_contents 'foo = functionCall one, two, { three: four, five: six }'
  end

  specify "strings" do
    set_file_contents <<~EOF
      foo = "example with \#{interpolation} and \\"nested\\" quotes"
    EOF
    setup_coffee_filetype

    vim.search 'example'
    split

    assert_file_contents <<~EOF
      foo = """
        example with \#{interpolation} and "nested" quotes
      """
    EOF

    join

    assert_file_contents <<~EOF
      foo = "example with \#{interpolation} and \\"nested\\" quotes"
    EOF
  end

  specify "triple strings" do
    set_file_contents <<~EOF
      foo = """example with \#{interpolation} and "nested" quotes"""
    EOF
    setup_coffee_filetype

    vim.search 'example'
    split

    assert_file_contents <<~EOF
      foo = """
        example with \#{interpolation} and "nested" quotes
      """
    EOF

    join

    assert_file_contents <<~EOF
      foo = "example with \#{interpolation} and \\"nested\\" quotes"
    EOF
  end
end
