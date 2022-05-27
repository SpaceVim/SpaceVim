
function Job.accumulate_results(results)
  return function(err, data)
    if data == nil then
      if results[#results] == '' then
        table.remove(results, #results)
      end

      return
    end

    if results[1] == nil then
      results[1] = ''
    end

    -- Get rid of pesky \r
    data = data:gsub("\r", "")

    local line, start, found_newline
    while true do
      start = string.find(data, "\n") or #data
      found_newline = string.find(data, "\n")

      line = string.sub(data, 1, start)
      data = string.sub(data, start + 1, -1)

      line = line:gsub("\r", "")
      line = line:gsub("\n", "")

      results[#results] = (results[#results] or '') .. line

      if found_newline then
        table.insert(results, '')
      else
        break
      end
    end

    -- if found_newline and results[#results] == '' then
    --   table.remove(results, #results)
    -- end

    -- if string.find(data, "\n") then
    --   for _, line in ipairs(vim.fn.split(data, "\n")) do
    --     line = line:gsub("\n", "")
    --     line = line:gsub("\r", "")

    --     table.insert(results, line)
    --   end
    -- else
    --   results[#results] = results[#results] .. data
    -- end
  end
end

