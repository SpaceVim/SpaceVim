local window = {}

function window.get_cursor(window_id)
    local winindex = vim.eval("win_id2win(" .. window_id .. ")")
    local w = vim.window(winindex)
    if w == nil then
        vim.command("return [" .. table.concat({0, 0}, ", ") .. "]")
    else
        vim.command("return [" .. table.concat({w.line, w.col}, ", ") .. "]")
    end
end

function window.set_cursor(window_id, pos)
    local winindex = vim.eval("win_id2win(" .. window_id .. ")")
    local w = vim.window(winindex)
    w.line = pos[0]
    w.col = pos[1]
end

function window.close(window_id)
    
end

function window.is_float(winid)
    if winid > 0 then
        local ok, c = pcall(vim.api.nvim_win_get_config, winid)
        if ok and c.col ~= nil then
            return true
        else
            return false
        end
    else
        return false
    end
end


return window


