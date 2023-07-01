---@class Text
---@field lines string[]
---@field hl Highlight[]
---@field lineNr number
---@field current string
local Text = {}
Text.__index = Text

function Text:new()
  local this = { lines = {}, hl = {}, lineNr = 0, current = "" }
  setmetatable(this, self)
  return this
end

function Text:nl()
  table.insert(self.lines, self.current)
  self.current = ""
  self.lineNr = self.lineNr + 1
end

function Text:render(str, group, opts)
  str = str:gsub("[\n]", " ")
  if type(opts) == "string" then
    opts = { append = opts }
  end
  opts = opts or {}

  if group then
    if opts.exact ~= true then
      group = "Trouble" .. group
    end
    local from = string.len(self.current)
    ---@class Highlight
    local hl
    hl = {
      line = self.lineNr,
      from = from,
      to = from + string.len(str),
      group = group,
    }
    table.insert(self.hl, hl)
  end
  self.current = self.current .. str
  if opts.append then
    self.current = self.current .. opts.append
  end
  if opts.nl then
    self:nl()
  end
end

return Text
