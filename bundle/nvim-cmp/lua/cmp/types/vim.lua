---@class vim.CompletedItem
---@field public word string
---@field public abbr string|nil
---@field public kind string|nil
---@field public menu string|nil
---@field public equal "1"|nil
---@field public empty "1"|nil
---@field public dup "1"|nil
---@field public id any

---@class vim.Position
---@field public row number
---@field public col number

---@class vim.Range
---@field public start vim.Position
---@field public end vim.Position
