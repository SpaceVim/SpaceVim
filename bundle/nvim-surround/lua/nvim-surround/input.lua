local M = {}

-- Gets a character input from the user.
---@return string|nil @The input character, or nil if a control character is pressed.
---@nodiscard
M.get_char = function()
    local ok, char = pcall(vim.fn.getcharstr)
    -- Return nil if input is cancelled (e.g. <C-c> or <Esc>)
    if not ok or char == "\27" then
        return nil
    end
    return char
end

-- Gets a string input from the user.
---@param prompt string The input prompt.
---@return string|nil @The user input.
---@nodiscard
M.get_input = function(prompt)
    -- Since `vim.fn.input()` does not handle keyboard interrupts, we use a protected call to detect <C-c>
    local ok, result = pcall(vim.fn.input, { prompt = prompt, cancelreturn = vim.NIL })
    if ok and result ~= vim.NIL then
        return result
    end
end

return M
