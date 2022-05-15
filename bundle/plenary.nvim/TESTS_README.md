# Testing Guide

Some testing examples using Plenary.nvim

# A simple test

This tests demonstrates a **describe** block that contains two tests defined with **it** blocks, the describe block also contains a **before_each** call that gets called before each test.

```lua
describe("some basics", function()

  local bello = function(boo)
    return "bello " .. boo
  end

  local bounter

  before_each(function()
    bounter = 0
  end)

  it("some test", function()
  bounter = 100
    assert.equals("bello Brian", bello("Brian"))
  end)

  it("some other test", function()
    assert.equals(0, bounter)
  end)
end)
```

The test **some test** checks that a functions output is as expected based on the input. The second test **some other test** checks that the variable **bounter** is reset for each test (as defined in the before_each block).

# mocking with luassert

Plenary.nvim comes bundled with [luassert](https://github.com/Olivine-Labs/luassert) a library that's built to extend the built-int assertions... but it also comes with stubs, mocks and spies!

Sometimes it's useful to test functions that have nvim api function calls within them, take for example the following example of a simple module that creates a new buffer and opens in it in a split.


**module.lua**
```lua
local M = {}

function M.realistic_func()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_command("sbuffer " .. buf)
end

return M
```

The following is an example of completely mocking a module, and another of just stubbing a single function within a module. In this case the module is `vim.api`, with an aim of giving an example of a unit test (fully mocked) and an integration test... details in the comments.

**module.lua**
```lua
-- import the luassert.mock module
local mock = require('luassert.mock')
local stub = require('luassert.stub')

describe("example", function()
  -- instance of module to be tested
  local testModule = require('example.module')
  -- mocked instance of api to interact with

  describe("realistic_func", function()
    it("Should make expected calls to api, fully mocked", function()
      -- mock the vim.api
      local api = mock(vim.api, true)

      -- set expectation when mocked api call made
      api.nvim_create_buf.returns(5)

      testModule.realistic_func()

      -- assert api was called with expcted values
      assert.stub(api.nvim_create_buf).was_called_with(false, true)
      -- assert api was called with set expectation
      assert.stub(api.nvim_command).was_called_with("sbuffer 5")

      -- revert api back to it's former glory
      mock.revert(api)
    end)

    it("Should mock single api call", function()
      -- capture some number of windows and buffers before
      -- running our function
      local buf_count = #vim.api.nvim_list_bufs()
      local win_count = #vim.api.nvim_list_wins()
      -- stub a single function in the api
      stub(vim.api, "nvim_command")

      testModule.realistic_func()

      -- capture some details after running out function
      local after_buf_count = #vim.api.nvim_list_bufs()
      local after_win_count = #vim.api.nvim_list_wins()

      -- why 3 not two? NO IDEA! The point is we mocked
      -- nvim_commad and there is only a single window
      assert.equals(3, buf_count)
      assert.equals(4, after_buf_count)

      -- WOOPIE!
      assert.equals(1, win_count)
      assert.equals(1, after_win_count)
    end)
  end)
end)
```

To test this in your `~/.config/nvim` configuration, try the suggested file structure:

```
lua/example/module.lua
lua/spec/example/module_spec.lua
```
