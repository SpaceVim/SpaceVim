require 'spec_helper'

describe "tex" do
  let(:filename) { 'test.tex' }

  before :each do
    vim.set :expandtab
    vim.set :shiftwidth, 2
  end

  specify "simple blocks" do
    set_file_contents <<~EOF
      \\begin{center} Hello World \\end{center}
    EOF

    split

    assert_file_contents <<~EOF
      \\begin{center}
        Hello World
      \\end{center}
    EOF

    vim.search 'begin'
    join

    assert_file_contents <<~EOF
      \\begin{center} Hello World \\end{center}
    EOF
  end

  specify "multiline block" do
    set_file_contents <<~EOF
      \\begin{center} x = y\\\\  y = z \\end{center}
    EOF

    split

    assert_file_contents <<~EOF
      \\begin{center}
        x = y\\\\
        y = z
      \\end{center}
    EOF

    join

    assert_file_contents <<~EOF
      \\begin{center} x = y\\\\ y = z \\end{center}
    EOF
  end

  specify "block with parameters" do
    set_file_contents <<~EOF
      \\begin{tabular}[]{cc} row1 \\\\ row2 \\end{tabular}
    EOF

    split

    assert_file_contents <<~EOF
      \\begin{tabular}[]{cc}
        row1 \\\\
        row2
      \\end{tabular}
    EOF

    join

    assert_file_contents <<~EOF
      \\begin{tabular}[]{cc} row1 \\\\ row2 \\end{tabular}
    EOF
  end

  specify "itemized blocks" do
    set_file_contents <<~EOF
      \\begin{enumerate}\\item item1 \\item item2\\end{enumerate}
    EOF

    split

    assert_file_contents <<~EOF
      \\begin{enumerate}
        \\item item1
        \\item item2
      \\end{enumerate}
    EOF

    join

    assert_file_contents <<~EOF
      \\begin{enumerate} \\item item1 \\item item2 \\end{enumerate}
    EOF
  end
end
