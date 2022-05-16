local scandir = require "plenary.scandir"
local Path = require "plenary.path"

local eq = assert.are.same

describe("plenary.popup", function()
  local allowed_imports = {
    ["plenary.window"] = true,
    ["plenary.window.border"] = true,
  }

  local matches_any_import = function(line)
    local matched = string.match(line, [[require."(.*)"]])
    if matched and not vim.startswith(matched, "plenary.popup") then
      if not allowed_imports[matched] then
        return true, string.format("Not an allowed import for popup: %s. Line: %s", matched, line)
      end
    end

    return false, nil
  end

  -- Tests to make sure that we're matching both types of requires
  it("should match these kinds of patterns", function()
    eq(true, matches_any_import [[local x = require "plenary.other"]])
    eq(true, matches_any_import [[local x = require("plenary.module").something]])
  end)

  it("must not require anything other than Window and Border from plenary", function()
    local result = scandir.scan_dir("./lua/plenary/popup", { depth = 1 })

    for _, file in ipairs(result) do
      local popup_file = Path:new(file)
      local lines = popup_file:readlines()

      for _, line in ipairs(lines) do
        local matches, msg = matches_any_import(line)
        eq(false, matches, msg)
      end
    end
  end)
end)
