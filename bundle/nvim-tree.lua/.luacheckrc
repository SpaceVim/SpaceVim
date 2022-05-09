-- vim: ft=lua tw=80

-- Don't report unused self arguments of methods.
self = false

ignore = {
  "631",  -- max_line_length
}

-- Global objects defined by the C code
globals = {
  "vim",
  "TreeExplorer"
}
