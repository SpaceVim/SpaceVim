local buffer = require("nvim-surround.buffer")
local config = require("nvim-surround.config")

local M = {}

-- Determines whether the input character is a quote character.
---@param char string|nil The input character.
---@return boolean @Whether or not char is a quote character.
---@nodiscard
M.is_quote = function(char)
    return char == "'" or char == '"' or char == "`"
end

-- Gets a selection based on a given motion.
---@param motion string The provided motion.
---@return selection|nil @The selection that represents the text-object.
---@nodiscard
M.get_selection = function(motion)
    local char = config.get_alias(motion:sub(2, 2))
    local curpos = buffer.get_curpos()

    buffer.set_operator_marks(motion)
    -- Adjust the marks to reside on non-whitespace characters
    buffer.adjust_mark("[")
    buffer.adjust_mark("]")

    -- Get the row and column of the first and last characters of the selection
    local first_pos = buffer.get_mark("[")
    local last_pos = buffer.get_mark("]")
    -- If a selection is found surrounding the cursor or after it, then return
    if first_pos and last_pos and buffer.comes_before(first_pos, last_pos) then
        -- Restore the cursor position
        buffer.set_curpos(curpos)
        return {
            first_pos = first_pos,
            last_pos = last_pos,
        }
    end

    -- Since no selection was found around/after the cursor, we look behind
    if char == "t" then -- Handle special case with lookbehind for HTML tags (search for `>` instead of `t`)
        vim.fn.searchpos(">", "bcW")
    elseif M.is_quote(char) then -- Handle special case with lookbehind for quote characters (stay in current line)
        if vim.fn.searchpos(char, "bncW")[1] == curpos[1] then
            vim.fn.searchpos(char, "bcW")
        end
    elseif char then -- General case, jump to the character
        vim.fn.searchpos(char, "bcW")
    end

    buffer.set_operator_marks(motion)
    -- Adjust the marks to reside on non-whitespace characters
    buffer.adjust_mark("[")
    buffer.adjust_mark("]")

    -- Get the row and column of the first and last characters of the selection
    first_pos = buffer.get_mark("[")
    last_pos = buffer.get_mark("]")
    -- Restore the cursor position
    buffer.set_curpos(curpos)
    -- Return nil if either endpoint of the selection do not exist, or no match is found (marks out of order)
    if not first_pos or not last_pos or not buffer.comes_before(first_pos, last_pos) then
        return nil
    end
    return {
        first_pos = first_pos,
        last_pos = last_pos,
    }
end

return M
