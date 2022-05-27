local PATTERN_LUA_IDENTIFIER = '([%a_]+[%a%d_.]*)'

complete = {}

local vimutil = require('luavi.vimutils')

local function merge_list(...)
  local res = {}
  for idx = 1, select("#", ...) do
    local t = select(idx, ...)
    if type(t) == "table" then
      for i, v in ipairs(t) do table.insert(res, v) end
    else
      table.insert(res, t)
    end
  end
  return res
end

local function find_assigments(buf, line)
  if not line then
    buf = vimutils.current_buffer()
    -- line = current line number
    line = vimutils.current_linenr()
  end
  buf = buf or vimutils.current_buffer()
  -- scan from first line
  local set = {}
  local list = {}
  local absidx

  local function add_multi_names(str)
    string.gsub(str, '([^, ]+)', function(s)
      if not set[s] or (set[s] > absidx) then
        set[s] = absidx
        table.insert(list, s)
      end
    end)
  end

  for lineidx = 1, #buf do
    local sts = string.match(buf[lineidx], PATTERN_LUA_IDENTIFIER .. '%s*=[^=]?.*$')
    -- collect assignments with relative line numbers
    absidx = math.abs(line - lineidx)
    if sts and (not set[sts] or (set[sts] > absidx)) then
      -- set new key or replace but only if the new absolute index is smaller
      set[sts] = absidx
      table.insert(list, sts)
    end
    -- Check for variables defined without assignments as local. It may
    -- generate redundant match but conditions in gsub's argument functions
    -- will make it get correct results.
    sts = string.match(buf[lineidx], 'local%s+([^=]+)')
    if sts then add_multi_names(sts) end
    -- matching variables initialized in generic for loop
    sts = string.match(buf[lineidx], 'for%s+(.*)%s+in')
    if sts then add_multi_names(sts) end
    -- function names matching
    sts = string.match(buf[lineidx], 'function%s+(' .. PATTERN_LUA_IDENTIFIER .. ')%s*%(')
    if sts and (not set[sts] or (set[sts] > absidx)) then
      -- set new key or replace but only if the new absolute index is smaller
      set[sts] = absidx
      table.insert(list, sts)
    end
    -- check for variables defined in functions statements
    sts = string.match(buf[lineidx], 'function%s*[^(]*%(([^)]+)%)')
    if sts then add_multi_names(sts) end
  end
  -- sort list using set's absolute indexes in comparator
  table.sort(list, function(v1, v2) return set[v1] < set[v2] end)
  return list
end


local function lua_omni_files()
  local list = {}
  -- first check LUA_OMNI shell variable
  string.gsub(vimutils.eval("$LUA_OMNI") or "", '([^ ;,]+)', function(s) table.insert(list, s) end)
  -- Next try b:lua_omni buffer variable or...
  if vimutils.eval('exists("b:lua_omni")') == 1 then
    string.gsub(vimutils.eval("b:lua_omni") or "", '([^ ;,]+)', function(s) table.insert(list, s) end)
  -- there isn't buffer's var check for global one.
  elseif vimutils.eval('exists("g:lua_omni")') == 1 then
    string.gsub(vimutils.eval("g:lua_omni") or "", '([^ ;,]+)', function(s) table.insert(list, s) end)
  end
  return list
end

local function completion_findstart()
    local line = vimutil.get_current_line()
    local col = vimutils.eval('col(".")')
    for i = col - 1, 1, -1 do
        local c = string.sub(line, i, i)
        -- "*" and "?" may be used by glob pattern
        if string.find(c, "[^a-zA-Z0-9_%.*?]") then
            return i
        end
    end
    return 0
end

local function escape_magic_chars(s)
  assert(type(s) == "string", "s must be a string!")

  return (string.gsub(s, '([().%+-*?[^$])', '%%%1'))
end

local function glob_to_pattern(s)
  assert(type(s) == "string", "s must be a string!")

  local pat = string.gsub(s, '.', function(c)
    if c == "*" then
      return '.-'
    elseif c == '?' then
      return '.'
    else return escape_magic_chars(c) end
  end)
  return pat
end

local function find_completions3(pat)
  local flat = {}
  local visited = {}
  local count = 0

  function flatten_recursively(t, lvl)
    lvl = lvl or ""
    -- just to be safe...
    if count > 10000 then return end

    for k, v in pairs(t) do
      -- for safe measure above
      count = count + 1
      if type(k) == "string" then
        table.insert(flat, #lvl > 0 and lvl .. "." .. k or k)
      end
      -- Inner table but do it recursively only when this run hasn't found it
      -- already.
      if type(v) == "table" and not visited[v] then
        -- check to avoid in recursive call
        visited[v] = true
        if type(k) == "string" then
          flatten_recursively(v, #lvl > 0 and lvl .. "." .. k or k)
        end
        -- Uncheck to allow to visit the same table but from different path.
        visited[v] = nil
      end
    end
  end

  -- start from _G
  flatten_recursively(_G)

  -- add paths from file(s)
  local pathfiles = lua_omni_files()
  for _, fname in ipairs(pathfiles) do
    -- there is chance that filename is invalid so guard for error
    local res, err = pcall(function()
      for line in io.lines(fname) do
        -- trim line
        line = string.gsub(line, "^%s-(%S.-)%s-$", "%1")
        -- put every line as path
        table.insert(flat, line)
      end
    end)
    -- If pcall above did catch error then echo about it.
    if not res then vimutils.command('echoerr "' .. tostring(err) .. '"') end
  end

  local res = {}
  -- match paths with pattern
  for _, v in ipairs(flat) do
    if string.match(v, pat) then table.insert(res, v) end
  end

  return res
end

local function complete_base_string(base)
    local t = {}

    if type(base) == "string" then
        -- completion using _G environment
        -- obsolete the new version seems better
        --  local comps = find_completions2(base)
        --  for _, v in pairs(comps) do
        --    table.insert(t, v[1])
        --  end
        --  table.sort(t)

        local sortbylen = false
        local pat = string.match(base, '^[%a_][%a%d_]*$')
        if pat then             -- single word completion
            pat = ".*" .. escape_magic_chars(pat) .. ".*"
            sortbylen = true
        else                    -- full completion
            pat = glob_to_pattern(base)
            if not string.match(pat, '%.%*$') then pat = pat .. '.*' end
        end
        -- try to find something matching...
        t = find_completions3("^" .. pat .. "$")
        -- in a case no results were found try to expand dots
        if #t == 0 then
            pat = string.gsub(base, "%.", "[^.]*%%.") .. '.*'
            t = find_completions3("^" .. pat .. "$")
        end

        -- For single word matches it's more convenient to have results sorted by
        -- their string length.
        if sortbylen then
            table.sort(t, function(o1, o2)
                o1 = o1 or ""
                o2 = o2 or ""
                local l1 = string.len(o1)
                local l2 = string.len(o2)
                return l1 < l2
            end)
        else
            table.sort(t)
        end

        -- Always do variable assignments matching per buffer now as
        -- find_assigments will return most close assignments first.
        local assigments = {}
        for i, v in ipairs(find_assigments()) do
            if string.find(v, "^" .. base) then table.insert(assigments, v) end
        end
        t = merge_list(assigments, t)
    end
    return t
end



function complete.complete(findstart, base)
    -- this function is called twice - first for finding range in line to complete
    if findstart == 1 then
        vimutil.command("return " .. completion_findstart())
    else      -- the second run - do proper complete
        local comps = complete_base_string(base)
        for i = 1, #comps do comps[i] = "'" .. comps[i] .. "'" end
        -- returning
        vimutil.command("return [" .. table.concat(comps, ", ") .. "]")
    end
end


return complete
