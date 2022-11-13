require "nvim-treesitter.highlight" -- yes, this is necessary to set the hlmap
local highlighter = require "vim.treesitter.highlighter"
local configs = require "nvim-treesitter.configs"
local ts_utils = require "nvim-treesitter.ts_utils"
local parsers = require "nvim-treesitter.parsers"

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

    local found = false
    self.tree:for_each_tree(function(tstree, tree)
      if not tstree then
        return
      end

      local root = tstree:root()
      if
        ts_utils.is_in_node_range(root, row, col)
        and assertion.expected_capture_name == tree:lang()
        and root ~= top_level_root
      then
        found = true
      end
    end, true)
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

describe("injections", function()
  local files = vim.fn.split(vim.fn.glob "tests/query/injections/**/*.*")
  for _, file in ipairs(files) do
    it(file, function()
      check_assertions(file)
    end)
  end
end)
