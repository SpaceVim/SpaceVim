local util = require("trouble.util")

local M = {}

local links = {
  TextError = "TroubleText",
  TextWarning = "TroubleText",
  TextInformation = "TroubleText",
  TextHint = "TroubleText",
  Text = "Normal",
  File = "Directory",
  Source = "Comment",
  Code = "Comment",
  Location = "LineNr",
  FoldIcon = "CursorLineNr",
  Normal = "Normal",
  Count = "TabLineSel",
  Preview = "Search",
  Indent = "LineNr",
  SignOther = "TroubleSignInformation",
}

function M.setup()
  for k, v in pairs(links) do
    vim.api.nvim_command("hi def link Trouble" .. k .. " " .. v)
  end

  for _, severity in pairs(util.severity) do
    vim.api.nvim_command("hi def link Trouble" .. severity .. " " .. util.get_severity_label(severity))
    vim.api.nvim_command("hi def link TroubleSign" .. severity .. " " .. util.get_severity_label(severity, "Sign"))
  end
end

return M
