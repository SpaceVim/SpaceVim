require 'spec_helper'

describe "sh" do
  let(:filename) { 'test.sh' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  describe "by semicolon" do
    specify "simple case" do
      set_file_contents <<~EOF
        echo "one"; echo "two"
      EOF

      split

      assert_file_contents <<~EOF
        echo "one"
        echo "two"
      EOF

      vim.search('one')
      join

      assert_file_contents <<~EOF
        echo "one"; echo "two"
      EOF
    end

    specify "skipping semicolons in strings" do
      set_file_contents <<~EOF
        echo "one;two"; echo "three"
      EOF

      split

      assert_file_contents <<~EOF
        echo "one;two"
        echo "three"
      EOF
    end

    specify "skipping semicolons in groups with braces" do
      set_file_contents <<~EOF
        echo "one"; (echo "two"; echo "three") &; echo "four"
      EOF

      split

      assert_file_contents <<~EOF
        echo "one"
        (echo "two"; echo "three") &
        echo "four"
      EOF
    end
  end

  describe "with backslash" do
    specify "simple case" do
      set_file_contents <<~EOF
        echo "one" | wc -c
      EOF

      vim.search('|')
      split

      assert_file_contents <<~EOF
        echo "one" \\
          | wc -c
      EOF

      join

      assert_file_contents <<~EOF
        echo "one" | wc -c
      EOF
    end

    specify "between words, finds closest non-whitespace forward" do
      set_file_contents <<~EOF
        echo "one" | wc -c
      EOF

      vim.search(' w')
      split

      assert_file_contents <<~EOF
        echo "one" | \\
          wc -c
      EOF

      join

      assert_file_contents <<~EOF
        echo "one" | wc -c
      EOF
    end
  end
end
