local M = {}

M.__aliases = {
  typescript = 'TypeScript',
  typescriptreact = 'TypeScript React',
  python = 'Python',
  java = 'Java',
  smalltalk = 'SmallTalk',
  objc = 'Objective-C',
  postscript = 'PostScript',
}

function M.get_alias(ft)
  if ft and ft ~= '' and M.__aliases[ft] then
    return M.__aliases[ft]
  else
    return ft
  end
end

return M
