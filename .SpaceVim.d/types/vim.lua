---@meta

vim = {}

---@type uv
vim.loop = {}

vim.F = require("vim.F")
vim.diagnostic = require("vim.diagnostic")
vim.filetype = require("vim.filetype")
vim.fs = require("vim.fs")
vim.health = require("vim.health")
vim.highlight = require("vim.highlight")
vim.inspect = require("vim.inspect").inspect
vim.iter = require("vim.iter")
vim.keymap = require("vim.keymap")
vim.lsp = require("vim.lsp")
vim.secure = require("vim.secure")
vim.treesitter = require("vim.treesitter")
vim.treesitter.highlighter = require("vim.treesitter.highlighter")
vim.treesitter.language = require("vim.treesitter.language")
vim.treesitter.query = require("vim.treesitter.query")
vim.ui = require("vim.ui")
vim.uri_from_bufnr = require("vim.uri").uri_from_bufnr
vim.uri_from_fname = require("vim.uri").uri_from_fname
vim.uri_to_bufnr = require("vim.uri").uri_to_bufnr
vim.uri_to_fname = require("vim.uri").uri_to_fname
vim.version = require("vim.version")
vim.lpeg = require("lpeg")

---@type table<string,any>
vim.g = {}
---@type table<string,any>
vim.v = {}
---@type table<number,table<string, any>>
vim.b = {}
---@type table<number,table<string, any>>
vim.w = {}
---@type table<number,table<string, any>>
vim.t = {}
