local tester = require "telescope.pickers._test"
local helper = require "telescope.pickers._test_helpers"

tester.builtin_picker("find_files", "README.md", {
  post_close = {
    { "README.md", helper.get_file },
  },
})
