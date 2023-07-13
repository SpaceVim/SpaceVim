--(c) 2008-2011 David Manura.  Licensed under the same terms as Lua (MIT).

--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:

--The above copyright notice and this permission notice shall be included in
--all copies or substantial portions of the Software.

--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--THE SOFTWARE.
--(end license)

local M = { _TYPE = "module", _NAME = "globtopattern", _VERSION = "0.2.1.20120406" }

function M.globtopattern(g)
  -- Some useful references:
  -- - apr_fnmatch in Apache APR.  For example,
  --   http://apr.apache.org/docs/apr/1.3/group__apr__fnmatch.html
  --   which cites POSIX 1003.2-1992, section B.6.

  local p = "^" -- pattern being built
  local i = 0 -- index in g
  local c -- char at index i in g.

  -- unescape glob char
  local function unescape()
    if c == "\\" then
      i = i + 1
      c = g:sub(i, i)
      if c == "" then
        p = "[^]"
        return false
      end
    end
    return true
  end

  -- escape pattern char
  local function escape(c)
    return c:match("^%w$") and c or "%" .. c
  end

  -- Convert tokens at end of charset.
  local function charset_end()
    while 1 do
      if c == "" then
        p = "[^]"
        return false
      elseif c == "]" then
        p = p .. "]"
        break
      else
        if not unescape() then
          break
        end
        local c1 = c
        i = i + 1
        c = g:sub(i, i)
        if c == "" then
          p = "[^]"
          return false
        elseif c == "-" then
          i = i + 1
          c = g:sub(i, i)
          if c == "" then
            p = "[^]"
            return false
          elseif c == "]" then
            p = p .. escape(c1) .. "%-]"
            break
          else
            if not unescape() then
              break
            end
            p = p .. escape(c1) .. "-" .. escape(c)
          end
        elseif c == "]" then
          p = p .. escape(c1) .. "]"
          break
        else
          p = p .. escape(c1)
          i = i - 1 -- put back
        end
      end
      i = i + 1
      c = g:sub(i, i)
    end
    return true
  end

  -- Convert tokens in charset.
  local function charset()
    i = i + 1
    c = g:sub(i, i)
    if c == "" or c == "]" then
      p = "[^]"
      return false
    elseif c == "^" or c == "!" then
      i = i + 1
      c = g:sub(i, i)
      if c == "]" then
        -- ignored
      else
        p = p .. "[^"
        if not charset_end() then
          return false
        end
      end
    else
      p = p .. "["
      if not charset_end() then
        return false
      end
    end
    return true
  end

  -- Convert tokens.
  while 1 do
    i = i + 1
    c = g:sub(i, i)
    if c == "" then
      p = p .. "$"
      break
    elseif c == "?" then
      p = p .. "."
    elseif c == "*" then
      p = p .. ".*"
    elseif c == "[" then
      if not charset() then
        break
      end
    elseif c == "\\" then
      i = i + 1
      c = g:sub(i, i)
      if c == "" then
        p = p .. "\\$"
        break
      end
      p = p .. escape(c)
    else
      p = p .. escape(c)
    end
  end
  return p
end

return M
