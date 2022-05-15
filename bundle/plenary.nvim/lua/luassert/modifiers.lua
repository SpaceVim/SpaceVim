-- module will not return anything, only register assertions/modifiers with the main assert engine
local assert = require('luassert.assert')

local function is(state)
  return state
end

local function is_not(state)
  state.mod = not state.mod
  return state
end

assert:register("modifier", "is", is)
assert:register("modifier", "are", is)
assert:register("modifier", "was", is)
assert:register("modifier", "has", is)
assert:register("modifier", "does", is)
assert:register("modifier", "not", is_not)
assert:register("modifier", "no", is_not)
