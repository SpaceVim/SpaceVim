require 'spec_helper'

describe "php" do
  let(:filename) { 'test.php' }

  before(:each) do
    vim.set(:shiftwidth, 2)
  end

  specify "arrays" do
    set_file_contents '<?php $foo = array("one" => "two", "three" => "four"); ?>'

    split

    assert_file_contents <<~EOF
      <?php $foo = array(
        "one" => "two",
        "three" => "four"
      ); ?>
    EOF

    join

    assert_file_contents '<?php $foo = array("one" => "two", "three" => "four"); ?>'
  end

  specify "square-bracketed lists" do
    set_file_contents '<?php $foo = [1, 2, 3]; ?>'

    split

    assert_file_contents <<~EOF
      <?php $foo = [
        1,
        2,
        3
      ]; ?>
    EOF

    join

    assert_file_contents '<?php $foo = [1, 2, 3]; ?>'
  end

  specify "if-clauses" do
    set_file_contents <<~EOF
      <?php
      if ($foo) { $a = "bar"; }
      ?>
    EOF

    vim.search('if')
    split

    assert_file_contents <<~EOF
      <?php
      if ($foo) {
        $a = "bar";
      }
      ?>
    EOF

    join

    assert_file_contents <<~EOF
      <?php
      if ($foo) { $a = "bar"; }
      ?>
    EOF
  end

  specify "else-clauses" do
    set_file_contents <<~EOF
      <?php
      if ($foo) { $a = "bar"; }
      else { $a = "baz"; }
      ?>
    EOF

    vim.search('else')
    split

    assert_file_contents <<~EOF
      <?php
      if ($foo) { $a = "bar"; }
      else {
        $a = "baz";
      }
      ?>
    EOF

    join

    assert_file_contents <<~EOF
      <?php
      if ($foo) { $a = "bar"; }
      else { $a = "baz"; }
      ?>
    EOF
  end

  specify "<?php markers" do
    set_file_contents "<?php example(); ?>"

    vim.search('example')
    split

    assert_file_contents <<~EOF
      <?php
      example();
      ?>
    EOF

    vim.search('php')
    join

    assert_file_contents "<?php example(); ?>"
  end

  specify "<?= markers" do
    set_file_contents "<?= 'example'; ?>"

    vim.search('example')
    split

    assert_file_contents <<~EOF
      <?=
      'example';
      ?>
    EOF

    vim.search('<?')
    join

    assert_file_contents "<?= 'example'; ?>"
  end

  specify "<? markers" do
    set_file_contents "<? example(); ?>"

    vim.search('example')
    split

    assert_file_contents <<~EOF
      <?
      example();
      ?>
    EOF

    vim.search('<?')
    join

    assert_file_contents "<? example(); ?>"
  end

  specify "method chain -> on function call" do
    set_file_contents <<~EOF
      <?php
      function stuff()
      {
        $var = $foo->one($baz->nope())->two()->three();
      }
    EOF

    vim.search('->two')
    split

    # indentation differs between versions, let's ignore it
    remove_indentation

    assert_file_contents <<~EOF
      <?php
      function stuff()
      {
      $var = $foo->one($baz->nope())
      ->two()->three();
      }
    EOF

    vim.search('foo')
    join

    assert_file_contents <<~EOF
      <?php
      function stuff()
      {
      $var = $foo->one($baz->nope())->two()->three();
      }
    EOF
  end

  specify "method chain -> on property on beginning of line" do
    set_file_contents <<~EOF
      <?php
      function stuff()
      {
        $one
          ->two->three;
      }
    EOF

    vim.search('three')
    split

    assert_file_contents <<~EOF
      <?php
      function stuff()
      {
        $one
          ->two
          ->three;
      }
    EOF

    vim.search('two')
    join

    assert_file_contents <<~EOF
      <?php
      function stuff()
      {
        $one
          ->two->three;
      }
    EOF
  end

  specify "method chain -> until end of chain" do
    vim.command('let g:splitjoin_php_method_chain_full = 1')

    set_file_contents <<~EOF
      <?php
      function stuff()
      {
        $var = $foo->one()->two($baz->nope())->three();
      }
    EOF

    vim.search('->two')
    split

    # indentation differs between versions, let's ignore it
    remove_indentation

    assert_file_contents <<~EOF
      <?php
      function stuff()
      {
      $var = $foo->one()
      ->two($baz->nope())
      ->three();
      }
    EOF

    vim.search('foo')
    join

    assert_file_contents <<~EOF
      <?php
      function stuff()
      {
      $var = $foo->one()->two($baz->nope())->three();
      }
    EOF
  end
end
