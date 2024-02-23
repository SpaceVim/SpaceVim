local log = require "telescope.log"

local LinkedList = require "telescope.algos.linked_list"

local EntryManager = {}
EntryManager.__index = EntryManager

function EntryManager:new(max_results, set_entry, info)
  log.trace "Creating entry_manager..."

  info = info or {}
  info.looped = 0
  info.inserted = 0
  info.find_loop = 0

  -- state contains list of
  --    { entry, score }
  --    Stored directly in a table, accessed as [1], [2]
  set_entry = set_entry or function() end

  return setmetatable({
    linked_states = LinkedList:new { track_at = max_results },
    info = info,
    max_results = max_results,
    set_entry = set_entry,
    worst_acceptable_score = math.huge,
  }, self)
end

function EntryManager:num_results()
  return self.linked_states.size
end

function EntryManager:get_container(index)
  local count = 0
  for val in self.linked_states:iter() do
    count = count + 1

    if count == index then
      return val
    end
  end

  return {}
end

function EntryManager:get_entry(index)
  return self:get_container(index)[1]
end

function EntryManager:get_score(index)
  return self:get_container(index)[2]
end

function EntryManager:get_ordinal(index)
  return self:get_entry(index).ordinal
end

function EntryManager:find_entry(entry)
  local info = self.info

  local count = 0
  for container in self.linked_states:iter() do
    count = count + 1

    if container[1] == entry then
      info.find_loop = info.find_loop + count

      return count
    end
  end

  info.find_loop = info.find_loop + count
  return nil
end

function EntryManager:_update_score_from_tracked()
  local linked = self.linked_states

  if linked.tracked then
    self.worst_acceptable_score = math.min(self.worst_acceptable_score, linked.tracked[2])
  end
end

function EntryManager:_insert_container_before(picker, index, linked_node, new_container)
  self.linked_states:place_before(index, linked_node, new_container)
  self.set_entry(picker, index, new_container[1], new_container[2], true)

  self:_update_score_from_tracked()
end

function EntryManager:_insert_container_after(picker, index, linked_node, new_container)
  self.linked_states:place_after(index, linked_node, new_container)
  self.set_entry(picker, index, new_container[1], new_container[2], true)

  self:_update_score_from_tracked()
end

function EntryManager:_append_container(picker, new_container, should_update)
  self.linked_states:append(new_container)
  self.worst_acceptable_score = math.min(self.worst_acceptable_score, new_container[2])

  if should_update then
    self.set_entry(picker, self.linked_states.size, new_container[1], new_container[2])
  end
end

function EntryManager:add_entry(picker, score, entry, prompt)
  score = score or 0

  local max_res = self.max_results
  local worst_score = self.worst_acceptable_score
  local size = self.linked_states.size

  local info = self.info
  info.maxed = info.maxed or 0

  local new_container = { entry, score }

  -- Short circuit for bad scores -- they never need to be displayed.
  --    Just save them and we'll deal with them later.
  if score >= worst_score then
    return self.linked_states:append(new_container)
  end

  -- Short circuit for first entry.
  if size == 0 then
    self.linked_states:prepend(new_container)
    self.set_entry(picker, 1, entry, score)
    return
  end

  for index, container, node in self.linked_states:ipairs() do
    info.looped = info.looped + 1

    if container[2] > score then
      return self:_insert_container_before(picker, index, node, new_container)
    end

    if score < 1 and container[2] == score and picker.tiebreak(entry, container[1], prompt) then
      return self:_insert_container_before(picker, index, node, new_container)
    end

    -- Don't add results that are too bad.
    if index >= max_res then
      info.maxed = info.maxed + 1
      return self:_append_container(picker, new_container, false)
    end
  end

  if self.linked_states.size >= max_res then
    self.worst_acceptable_score = math.min(self.worst_acceptable_score, score)
  end

  return self:_insert_container_after(picker, size + 1, self.linked_states.tail, new_container)
end

function EntryManager:iter()
  local iterator = self.linked_states:iter()
  return function()
    local val = iterator()
    if val then
      return val[1]
    end
  end
end

return EntryManager
