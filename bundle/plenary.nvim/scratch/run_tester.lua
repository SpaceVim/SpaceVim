
local lu = require("plenary.luaunit")
local test_harness = require("plenary.test_harness")

require("tests.plenary.path_spec")

-- lu.LuaUnit.run("./tests/plenary/path_spec.lua")
-- lu.LuaUnit.run({"TestPath"})

test_harness:run(0, 0, "TestPath")


[[
lua require("plenary.test_harness"):test_directory("luaunit", "./tests/plenary/lu/")
lua require("plenary.test_harness"):test_directory("busted", "./tests/plenary/bu/")
]]
