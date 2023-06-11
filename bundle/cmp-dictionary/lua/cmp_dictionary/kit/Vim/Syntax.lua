local kit = require('cmp_dictionary.kit')

local Syntax = {}

---Return the specified position is in the specified syntax.
---@param cursor { [1]: integer, [2]: integer }
---@param groups string[]
function Syntax.within(cursor, groups)
  for _, group in ipairs(Syntax.get_syntax_groups(cursor)) do
    if vim.tbl_contains(groups, group) then
      return true
    end
  end
  return false
end

---Get all syntax groups for specified position.
---NOTE: This function accepts 0-origin cursor position.
---@param cursor { [1]: integer, [2]: integer }
---@return string[]
function Syntax.get_syntax_groups(cursor)
  return kit.concat(Syntax.get_vim_syntax_groups(cursor), Syntax.get_treesitter_syntax_groups(cursor))
end

---Get vim's syntax groups for specified position.
---NOTE: This function accepts 0-origin cursor position.
---@param cursor { [1]: integer, [2]: integer }
---@return string[]
function Syntax.get_vim_syntax_groups(cursor)
  local unique = {}
  local groups = {}
  for _, syntax_id in ipairs(vim.fn.synstack(cursor[1] + 1, cursor[2] + 1)) do
    local name = vim.fn.synIDattr(vim.fn.synIDtrans(syntax_id), 'name')
    if not unique[name] then
      unique[name] = true
      table.insert(groups, name)
    end
  end
  for _, syntax_id in ipairs(vim.fn.synstack(cursor[1] + 1, cursor[2] + 1)) do
    local name = vim.fn.synIDattr(syntax_id, 'name')
    if not unique[name] then
      unique[name] = true
      table.insert(groups, name)
    end
  end
  return groups
end

---Get tree-sitter's syntax groups for specified position.
---NOTE: This function accepts 0-origin cursor position.
---@param cursor { [1]: integer, [2]: integer }
---@return string[]
function Syntax.get_treesitter_syntax_groups(cursor)
  local groups = {}
  for _, capture in ipairs(vim.treesitter.get_captures_at_pos(0, cursor[1], cursor[2])) do
    table.insert(groups, ('@%s'):format(capture.capture))
  end
  return groups
end

return Syntax
