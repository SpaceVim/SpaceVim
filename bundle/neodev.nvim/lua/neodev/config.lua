local M = {}

--- @class LuaDevOptions
M.defaults = {
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    ---@type boolean|string[]
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for .luarc.json files
  -- for your neovim config directory, the config.library settings will be used as is
  -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
  -- for any other directory, config.library.enabled will be set to false
  override = function(root_dir, options) end,
  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = true,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
  debug = false,
}

--- @type LuaDevOptions
M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

function M.types()
  return M.root("/types/" .. M.version())
end

---@param root? string
function M.root(root)
  local f = debug.getinfo(1, "S").source:sub(2)
  return vim.loop.fs_realpath(vim.fn.fnamemodify(f, ":h:h:h") .. "/" .. (root or ""))
end

---@return "nightly" | "stable"
function M.version()
  return vim.version().prerelease and "nightly" or "stable"
end

---@return LuaDevOptions
function M.merge(options)
  return vim.tbl_deep_extend("force", {}, M.options, options or {})
end

return M
