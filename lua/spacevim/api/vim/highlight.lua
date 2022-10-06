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


return M
