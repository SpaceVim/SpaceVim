local window = {}

function window.get_cursor(window_id)
    local winindex = vim.eval("win_id2win(" .. window_id .. ")")
    local w = vim.window(winindex)
    if w == nil then
        return {0, 0}
    else
        return {w.line, w.col}
    end
end


return window


