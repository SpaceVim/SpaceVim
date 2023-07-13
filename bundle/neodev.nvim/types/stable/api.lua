---@meta

---@class vim.api
vim.api = {}


-- Find files in runtime directories
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {pat}   pattern of files to search for
--   • {all}   whether to return all matches or only the first
--   • {opts}  is_lua: only search lua subdirs
-- 
-- Return: ~
--     list of absolute paths to the found files
--- @param opts? table<string, any>
function vim.api.nvim__get_runtime(pat, all, opts) end

-- Returns object given as argument.
-- 
-- This API function is used for testing. One should not rely on its presence
-- in plugins.
-- 
-- Parameters: ~
--   • {obj}  Object to return.
-- 
-- Return: ~
--     its argument.
function vim.api.nvim__id(obj) end

-- Returns array given as argument.
-- 
-- This API function is used for testing. One should not rely on its presence
-- in plugins.
-- 
-- Parameters: ~
--   • {arr}  Array to return.
-- 
-- Return: ~
--     its argument.
function vim.api.nvim__id_array(arr) end

-- Returns dictionary given as argument.
-- 
-- This API function is used for testing. One should not rely on its presence
-- in plugins.
-- 
-- Parameters: ~
--   • {dct}  Dictionary to return.
-- 
-- Return: ~
--     its argument.
function vim.api.nvim__id_dictionary(dct) end

-- Returns floating-point value given as argument.
-- 
-- This API function is used for testing. One should not rely on its presence
-- in plugins.
-- 
-- Parameters: ~
--   • {flt}  Value to return.
-- 
-- Return: ~
--     its argument.
function vim.api.nvim__id_float(flt) end

-- NB: if your UI doesn't use hlstate, this will not return hlstate first
-- time.
--- @param col number
function vim.api.nvim__inspect_cell(grid, row, col) end

-- Gets internal stats.
-- 
-- Return: ~
--     Map of various internal stats.
function vim.api.nvim__stats() end

-- Adds a highlight to buffer.
-- 
-- Useful for plugins that dynamically generate highlights to a buffer (like
-- a semantic highlighter or linter). The function adds a single highlight to
-- a buffer. Unlike |matchaddpos()| highlights follow changes to line
-- numbering (as lines are inserted/removed above the highlighted line), like
-- signs and marks do.
-- 
-- Namespaces are used for batch deletion/updating of a set of highlights. To
-- create a namespace, use |nvim_create_namespace()| which returns a
-- namespace id. Pass it in to this function as `ns_id` to add highlights to
-- the namespace. All highlights in the same namespace can then be cleared
-- with single call to |nvim_buf_clear_namespace()|. If the highlight never
-- will be deleted by an API call, pass `ns_id = -1`.
-- 
-- As a shorthand, `ns_id = 0` can be used to create a new namespace for the
-- highlight, the allocated id is then returned. If `hl_group` is the empty
-- string no highlight is added, but a new `ns_id` is still returned. This is
-- supported for backwards compatibility, new code should use
-- |nvim_create_namespace()| to create a new empty namespace.
-- 
-- Parameters: ~
--   • {buffer}     Buffer handle, or 0 for current buffer
--   • {ns_id}      namespace to use or -1 for ungrouped highlight
--   • {hl_group}   Name of the highlight group to use
--   • {line}       Line to highlight (zero-indexed)
--   • {col_start}  Start of (byte-indexed) column range to highlight
--   • {col_end}    End of (byte-indexed) column range to highlight, or -1 to
--                  highlight to end of line
-- 
-- Return: ~
--     The ns_id that was used
--- @param buffer buffer
--- @param ns_id number
--- @param hl_group string
--- @param line number
--- @param col_start number
--- @param col_end number
--- @return number
function vim.api.nvim_buf_add_highlight(buffer, ns_id, hl_group, line, col_start, col_end) end

-- Activates buffer-update events on a channel, or as Lua callbacks.
-- 
-- Example (Lua): capture buffer updates in a global `events` variable (use "print(vim.inspect(events))" to see its contents): 
-- ```lua
--   events = {}
--   vim.api.nvim_buf_attach(0, false, {
--     on_lines=function(...) table.insert(events, {...}) end})
-- ```
-- 
-- Parameters: ~
--   • {buffer}       Buffer handle, or 0 for current buffer
--   • {send_buffer}  True if the initial notification should contain the
--                    whole buffer: first notification will be
--                    `nvim_buf_lines_event`. Else the first notification
--                    will be `nvim_buf_changedtick_event`. Not for Lua
--                    callbacks.
--   • {opts}         Optional parameters.
--                    • on_lines: Lua callback invoked on change. Return `true` to detach. Args:
--                      • the string "lines"
--                      • buffer handle
--                      • b:changedtick
--                      • first line that changed (zero-indexed)
--                      • last line that was changed
--                      • last line in the updated range
--                      • byte count of previous contents
--                      • deleted_codepoints (if `utf_sizes` is true)
--                      • deleted_codeunits (if `utf_sizes` is true)
-- 
--                    • on_bytes: lua callback invoked on change. This
--                      callback receives more granular information about the
--                      change compared to on_lines. Return `true` to detach. Args:
--                      • the string "bytes"
--                      • buffer handle
--                      • b:changedtick
--                      • start row of the changed text (zero-indexed)
--                      • start column of the changed text
--                      • byte offset of the changed text (from the start of
--                        the buffer)
--                      • old end row of the changed text
--                      • old end column of the changed text
--                      • old end byte length of the changed text
--                      • new end row of the changed text
--                      • new end column of the changed text
--                      • new end byte length of the changed text
-- 
--                    • on_changedtick: Lua callback invoked on changedtick
--                      increment without text change. Args:
--                      • the string "changedtick"
--                      • buffer handle
--                      • b:changedtick
-- 
--                    • on_detach: Lua callback invoked on detach. Args:
--                      • the string "detach"
--                      • buffer handle
-- 
--                    • on_reload: Lua callback invoked on reload. The entire
--                      buffer content should be considered changed. Args:
--                      • the string "reload"
--                      • buffer handle
-- 
--                    • utf_sizes: include UTF-32 and UTF-16 size of the
--                      replaced region, as args to `on_lines`.
--                    • preview: also attach to command preview (i.e.
--                      'inccommand') events.
-- 
-- Return: ~
--     False if attach failed (invalid parameter, or buffer isn't loaded);
--     otherwise True. TODO: LUA_API_NO_EVAL
-- 
-- See also: ~
--   • |nvim_buf_detach()|
--   • |api-buffer-updates-lua|
--- @param buffer buffer
--- @param send_buffer boolean
--- @param opts table<string, any>
--- @return boolean
function vim.api.nvim_buf_attach(buffer, send_buffer, opts) end

-- call a function with buffer as temporary current buffer
-- 
-- This temporarily switches current buffer to "buffer". If the current
-- window already shows "buffer", the window is not switched If a window
-- inside the current tabpage (including a float) already shows the buffer
-- One of these windows will be set as current window temporarily. Otherwise
-- a temporary scratch window (called the "autocmd window" for historical
-- reasons) will be used.
-- 
-- This is useful e.g. to call vimL functions that only work with the current
-- buffer/window currently, like |termopen()|.
-- 
-- Attributes: ~
--     Lua |vim.api| only
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {fun}     Function to call inside the buffer (currently lua callable
--               only)
-- 
-- Return: ~
--     Return value of function. NB: will deepcopy lua values currently, use
--     upvalues to send lua references in and out.
--- @param buffer buffer
--- @param fun fun()
--- @return object
function vim.api.nvim_buf_call(buffer, fun) end

-- Clears |namespace|d objects (highlights, |extmarks|, virtual text) from a
-- region.
-- 
-- Lines are 0-indexed. |api-indexing| To clear the namespace in the entire
-- buffer, specify line_start=0 and line_end=-1.
-- 
-- Parameters: ~
--   • {buffer}      Buffer handle, or 0 for current buffer
--   • {ns_id}       Namespace to clear, or -1 to clear all namespaces.
--   • {line_start}  Start of range of lines to clear
--   • {line_end}    End of range of lines to clear (exclusive) or -1 to
--                   clear to end of buffer.
--- @param buffer buffer
--- @param ns_id number
--- @param line_start number
--- @param line_end number
function vim.api.nvim_buf_clear_namespace(buffer, ns_id, line_start, line_end) end

-- Creates a buffer-local command |user-commands|.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer.
-- 
-- See also: ~
--   • nvim_create_user_command
--- @param buffer buffer
--- @param name string
--- @param command object
--- @param opts? table<string, any>
function vim.api.nvim_buf_create_user_command(buffer, name, command, opts) end

-- Removes an |extmark|.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {ns_id}   Namespace id from |nvim_create_namespace()|
--   • {id}      Extmark id
-- 
-- Return: ~
--     true if the extmark was found, else false
--- @param buffer buffer
--- @param ns_id number
--- @param id number
--- @return boolean
function vim.api.nvim_buf_del_extmark(buffer, ns_id, id) end

-- Unmaps a buffer-local |mapping| for the given mode.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- See also: ~
--   • |nvim_del_keymap()|
--- @param buffer buffer
--- @param mode string
--- @param lhs string
function vim.api.nvim_buf_del_keymap(buffer, mode, lhs) end

-- Deletes a named mark in the buffer. See |mark-motions|.
-- 
-- Note:
--     only deletes marks set in the buffer, if the mark is not set in the
--     buffer it will return false.
-- 
-- Parameters: ~
--   • {buffer}  Buffer to set the mark on
--   • {name}    Mark name
-- 
-- Return: ~
--     true if the mark was deleted, else false.
-- 
-- See also: ~
--   • |nvim_buf_set_mark()|
--   • |nvim_del_mark()|
--- @param buffer buffer
--- @param name string
--- @return boolean
function vim.api.nvim_buf_del_mark(buffer, name) end

-- Delete a buffer-local user-defined command.
-- 
-- Only commands created with |:command-buffer| or
-- |nvim_buf_create_user_command()| can be deleted with this function.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer.
--   • {name}    Name of the command to delete.
--- @param buffer buffer
--- @param name string
function vim.api.nvim_buf_del_user_command(buffer, name) end

-- Removes a buffer-scoped (b:) variable
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Variable name
--- @param buffer buffer
--- @param name string
function vim.api.nvim_buf_del_var(buffer, name) end

-- Deletes the buffer. See |:bwipeout|
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {opts}    Optional parameters. Keys:
--               • force: Force deletion and ignore unsaved changes.
--               • unload: Unloaded only, do not delete. See |:bunload|
--- @param buffer buffer
--- @param opts table<string, any>
function vim.api.nvim_buf_delete(buffer, opts) end

-- Gets a changed tick of a buffer
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- Return: ~
--     `b:changedtick` value.
--- @param buffer buffer
--- @return number
function vim.api.nvim_buf_get_changedtick(buffer) end

-- Gets a map of buffer-local |user-commands|.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {opts}    Optional parameters. Currently not used.
-- 
-- Return: ~
--     Map of maps describing commands.
--- @param buffer buffer
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_buf_get_commands(buffer, opts) end

-- Gets the position (0-indexed) of an |extmark|.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {ns_id}   Namespace id from |nvim_create_namespace()|
--   • {id}      Extmark id
--   • {opts}    Optional parameters. Keys:
--               • details: Whether to include the details dict
--               • hl_name: Whether to include highlight group name instead
--                 of id, true if omitted
-- 
-- Return: ~
--     0-indexed (row, col) tuple or empty list () if extmark id was absent
--- @param buffer buffer
--- @param ns_id number
--- @param id number
--- @param opts table<string, any>
--- @return any[]
function vim.api.nvim_buf_get_extmark_by_id(buffer, ns_id, id, opts) end

-- Gets |extmarks| in "traversal order" from a |charwise| region defined by
-- buffer positions (inclusive, 0-indexed |api-indexing|).
-- 
-- Region can be given as (row,col) tuples, or valid extmark ids (whose
-- positions define the bounds). 0 and -1 are understood as (0,0) and (-1,-1)
-- respectively, thus the following are equivalent: 
-- ```lua
--   vim.api.nvim_buf_get_extmarks(0, my_ns, 0, -1, {})
--   vim.api.nvim_buf_get_extmarks(0, my_ns, {0,0}, {-1,-1}, {})
-- ```
-- 
-- If `end` is less than `start`, traversal works backwards. (Useful with
-- `limit`, to get the first marks prior to a given position.)
-- 
-- Example: 
-- ```lua
--   local api = vim.api
--   local pos = api.nvim_win_get_cursor(0)
--   local ns  = api.nvim_create_namespace('my-plugin')
--   -- Create new extmark at line 1, column 1.
--   local m1  = api.nvim_buf_set_extmark(0, ns, 0, 0, {})
--   -- Create new extmark at line 3, column 1.
--   local m2  = api.nvim_buf_set_extmark(0, ns, 2, 0, {})
--   -- Get extmarks only from line 3.
--   local ms  = api.nvim_buf_get_extmarks(0, ns, {2,0}, {2,0}, {})
--   -- Get all marks in this buffer + namespace.
--   local all = api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
--   print(vim.inspect(ms))
-- ```
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {ns_id}   Namespace id from |nvim_create_namespace()| or -1 for all
--               namespaces
--   • {start}   Start of range: a 0-indexed (row, col) or valid extmark id
--               (whose position defines the bound). |api-indexing|
--   • {end}     End of range (inclusive): a 0-indexed (row, col) or valid
--               extmark id (whose position defines the bound).
--               |api-indexing|
--   • {opts}    Optional parameters. Keys:
--               • limit: Maximum number of marks to return
--               • details: Whether to include the details dict
--               • hl_name: Whether to include highlight group name instead
--                 of id, true if omitted
--               • type: Filter marks by type: "highlight", "sign",
--                 "virt_text" and "virt_lines"
-- 
-- Return: ~
--     List of [extmark_id, row, col] tuples in "traversal order".
--- @param buffer buffer
--- @param ns_id number
--- @param start object
--- @param end_ object
--- @param opts table<string, any>
--- @return any[]
function vim.api.nvim_buf_get_extmarks(buffer, ns_id, start, end_, opts) end

-- Gets a list of buffer-local |mapping| definitions.
-- 
-- Parameters: ~
--   • {mode}    Mode short-name ("n", "i", "v", ...)
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- Return: ~
--     Array of |maparg()|-like dictionaries describing mappings. The
--     "buffer" key holds the associated buffer handle.
--- @param buffer buffer
--- @param mode string
--- @return any[]
function vim.api.nvim_buf_get_keymap(buffer, mode) end

-- Gets a line-range from the buffer.
-- 
-- Indexing is zero-based, end-exclusive. Negative indices are interpreted as
-- length+1+index: -1 refers to the index past the end. So to get the last
-- element use start=-2 and end=-1.
-- 
-- Out-of-bounds indices are clamped to the nearest valid value, unless
-- `strict_indexing` is set.
-- 
-- Parameters: ~
--   • {buffer}           Buffer handle, or 0 for current buffer
--   • {start}            First line index
--   • {end}              Last line index, exclusive
--   • {strict_indexing}  Whether out-of-bounds should be an error.
-- 
-- Return: ~
--     Array of lines, or empty array for unloaded buffer.
--- @param buffer buffer
--- @param start number
--- @param end_ number
--- @param strict_indexing boolean
--- @return string[]
function vim.api.nvim_buf_get_lines(buffer, start, end_, strict_indexing) end

-- Returns a tuple (row,col) representing the position of the named mark. See
-- |mark-motions|.
-- 
-- Marks are (1,0)-indexed. |api-indexing|
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Mark name
-- 
-- Return: ~
--     (row, col) tuple, (0, 0) if the mark is not set, or is an
--     uppercase/file mark set in another buffer.
-- 
-- See also: ~
--   • |nvim_buf_set_mark()|
--   • |nvim_buf_del_mark()|
--- @param buffer buffer
--- @param name string
--- @return number[]
function vim.api.nvim_buf_get_mark(buffer, name) end

-- Gets the full file name for the buffer
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- Return: ~
--     Buffer name
--- @param buffer buffer
--- @return string
function vim.api.nvim_buf_get_name(buffer) end

-- Returns the byte offset of a line (0-indexed). |api-indexing|
-- 
-- Line 1 (index=0) has offset 0. UTF-8 bytes are counted. EOL is one byte.
-- 'fileformat' and 'fileencoding' are ignored. The line index just after the
-- last line gives the total byte-count of the buffer. A final EOL byte is
-- counted if it would be written, see 'eol'.
-- 
-- Unlike |line2byte()|, throws error for out-of-bounds indexing. Returns -1
-- for unloaded buffer.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {index}   Line index
-- 
-- Return: ~
--     Integer byte offset, or -1 for unloaded buffer.
--- @param buffer buffer
--- @param index number
--- @return number
function vim.api.nvim_buf_get_offset(buffer, index) end

-- Gets a buffer option value
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Option name
-- 
-- Return: ~
--     Option value
--- @param buffer buffer
--- @param name string
--- @return object
function vim.api.nvim_buf_get_option(buffer, name) end

-- Gets a range from the buffer.
-- 
-- This differs from |nvim_buf_get_lines()| in that it allows retrieving only
-- portions of a line.
-- 
-- Indexing is zero-based. Row indices are end-inclusive, and column indices
-- are end-exclusive.
-- 
-- Prefer |nvim_buf_get_lines()| when retrieving entire lines.
-- 
-- Parameters: ~
--   • {buffer}     Buffer handle, or 0 for current buffer
--   • {start_row}  First line index
--   • {start_col}  Starting column (byte offset) on first line
--   • {end_row}    Last line index, inclusive
--   • {end_col}    Ending column (byte offset) on last line, exclusive
--   • {opts}       Optional parameters. Currently unused.
-- 
-- Return: ~
--     Array of lines, or empty array for unloaded buffer.
--- @param buffer buffer
--- @param start_row number
--- @param start_col number
--- @param end_row number
--- @param end_col number
--- @param opts table<string, any>
--- @return string[]
function vim.api.nvim_buf_get_text(buffer, start_row, start_col, end_row, end_col, opts) end

-- Gets a buffer-scoped (b:) variable.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Variable name
-- 
-- Return: ~
--     Variable value
--- @param buffer buffer
--- @param name string
--- @return object
function vim.api.nvim_buf_get_var(buffer, name) end

-- Checks if a buffer is valid and loaded. See |api-buffer| for more info
-- about unloaded buffers.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- Return: ~
--     true if the buffer is valid and loaded, false otherwise.
--- @param buffer buffer
--- @return boolean
function vim.api.nvim_buf_is_loaded(buffer) end

-- Checks if a buffer is valid.
-- 
-- Note:
--     Even if a buffer is valid it may have been unloaded. See |api-buffer|
--     for more info about unloaded buffers.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- Return: ~
--     true if the buffer is valid, false otherwise.
--- @param buffer buffer
--- @return boolean
function vim.api.nvim_buf_is_valid(buffer) end

-- Returns the number of lines in the given buffer.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- Return: ~
--     Line count, or 0 for unloaded buffer. |api-buffer|
--- @param buffer buffer
--- @return number
function vim.api.nvim_buf_line_count(buffer) end

-- Creates or updates an |extmark|.
-- 
-- By default a new extmark is created when no id is passed in, but it is
-- also possible to create a new mark by passing in a previously unused id or
-- move an existing mark by passing in its id. The caller must then keep
-- track of existing and unused ids itself. (Useful over RPC, to avoid
-- waiting for the return value.)
-- 
-- Using the optional arguments, it is possible to use this to highlight a
-- range of text, and also to associate virtual text to the mark.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {ns_id}   Namespace id from |nvim_create_namespace()|
--   • {line}    Line where to place the mark, 0-based. |api-indexing|
--   • {col}     Column where to place the mark, 0-based. |api-indexing|
--   • {opts}    Optional parameters.
--               • id : id of the extmark to edit.
--               • end_row : ending line of the mark, 0-based inclusive.
--               • end_col : ending col of the mark, 0-based exclusive.
--               • hl_group : name of the highlight group used to highlight
--                 this mark.
--               • hl_eol : when true, for a multiline highlight covering the
--                 EOL of a line, continue the highlight for the rest of the
--                 screen line (just like for diff and cursorline highlight).
--               • virt_text : virtual text to link to this mark. A list of
--                 [text, highlight] tuples, each representing a text chunk
--                 with specified highlight. `highlight` element can either
--                 be a single highlight group, or an array of multiple
--                 highlight groups that will be stacked (highest priority
--                 last). A highlight group can be supplied either as a
--                 string or as an integer, the latter which can be obtained
--                 using |nvim_get_hl_id_by_name()|.
--               • virt_text_pos : position of virtual text. Possible values:
--                 • "eol": right after eol character (default)
--                 • "overlay": display over the specified column, without
--                   shifting the underlying text.
--                 • "right_align": display right aligned in the window.
-- 
--               • virt_text_win_col : position the virtual text at a fixed
--                 window column (starting from the first text column)
--               • virt_text_hide : hide the virtual text when the background
--                 text is selected or hidden due to horizontal scroll
--                 'nowrap'
--               • hl_mode : control how highlights are combined with the
--                 highlights of the text. Currently only affects virt_text
--                 highlights, but might affect `hl_group` in later versions.
--                 • "replace": only show the virt_text color. This is the
--                   default
--                 • "combine": combine with background text color
--                 • "blend": blend with background text color.
-- 
--               • virt_lines : virtual lines to add next to this mark This
--                 should be an array over lines, where each line in turn is
--                 an array over [text, highlight] tuples. In general, buffer
--                 and window options do not affect the display of the text.
--                 In particular 'wrap' and 'linebreak' options do not take
--                 effect, so the number of extra screen lines will always
--                 match the size of the array. However the 'tabstop' buffer
--                 option is still used for hard tabs. By default lines are
--                 placed below the buffer line containing the mark.
--               • virt_lines_above: place virtual lines above instead.
--               • virt_lines_leftcol: Place extmarks in the leftmost column
--                 of the window, bypassing sign and number columns.
--               • ephemeral : for use with |nvim_set_decoration_provider()|
--                 callbacks. The mark will only be used for the current
--                 redraw cycle, and not be permantently stored in the
--                 buffer.
--               • right_gravity : boolean that indicates the direction the
--                 extmark will be shifted in when new text is inserted (true
--                 for right, false for left). Defaults to true.
--               • end_right_gravity : boolean that indicates the direction
--                 the extmark end position (if it exists) will be shifted in
--                 when new text is inserted (true for right, false for
--                 left). Defaults to false.
--               • priority: a priority value for the highlight group or sign
--                 attribute. For example treesitter highlighting uses a
--                 value of 100.
--               • strict: boolean that indicates extmark should not be
--                 placed if the line or column value is past the end of the
--                 buffer or end of the line respectively. Defaults to true.
--               • sign_text: string of length 1-2 used to display in the
--                 sign column. Note: ranges are unsupported and decorations
--                 are only applied to start_row
--               • sign_hl_group: name of the highlight group used to
--                 highlight the sign column text. Note: ranges are
--                 unsupported and decorations are only applied to start_row
--               • number_hl_group: name of the highlight group used to
--                 highlight the number column. Note: ranges are unsupported
--                 and decorations are only applied to start_row
--               • line_hl_group: name of the highlight group used to
--                 highlight the whole line. Note: ranges are unsupported and
--                 decorations are only applied to start_row
--               • cursorline_hl_group: name of the highlight group used to
--                 highlight the line when the cursor is on the same line as
--                 the mark and 'cursorline' is enabled. Note: ranges are
--                 unsupported and decorations are only applied to start_row
--               • conceal: string which should be either empty or a single
--                 character. Enable concealing similar to |:syn-conceal|.
--                 When a character is supplied it is used as |:syn-cchar|.
--                 "hl_group" is used as highlight for the cchar if provided,
--                 otherwise it defaults to |hl-Conceal|.
--               • spell: boolean indicating that spell checking should be
--                 performed within this extmark
--               • ui_watched: boolean that indicates the mark should be
--                 drawn by a UI. When set, the UI will receive win_extmark
--                 events. Note: the mark is positioned by virt_text
--                 attributes. Can be used together with virt_text.
-- 
-- Return: ~
--     Id of the created/updated extmark
--- @param buffer buffer
--- @param ns_id number
--- @param line number
--- @param col number
--- @param opts? table<string, any>
--- @return number
function vim.api.nvim_buf_set_extmark(buffer, ns_id, line, col, opts) end

-- Sets a buffer-local |mapping| for the given mode.
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
-- 
-- See also: ~
--   • |nvim_set_keymap()|
--- @param buffer buffer
--- @param mode string
--- @param lhs string
--- @param rhs string
--- @param opts? table<string, any>
function vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts) end

-- Sets (replaces) a line-range in the buffer.
-- 
-- Indexing is zero-based, end-exclusive. Negative indices are interpreted as
-- length+1+index: -1 refers to the index past the end. So to change or
-- delete the last element use start=-2 and end=-1.
-- 
-- To insert lines at a given index, set `start` and `end` to the same index.
-- To delete a range of lines, set `replacement` to an empty array.
-- 
-- Out-of-bounds indices are clamped to the nearest valid value, unless
-- `strict_indexing` is set.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {buffer}           Buffer handle, or 0 for current buffer
--   • {start}            First line index
--   • {end}              Last line index, exclusive
--   • {strict_indexing}  Whether out-of-bounds should be an error.
--   • {replacement}      Array of lines to use as replacement
-- 
-- See also: ~
--   • |nvim_buf_set_text()|
--- @param buffer buffer
--- @param start number
--- @param end_ number
--- @param strict_indexing boolean
--- @param replacement string[]
function vim.api.nvim_buf_set_lines(buffer, start, end_, strict_indexing, replacement) end

-- Sets a named mark in the given buffer, all marks are allowed
-- file/uppercase, visual, last change, etc. See |mark-motions|.
-- 
-- Marks are (1,0)-indexed. |api-indexing|
-- 
-- Note:
--     Passing 0 as line deletes the mark
-- 
-- Parameters: ~
--   • {buffer}  Buffer to set the mark on
--   • {name}    Mark name
--   • {line}    Line number
--   • {col}     Column/row number
--   • {opts}    Optional parameters. Reserved for future use.
-- 
-- Return: ~
--     true if the mark was set, else false.
-- 
-- See also: ~
--   • |nvim_buf_del_mark()|
--   • |nvim_buf_get_mark()|
--- @param buffer buffer
--- @param name string
--- @param line number
--- @param col number
--- @param opts table<string, any>
--- @return boolean
function vim.api.nvim_buf_set_mark(buffer, name, line, col, opts) end

-- Sets the full file name for a buffer
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Buffer name
--- @param buffer buffer
--- @param name string
function vim.api.nvim_buf_set_name(buffer, name) end

-- Sets a buffer option value. Passing `nil` as value deletes the option
-- (only works if there's a global fallback)
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Option name
--   • {value}   Option value
--- @param buffer buffer
--- @param name string
--- @param value object
function vim.api.nvim_buf_set_option(buffer, name, value) end

-- Sets (replaces) a range in the buffer
-- 
-- This is recommended over |nvim_buf_set_lines()| when only modifying parts
-- of a line, as extmarks will be preserved on non-modified parts of the
-- touched lines.
-- 
-- Indexing is zero-based. Row indices are end-inclusive, and column indices
-- are end-exclusive.
-- 
-- To insert text at a given `(row, column)` location, use `start_row =
-- end_row = row` and `start_col = end_col = col`. To delete the text in a
-- range, use `replacement = {}`.
-- 
-- Prefer |nvim_buf_set_lines()| if you are only adding or deleting entire
-- lines.
-- 
-- Parameters: ~
--   • {buffer}       Buffer handle, or 0 for current buffer
--   • {start_row}    First line index
--   • {start_col}    Starting column (byte offset) on first line
--   • {end_row}      Last line index, inclusive
--   • {end_col}      Ending column (byte offset) on last line, exclusive
--   • {replacement}  Array of lines to use as replacement
-- 
-- See also: ~
--   • |nvim_buf_set_lines()|
--- @param buffer buffer
--- @param start_row number
--- @param start_col number
--- @param end_row number
--- @param end_col number
--- @param replacement string[]
function vim.api.nvim_buf_set_text(buffer, start_row, start_col, end_row, end_col, replacement) end

-- Sets a buffer-scoped (b:) variable
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle, or 0 for current buffer
--   • {name}    Variable name
--   • {value}   Variable value
--- @param buffer buffer
--- @param name string
--- @param value object
function vim.api.nvim_buf_set_var(buffer, name, value) end

-- Calls a VimL |Dictionary-function| with the given arguments.
-- 
-- On execution error: fails with VimL error, updates v:errmsg.
-- 
-- Parameters: ~
--   • {dict}  Dictionary, or String evaluating to a VimL |self| dict
--   • {fn}    Name of the function defined on the VimL dict
--   • {args}  Function arguments packed in an Array
-- 
-- Return: ~
--     Result of the function call
--- @param dict object
--- @param fn string
--- @param args any[]
--- @return object
function vim.api.nvim_call_dict_function(dict, fn, args) end

-- Calls a VimL function with the given arguments.
-- 
-- On execution error: fails with VimL error, updates v:errmsg.
-- 
-- Parameters: ~
--   • {fn}    Function to call
--   • {args}  Function arguments packed in an Array
-- 
-- Return: ~
--     Result of the function call
--- @param fn string
--- @param args any[]
--- @return object
function vim.api.nvim_call_function(fn, args) end

-- Send data to channel `id`. For a job, it writes it to the stdin of the
-- process. For the stdio channel |channel-stdio|, it writes to Nvim's
-- stdout. For an internal terminal instance (|nvim_open_term()|) it writes
-- directly to terminal output. See |channel-bytes| for more information.
-- 
-- This function writes raw data, not RPC messages. If the channel was
-- created with `rpc=true` then the channel expects RPC messages, use
-- |vim.rpcnotify()| and |vim.rpcrequest()| instead.
-- 
-- Attributes: ~
--     |RPC| only
--     Lua |vim.api| only
-- 
-- Parameters: ~
--   • {chan}  id of the channel
--   • {data}  data to write. 8-bit clean: can contain NUL bytes.
--- @param chan number
--- @param data string
function vim.api.nvim_chan_send(chan, data) end

-- Clear all autocommands that match the corresponding {opts}. To delete a
-- particular autocmd, see |nvim_del_autocmd()|.
-- 
-- Parameters: ~
--   • {opts}  Parameters
--             • event: (string|table) Examples:
--               • event: "pat1"
--               • event: { "pat1" }
--               • event: { "pat1", "pat2", "pat3" }
-- 
--             • pattern: (string|table)
--               • pattern or patterns to match exactly.
--                 • For example, if you have `*.py` as that pattern for the
--                   autocmd, you must pass `*.py` exactly to clear it.
--                   `test.py` will not match the pattern.
-- 
--               • defaults to clearing all patterns.
--               • NOTE: Cannot be used with {buffer}
-- 
--             • buffer: (bufnr)
--               • clear only |autocmd-buflocal| autocommands.
--               • NOTE: Cannot be used with {pattern}
-- 
--             • group: (string|int) The augroup name or id.
--               • NOTE: If not passed, will only delete autocmds not in any group.
--- @param opts? table<string, any>
function vim.api.nvim_clear_autocmds(opts) end

-- Executes an Ex command.
-- 
-- Unlike |nvim_command()| this command takes a structured Dictionary instead
-- of a String. This allows for easier construction and manipulation of an Ex
-- command. This also allows for things such as having spaces inside a
-- command argument, expanding filenames in a command that otherwise doesn't
-- expand filenames, etc. Command arguments may also be Number, Boolean or
-- String.
-- 
-- The first argument may also be used instead of count for commands that
-- support it in order to make their usage simpler with |vim.cmd()|. For
-- example, instead of `vim.cmd.bdelete{ count = 2 }`, you may do
-- `vim.cmd.bdelete(2)`.
-- 
-- On execution error: fails with VimL error, updates v:errmsg.
-- 
-- Parameters: ~
--   • {cmd}   Command to execute. Must be a Dictionary that can contain the
--             same values as the return value of |nvim_parse_cmd()| except
--             "addr", "nargs" and "nextcmd" which are ignored if provided.
--             All values except for "cmd" are optional.
--   • {opts}  Optional parameters.
--             • output: (boolean, default false) Whether to return command
--               output.
-- 
-- Return: ~
--     Command output (non-error, non-shell |:!|) if `output` is true, else
--     empty string.
-- 
-- See also: ~
--   • |nvim_exec2()|
--   • |nvim_command()|
--- @param cmd? table<string, any>
--- @param opts? table<string, any>
--- @return string
function vim.api.nvim_cmd(cmd, opts) end

-- Executes an Ex command.
-- 
-- On execution error: fails with VimL error, updates v:errmsg.
-- 
-- Prefer using |nvim_cmd()| or |nvim_exec2()| over this. To evaluate
-- multiple lines of Vim script or an Ex command directly, use
-- |nvim_exec2()|. To construct an Ex command using a structured format and
-- then execute it, use |nvim_cmd()|. To modify an Ex command before
-- evaluating it, use |nvim_parse_cmd()| in conjunction with |nvim_cmd()|.
-- 
-- Parameters: ~
--   • {command}  Ex command string
--- @param command string
function vim.api.nvim_command(command) end

-- Create or get an autocommand group |autocmd-groups|.
-- 
-- To get an existing group id, do: 
-- ```lua
--     local id = vim.api.nvim_create_augroup("MyGroup", {
--         clear = false
--     })
-- ```
-- 
-- Parameters: ~
--   • {name}  String: The name of the group
--   • {opts}  Dictionary Parameters
--             • clear (bool) optional: defaults to true. Clear existing
--               commands if the group already exists |autocmd-groups|.
-- 
-- Return: ~
--     Integer id of the created group.
-- 
-- See also: ~
--   • |autocmd-groups|
--- @param name string
--- @param opts? table<string, any>
--- @return number
function vim.api.nvim_create_augroup(name, opts) end

-- Creates an |autocommand| event handler, defined by `callback` (Lua function or Vimscript function name string) or `command` (Ex command string).
-- 
-- Example using Lua callback: 
-- ```lua
--     vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--       pattern = {"*.c", "*.h"},
--       callback = function(ev)
--         print(string.format('event fired: s', vim.inspect(ev)))
--       end
--     })
-- ```
-- 
-- Example using an Ex command as the handler: 
-- ```lua
--     vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--       pattern = {"*.c", "*.h"},
--       command = "echo 'Entering a C or C++ file'",
--     })
-- ```
-- 
-- Note: `pattern` is NOT automatically expanded (unlike with |:autocmd|), thus names like
-- "$HOME" and "~" must be expanded explicitly: 
-- ```lua
--   pattern = vim.fn.expand("~") .. "/some/path/*.py"
-- ```
-- 
-- Parameters: ~
--   • {event}  (string|array) Event(s) that will trigger the handler
--              (`callback` or `command`).
--   • {opts}   Options dict:
--              • group (string|integer) optional: autocommand group name or
--                id to match against.
--              • pattern (string|array) optional: pattern(s) to match
--                literally |autocmd-pattern|.
--              • buffer (integer) optional: buffer number for buffer-local
--                autocommands |autocmd-buflocal|. Cannot be used with
--                {pattern}.
--              • desc (string) optional: description (for documentation and
--                troubleshooting).
--              • callback (function|string) optional: Lua function (or
--                Vimscript function name, if string) called when the
--                event(s) is triggered. Lua callback can return true to
--                delete the autocommand, and receives a table argument with
--                these keys:
--                • id: (number) autocommand id
--                • event: (string) name of the triggered event
--                  |autocmd-events|
--                • group: (number|nil) autocommand group id, if any
--                • match: (string) expanded value of |<amatch>|
--                • buf: (number) expanded value of |<abuf>|
--                • file: (string) expanded value of |<afile>|
--                • data: (any) arbitrary data passed from
--                  |nvim_exec_autocmds()|
-- 
--              • command (string) optional: Vim command to execute on event.
--                Cannot be used with {callback}
--              • once (boolean) optional: defaults to false. Run the
--                autocommand only once |autocmd-once|.
--              • nested (boolean) optional: defaults to false. Run nested
--                autocommands |autocmd-nested|.
-- 
-- Return: ~
--     Autocommand id (number)
-- 
-- See also: ~
--   • |autocommand|
--   • |nvim_del_autocmd()|
--- @param event object
--- @param opts? table<string, any>
--- @return number
function vim.api.nvim_create_autocmd(event, opts) end

-- Creates a new, empty, unnamed buffer.
-- 
-- Parameters: ~
--   • {listed}   Sets 'buflisted'
--   • {scratch}  Creates a "throwaway" |scratch-buffer| for temporary work
--                (always 'nomodified'). Also sets 'nomodeline' on the
--                buffer.
-- 
-- Return: ~
--     Buffer handle, or 0 on error
-- 
-- See also: ~
--   • buf_open_scratch
--- @param listed boolean
--- @param scratch boolean
--- @return buffer
function vim.api.nvim_create_buf(listed, scratch) end

-- Creates a new namespace or gets an existing one.
-- 
-- Namespaces are used for buffer highlights and virtual text, see
-- |nvim_buf_add_highlight()| and |nvim_buf_set_extmark()|.
-- 
-- Namespaces can be named or anonymous. If `name` matches an existing
-- namespace, the associated id is returned. If `name` is an empty string a
-- new, anonymous namespace is created.
-- 
-- Parameters: ~
--   • {name}  Namespace name or empty string
-- 
-- Return: ~
--     Namespace id
--- @param name string
--- @return number
function vim.api.nvim_create_namespace(name) end

-- Creates a global |user-commands| command.
-- 
-- For Lua usage see |lua-guide-commands-create|.
-- 
-- Example: 
-- ```vim
--    :call nvim_create_user_command('SayHello', 'echo "Hello world!"', {'bang': v:true})
--    :SayHello
--    Hello world!
-- ```
-- 
-- Parameters: ~
--   • {name}     Name of the new user command. Must begin with an uppercase
--                letter.
--   • {command}  Replacement command to execute when this user command is
--                executed. When called from Lua, the command can also be a
--                Lua function. The function is called with a single table
--                argument that contains the following keys:
--                • name: (string) Command name
--                • args: (string) The args passed to the command, if any
--                  |<args>|
--                • fargs: (table) The args split by unescaped whitespace
--                  (when more than one argument is allowed), if any
--                  |<f-args>|
--                • bang: (boolean) "true" if the command was executed with a
--                  ! modifier |<bang>|
--                • line1: (number) The starting line of the command range
--                  |<line1>|
--                • line2: (number) The final line of the command range
--                  |<line2>|
--                • range: (number) The number of items in the command range:
--                  0, 1, or 2 |<range>|
--                • count: (number) Any count supplied |<count>|
--                • reg: (string) The optional register, if specified |<reg>|
--                • mods: (string) Command modifiers, if any |<mods>|
--                • smods: (table) Command modifiers in a structured format.
--                  Has the same structure as the "mods" key of
--                  |nvim_parse_cmd()|.
--   • {opts}     Optional |command-attributes|.
--                • Set boolean attributes such as |:command-bang| or
--                  |:command-bar| to true (but not |:command-buffer|, use
--                  |nvim_buf_create_user_command()| instead).
--                • "complete" |:command-complete| also accepts a Lua
--                  function which works like
--                  |:command-completion-customlist|.
--                • Other parameters:
--                  • desc: (string) Used for listing the command when a Lua
--                    function is used for {command}.
--                  • force: (boolean, default true) Override any previous
--                    definition.
--                  • preview: (function) Preview callback for 'inccommand'
--                    |:command-preview|
--- @param name string
--- @param command object
--- @param opts? table<string, any>
function vim.api.nvim_create_user_command(name, command, opts) end

-- Delete an autocommand group by id.
-- 
-- To get a group id one can use |nvim_get_autocmds()|.
-- 
-- NOTE: behavior differs from |:augroup-delete|. When deleting a group,
-- autocommands contained in this group will also be deleted and cleared.
-- This group will no longer exist.
-- 
-- Parameters: ~
--   • {id}  Integer The id of the group.
-- 
-- See also: ~
--   • |nvim_del_augroup_by_name()|
--   • |nvim_create_augroup()|
--- @param id number
function vim.api.nvim_del_augroup_by_id(id) end

-- Delete an autocommand group by name.
-- 
-- NOTE: behavior differs from |:augroup-delete|. When deleting a group,
-- autocommands contained in this group will also be deleted and cleared.
-- This group will no longer exist.
-- 
-- Parameters: ~
--   • {name}  String The name of the group.
-- 
-- See also: ~
--   • |autocmd-groups|
--- @param name string
function vim.api.nvim_del_augroup_by_name(name) end

-- Delete an autocommand by id.
-- 
-- NOTE: Only autocommands created via the API have an id.
-- 
-- Parameters: ~
--   • {id}  Integer The id returned by nvim_create_autocmd
-- 
-- See also: ~
--   • |nvim_create_autocmd()|
--- @param id number
function vim.api.nvim_del_autocmd(id) end

-- Deletes the current line.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
function vim.api.nvim_del_current_line() end

-- Unmaps a global |mapping| for the given mode.
-- 
-- To unmap a buffer-local mapping, use |nvim_buf_del_keymap()|.
-- 
-- See also: ~
--   • |nvim_set_keymap()|
--- @param mode string
--- @param lhs string
function vim.api.nvim_del_keymap(mode, lhs) end

-- Deletes an uppercase/file named mark. See |mark-motions|.
-- 
-- Note:
--     fails with error if a lowercase or buffer local named mark is used.
-- 
-- Parameters: ~
--   • {name}  Mark name
-- 
-- Return: ~
--     true if the mark was deleted, else false.
-- 
-- See also: ~
--   • |nvim_buf_del_mark()|
--   • |nvim_get_mark()|
--- @param name string
--- @return boolean
function vim.api.nvim_del_mark(name) end

-- Delete a user-defined command.
-- 
-- Parameters: ~
--   • {name}  Name of the command to delete.
--- @param name string
function vim.api.nvim_del_user_command(name) end

-- Removes a global (g:) variable.
-- 
-- Parameters: ~
--   • {name}  Variable name
--- @param name string
function vim.api.nvim_del_var(name) end

-- Echo a message.
-- 
-- Parameters: ~
--   • {chunks}   A list of [text, hl_group] arrays, each representing a text
--                chunk with specified highlight. `hl_group` element can be
--                omitted for no highlight.
--   • {history}  if true, add to |message-history|.
--   • {opts}     Optional parameters.
--                • verbose: Message was printed as a result of 'verbose'
--                  option if Nvim was invoked with -V3log_file, the message
--                  will be redirected to the log_file and suppressed from
--                  direct output.
--- @param chunks any[]
--- @param history boolean
--- @param opts? table<string, any>
function vim.api.nvim_echo(chunks, history, opts) end

-- Writes a message to the Vim error buffer. Does not append "\n", the
-- message is buffered (won't display) until a linefeed is written.
-- 
-- Parameters: ~
--   • {str}  Message
--- @param str string
function vim.api.nvim_err_write(str) end

-- Writes a message to the Vim error buffer. Appends "\n", so the buffer is
-- flushed (and displayed).
-- 
-- Parameters: ~
--   • {str}  Message
-- 
-- See also: ~
--   • nvim_err_write()
--- @param str string
function vim.api.nvim_err_writeln(str) end

-- Evaluates a VimL |expression|. Dictionaries and Lists are recursively
-- expanded.
-- 
-- On execution error: fails with VimL error, updates v:errmsg.
-- 
-- Parameters: ~
--   • {expr}  VimL expression string
-- 
-- Return: ~
--     Evaluation result or expanded object
--- @param expr string
--- @return object
function vim.api.nvim_eval(expr) end

-- Evaluates statusline string.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {str}   Statusline string (see 'statusline').
--   • {opts}  Optional parameters.
--             • winid: (number) |window-ID| of the window to use as context
--               for statusline.
--             • maxwidth: (number) Maximum width of statusline.
--             • fillchar: (string) Character to fill blank spaces in the
--               statusline (see 'fillchars'). Treated as single-width even
--               if it isn't.
--             • highlights: (boolean) Return highlight information.
--             • use_winbar: (boolean) Evaluate winbar instead of statusline.
--             • use_tabline: (boolean) Evaluate tabline instead of
--               statusline. When true, {winid} is ignored. Mutually
--               exclusive with {use_winbar}.
--             • use_statuscol_lnum: (number) Evaluate statuscolumn for this
--               line number instead of statusline.
-- 
-- Return: ~
--     Dictionary containing statusline information, with these keys:
--     • str: (string) Characters that will be displayed on the statusline.
--     • width: (number) Display width of the statusline.
--     • highlights: Array containing highlight information of the
--       statusline. Only included when the "highlights" key in {opts} is
--       true. Each element of the array is a |Dictionary| with these keys:
--       • start: (number) Byte index (0-based) of first character that uses
--         the highlight.
--       • group: (string) Name of highlight group.
--- @param str string
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_eval_statusline(str, opts) end

-- Executes Vimscript (multiline block of Ex commands), like anonymous
-- |:source|.
-- 
-- Unlike |nvim_command()| this function supports heredocs, script-scope
-- (s:), etc.
-- 
-- On execution error: fails with VimL error, updates v:errmsg.
-- 
-- Parameters: ~
--   • {src}   Vimscript code
--   • {opts}  Optional parameters.
--             • output: (boolean, default false) Whether to capture and
--               return all (non-error, non-shell |:!|) output.
-- 
-- Return: ~
--     Dictionary containing information about execution, with these keys:
--     • output: (string|nil) Output if `opts.output` is true.
-- 
-- See also: ~
--   • |execute()|
--   • |nvim_command()|
--   • |nvim_cmd()|
--- @param src string
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_exec2(src, opts) end

-- Execute all autocommands for {event} that match the corresponding {opts}
-- |autocmd-execute|.
-- 
-- Parameters: ~
--   • {event}  (String|Array) The event or events to execute
--   • {opts}   Dictionary of autocommand options:
--              • group (string|integer) optional: the autocommand group name
--                or id to match against. |autocmd-groups|.
--              • pattern (string|array) optional: defaults to "*"
--                |autocmd-pattern|. Cannot be used with {buffer}.
--              • buffer (integer) optional: buffer number
--                |autocmd-buflocal|. Cannot be used with {pattern}.
--              • modeline (bool) optional: defaults to true. Process the
--                modeline after the autocommands |<nomodeline>|.
--              • data (any): arbitrary data to send to the autocommand
--                callback. See |nvim_create_autocmd()| for details.
-- 
-- See also: ~
--   • |:doautocmd|
--- @param event object
--- @param opts? table<string, any>
function vim.api.nvim_exec_autocmds(event, opts) end

-- Sends input-keys to Nvim, subject to various quirks controlled by `mode`
-- flags. This is a blocking call, unlike |nvim_input()|.
-- 
-- On execution error: does not fail, but updates v:errmsg.
-- 
-- To input sequences like <C-o> use |nvim_replace_termcodes()| (typically
-- with escape_ks=false) to replace |keycodes|, then pass the result to
-- nvim_feedkeys().
-- 
-- Example: 
-- ```vim
--     :let key = nvim_replace_termcodes("<C-o>", v:true, v:false, v:true)
--     :call nvim_feedkeys(key, 'n', v:false)
-- ```
-- 
-- Parameters: ~
--   • {keys}       to be typed
--   • {mode}       behavior flags, see |feedkeys()|
--   • {escape_ks}  If true, escape K_SPECIAL bytes in `keys`. This should be
--                  false if you already used |nvim_replace_termcodes()|, and
--                  true otherwise.
-- 
-- See also: ~
--   • feedkeys()
--   • vim_strsave_escape_ks
--- @param keys string
--- @param mode string
--- @param escape_ks boolean
function vim.api.nvim_feedkeys(keys, mode, escape_ks) end

-- Gets the option information for all options.
-- 
-- The dictionary has the full option names as keys and option metadata
-- dictionaries as detailed at |nvim_get_option_info2()|.
-- 
-- Return: ~
--     dictionary of all options
--- @return table<string, any>
function vim.api.nvim_get_all_options_info() end

-- Get all autocommands that match the corresponding {opts}.
-- 
-- These examples will get autocommands matching ALL the given criteria: 
-- ```lua
--   -- Matches all criteria
--   autocommands = vim.api.nvim_get_autocmds({
--     group = "MyGroup",
--     event = {"BufEnter", "BufWinEnter"},
--     pattern = {"*.c", "*.h"}
--   })
-- 
--   -- All commands from one group
--   autocommands = vim.api.nvim_get_autocmds({
--     group = "MyGroup",
--   })
-- ```
-- 
-- NOTE: When multiple patterns or events are provided, it will find all the
-- autocommands that match any combination of them.
-- 
-- Parameters: ~
--   • {opts}  Dictionary with at least one of the following:
--             • group (string|integer): the autocommand group name or id to
--               match against.
--             • event (string|array): event or events to match against
--               |autocmd-events|.
--             • pattern (string|array): pattern or patterns to match against
--               |autocmd-pattern|. Cannot be used with {buffer}
--             • buffer: Buffer number or list of buffer numbers for buffer
--               local autocommands |autocmd-buflocal|. Cannot be used with
--               {pattern}
-- 
-- Return: ~
--     Array of autocommands matching the criteria, with each item containing
--     the following fields:
--     • id (number): the autocommand id (only when defined with the API).
--     • group (integer): the autocommand group id.
--     • group_name (string): the autocommand group name.
--     • desc (string): the autocommand description.
--     • event (string): the autocommand event.
--     • command (string): the autocommand command. Note: this will be empty
--       if a callback is set.
--     • callback (function|string|nil): Lua function or name of a Vim script
--       function which is executed when this autocommand is triggered.
--     • once (boolean): whether the autocommand is only run once.
--     • pattern (string): the autocommand pattern. If the autocommand is
--       buffer local |autocmd-buffer-local|:
--     • buflocal (boolean): true if the autocommand is buffer local.
--     • buffer (number): the buffer number.
--- @param opts? table<string, any>
--- @return any[]
function vim.api.nvim_get_autocmds(opts) end

-- Gets information about a channel.
-- 
-- Return: ~
--     Dictionary describing a channel, with these keys:
--     • "id" Channel id.
--     • "argv" (optional) Job arguments list.
--     • "stream" Stream underlying the channel.
--       • "stdio" stdin and stdout of this Nvim instance
--       • "stderr" stderr of this Nvim instance
--       • "socket" TCP/IP socket or named pipe
--       • "job" Job with communication over its stdio.
-- 
--     • "mode" How data received on the channel is interpreted.
--       • "bytes" Send and receive raw bytes.
--       • "terminal" |terminal| instance interprets ASCII sequences.
--       • "rpc" |RPC| communication on the channel is active.
-- 
--     • "pty" (optional) Name of pseudoterminal. On a POSIX system this is a
--       device path like "/dev/pts/1". If the name is unknown, the key will
--       still be present if a pty is used (e.g. for conpty on Windows).
--     • "buffer" (optional) Buffer with connected |terminal| instance.
--     • "client" (optional) Info about the peer (client on the other end of
--       the RPC channel), if provided by it via |nvim_set_client_info()|.
--- @param chan number
--- @return table<string, any>
function vim.api.nvim_get_chan_info(chan) end

-- Returns the 24-bit RGB value of a |nvim_get_color_map()| color name or
-- "#rrggbb" hexadecimal string.
-- 
-- Example: 
-- ```vim
--     :echo nvim_get_color_by_name("Pink")
--     :echo nvim_get_color_by_name("#cbcbcb")
-- ```
-- 
-- Parameters: ~
--   • {name}  Color name or "#rrggbb" string
-- 
-- Return: ~
--     24-bit RGB value, or -1 for invalid argument.
--- @param name string
--- @return number
function vim.api.nvim_get_color_by_name(name) end

-- Returns a map of color names and RGB values.
-- 
-- Keys are color names (e.g. "Aqua") and values are 24-bit RGB color values
-- (e.g. 65535).
-- 
-- Return: ~
--     Map of color names and RGB values.
--- @return table<string, any>
function vim.api.nvim_get_color_map() end

-- Gets a map of global (non-buffer-local) Ex commands.
-- 
-- Currently only |user-commands| are supported, not builtin Ex commands.
-- 
-- Parameters: ~
--   • {opts}  Optional parameters. Currently only supports {"builtin":false}
-- 
-- Return: ~
--     Map of maps describing commands.
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_get_commands(opts) end

-- Gets a map of the current editor state.
-- 
-- Parameters: ~
--   • {opts}  Optional parameters.
--             • types: List of |context-types| ("regs", "jumps", "bufs",
--               "gvars", …) to gather, or empty for "all".
-- 
-- Return: ~
--     map of global |context|.
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_get_context(opts) end

-- Gets the current buffer.
-- 
-- Return: ~
--     Buffer handle
--- @return buffer
function vim.api.nvim_get_current_buf() end

-- Gets the current line.
-- 
-- Return: ~
--     Current line string
--- @return string
function vim.api.nvim_get_current_line() end

-- Gets the current tabpage.
-- 
-- Return: ~
--     Tabpage handle
--- @return tabpage
function vim.api.nvim_get_current_tabpage() end

-- Gets the current window.
-- 
-- Return: ~
--     Window handle
--- @return window
function vim.api.nvim_get_current_win() end

-- Gets all or specific highlight groups in a namespace.
-- 
-- Parameters: ~
--   • {ns_id}  Get highlight groups for namespace ns_id
--              |nvim_get_namespaces()|. Use 0 to get global highlight groups
--              |:highlight|.
--   • {opts}   Options dict:
--              • name: (string) Get a highlight definition by name.
--              • id: (integer) Get a highlight definition by id.
--              • link: (boolean, default true) Show linked group name
--                instead of effective definition |:hi-link|.
-- 
-- Return: ~
--     Highlight groups as a map from group name to a highlight definition
--     map as in |nvim_set_hl()|, or only a single highlight definition map
--     if requested by name or id.
-- 
-- Note:
--     When the `link` attribute is defined in the highlight definition map,
--     other attributes will not be taking effect (see |:hi-link|).
--- @param ns_id number
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_get_hl(ns_id, opts) end

-- Gets a highlight group by name
-- 
-- similar to |hlID()|, but allocates a new ID if not present.
--- @param name string
--- @return number
function vim.api.nvim_get_hl_id_by_name(name) end

-- Gets a list of global (non-buffer-local) |mapping| definitions.
-- 
-- Parameters: ~
--   • {mode}  Mode short-name ("n", "i", "v", ...)
-- 
-- Return: ~
--     Array of |maparg()|-like dictionaries describing mappings. The
--     "buffer" key is always zero.
--- @param mode string
--- @return any[]
function vim.api.nvim_get_keymap(mode) end

-- Return a tuple (row, col, buffer, buffername) representing the position of
-- the uppercase/file named mark. See |mark-motions|.
-- 
-- Marks are (1,0)-indexed. |api-indexing|
-- 
-- Note:
--     fails with error if a lowercase or buffer local named mark is used.
-- 
-- Parameters: ~
--   • {name}  Mark name
--   • {opts}  Optional parameters. Reserved for future use.
-- 
-- Return: ~
--     4-tuple (row, col, buffer, buffername), (0, 0, 0, '') if the mark is
--     not set.
-- 
-- See also: ~
--   • |nvim_buf_set_mark()|
--   • |nvim_del_mark()|
--- @param name string
--- @param opts table<string, any>
--- @return any[]
function vim.api.nvim_get_mark(name, opts) end

-- Gets the current mode. |mode()| "blocking" is true if Nvim is waiting for
-- input.
-- 
-- Return: ~
--     Dictionary { "mode": String, "blocking": Boolean }
-- 
-- Attributes: ~
--     |api-fast|
--- @return table<string, any>
function vim.api.nvim_get_mode() end

-- Gets existing, non-anonymous |namespace|s.
-- 
-- Return: ~
--     dict that maps from names to namespace ids.
--- @return table<string, any>
function vim.api.nvim_get_namespaces() end

-- Gets the global value of an option.
-- 
-- Parameters: ~
--   • {name}  Option name
-- 
-- Return: ~
--     Option value (global)
--- @param name string
--- @return object
function vim.api.nvim_get_option(name) end

--- @return table<string, any>
function vim.api.nvim_get_option_info() end

-- Gets the option information for one option from arbitrary buffer or window
-- 
-- Resulting dictionary has keys:
-- • name: Name of the option (like 'filetype')
-- • shortname: Shortened name of the option (like 'ft')
-- • type: type of option ("string", "number" or "boolean")
-- • default: The default value for the option
-- • was_set: Whether the option was set.
-- • last_set_sid: Last set script id (if any)
-- • last_set_linenr: line number where option was set
-- • last_set_chan: Channel where option was set (0 for local)
-- • scope: one of "global", "win", or "buf"
-- • global_local: whether win or buf option has a global value
-- • commalist: List of comma separated values
-- • flaglist: List of single char flags
-- 
-- When {scope} is not provided, the last set information applies to the
-- local value in the current buffer or window if it is available, otherwise
-- the global value information is returned. This behavior can be disabled by
-- explicitly specifying {scope} in the {opts} table.
-- 
-- Parameters: ~
--   • {name}  Option name
--   • {opts}  Optional parameters
--             • scope: One of "global" or "local". Analogous to |:setglobal|
--               and |:setlocal|, respectively.
--             • win: |window-ID|. Used for getting window local options.
--             • buf: Buffer number. Used for getting buffer local options.
--               Implies {scope} is "local".
-- 
-- Return: ~
--     Option Information
--- @param name string
--- @param opts? table<string, any>
--- @return table<string, any>
function vim.api.nvim_get_option_info2(name, opts) end

-- Gets the value of an option. The behavior of this function matches that of
-- |:set|: the local value of an option is returned if it exists; otherwise,
-- the global value is returned. Local values always correspond to the
-- current buffer or window, unless "buf" or "win" is set in {opts}.
-- 
-- Parameters: ~
--   • {name}  Option name
--   • {opts}  Optional parameters
--             • scope: One of "global" or "local". Analogous to |:setglobal|
--               and |:setlocal|, respectively.
--             • win: |window-ID|. Used for getting window local options.
--             • buf: Buffer number. Used for getting buffer local options.
--               Implies {scope} is "local".
--             • filetype: |filetype|. Used to get the default option for a
--               specific filetype. Cannot be used with any other option.
--               Note: this will trigger |ftplugin| and all |FileType|
--               autocommands for the corresponding filetype.
-- 
-- Return: ~
--     Option value
--- @param name string
--- @param opts? table<string, any>
--- @return object
function vim.api.nvim_get_option_value(name, opts) end

-- Gets info describing process `pid`.
-- 
-- Return: ~
--     Map of process properties, or NIL if process not found.
--- @param pid number
--- @return object
function vim.api.nvim_get_proc(pid) end

-- Gets the immediate children of process `pid`.
-- 
-- Return: ~
--     Array of child process ids, empty if process not found.
--- @param pid number
--- @return any[]
function vim.api.nvim_get_proc_children(pid) end

-- Find files in runtime directories
-- 
-- "name" can contain wildcards. For example
-- nvim_get_runtime_file("colors/*.vim", true) will return all color scheme
-- files. Always use forward slashes (/) in the search pattern for
-- subdirectories regardless of platform.
-- 
-- It is not an error to not find any files. An empty array is returned then.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {name}  pattern of files to search for
--   • {all}   whether to return all matches or only the first
-- 
-- Return: ~
--     list of absolute paths to the found files
--- @param name string
--- @param all boolean
--- @return string[]
function vim.api.nvim_get_runtime_file(name, all) end

-- Gets a global (g:) variable.
-- 
-- Parameters: ~
--   • {name}  Variable name
-- 
-- Return: ~
--     Variable value
--- @param name string
--- @return object
function vim.api.nvim_get_var(name) end

-- Gets a v: variable.
-- 
-- Parameters: ~
--   • {name}  Variable name
-- 
-- Return: ~
--     Variable value
--- @param name string
--- @return object
function vim.api.nvim_get_vvar(name) end

-- Queues raw user-input. Unlike |nvim_feedkeys()|, this uses a low-level
-- input buffer and the call is non-blocking (input is processed
-- asynchronously by the eventloop).
-- 
-- On execution error: does not fail, but updates v:errmsg.
-- 
-- Note:
--     |keycodes| like <CR> are translated, so "<" is special. To input a
--     literal "<", send <LT>.
-- 
-- Note:
--     For mouse events use |nvim_input_mouse()|. The pseudokey form
--     "<LeftMouse><col,row>" is deprecated since |api-level| 6.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {keys}  to be typed
-- 
-- Return: ~
--     Number of bytes actually written (can be fewer than requested if the
--     buffer becomes full).
--- @param keys string
--- @return number
function vim.api.nvim_input(keys) end

-- Send mouse event from GUI.
-- 
-- Non-blocking: does not wait on any result, but queues the event to be
-- processed soon by the event loop.
-- 
-- Note:
--     Currently this doesn't support "scripting" multiple mouse events by
--     calling it multiple times in a loop: the intermediate mouse positions
--     will be ignored. It should be used to implement real-time mouse input
--     in a GUI. The deprecated pseudokey form ("<LeftMouse><col,row>") of
--     |nvim_input()| has the same limitation.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {button}    Mouse button: one of "left", "right", "middle", "wheel",
--                 "move".
--   • {action}    For ordinary buttons, one of "press", "drag", "release".
--                 For the wheel, one of "up", "down", "left", "right".
--                 Ignored for "move".
--   • {modifier}  String of modifiers each represented by a single char. The
--                 same specifiers are used as for a key press, except that
--                 the "-" separator is optional, so "C-A-", "c-a" and "CA"
--                 can all be used to specify Ctrl+Alt+click.
--   • {grid}      Grid number if the client uses |ui-multigrid|, else 0.
--   • {row}       Mouse row-position (zero-based, like redraw events)
--   • {col}       Mouse column-position (zero-based, like redraw events)
--- @param button string
--- @param action string
--- @param modifier string
--- @param grid number
--- @param row number
--- @param col number
function vim.api.nvim_input_mouse(button, action, modifier, grid, row, col) end

-- Gets the current list of buffer handles
-- 
-- Includes unlisted (unloaded/deleted) buffers, like `:ls!`. Use
-- |nvim_buf_is_loaded()| to check if a buffer is loaded.
-- 
-- Return: ~
--     List of buffer handles
--- @return any[]
function vim.api.nvim_list_bufs() end

-- Get information about all open channels.
-- 
-- Return: ~
--     Array of Dictionaries, each describing a channel with the format
--     specified at |nvim_get_chan_info()|.
--- @return any[]
function vim.api.nvim_list_chans() end

-- Gets the paths contained in 'runtimepath'.
-- 
-- Return: ~
--     List of paths
--- @return string[]
function vim.api.nvim_list_runtime_paths() end

-- Gets the current list of tabpage handles.
-- 
-- Return: ~
--     List of tabpage handles
--- @return any[]
function vim.api.nvim_list_tabpages() end

-- Gets a list of dictionaries representing attached UIs.
-- 
-- Return: ~
--     Array of UI dictionaries, each with these keys:
--     • "height" Requested height of the UI
--     • "width" Requested width of the UI
--     • "rgb" true if the UI uses RGB colors (false implies |cterm-colors|)
--     • "ext_..." Requested UI extensions, see |ui-option|
--     • "chan" |channel-id| of remote UI
--- @return any[]
function vim.api.nvim_list_uis() end

-- Gets the current list of window handles.
-- 
-- Return: ~
--     List of window handles
--- @return any[]
function vim.api.nvim_list_wins() end

-- Sets the current editor state from the given |context| map.
-- 
-- Parameters: ~
--   • {dict}  |Context| map.
--- @param dict table<string, any>
--- @return object
function vim.api.nvim_load_context(dict) end

-- Notify the user with a message
-- 
-- Relays the call to vim.notify . By default forwards your message in the
-- echo area but can be overridden to trigger desktop notifications.
-- 
-- Parameters: ~
--   • {msg}        Message to display to the user
--   • {log_level}  The log level
--   • {opts}       Reserved for future use.
--- @param msg string
--- @param log_level number
--- @param opts table<string, any>
--- @return object
function vim.api.nvim_notify(msg, log_level, opts) end

-- Open a terminal instance in a buffer
-- 
-- By default (and currently the only option) the terminal will not be
-- connected to an external process. Instead, input send on the channel will
-- be echoed directly by the terminal. This is useful to display ANSI
-- terminal sequences returned as part of a rpc message, or similar.
-- 
-- Note: to directly initiate the terminal using the right size, display the
-- buffer in a configured window before calling this. For instance, for a
-- floating display, first create an empty buffer using |nvim_create_buf()|,
-- then display it using |nvim_open_win()|, and then call this function. Then
-- |nvim_chan_send()| can be called immediately to process sequences in a
-- virtual terminal having the intended size.
-- 
-- Parameters: ~
--   • {buffer}  the buffer to use (expected to be empty)
--   • {opts}    Optional parameters.
--               • on_input: lua callback for input sent, i e keypresses in
--                 terminal mode. Note: keypresses are sent raw as they would
--                 be to the pty master end. For instance, a carriage return
--                 is sent as a "\r", not as a "\n". |textlock| applies. It
--                 is possible to call |nvim_chan_send()| directly in the
--                 callback however. ["input", term, bufnr, data]
-- 
-- Return: ~
--     Channel id, or 0 on error
--- @param buffer buffer
--- @param opts table<string, any>
--- @return number
function vim.api.nvim_open_term(buffer, opts) end

-- Open a new window.
-- 
-- Currently this is used to open floating and external windows. Floats are
-- windows that are drawn above the split layout, at some anchor position in
-- some other window. Floats can be drawn internally or by external GUI with
-- the |ui-multigrid| extension. External windows are only supported with
-- multigrid GUIs, and are displayed as separate top-level windows.
-- 
-- For a general overview of floats, see |api-floatwin|.
-- 
-- Exactly one of `external` and `relative` must be specified. The `width`
-- and `height` of the new window must be specified.
-- 
-- With relative=editor (row=0,col=0) refers to the top-left corner of the
-- screen-grid and (row=Lines-1,col=Columns-1) refers to the bottom-right
-- corner. Fractional values are allowed, but the builtin implementation
-- (used by non-multigrid UIs) will always round down to nearest integer.
-- 
-- Out-of-bounds values, and configurations that make the float not fit
-- inside the main editor, are allowed. The builtin implementation truncates
-- values so floats are fully within the main screen grid. External GUIs
-- could let floats hover outside of the main window like a tooltip, but this
-- should not be used to specify arbitrary WM screen positions.
-- 
-- Example (Lua): window-relative float 
-- ```lua
--     vim.api.nvim_open_win(0, false,
--       {relative='win', row=3, col=3, width=12, height=3})
-- ```
-- 
-- Example (Lua): buffer-relative float (travels as buffer is scrolled) 
-- ```lua
--     vim.api.nvim_open_win(0, false,
--       {relative='win', width=12, height=3, bufpos={100,10}})
-- ```
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {buffer}  Buffer to display, or 0 for current buffer
--   • {enter}   Enter the window (make it the current window)
--   • {config}  Map defining the window configuration. Keys:
--               • relative: Sets the window layout to "floating", placed at
--                 (row,col) coordinates relative to:
--                 • "editor" The global editor grid
--                 • "win" Window given by the `win` field, or current
--                   window.
--                 • "cursor" Cursor position in current window.
--                 • "mouse" Mouse position
-- 
--               • win: |window-ID| for relative="win".
--               • anchor: Decides which corner of the float to place at
--                 (row,col):
--                 • "NW" northwest (default)
--                 • "NE" northeast
--                 • "SW" southwest
--                 • "SE" southeast
-- 
--               • width: Window width (in character cells). Minimum of 1.
--               • height: Window height (in character cells). Minimum of 1.
--               • bufpos: Places float relative to buffer text (only when
--                 relative="win"). Takes a tuple of zero-indexed [line,
--                 column]. `row` and `col` if given are applied relative to this position, else they
--                 default to:
--                 • `row=1` and `col=0` if `anchor` is "NW" or "NE"
--                 • `row=0` and `col=0` if `anchor` is "SW" or "SE" (thus
--                   like a tooltip near the buffer text).
-- 
--               • row: Row position in units of "screen cell height", may be
--                 fractional.
--               • col: Column position in units of "screen cell width", may
--                 be fractional.
--               • focusable: Enable focus by user actions (wincmds, mouse
--                 events). Defaults to true. Non-focusable windows can be
--                 entered by |nvim_set_current_win()|.
--               • external: GUI should display the window as an external
--                 top-level window. Currently accepts no other positioning
--                 configuration together with this.
--               • zindex: Stacking order. floats with higher `zindex` go on top on floats with lower indices. Must be larger
--                 than zero. The following screen elements have hard-coded
--                 z-indices:
--                 • 100: insert completion popupmenu
--                 • 200: message scrollback
--                 • 250: cmdline completion popupmenu (when
--                   wildoptions+=pum) The default value for floats are 50.
--                   In general, values below 100 are recommended, unless
--                   there is a good reason to overshadow builtin elements.
-- 
--               • style: Configure the appearance of the window. Currently
--                 only takes one non-empty value:
--                 • "minimal" Nvim will display the window with many UI
--                   options disabled. This is useful when displaying a
--                   temporary float where the text should not be edited.
--                   Disables 'number', 'relativenumber', 'cursorline',
--                   'cursorcolumn', 'foldcolumn', 'spell' and 'list'
--                   options. 'signcolumn' is changed to `auto` and
--                   'colorcolumn' is cleared. 'statuscolumn' is changed to
--                   empty. The end-of-buffer region is hidden by setting
--                   `eob` flag of 'fillchars' to a space char, and clearing
--                   the |hl-EndOfBuffer| region in 'winhighlight'.
-- 
--               • border: Style of (optional) window border. This can either
--                 be a string or an array. The string values are
--                 • "none": No border (default).
--                 • "single": A single line box.
--                 • "double": A double line box.
--                 • "rounded": Like "single", but with rounded corners ("╭"
--                   etc.).
--                 • "solid": Adds padding by a single whitespace cell.
--                 • "shadow": A drop shadow effect by blending with the
--                   background.
--                 • If it is an array, it should have a length of eight or
--                   any divisor of eight. The array will specifify the eight
--                   chars building up the border in a clockwise fashion
--                   starting with the top-left corner. As an example, the
--                   double box style could be specified as [ "╔", "═" ,"╗",
--                   "║", "╝", "═", "╚", "║" ]. If the number of chars are
--                   less than eight, they will be repeated. Thus an ASCII
--                   border could be specified as [ "/", "-", "\\", "|" ], or
--                   all chars the same as [ "x" ]. An empty string can be
--                   used to turn off a specific border, for instance, [ "",
--                   "", "", ">", "", "", "", "<" ] will only make vertical
--                   borders but not horizontal ones. By default,
--                   `FloatBorder` highlight is used, which links to
--                   `WinSeparator` when not defined. It could also be
--                   specified by character: [ ["+", "MyCorner"], ["x",
--                   "MyBorder"] ].
-- 
--               • title: Title (optional) in window border, String or list.
--                 List is [text, highlight] tuples. if is string the default
--                 highlight group is `FloatTitle`.
--               • title_pos: Title position must set with title option.
--                 value can be of `left` `center` `right` default is left.
--               • noautocmd: If true then no buffer-related autocommand
--                 events such as |BufEnter|, |BufLeave| or |BufWinEnter| may
--                 fire from calling this function.
-- 
-- Return: ~
--     Window handle, or 0 on error
--- @param buffer buffer
--- @param enter boolean
--- @param config? table<string, any>
--- @return window
function vim.api.nvim_open_win(buffer, enter, config) end

-- Writes a message to the Vim output buffer. Does not append "\n", the
-- message is buffered (won't display) until a linefeed is written.
-- 
-- Parameters: ~
--   • {str}  Message
--- @param str string
function vim.api.nvim_out_write(str) end

-- Parse command line.
-- 
-- Doesn't check the validity of command arguments.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {str}   Command line string to parse. Cannot contain "\n".
--   • {opts}  Optional parameters. Reserved for future use.
-- 
-- Return: ~
--     Dictionary containing command information, with these keys:
--     • cmd: (string) Command name.
--     • range: (array) (optional) Command range (|<line1>| |<line2>|).
--       Omitted if command doesn't accept a range. Otherwise, has no
--       elements if no range was specified, one element if only a single
--       range item was specified, or two elements if both range items were
--       specified.
--     • count: (number) (optional) Command |<count>|. Omitted if command
--       cannot take a count.
--     • reg: (string) (optional) Command |<register>|. Omitted if command
--       cannot take a register.
--     • bang: (boolean) Whether command contains a |<bang>| (!) modifier.
--     • args: (array) Command arguments.
--     • addr: (string) Value of |:command-addr|. Uses short name or "line"
--       for -addr=lines.
--     • nargs: (string) Value of |:command-nargs|.
--     • nextcmd: (string) Next command if there are multiple commands
--       separated by a |:bar|. Empty if there isn't a next command.
--     • magic: (dictionary) Which characters have special meaning in the
--       command arguments.
--       • file: (boolean) The command expands filenames. Which means
--         characters such as "%", "#" and wildcards are expanded.
--       • bar: (boolean) The "|" character is treated as a command separator
--         and the double quote character (") is treated as the start of a
--         comment.
-- 
--     • mods: (dictionary) |:command-modifiers|.
--       • filter: (dictionary) |:filter|.
--         • pattern: (string) Filter pattern. Empty string if there is no
--           filter.
--         • force: (boolean) Whether filter is inverted or not.
-- 
--       • silent: (boolean) |:silent|.
--       • emsg_silent: (boolean) |:silent!|.
--       • unsilent: (boolean) |:unsilent|.
--       • sandbox: (boolean) |:sandbox|.
--       • noautocmd: (boolean) |:noautocmd|.
--       • browse: (boolean) |:browse|.
--       • confirm: (boolean) |:confirm|.
--       • hide: (boolean) |:hide|.
--       • horizontal: (boolean) |:horizontal|.
--       • keepalt: (boolean) |:keepalt|.
--       • keepjumps: (boolean) |:keepjumps|.
--       • keepmarks: (boolean) |:keepmarks|.
--       • keeppatterns: (boolean) |:keeppatterns|.
--       • lockmarks: (boolean) |:lockmarks|.
--       • noswapfile: (boolean) |:noswapfile|.
--       • tab: (integer) |:tab|. -1 when omitted.
--       • verbose: (integer) |:verbose|. -1 when omitted.
--       • vertical: (boolean) |:vertical|.
--       • split: (string) Split modifier string, is an empty string when
--         there's no split modifier. If there is a split modifier it can be
--         one of:
--         • "aboveleft": |:aboveleft|.
--         • "belowright": |:belowright|.
--         • "topleft": |:topleft|.
--         • "botright": |:botright|.
--- @param str string
--- @param opts table<string, any>
--- @return table<string, any>
function vim.api.nvim_parse_cmd(str, opts) end

-- Parse a VimL expression.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {expr}       Expression to parse. Always treated as a single line.
--   • {flags}      Flags:
--                  • "m" if multiple expressions in a row are allowed (only
--                    the first one will be parsed),
--                  • "E" if EOC tokens are not allowed (determines whether
--                    they will stop parsing process or be recognized as an
--                    operator/space, though also yielding an error).
--                  • "l" when needing to start parsing with lvalues for
--                    ":let" or ":for". Common flag sets:
--                  • "m" to parse like for ":echo".
--                  • "E" to parse like for "<C-r>=".
--                  • empty string for ":call".
--                  • "lm" to parse for ":let".
--   • {highlight}  If true, return value will also include "highlight" key
--                  containing array of 4-tuples (arrays) (Integer, Integer,
--                  Integer, String), where first three numbers define the
--                  highlighted region and represent line, starting column
--                  and ending column (latter exclusive: one should highlight
--                  region [start_col, end_col)).
-- 
-- Return: ~
-- 
--     • AST: top-level dictionary with these keys:
--       • "error": Dictionary with error, present only if parser saw some
--         error. Contains the following keys:
--         • "message": String, error message in printf format, translated.
--           Must contain exactly one "%.*s".
--         • "arg": String, error message argument.
-- 
--       • "len": Amount of bytes successfully parsed. With flags equal to ""
--         that should be equal to the length of expr string. (“Successfully
--         parsed” here means “participated in AST creation”, not “till the
--         first error”.)
--       • "ast": AST, either nil or a dictionary with these keys:
--         • "type": node type, one of the value names from ExprASTNodeType
--           stringified without "kExprNode" prefix.
--         • "start": a pair [line, column] describing where node is
--           "started" where "line" is always 0 (will not be 0 if you will be
--           using nvim_parse_viml() on e.g. ":let", but that is not present
--           yet). Both elements are Integers.
--         • "len": “length” of the node. This and "start" are there for
--           debugging purposes primary (debugging parser and providing debug
--           information).
--         • "children": a list of nodes described in top/"ast". There always
--           is zero, one or two children, key will not be present if node
--           has no children. Maximum number of children may be found in
--           node_maxchildren array.
-- 
--     • Local values (present only for certain nodes):
--       • "scope": a single Integer, specifies scope for "Option" and
--         "PlainIdentifier" nodes. For "Option" it is one of ExprOptScope
--         values, for "PlainIdentifier" it is one of ExprVarScope values.
--       • "ident": identifier (without scope, if any), present for "Option",
--         "PlainIdentifier", "PlainKey" and "Environment" nodes.
--       • "name": Integer, register name (one character) or -1. Only present
--         for "Register" nodes.
--       • "cmp_type": String, comparison type, one of the value names from
--         ExprComparisonType, stringified without "kExprCmp" prefix. Only
--         present for "Comparison" nodes.
--       • "ccs_strategy": String, case comparison strategy, one of the value
--         names from ExprCaseCompareStrategy, stringified without
--         "kCCStrategy" prefix. Only present for "Comparison" nodes.
--       • "augmentation": String, augmentation type for "Assignment" nodes.
--         Is either an empty string, "Add", "Subtract" or "Concat" for "=",
--         "+=", "-=" or ".=" respectively.
--       • "invert": Boolean, true if result of comparison needs to be
--         inverted. Only present for "Comparison" nodes.
--       • "ivalue": Integer, integer value for "Integer" nodes.
--       • "fvalue": Float, floating-point value for "Float" nodes.
--       • "svalue": String, value for "SingleQuotedString" and
--         "DoubleQuotedString" nodes.
--- @param expr string
--- @param flags string
--- @param highlight boolean
--- @return table<string, any>
function vim.api.nvim_parse_expression(expr, flags, highlight) end

-- Pastes at cursor, in any mode.
-- 
-- Invokes the `vim.paste` handler, which handles each mode appropriately.
-- Sets redo/undo. Faster than |nvim_input()|. Lines break at LF ("\n").
-- 
-- Errors ('nomodifiable', `vim.paste()` failure, …) are reflected in `err`
-- but do not affect the return value (which is strictly decided by
-- `vim.paste()`). On error, subsequent calls are ignored ("drained") until
-- the next paste is initiated (phase 1 or -1).
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {data}   Multiline input. May be binary (containing NUL bytes).
--   • {crlf}   Also break lines at CR and CRLF.
--   • {phase}  -1: paste in a single call (i.e. without streaming). To
--              "stream" a paste, call `nvim_paste` sequentially with these `phase` values:
--              • 1: starts the paste (exactly once)
--              • 2: continues the paste (zero or more times)
--              • 3: ends the paste (exactly once)
-- 
-- Return: ~
-- 
--     • true: Client may continue pasting.
--     • false: Client must cancel the paste.
--- @param data string
--- @param crlf boolean
--- @param phase number
--- @return boolean
function vim.api.nvim_paste(data, crlf, phase) end

-- Puts text at cursor, in any mode.
-- 
-- Compare |:put| and |p| which are always linewise.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {lines}   |readfile()|-style list of lines. |channel-lines|
--   • {type}    Edit behavior: any |getregtype()| result, or:
--               • "b" |blockwise-visual| mode (may include width, e.g. "b3")
--               • "c" |charwise| mode
--               • "l" |linewise| mode
--               • "" guess by contents, see |setreg()|
--   • {after}   If true insert after cursor (like |p|), or before (like
--               |P|).
--   • {follow}  If true place cursor at end of inserted text.
--- @param lines string[]
--- @param type string
--- @param after boolean
--- @param follow boolean
function vim.api.nvim_put(lines, type, after, follow) end

-- Replaces terminal codes and |keycodes| (<CR>, <Esc>, ...) in a string with
-- the internal representation.
-- 
-- Parameters: ~
--   • {str}        String to be converted.
--   • {from_part}  Legacy Vim parameter. Usually true.
--   • {do_lt}      Also translate <lt>. Ignored if `special` is false.
--   • {special}    Replace |keycodes|, e.g. <CR> becomes a "\r" char.
-- 
-- See also: ~
--   • replace_termcodes
--   • cpoptions
--- @param str string
--- @param from_part boolean
--- @param do_lt boolean
--- @param special boolean
--- @return string
function vim.api.nvim_replace_termcodes(str, from_part, do_lt, special) end

-- Selects an item in the completion popup menu.
-- 
-- If neither |ins-completion| nor |cmdline-completion| popup menu is active
-- this API call is silently ignored. Useful for an external UI using
-- |ui-popupmenu| to control the popup menu with the mouse. Can also be used
-- in a mapping; use <Cmd> |:map-cmd| or a Lua mapping to ensure the mapping
-- doesn't end completion mode.
-- 
-- Parameters: ~
--   • {item}    Index (zero-based) of the item to select. Value of -1
--               selects nothing and restores the original text.
--   • {insert}  For |ins-completion|, whether the selection should be
--               inserted in the buffer. Ignored for |cmdline-completion|.
--   • {finish}  Finish the completion and dismiss the popup menu. Implies
--               {insert}.
--   • {opts}    Optional parameters. Reserved for future use.
--- @param item number
--- @param insert boolean
--- @param finish boolean
--- @param opts table<string, any>
function vim.api.nvim_select_popupmenu_item(item, insert, finish, opts) end

-- Sets the current buffer.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {buffer}  Buffer handle
--- @param buffer buffer
function vim.api.nvim_set_current_buf(buffer) end

-- Changes the global working directory.
-- 
-- Parameters: ~
--   • {dir}  Directory path
--- @param dir string
function vim.api.nvim_set_current_dir(dir) end

-- Sets the current line.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {line}  Line contents
--- @param line string
function vim.api.nvim_set_current_line(line) end

-- Sets the current tabpage.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle
--- @param tabpage tabpage
function vim.api.nvim_set_current_tabpage(tabpage) end

-- Sets the current window.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {window}  Window handle
--- @param window window
function vim.api.nvim_set_current_win(window) end

-- Set or change decoration provider for a |namespace|
-- 
-- This is a very general purpose interface for having lua callbacks being
-- triggered during the redraw code.
-- 
-- The expected usage is to set |extmarks| for the currently redrawn buffer.
-- |nvim_buf_set_extmark()| can be called to add marks on a per-window or
-- per-lines basis. Use the `ephemeral` key to only use the mark for the
-- current screen redraw (the callback will be called again for the next
-- redraw ).
-- 
-- Note: this function should not be called often. Rather, the callbacks
-- themselves can be used to throttle unneeded callbacks. the `on_start`
-- callback can return `false` to disable the provider until the next redraw.
-- Similarly, return `false` in `on_win` will skip the `on_lines` calls for
-- that window (but any extmarks set in `on_win` will still be used). A
-- plugin managing multiple sources of decoration should ideally only set one
-- provider, and merge the sources internally. You can use multiple `ns_id`
-- for the extmarks set/modified inside the callback anyway.
-- 
-- Note: doing anything other than setting extmarks is considered
-- experimental. Doing things like changing options are not expliticly
-- forbidden, but is likely to have unexpected consequences (such as 100% CPU
-- consumption). doing `vim.rpcnotify` should be OK, but `vim.rpcrequest` is
-- quite dubious for the moment.
-- 
-- Attributes: ~
--     Lua |vim.api| only
-- 
-- Parameters: ~
--   • {ns_id}  Namespace id from |nvim_create_namespace()|
--   • {opts}   Table of callbacks:
--              • on_start: called first on each screen redraw ["start",
--                tick]
--              • on_buf: called for each buffer being redrawn (before window
--                callbacks) ["buf", bufnr, tick]
--              • on_win: called when starting to redraw a specific window.
--                ["win", winid, bufnr, topline, botline_guess]
--              • on_line: called for each buffer line being redrawn. (The
--                interaction with fold lines is subject to change) ["win",
--                winid, bufnr, row]
--              • on_end: called at the end of a redraw cycle ["end", tick]
--- @param ns_id number
--- @param opts? table<string, any>
function vim.api.nvim_set_decoration_provider(ns_id, opts) end

-- Sets a highlight group.
-- 
-- Note:
--     Unlike the `:highlight` command which can update a highlight group,
--     this function completely replaces the definition. For example:
--     `nvim_set_hl(0, 'Visual', {})` will clear the highlight group
--     'Visual'.
-- 
-- Note:
--     The fg and bg keys also accept the string values `"fg"` or `"bg"`
--     which act as aliases to the corresponding foreground and background
--     values of the Normal group. If the Normal group has not been defined,
--     using these values results in an error.
-- 
-- Note:
--     If `link` is used in combination with other attributes; only the
--     `link` will take effect (see |:hi-link|).
-- 
-- Parameters: ~
--   • {ns_id}  Namespace id for this highlight |nvim_create_namespace()|.
--              Use 0 to set a highlight group globally |:highlight|.
--              Highlights from non-global namespaces are not active by
--              default, use |nvim_set_hl_ns()| or |nvim_win_set_hl_ns()| to
--              activate them.
--   • {name}   Highlight group name, e.g. "ErrorMsg"
--   • {val}    Highlight definition map, accepts the following keys:
--              • fg (or foreground): color name or "#RRGGBB", see note.
--              • bg (or background): color name or "#RRGGBB", see note.
--              • sp (or special): color name or "#RRGGBB"
--              • blend: integer between 0 and 100
--              • bold: boolean
--              • standout: boolean
--              • underline: boolean
--              • undercurl: boolean
--              • underdouble: boolean
--              • underdotted: boolean
--              • underdashed: boolean
--              • strikethrough: boolean
--              • italic: boolean
--              • reverse: boolean
--              • nocombine: boolean
--              • link: name of another highlight group to link to, see
--                |:hi-link|.
--              • default: Don't override existing definition |:hi-default|
--              • ctermfg: Sets foreground of cterm color |ctermfg|
--              • ctermbg: Sets background of cterm color |ctermbg|
--              • cterm: cterm attribute map, like |highlight-args|. If not
--                set, cterm attributes will match those from the attribute
--                map documented above.
--- @param ns_id number
--- @param name string
--- @param val? table<string, any>
function vim.api.nvim_set_hl(ns_id, name, val) end

-- Set active namespace for highlights defined with |nvim_set_hl()|. This can
-- be set for a single window, see |nvim_win_set_hl_ns()|.
-- 
-- Parameters: ~
--   • {ns_id}  the namespace to use
--- @param ns_id number
function vim.api.nvim_set_hl_ns(ns_id) end

-- Set active namespace for highlights defined with |nvim_set_hl()| while
-- redrawing.
-- 
-- This function meant to be called while redrawing, primarily from
-- |nvim_set_decoration_provider()| on_win and on_line callbacks, which are
-- allowed to change the namespace during a redraw cycle.
-- 
-- Attributes: ~
--     |api-fast|
-- 
-- Parameters: ~
--   • {ns_id}  the namespace to activate
--- @param ns_id number
function vim.api.nvim_set_hl_ns_fast(ns_id) end

-- Sets a global |mapping| for the given mode.
-- 
-- To set a buffer-local mapping, use |nvim_buf_set_keymap()|.
-- 
-- Unlike |:map|, leading/trailing whitespace is accepted as part of the
-- {lhs} or {rhs}. Empty {rhs} is |<Nop>|. |keycodes| are replaced as usual.
-- 
-- Example: 
-- ```vim
--     call nvim_set_keymap('n', ' <NL>', '', {'nowait': v:true})
-- ```
-- 
-- is equivalent to: 
-- ```vim
--     nmap <nowait> <Space><NL> <Nop>
-- ```
-- 
-- Parameters: ~
--   • {mode}  Mode short-name (map command prefix: "n", "i", "v", "x", …) or
--             "!" for |:map!|, or empty string for |:map|.
--   • {lhs}   Left-hand-side |{lhs}| of the mapping.
--   • {rhs}   Right-hand-side |{rhs}| of the mapping.
--   • {opts}  Optional parameters map: Accepts all |:map-arguments| as keys
--             except |<buffer>|, values are booleans (default false). Also:
--             • "noremap" non-recursive mapping |:noremap|
--             • "desc" human-readable description.
--             • "callback" Lua function called when the mapping is executed.
--             • "replace_keycodes" (boolean) When "expr" is true, replace
--               keycodes in the resulting string (see
--               |nvim_replace_termcodes()|). Returning nil from the Lua
--               "callback" is equivalent to returning an empty string.
--- @param mode string
--- @param lhs string
--- @param rhs string
--- @param opts? table<string, any>
function vim.api.nvim_set_keymap(mode, lhs, rhs, opts) end

-- Sets the global value of an option.
-- 
-- Parameters: ~
--   • {name}   Option name
--   • {value}  New option value
--- @param name string
--- @param value object
function vim.api.nvim_set_option(name, value) end

-- Sets the value of an option. The behavior of this function matches that of
-- |:set|: for global-local options, both the global and local value are set
-- unless otherwise specified with {scope}.
-- 
-- Note the options {win} and {buf} cannot be used together.
-- 
-- Parameters: ~
--   • {name}   Option name
--   • {value}  New option value
--   • {opts}   Optional parameters
--              • scope: One of "global" or "local". Analogous to
--                |:setglobal| and |:setlocal|, respectively.
--              • win: |window-ID|. Used for setting window local option.
--              • buf: Buffer number. Used for setting buffer local option.
--- @param name string
--- @param value object
--- @param opts? table<string, any>
function vim.api.nvim_set_option_value(name, value, opts) end

-- Sets a global (g:) variable.
-- 
-- Parameters: ~
--   • {name}   Variable name
--   • {value}  Variable value
--- @param name string
--- @param value object
function vim.api.nvim_set_var(name, value) end

-- Sets a v: variable, if it is not readonly.
-- 
-- Parameters: ~
--   • {name}   Variable name
--   • {value}  Variable value
--- @param name string
--- @param value object
function vim.api.nvim_set_vvar(name, value) end

-- Calculates the number of display cells occupied by `text`. Control
-- characters including <Tab> count as one cell.
-- 
-- Parameters: ~
--   • {text}  Some text
-- 
-- Return: ~
--     Number of cells
--- @param text string
--- @return number
function vim.api.nvim_strwidth(text) end

-- Removes a tab-scoped (t:) variable
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
--   • {name}     Variable name
--- @param tabpage tabpage
--- @param name string
function vim.api.nvim_tabpage_del_var(tabpage, name) end

-- Gets the tabpage number
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
-- 
-- Return: ~
--     Tabpage number
--- @param tabpage tabpage
--- @return number
function vim.api.nvim_tabpage_get_number(tabpage) end

-- Gets a tab-scoped (t:) variable
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
--   • {name}     Variable name
-- 
-- Return: ~
--     Variable value
--- @param tabpage tabpage
--- @param name string
--- @return object
function vim.api.nvim_tabpage_get_var(tabpage, name) end

-- Gets the current window in a tabpage
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
-- 
-- Return: ~
--     Window handle
--- @param tabpage tabpage
--- @return window
function vim.api.nvim_tabpage_get_win(tabpage) end

-- Checks if a tabpage is valid
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
-- 
-- Return: ~
--     true if the tabpage is valid, false otherwise
--- @param tabpage tabpage
--- @return boolean
function vim.api.nvim_tabpage_is_valid(tabpage) end

-- Gets the windows in a tabpage
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
-- 
-- Return: ~
--     List of windows in `tabpage`
--- @param tabpage tabpage
--- @return any[]
function vim.api.nvim_tabpage_list_wins(tabpage) end

-- Sets a tab-scoped (t:) variable
-- 
-- Parameters: ~
--   • {tabpage}  Tabpage handle, or 0 for current tabpage
--   • {name}     Variable name
--   • {value}    Variable value
--- @param tabpage tabpage
--- @param name string
--- @param value object
function vim.api.nvim_tabpage_set_var(tabpage, name, value) end

-- Calls a function with window as temporary current window.
-- 
-- Attributes: ~
--     Lua |vim.api| only
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {fun}     Function to call inside the window (currently lua callable
--               only)
-- 
-- Return: ~
--     Return value of function. NB: will deepcopy lua values currently, use
--     upvalues to send lua references in and out.
-- 
-- See also: ~
--   • |win_execute()|
--   • |nvim_buf_call()|
--- @param window window
--- @param fun fun()
--- @return object
function vim.api.nvim_win_call(window, fun) end

-- Closes the window (like |:close| with a |window-ID|).
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {force}   Behave like `:close!` The last window of a buffer with
--               unwritten changes can be closed. The buffer will become
--               hidden, even if 'hidden' is not set.
--- @param window window
--- @param force boolean
function vim.api.nvim_win_close(window, force) end

-- Removes a window-scoped (w:) variable
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {name}    Variable name
--- @param window window
--- @param name string
function vim.api.nvim_win_del_var(window, name) end

-- Gets the current buffer in a window
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     Buffer handle
--- @param window window
--- @return buffer
function vim.api.nvim_win_get_buf(window) end

-- Gets window configuration.
-- 
-- The returned value may be given to |nvim_open_win()|.
-- 
-- `relative` is empty for normal windows.
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     Map defining the window configuration, see |nvim_open_win()|
--- @param window window
--- @return table<string, any>
function vim.api.nvim_win_get_config(window) end

-- Gets the (1,0)-indexed, buffer-relative cursor position for a given window
-- (different windows showing the same buffer have independent cursor
-- positions). |api-indexing|
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     (row, col) tuple
--- @param window window
--- @return number[]
function vim.api.nvim_win_get_cursor(window) end

-- Gets the window height
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     Height as a count of rows
--- @param window window
--- @return number
function vim.api.nvim_win_get_height(window) end

-- Gets the window number
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     Window number
--- @param window window
--- @return number
function vim.api.nvim_win_get_number(window) end

-- Gets a window option value
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {name}    Option name
-- 
-- Return: ~
--     Option value
--- @param window window
--- @param name string
--- @return object
function vim.api.nvim_win_get_option(window, name) end

-- Gets the window position in display cells. First position is zero.
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     (row, col) tuple with the window position
--- @param window window
--- @return number[]
function vim.api.nvim_win_get_position(window) end

-- Gets the window tabpage
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     Tabpage that contains the window
--- @param window window
--- @return tabpage
function vim.api.nvim_win_get_tabpage(window) end

-- Gets a window-scoped (w:) variable
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {name}    Variable name
-- 
-- Return: ~
--     Variable value
--- @param window window
--- @param name string
--- @return object
function vim.api.nvim_win_get_var(window, name) end

-- Gets the window width
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     Width as a count of columns
--- @param window window
--- @return number
function vim.api.nvim_win_get_width(window) end

-- Closes the window and hide the buffer it contains (like |:hide| with a
-- |window-ID|).
-- 
-- Like |:hide| the buffer becomes hidden unless another window is editing
-- it, or 'bufhidden' is `unload`, `delete` or `wipe` as opposed to |:close|
-- or |nvim_win_close()|, which will close the buffer.
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--- @param window window
function vim.api.nvim_win_hide(window) end

-- Checks if a window is valid
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
-- 
-- Return: ~
--     true if the window is valid, false otherwise
--- @param window window
--- @return boolean
function vim.api.nvim_win_is_valid(window) end

-- Sets the current buffer in a window, without side effects
-- 
-- Attributes: ~
--     not allowed when |textlock| is active
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {buffer}  Buffer handle
--- @param window window
--- @param buffer buffer
function vim.api.nvim_win_set_buf(window, buffer) end

-- Configures window layout. Currently only for floating and external windows
-- (including changing a split window to those layouts).
-- 
-- When reconfiguring a floating window, absent option keys will not be
-- changed. `row`/`col` and `relative` must be reconfigured together.
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {config}  Map defining the window configuration, see |nvim_open_win()|
-- 
-- See also: ~
--   • |nvim_open_win()|
--- @param window window
--- @param config? table<string, any>
function vim.api.nvim_win_set_config(window, config) end

-- Sets the (1,0)-indexed cursor position in the window. |api-indexing| This
-- scrolls the window even if it is not the current one.
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {pos}     (row, col) tuple representing the new position
--- @param window window
--- @param pos number[]
function vim.api.nvim_win_set_cursor(window, pos) end

-- Sets the window height.
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {height}  Height as a count of rows
--- @param window window
--- @param height number
function vim.api.nvim_win_set_height(window, height) end

-- Set highlight namespace for a window. This will use highlights defined
-- with |nvim_set_hl()| for this namespace, but fall back to global
-- highlights (ns=0) when missing.
-- 
-- This takes precedence over the 'winhighlight' option.
-- 
-- Parameters: ~
--   • {ns_id}  the namespace to use
--- @param window window
--- @param ns_id number
function vim.api.nvim_win_set_hl_ns(window, ns_id) end

-- Sets a window option value. Passing `nil` as value deletes the option
-- (only works if there's a global fallback)
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {name}    Option name
--   • {value}   Option value
--- @param window window
--- @param name string
--- @param value object
function vim.api.nvim_win_set_option(window, name, value) end

-- Sets a window-scoped (w:) variable
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {name}    Variable name
--   • {value}   Variable value
--- @param window window
--- @param name string
--- @param value object
function vim.api.nvim_win_set_var(window, name, value) end

-- Sets the window width. This will only succeed if the screen is split
-- vertically.
-- 
-- Parameters: ~
--   • {window}  Window handle, or 0 for current window
--   • {width}   Width as a count of columns
--- @param window window
--- @param width number
function vim.api.nvim_win_set_width(window, width) end

