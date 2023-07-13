local highlight = {}

highlight.keys = {
  'fg',
  'bg',
  'bold',
  'italic',
  'reverse',
  'standout',
  'underline',
  'undercurl',
  'strikethrough',
}

highlight.inherit = function(name, source, settings)
  for _, key in ipairs(highlight.keys) do
    if not settings[key] then
      local v = vim.fn.synIDattr(vim.fn.hlID(source), key)
      if key == 'fg' or key == 'bg' then
        local n = tonumber(v, 10)
        v = type(n) == 'number' and n or v
      else
        v = v == 1
      end
      settings[key] = v == '' and 'NONE' or v
    end
  end
  vim.api.nvim_set_hl(0, name, settings)
end

return highlight
