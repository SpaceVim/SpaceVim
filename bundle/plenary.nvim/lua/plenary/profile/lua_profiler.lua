--[[ Copyright (c) 2018-2020, Charles Mallah ]]
-- Released with MIT License
--
-- Originally link:
--  https://github.com/charlesmallah/lua-profiler
--
-- Hopefully will add some better neovim stuff in the future.
-- Shoutout to @clason for finding this.


---------------------------------------|
--- Configuration
--
---------------------------------------|

local PROFILER_FILENAME = "lua/telescope/profile/lua_profiler.lua" -- Location and name of profiler (to remove itself from reports);
-- e.g. if this is in a 'tool' folder, rename this as: "tool/profiler.lua"

local EMPTY_TIME = "0.0000" -- Detect empty time, replace with tag below
local emptyToThis = "~"

local fileWidth = 75
local funcWidth = 22
local lineWidth = 6
local timeWidth = 7
local relaWidth = 6
local callWidth = 4

local reportSaved = " > Report saved to"
local formatOutputHeader = "| %-"..fileWidth.."s: %-"..funcWidth.."s: %-"..lineWidth.."s: %-"..timeWidth.."s: %-"..relaWidth.."s: %-"..callWidth.."s|\n"
local formatOutputTitle = "%-"..fileWidth.."."..fileWidth.."s: %-"..funcWidth.."."..funcWidth.."s: %-"..lineWidth.."s" -- File / Function / Line count
local formatOutput = "| %s: %-"..timeWidth.."s: %-"..relaWidth.."s: %-"..callWidth.."s|\n" -- Time / Relative / Called
local formatTotalTime = "TOTAL TIME   = %f s\n"
local formatFunLine = "%"..(lineWidth - 2).."i"
local formatFunTime = "%04.4f"
local formatFunRelative = "%03.1f"
local formatFunCount = "%"..(callWidth - 1).."i"
local formatHeader = string.format(formatOutputHeader, "FILE", "FUNCTION", "LINE", "TIME", "%", "#")


---------------------------------------|
--- Locals
--
---------------------------------------|

local module = {}

local getTime = os.clock
local string = string
local debug = debug
local table = table

local TABL_REPORT_CACHE = {}
local TABL_REPORTS = {}
local reportCount = 0
local startTime = 0
local stopTime = 0

local printFun = nil
local verbosePrint = false

local function functionReport(information)
  local src = information.short_src
  if src == nil then
    src = "<C>"
  elseif string.sub(src, #src - 3, #src) == ".lua" then
    src = string.sub(src, 1, #src - 4)
  end

  local name = information.name
  if name == nil then
    name = "Anon"
  elseif string.sub(name, #name - 1, #name) == "_l" then
    name = string.sub(name, 1, #name - 2)
  end

  local title = string.format(formatOutputTitle,
    src, name,
  string.format(formatFunLine, information.linedefined or 0))

  local funcReport = TABL_REPORT_CACHE[title]
  if not funcReport then
    funcReport = {
      title = string.format(formatOutputTitle,
        src, name,
      string.format(formatFunLine, information.linedefined or 0)),
      count = 0,
      timer = 0,
    }
    TABL_REPORT_CACHE[title] = funcReport
    reportCount = reportCount + 1
    TABL_REPORTS[reportCount] = funcReport
  end

  return funcReport
end

local onDebugHook = function(hookType)
  local information = debug.getinfo(2, "nS")
  if hookType == "call" then
    local funcReport = functionReport(information)
    funcReport.callTime = getTime()
    funcReport.count = funcReport.count + 1
  elseif hookType == "return" then
    local funcReport = functionReport(information)
    if funcReport.callTime and funcReport.count > 0 then
      funcReport.timer = funcReport.timer + (getTime() - funcReport.callTime)
    end
  end
end

local function charRepetition(n, character)
  local s = ""
  character = character or " "
  for _ = 1, n do
    s = s..character
  end
  return s
end

local function singleSearchReturn(str, search)
  for _ in string.gmatch(str, search) do
    do return true end
  end
  return false
end

local divider = charRepetition(#formatHeader - 1, "-").."\n"


---------------------------------------|
--- Functions
--
---------------------------------------|

--- Attach a print function to the profiler, to receive a single string parameter
--
function module.attachPrintFunction(fn, verbose)
  printFun = fn
  if verbose ~= nil then
    verbosePrint = verbose
  end
end

---
--
function module.start()
  TABL_REPORT_CACHE = {}
  TABL_REPORTS = {}
  reportCount = 0
  startTime = getTime()
  stopTime = nil
  debug.sethook(onDebugHook, "cr", 0)
end

---
--
function module.stop()
  stopTime = getTime()
  debug.sethook()
end

--- Writes the profile report to file
--
function module.report(filename)
  if stopTime == nil then
    module.stop()
  end

  if reportCount > 0 then
    filename = filename or "profiler.log"
    table.sort(TABL_REPORTS, function(a, b) return a.timer > b.timer end)
    local file = io.open(filename, "w+")

    if reportCount > 0 then
      local divide = false
      local totalTime = stopTime - startTime
      local totalTimeOutput = " > "..string.format(formatTotalTime, totalTime)

      file:write(totalTimeOutput)
      if printFun ~= nil then
        printFun(totalTimeOutput)
      end

      file:write("\n"..divider)
      file:write(formatHeader)
      file:write(divider)

      for i = 1, reportCount do
        local funcReport = TABL_REPORTS[i]

        if funcReport.count > 0 and funcReport.timer <= totalTime then
          local printThis = true

          if PROFILER_FILENAME ~= "" then
            if singleSearchReturn(funcReport.title, PROFILER_FILENAME) then
              printThis = false
            end
          end

          -- Remove line if not needed
          if printThis == true then
            if singleSearchReturn(funcReport.title, "[[C]]") then
              printThis = false
            end
          end

          if printThis == true then
            local count = string.format(formatFunCount, funcReport.count)
            local timer = string.format(formatFunTime, funcReport.timer)
            local relTime = string.format(formatFunRelative, (funcReport.timer / totalTime) * 100)
            if divide == false and timer == EMPTY_TIME then
              file:write(divider)
              divide = true
            end

            -- Replace
            if timer == EMPTY_TIME then
              timer = emptyToThis
              relTime = emptyToThis
            end

            -- Build final line
            local outputLine = string.format(formatOutput, funcReport.title, timer, relTime, count)
            file:write(outputLine)

            -- This is a verbose print to the printFun, however maybe make this smaller for on screen debug?
            if printFun ~= nil and verbosePrint == true then
              printFun(outputLine)
            end

          end
        end
      end

      file:write(divider)

    end

    file:close()

    if printFun ~= nil then
      printFun(reportSaved.."'"..filename.."'")
    end

  end

end

--- End
--
return module
