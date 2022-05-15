local util = {}
function util.deepcompare(t1,t2,ignore_mt,cycles,thresh1,thresh2)
  local ty1 = type(t1)
  local ty2 = type(t2)
  -- non-table types can be directly compared
  if ty1 ~= 'table' or ty2 ~= 'table' then return t1 == t2 end
  local mt1 = debug.getmetatable(t1)
  local mt2 = debug.getmetatable(t2)
  -- would equality be determined by metatable __eq?
  if mt1 and mt1 == mt2 and mt1.__eq then
    -- then use that unless asked not to
    if not ignore_mt then return t1 == t2 end
  else -- we can skip the deep comparison below if t1 and t2 share identity
    if rawequal(t1, t2) then return true end
  end

  -- handle recursive tables
  cycles = cycles or {{},{}}
  thresh1, thresh2 = (thresh1 or 1), (thresh2 or 1)
  cycles[1][t1] = (cycles[1][t1] or 0)
  cycles[2][t2] = (cycles[2][t2] or 0)
  if cycles[1][t1] == 1 or cycles[2][t2] == 1 then
    thresh1 = cycles[1][t1] + 1
    thresh2 = cycles[2][t2] + 1
  end
  if cycles[1][t1] > thresh1 and cycles[2][t2] > thresh2 then
    return true
  end

  cycles[1][t1] = cycles[1][t1] + 1
  cycles[2][t2] = cycles[2][t2] + 1

  for k1,v1 in next, t1 do
    local v2 = t2[k1]
    if v2 == nil then
      return false, {k1}
    end

    local same, crumbs = util.deepcompare(v1,v2,nil,cycles,thresh1,thresh2)
    if not same then
      crumbs = crumbs or {}
      table.insert(crumbs, k1)
      return false, crumbs
    end
  end
  for k2,_ in next, t2 do
    -- only check whether each element has a t1 counterpart, actual comparison
    -- has been done in first loop above
    if t1[k2] == nil then return false, {k2} end
  end

  cycles[1][t1] = cycles[1][t1] - 1
  cycles[2][t2] = cycles[2][t2] - 1

  return true
end

function util.shallowcopy(t)
  if type(t) ~= "table" then return t end
  local copy = {}
  for k,v in next, t do
    copy[k] = v
  end
  return copy
end

function util.deepcopy(t, deepmt, cache)
  local spy = require 'luassert.spy'
  if type(t) ~= "table" then return t end
  local copy = {}

  -- handle recursive tables
  local cache = cache or {}
  if cache[t] then return cache[t] end
  cache[t] = copy

  for k,v in next, t do
    copy[k] = (spy.is_spy(v) and v or util.deepcopy(v, deepmt, cache))
  end
  if deepmt then
    debug.setmetatable(copy, util.deepcopy(debug.getmetatable(t, nil, cache)))
  else
    debug.setmetatable(copy, debug.getmetatable(t))
  end
  return copy
end

-----------------------------------------------
-- Copies arguments as a list of arguments
-- @param args the arguments of which to copy
-- @return the copy of the arguments
function util.copyargs(args)
  local copy = {}
  local match = require 'luassert.match'
  local spy = require 'luassert.spy'
  for k,v in pairs(args) do
    copy[k] = ((match.is_matcher(v) or spy.is_spy(v)) and v or util.deepcopy(v))
  end
  return { vals = copy, refs = util.shallowcopy(args) }
end

-----------------------------------------------
-- Finds matching arguments in a saved list of arguments
-- @param argslist list of arguments from which to search
-- @param args the arguments of which to find a match
-- @return the matching arguments if a match is found, otherwise nil
function util.matchargs(argslist, args)
  local function matches(t1, t2, t1refs)
    local match = require 'luassert.match'
    for k1,v1 in pairs(t1) do
      local v2 = t2[k1]
      if match.is_matcher(v1) then
        if not v1(v2) then return false end
      elseif match.is_matcher(v2) then
        if match.is_ref_matcher(v2) then v1 = t1refs[k1] end
        if not v2(v1) then return false end
      elseif (v2 == nil or not util.deepcompare(v1,v2)) then
        return false
      end
    end
    for k2,v2 in pairs(t2) do
      -- only check wether each element has a t1 counterpart, actual comparison
      -- has been done in first loop above
      local v1 = t1[k2]
      if v1 == nil then
        -- no t1 counterpart, so try to compare using matcher
        if match.is_matcher(v2) then
          if not v2(v1) then return false end
        else
          return false
        end
      end
    end
    return true
  end
  for k,v in ipairs(argslist) do
    if matches(v.vals, args, v.refs) then
      return v
    end
  end
  return nil
end

-----------------------------------------------
-- table.insert() replacement that respects nil values.
-- The function will use table field 'n' as indicator of the
-- table length, if not set, it will be added.
-- @param t table into which to insert
-- @param pos (optional) position in table where to insert. NOTE: not optional if you want to insert a nil-value!
-- @param val value to insert
-- @return No return values
function util.tinsert(...)
  -- check optional POS value
  local args = {...}
  local c = select('#',...)
  local t = args[1]
  local pos = args[2]
  local val = args[3]
  if c < 3 then
    val = pos
    pos = nil
  end
  -- set length indicator n if not present (+1)
  t.n = (t.n or #t) + 1
  if not pos then
    pos = t.n
  elseif pos > t.n then
    -- out of our range
    t[pos] = val
    t.n = pos
  end
  -- shift everything up 1 pos
  for i = t.n, pos + 1, -1 do
    t[i]=t[i-1]
  end
  -- add element to be inserted
  t[pos] = val
end
-----------------------------------------------
-- table.remove() replacement that respects nil values.
-- The function will use table field 'n' as indicator of the
-- table length, if not set, it will be added.
-- @param t table from which to remove
-- @param pos (optional) position in table to remove
-- @return No return values
function util.tremove(t, pos)
  -- set length indicator n if not present (+1)
  t.n = t.n or #t
  if not pos then
    pos = t.n
  elseif pos > t.n then
    local removed = t[pos]
    -- out of our range
    t[pos] = nil
    return removed
  end
  local removed = t[pos]
  -- shift everything up 1 pos
  for i = pos, t.n do
    t[i]=t[i+1]
  end
  -- set size, clean last
  t[t.n] = nil
  t.n = t.n - 1
  return removed
end

-----------------------------------------------
-- Checks an element to be callable.
-- The type must either be a function or have a metatable
-- containing an '__call' function.
-- @param object element to inspect on being callable or not
-- @return boolean, true if the object is callable
function util.callable(object)
  return type(object) == "function" or type((debug.getmetatable(object) or {}).__call) == "function"
end
-----------------------------------------------
-- Checks an element has tostring.
-- The type must either be a string or have a metatable
-- containing an '__tostring' function.
-- @param object element to inspect on having tostring or not
-- @return boolean, true if the object has tostring
function util.hastostring(object)
  return type(object) == "string" or type((debug.getmetatable(object) or {}).__tostring) == "function"
end

-----------------------------------------------
-- Find the first level, not defined in the same file as the caller's
-- code file to properly report an error.
-- @param level the level to use as the caller's source file
-- @return number, the level of which to report an error
function util.errorlevel(level)
  local level = (level or 1) + 1 -- add one to get level of the caller
  local info = debug.getinfo(level)
  local source = (info or {}).source
  local file = source
  while file and (file == source or source == "=(tail call)") do
    level = level + 1
    info = debug.getinfo(level)
    source = (info or {}).source
  end
  if level > 1 then level = level - 1 end -- deduct call to errorlevel() itself
  return level
end

-----------------------------------------------
-- Extract modifier and namespace keys from list of tokens.
-- @param nspace the namespace from which to match tokens
-- @param tokens list of tokens to search for keys
-- @return table, list of keys that were extracted
function util.extract_keys(nspace, tokens)
  local namespace = require 'luassert.namespaces'

  -- find valid keys by coalescing tokens as needed, starting from the end
  local keys = {}
  local key = nil
  local i = #tokens
  while i > 0 do
    local token = tokens[i]
    key = key and (token .. '_' .. key) or token

    -- find longest matching key in the given namespace
    local longkey = i > 1 and (tokens[i-1] .. '_' .. key) or nil
    while i > 1 and longkey and namespace[nspace][longkey] do
      key = longkey
      i = i - 1
      token = tokens[i]
      longkey = (token .. '_' .. key)
    end

    if namespace.modifier[key] or namespace[nspace][key] then
      table.insert(keys, 1, key)
      key = nil
    end
    i = i - 1
  end

  -- if there's anything left we didn't recognize it
  if key then
    error("luassert: unknown modifier/" .. nspace .. ": '" .. key .."'", util.errorlevel(2))
  end

  return keys
end

return util
