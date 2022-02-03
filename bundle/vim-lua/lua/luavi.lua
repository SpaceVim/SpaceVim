luavi = {}

local complete = require('luavi.complete')

function luavi.complete(findstart, base)
    complete.complete(findstart, base)
end

local function fold_iter(buf, fromline, toline)
  assert(fromline == nil or type(fromline) == "number", "fromline must be a number if specified!")
  buf = buf or vimutils.current_buffer()
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

function luavi.fold(linenum)
  assert(type(linenum) == "number", "linenum must be a number!")

  -- by default don't make nested folds
  local innerfolds = false
  -- though a configuration variable can enable it
  if vimutils.eval('exists("b:lua_inner_folds")') == 1 then
    innerfolds = vimutils.eval('b:lua_inner_folds') == 1
  elseif vimutils.eval('exists("g:lua_inner_folds")') == 1 then
    innerfolds = vimutils.eval('g:lua_inner_folds') == 1
  end

  for lvl, lineidx in fold_iter() do
    if lineidx == linenum then
      vim.command("return " .. (innerfolds and lvl or (lvl > 1 and 1 or lvl)))
      break
    end
  end
end

return luavi
