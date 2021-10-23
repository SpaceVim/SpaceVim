local PATTERN_LUA_IDENTIFIER = '([%a_]+[%a%d_.]*)'

local vimutil = require("luavi.vimutils")


local __p_counter = 0
--- Writes given arguments to temporary file adding counting and "\n" when appropriate. Useful when debugging.
-- @param ... anything that a io.write function could accept
local function __p(...)
  __p_counter = __p_counter + 1
  local f = io.open("/tmp/lua_omni_out.txt", "a")
  if f then
    f:write(__p_counter .. ": ")
    f:write(...)
    local last = select(select("#", ...), ...)
    if type(last) == "string" and not string.find(last, "\n$") then
      f:write("\n")
    end
    f:close()
  end
end


--- Finds all assignments in given buffer and return a table with them with order the closest ones being first.
-- @param buf Vim's buffer to be used as source (current one if absent)
-- @param line line number to be checked for being within function' body
-- @return table with list of assignments
function find_assigments(buf, line)
  if not line then
    buf = vim.window().buffer
    line = vim.window().line
  end
  buf = buf or vim.buffer()
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


--- Escape Lua pattern magic characters "[().%+-*?[^$]" using escape "%".
-- @param s a string to be escaped
-- @return just an escaped string
function escape_magic_chars(s)
  assert(type(s) == "string", "s must be a string!")

  return (string.gsub(s, '([().%+-*?[^$])', '%%%1'))
end


--- Replaces "*" and "." characters to more fitting Lua pattern ones.
-- @param s a string
-- @return pattern
function glob_to_pattern(s)
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


--- Iterator which walks over a Vim buffer.
-- @param buf buffer to be used as source
-- @return next buffer's line
function line_buf_iter(buf)
  buf = buf or vim.buffer()
  local lineidx = 0
  return function()
    lineidx = lineidx + 1
    if lineidx <= #buf then
      return buf[lineidx]
    end
  end
end


-- The completion functionality ------------------------------------------------


--- Search for a single part path in _G environment.
-- Nested tables aren't supported.
-- @param pat path to be used in search
-- @return Table with list of k, v pairs.
-- k is function, table, or just variable) name.
-- v is an actual object reference.
function find_completions1(pat)
  local comps = {}
  for k, v in pairs(_G) do
    if string.find(k, "^" .. pat) then
      table.insert(comps, {k, v})
    end
  end
  return comps
end


--- Search for multi level paths starting from _G environment.
-- @param pat path to be used in search
-- @return Table with list of k, v pairs.
-- k is function, table, or just variable name (however it's absolute path).
-- v is an actual object reference.
function find_completions2(pat)
  local results = {}
  -- split path pattern into levels
  local levels = {}
  for lev in string.gmatch(pat, "[^%.]+") do
    table.insert(levels, lev)
  end
  -- if the last character in pat is '.' and matching all level
  if string.sub(pat, -1) == "." then
    table.insert(levels, ".*")
  end

  -- set prepath if there are multiple levels (used for generating absolute paths)
  local prepath = #levels > 1 and table.concat(slice(levels, 1, #levels - 1), ".") .. "." or ""
  -- find target table namespace
  local where = _G
  for i, lev in ipairs(levels) do
    if i < #levels then     -- not last final path's part?
      local w = where[lev]
      if w and type(w) == "table" then  -- going into inner table/namespace?
        where = w
      else  -- not, path is incorrect!
        break
      end
    else    -- the last part of path
      for k, v in pairs(where) do
        if string.find(k, "^" .. lev) then  -- final names search...
          table.insert(results, {prepath .. k, v})
        end
      end
    end
  end
  return results
end


--- Returns a list with paths to files with additional path for Lua omnicompletion.
function lua_omni_files()
  local list = {}
  -- first check LUA_OMNI shell variable
  string.gsub(vim.eval("$LUA_OMNI") or "", '([^ ;,]+)', function(s) table.insert(list, s) end)
  -- Next try b:lua_omni buffer variable or...
  if vim.eval('exists("b:lua_omni")') == 1 then
    string.gsub(vim.eval("b:lua_omni") or "", '([^ ;,]+)', function(s) table.insert(list, s) end)
  -- there isn't buffer's var check for global one.
  elseif vim.eval('exists("g:lua_omni")') == 1 then
    string.gsub(vim.eval("g:lua_omni") or "", '([^ ;,]+)', function(s) table.insert(list, s) end)
  end
  return list
end


--- Search for paths in _G environment table and returns ones matching given pattern.
-- @param pat a pattern
-- @return list of matching paths from _G
function find_completions3(pat)
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
    if not res then vim.command('echoerr "' .. tostring(err) .. '"') end
  end

  local res = {}
  -- match paths with pattern
  for _, v in ipairs(flat) do
    if string.match(v, pat) then table.insert(res, v) end
  end

  return res
end


--- Utility function to be used with Vim's completefunc.
function completion_findstart()
  local w = vim.window()
  local buf = w.buffer
  local line = buf[w.line]
  for i = w.col - 1, 1, -1 do
    local c = string.sub(line, i, i)
    -- "*" and "?" may be used by glob pattern
    if string.find(c, "[^a-zA-Z0-9_%.*?]") then
      return i
    end
  end
  return 0
end


--- Find matching completions.
-- @param base a base to which complete
-- @return list with possible (string) abbreviations
function complete_base_string(base)
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


--- To be called within CompleteLua Vim function.
function completefunc_luacode()
  -- getting arguments from Vim function
  local findstart = vim.eval("a:findstart")
  local base = vim.eval("a:base")
  -- this function is called twice - first for finding range in line to complete
  if findstart == 1 then
    vim.command("return " .. completion_findstart())
  else      -- the second run - do proper complete
    local comps = complete_base_string(base)
    for i = 1, #comps do comps[i] = "'" .. comps[i] .. "'" end
    -- returning
    vim.command("return [" .. table.concat(comps, ", ") .. "]")
  end
end


-- The outline window. ---------------------------------------------------------

--- Get a list of Lua defined functions in a buffer.
-- @param buf a buffer to be used (parsed?) for doing funcs list (optional, if
-- absent then use current one)
-- @return list of {linenumber, linecontent} tables
function function_list(buf)
  local funcs = {}
  local linenum = 0
  for line in line_buf_iter(buf) do
    linenum = linenum + 1
    if string.find(line, "^%s-function%s+") then
      funcs[#funcs + 1] = {linenum, line}
    end
    -- TODO reuse later
--  local funcname = string.match(buf[lineidx], "function%s+" .. PATTERN_LUA_IDENTIFIER .. "%s*%(")
--  if funcname then
--    table.insert(funcs, funcname)
--  else
--    funcname = string.match(buf[lineidx], PATTERN_LUA_IDENTIFIER .. "%s*=%s*function%s*%(")
--    if funcname then
--      table.insert(funcs, funcname)
--    end
--  end
  end
  return funcs
end


--- Prints list of function within Vim buffer.
-- The output format is line_number: function func_name __spaces__ function's title (if exists)
-- @param buf buffer to be used as source
function print_function_list(buf)
  local funclist = function_list(buf)
  if #funclist > 0 then
    local countsize = #tostring(funclist[#funclist][1])
    for i, f in ipairs(funclist) do
      if i == 1 then print("line: function definition...") end
      -- try to get any doc about function...
      local doc = func_doc(f[1])
      local title = string.gmatch(doc["---"] or "", "[^\n]+")
      title = title and title() or nil
      local s = string.format("%" .. countsize .. "d: %-" .. (40 - countsize) ..  "s %s", f[1], f[2],
              (title or ""))
      print(s)
    end
  else
    print "no functions found..."
  end
end


--- Checks if current line lies in function definition.
-- Depends on usual code formating where "function" and "end" statements start
-- at first column.
-- @param buf Vim's buffer to be used as source (current one if absent)
-- @param line line number to be checked for being within function' body
-- @return funcstart, funcend pair or nil, nil if line is outside a function
function in_func_body(buf, line)
  if not line then
    buf = vim.window().buffer
    line = vim.window().line
  end
  buf = buf or vim.buffer()
  -- search for function definition first
  local funcstart
  for lineidx = line, 1, -1 do
    -- If iterating back end at first column is found, then it's outside
    -- function.
    if string.find(buf[lineidx], "^end") then break end
    if string.find(buf[lineidx], "^function") then
      funcstart = lineidx
      break
    end
  end
  -- search for the function's closing "end"
  -- (depends on an usual formating, doesn't count code chunks)
  local funcend
  if funcstart then -- search for function's end only when start was found...
    for lineidx = line + 1, #buf do
      if string.find(buf[lineidx], "^end") then
        funcend = lineidx
        break
      end
    end
  end
  return funcstart, funcend
end


--- Search for variable assignments in a Vim buffer within given line range.
-- @param buf Vim buffer to be used
-- @param startline line number from search of assignments will begin
-- @param endline line number to search of assignments will end
-- @return table with list of found variable names
function search_assignments1(buf, startline, endline)
  assert(type(buf) == "userdata", "buf must be a Vim buffer!")
  assert(type(startline) == "number", "startline must be a number!")
  assert(type(endline) == "number", "endline must be a number!")
  assert(startline < endline, "startline must precede endline!")

  -- assignment has a forms like:
  -- varname = something
  -- varname1[, varname2[, varname3]] = something1[, something2[, something3]]
  -- lets assume that there is only one "=" per line
  -- visibility of closures by dammed (for now...)
  local assignments = {}
  -- Patterns have list of patterns matching variable definitions. The first
  -- must be the usual "varname = something" type.
  local patterns = {"([%w,%s_,]-[^=])=([^=].-)",    -- check if there is assignment in a line
                    "for%s+(.-)%s+in%s+(.-)",       -- check if there are variable definitions in "for ... in" loop
                    "function%s%s-[%w-_]-%s-%((.-)%)"}          -- check if there are variable set in function definition

  for lineidx = startline, endline - 1 do
    -- filter out eventual comments
    local line = string.gsub(buf[lineidx], "%s*%-%-.*$", "")
    -- Search for assignments, variable definitions in "for in" and in
    -- function statements.
    for i, pat in ipairs(patterns) do
      local s, e, pre, post = string.find(" " .. line .. " ", "%s" .. pat .. "%s")
      if pre then
        -- if subnum is 1 then assignment is local
        local line, subnum
        if i == 1 then      -- only assignments can have local/not local variety
          line, subnum = string.gsub(pre, "local%s+", "")
        else
          line = pre
        end
        -- just store variable names in a set
        for varname in string.gmatch(line, "[^, \t]+") do assignments[varname] = true end
      end
    end

  end
  -- convert set to a list
  local assignmentlist = {}
  for k, v in pairs(assignments) do table.insert(assignmentlist, k) end
  return assignmentlist
end


--- Miscellaneous. -------------------------------------------------------------

--- Prints keys within a table (or environment). Similar to Python's dir.
-- @param t should be a table or a nil
function dir(t)
  if t == nil then
    t = _G
  assert(type(t) == "table", "t should be a table!")
  elseif type(t) == "table" then
    for k, v in pairs(t) do
      -- TODO commit to main directory
      -- if value is a string and it's too long then trim it
      if type(v) == "string" and string.len(v) > 150 then
        v = string.sub(v, 1, 150) .. "..."
      end
      -- TODO end
      print(k .. ":", v)
    end
  end
end


--- Prints keys of internal Vim's vim Lua module.
function dir_vim()
  for k, v in pairs(vim) do
    local ty = type(v)
    if ty == "function" or ty == "string" or ty == "number" then
      print(k)
    end
  end
end


--- Slice function operating on tables.
-- Minus indexes aren't supported (yet...).
-- @param t a table to be sliced
-- @param s the starting index of slice (inclusive)
-- @param s the ending index of slice (inclusive)
-- @return a new table containing a slice from t
function slice(t, s, e)
  assert(type(t) == "table", "t should be a table!")
  s = s or 1
  e = e or #t
  local sliced = {}
  for idx = s, e do
    if t[idx] then table.insert(sliced, t[idx]) end
  end
  return sliced
end


--- Merges multiple tables as lists.
-- @return resulting list have merged arguments from left to right in ascending order
function merge_list(...)
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


--- Returns list of active windows in a current tab.
-- @return vim.window like tables with similar keys
function window_list()
  local idx = 1
  local winlist = {}
  while true do
    local w = vim.window(idx)
    if not w then break end
    winlist[#winlist + 1] = {line = w.line, col = w.col, width = w.width,
                                height = w.height, firstline = w.buffer[1],
                                currentline = w.buffer[w.line]}
    idx = idx + 1
  end
  return winlist
end


--- Just prints current window list.
function print_window_list()
  local wincount
  for i, w in ipairs(window_list()) do
    if i == 1 then print("win number, line, col, width, height :current line content...") end
    print(string.format("%02d: %s", i, w.currentline))
    wincount = i
  end
  if not wincount then print("no windows found (how it's possible?!)...") end
end


--- Try to parse function documentation using luadoc format.
-- At first it wasn't easy to write, but after some thought I had it done
-- in quite efficient way (I think :).
-- @param line starting line of function which luadoc to parse
-- @param buf Vim's buffer to be used as source (current one if absent)
-- @return table containing k/v pairs analogous to luadoc's "@" flags
function func_doc(line, buf)
  buf = buf or vim.buffer()
  assert(type(line) == "number", "line must be a number!")
  assert(line >= 1 and line <= #buf, "line should be withing range of buffer's lines!")
  local curlines, doc = {}, {}
  for l = line - 1, 1, -1 do
    local spciter = string.gmatch(buf[l], "%S+")
    local pre = spciter()
    local flag, fvalue, rest
    if pre == "---" then
      rest = table.concat(iter_to_table(spciter), " ")
      table.insert(curlines, rest)
      doc["---"] = curlines
    elseif pre == "--" then
      flag = spciter()
      if string.sub(flag, 1, 1) == "@" then
        fvalue = spciter()
        rest = table.concat(iter_to_table(spciter), " ")
        table.insert(curlines, rest)
        doc[flag .. ":" .. fvalue] = curlines
        curlines = {}
      else
        rest = table.concat(iter_to_table(spciter), " ")
        table.insert(curlines, rest)
      end
    else
      break
    end
  end
  -- post reverse and concat doc's strings
  for k, t in pairs(doc) do
    local reversed = {}
    for i = 1, #t do reversed[i] = t[#t - i + 1] end    -- reverse accumulated lines
    doc[k] = table.concat(reversed, "\n")
  end
  return doc
end


--- Translates iterator function into a table.
-- @param iter iterator function
-- @return table populated by iterator
function iter_to_table(iter)
  assert(type(iter) == "function", "iter has to be a function!")
  local t = {}
  local idx = 0
  for v in iter do
    idx = idx + 1
    t[idx] = v
  end
  return t
end


--- Iterator which scans Vim buffer and returns on each call a supposed fold level, line number and line itself. Parsing is simplified but should be good enough for most of the time.
-- @param buf a Vim buffer to scan, nil for current buffer
-- @param fromline a line number from which scanning starts, nil for 1
-- @param toline a line number at which scanning stops, nil for the last buffer's line
-- @return fold level, line number, line's content
function fold_iter(buf, fromline, toline)
  assert(fromline == nil or type(fromline) == "number", "fromline must be a number if specified!")
  buf = buf or vim.buffer()
  toline = toline or #buf
  assert(type(toline) == "number", "toline must be a number if specified!")

  local lineidx = fromline and (fromline - 1) or 0
  -- to remember consecutive folds
  local foldlist = {}
  -- closure blocks opening/closing statements
  local patterns = {{"do", "end"},
                    {"repeat", "until%s+.+"},
                    {"if%s+.+%s+then", "end"},
                    {"for%s+.+%s+do", "end"},
                    {"function.+", "end"},
                    {"return%s+function.+", "end"},
                    {"local%s+function%s+.+", "end"},
                   }

  return function()
    lineidx = lineidx + 1
    if lineidx <= toline then
      -- search for one of blocks statements
      for i, t in ipairs(patterns) do
        -- add whole line anchors
        local tagopen = '^%s*' .. t[1] .. '%s*$'
        local tagclose = '^%s*' .. t[2] .. '%s*$'
        -- try to find opening statement
        if string.find(buf[lineidx], tagopen) then
          -- just remember it
          table.insert(foldlist, t)
        elseif string.find(buf[lineidx], tagclose) then     -- check for closing statement
          -- Proceed only if there is unclosed block in foldlist and its
          -- closing statement matches.
          if #foldlist > 0 and string.find(buf[lineidx], foldlist[#foldlist][2]) then
            table.remove(foldlist)
            -- Add 1 to foldlist length (synonymous to fold level) to include
            -- closing statement in the fold too.
            return #foldlist + 1, lineidx, buf[lineidx]
          else
            -- An incorrect situation where opening/closing statements didn't
            -- match (probably due to malformed formating or erroneous code).
            -- Just "reset" foldlist.
            foldlist = {}
          end
        end
      end
      -- #foldlist is fold level
      return #foldlist, lineidx, buf[lineidx]
    end
  end
end


--- A Lua part to be called from Vim script FoldLuaLevel function used by foldexpr option. It returns fold level for given line number.
function foldlevel_luacode()
  local linenum = vim.eval("a:linenum")
  assert(type(linenum) == "number", "linenum must be a number!")

  -- by default don't make nested folds
  local innerfolds = false
  -- though a configuration variable can enable it
  if vim.eval('exists("b:lua_inner_folds")') == 1 then
    innerfolds = vim.eval('b:lua_inner_folds') == 1
  elseif vim.eval('exists("g:lua_inner_folds")') == 1 then
    innerfolds = vim.eval('g:lua_inner_folds') == 1
  end
  __p("innerfolds " .. tostring(innerfolds))
  -- Iterate over line fold levels to find that one for which Vim is asking.
  -- TODO It's repetitively inefficient - perhaps some kind of caching would
  -- be beneficial?
  for lvl, lineidx in fold_iter() do
    if lineidx == linenum then
      vim.command("return " .. (innerfolds and lvl or (lvl > 1 and 1 or lvl)))
      break
    end
  end
end

