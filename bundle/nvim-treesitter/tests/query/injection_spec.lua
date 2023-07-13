require "nvim-treesitter.highlight" -- yes, this is necessary to set the hlmap
local highlighter = require "vim.treesitter.highlighter"
local configs = require "nvim-treesitter.configs"
local parsers = require "nvim-treesitter.parsers"
local ts = vim.treesitter

local function check_assertions(file)
  local buf = vim.fn.bufadd(file)
  vim.fn.bufload(file)
  local lang = parsers.get_buf_lang(buf)
  assert.same(
    1,
    vim.fn.executable "highlight-assertions",
    '"highlight-assertions" not executable!'
      .. ' Get it via "cargo install --git https://github.com/theHamsta/highlight-assertions"'
  )
  local assertions = vim.fn.json_decode(
    vim.fn.system(
      "highlight-assertions -p '" .. configs.get_parser_install_dir() .. "/" .. lang .. ".so'" .. " -s '" .. file .. "'"
    )
  )
  local parser = parsers.get_parser(buf, lang)

  local self = highlighter.new(parser, {})
  local top_level_root = parser:parse()[1]:root()

  for _, assertion in ipairs(assertions) do
    local row = assertion.position.row
    local col = assertion.position.column

    local neg_assert = assertion.expected_capture_name:match "^!"
    assertion.expected_capture_name = neg_assert and assertion.expected_capture_name:sub(2)
      or assertion.expected_capture_name
    local found = false
    self.tree:for_each_tree(function(tstree, tree)
      if not tstree then
        return
      end
      local root = tstree:root()
      --- If there are multiple tree with the smallest range possible
      --- Check all of them to see if they fit or not
      if not ts.is_in_node_range(root, row, col) or root == top_level_root then
        return
      end
      if assertion.expected_capture_name == tree:lang() then
        found = true
      end
    end, true)
    if neg_assert then
      assert.False(
        found,
        "Error in at "
          .. file
          .. ":"
          .. (row + 1)
          .. ":"
          .. (col + 1)
          .. ': expected "'
          .. assertion.expected_capture_name
          .. '" not to be injected here!'
      )
    else
      assert.True(
        found,
        "Error in at "
          .. file
          .. ":"
          .. (row + 1)
          .. ":"
          .. (col + 1)
          .. ': expected "'
          .. assertion.expected_capture_name
          .. '" to be injected here!'
      )
    end
  end
end

describe("injections", function()
  local files = vim.fn.split(vim.fn.glob "tests/query/injections/**/*.*")
  for _, file in ipairs(files) do
    it(file, function()
      check_assertions(file)
    end)
  end
end)
