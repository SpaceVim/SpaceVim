
local nf_finder = function(data)
  local results = {}

  if data == nil then
    if results[#results] == '' then
      table.remove(results, #results)
    end

    return
  end

  local line, last_start, start, found_newline, result_index

  last_start = 1
  result_index = #results + 1
  repeat
    start = string.find(data, "\n", last_start, true) or #data
    found_newline = start ~= #data

    line = string.sub(data, last_start, start - 1)

    if results[result_index] then
      results[result_index] = results[result_index] .. line
    else
      results[result_index] = line
    end

    if found_newline then
      result_index = result_index + 1
    end

    last_start = start + 1
  until not found_newline

  return results
end

local prev_nf_finder = function(data) -- {{{
  local results = { '' }

  if data == nil then
    if results[#results] == '' then
      table.remove(results, #results)
    end

    return
  end

  local line, last_start, start, found_newline

  last_start = 1
  repeat
    start = string.find(data, "\n", last_start, true) or #data
    found_newline = start ~= #data

    line = string.sub(data, last_start, start - 1)

    results[#results] = (results[#results] or '') .. line

    if found_newline then
      table.insert(results, '')
    end

    last_start = start + 1
  until not found_newline

  return results
end -- }}}
local old_nf_finder = function(data) -- {{{
  local results = {}

  if data == nil then
    if results[#results] == '' then
      table.remove(results, #results)
    end

    return
  end

  local line, start, found_newline
  repeat
    start = string.find(data, "\n", nil, true) or #data
    found_newline = string.find(data, "\n", nil, true)

    line = string.sub(data, 1, start - 1)
    data = string.sub(data, start + 1, -1)

    line = line:gsub("\r", "")

    results[#results] = (results[#results] or '') .. line

    if found_newline then
      table.insert(results, '')
    end
  until not found_newline
end -- }}}

local disp_result = false
local to_test = vim.fn.system('fdfind')


if disp_result then
  print(vim.inspect(nf_finder(to_test)))
else
  local test_amount = 100
  print(#to_test * test_amount)
  print(require('plenary.profile').benchmark(test_amount, nf_finder, to_test))
  print(require('plenary.profile').benchmark(test_amount, prev_nf_finder, to_test))
  print(require('plenary.profile').benchmark(test_amount, old_nf_finder, to_test))
end
-- print(require('plenary.profile').benchmark(100, nf_finder, to_test))
-- print(require('plenary.profile').benchmark(100, nf_finder, to_test))
-- print(require('plenary.profile').benchmark(100, nf_finder, to_test))
