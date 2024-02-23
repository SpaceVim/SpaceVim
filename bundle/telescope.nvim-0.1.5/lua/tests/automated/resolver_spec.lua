local eq = function(a, b)
  assert.are.same(a, b)
end

local resolve = require "telescope.config.resolve"

describe("telescope.config.resolve", function()
  describe("win_option", function()
    it("should resolve for percentages", function()
      local height_config = 0.8
      local opt = resolve.win_option(height_config)

      eq(height_config, opt.preview)
      eq(height_config, opt.prompt)
      eq(height_config, opt.results)
    end)

    it("should resolve for percentages with default", function()
      local height_config = 0.8
      local opt = resolve.win_option(nil, height_config)

      eq(height_config, opt.preview)
      eq(height_config, opt.prompt)
      eq(height_config, opt.results)
    end)

    it("should resolve table values", function()
      local table_val = { "a" }
      local opt = resolve.win_option(nil, table_val)

      eq(table_val, opt.preview)
      eq(table_val, opt.prompt)
      eq(table_val, opt.results)
    end)

    it("should allow overrides for different wins", function()
      local prompt_override = { "a", prompt = "b" }
      local opt = resolve.win_option(prompt_override)
      eq("a", opt.preview)
      eq("a", opt.results)
      eq("b", opt.prompt)
    end)

    it("should allow overrides for all wins", function()
      local all_specified = { preview = "a", prompt = "b", results = "c" }
      local opt = resolve.win_option(all_specified)
      eq("a", opt.preview)
      eq("b", opt.prompt)
      eq("c", opt.results)
    end)

    it("should allow some specified with a simple default", function()
      local some_specified = { prompt = "b", results = "c" }
      local opt = resolve.win_option(some_specified, "a")
      eq("a", opt.preview)
      eq("b", opt.prompt)
      eq("c", opt.results)
    end)
  end)

  describe("resolve_height/width", function()
    local test_sizes = {
      { 24, 100 },
      { 35, 125 },
      { 60, 59 },
      { 100, 40 },
    }
    it("should handle percentages", function()
      local percentages = { 0.1, 0.33333, 0.5, 0.99 }
      for _, s in ipairs(test_sizes) do
        for _, p in ipairs(percentages) do
          eq(math.floor(s[1] * p), resolve.resolve_width(p)(nil, unpack(s)))
          eq(math.floor(s[2] * p), resolve.resolve_height(p)(nil, unpack(s)))
        end
      end
    end)

    it("should handle percentages with min/max boundary", function()
      eq(20, resolve.resolve_width { 0.1, min = 20 }(nil, 40, 120))
      eq(30, resolve.resolve_height { 0.1, min = 20 }(nil, 40, 300))

      eq(24, resolve.resolve_width { 0.4, max = 80 }(nil, 60, 60))
      eq(80, resolve.resolve_height { 0.4, max = 80 }(nil, 60, 300))
    end)

    it("should handle fixed size", function()
      local fixed = { 5, 8, 13, 21, 34 }
      for _, s in ipairs(test_sizes) do
        for _, f in ipairs(fixed) do
          eq(math.min(f, s[1]), resolve.resolve_width(f)(nil, unpack(s)))
          eq(math.min(f, s[2]), resolve.resolve_height(f)(nil, unpack(s)))
        end
      end
    end)

    it("should handle functions", function()
      local func = function(_, max_columns, max_lines)
        if max_columns < 45 then
          return math.min(max_columns, max_lines)
        elseif max_columns < max_lines then
          return max_columns * 0.8
        else
          return math.min(max_columns, max_lines) * 0.5
        end
      end
      for _, s in ipairs(test_sizes) do
        eq(func(nil, unpack(s)), resolve.resolve_height(func)(nil, unpack(s)))
      end
    end)

    it("should handle padding", function()
      local func = function(_, max_columns, max_lines)
        return math.floor(math.min(max_columns * 0.6, max_lines * 0.8))
      end
      local pads = { 0.1, 5, func }
      for _, s in ipairs(test_sizes) do
        for _, p in ipairs(pads) do
          eq(s[1] - 2 * resolve.resolve_width(p)(nil, unpack(s)), resolve.resolve_width { padding = p }(nil, unpack(s)))
          eq(
            s[2] - 2 * resolve.resolve_height(p)(nil, unpack(s)),
            resolve.resolve_height { padding = p }(nil, unpack(s))
          )
        end
      end
    end)
  end)

  describe("resolve_anchor_pos", function()
    local test_sizes = {
      { 6, 7, 8, 9 },
      { 10, 20, 30, 40 },
      { 15, 15, 16, 16 },
      { 17, 19, 23, 31 },
      { 21, 18, 26, 24 },
      { 50, 100, 150, 200 },
    }

    it([[should not adjust when "CENTER" or "" is the anchor]], function()
      for _, s in ipairs(test_sizes) do
        eq({ 0, 0 }, resolve.resolve_anchor_pos("", unpack(s)))
        eq({ 0, 0 }, resolve.resolve_anchor_pos("center", unpack(s)))
        eq({ 0, 0 }, resolve.resolve_anchor_pos("CENTER", unpack(s)))
      end
    end)

    it([[should end up at top when "N" in the anchor]], function()
      local top_test = function(anchor, p_width, p_height, max_columns, max_lines)
        local pos = resolve.resolve_anchor_pos(anchor, p_width, p_height, max_columns, max_lines)
        eq(1, pos[2] + math.floor((max_lines - p_height) / 2))
      end
      for _, s in ipairs(test_sizes) do
        top_test("NW", unpack(s))
        top_test("N", unpack(s))
        top_test("NE", unpack(s))
      end
    end)

    it([[should end up at left when "W" in the anchor]], function()
      local left_test = function(anchor, p_width, p_height, max_columns, max_lines)
        local pos = resolve.resolve_anchor_pos(anchor, p_width, p_height, max_columns, max_lines)
        eq(1, pos[1] + math.floor((max_columns - p_width) / 2))
      end
      for _, s in ipairs(test_sizes) do
        left_test("NW", unpack(s))
        left_test("W", unpack(s))
        left_test("SW", unpack(s))
      end
    end)

    it([[should end up at bottom when "S" in the anchor]], function()
      local bot_test = function(anchor, p_width, p_height, max_columns, max_lines)
        local pos = resolve.resolve_anchor_pos(anchor, p_width, p_height, max_columns, max_lines)
        eq(max_lines - 1, pos[2] + p_height + math.floor((max_lines - p_height) / 2))
      end
      for _, s in ipairs(test_sizes) do
        bot_test("SW", unpack(s))
        bot_test("S", unpack(s))
        bot_test("SE", unpack(s))
      end
    end)

    it([[should end up at right when "E" in the anchor]], function()
      local right_test = function(anchor, p_width, p_height, max_columns, max_lines)
        local pos = resolve.resolve_anchor_pos(anchor, p_width, p_height, max_columns, max_lines)
        eq(max_columns - 1, pos[1] + p_width + math.floor((max_columns - p_width) / 2))
      end
      for _, s in ipairs(test_sizes) do
        right_test("NE", unpack(s))
        right_test("E", unpack(s))
        right_test("SE", unpack(s))
      end
    end)

    it([[should ignore casing of the anchor]], function()
      local case_test = function(a1, a2, p_width, p_height, max_columns, max_lines)
        local pos1 = resolve.resolve_anchor_pos(a1, p_width, p_height, max_columns, max_lines)
        local pos2 = resolve.resolve_anchor_pos(a2, p_width, p_height, max_columns, max_lines)
        eq(pos1, pos2)
      end
      for _, s in ipairs(test_sizes) do
        case_test("ne", "NE", unpack(s))
        case_test("w", "W", unpack(s))
        case_test("sW", "sw", unpack(s))
        case_test("cEnTeR", "CeNtEr", unpack(s))
      end
    end)
  end)
end)
