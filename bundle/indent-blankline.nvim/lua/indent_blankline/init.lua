local ts_status, ts_query = pcall(require, "nvim-treesitter.query")
local ts_status, ts_indent = pcall(require, "nvim-treesitter.indent")
local utils = require "indent_blankline/utils"
local M = {}

local char_highlight = "IndentBlanklineChar"
local space_char_highlight = "IndentBlanklineSpaceChar"
local space_char_blankline_highlight = "IndentBlanklineSpaceCharBlankline"
local context_highlight = "IndentBlanklineContextChar"

M.setup = function()
    vim.g.indent_blankline_namespace = vim.api.nvim_create_namespace("indent_blankline")

    utils.reset_highlights()
end

local refresh = function()
    if
        not utils.is_indent_blankline_enabled(
            vim.b.indent_blankline_enabled,
            vim.g.indent_blankline_enabled,
            vim.bo.filetype,
            vim.g.indent_blankline_filetype,
            vim.g.indent_blankline_filetype_exclude,
            vim.bo.buftype,
            vim.g.indent_blankline_buftype_exclude,
            vim.g.indent_blankline_bufname_exclude,
            vim.fn["bufname"]("")
        )
     then
        vim.b.__indent_blankline_active = false
        return
    else
        vim.b.__indent_blankline_active = true
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local offset = math.max(vim.fn.line("w0") - 1 - vim.g.indent_blankline_viewport_buffer, 0)
    local range =
        math.min(vim.fn.line("w$") + vim.g.indent_blankline_viewport_buffer, vim.api.nvim_buf_line_count(bufnr))
    local lines = vim.api.nvim_buf_get_lines(bufnr, offset, range, false)
    local char = vim.g.indent_blankline_char
    local char_list = vim.g.indent_blankline_char_list
    local char_highlight_list = vim.g.indent_blankline_char_highlight_list
    local space_char_highlight_list = vim.g.indent_blankline_space_char_highlight_list
    local space_char_blankline_highlight_list = vim.g.indent_blankline_space_char_blankline_highlight_list
    local space_char = vim.g.indent_blankline_space_char
    local space_char_blankline = vim.g.indent_blankline_space_char_blankline
    local max_indent_level = vim.g.indent_blankline_indent_level
    local expandtab = vim.bo.expandtab
    local use_ts_indent = vim.g.indent_blankline_use_treesitter and ts_status and ts_query.has_indents(vim.bo.filetype)
    local first_indent = vim.g.indent_blankline_show_first_indent_level
    local trail_indent = vim.g.indent_blankline_show_trailing_blankline_indent
    local end_of_line = vim.g.indent_blankline_show_end_of_line
    local end_of_line_char = vim.fn["indent_blankline#helper#GetListChar"]("eol", "")
    local strict_tabs = vim.g.indent_blankline_strict_tabs
    local foldtext = vim.g.indent_blankline_show_foldtext

    local tabs = vim.bo.shiftwidth == 0 or not expandtab
    local space = utils._if(tabs, vim.bo.tabstop, vim.bo.shiftwidth)

    local context_highlight_list = vim.g.indent_blankline_context_highlight_list
    local context_status, context_start, context_end = false, 0, 0
    if vim.g.indent_blankline_show_current_context then
        context_status, context_start, context_end = utils.get_current_context(vim.g.indent_blankline_context_patterns)
    end

    local get_virtual_text = function(indent, extra, blankline, context_active, context_indent)
        local virtual_text = {}
        for i = 1, math.min(math.max(indent, 0), max_indent_level) do
            local space_count = space
            local context = context_active and context_indent == i
            if i ~= 1 or first_indent then
                space_count = space_count - 1
                table.insert(
                    virtual_text,
                    {
                        utils._if(
                            i == 1 and blankline and end_of_line and #end_of_line_char > 0,
                            end_of_line_char,
                            utils._if(
                                #char_list > 0,
                                utils.get_from_list(char_list, i - utils._if(not first_indent, 1, 0)),
                                char
                            )
                        ),
                        utils._if(
                            context,
                            utils._if(
                                #context_highlight_list > 0,
                                utils.get_from_list(context_highlight_list, i),
                                context_highlight
                            ),
                            utils._if(
                                #char_highlight_list > 0,
                                utils.get_from_list(char_highlight_list, i),
                                char_highlight
                            )
                        )
                    }
                )
            end
            table.insert(
                virtual_text,
                {
                    utils._if(blankline, space_char_blankline, space_char):rep(space_count),
                    utils._if(
                        blankline,
                        utils._if(
                            #space_char_blankline_highlight_list > 0,
                            utils.get_from_list(space_char_blankline_highlight_list, i),
                            space_char_blankline_highlight
                        ),
                        utils._if(
                            #space_char_highlight_list > 0,
                            utils.get_from_list(space_char_highlight_list, i),
                            space_char_highlight
                        )
                    )
                }
            )
        end

        if ((blankline or extra) and trail_indent) and (first_indent or #virtual_text > 0) then
            local index = math.ceil(#virtual_text / 2) + 1
            table.insert(
                virtual_text,
                {
                    utils._if(
                        #char_list > 0,
                        utils.get_from_list(char_list, index - utils._if(not first_indent, 1, 0)),
                        char
                    ),
                    utils._if(
                        context_active and context_indent == index,
                        utils._if(
                            #context_highlight_list > 0,
                            utils.get_from_list(context_highlight_list, index),
                            context_highlight
                        ),
                        utils._if(
                            #char_highlight_list > 0,
                            utils.get_from_list(char_highlight_list, index),
                            char_highlight
                        )
                    )
                }
            )
        end

        return virtual_text
    end

    local next_indent
    local next_extra
    local empty_line_counter = 0
    local context_indent
    for i = 1, #lines do
        if foldtext and vim.fn.foldclosed(i + offset) > 0 then
            utils.clear_line_indent(bufnr, i + offset)
        else
            local async
            async =
                vim.loop.new_async(
                function()
                    local blankline = lines[i]:len() == 0
                    local context_active = false
                    if context_status then
                        context_active = offset + i > context_start and offset + i <= context_end
                    end

                    if blankline and use_ts_indent then
                        vim.schedule_wrap(
                            function()
                                local indent = ts_indent.get_indent(i + offset)
                                if not indent or indent == 0 then
                                    utils.clear_line_indent(bufnr, i + offset)
                                    return
                                end
                                indent = indent / space
                                if offset + i == context_start then
                                    context_indent = (indent or 0) + 1
                                end

                                local virtual_text =
                                    get_virtual_text(indent, false, blankline, context_active, context_indent)
                                utils.clear_line_indent(bufnr, i + offset)
                                xpcall(
                                    vim.api.nvim_buf_set_extmark,
                                    utils.error_handler,
                                    bufnr,
                                    vim.g.indent_blankline_namespace,
                                    i - 1 + offset,
                                    0,
                                    {virt_text = virtual_text, virt_text_pos = "overlay", hl_mode = "combine"}
                                )
                            end
                        )()
                        return async:close()
                    end

                    local indent, extra
                    if not blankline then
                        indent, extra = utils.find_indent(lines[i], space, strict_tabs)
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
                            while (j < #lines and lines[j]:len() == 0) do
                                j = j + 1
                                empty_line_counter = empty_line_counter + 1
                            end
                            indent, extra = utils.find_indent(lines[j], space, strict_tabs)
                        end
                        next_indent = indent
                        next_extra = extra
                    end

                    if offset + i == context_start then
                        context_indent = (indent or 0) + 1
                    end

                    if not indent or indent == 0 then
                        vim.schedule_wrap(utils.clear_line_indent)(bufnr, i + offset)
                        return async:close()
                    end

                    local virtual_text = get_virtual_text(indent, extra, blankline, context_active, context_indent)
                    vim.schedule_wrap(
                        function()
                            utils.clear_line_indent(bufnr, i + offset)
                            xpcall(
                                vim.api.nvim_buf_set_extmark,
                                utils.error_handler,
                                bufnr,
                                vim.g.indent_blankline_namespace,
                                i - 1 + offset,
                                0,
                                {virt_text = virtual_text, virt_text_pos = "overlay", hl_mode = "combine"}
                            )
                        end
                    )()
                    return async:close()
                end
            )

            async:send()
        end
    end
end

M.refresh = function()
    xpcall(refresh, utils.error_handler)
end

return M
