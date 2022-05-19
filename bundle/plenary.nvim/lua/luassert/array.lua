local assert = require('luassert.assert')
local say = require('say')

-- Example usage:
-- local arr = { "one", "two", "three" }
--
-- assert.array(arr).has.no.holes()   -- checks the array to not contain holes --> passes
-- assert.array(arr).has.no.holes(4)  -- sets explicit length to 4 --> fails
--
-- local first_hole = assert.array(arr).has.holes(4)     -- check array of size 4 to contain holes --> passes
-- assert.equal(4, first_hole)        -- passes, as the index of the first hole is returned


-- Unique key to store the object we operate on in the state object
-- key must be unique, to make sure we do not have name collissions in the shared state object
local ARRAY_STATE_KEY = "__array_state"

-- The modifier, to store the object in our state
local function array(state, args, level)
  assert(args.n > 0, "No array provided to the array-modifier")
  assert(rawget(state, ARRAY_STATE_KEY) == nil, "Array already set")
  rawset(state, ARRAY_STATE_KEY, args[1])
  return state
end

-- The actual assertion that operates on our object, stored via the modifier
local function holes(state, args, level)
  local length = args[1]
  local arr = rawget(state, ARRAY_STATE_KEY) -- retrieve previously set object
  -- only check against nil, metatable types are allowed
  assert(arr ~= nil, "No array set, please use the array modifier to set the array to validate")
  if length == nil then
    length = 0
    for i in pairs(arr) do
      if type(i) == "number" and
         i > length and
         math.floor(i) == i then
        length = i
      end
    end
  end
  assert(type(length) == "number", "expected array length to be of type 'number', got: "..tostring(length))
  -- let's do the actual assertion
  local missing
  for i = 1, length do
    if arr[i] == nil then
      missing = i
      break
    end
  end
  -- format arguments for output strings;
  args[1] = missing
  args.n = missing and 1 or 0
  return missing ~= nil, { missing } -- assert result + first missing index as return value
end

-- Register the proper assertion messages
say:set("assertion.array_holes.positive", [[
Expected array to have holes, but none was found.
]])
say:set("assertion.array_holes.negative", [[
Expected array to not have holes, hole found at position: %s
]])

-- Register the assertion, and the modifier
assert:register("assertion", "holes", holes,
                  "assertion.array_holes.positive",
                  "assertion.array_holes.negative")

assert:register("modifier", "array", array)
