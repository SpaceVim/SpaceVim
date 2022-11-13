local query = require "vim.treesitter.query"

local function error(str)
  vim.api.nvim_err_writeln(str)
end

local function valid_args(name, pred, count, strict_count)
  local arg_count = #pred - 1

  if strict_count then
    if arg_count ~= count then
      error(string.format("%s must have exactly %d arguments", name, count))
      return false
    end
  elseif arg_count < count then
    error(string.format("%s must have at least %d arguments", name, count))
    return false
  end

  return true
end

query.add_predicate("nth?", function(match, pattern, bufnr, pred)
  if not valid_args("nth?", pred, 2, true) then
    return
  end

  local node = match[pred[2]]
  local n = tonumber(pred[3])
  if node and node:parent() and node:parent():named_child_count() > n then
    return node:parent():named_child(n) == node
  end

  return false
end)

local function has_ancestor(match, pattern, bufnr, pred)
  if not valid_args(pred[1], pred, 2) then
    return
  end

  local node = match[pred[2]]
  local ancestor_types = { unpack(pred, 3) }
  if not node then
    return true
  end

  local just_direct_parent = pred[1]:find("has-parent", 1, true)

  node = node:parent()
  while node do
    if vim.tbl_contains(ancestor_types, node:type()) then
      return true
    end
    if just_direct_parent then
      node = nil
    else
      node = node:parent()
    end
  end
  return false
end

query.add_predicate("has-ancestor?", has_ancestor)

query.add_predicate("has-parent?", has_ancestor)

query.add_predicate("is?", function(match, pattern, bufnr, pred)
  if not valid_args("is?", pred, 2) then
    return
  end

  -- Avoid circular dependencies
  local locals = require "nvim-treesitter.locals"
  local node = match[pred[2]]
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  local _, _, kind = locals.find_definition(node, bufnr)

  return vim.tbl_contains(types, kind)
end)

query.add_predicate("has-type?", function(match, pattern, bufnr, pred)
  if not valid_args(pred[1], pred, 2) then
    return
  end

  local node = match[pred[2]]
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  return vim.tbl_contains(types, node:type())
end)

-- Just avoid some annoying warnings for this directive
query.add_directive("make-range!", function() end)

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local text, key, value

  if #pred == 3 then
    -- (#downcase! @capture "key")
    key = pred[3]
    value = metadata[pred[2]][key]
  else
    -- (#downcase! "key")
    key = pred[2]
    value = metadata[key]
  end

  if type(value) == "string" then
    text = value
  else
    local node = match[value]
    text = query.get_node_text(node, bufnr) or ""
  end

  if #pred == 3 then
    metadata[pred[2]][key] = string.lower(text)
  else
    metadata[key] = string.lower(text)
  end
end)

query.add_directive("exclude_children!", function(match, _pattern, _bufnr, pred, metadata)
  local capture_id = pred[2]
  local node = match[capture_id]
  local start_row, start_col, end_row, end_col = node:range()
  local ranges = {}
  for i = 0, node:named_child_count() - 1 do
    local child = node:named_child(i)
    local child_start_row, child_start_col, child_end_row, child_end_col = child:range()
    if child_start_row > start_row or child_start_col > start_col then
      table.insert(ranges, {
        start_row,
        start_col,
        child_start_row,
        child_start_col,
      })
    end
    start_row = child_end_row
    start_col = child_end_col
  end
  if end_row > start_row or end_col > start_col then
    table.insert(ranges, { start_row, start_col, end_row, end_col })
  end
  metadata.content = ranges
end)

-- Trim blank lines from end of the region
-- Arguments are the captures to trim.
query.add_directive("trim!", function(match, _, bufnr, pred, metadata)
  for _, id in ipairs { select(2, unpack(pred)) } do
    local node = match[id]
    local start_row, start_col, end_row, end_col = node:range()

    -- Don't trim if region ends in middle of a line
    if end_col ~= 0 then
      return
    end

    while true do
      -- As we only care when end_col == 0, always inspect one line above end_row.
      local end_line = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)[1]

      if end_line ~= "" then
        break
      end

      end_row = end_row - 1
    end

    -- If this produces an invalid range, we just skip it.
    if start_row < end_row or (start_row == end_row and start_col <= end_col) then
      if not metadata[id] then
        metadata[id] = {}
      end
      metadata[id].range = { start_row, start_col, end_row, end_col }
    end
  end
end)
