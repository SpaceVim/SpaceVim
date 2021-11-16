local cmp = require('cmp')

local definitions = {
  {
    ctype = 'customlist',
    regex = [=[[^[:blank:]]*$]=],
    kind = cmp.lsp.CompletionItemKind.Variable,
    fallback = true,
    isIncomplete = false,
    exec = function(arglead, cmdline, curpos)
      local name = cmdline:match([=[^[ <'>]*(%a*)]=])
      if not name then
        return {}
      end
      for name_, option in pairs(vim.api.nvim_get_commands({ builtin = false })) do
        if name_ == name then
          if vim.tbl_contains({ 'customlist', 'custom' }, option.complete) then
            local ok, items = pcall(function()
              local func = string.gsub(option.complete_arg, 's:', ('<SNR>%d_'):format(option.script_id))
              return vim.fn.eval(('%s("%s", "%s", "%s")'):format(
                func,
                vim.fn.escape(arglead, '"'),
                vim.fn.escape(cmdline, '"'),
                vim.fn.escape(curpos, '"')
              ))
            end)
            if not ok then
              return {}
            end
            if type(items) == 'string' then
              return vim.split(items, '\n')
            elseif type(items) == 'table' then
              return items
            end
            return {}
          end
        end
      end
      return {}
    end
  },
  {
    ctype = 'cmdline',
    regex = [=[^[^!].*]=],
    kind = cmp.lsp.CompletionItemKind.Variable,
    isIncomplete = true,
    exec = function(_, cmdline, _)
      return vim.fn.getcompletion(cmdline, 'cmdline')
    end
  },
}

local source = {}

source.new = function()
  return setmetatable({
    before_line = '',
    offset = -1,
    ctype = '',
    items = {},
  }, { __index = source })
end

source.get_keyword_pattern = function()
  return [=[[[:keyword:]-]*]=]
end

source.get_trigger_characters = function()
  return { ' ', '.' }
end

source.is_available = function()
  return vim.api.nvim_get_mode().mode == 'c'
end

source.complete = function(self, params, callback)
  local offset = 0
  local ctype = ''
  local items = {}
  local kind = ''
  local isIncomplete = false
  for _, def in ipairs(definitions) do
    local s, e = vim.regex(def.regex):match_str(params.context.cursor_before_line)
    if s and e then
      offset = s
      ctype = def.type
      items = def.exec(
        string.sub(params.context.cursor_before_line, s + 1),
        params.context.cursor_before_line,
        params.context.cursor.col
      )
      kind = def.kind
      isIncomplete = def.isIncomplete
      if not (#items == 0 and def.fallback) then
        break
      end
    end
  end

  local labels = {}
  items = vim.tbl_map(function(item)
    if type(item) == 'string' then
      labels[item] = true
      return { label = item, kind = kind }
    end
      labels[item.word] = true
    return { label = item.word, kind = kind }
  end, items)

  local match_prefix = false
  if #params.context.cursor_before_line > #self.before_line then
    match_prefix = string.find(params.context.cursor_before_line, self.before_line, 1, true) == 1
  elseif #params.context.cursor_before_line < #self.before_line then
    match_prefix = string.find(self.before_line, params.context.cursor_before_line, 1, true) == 1
  end
  if match_prefix and self.offset == offset and self.ctype == ctype then
    for _, item in ipairs(self.items) do
      if not labels[item.label] then
        table.insert(items, item)
      end
    end
  end
  self.before_line = params.context.cursor_before_line
  self.offset = offset
  self.ctype = ctype
  self.items = items

  callback({
    isIncomplete = isIncomplete,
    items = items,
  })
end

return source

