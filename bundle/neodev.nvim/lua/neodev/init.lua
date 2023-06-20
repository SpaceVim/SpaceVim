local M = {}

local function neoconf(config)
  pcall(function()
    require("neoconf.plugins").register({
      on_schema = function(schema)
        schema:import("neodev", config.defaults)
        schema:set("neodev.library.plugins", {
          description = "true/false or an array of plugin names to enable",
          anyOf = {
            { type = "boolean" },
            { type = "array", items = { type = "string" } },
          },
        })
      end,
    })
  end)
end

---@param opts? LuaDevOptions
function M.setup(opts)
  local config = require("neodev.config")
  config.setup(opts)

  if config.options.lspconfig then
    require("neodev.lsp").setup()
  end

  neoconf(config)

  -- leave this for now for backward compatibility
  return {
    settings = {
      legacy = true,
    },
  }
end

return M
