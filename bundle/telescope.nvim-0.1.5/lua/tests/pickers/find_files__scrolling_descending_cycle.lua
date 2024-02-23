local tester = require "telescope.testharness"
local helper = require "telescope.testharness.helpers"
local runner = require "telescope.testharness.runner"

runner.picker("find_files", "telescope<c-n>", {
  post_close = {
    tester.not_ { "plugin/telescope.vim", helper.get_file },
  },
}, {
  sorting_strategy = "descending",
  scroll_strategy = "cycle",
})
