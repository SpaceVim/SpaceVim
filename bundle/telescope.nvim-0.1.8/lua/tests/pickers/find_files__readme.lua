local helper = require "telescope.testharness.helpers"
local runner = require "telescope.testharness.runner"

runner.picker("find_files", "README.md", {
  post_close = {
    { "README.md", helper.get_file },
  },
})
