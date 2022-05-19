require("plenary.reload").reload_module "plenary"
require("plenary.reload").reload_module "telescope"

local tester = require "telescope.pickers._test"
local helper = require "telescope.pickers._test_helpers"

tester.builtin_picker("find_files", "telescope<c-n>", {
  post_close = {
    tester.not_ { "plugin/telescope.vim", helper.get_file },
  },
}, {
  sorting_strategy = "descending",
  scroll_strategy = "cycle",
})
