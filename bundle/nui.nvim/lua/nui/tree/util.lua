local NuiLine = require("nui.line")

local mod = {}

---@param node table NuiTreeNode
---@return string node_id id
function mod.default_get_node_id(node)
  if node.id then
    return "-" .. node.id
  end

  if node.text then
    local texts = node.text
    if type(node.text) ~= "table" or node.text.content then
      texts = { node.text }
    end
    return string.format(
      "%s-%s-%s",
      node._parent_id or "",
      node._depth,
      table.concat(
        vim.tbl_map(function(text)
          if type(text) == "string" then
            return text
          end
          return text:content()
        end, texts),
        "-"
      )
    )
  end

  return "-" .. math.random()
end

---@param node table NuiTreeNode
---@return table[] lines NuiLine[]
function mod.default_prepare_node(node)
  if not node.text then
    error("missing node.text")
  end

  local texts = node.text

  if type(node.text) ~= "table" or node.text.content then
    texts = { node.text }
  end

  local lines = {}

  for i, text in ipairs(texts) do
    local line = NuiLine()

    line:append(string.rep("  ", node._depth - 1))

    if i == 1 and node:has_children() then
      line:append(node:is_expanded() and " " or " ")
    else
      line:append("  ")
    end

    line:append(text)

    table.insert(lines, line)
  end

  return lines
end

return mod
