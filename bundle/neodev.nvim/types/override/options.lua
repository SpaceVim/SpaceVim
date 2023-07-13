---@type table<number, vim.go>
vim.go = {}

---@type table<number, vim.bo>
vim.bo = {}

---@type table<number, vim.wo>
vim.wo = {}

---@type vim.go | vim.wo | vim.bo
vim.o = {}

---@class vim.opt
vim.opt = {}

---@type vim.opt
vim.opt_global = {}

---@type vim.opt
vim.opt_local = {}

---@class vim.Option
local Option = {}

function Option:append(right) end
function Option:prepend(right) end
function Option:remove(right) end
