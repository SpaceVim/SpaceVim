require 'spec_helper'

describe "yaml" do
  let(:filename) { 'test.yml' }

  before :each do
    vim.set 'expandtab'
    vim.set 'shiftwidth', 2
  end

  after :each do
    vim.command('silent! unlet g:splitjoin_curly_brace_padding')
  end

  describe "arrays" do
    specify "basic" do
      set_file_contents <<~EOF
        root:
          one: [1, 2]
          two: ['three', 'four']
      EOF

      vim.search 'one'
      split
      vim.search 'two'
      split

      assert_file_contents <<~EOF
        root:
          one:
            - 1
            - 2
          two:
            - 'three'
            - 'four'
      EOF

      vim.search 'one'
      join
      vim.search 'two'
      join

      assert_file_contents <<~EOF
        root:
          one: [1, 2]
          two: ['three', 'four']
      EOF
    end

    specify "with empty spaces" do
      set_file_contents <<~EOF
        root:
          - 'one'

          - 'two'

      EOF

      vim.search 'root'
      join

      assert_file_contents <<~EOF
        root: ['one', 'two']
      EOF
    end

    specify "with strings containing a colon" do
      set_file_contents <<~EOF
        root:
          - 'one: foo'
          - 'two: bar'
      EOF

      vim.search 'root'
      join

      assert_file_contents <<~EOF
        root: ['one: foo', 'two: bar']
      EOF

      vim.search 'root'
      split

      assert_file_contents <<~EOF
        root:
          - 'one: foo'
          - 'two: bar'
      EOF
    end

    specify "with strings containing a comma" do
      set_file_contents <<~EOF
        root:
          - 'one, foo'
          - 'two, bar'

      EOF

      vim.search 'root'
      join

      assert_file_contents <<~EOF
        root: ['one, foo', 'two, bar']
      EOF

      vim.search 'root'
      split

      assert_file_contents <<~EOF
        root:
          - 'one, foo'
          - 'two, bar'
      EOF
    end

    specify "splitting nested maps inside an array" do
      set_file_contents <<~EOF
        root: [{ one: { foo: bar } }]
      EOF

      vim.search 'root'
      split

      assert_file_contents <<~EOF
        root:
          - one: { foo: bar }
      EOF
    end


    specify "nested objects inside an array" do
      set_file_contents <<~EOF
        root:
          - one: { foo: bar }
      EOF

      vim.search 'one'
      split

      assert_file_contents <<~EOF
        root:
          - one:
              foo: bar
      EOF
    end

    specify "list of simple objects" do
      set_file_contents <<~EOF
        list: [{ aprop: 1 }, { aProp: 2 }, { 'a:prop': 3 }, { a prop: 4 }, { a#prop: 5 }]
      EOF

      vim.search 'list'
      split

      assert_file_contents <<~EOF
        list:
          - aprop: 1
          - aProp: 2
          - 'a:prop': 3
          - a prop: 4
          - a#prop: 5
      EOF

      vim.search 'list'
      join

      assert_file_contents <<~EOF
        list: [{ aprop: 1 }, { aProp: 2 }, { 'a:prop': 3 }, { a prop: 4 }, { a#prop: 5 }]
      EOF
    end

    specify "containing mixed elements" do
      set_file_contents <<~EOF
        list: [{ prop: 1 }, { a: 1, b: 2 }, "a: b", { a value: 1, 'a:value': 2, aValue: 3 }]
      EOF

      vim.search 'list'
      split

      assert_file_contents <<~EOF
        list:
          - prop: 1
          - { a: 1, b: 2 }
          - "a: b"
          - { a value: 1, 'a:value': 2, aValue: 3 }
      EOF

      vim.search 'list'
      join

      assert_file_contents <<~EOF
        list: [{ prop: 1 }, { a: 1, b: 2 }, "a: b", { a value: 1, 'a:value': 2, aValue: 3 }]
      EOF
    end

    specify "preserve empty lines" do
      set_file_contents <<~EOF
        list:
          - 1

        end: true
      EOF

      vim.search 'list'
      join

      assert_file_contents <<~EOF
        list: [1]

        end: true
      EOF

      vim.search 'list'
      split

      assert_file_contents <<~EOF
        list:
          - 1

        end: true
      EOF
    end

    specify "Not handled: containing mulitline maps (recursive)" do
      set_file_contents <<~EOF
        list:
          - one: 1
            two: 2
      EOF

      vim.search 'list'
      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinJoin'

      # Does nothing, needs to be joined from the inside first
      assert_file_contents <<~EOF
        list:
          - one: 1
            two: 2
      EOF
    end

    specify "Not handled: containing arrays (recursive)" do
      set_file_contents <<~EOF
        list:
          - - 1
            - 2
      EOF

      vim.search 'list'
      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinJoin'

      assert_file_contents <<~EOF
        list:
          - - 1
            - 2
      EOF
    end

    specify "inside an array" do
      set_file_contents <<~EOF
        list:
          - - 1
            - 2
      EOF

      vim.search '1'
      join

      assert_file_contents <<~EOF
        list:
          - [1, 2]
      EOF
    end

    specify "split nested arrays" do
      set_file_contents <<~EOF
        list: [[[1, 2]]]
      EOF

      vim.search 'list'
      split

      assert_file_contents <<~EOF
        list:
          - [[1, 2]]
      EOF

      vim.search '1'
      split

      assert_file_contents <<~EOF
        list:
          - - [1, 2]
      EOF

      vim.search '1'
      split

      assert_file_contents <<~EOF
        list:
          - - - 1
              - 2
      EOF
    end

    specify "join nested arrays" do
      set_file_contents <<~EOF
        list:
          - - - 1
              - 2
          - - - 3
        end: true
      EOF

      vim.search '1'
      join

      assert_file_contents <<~EOF
        list:
          - - [1, 2]
          - - - 3
        end: true
      EOF

      vim.search '1'
      join

      assert_file_contents <<~EOF
        list:
          - [[1, 2]]
          - - - 3
        end: true
      EOF

      vim.search '3'
      join

      assert_file_contents <<~EOF
        list:
          - [[1, 2]]
          - - [3]
        end: true
      EOF

      vim.search '3'
      join

      assert_file_contents <<~EOF
        list:
          - [[1, 2]]
          - [[3]]
        end: true
      EOF

      vim.search 'list'
      join

      assert_file_contents <<~EOF
        list: [[[1, 2]], [[3]]]
        end: true
      EOF
    end

    specify "stripping comments" do
      set_file_contents <<~EOF
        root#list:     # root object
          - 'one'
          - 'two' # second record
      EOF

      vim.search 'root'
      join

      assert_file_contents <<~EOF
        root#list: ['one', 'two']
      EOF
    end

    specify "joining inside an array and map with other properties" do
      set_file_contents <<~EOF
        list:
          - foo:
              - 1
              - 2
            bar:
              one: 1
              two: 2
        end: true
      EOF

      vim.search 'foo:'
      join

      assert_file_contents <<~EOF
        list:
          - foo: [1, 2]
            bar:
              one: 1
              two: 2
        end: true
      EOF
    end
  end

  describe "maps" do
    specify "basic" do
      set_file_contents <<~EOF
        root:
          one: { foo: bar }
          two: { three: ['four', 'five'], six: seven }
      EOF

      vim.search 'one'
      split
      vim.search 'two'
      split

      assert_file_contents <<~EOF
        root:
          one:
            foo: bar
          two:
            three: ['four', 'five']
            six: seven
      EOF

      vim.search 'one'
      join
      vim.search 'two'
      join

      assert_file_contents <<~EOF
        root:
          one: { foo: bar }
          two: { three: ['four', 'five'], six: seven }
      EOF
    end

    specify "with multiple spaces after key" do
      set_file_contents <<~EOF
        root:  { one: 1 }
      EOF

      vim.search 'root:'
      split

      assert_file_contents <<~EOF
        root:
          one: 1
      EOF
    end

    specify "without padding" do
      vim.command 'let g:splitjoin_curly_brace_padding = 0'

      set_file_contents <<~EOF
        root:
          one: 1
      EOF

      vim.search 'root:'
      join

      assert_file_contents 'root: {one: 1}'
    end

    specify "complex keys" do
      set_file_contents <<~EOF
        root:
          one value: 1
          'my:key': 2
      EOF

      vim.search 'root'
      join

      assert_file_contents <<~EOF
        root: { one value: 1, 'my:key': 2 }
      EOF
    end

    specify "preserve empty lines" do
      set_file_contents <<~EOF
        map:
          one: 1

        end: true
      EOF

      vim.search ''
      join

      assert_file_contents <<~EOF
        map: { one: 1 }

        end: true
      EOF

      vim.search 'map'
      split

      assert_file_contents <<~EOF
        map:
          one: 1

        end: true
      EOF
    end

    specify "joining inside an array" do
      set_file_contents <<~EOF
        list:
          - one: 1
            two: 2
        end: true
      EOF

      vim.search 'one:'
      join

      assert_file_contents <<~EOF
        list:
          - { one: 1, two: 2 }
        end: true
      EOF
    end

    specify "splitting inside an array" do
      set_file_contents <<~EOF
        list:
          - { one: 1, two: 2 }
        end: true
      EOF

      vim.search 'one:'
      split

      assert_file_contents <<~EOF
        list:
          - one: 1
            two: 2
        end: true
      EOF
    end

    specify "splitting inside an array, with complex properties" do
      set_file_contents <<~EOF
        list:
          - { one: 1, two: [ 'foo', 'bar' ], three: { foo: 'item-1', bar: 'item-2' } }
        end: true
      EOF

      vim.search 'one:'
      split

      assert_file_contents <<~EOF
        list:
          - one: 1
            two: [ 'foo', 'bar' ]
            three: { foo: 'item-1', bar: 'item-2' }
        end: true
      EOF
    end

    specify "joining inside an array and map" do
      set_file_contents <<~EOF
        list:
          - foo:
              one: 1
              two: 2
        end: true
      EOF

      vim.search 'foo:'
      join

      assert_file_contents <<~EOF
        list:
          - foo: { one: 1, two: 2 }
        end: true
      EOF
    end

    specify "joining inside an array and map with other properties" do
      set_file_contents <<~EOF
        list:
          - foo:
              one: 1
              two: 2
            bar:
              one: 1
              two: 2
        end: true
      EOF

      vim.search 'foo:'
      join

      assert_file_contents <<~EOF
        list:
          - foo: { one: 1, two: 2 }
            bar:
              one: 1
              two: 2
        end: true
      EOF
    end

    specify "splitting inside an array and map" do
      set_file_contents <<~EOF
        list:
          - foo: { one: 1, two: 2 }
        end: true
      EOF

      vim.search 'foo:'
      split

      assert_file_contents <<~EOF
        list:
          - foo:
              one: 1
              two: 2
        end: true
      EOF
    end

    specify "Not handled: containing nested maps (recursive)" do
      set_file_contents <<~EOF
        map:
          foo:
            bar: 2
      EOF

      vim.search 'map'
      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinJoin'

      assert_file_contents <<~EOF
        map:
          foo:
            bar: 2
      EOF
    end

    specify "Not handled: containing nested maps within lists (recursive)" do
      set_file_contents <<~EOF
        list1:
          - one: 1
          - two: 2
            four:
              five: 6
      EOF

      vim.search 'two'
      # Call command instead of mapping to avoid default mapping
      vim.command 'SplitjoinJoin'

      assert_file_contents <<~EOF
        list1:
          - one: 1
          - two: 2
            four:
              five: 6
      EOF
    end

    specify "stripping comments" do
      set_file_contents <<~EOF
        root_a#list: # root object
          a: 'one'
          b: 'two' # one more
        root_b#list:
          - prop:    # nested object
              a: 'one' # another
              b: 'two'
      EOF

      vim.search 'root_a'
      join

      vim.search 'prop'
      join

      assert_file_contents <<~EOF
        root_a#list: { a: 'one', b: 'two' }
        root_b#list:
          - prop: { a: 'one', b: 'two' }
      EOF
    end

    specify "splitting paths in maps" do
      set_file_contents <<~EOF
        - copy: { dest: /etc/default/locale, content: "LANG=en_US.UTF-8" }
      EOF

      vim.search 'dest'
      split

      assert_file_contents <<~EOF
        - copy:
            dest: /etc/default/locale
            content: "LANG=en_US.UTF-8"
      EOF
    end
  end
end
