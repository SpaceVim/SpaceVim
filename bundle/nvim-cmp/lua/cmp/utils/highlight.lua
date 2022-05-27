local highlight = {}

highlight.keys = {
  'gui',
  'guifg',
  'guibg',
  'cterm',
  'ctermfg',
  'ctermbg',
}

highlight.inherit = function(name, source, override)
  local cmd = ('highlight default %s'):format(name)
  for _, key in ipairs(highlight.keys) do
    if override[key] then
      cmd = cmd .. (' %s=%s'):format(key, override[key])
    else
      local v = highlight.get(source, key)
      v = v == '' and 'NONE' or v
      cmd = cmd .. (' %s=%s'):format(key, v)
    end
  end
  vim.cmd(cmd)
end

highlight.get = function(source, key)
  if key == 'gui' or key == 'cterm' then
    local ui = {}
    for _, k in ipairs({ 'bold', 'italic', 'reverse', 'inverse', 'standout', 'underline', 'undercurl', 'strikethrough' }) do
      if vim.fn.synIDattr(vim.fn.hlID(source), k, key) == 1 then
        table.insert(ui, k)
      end
    end
    return table.concat(ui, ',')
  elseif key == 'guifg' then
    return vim.fn.synIDattr(vim.fn.hlID(source), 'fg#', 'gui')
  elseif key == 'guibg' then
    return vim.fn.synIDattr(vim.fn.hlID(source), 'bg#', 'gui')
  elseif key == 'ctermfg' then
    return vim.fn.synIDattr(vim.fn.hlID(source), 'fg', 'term')
  elseif key == 'ctermbg' then
    return vim.fn.synIDattr(vim.fn.hlID(source), 'bg', 'term')
  end
end

return highlight
