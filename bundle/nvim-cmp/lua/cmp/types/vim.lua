---@class vim.CompletedItem
---@field public word string
---@field public abbr string|nil
---@field public kind string|nil
---@field public menu string|nil
---@field public equal 1|nil
---@field public empty 1|nil
---@field public dup 1|nil
---@field public id any
---@field public abbr_hl_group string|nil
---@field public kind_hl_group string|nil
---@field public menu_hl_group string|nil

---@class vim.Position 1-based index
---@field public row integer
---@field public col integer

---@class vim.Range
---@field public start vim.Position
---@field public end vim.Position
