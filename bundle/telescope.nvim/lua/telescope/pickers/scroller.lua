local scroller = {}

local range_calculators = {
  ascending = function(max_results, num_results)
    return 0, math.min(max_results, num_results)
  end,

  descending = function(max_results, num_results)
    return math.max(max_results - num_results, 0), max_results
  end,
}

local scroll_calculators = {
  cycle = function(range_fn)
    return function(max_results, num_results, row)
      local start, finish = range_fn(max_results, num_results)

      if row >= finish then
        return start
      elseif row < start then
        return (finish - 1 < 0) and finish or finish - 1
      end

      return row
    end
  end,

  limit = function(range_fn)
    return function(max_results, num_results, row)
      local start, finish = range_fn(max_results, num_results)

      if row >= finish and finish > 0 then
        return finish - 1
      elseif row < start then
        return start
      end

      return row
    end
  end,
}

scroller.create = function(scroll_strategy, sorting_strategy)
  local range_fn = range_calculators[sorting_strategy]
  if not range_fn then
    error(debug.traceback("Unknown sorting strategy: " .. sorting_strategy))
  end

  local scroll_fn = scroll_calculators[scroll_strategy]
  if not scroll_fn then
    error(debug.traceback("Unknown scroll strategy: " .. (scroll_strategy or "")))
  end

  local calculator = scroll_fn(range_fn)
  return function(max_results, num_results, row)
    local result = calculator(max_results, num_results, row)

    if result < 0 then
      error(
        string.format(
          "Must never return a negative row: { result = %s, args = { %s %s %s } }",
          result,
          max_results,
          num_results,
          row
        )
      )
    end

    if result > max_results then
      error(
        string.format(
          "Must never exceed max results: { result = %s, args = { %s %s %s } }",
          result,
          max_results,
          num_results,
          row
        )
      )
    end

    return result
  end
end

scroller.top = function(sorting_strategy, max_results, num_results)
  if sorting_strategy == "ascending" then
    return 0
  end
  return (num_results > max_results) and 0 or (max_results - num_results)
end

scroller.middle = function(sorting_strategy, max_results, num_results)
  local mid_pos

  if sorting_strategy == "ascending" then
    mid_pos = math.floor(num_results / 2)
  else
    mid_pos = math.floor(max_results - num_results / 2)
  end

  return (num_results < max_results) and mid_pos or math.floor(max_results / 2)
end

scroller.bottom = function(sorting_strategy, max_results, num_results)
  if sorting_strategy == "ascending" then
    return math.min(max_results, num_results) - 1
  end
  return max_results - 1
end

scroller.better = function(sorting_strategy)
  if sorting_strategy == "ascending" then
    return -1
  else
    return 1
  end
end

scroller.worse = function(sorting_strategy)
  return -(scroller.better(sorting_strategy))
end

return scroller
