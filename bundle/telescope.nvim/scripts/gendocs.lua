-- Setup telescope with defaults
if RELOAD then
  RELOAD "telescope"
end
require("telescope").setup()

local docgen = require "docgen"

local docs = {}

docs.test = function()
  -- TODO: Fix the other files so that we can add them here.
  local input_files = {
    "./lua/telescope/init.lua",
    "./lua/telescope/command.lua",
    "./lua/telescope/builtin/init.lua",
    "./lua/telescope/themes.lua",
    "./lua/telescope/mappings.lua",
    "./lua/telescope/pickers/layout_strategies.lua",
    "./lua/telescope/config/resolve.lua",
    "./lua/telescope/make_entry.lua",
    "./lua/telescope/pickers/entry_display.lua",
    "./lua/telescope/utils.lua",
    "./lua/telescope/actions/init.lua",
    "./lua/telescope/actions/state.lua",
    "./lua/telescope/actions/set.lua",
    "./lua/telescope/actions/layout.lua",
    "./lua/telescope/actions/utils.lua",
    "./lua/telescope/actions/generate.lua",
    "./lua/telescope/previewers/init.lua",
    "./lua/telescope/actions/history.lua",
  }

  local output_file = "./doc/telescope.txt"
  local output_file_handle = io.open(output_file, "w")

  for _, input_file in ipairs(input_files) do
    docgen.write(input_file, output_file_handle)
  end

  output_file_handle:write " vim:tw=78:ts=8:ft=help:norl:\n"
  output_file_handle:close()
  vim.cmd [[checktime]]
end

docs.test()

return docs
