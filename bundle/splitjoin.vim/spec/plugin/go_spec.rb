require 'spec_helper'

describe "go" do
  let(:filename) { 'test.go' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  specify "imports" do
    set_file_contents <<~EOF
      import "fmt"
    EOF

    vim.search('import')
    split

    assert_file_contents <<~EOF
      import (
        "fmt"
      )
    EOF

    vim.search('import')
    join

    assert_file_contents <<~EOF
      import "fmt"
    EOF
  end

  specify "imports with names" do
    set_file_contents <<~EOF
      import _ "fmt"
    EOF

    vim.search('import')
    split

    assert_file_contents <<~EOF
      import (
        _ "fmt"
      )
    EOF

    vim.search('import')
    join

    assert_file_contents <<~EOF
      import _ "fmt"
    EOF
  end

  describe "structs" do
    specify "instantiation" do
      set_file_contents <<~EOF
        StructType{one: 1, two: "asdf", three: []int{1, 2, 3}}
      EOF

      vim.search 'one:'
      split

      assert_file_contents <<~EOF
        StructType{
          one: 1,
          two: "asdf",
          three: []int{1, 2, 3},
        }
      EOF

      join

      assert_file_contents <<~EOF
        StructType{one: 1, two: "asdf", three: []int{1, 2, 3}}
      EOF
    end

    specify "instantiation without padding" do
      set_file_contents <<~EOF
        StructType{one: 1, two: "asdf", three: []int{1, 2, 3}}
      EOF
      vim.command('let b:splitjoin_curly_brace_padding = 0')

      vim.search 'one:'
      split

      assert_file_contents <<~EOF
        StructType{
          one: 1,
          two: "asdf",
          three: []int{1, 2, 3},
        }
      EOF

      join

      assert_file_contents <<~EOF
        StructType{one: 1, two: "asdf", three: []int{1, 2, 3}}
      EOF
    end

    specify "definition" do
      set_file_contents <<~EOF
        type str struct{ A, B int }
      EOF

      vim.search 'A'
      split

      assert_file_contents <<~EOF
        type str struct {
          A, B int
        }
      EOF

      vim.search 'struct'
      join

      assert_file_contents <<~EOF
        type str struct{ A, B int }
      EOF
    end

    specify "empty definition" do
      set_file_contents <<~EOF
        type empty struct{}
      EOF

      vim.search '{'
      split

      assert_file_contents <<~EOF
        type empty struct {

        }
      EOF

      vim.search 'struct'
      join

      assert_file_contents <<~EOF
        type empty struct{}
      EOF

      vim.search 'type'
      split

      assert_file_contents <<~EOF
        type (
          empty struct{}
        )
      EOF
    end
  end

  describe "funcs" do
    def assert_split_join(initial, split_expected, join_expected)
      set_file_contents initial
      vim.search 'Func(\zs\k'

      split

      assert_file_contents split_expected

      join

      assert_file_contents join_expected
    end

    it "handles function definitions" do
      initial = <<~EOF
        func Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) {
        }
      EOF
      split = <<~EOF
        func Func(
          a, b int,
          c time.Time,
          d func(int) error,
          e func(int, int) (int, error),
          f ...time.Time,
        ) {
        }
      EOF
      joined = <<~EOF
        func Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) {
        }
      EOF
      assert_split_join(initial, split, joined)
    end

    it "handles function definitions with return types" do
      initial = <<~EOF
        func Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) (r string, err error) {
        }
      EOF
      split = <<~EOF
        func Func(
          a, b int,
          c time.Time,
          d func(int) error,
          e func(int, int) (int, error),
          f ...time.Time,
        ) (r string, err error) {
        }
      EOF
      joined = <<~EOF
        func Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) (r string, err error) {
        }
      EOF
      assert_split_join(initial, split, joined)
    end

    it "handles method definitions" do
      initial = <<~EOF
        func (r Receiver) Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) {
        }
      EOF
      split = <<~EOF
        func (r Receiver) Func(
          a, b int,
          c time.Time,
          d func(int) error,
          e func(int, int) (int, error),
          f ...time.Time,
        ) {
        }
      EOF
      joined = <<~EOF
        func (r Receiver) Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) {
        }
      EOF
      assert_split_join(initial, split, joined)
    end

    it "handles method definitions with return types" do
      initial = <<~EOF
        func (r Receiver) Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) (r string, err error) {
        }
      EOF
      split = <<~EOF
        func (r Receiver) Func(
          a, b int,
          c time.Time,
          d func(int) error,
          e func(int, int) (int, error),
          f ...time.Time,
        ) (r string, err error) {
        }
      EOF
      joined = <<~EOF
        func (r Receiver) Func(a, b int, c time.Time, d func(int) error, e func(int, int) (int, error), f ...time.Time) (r string, err error) {
        }
      EOF
      assert_split_join(initial, split, joined)
    end
  end

  specify "func calls" do
    set_file_contents <<~EOF
      err := Func(a, b, c, d)
    EOF

    vim.search 'a,'
    split

    assert_file_contents <<~EOF
      err := Func(
        a,
        b,
        c,
        d,
      )
    EOF

    join

    assert_file_contents <<~EOF
      err := Func(a, b, c, d)
    EOF
  end

  specify "func definition bodies" do
    set_file_contents <<~EOF
      func foo(x, y int) bool { return x+y == 5 }
    EOF

    vim.search 'return'
    split

    assert_file_contents <<~EOF
      func foo(x, y int) bool {
        return x+y == 5
      }
    EOF

    join

    assert_file_contents <<~EOF
      func foo(x, y int) bool { return x+y == 5 }
    EOF
  end

  describe "variable declarations" do
    specify "one per line" do
      set_file_contents <<~EOF
        type ChanDir int

        func Func() {
          var foo string
          const bar string
        }
      EOF

      vim.search('var')
      split
      vim.search('const')
      split
      vim.search('type')
      split

      assert_file_contents <<~EOF
        type (
          ChanDir int
        )

        func Func() {
          var (
            foo string
          )
          const (
            bar string
          )
        }
      EOF

      vim.search('var')
      join
      vim.search('const')
      join
      vim.search('type')
      join

      assert_file_contents <<~EOF
        type ChanDir int

        func Func() {
          var foo string
          const bar string
        }
      EOF
    end

    specify "comma-separated without type" do
      set_file_contents <<~EOF
        const (
          const4 = "4"
          const5 = "5",
        )
      EOF

      join

      assert_file_contents <<~EOF
        const const4, const5 = "4", "5"
      EOF

      split

      assert_file_contents <<~EOF
        const (
          const4 = "4"
          const5 = "5"
        )
      EOF
    end

    specify "comma-separated with type, without values" do
      set_file_contents <<~EOF
        const (
          const4 string
          const5 string
        )
      EOF

      join

      assert_file_contents <<~EOF
        const const4, const5 string
      EOF

      split

      assert_file_contents <<~EOF
        const (
          const4 string
          const5 string
        )
      EOF
    end

    specify "different types don't get joined" do
      set_file_contents <<~EOF
        const (
          const4 string
          const5 int
        )
      EOF

      join

      # Triggers the built-in gJ
      assert_file_contents <<~EOF
        const (  const4 string
          const5 int
        )
      EOF
    end

    specify "join single line as a special case" do
      set_file_contents <<~EOF
        const (
          const4, const5 = "4", "5"
        )
      EOF

      join

      assert_file_contents <<~EOF
        const const4, const5 = "4", "5"
      EOF
    end

    specify "doesn't split multiline declarations" do
      set_file_contents <<~EOF
        var first = map[string]any{
          "k": "v",
        }
      EOF

      split

      assert_file_contents <<~EOF
        var first = map[string]any{
          "k": "v",
        }
      EOF

      vim.normal 'f{'
      join
      vim.search('var first')
      split

      assert_file_contents <<~EOF
        var (
          first = map[string]any{ "k": "v", }
        )
      EOF
    end
  end
end
