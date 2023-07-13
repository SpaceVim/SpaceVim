local M = {}

M.group2dict = function (name)
    local id = vim.fn.hlID(name)
    if id == 0 then
        return {
            name = '',
            ctermbg = '',
            ctermfg = '',
            bold = '',
            italic = '',
            reverse = '',
            underline = '',
            guibg = '',
            guifg = '',
        }
    end
    local rst = {
        name = vim.fn.synIDattr(id, 'name'),
        ctermbg = vim.fn.synIDattr(id, 'bg', 'cterm'),
        ctermfg = vim.fn.synIDattr(id, 'fg', 'cterm'),
        bold = vim.fn.synIDattr(id, 'bold'),
        italic = vim.fn.synIDattr(id, 'italic'),
        reverse = vim.fn.synIDattr(id, 'reverse'),
        underline = vim.fn.synIDattr(id, 'underline'),
        guibg = vim.fn.tolower(vim.fn.synIDattr(id, 'bg#', 'gui')),
        guifg = vim.fn.tolower(vim.fn.synIDattr(id, 'fg#', 'gui')),
    }
    return rst
end

M.hide_in_normal = function (name)
  local group = M.group2dict(name)
  if vim.fn.empty(group) == 1 then
    return
  end
  local normal = M.group2dict('Normal')
  local guibg = normal.guibg or ''
  local ctermbg = normal.ctermbg or ''
  group.guifg = guibg
  group.guibg = guibg
  group.ctermfg = ctermbg
  group.ctermbg = ctermbg
  M.hi(group)
end



M.hi = function (info)
    if vim.fn.empty(info) == 1 or vim.fn.get(info, 'name', '') == '' then
        return
    end
    vim.cmd('silent! hi clear ' .. info.name)
    local cmd = 'silent hi! ' .. info.name
    if vim.fn.empty(info.ctermbg) == 0 then
        cmd = cmd .. ' ctermbg=' .. info.ctermbg
    end
    if vim.fn.empty(info.ctermfg) == 0 then
        cmd = cmd .. ' ctermfg=' .. info.ctermfg
    end
    if vim.fn.empty(info.guibg) == 0 then
        cmd = cmd .. ' guibg=' .. info.guibg
    end
    if vim.fn.empty(info.guifg) == 0 then
        cmd = cmd .. ' guifg=' .. info.guifg
    end
    local style = {}

    for _, sty in ipairs({'bold', 'italic', 'underline', 'reverse'}) do
        if info[sty] == 1 then
            table.insert(style, sty)
        end
    end

    if vim.fn.empty(style) == 0 then
        cmd = cmd .. ' gui=' .. vim.fn.join(style, ',') .. ' cterm=' .. vim.fn.join(style, ',')
    end
    pcall(vim.cmd, cmd)
end


return M
