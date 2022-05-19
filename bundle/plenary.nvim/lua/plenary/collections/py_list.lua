---@brief [[
--- This module implements python-like lists. It can be used like so:
--- <pre>
---     local List = require 'plenary.collections.py_list'
---     local l = List{3, 20, 44}
---     print(l)  -- [3, 20, 44]
--- </pre>
---@brief ]]
local List = {}

---@class List @The base class for all list objects

---List constructor. Can be used in higher order functions
---@param  tbl table: A list-like table containing the initial elements of the list
---@return List: A new list object
function List.new(tbl)
  if type(tbl) == "table" then
    local len = #tbl
    local obj = setmetatable(tbl, List)
    obj._len = len
    return obj
  end
  error "List constructor must be called with table argument"
end

--- Checks whether the argument is a List object
--- @param tbl table: The object to test
--- @return boolean: Whether tbl is an instance of List
function List.is_list(tbl)
  local meta = getmetatable(tbl) or {}
  return meta == List
end

function List:__index(key)
  if self ~= List then
    local field = List[key]
    if field then
      return field
    end
  end
end

-- TODO: Similar to python, use [...] if the table references itself --
function List:__tostring()
  local elements = self:join ", "
  return "[" .. elements .. "]"
end

function List:__eq(other)
  if #self ~= #other then
    return false
  end
  for i = 1, #self do
    if self[i] ~= other[i] then
      return false
    end
  end
  return true
end

function List:__mul(other)
  local result = List.new {}
  for i = 1, other do
    result[i] = self
  end
  return result
end

function List:__len()
  return self._len
end

function List:__concat(other)
  return self:concat(other)
end

--- Pushes the element to the end of the list
--- @param other any: The object to append
--- @see List.pop
function List:push(other)
  self[#self + 1] = other
  self._len = self._len + 1
end

--- Pops the last element off the list and returns it
--- @return any: The (previously) last element from the list
--- @see List.push
function List:pop()
  local result = table.remove(self)
  self._len = self._len - 1
  return result
end

--- Inserts other into the specified idx
--- @param idx number: The index that other will be inserted to
--- @param other any: The element to insert
--- @see List.remove
function List:insert(idx, other)
  table.insert(self, idx, other)
  self._len = self._len + 1
end

--- Removes the element at index idx and returns it
--- @param idx number: The index of the element to remove
--- @return any: The element previously at index idx
--- @see List.insert
function List:remove(idx)
  self._len = self._len - 1
  return table.remove(self, idx)
end

--- Can be used to compare elements with any list-like table. It only checks for
--- shallow equality
--- @param other any: The element to test for
--- @return boolean: True if other is a list object and all it's elements are equal
--- @see List.deep_equal
function List:equal(other)
  return self:__eq(other)
end

--- Checks for deep equality between lists. This uses vim.deep_equal for testing
--- @param other any: The element to test for
--- @return boolean: True if all elements and their children are equal
--- @see List.equal
--- @see vim.deep_equal
function List:deep_equal(other)
  return vim.deep_equal(self, other)
end

--- Returns a copy of the list with elements between a and b, inclusive
--- <pre>
---     local list = List{1, 2, 3, 4}
---     local slice = list:slice(2, 3)
---     print(slice) -- [2, 3]
--- </pre>
--- @param a number: The low end of the slice
--- @param b number: The high end of the slice
--- @return List: A list with elements between a and b
function List:slice(a, b)
  return List.new(vim.list_slice(self, a, b))
end

--- Similar to slice, but with every element. It only makes a shallow copy
--- @return List: A slice from 1 to #self, i.e., a complete copy of the list
--- @see List.deep_copy
function List:copy()
  return self:slice(1, #self)
end

--- Similar to copy, but makes a deep copy instead
--- @return List: A deep copy of the object
--- @see List.copy
--- @see vim.deep_copy
function List:deep_copy()
  return vim.deep_copy(self)
end

--- Reverses the list in place. If you don't want this, you could do something
--- like this
--- <pre>
---     local list = List{1, 2, 3, 4}
---     local reversed = list:copy():reverse()
--- </pre>
--- @return List: The list itself, so you can chain method calls
--- @see List.copy
--- @see List.deep_copy
function List:reverse()
  local n = #self
  local i = 1
  while i < n do
    self[i], self[n] = self[n], self[i]
    i = i + 1
    n = n - 1
  end
  return self
end

--- Concatenates the elements whithin the list separated by the given string
--- <pre>
---     local list = List{1, 2, 3, 4}
---     print(list:join('-'))  -- 1-2-3-4
--- </pre>
--- @param sep string: The separator to place between the elements. Default ''
--- @return string: The elements in the list separated by sep
function List:join(sep)
  sep = sep or ""
  local result = ""
  for i, v in self:iter() do
    result = result .. tostring(v)
    if i ~= #self then
      result = result .. sep
    end
  end
  return result
end

--- Returns a list with the elements of self concatenated with those in the
--- given arguments
--- @vararg table|List: The sequences to concatenate to this one
--- @return List
function List:concat(...)
  local result = self:copy()
  local others = { ... }
  for _, other in ipairs(others) do
    for _, v in ipairs(other) do
      result:push(v)
    end
  end
  return result
end

--- Moves the elements between from and from+len in self, to positions between
--- to and to+len in other, like so
--- <pre>
---     other[to], other[to+1]... other[to+len] = self[from], self[from+1]... self[from+len]
--- </pre>
--- @param from number: The first index of the origin slice
--- @param len number: The length of the slices
--- @param to number: The first index of the destination slice
--- @param other table|List: The destination list. Defaults to self
--- @see table.move
function List:move(from, len, to, other)
  return table.move(self, from, len, to, other)
end

--- Packs the given elements into a list. Similar to lua 5.3's table.pack
--- @vararg any: The elements to pack
--- @return List: a list containing all the given elements
--- @see table.pack
function List.pack(...)
  return List.new { ... }
end

--- Unpacks the elements from this list and returns them
--- @return ...any: All the elements from self[1] to self[#self]
function List:unpack()
  return unpack(self, 1, #self)
end

-- Iterator stuff

local Iter = require "plenary.iterators"

local itermetatable = getmetatable(Iter:wrap())

local function forward_list_gen(param, state)
  state = state + 1
  local v = param[state]
  if v ~= nil then
    return state, v
  end
end

local function backward_list_gen(param, state)
  state = state - 1
  local v = param[state]
  if v ~= nil then
    return state, v
  end
end

--- Run the given predicate through all the elements pointed by this iterator,
--- and classify them into two lists. The first one holds the elements for which
--- predicate returned a truthy value, and the second holds the rest. For
--- example:
---
--- <pre>
---     local list = List{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
---     local evens, odds = list:iter():partition(function(e)
---         return e % 2 == 0
---     end)
---     print(evens, odds)
--- </pre>
---
--- Would print
---
--- <pre>
---     [0, 2, 4, 6, 8] [1, 3, 5, 7, 9]
--- </pre>
---@param predicate function: The predicate to classify the elements
---@return List,List
local function partition(self, predicate)
  local list1, list2 = List.new {}, List.new {}
  for _, v in self do
    if predicate(v) then
      list1:push(v)
    else
      list2:push(v)
    end
  end
  return list1, list2
end

local function wrap_iter(f, l, n)
  local iter = Iter.wrap(f, l, n)
  iter.partition = partition
  return iter
end

--- Counts the occurrences of e inside the list
--- @param e any: The element to test for
--- @return number: The number of occurrences of e
function List:count(e)
  local count = 0
  for _, v in self:iter() do
    if e == v then
      count = count + 1
    end
  end
  return count
end

--- Appends the elements in the given iterator to the list
--- @param other table: An iterator object
function List:extend(other)
  if type(other) == "table" and getmetatable(other) == itermetatable then
    for _, v in other do
      self:push(v)
    end
  else
    error "Argument must be an iterator"
  end
end

--- Checks whether there is an occurence of the given element in the list
--- @param e any: The object to test for
--- @return boolean: True if e is present
function List:contains(e)
  for _, v in self:iter() do
    if v == e then
      return true
    end
  end
  return false
end

--- Creates an iterator for the list. For example:
--- <pre>
---     local list = List{8, 4, 7, 9}
---     for i, v in list:iter() do
---         print(i, v)
---     end
--- </pre>
--- Would print:
--- <pre>
---     1    8
---     2    4
---     3    7
---     4    9
--- </pre>
--- @return table: An iterator object
function List:iter()
  return wrap_iter(forward_list_gen, self, 0)
end

--- Creates a reverse iterator for the list. For example:
--- <pre>
---     local list = List{8, 4, 7, 9}
---     for i, v in list:riter() do
---         print(i, v)
---     end
--- </pre>
--- Would print:
--- <pre>
---     4    9
---     3    7
---     2    4
---     1    8
--- </pre>
--- @return table: An iterator object
function List:riter()
  return wrap_iter(backward_list_gen, self, #self + 1)
end

-- Miscellaneous

--- Create a list from the elements pointed at by the given iterator.
--- @param iter table: An iterator object
--- @return List
function List.from_iter(iter)
  local result = List.new {}
  for _, v in iter do
    result:push(v)
  end
  return result
end

return setmetatable({}, {
  __call = function(_, tbl)
    return List.new(tbl)
  end,
  __index = List,
})
