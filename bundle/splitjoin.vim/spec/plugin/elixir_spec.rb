require 'spec_helper'

describe "elixir" do
  let(:filename) { "test.ex" }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  describe "function definitions" do
    specify "0 arity" do
      set_file_contents <<~EOF
        defmodule Foo do
          def bar() do
            :bar
          end
        end
      EOF

      vim.search 'def bar'
      join

      assert_file_contents <<~EOF
        defmodule Foo do
          def bar(), do: :bar
        end
      EOF

      vim.search 'def bar'
      split

      assert_file_contents <<~EOF
        defmodule Foo do
          def bar() do
            :bar
          end
        end
      EOF
    end

    specify "0 arity no parens" do
      set_file_contents <<~EOF
        defmodule Foo do
          def bar do
            :bar
          end
        end
      EOF

      vim.search 'def bar'
      join

      assert_file_contents <<~EOF
        defmodule Foo do
          def bar, do: :bar
        end
      EOF

      vim.search 'def bar'
      split

      assert_file_contents <<~EOF
        defmodule Foo do
          def bar do
            :bar
          end
        end
      EOF
    end

    specify "1 arity" do
      set_file_contents <<~EOF
        defmodule Foo do
          def bar(foo) do
            :bar
          end
        end
      EOF

      vim.search 'def bar'
      join

      assert_file_contents <<~EOF
        defmodule Foo do
          def bar(foo), do: :bar
        end
      EOF

      vim.search 'def bar'
      split

      assert_file_contents <<~EOF
        defmodule Foo do
          def bar(foo) do
            :bar
          end
        end
      EOF
    end
  end

  describe "do-blocks" do
    specify "with round brackets" do
      set_file_contents <<~EOF
        let(:one, do: two() |> three(four()))
      EOF

      vim.search ':one'
      split

      assert_file_contents <<~EOF
        let(:one) do
          two() |> three(four())
        end
      EOF

      join

      assert_file_contents <<~EOF
        let(:one, do: two() |> three(four()))
      EOF
    end

    specify "with no brackets" do
      set_file_contents <<~EOF
        let :one, do: two() |> three(four())
      EOF

      vim.search ':one'
      split

      assert_file_contents <<~EOF
        let :one do
          two() |> three(four())
        end
      EOF

      join

      assert_file_contents <<~EOF
        let :one, do: two() |> three(four())
      EOF
    end
  end

  describe "if-blocks" do
    specify "with no brackets" do
      set_file_contents <<~EOF
        if 2 > 1, do: print("OK"), else: print("Not OK")
      EOF

      vim.search '2 > 1'
      split

      assert_file_contents <<~EOF
        if 2 > 1 do
          print("OK")
        else
          print("Not OK")
        end
      EOF

      join

      assert_file_contents <<~EOF
        if 2 > 1, do: print("OK"), else: print("Not OK")
      EOF
    end

    specify "with round brackets" do
      set_file_contents <<~EOF
        if(2 > 1, do: print("OK"), else: print("Not OK"))
      EOF

      vim.search '2 > 1'
      split

      assert_file_contents <<~EOF
        if 2 > 1 do
          print("OK")
        else
          print("Not OK")
        end
      EOF

      join

      assert_file_contents <<~EOF
        if 2 > 1, do: print("OK"), else: print("Not OK")
      EOF
    end
  end

  describe "joining comma-separated arguments" do
    specify "with a level of indent" do
      set_file_contents <<~EOF
        for a <- 1..10,
          Integer.is_odd(a) do
          a
        end
      EOF

      vim.search 'for'
      join

      assert_file_contents <<~EOF
        for a <- 1..10, Integer.is_odd(a) do
          a
        end
      EOF
    end

    specify "with no indent" do
      set_file_contents <<~EOF
        for a <- 1..10,
        Integer.is_odd(a) do
          a
        end
      EOF

      vim.search 'for'
      join

      assert_file_contents <<~EOF
        for a <- 1..10, Integer.is_odd(a) do
          a
        end
      EOF
    end

    specify "multiple lines" do
      set_file_contents <<~EOF
        if Enum.member?(one, two),
          do: query |> where(three, four),
          else: five
      EOF

      vim.search 'Enum'
      join

      assert_file_contents <<~EOF
        if Enum.member?(one, two), do: query |> where(three, four), else: five
      EOF
    end
  end

  specify "arrays" do
    set_file_contents <<~EOF
      [a, b, c]
    EOF

    split

    assert_file_contents <<~EOF
      [
        a,
        b,
        c
      ]
    EOF

    vim.search('[')
    join

    assert_file_contents <<~EOF
      [a, b, c]
    EOF

    set_file_contents <<~EOF
      [a: 1, b: 2, c: %{a: 1, b: 2}]
    EOF

    split

    assert_file_contents <<~EOF
      [
        a: 1,
        b: 2,
        c: %{a: 1, b: 2}
      ]
    EOF

    vim.search('[')
    join

    assert_file_contents <<~EOF
      [a: 1, b: 2, c: %{a: 1, b: 2}]
    EOF

    set_file_contents <<~EOF
      []
    EOF

    vim.search('[')
    split

    assert_file_contents <<~EOF
      []
    EOF

    vim.search('[')
    join

    assert_file_contents <<~EOF
      []
    EOF
  end

  describe "pipes" do
    specify "1 arity" do
      set_file_contents <<~EOF
        foo(bar)
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        bar
        |> foo()
      EOF

      vim.search "|>"
      join

      assert_file_contents <<~EOF
        foo(bar)
      EOF
    end

    specify "1 arity, no parens" do
      set_file_contents <<~EOF
        foo bar
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        bar
        |> foo()
      EOF
    end

    specify "1 arity, qualified call" do
      set_file_contents <<~EOF
        My.Module.foo(bar)
      EOF

      vim.search 'My'
      split

      assert_file_contents <<~EOF
        bar
        |> My.Module.foo()
      EOF

      vim.search "|>"
      join

      assert_file_contents <<~EOF
        My.Module.foo(bar)
      EOF
    end

    specify "1 arity, atom call" do
      set_file_contents <<~EOF
        :module.foo(bar)
      EOF

      vim.search ':module'
      split

      assert_file_contents <<~EOF
        bar
        |> :module.foo()
      EOF

      vim.search "|>"
      join

      assert_file_contents <<~EOF
        :module.foo(bar)
      EOF
    end

    specify "1 arity, indented" do
      set_file_contents <<~EOF
        if bla do
          foo(bar)
        end
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        if bla do
          bar
          |> foo()
        end
      EOF

      vim.search "|>"
      join

      assert_file_contents <<~EOF
        if bla do
          foo(bar)
        end
      EOF
    end

    specify "2 arity" do
      set_file_contents <<~EOF
        foo(bar, baz)
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        bar
        |> foo(baz)
      EOF

      vim.search '|>'
      join

      assert_file_contents <<~EOF
        foo(bar, baz)
      EOF
    end

    specify "2 arity, no parens" do
      set_file_contents <<~EOF
        foo bar, baz
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        bar
        |> foo(baz)
      EOF
    end

    specify "2 arity, qualified call" do
      set_file_contents <<~EOF
        My.Module.foo(bar, baz)
      EOF

      vim.search 'My'
      split

      assert_file_contents <<~EOF
        bar
        |> My.Module.foo(baz)
      EOF

      vim.search "|>"
      join

      assert_file_contents <<~EOF
        My.Module.foo(bar, baz)
      EOF
    end

    specify "2 arity, atom call" do
      set_file_contents <<~EOF
        :module.foo(bar, baz)
      EOF

      vim.search ':module'
      split

      assert_file_contents <<~EOF
        bar
        |> :module.foo(baz)
      EOF

      vim.search "|>"
      join

      assert_file_contents <<~EOF
        :module.foo(bar, baz)
      EOF
    end

    specify "2 arity, indented" do
      set_file_contents <<~EOF
        if bla do
          foo(bar, baz)
        end
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        if bla do
          bar
          |> foo(baz)
        end
      EOF

      vim.search '|>'
      join

      assert_file_contents <<~EOF
        if bla do
          foo(bar, baz)
        end
      EOF
    end

    specify "join from line preceding pipe operator" do
      set_file_contents <<~EOF
        bar
        |> foo()
      EOF

      vim.search 'bar'
      join

      assert_file_contents <<~EOF
        foo(bar)
      EOF
    end

    specify "join from middle of pipeline does nothing" do
      set_file_contents <<~EOF
        bar
        |> foo()
        |> baz()
        |> bla()
      EOF

      vim.search 'baz'
      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinJoin'

      assert_file_contents <<~EOF
        bar
        |> foo()
        |> baz()
        |> bla()
      EOF
    end

    specify "join from start of pipeline" do
      set_file_contents <<~EOF
        bar
        |> foo()
        |> baz()
        |> bla()
      EOF

      vim.search 'foo'
      join

      assert_file_contents <<~EOF
        foo(bar)
        |> baz()
        |> bla()
      EOF
    end

    specify "complex args" do
      set_file_contents <<~EOF
        foo((1 + 2) * 3, bar(baz, bla))
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        (1 + 2) * 3
        |> foo(bar(baz, bla))
      EOF

      vim.search '|>'
      join

      assert_file_contents <<~EOF
        foo((1 + 2) * 3, bar(baz, bla))
      EOF
    end

    specify "split from a pipeline does nothing" do
      set_file_contents <<~EOF
        bar
        |> foo(baz)
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        bar
        |> foo(baz)
      EOF
    end

    specify "splitting multiple functions on one line does nothing" do
      set_file_contents <<~EOF
        foo("one") + bar("two")
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        foo("one") + bar("two")
      EOF

      vim.search 'bar'
      split

      assert_file_contents <<~EOF
        foo("one") + bar("two")
      EOF
    end

    specify "splitting multiple no-parens functions on one line does nothing" do
      set_file_contents <<~EOF
        IO.puts 3 + String.length "foo"
      EOF

      vim.search 'IO'
      split

      assert_file_contents <<~EOF
        IO.puts 3 + String.length "foo"
      EOF

      vim.search 'String.length'
      split

      assert_file_contents <<~EOF
        IO.puts 3 + String.length "foo"
      EOF
    end

    specify "splitting with whitespace and a comment at the end works" do
      set_file_contents <<~EOF
        foo("one", "two") # bar
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        "one"
        |> foo("two") # bar
      EOF

      set_file_contents <<~EOF
        foo "one", "two" # bar
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        "one"
        |> foo("two") # bar
      EOF
    end

    specify "ignores function calls that do not start at the beginning of the line" do
      set_file_contents <<~EOF
        if foo,
          do: "one" |> bla(a)
          else: foo
      EOF

      vim.search 'bla'
      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinSplit'

      assert_file_contents <<~EOF
        if foo,
          do: "one" |> bla(a)
          else: foo
      EOF

      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinJoin'

      assert_file_contents <<~EOF
        if foo,
          do: "one" |> bla(a)
          else: foo
      EOF
    end

    specify "with a pipe within the args" do
      set_file_contents <<~EOF
        IO.inspect("foo" |> String.length())
      EOF

      vim.search 'foo'
      split

      assert_file_contents <<~EOF
        "foo" |> String.length()
        |> IO.inspect()
      EOF

      join

      assert_file_contents <<~EOF
        IO.inspect("foo" |> String.length())
      EOF
    end
  end
end
