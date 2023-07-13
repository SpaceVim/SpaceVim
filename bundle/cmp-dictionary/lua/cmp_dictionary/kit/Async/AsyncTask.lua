---@diagnostic disable: invisible
local uv = require('luv')
local kit = require('cmp_dictionary.kit')

local is_thread = vim.is_thread()

---@class cmp_dictionary.kit.Async.AsyncTask
---@field private value any
---@field private status cmp_dictionary.kit.Async.AsyncTask.Status
---@field private synced boolean
---@field private chained boolean
---@field private children (fun(): any)[]
local AsyncTask = {}
AsyncTask.__index = AsyncTask

---Settle the specified task.
---@param task cmp_dictionary.kit.Async.AsyncTask
---@param status cmp_dictionary.kit.Async.AsyncTask.Status
---@param value any
local function settle(task, status, value)
  task.status = status
  task.value = value
  for _, c in ipairs(task.children) do
    c()
  end

  if status == AsyncTask.Status.Rejected then
    if not task.chained and not task.synced then
      local timer = uv.new_timer()
      timer:start(
        0,
        0,
        kit.safe_schedule_wrap(function()
          timer:stop()
          timer:close()
          if not task.chained and not task.synced then
            AsyncTask.on_unhandled_rejection(value)
          end
        end)
      )
    end
  end
end

---@enum cmp_dictionary.kit.Async.AsyncTask.Status
AsyncTask.Status = {
  Pending = 0,
  Fulfilled = 1,
  Rejected = 2,
}

---Handle unhandled rejection.
---@param err any
function AsyncTask.on_unhandled_rejection(err)
  error('AsyncTask.on_unhandled_rejection: ' .. tostring(err))
end

---Return the value is AsyncTask or not.
---@param value any
---@return boolean
function AsyncTask.is(value)
  return getmetatable(value) == AsyncTask
end

---Resolve all tasks.
---@param tasks any[]
---@return cmp_dictionary.kit.Async.AsyncTask
function AsyncTask.all(tasks)
  return AsyncTask.new(function(resolve, reject)
    local values = {}
    local count = 0
    for i, task in ipairs(tasks) do
      task:dispatch(function(value)
        values[i] = value
        count = count + 1
        if #tasks == count then
          resolve(values)
        end
      end, reject)
    end
  end)
end

---Resolve first resolved task.
---@param tasks any[]
---@return cmp_dictionary.kit.Async.AsyncTask
function AsyncTask.race(tasks)
  return AsyncTask.new(function(resolve, reject)
    for _, task in ipairs(tasks) do
      task:dispatch(resolve, reject)
    end
  end)
end

---Create resolved AsyncTask.
---@param v any
---@return cmp_dictionary.kit.Async.AsyncTask
function AsyncTask.resolve(v)
  if AsyncTask.is(v) then
    return v
  end
  return AsyncTask.new(function(resolve)
    resolve(v)
  end)
end

---Create new AsyncTask.
---@NOET: The AsyncTask has similar interface to JavaScript Promise but the AsyncTask can be worked as synchronous.
---@param v any
---@return cmp_dictionary.kit.Async.AsyncTask
function AsyncTask.reject(v)
  if AsyncTask.is(v) then
    return v
  end
  return AsyncTask.new(function(_, reject)
    reject(v)
  end)
end

---Create new async task object.
---@param runner fun(resolve?: fun(value: any?), reject?: fun(err: any?))
function AsyncTask.new(runner)
  local self = setmetatable({}, AsyncTask)

  self.value = nil
  self.status = AsyncTask.Status.Pending
  self.synced = false
  self.chained = false
  self.children = {}
  local ok, err = pcall(runner, function(res)
    if self.status == AsyncTask.Status.Pending then
      settle(self, AsyncTask.Status.Fulfilled, res)
    end
  end, function(err)
    if self.status == AsyncTask.Status.Pending then
      settle(self, AsyncTask.Status.Rejected, err)
    end
  end)
  if not ok then
    settle(self, AsyncTask.Status.Rejected, err)
  end
  return self
end

---Sync async task.
---@NOTE: This method uses `vim.wait` so that this can't wait the typeahead to be empty.
---@param timeout? number
---@return any
function AsyncTask:sync(timeout)
  self.synced = true

  if is_thread then
    while true do
      if self.status ~= AsyncTask.Status.Pending then
        break
      end
      uv.run('once')
    end
  else
    vim.wait(timeout or 24 * 60 * 60 * 1000, function()
      return self.status ~= AsyncTask.Status.Pending
    end, 1, false)
  end
  if self.status == AsyncTask.Status.Rejected then
    error(self.value, 2)
  end
  if self.status ~= AsyncTask.Status.Fulfilled then
    error('AsyncTask:sync is timeout.', 2)
  end
  return self.value
end

---Await async task.
---@param schedule? boolean
---@return any
function AsyncTask:await(schedule)
  local Async = require('cmp_dictionary.kit.Async')
  local ok, res = pcall(Async.await, self)
  if not ok then
    error(res, 2)
  end
  if schedule then
    Async.await(Async.schedule())
  end
  return res
end

---Return current state of task.
---@return { status: cmp_dictionary.kit.Async.AsyncTask.Status, value: any }
function AsyncTask:state()
  return {
    status = self.status,
    value = self.value,
  }
end

---Register next step.
---@param on_fulfilled fun(value: any): any
function AsyncTask:next(on_fulfilled)
  return self:dispatch(on_fulfilled, function(err)
    error(err, 2)
  end)
end

---Register catch step.
---@param on_rejected fun(value: any): any
---@return cmp_dictionary.kit.Async.AsyncTask
function AsyncTask:catch(on_rejected)
  return self:dispatch(function(value)
    return value
  end, on_rejected)
end

---Dispatch task state.
---@param on_fulfilled fun(value: any): any
---@param on_rejected fun(err: any): any
---@return cmp_dictionary.kit.Async.AsyncTask
function AsyncTask:dispatch(on_fulfilled, on_rejected)
  self.chained = true

  local function dispatch(resolve, reject)
    local on_next = self.status == AsyncTask.Status.Fulfilled and on_fulfilled or on_rejected
    local res = on_next(self.value)
    if AsyncTask.is(res) then
      res:dispatch(resolve, reject)
    else
      resolve(res)
    end
  end

  if self.status == AsyncTask.Status.Pending then
    return AsyncTask.new(function(resolve, reject)
      table.insert(self.children, function()
        dispatch(resolve, reject)
      end)
    end)
  end
  return AsyncTask.new(dispatch)
end

return AsyncTask
