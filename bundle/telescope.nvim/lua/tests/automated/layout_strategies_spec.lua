-- local tester = require('telescope.pickers._test')
local config = require "telescope.config"
local resolve = require "telescope.config.resolve"
local layout_strats = require "telescope.pickers.layout_strategies"

local validate_layout_config = layout_strats._validate_layout_config

local eq = assert.are.same

describe("layout_strategies", function()
  it("should have validator", function()
    assert(validate_layout_config, "Has validator")
  end)

  local test_height = function(should, output, input, opts)
    opts = opts or {}

    local max_columns, max_lines = opts.max_columns or 100, opts.max_lines or 100
    it(should, function()
      local layout_config = validate_layout_config("horizontal", { height = true }, { height = input })

      eq(output, resolve.resolve_height(layout_config.height)({}, max_columns, max_lines))
    end)
  end

  test_height("should handle numbers", 10, 10)

  test_height("should handle percentage: 100", 10, 0.1, { max_lines = 100 })
  test_height("should handle percentage: 110", 11, 0.1, { max_lines = 110 })

  test_height("should call functions: simple", 5, function()
    return 5
  end)
  test_height("should call functions: percentage", 15, function(_, _, lines)
    return 0.1 * lines
  end, {
    max_lines = 150,
  })

  local test_defaults_key = function(should, key, strat, output, ours, theirs, override)
    ours = ours or {}
    theirs = theirs or {}
    override = override or {}

    it(should, function()
      config.clear_defaults()
      config.set_defaults({ layout_config = theirs }, { layout_config = { ours, "description" } })
      local layout_config = validate_layout_config(strat, layout_strats._configurations[strat], override)
      eq(output, layout_config[key])
    end)
  end

  test_defaults_key(
    "should use ours if theirs and override don't give the key",
    "height",
    "horizontal",
    50,
    { height = 50 },
    { width = 100 },
    { width = 120 }
  )

  test_defaults_key(
    "should use ours if theirs and override don't give the key for this strategy",
    "height",
    "horizontal",
    50,
    { height = 50 },
    { vertical = { height = 100 } },
    { vertical = { height = 120 } }
  )

  test_defaults_key(
    "should use theirs if override doesn't give the key",
    "height",
    "horizontal",
    100,
    { height = 50 },
    { height = 100 },
    { width = 120 }
  )

  test_defaults_key(
    "should use override if key given",
    "height",
    "horizontal",
    120,
    { height = 50 },
    { height = 100 },
    { height = 120 }
  )

  test_defaults_key(
    "should use override if key given for this strategy",
    "height",
    "horizontal",
    120,
    { height = 50 },
    { height = 100 },
    { horizontal = { height = 120 } }
  )

  test_defaults_key(
    "should use theirs if override doesn't give key (even if ours has strategy specific)",
    "height",
    "horizontal",
    100,
    { horizontal = { height = 50 } },
    { height = 100 },
    { width = 120 }
  )

  test_defaults_key(
    "should use override (even if ours has strategy specific)",
    "height",
    "horizontal",
    120,
    { horizontal = { height = 50 } },
    { height = 100 },
    { height = 120 }
  )

  test_defaults_key(
    "should use override (even if theirs has strategy specific)",
    "height",
    "horizontal",
    120,
    { height = 50 },
    { horizontal = { height = 100 } },
    { height = 120 }
  )

  test_defaults_key(
    "should use override (even if ours and theirs have strategy specific)",
    "height",
    "horizontal",
    120,
    { horizontal = { height = 50 } },
    { horizontal = { height = 100 } },
    { height = 120 }
  )

  test_defaults_key(
    "should handle user config overriding a table with a number",
    "height",
    "horizontal",
    120,
    { height = { padding = 5 } },
    { height = 120 },
    {}
  )

  test_defaults_key(
    "should handle user oneshot overriding a table with a number",
    "height",
    "horizontal",
    120,
    {},
    { height = { padding = 5 } },
    { height = 120 }
  )
end)
