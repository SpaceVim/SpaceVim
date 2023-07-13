local log = require("neo-tree.log")

Node = {}
function Node:new(value)
  local props = { prev = nil, next = nil, value = value }
  setmetatable(props, self)
  self.__index = self
  return props
end

LinkedList = {}
function LinkedList:new()
  local props = { head = nil, tail = nil, size = 0 }
  setmetatable(props, self)
  self.__index = self
  return props
end

function LinkedList:add_node(node)
  if self.head == nil then
    self.head = node
    self.tail = node
  else
    self.tail.next = node
    node.prev = self.tail
    self.tail = node
  end
  self.size = self.size + 1
  return node
end

function LinkedList:remove_node(node)
  if node.prev ~= nil then
    node.prev.next = node.next
  end
  if node.next ~= nil then
    node.next.prev = node.prev
  end
  if self.head == node then
    self.head = node.next
  end
  if self.tail == node then
    self.tail = node.prev
  end
  self.size = self.size - 1
  node.prev = nil
  node.next = nil
  node.value = nil
end

-- First in Last Out
Queue = {}
function Queue:new()
  local props = { _list = LinkedList:new() }
  setmetatable(props, self)
  self.__index = self
  return props
end

---Add an element to the end of the queue.
---@param value any The value to add.
function Queue:add(value)
  self._list:add_node(Node:new(value))
end

---Iterates over the entire list, running func(value) on each element.
---If func returns true, the element is removed from the list.
---@param func function The function to run on each element.
function Queue:for_each(func)
  local node = self._list.head
  while node ~= nil do
    local result = func(node.value)
    local node_is_next = false
    if result then
      if type(result) == "boolean" then
        local node_to_remove = node
        node = node.next
        node_is_next = true
        self._list:remove_node(node_to_remove)
      elseif type(result) == "table" then
        if type(result.handled) == "boolean" and result.handled == true then
          log.trace(
            "Handler ",
            node.value.id,
            " for "
              .. node.value.event
              .. " returned handled = true, skipping the rest of the queue."
          )
          return result
        end
      end
    end
    if not node_is_next then
      node = node.next
    end
  end
end

function Queue:is_empty()
  return self._list.size == 0
end

function Queue:remove_by_id(id)
  local current = self._list.head
  while current ~= nil do
    local is_match = false
    local item = current.value
    if item ~= nil then
      local item_id = item.id or item
      if item_id == id then
        is_match = true
      end
    end
    if is_match then
      local next = current.next
      self._list:remove_node(current)
      current = next
    else
      current = current.next
    end
  end
end

return {
  Queue = Queue,
  LinkedList = LinkedList,
}
