require 'spec_helper'

describe "haml" do
  let(:filename) { 'test.haml' }

  # Haml is not built-in, so let's set it up manually
  def setup_haml_filetype
    vim.set(:filetype, 'haml')
    vim.set(:expandtab)
    vim.set(:shiftwidth, 2)
  end

  specify "interpolation" do
    set_file_contents '%div= 1 + 2'
    setup_haml_filetype

    split

    assert_file_contents <<~EOF
      %div
        = 1 + 2
    EOF

    join

    assert_file_contents '%div= 1 + 2'
  end
end
