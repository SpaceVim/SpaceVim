local utils = require "indent_blankline/utils"
local M = {}

local char_highlight = "IndentBlanklineChar"
local space_char_highlight = "IndentBlanklineSpaceChar"
local space_char_blankline_highlight = "IndentBlanklineSpaceCharBlankline"
local context_highlight = "IndentBlanklineContextChar"

M.init = function()
    if not vim.g.indent_blankline_namespace then
        vim.g.indent_blankline_namespace = vim.api.nvim_create_namespace "indent_blankline"
    end

    utils.reset_highlights()

    require("indent_blankline.commands").refresh(true)
end

M.setup = function(options)
    if options == nil then
        options = {}
    end

    local o = utils.first_not_nil

    vim.g.indent_blankline_char = o(options.char, vim.g.indent_blankline_char, vim.g.indentLine_char, "│")
    vim.g.indent_blankline_char_blankline = o(options.char_blankline, vim.g.indent_blankline_char_blankline)
    vim.g.indent_blankline_char_list = o(
        options.char_list,
        vim.g.indent_blankline_char_list,
        vim.g.indentLine_char_list
    )
    vim.g.indent_blankline_char_list_blankline = o(
        options.char_list_blankline,
        vim.g.indent_blankline_char_list_blankline
    )
    vim.g.indent_blankline_context_char = o(
        options.context_char,
        vim.g.indent_blankline_context_char,
        vim.g.indent_blankline_char
    )
    vim.g.indent_blankline_context_char_blankline = o(
        options.context_char_blankline,
        vim.g.indent_blankline_context_char_blankline,
        vim.g.indent_blankline_char_blankline
    )
    vim.g.indent_blankline_context_char_list = o(options.context_char_list, vim.g.indent_blankline_context_char_list)
    vim.g.indent_blankline_context_char_list_blankline = o(
        options.context_char_list_blankline,
        vim.g.indent_blankline_context_char_list
    )
    vim.g.indent_blankline_char_highlight_list = o(
        options.char_highlight_list,
        vim.g.indent_blankline_char_highlight_list
    )
    vim.g.indent_blankline_space_char_highlight_list = o(
        options.space_char_highlight_list,
        vim.g.indent_blankline_space_char_highlight_list
    )
    vim.g.indent_blankline_space_char_blankline = o(
        options.space_char_blankline,
        vim.g.indent_blankline_space_char_blankline,
        " "
    )
    vim.g.indent_blankline_space_char_blankline_highlight_list = o(
        options.space_char_blankline_highlight_list,
        vim.g.indent_blankline_space_char_blankline_highlight_list,
        options.space_char_highlight_list,
        vim.g.indent_blankline_space_char_highlight_list
    )
    vim.g.indent_blankline_indent_level = o(options.indent_level, vim.g.indent_blankline_indent_level, 20)
    vim.g.indent_blankline_enabled = o(options.enabled, vim.g.indent_blankline_enabled, true)
    vim.g.indent_blankline_disable_with_nolist = o(
        options.disable_with_nolist,
        vim.g.indent_blankline_disable_with_nolist,
        false
    )
    vim.g.indent_blankline_filetype = o(options.filetype, vim.g.indent_blankline_filetype, vim.g.indentLine_fileType)
    vim.g.indent_blankline_filetype_exclude = o(
        options.filetype_exclude,
        vim.g.indent_blankline_filetype_exclude,
        vim.g.indentLine_fileTypeExclude,
        { "lspinfo", "packer", "checkhealth", "help", "" }
    )
    vim.g.indent_blankline_bufname_exclude = o(
        options.bufname_exclude,
        vim.g.indent_blankline_bufname_exclude,
        vim.g.indentLine_bufNameExclude
    )
    vim.g.indent_blankline_buftype_exclude = o(
        options.buftype_exclude,
        vim.g.indent_blankline_buftype_exclude,
        vim.g.indentLine_bufTypeExclude
    )
    vim.g.indent_blankline_viewport_buffer = o(options.viewport_buffer, vim.g.indent_blankline_viewport_buffer, 10)
    vim.g.indent_blankline_use_treesitter = o(options.use_treesitter, vim.g.indent_blankline_use_treesitter, false)
    vim.g.indent_blankline_max_indent_increase = o(
        options.max_indent_increase,
        vim.g.indent_blankline_max_indent_increase,
        options.indent_level,
        vim.g.indent_blankline_indent_level
    )
    vim.g.indent_blankline_show_first_indent_level = o(
        options.show_first_indent_level,
        vim.g.indent_blankline_show_first_indent_level,
        true
    )
    vim.g.indent_blankline_show_trailing_blankline_indent = o(
        options.show_trailing_blankline_indent,
        vim.g.indent_blankline_show_trailing_blankline_indent,
        true
    )
    vim.g.indent_blankline_show_end_of_line = o(
        options.show_end_of_line,
        vim.g.indent_blankline_show_end_of_line,
        false
    )
    vim.g.indent_blankline_show_foldtext = o(options.show_foldtext, vim.g.indent_blankline_show_foldtext, true)
    vim.g.indent_blankline_show_current_context = o(
        options.show_current_context,
        vim.g.indent_blankline_show_current_context,
        false
    )
    vim.g.indent_blankline_show_current_context_start = o(
        options.show_current_context_start,
        vim.g.indent_blankline_show_current_context_start,
        false
    )
    vim.g.indent_blankline_show_current_context_start_on_current_line = o(
        options.show_current_context_start_on_current_line,
        vim.g.indent_blankline_show_current_context_start_on_current_line,
        true
    )
    vim.g.indent_blankline_context_highlight_list = o(
        options.context_highlight_list,
        vim.g.indent_blankline_context_highlight_list
    )
    vim.g.indent_blankline_context_patterns = o(options.context_patterns, vim.g.indent_blankline_context_patterns, {
        "class",
        "^func",
        "method",
        "^if",
        "while",
        "for",
        "with",
        "try",
        "except",
        "arguments",
        "argument_list",
        "object",
        "dictionary",
        "element",
        "table",
        "tuple",
    })
    vim.g.indent_blankline_context_pattern_highlight = o(
        options.context_pattern_highlight,
        vim.g.indent_blankline_context_pattern_highlight
    )
    vim.g.indent_blankline_strict_tabs = o(options.strict_tabs, vim.g.indent_blankline_strict_tabs, false)

    vim.g.indent_blankline_disable_warning_message = o(
        options.disable_warning_message,
        vim.g.indent_blankline_disable_warning_message,
        false
    )
    vim.g.indent_blankline_debug = o(options.debug, vim.g.indent_blankline_debug, false)

    if vim.g.indent_blankline_show_current_context then
        vim.cmd [[
            augroup IndentBlanklineContextAutogroup
                autocmd!
                autocmd CursorMoved * IndentBlanklineRefresh
            augroup END
        ]]
    end

    vim.g.__indent_blankline_setup_completed = true
end

local refresh = function(scroll)
    local v = utils.get_variable
    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
    end

    if
        not utils.is_indent_blankline_enabled(
            vim.b.indent_blankline_enabled,
            vim.g.indent_blankline_enabled,
            v "indent_blankline_disable_with_nolist",
            vim.opt.list:get(),
            vim.bo.filetype,
            v "indent_blankline_filetype" or {},
            v "indent_blankline_filetype_exclude",
            vim.bo.buftype,
            v "indent_blankline_buftype_exclude" or {},
            v "indent_blankline_bufname_exclude" or {},
            vim.fn["bufname"] ""
        )
    then
        if vim.b.__indent_blankline_active then
            vim.schedule_wrap(utils.clear_buf_indent)(bufnr)
        end
        vim.b.__indent_blankline_active = false
        return
    else
        vim.b.__indent_blankline_active = true
    end

    local win_start = vim.fn.line "w0"
    local win_end = vim.fn.line "w$"
    local offset = math.max(win_start - 1 - v "indent_blankline_viewport_buffer", 0)
    local win_view = vim.fn.winsaveview()
    local left_offset = win_view.leftcol
    local lnum = win_view.lnum
    local left_offset_s = tostring(left_offset)
    local range = math.min(win_end + v "indent_blankline_viewport_buffer", vim.api.nvim_buf_line_count(bufnr))

    if not vim.b.__indent_blankline_ranges then
        vim.b.__indent_blankline_ranges = {}
    end

    if scroll then
        local updated_range

        if vim.b.__indent_blankline_ranges[left_offset_s] then
            local blankline_ranges = vim.b.__indent_blankline_ranges[left_offset_s]
            local need_to_update = true

            -- find a candidate that could contain the window
            local idx_candidate = utils.binary_search_ranges(blankline_ranges, { win_start, win_end })
            local candidate_start, candidate_end = unpack(blankline_ranges[idx_candidate])

            -- check if the current window is contained or if a new range needs to be created
            if candidate_start <= win_start then
                if candidate_end >= win_end then
                    need_to_update = false
                else
                    table.insert(blankline_ranges, idx_candidate + 1, { offset, range })
                end
            else
                table.insert(blankline_ranges, idx_candidate, { offset, range })
            end

            if not need_to_update then
                return
            end

            -- merge ranges and update the variable, strategies are: contains or extends
            updated_range = utils.merge_ranges(blankline_ranges)
        else
            updated_range = { { offset, range } }
        end

        -- we can't assign directly to a table key, so we update the reference to the variable
        local new_ranges = vim.b.__indent_blankline_ranges
        new_ranges[left_offset_s] = updated_range
        vim.b.__indent_blankline_ranges = new_ranges
    else
        vim.b.__indent_blankline_ranges = { [left_offset_s] = { { offset, range } } }
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, offset, range, false)
    local char = v "indent_blankline_char"
    local char_blankline = v "indent_blankline_char_blankline"
    local char_list = v "indent_blankline_char_list" or {}
    local char_list_blankline = v "indent_blankline_char_list_blankline" or {}
    local context_char = v "indent_blankline_context_char"
    local context_char_blankline = v "indent_blankline_context_char_blankline"
    local context_char_list = v "indent_blankline_context_char_list" or {}
    local context_char_list_blankline = v "indent_blankline_context_char_list_blankline" or {}
    local char_highlight_list = v "indent_blankline_char_highlight_list" or {}
    local space_char_highlight_list = v "indent_blankline_space_char_highlight_list" or {}
    local space_char_blankline_highlight_list = v "indent_blankline_space_char_blankline_highlight_list" or {}
    local space_char_blankline = v "indent_blankline_space_char_blankline"

    local list_chars
    local no_tab_character = false
    -- No need to check for disable_with_nolist as this part would never be executed if "true" && nolist
    if vim.opt.list:get() then
        -- list is set, get listchars
        local tab_characters
        local space_character = vim.opt.listchars:get().space or " "
        if vim.opt.listchars:get().tab then
            -- tab characters can be any UTF-8 character, Lua 5.1 cannot handle this without external libraries
            tab_characters = vim.fn.split(vim.opt.listchars:get().tab, "\\zs")
        else
            no_tab_character = true
            tab_characters = { "^", "I" }
        end
        list_chars = {
            space_char = space_character,
            trail_char = vim.opt.listchars:get().trail or space_character,
            lead_char = vim.opt.listchars:get().lead or space_character,
            tab_char_start = tab_characters[1] or space_character,
            tab_char_fill = tab_characters[2] or space_character,
            tab_char_end = tab_characters[3],
            eol_char = vim.opt.listchars:get().eol,
        }
    else
        -- nolist is set, replace all listchars with empty space
        list_chars = {
            space_char = " ",
            trail_char = " ",
            lead_char = " ",
            tab_char_start = " ",
            tab_char_fill = " ",
            tab_char_end = nil,
            eol_char = nil,
        }
    end

    local max_indent_level = v "indent_blankline_indent_level"
    local max_indent_increase = v "indent_blankline_max_indent_increase"
    local expandtab = vim.bo.expandtab
    local use_ts_indent = false
    local ts_indent
    if v "indent_blankline_use_treesitter" then
        local ts_query_status, ts_query = pcall(require, "nvim-treesitter.query")
        local ts_indent_status
        ts_indent_status, ts_indent = pcall(require, "nvim-treesitter.indent")
        use_ts_indent = ts_query_status and ts_indent_status and ts_query.has_indents(vim.bo.filetype)
    end
    local first_indent = v "indent_blankline_show_first_indent_level"
    local trail_indent = v "indent_blankline_show_trailing_blankline_indent"
    local end_of_line = v "indent_blankline_show_end_of_line"
    local strict_tabs = v "indent_blankline_strict_tabs"
    local foldtext = v "indent_blankline_show_foldtext"

    local tabs = vim.bo.shiftwidth == 0 or not expandtab
    local shiftwidth = utils._if(tabs, utils._if(no_tab_character, 2, vim.bo.tabstop), vim.bo.shiftwidth)

    local context_highlight_list = v "indent_blankline_context_highlight_list" or {}
    local context_pattern_highlight = v "indent_blankline_context_pattern_highlight" or {}
    local context_status, context_start, context_end, context_pattern = false, 0, 0, nil
    local show_current_context_start = v "indent_blankline_show_current_context_start"
    local show_current_context_start_on_current_line = v "indent_blankline_show_current_context_start_on_current_line"
    if v "indent_blankline_show_current_context" then
        context_status, context_start, context_end, context_pattern = utils.get_current_context(
            v "indent_blankline_context_patterns"
        )
    end

    local get_virtual_text =
        function(indent, extra, blankline, context_active, context_indent, prev_indent, virtual_string)
            local virtual_text = {}
            local current_left_offset = left_offset
            local local_max_indent_level = math.min(max_indent_level, prev_indent + max_indent_increase)
            local indent_char = utils._if(blankline and char_blankline, char_blankline, char)
            local context_indent_char = utils._if(
                blankline and context_char_blankline,
                context_char_blankline,
                context_char
            )
            local indent_char_list = utils._if(blankline and #char_list_blankline > 0, char_list_blankline, char_list)
            local context_indent_char_list = utils._if(
                blankline and #context_char_list_blankline > 0,
                context_char_list_blankline,
                context_char_list
            )
            for i = 1, math.min(math.max(indent, 0), local_max_indent_level) do
                local space_count = shiftwidth
                local context = context_active and context_indent == i
                local show_indent_char = (i ~= 1 or first_indent) and indent_char ~= ""
                local show_context_indent_char = context and (i ~= 1 or first_indent) and context_indent_char ~= ""
                local show_end_of_line_char = i == 1 and blankline and end_of_line and list_chars["eol_char"]
                local show_indent_or_eol_char = show_indent_char or show_context_indent_char or show_end_of_line_char
                if show_indent_or_eol_char then
                    space_count = space_count - 1
                    if current_left_offset > 0 then
                        current_left_offset = current_left_offset - 1
                    else
                        table.insert(virtual_text, {
                            utils._if(
                                show_end_of_line_char,
                                list_chars["eol_char"],
                                utils._if(
                                    context,
                                    utils.get_from_list(
                                        context_indent_char_list,
                                        i - utils._if(not first_indent, 1, 0),
                                        context_indent_char
                                    ),
                                    utils.get_from_list(
                                        indent_char_list,
                                        i - utils._if(not first_indent, 1, 0),
                                        indent_char
                                    )
                                )
                            ),
                            utils._if(
                                context,
                                utils._if(
                                    context_pattern_highlight[context_pattern],
                                    context_pattern_highlight[context_pattern],
                                    utils.get_from_list(context_highlight_list, i, context_highlight)
                                ),
                                utils.get_from_list(char_highlight_list, i, char_highlight)
                            ),
                        })
                    end
                end
                if current_left_offset > 0 then
                    local current_space_count = space_count
                    space_count = space_count - current_left_offset
                    current_left_offset = current_left_offset - current_space_count
                end
                if space_count > 0 then
                    -- ternary operator below in table.insert() doesn't work because it would evaluate each option regardless
                    local tmp_string
                    local index = 1 + (i - 1) * shiftwidth
                    if show_indent_or_eol_char then
                        if table.maxn(virtual_string) >= index + space_count then
                            -- first char was already set above
                            tmp_string = table.concat(virtual_string, "", index + 1, index + space_count)
                        end
                    else
                        if table.maxn(virtual_string) >= index + space_count - 1 then
                            tmp_string = table.concat(virtual_string, "", index, index + space_count - 1)
                        end
                    end
                    table.insert(virtual_text, {
                        utils._if(
                            tmp_string,
                            tmp_string,
                            utils._if(blankline, space_char_blankline, list_chars["lead_char"]):rep(space_count)
                        ),
                        utils._if(
                            blankline,
                            utils.get_from_list(space_char_blankline_highlight_list, i, space_char_blankline_highlight),
                            utils.get_from_list(space_char_highlight_list, i, space_char_highlight)
                        ),
                    })
                end
            end

            local index = math.ceil(#virtual_text / 2) + 1
            local extra_context_active = context_active and context_indent == index

            if
                (
                    (indent_char ~= "" or #indent_char_list > 0)
                    or (extra_context_active and (context_indent_char ~= "" or #context_char_list > 0))
                )
                and ((blankline or extra) and trail_indent)
                and (first_indent or #virtual_text > 0)
                and current_left_offset < 1
                and indent < local_max_indent_level
            then
                table.insert(virtual_text, {
                    utils._if(
                        extra_context_active,
                        utils.get_from_list(
                            context_indent_char_list,
                            index - utils._if(not first_indent, 1, 0),
                            context_indent_char
                        ),
                        utils.get_from_list(indent_char_list, index - utils._if(not first_indent, 1, 0), indent_char)
                    ),
                    utils._if(
                        extra_context_active,
                        utils.get_from_list(context_highlight_list, index, context_highlight),
                        utils.get_from_list(char_highlight_list, index, char_highlight)
                    ),
                })
            end

            return virtual_text
        end

    local prev_indent
    local next_indent
    local next_extra
    local empty_line_counter = 0
    local context_indent
    for i = 1, #lines do
        if foldtext and vim.fn.foldclosed(i + offset) > 0 then
            utils.clear_line_indent(bufnr, i + offset)
        else
            local async
            async = vim.loop.new_async(function()
                local blankline = lines[i]:len() == 0
                local whitespace = string.match(lines[i], "^%s+") or ""
                local only_whitespace = whitespace == lines[i]
                local context_active = false
                local context_first_line = false
                if context_status then
                    context_active = offset + i > context_start and offset + i <= context_end
                    context_first_line = offset + i == context_start
                end

                if blankline and use_ts_indent then
                    vim.schedule_wrap(function()
                        local indent = ts_indent.get_indent(i + offset) or 0
                        utils.clear_line_indent(bufnr, i + offset)

                        if
                            context_first_line
                            and show_current_context_start
                            and (show_current_context_start_on_current_line or lnum ~= context_start)
                        then
                            xpcall(
                                vim.api.nvim_buf_set_extmark,
                                utils.error_handler,
                                bufnr,
                                vim.g.indent_blankline_namespace,
                                context_start - 1,
                                #whitespace,
                                {
                                    end_col = #lines[i],
                                    hl_group = "IndentBlanklineContextStart",
                                    priority = 10000,
                                }
                            )
                        end

                        if indent == 0 then
                            return
                        end

                        indent = indent / shiftwidth
                        if context_first_line then
                            context_indent = indent + 1
                        end

                        local virtual_text = get_virtual_text(
                            indent,
                            false,
                            blankline,
                            context_active,
                            context_indent,
                            max_indent_level,
                            {}
                        )
                        xpcall(
                            vim.api.nvim_buf_set_extmark,
                            utils.error_handler,
                            bufnr,
                            vim.g.indent_blankline_namespace,
                            i - 1 + offset,
                            0,
                            { virt_text = virtual_text, virt_text_pos = "overlay", hl_mode = "combine", priority = 1 }
                        )
                    end)()
                    return async:close()
                end

                local indent, extra
                local virtual_string = {}
                if not blankline then
                    indent, extra, virtual_string = utils.find_indent(
                        whitespace,
                        only_whitespace,
                        shiftwidth,
                        strict_tabs,
                        list_chars
                    )
                elseif empty_line_counter > 0 then
                    empty_line_counter = empty_line_counter - 1
                    indent = next_indent
                    extra = next_extra
                else
                    if i == #lines then
                        indent = 0
                        extra = false
                    else
                        local j = i + 1
                        while j < #lines and lines[j]:len() == 0 do
                            j = j + 1
                            empty_line_counter = empty_line_counter + 1
                        end
                        local j_whitespace = string.match(lines[j], "^%s+")
                        local j_only_whitespace = j_whitespace == lines[j]
                        indent, extra, _ = utils.find_indent(
                            j_whitespace,
                            j_only_whitespace,
                            shiftwidth,
                            strict_tabs,
                            list_chars
                        )
                    end
                    next_indent = indent
                    next_extra = extra
                end

                if context_first_line then
                    context_indent = indent + 1
                end

                vim.schedule_wrap(utils.clear_line_indent)(bufnr, i + offset)
                if
                    context_first_line
                    and show_current_context_start
                    and (show_current_context_start_on_current_line or lnum ~= context_start)
                then
                    vim.schedule_wrap(function()
                        xpcall(
                            vim.api.nvim_buf_set_extmark,
                            utils.error_handler,
                            bufnr,
                            vim.g.indent_blankline_namespace,
                            context_start - 1,
                            #whitespace,
                            {
                                end_col = #lines[i],
                                hl_group = "IndentBlanklineContextStart",
                                priority = 10000,
                            }
                        )
                    end)()
                end

                if indent == 0 and #virtual_string == 0 and not extra then
                    prev_indent = 0
                    return async:close()
                end

                if not prev_indent or indent + utils._if(extra, 1, 0) <= prev_indent + max_indent_increase then
                    prev_indent = indent
                end

                local virtual_text = get_virtual_text(
                    indent,
                    extra,
                    blankline,
                    context_active,
                    context_indent,
                    prev_indent - utils._if(trail_indent, 0, 1),
                    virtual_string
                )
                vim.schedule_wrap(function()
                    xpcall(
                        vim.api.nvim_buf_set_extmark,
                        utils.error_handler,
                        bufnr,
                        vim.g.indent_blankline_namespace,
                        i - 1 + offset,
                        0,
                        { virt_text = virtual_text, virt_text_pos = "overlay", hl_mode = "combine", priority = 1 }
                    )
                end)()
                return async:close()
            end)

            async:send()
        end
    end
end

M.refresh = function(scroll)
    xpcall(refresh, utils.error_handler, scroll)
end

return M
