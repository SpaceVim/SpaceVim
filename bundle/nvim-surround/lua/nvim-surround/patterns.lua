local buffer = require("nvim-surround.buffer")

local M = {}

-- Converts a 1D index into the buffer to the corresponding 2D buffer position.
---@param index integer The index of the character in the string.
---@return position @The position of the character in the buffer.
---@nodiscard
M.index_to_pos = function(index)
    local buffer_text = table.concat(buffer.get_lines(1, -1), "\n")
    -- Counts the number of newline characters, plus one for the final character before the current line
    local lnum = select(2, buffer_text:sub(1, math.max(1, index - 1)):gsub("\n", "\n")) + 1
    -- Special case for first line, as there are no newline characters preceding it
    if lnum == 1 then
        return { 1, index }
    end
    local col = index - #table.concat(buffer.get_lines(1, lnum - 1), "\n") - 1
    return { lnum, col }
end

-- Converts a 2D position in the buffer to the corresponding 1D string index.
---@param pos position The position in the buffer.
---@return integer @The index of the character into the buffer.
---@nodiscard
M.pos_to_index = function(pos)
    -- Special case for first line, as there are no newline characters preceding it
    if pos[1] == 1 then
        return pos[2]
    end
    return #table.concat(buffer.get_lines(1, pos[1] - 1), "\n") + pos[2] + 1
end

-- Expands a selection to properly contain multi-byte characters.
---@param selection selection The given selection.
---@return selection @The adjusted selection, handling multi-byte characters.
---@nodiscard
M.adjust_selection = function(selection)
    selection.first_pos = buffer.get_first_byte(selection.first_pos)
    selection.last_pos = buffer.get_last_byte(selection.last_pos)
    return selection
end

-- Returns a selection in the buffer based on a Lua pattern.
---@param find string The Lua pattern to find in the buffer.
---@return selection|nil @The closest selection matching the pattern, if any.
---@nodiscard
M.get_selection = function(find)
    -- Get the current cursor position, buffer contents
    local curpos = buffer.get_curpos()
    local buffer_text = table.concat(buffer.get_lines(1, -1), "\n")
    -- Find which character the cursor is in the file
    local cursor_index = M.pos_to_index(curpos)
    -- Find the character positions of the pattern in the file (after/on the cursor)
    local a_first, a_last = buffer_text:find(find, cursor_index)
    -- Find the character positions of the pattern in the file (before the cursor)
    local b_first, b_last
    -- Linewise search for the pattern before/on the cursor
    for lnum = curpos[1], 1, -1 do
        -- Get the file contents from the first line to current line
        local cur_text = table.concat(buffer.get_lines(1, lnum - 1), "\n")
        -- Find the character positions of the pattern in the file (before the cursor)
        b_first, b_last = buffer_text:find(find, #cur_text + 1)
        if b_first and b_first <= cursor_index then
            break
        end
    end
    -- If no match found, return the after one, if it exists
    if not b_first or not b_last then
        return a_first
            and a_last
            and M.adjust_selection({
                first_pos = M.index_to_pos(a_first),
                last_pos = M.index_to_pos(a_last),
            })
    end
    -- Adjust the selection character-wise
    local start_col, end_col = cursor_index, b_first
    b_first, b_last = nil, nil
    for index = start_col, end_col, -1 do
        local c_first, c_last = buffer_text:find(find, index)
        -- Validate if there is a current match
        if c_last then
            -- If no match yet or the current match is "better", use the current match
            if
                not (b_first and b_last) -- No match yet
                or (b_last == c_last) -- Extending current match
                or (cursor_index < b_first and c_first < b_first) -- Current is closer to cursor, after case
                or (b_last < cursor_index and b_last < c_last) -- Current is closer to cursor, before case
            then
                b_first, b_last = c_first, c_last
            end
        end
    end
    -- If the cursor is inside the range then return it
    if b_last and b_first and b_last >= cursor_index then
        return M.adjust_selection({
            first_pos = M.index_to_pos(b_first),
            last_pos = M.index_to_pos(b_last),
        })
    end
    -- Else if there's a range found after the cursor, return it
    if a_first and a_last then
        return M.adjust_selection({
            first_pos = M.index_to_pos(a_first),
            last_pos = M.index_to_pos(a_last),
        })
    end
    -- Otherwise return the range found before the cursor, if one exists
    if b_first and b_last then
        return M.adjust_selection({
            first_pos = M.index_to_pos(b_first),
            last_pos = M.index_to_pos(b_last),
        })
    end
end

-- Finds the start and end indices for the given match groups.
---@param selection selection The parent selection encompassing the delimiter pair.
---@param pattern string The given Lua pattern to extract match groups from.
---@return selections|nil @The selections for the left and right delimiters.
---@nodiscard
M.get_selections = function(selection, pattern)
    local offset = M.pos_to_index(selection.first_pos)
    local str = table.concat(buffer.get_text(selection), "\n")
    -- Get the surrounding pair, and the start/end indices
    local ok, _, left_delimiter, first_index, right_delimiter, last_index = str:find(pattern)
    -- Validate that a match was found
    if not ok then
        return nil
    end
    -- Validate that all four match groups are present
    if not last_index then
        vim.notify(
            "Four match groups must be present in the Lua pattern, see :h nvim-surround.config.get_selections().",
            vim.log.levels.ERROR
        )
        return nil
    end
    -- Validate that the second and fourth match groups are empty
    if type(first_index) ~= "number" or type(last_index) ~= "number" then
        vim.notify(
            "The second and last capture groups must be empty, see :h nvim-surround.config.get_selections().",
            vim.log.levels.ERROR
        )
        return nil
    end

    -- If delimiter does not exist, set the length to zero
    local left_len = type(left_delimiter) == "string" and #left_delimiter or 0
    local right_len = type(right_delimiter) == "string" and #right_delimiter or 0
    -- If the left or right delimiters are empty, return the equivalent of an empty selection
    local selections = {
        ---@cast first_index integer
        ---@cast last_index integer
        left = M.adjust_selection({
            first_pos = M.index_to_pos(offset + first_index - left_len - 1),
            last_pos = M.index_to_pos(offset + first_index - 2),
        }),
        right = M.adjust_selection({
            first_pos = M.index_to_pos(offset + last_index - right_len - 1),
            last_pos = M.index_to_pos(offset + last_index - 2),
        }),
    }
    -- Handle special case where the column is invalid
    if selections.left.last_pos[2] > #buffer.get_line(selections.left.last_pos[1]) then
        selections.left.last_pos[1] = selections.left.last_pos[1] + 1
        selections.left.last_pos[2] = 0
    end
    if selections.right.last_pos[2] > #buffer.get_line(selections.right.last_pos[1]) then
        selections.right.last_pos[1] = selections.right.last_pos[1] + 1
        selections.right.last_pos[2] = 0
    end
    return selections
end

return M
