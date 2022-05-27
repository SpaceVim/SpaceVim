local debug_utils = {}

function debug_utils.sourced_filepath()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str
end

function debug_utils.sourced_filename()
  local str = debug_utils.sourced_filepath()
  return str:match "^.*/(.*).lua$" or str
end

return debug_utils
