local M = {}

function M.get_cursor(window_id)
    local winindex = vim.eval("win_id2win(" .. window_id .. ")")
    local w = vim.window(winindex)
    if w == nil then
        vim.command("return [" .. table.concat({0, 0}, ", ") .. "]")
    else
        vim.command("return [" .. table.concat({w.line, w.col}, ", ") .. "]")
    end
end

function M.set_cursor(window_id, pos)
    local winindex = vim.eval("win_id2win(" .. window_id .. ")")
    local w = vim.window(winindex)
    w.line = pos[0]
    w.col = pos[1]
end

function M.close(window_id)
    
end


-- neovim winnr('$') includes floating windows
function M.is_last_win()
  local win_list = vim.api.nvim_tabpage_list_wins(0)
  local num = #win_list
  for _, v in ipairs(win_list) do
    if M.is_float(v) then
      num = num - 1
    end
  end
  return num == 1
  
end

function M.is_float(winid)
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


return M


