local api = vim.api

local queries = require "nvim-treesitter.query"
local ts = require "nvim-treesitter.compat"
local parsers = require "nvim-treesitter.parsers"
local utils = require "nvim-treesitter.utils"
local caching = require "nvim-treesitter.caching"

local M = {}

---@class TSConfig
---@field modules {[string]:TSModule}
---@field sync_install boolean
---@field ensure_installed string[]|string
---@field ignore_install string[]
---@field auto_install boolean
---@field parser_install_dir string|nil

---@type TSConfig
local config = {
  modules = {},
  sync_install = false,
  ensure_installed = {},
  auto_install = false,
  ignore_install = {},
  parser_install_dir = nil,
}

-- List of modules that need to be setup on initialization.
---@type TSModule[][]
local queued_modules_defs = {}
-- Whether we've initialized the plugin yet.
local is_initialized = false

---@class TSModule
---@field module_path string
---@field enable boolean|string[]|function(string): boolean
---@field disable boolean|string[]|function(string): boolean
---@field keymaps table<string, string>
---@field is_supported function(string): boolean
---@field attach function(string)
---@field detach function(string)
---@field enabled_buffers table<integer, boolean>
---@field additional_vim_regex_highlighting boolean|string[]

---@type {[string]: TSModule}
local builtin_modules = {
  highlight = {
    module_path = "nvim-treesitter.highlight",
    -- @deprecated: use `highlight.set_custom_captures` instead
    custom_captures = {},
    enable = false,
    is_supported = function(lang)
      return queries.has_highlights(lang)
    end,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    module_path = "nvim-treesitter.incremental_selection",
    enable = false,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
    is_supported = function()
      return true
    end,
  },
  indent = {
    module_path = "nvim-treesitter.indent",
    enable = false,
    is_supported = queries.has_indents,
  },
}

local attached_buffers_by_module = caching.create_buffer_cache()

---Resolves a module by requiring the `module_path` or using the module definition.
---@param mod_name string
---@return TSModule|nil
local function resolve_module(mod_name)
  local config_mod = M.get_module(mod_name)

  if not config_mod then
    return
  end

  if type(config_mod.attach) == "function" and type(config_mod.detach) == "function" then
    return config_mod
  elseif type(config_mod.module_path) == "string" then
    return require(config_mod.module_path)
  end
end

---Enables and attaches the module to a buffer for lang.
---@param mod string path to module
---@param bufnr integer|nil buffer number, defaults to current buffer
---@param lang string|nil language, defaults to current language
local function enable_module(mod, bufnr, lang)
  local module = M.get_module(mod)
  if not module then
    return
  end

  bufnr = bufnr or api.nvim_get_current_buf()
  lang = lang or parsers.get_buf_lang(bufnr)

  if not module.enable then
    if module.enabled_buffers then
      module.enabled_buffers[bufnr] = true
    else
      module.enabled_buffers = { [bufnr] = true }
    end
  end

  M.attach_module(mod, bufnr, lang)
end

---Enables autocomands for the module.
---After the module is loaded `loaded` will be set to true for the module.
---@param mod string path to module
local function enable_mod_conf_autocmd(mod)
  local config_mod = M.get_module(mod)
  if not config_mod or config_mod.loaded then
    return
  end

  api.nvim_create_autocmd("FileType", {
    group = api.nvim_create_augroup("NvimTreesitter-" .. mod, {}),
    callback = function(args)
      require("nvim-treesitter.configs").reattach_module(mod, args.buf)
    end,
    desc = "Reattach module",
  })

  config_mod.loaded = true
end

---Enables the module globally and for all current buffers.
---After enabled, `enable` will be set to true for the module.
---@param mod string path to module
local function enable_all(mod)
  local config_mod = M.get_module(mod)
  if not config_mod then
    return
  end

  enable_mod_conf_autocmd(mod)
  config_mod.enable = true
  config_mod.enabled_buffers = nil

  for _, bufnr in pairs(api.nvim_list_bufs()) do
    enable_module(mod, bufnr)
  end
end

---Disables and detaches the module for a buffer.
---@param mod string path to module
---@param bufnr integer buffer number, defaults to current buffer
local function disable_module(mod, bufnr)
  local module = M.get_module(mod)
  if not module then
    return
  end

  bufnr = bufnr or api.nvim_get_current_buf()
  if module.enabled_buffers then
    module.enabled_buffers[bufnr] = false
  end
  M.detach_module(mod, bufnr)
end

---Disables autocomands for the module.
---After the module is unloaded `loaded` will be set to false for the module.
---@param mod string path to module
local function disable_mod_conf_autocmd(mod)
  local config_mod = M.get_module(mod)
  if not config_mod or not config_mod.loaded then
    return
  end
  api.nvim_clear_autocmds { event = "FileType", group = "NvimTreesitter-" .. mod }
  config_mod.loaded = false
end

---Disables the module globally and for all current buffers.
---After disabled, `enable` will be set to false for the module.
---@param mod string path to module
local function disable_all(mod)
  local config_mod = M.get_module(mod)
  if not config_mod then
    return
  end

  config_mod.enabled_buffers = nil
  disable_mod_conf_autocmd(mod)
  config_mod.enable = false

  for _, bufnr in pairs(api.nvim_list_bufs()) do
    disable_module(mod, bufnr)
  end
end

---Toggles a module for a buffer
---@param mod string path to module
---@param bufnr integer buffer number, defaults to current buffer
---@param lang string language, defaults to current language
local function toggle_module(mod, bufnr, lang)
  bufnr = bufnr or api.nvim_get_current_buf()
  lang = lang or parsers.get_buf_lang(bufnr)

  if attached_buffers_by_module.has(mod, bufnr) then
    disable_module(mod, bufnr)
  else
    enable_module(mod, bufnr, lang)
  end
end

-- Toggles the module globally and for all current buffers.
-- @param mod path to module
local function toggle_all(mod)
  local config_mod = M.get_module(mod)
  if not config_mod then
    return
  end

  if config_mod.enable then
    disable_all(mod)
  else
    enable_all(mod)
  end
end

---Recurses through all modules including submodules
---@param accumulator function called for each module
---@param root {[string]: TSModule}|nil root configuration table to start at
---@param path string|nil prefix path
local function recurse_modules(accumulator, root, path)
  root = root or config.modules

  for name, module in pairs(root) do
    local new_path = path and (path .. "." .. name) or name

    if M.is_module(module) then
      accumulator(name, module, new_path, root)
    elseif type(module) == "table" then
      recurse_modules(accumulator, module, new_path)
    end
  end
end

-- Shows current configuration of all nvim-treesitter modules
---@param process_function function used as the `process` parameter
---       for vim.inspect (https://github.com/kikito/inspect.lua#optionsprocess)
local function config_info(process_function)
  process_function = process_function
    or function(item, path)
      if path[#path] == vim.inspect.METATABLE then
        return
      end
      if path[#path] == "is_supported" then
        return
      end
      return item
    end
  print(vim.inspect(config, { process = process_function }))
end

---@param query_group string
---@param lang string
function M.edit_query_file(query_group, lang)
  lang = lang or parsers.get_buf_lang()
  local files = ts.get_query_files(lang, query_group, true)
  if #files == 0 then
    utils.notify "No query file found! Creating a new one!"
    M.edit_query_file_user_after(query_group, lang)
  elseif #files == 1 then
    vim.cmd(":edit " .. files[1])
  else
    vim.ui.select(files, { prompt = "Select a file:" }, function(file)
      if file then
        vim.cmd(":edit " .. file)
      end
    end)
  end
end

---@param query_group string
---@param lang string
function M.edit_query_file_user_after(query_group, lang)
  lang = lang or parsers.get_buf_lang()
  local folder = utils.join_path(vim.fn.stdpath "config", "after", "queries", lang)
  local file = utils.join_path(folder, query_group .. ".scm")
  if vim.fn.isdirectory(folder) ~= 1 then
    vim.ui.select({ "Yes", "No" }, { prompt = '"' .. folder .. '" does not exist. Create it?' }, function(choice)
      if choice == "Yes" then
        vim.fn.mkdir(folder, "p", "0755")
        vim.cmd(":edit " .. file)
      end
    end)
  else
    vim.cmd(":edit " .. file)
  end
end

M.commands = {
  TSBufEnable = {
    run = enable_module,
    args = {
      "-nargs=1",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
  TSBufDisable = {
    run = disable_module,
    args = {
      "-nargs=1",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
  TSBufToggle = {
    run = toggle_module,
    args = {
      "-nargs=1",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
  TSEnable = {
    run = enable_all,
    args = {
      "-nargs=+",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
  TSDisable = {
    run = disable_all,
    args = {
      "-nargs=+",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
  TSToggle = {
    run = toggle_all,
    args = {
      "-nargs=+",
      "-complete=custom,nvim_treesitter#available_modules",
    },
  },
  TSConfigInfo = {
    run = config_info,
    args = {
      "-nargs=0",
    },
  },
  TSEditQuery = {
    run = M.edit_query_file,
    args = {
      "-nargs=+",
      "-complete=custom,nvim_treesitter#available_query_groups",
    },
  },
  TSEditQueryUserAfter = {
    run = M.edit_query_file_user_after,
    args = {
      "-nargs=+",
      "-complete=custom,nvim_treesitter#available_query_groups",
    },
  },
}

---@param mod string module
---@param lang string the language of the buffer
---@param bufnr integer the buffer
function M.is_enabled(mod, lang, bufnr)
  if not parsers.has_parser(lang) then
    return false
  end

  local module_config = M.get_module(mod)
  if not module_config then
    return false
  end

  local buffer_enabled = module_config.enabled_buffers and module_config.enabled_buffers[bufnr]
  local config_enabled = module_config.enable or buffer_enabled
  if not config_enabled or not module_config.is_supported(lang) then
    return false
  end

  local disable = module_config.disable
  if type(disable) == "function" then
    if disable(lang, bufnr) then
      return false
    end
  elseif type(disable) == "table" then
    -- Otherwise it's a list of languages
    for _, parser in pairs(disable) do
      if lang == parser then
        return false
      end
    end
  end

  return true
end

---Setup call for users to override module configurations.
---@param user_data TSConfig module overrides
function M.setup(user_data)
  config.modules = vim.tbl_deep_extend("force", config.modules, user_data)
  config.ignore_install = user_data.ignore_install or {}
  config.parser_install_dir = user_data.parser_install_dir or nil
  if config.parser_install_dir then
    config.parser_install_dir = vim.fn.expand(config.parser_install_dir, ":p")
  end

  config.auto_install = user_data.auto_install or false
  if config.auto_install then
    require("nvim-treesitter.install").setup_auto_install()
  end

  local ensure_installed = user_data.ensure_installed or {}
  if #ensure_installed > 0 then
    if user_data.sync_install then
      require("nvim-treesitter.install").ensure_installed_sync(ensure_installed)
    else
      require("nvim-treesitter.install").ensure_installed(ensure_installed)
    end
  end

  config.modules.ensure_installed = nil
  config.ensure_installed = ensure_installed

  recurse_modules(function(_, _, new_path)
    local data = utils.get_at_path(config.modules, new_path)
    if data.enable then
      enable_all(new_path)
    end
  end, config.modules)
end

-- Defines a table of modules that can be attached/detached to buffers
-- based on language support. A module consist of the following properties:
---* @enable Whether the modules is enabled. Can be true or false.
---* @disable A list of languages to disable the module for. Only relevant if enable is true.
---* @keymaps A list of user mappings for a given module if relevant.
---* @is_supported A function which, given a ft, will return true if the ft works on the module.
---* @module_path A string path to a module file using `require`. The exported module must contain
---               an `attach` and `detach` function. This path is not required if `attach` and `detach`
---               functions are provided directly on the module definition.
---* @attach An attach function that is called for each buffer that the module is enabled for. This is required
---          if a `module_path` is not specified.
---* @detach A detach function that is called for each buffer that the module is enabled for. This is required
---          if a `module_path` is not specified.
--
-- Modules are not setup until `init` is invoked by the plugin. This allows modules to be defined in any order
-- and can be loaded lazily.
--
---* @example
---require"nvim-treesitter".define_modules {
---  my_cool_module = {
---    attach = function()
---      do_some_cool_setup()
---    end,
---    detach = function()
---      do_some_cool_teardown()
---    end
---  }
---}
---@param mod_defs TSModule[]
function M.define_modules(mod_defs)
  if not is_initialized then
    table.insert(queued_modules_defs, mod_defs)
    return
  end

  recurse_modules(function(key, mod, _, group)
    group[key] = vim.tbl_extend("keep", mod, {
      enable = false,
      disable = {},
      is_supported = function()
        return true
      end,
    })
  end, mod_defs)

  config.modules = vim.tbl_deep_extend("keep", config.modules, mod_defs)

  for _, mod in ipairs(M.available_modules(mod_defs)) do
    local module_config = M.get_module(mod)
    if module_config and module_config.enable then
      enable_mod_conf_autocmd(mod)
    end
  end
end

---Attaches a module to a buffer
---@param mod_name string the module name
---@param bufnr integer the buffer
---@param lang string the language of the buffer
function M.attach_module(mod_name, bufnr, lang)
  bufnr = bufnr or api.nvim_get_current_buf()
  lang = lang or parsers.get_buf_lang(bufnr)
  local resolved_mod = resolve_module(mod_name)

  if resolved_mod and not attached_buffers_by_module.has(mod_name, bufnr) and M.is_enabled(mod_name, lang, bufnr) then
    attached_buffers_by_module.set(mod_name, bufnr, true)
    resolved_mod.attach(bufnr, lang)
  end
end

-- Detaches a module to a buffer
---@param mod_name string the module name
---@param bufnr integer the buffer
function M.detach_module(mod_name, bufnr)
  local resolved_mod = resolve_module(mod_name)
  bufnr = bufnr or api.nvim_get_current_buf()

  if resolved_mod and attached_buffers_by_module.has(mod_name, bufnr) then
    attached_buffers_by_module.remove(mod_name, bufnr)
    resolved_mod.detach(bufnr)
  end
end

-- Same as attach_module, but if the module is already attached, detach it first.
---@param mod_name string the module name
---@param bufnr integer the buffer
---@param lang string the language of the buffer
function M.reattach_module(mod_name, bufnr, lang)
  M.detach_module(mod_name, bufnr)
  M.attach_module(mod_name, bufnr, lang)
end

-- Gets available modules
---@param root {[string]:TSModule}|nil table to find modules
---@return string[] modules list of module paths
function M.available_modules(root)
  local modules = {}

  recurse_modules(function(_, _, path)
    table.insert(modules, path)
  end, root)

  return modules
end

---Gets a module config by path
---@param mod_path string path to the module
---@return TSModule|nil: the module or nil
function M.get_module(mod_path)
  local mod = utils.get_at_path(config.modules, mod_path)

  return M.is_module(mod) and mod or nil
end

-- Determines whether the provided table is a module.
-- A module should contain an attach and detach function.
---@param mod table|nil the module table
---@return boolean
function M.is_module(mod)
  return type(mod) == "table"
    and ((type(mod.attach) == "function" and type(mod.detach) == "function") or type(mod.module_path) == "string")
end

-- Initializes built-in modules and any queued modules
-- registered by plugins or the user.
function M.init()
  is_initialized = true
  M.define_modules(builtin_modules)

  for _, mod_def in ipairs(queued_modules_defs) do
    M.define_modules(mod_def)
  end
end

-- If parser_install_dir is not nil is used or created.
-- If parser_install_dir is nil try the package dir of the nvim-treesitter
-- plugin first, followed by the "site" dir from "runtimepath". "site" dir will
-- be created if it doesn't exist. Using only the package dir won't work when
-- the plugin is installed with Nix, since the "/nix/store" is read-only.
---@param folder_name string|nil
---@return string|nil, string|nil
function M.get_parser_install_dir(folder_name)
  folder_name = folder_name or "parser"

  local install_dir = config.parser_install_dir or utils.get_package_path()
  local parser_dir = utils.join_path(install_dir, folder_name)

  return utils.create_or_reuse_writable_dir(
    parser_dir,
    utils.join_space("Could not create parser dir '", parser_dir, "': "),
    utils.join_space(
      "Parser dir '",
      parser_dir,
      "' should be read/write (see README on how to configure an alternative install location)"
    )
  )
end

function M.get_parser_info_dir()
  return M.get_parser_install_dir "parser-info"
end

function M.get_ignored_parser_installs()
  return config.ignore_install or {}
end

function M.get_ensure_installed_parsers()
  if type(config.ensure_installed) == "string" then
    return { config.ensure_installed }
  end
  return config.ensure_installed or {}
end

return M
