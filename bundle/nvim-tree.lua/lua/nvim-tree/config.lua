-- INFO: DEPRECATED FILE, DO NOT ADD ANYTHING IN THERE
-- keeping to avoid breaking user configs. Will remove during a weekend.
local M = {}

-- TODO: remove this once the cb property is not supported in mappings
function M.nvim_tree_callback(callback_name)
  return string.format(":lua require'nvim-tree.actions'.on_keypress('%s')<CR>", callback_name)
end

return M
