local async = require('cmp.utils.async')

describe('utils.async', function()
  it('throttle', function()
    local count = 0
    local now
    local f = async.throttle(function()
      count = count + 1
    end, 100)

    -- 1. delay for 100ms
    now = vim.loop.now()
    f.timeout = 100
    f()
    vim.wait(1000, function()
      return count == 1
    end)
    assert.is.truthy(math.abs(f.timeout - (vim.loop.now() - now)) < 10)

    -- 2. delay for 500ms
    now = vim.loop.now()
    f.timeout = 500
    f()
    vim.wait(1000, function()
      return count == 2
    end)
    assert.is.truthy(math.abs(f.timeout - (vim.loop.now() - now)) < 10)

    -- 4. delay for 500ms and wait 100ms (remain 400ms)
    f.timeout = 500
    f()
    vim.wait(100) -- remain 400ms

    -- 5. call immediately (100ms already elapsed from No.4)
    now = vim.loop.now()
    f.timeout = 100
    f()
    vim.wait(1000, function()
      return count == 3
    end)
    assert.is.truthy(math.abs(vim.loop.now() - now) < 10)
  end)
  it('step', function()
    local done = false
    local step = {}
    async.step(function(next)
      vim.defer_fn(function()
        table.insert(step, 1)
        next()
      end, 10)
    end, function(next)
      vim.defer_fn(function()
        table.insert(step, 2)
        next()
      end, 10)
    end, function(next)
      vim.defer_fn(function()
        table.insert(step, 3)
        next()
      end, 10)
    end, function()
      done = true
    end)
    vim.wait(1000, function()
      return done
    end)
    assert.are.same(step, { 1, 2, 3 })
  end)
end)
