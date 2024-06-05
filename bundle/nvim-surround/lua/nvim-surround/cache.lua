local M = {}

-- These variables hold cache values for dot-repeating the three actions

---@type { delimiters: string[][]|nil, line_mode: boolean }
M.normal = {}
---@type { char: string }
M.delete = {}
---@type { del_char: string, add_delimiters: add_func, line_mode: boolean }
M.change = {}

-- Sets the callback function for dot-repeating.
---@param func_name string A string representing the callback function's name.
M.set_callback = function(func_name)
    vim.go.operatorfunc = "v:lua.require'nvim-surround.utils'.NOOP"
    vim.cmd.normal({ "g@l", bang = true })
    vim.go.operatorfunc = func_name
end

return M
