require 'spec_helper'

describe "perl" do
  let(:filename) { 'test.pl' }

  before :each do
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  after :each do
    vim.command('silent! unlet g:splitjoin_trailing_comma')
  end

  after :all do
    # The perl filetype messes with iskeyword...
    vim.command('set iskeyword-=:')
  end

  specify "suffix if-clauses" do
    set_file_contents 'print "a = $a\n" if $debug;'

    split

    assert_file_contents <<~EOF
      if ($debug) {
        print "a = $a\\n";
      }
    EOF

    join

    assert_file_contents 'print "a = $a\n" if $debug;'
  end

  specify "postfix if-clauses" do
    set_file_contents 'if ($debug) { print "a = $a\\n"; }'

    split

    assert_file_contents <<~EOF
      if ($debug) {
        print "a = $a\\n";
      }
    EOF
  end

  specify "and/or control flow" do
    set_file_contents 'open PID, ">", $pidfile or die;'

    split

    assert_file_contents <<~EOF
      unless (open PID, ">", $pidfile) {
        die;
      }
    EOF

    join

    assert_file_contents 'die unless open PID, ">", $pidfile;'
  end

  specify "hashes" do
    set_file_contents "my $info = {name => $name, age => $age};"

    split

    assert_file_contents <<~EOF
      my $info = {
        name => $name,
        age => $age,
      };
    EOF

    join

    assert_file_contents "my $info = {name => $name, age => $age};"
  end

  specify "square-bracketed list" do
    set_file_contents "my @var = ['one', 'two', 'three'];"

    split

    assert_file_contents <<~EOF
      my @var = [
        'one',
        'two',
        'three'
      ];
    EOF

    join

    assert_file_contents "my @var = ['one', 'two', 'three'];"
  end

  specify "square-bracketed list, trailing comma" do
    vim.command('let g:splitjoin_trailing_comma = 1')
    set_file_contents "my @var = ['one', 'two', 'three'];"

    split

    assert_file_contents <<~EOF
      my @var = [
        'one',
        'two',
        'three',
      ];
    EOF

    join

    assert_file_contents "my @var = ['one', 'two', 'three'];"
  end

  specify "round-bracketed list" do
    set_file_contents "my @var = ('one', 'two', 'three');"

    split

    assert_file_contents <<~EOF
      my @var = (
        'one',
        'two',
        'three'
      );
    EOF

    join

    assert_file_contents "my @var = ('one', 'two', 'three');"
  end

  specify "round-bracketed list, trailing comma" do
    vim.command('let g:splitjoin_trailing_comma = 1')
    set_file_contents "my @var = ('one', 'two', 'three');"

    split

    assert_file_contents <<~EOF
      my @var = (
        'one',
        'two',
        'three',
      );
    EOF

    join

    assert_file_contents "my @var = ('one', 'two', 'three');"
  end

  specify "word lists" do
    set_file_contents "my @var = qw(one two three);"

    split

    assert_file_contents <<~EOF
      my @var = qw(
      one
      two
      three
      );
    EOF

    join

    assert_file_contents "my @var = qw(one two three);"
  end
end
