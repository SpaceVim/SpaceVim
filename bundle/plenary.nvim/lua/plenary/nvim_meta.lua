local get_lua_version = function()
  if jit then
    return {
      lua = string.gsub(_VERSION, "Lua ", ""),
      jit = not not string.find(jit.version, "LuaJIT"),
      version = string.gsub(jit.version, "LuaJIT ", ""),
    }
  end

  error("NEOROCKS: Unsupported Lua Versions", _VERSION)
end

return {
  -- Is run in `--headless` mode.
  is_headless = (#vim.api.nvim_list_uis() == 0),

  lua_jit = get_lua_version(),
}
