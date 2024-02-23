local extensions = {}

extensions._loaded = {}
extensions._config = {}
extensions._health = {}

local load_extension = function(name)
  local ok, ext = pcall(require, "telescope._extensions." .. name)
  if not ok then
    error(string.format("'%s' extension doesn't exist or isn't installed: %s", name, ext))
  end
  return ext
end

extensions.manager = setmetatable({}, {
  __index = function(t, k)
    local ext = load_extension(k)
    t[k] = ext.exports or {}
    if ext.setup then
      ext.setup(extensions._config[k] or {}, require("telescope.config").values)
    end
    extensions._health[k] = ext.health

    return t[k]
  end,
})

--- Register an extension module.
---
--- Extensions have several important keys.
---     - setup:
---         function(ext_config, config) -> nil
---
---         Called when first loading the extension.
---         The first parameter is the config passed by the user
---             in telescope setup. The second parameter is the resulting
---             config.values after applying the users setup defaults.
---
---         It is acceptable for a plugin to override values in config,
---         as some plugins will be installed simply to manage some setup,
---         install some sorter, etc.
---
---     - exports:
---         table
---
---         Only the items in `exports` will be exposed on the  resulting
---         module that users can access via require('telescope').extensions.foo
---         Also, any top-level key-value pairs in exports where the value is a function and the
---         key doesn't start with an underscore will be included when calling the `builtin` picker
---         with the `include_extensions` option enabled.
---
---         Other things in the module will not be accessible. This is the public API
---         for your extension. Consider not breaking it a lot :laugh:
---
--- TODO:
---     - actions
extensions.register = function(mod)
  return mod
end

extensions.load = function(name)
  local ext = load_extension(name)
  if ext.setup then
    ext.setup(extensions._config[name] or {}, require("telescope.config").values)
  end
  return extensions.manager[name]
end

extensions.set_config = function(extensions_config)
  extensions._config = extensions_config or {}
end

return extensions
