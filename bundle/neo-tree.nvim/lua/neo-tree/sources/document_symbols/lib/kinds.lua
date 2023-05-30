---Helper module to render symbols' kinds
---Need to be initialized by calling M.setup()
local M = {}

local kinds_id_to_name = {
  [0] = "Root",
  [1] = "File",
  [2] = "Module",
  [3] = "Namespace",
  [4] = "Package",
  [5] = "Class",
  [6] = "Method",
  [7] = "Property",
  [8] = "Field",
  [9] = "Constructor",
  [10] = "Enum",
  [11] = "Interface",
  [12] = "Function",
  [13] = "Variable",
  [14] = "Constant",
  [15] = "String",
  [16] = "Number",
  [17] = "Boolean",
  [18] = "Array",
  [19] = "Object",
  [20] = "Key",
  [21] = "Null",
  [22] = "EnumMember",
  [23] = "Struct",
  [24] = "Event",
  [25] = "Operator",
  [26] = "TypeParameter",
}

local kinds_map = {}

---Get how the kind with kind_id should be rendered
---@param kind_id integer the kind_id to be render
---@return table res of the form { name = kind_display_name, icon = kind_icon, hl = kind_hl }
M.get_kind = function(kind_id)
  local kind_name = kinds_id_to_name[kind_id]
  return vim.tbl_extend(
    "force",
    { name = kind_name or ("Unknown: " .. kind_id), icon = "?", hl = "" },
    kind_name and (kinds_map[kind_name] or {}) or kinds_map["Unknown"]
  )
end

---Setup the module with custom kinds
---@param custom_kinds table additional kinds, should be of the form { [kind_id] = kind_name }
---@param kinds_display table mapping of kind_name to corresponding display name, icon and hl group
---   { [kind_name] = {
---         name = kind_display_name,
---         icon = kind_icon,
---         hl = kind_hl
---         }, }
M.setup = function(custom_kinds, kinds_display)
  kinds_id_to_name = vim.tbl_deep_extend("force", kinds_id_to_name, custom_kinds or {})
  kinds_map = kinds_display
end

return M
