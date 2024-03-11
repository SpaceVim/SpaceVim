-- Rerun tests only if their modification time changed.
cache = true
codes = true

exclude_files = {
  "tests/indent/lua/"
}

-- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
  "212", -- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
  "411", -- Redefining a local variable.
  "412", -- Redefining an argument.
  "422", -- Shadowing an argument
  "122" -- Indirectly setting a readonly global
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}
