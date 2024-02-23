-- Rerun tests only if their modification time changed.
cache = true

std = luajit
codes = true

self = false

-- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
  "212", -- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
  "122", -- Indirectly setting a readonly global
}

globals = {
  "_",
  "TelescopeGlobalState",
  "_TelescopeConfigurationValues",
  "_TelescopeConfigurationPickers",
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}

files = {
  ["lua/telescope/builtin/init.lua"] = {
    ignore = {
      "631", -- allow line len > 120
    }
  },
}
