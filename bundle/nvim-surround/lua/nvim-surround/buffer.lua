local config = require("nvim-surround.config")

local M = {}

--[====================================================================================================================[
                                                Cursor helper functions
--]====================================================================================================================]

-- Gets the position of the cursor, 1-indexed.
---@return position @The position of the cursor.
---@nodiscard
M.get_curpos = function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    return { curpos[1], curpos[2] + 1 }
end

-- Sets the position of the cursor, 1-indexed.
---@param pos position|nil The given position.
M.set_curpos = function(pos)
    if not pos then
        return
    end
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
end

-- Move the cursor to a location in the buffer, depending on the `move_cursor` setting.
---@param pos { first_pos: position, old_pos: position } Various positions in the buffer.
M.restore_curpos = function(pos)
    -- TODO: Add a `last_pos` field for if `move_cursor` is set to "end"
    if config.get_opts().move_cursor == "begin" then
        M.set_curpos(pos.first_pos)
    elseif not config.get_opts().move_cursor then
        M.set_curpos(pos.old_pos)
    end
end

--[====================================================================================================================[
                                                 Mark helper functions
--]====================================================================================================================]

-- Gets the row and column for a mark, 1-indexed, if it exists, returns nil otherwise.
---@param mark string The mark whose position will be returned.
---@return position|nil @The position of the mark.
---@nodiscard
M.get_mark = function(mark)
    local position = vim.api.nvim_buf_get_mark(0, mark)
    if position[1] == 0 then
        return nil
    end
    return { position[1], position[2] + 1 }
end

-- Sets the position of a mark, 1-indexed.
---@param mark string The mark whose position will be returned.
---@param pos position|nil The position that the mark should be set to.
M.set_mark = function(mark, pos)
    if pos and M.is_valid_pos(pos) then
        vim.api.nvim_buf_set_mark(0, mark, pos[1], pos[2] - 1, {})
    end
end

-- Deletes a mark from the buffer.
---@param mark string The mark to be deleted.
M.del_mark = function(mark)
    vim.api.nvim_buf_del_mark(0, mark)
end

-- Deletes multiple marks from the buffer.
---@param marks string[] The marks to be deleted.
M.del_marks = function(marks)
    for _, mark in ipairs(marks) do
        M.del_mark(mark)
    end
end

-- Moves operator marks to not be on whitespace characters.
---@param mark string The mark to potentially move.
M.adjust_mark = function(mark)
    local pos = M.get_mark(mark)
    -- Do nothing if the mark doesn't exist
    if not pos then
        return
    end

    local line = M.get_line(pos[1])
    if mark == "[" then
        while line:sub(pos[2], pos[2]):match("%s") do
            pos[2] = pos[2] + 1
        end
    elseif mark == "]" then
        while line:sub(pos[2], pos[2]):match("%s") do
            pos[2] = pos[2] - 1
        end
    end
    M.set_mark(mark, pos)
end

-- Sets the operator marks according to a given motion.
---@param motion string The given motion.
M.set_operator_marks = function(motion)
    -- Calling operatorfunc may change some variables; cache them here
    local curpos = M.get_curpos()
    local visual_marks = { M.get_mark("<"), M.get_mark(">") }

    -- Clear the [ and ] marks
    M.del_marks({ "[", "]" })
    -- Set the [ and ] marks by calling an operatorfunc
    vim.go.operatorfunc = "v:lua.require'nvim-surround.utils'.NOOP"
    vim.cmd.normal({ args = { "g@" .. motion }, bang = true })
    -- Adjust the marks to not reside on whitespace
    M.adjust_mark("[")
    M.adjust_mark("]")

    -- Restore the cached variables
    M.set_curpos(curpos)
    M.set_mark("<", visual_marks[1])
    M.set_mark(">", visual_marks[2])
end

--[====================================================================================================================[
                                             Byte indexing helper functions
--]====================================================================================================================]

-- Gets the position of the first byte of a character, according to the UTF-8 standard.
---@param pos position The position of any byte in the character.
---@return position @The position of the first byte of the character.
---@nodiscard
M.get_first_byte = function(pos)
    local byte = string.byte(M.get_line(pos[1]):sub(pos[2], pos[2]))
    if not byte then
        return pos
    end
    -- See https://en.wikipedia.org/wiki/UTF-8#Encoding
    while byte >= 0x80 and byte < 0xc0 do
        pos[2] = pos[2] - 1
        byte = string.byte(M.get_line(pos[1]):sub(pos[2], pos[2]))
    end
    return pos
end

-- Gets the position of the last byte of a character, according to the UTF-8 standard.
---@param pos position The position of the beginning of the character.
---@return position @The position of the last byte of the character.
---@nodiscard
M.get_last_byte = function(pos)
    local byte = string.byte(M.get_line(pos[1]):sub(pos[2], pos[2]))
    if not byte then
        return pos
    end
    -- See https://en.wikipedia.org/wiki/UTF-8#Encoding
    if byte >= 0xf0 then
        pos[2] = pos[2] + 3
    elseif byte >= 0xe0 then
        pos[2] = pos[2] + 2
    elseif byte >= 0xc0 then
        pos[2] = pos[2] + 1
    end
    return pos
end

--[====================================================================================================================[
                                            Buffer contents helper functions
--]====================================================================================================================]

-- Returns whether or not the position is inside the current buffer.
---@param pos position The input position.
---@return boolean @Whether or not the position is inside the buffer.
---@nodiscard
M.is_valid_pos = function(pos)
    if pos[1] < 1 or pos[1] > vim.api.nvim_buf_line_count(0) then
        return false
    end
    if pos[2] < 1 or pos[2] > #M.get_line(pos[1]) then
        return false
    end
    return true
end

-- Gets a set of lines from the buffer, inclusive and 1-indexed.
---@param start integer The starting line.
---@param stop integer The final line.
---@return text @A list of lines from the buffer.
---@nodiscard
M.get_lines = function(start, stop)
    return vim.api.nvim_buf_get_lines(0, start - 1, stop, false)
end

-- Gets a line from the buffer, 1-indexed.
---@param line_num integer The number of the line to be retrieved.
---@return string @The contents of the line that was retrieved.
---@nodiscard
M.get_line = function(line_num)
    return M.get_lines(line_num, line_num)[1]
end

-- Returns whether a position comes before another in a buffer, true if the positions are the same.
---@param pos1 position The first position.
---@param pos2 position The second position.
---@return boolean @Whether or not pos1 comes before pos2.
---@nodiscard
M.comes_before = function(pos1, pos2)
    return pos1[1] < pos2[1] or pos1[1] == pos2[1] and pos1[2] <= pos2[2]
end

-- Returns whether a position is contained within a pair of selections, inclusive.
---@param pos position The given position.
---@param selections selections The given selections
---@return boolean @Whether the position is contained within the selections.
---@nodiscard
M.is_inside = function(pos, selections)
    return M.comes_before(selections.left.first_pos, pos) and M.comes_before(pos, selections.right.last_pos)
end

-- Gets a selection of text from the buffer.
---@param selection selection The selection of text to be retrieved.
---@return text @The text from the buffer.
---@nodiscard
M.get_text = function(selection)
    local first_pos, last_pos = selection.first_pos, selection.last_pos
    last_pos[2] = math.min(last_pos[2], #M.get_line(last_pos[1]))
    return vim.api.nvim_buf_get_text(0, first_pos[1] - 1, first_pos[2] - 1, last_pos[1] - 1, last_pos[2], {})
end

-- Adds some text into the buffer at a given position.
---@param pos position The position to be inserted at.
---@param text text The text to be added.
M.insert_text = function(pos, text)
    pos[2] = math.min(pos[2], #M.get_line(pos[1]) + 1)
    vim.api.nvim_buf_set_text(0, pos[1] - 1, pos[2] - 1, pos[1] - 1, pos[2] - 1, text)
end

-- Deletes a given selection from the buffer.
---@param selection selection The given selection.
M.delete_selection = function(selection)
    local first_pos, last_pos = selection.first_pos, selection.last_pos
    vim.api.nvim_buf_set_text(0, first_pos[1] - 1, first_pos[2] - 1, last_pos[1] - 1, last_pos[2], {})
end

-- Replaces a given selection with a set of lines.
---@param selection selection|nil The given selection.
---@param text text The given text to replace the selection.
M.change_selection = function(selection, text)
    if not selection then
        return
    end
    local first_pos, last_pos = selection.first_pos, selection.last_pos
    vim.api.nvim_buf_set_text(0, first_pos[1] - 1, first_pos[2] - 1, last_pos[1] - 1, last_pos[2], text)
end

--[====================================================================================================================[
                                               Highlight helper functions
--]====================================================================================================================]

-- Highlights a given selection.
---@param selection selection|nil The selection to be highlighted.
M.highlight_selection = function(selection)
    if not selection then
        return
    end
    local namespace = vim.api.nvim_create_namespace("NvimSurround")

    vim.highlight.range(
        0,
        namespace,
        "NvimSurroundHighlight",
        { selection.first_pos[1] - 1, selection.first_pos[2] - 1 },
        { selection.last_pos[1] - 1, selection.last_pos[2] - 1 },
        { inclusive = true }
    )
    -- Force the screen to highlight the text immediately
    vim.cmd.redraw()
end

-- Clears all nvim-surround highlights for the buffer.
M.clear_highlights = function()
    local namespace = vim.api.nvim_create_namespace("NvimSurround")
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
    -- Force the screen to clear the highlight immediately
    vim.cmd.redraw()
end

return M
