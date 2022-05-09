local M = {}

function M.get_padding(depth)
  return string.rep(" ", depth)
end

local function get_padding_arrows(icon_state)
  return function(depth, _, _, node)
    if node.nodes then
      local icon = icon_state.icons.folder_icons[node.open and "arrow_open" or "arrow_closed"]
      return string.rep(" ", depth - 2) .. icon .. " "
    end
    return string.rep(" ", depth)
  end
end

local function get_padding_indent_markers(depth, idx, tree, _, markers)
  local padding = ""
  if depth ~= 0 then
    local rdepth = depth / 2
    markers[rdepth] = idx ~= #tree.nodes
    for i = 1, rdepth do
      if idx == #tree.nodes and i == rdepth then
        padding = padding .. M.config.indent_markers.icons.corner
      elseif markers[i] then
        padding = padding .. M.config.indent_markers.icons.edge
      else
        padding = padding .. M.config.indent_markers.icons.none
      end
    end
  end
  return padding
end

function M.reload_padding_function()
  local icon_state = require("nvim-tree.renderer.icon-config").get_config()

  if icon_state.show_folder_icon and icon_state.show_folder_arrows then
    M.get_padding = get_padding_arrows(icon_state)
  end

  if M.config.indent_markers.enable then
    M.get_padding = get_padding_indent_markers
  end
end

function M.setup(opts)
  M.config = {
    indent_markers = opts.renderer.indent_markers,
  }
end

return M
