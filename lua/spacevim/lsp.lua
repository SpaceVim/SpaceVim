local lsp = {}

local function spliteof(data, delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( data, delimiter, from  )
    while delim_from do
        table.insert( result, string.sub( data, from , delim_from-1 ) )
        from  = delim_to + 1
        delim_from, delim_to = string.find( data, delimiter, from  )
    end
    table.insert( result, string.sub( data, from  ) )
    return result
end

function lsp.hover_callback(success, data)
    if not success then
        vim.api.nvim_command('call SpaceVim#util#echoWarn("Failed to retrieve hover information")')
        return
    end
    if (type(data.contents) == "table") then
        vim.api.nvim_command('leftabove split __lspdoc__')
        vim.api.nvim_command('set filetype=markdown.lspdoc')
        vim.api.nvim_command('setlocal nobuflisted')
        vim.api.nvim_command('setlocal buftype=nofile')
        vim.api.nvim_command('setlocal bufhidden=wipe')
        vim.api.nvim_buf_set_lines(0, 0, -1, 0, spliteof(data.contents.value, "\n"))
    elseif type(data.contents) == 'string' and data.contents ~= '' then
        -- for k, v in pairs(data) do
            -- print(k .. " - " ..  v)
            -- kind is filetype
            -- value is contents string
        -- end
        vim.api.nvim_command('leftabove split __lspdoc__')
        vim.api.nvim_command('set filetype=markdown.lspdoc')
        vim.api.nvim_command('setlocal nobuflisted')
        vim.api.nvim_command('setlocal buftype=nofile')
        vim.api.nvim_command('setlocal bufhidden=wipe')
        vim.api.nvim_buf_set_lines(0, 0, -1, 0, spliteof(data.contents, "\n"))
    else
        print('No hover information found')
    end
    -- print(type(data))
end
return lsp
