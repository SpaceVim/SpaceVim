local fn = vim.fn
if fn.has('nvim') == 0 then return end

local api = vim.api

local Buffer = require('if_lua_compat.buffer')
local Window = require('if_lua_compat.window')
local List = require('if_lua_compat.list')
local Dict = require('if_lua_compat.dict')
local Blob = require('if_lua_compat.blob')
local misc = require('if_lua_compat.misc')

vim.command = api.nvim_command
vim.eval = api.nvim_eval
vim.line = api.nvim_get_current_line
vim.buffer = Buffer
vim.window = Window
vim.list = List
vim.dict = Dict
vim.blob = Blob
vim.open = misc.open
vim.type = misc.type
vim.beep = misc.beep
vim.funcref = misc.funcref
