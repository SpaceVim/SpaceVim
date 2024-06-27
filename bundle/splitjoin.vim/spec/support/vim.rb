module Support
  module Vim
    def set_file_contents(string)
      write_file(filename, string)
      vim.edit!(filename)
    end

    def split
      vim.command 'normal gS'
      vim.write
    end

    def join
      vim.command 'normal gJ'
      vim.write
    end

    def remove_indentation
      vim.command '%s/^\s\+//g'
      vim.write
    end

    def assert_file_contents(string)
      expect(IO.read(filename).strip).to eq(string.strip)
    end
  end
end
