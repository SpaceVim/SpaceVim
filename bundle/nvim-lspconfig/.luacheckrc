-- vim: ft=lua tw=80

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
  "212", -- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
  "631", -- max_line_length, vscode pkg URL is too long
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}
