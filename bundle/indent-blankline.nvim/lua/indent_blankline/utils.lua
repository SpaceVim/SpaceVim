local M = {}

M.memo = setmetatable({
    put = function(cache, params, result)
        local node = cache
        for i = 1, #params do
            local param = vim.inspect(params[i])
            node.children = node.children or {}
            node.children[param] = node.children[param] or {}
            node = node.children[param]
        end
        node.result = result
    end,
    get = function(cache, params)
        local node = cache
        for i = 1, #params do
            local param = vim.inspect(params[i])
            node = node.children and node.children[param]
            if not node then
                return nil
            end
        end
        return node.result
    end,
}, {
    __call = function(memo, func)
        local cache = {}

        return function(...)
            local params = { ... }
            local result = memo.get(cache, params)
            if not result then
                result = { func(...) }
                memo.put(cache, params, result)
            end
            return unpack(result)
        end
    end,
})

M.error_handler = function(err, level)
    if err:match "Invalid buffer id.*" then
        return
    end
    if not pcall(require, "notify") then
        err = string.format("indent-blankline: %s", err)
    end
    vim.notify_once(err, level or vim.log.levels.DEBUG, {
        title = "indent-blankline",
    })
end

M.is_indent_blankline_enabled = M.memo(
    function(
        b_enabled,
        g_enabled,
        disable_with_nolist,
        opt_list,
        filetype,
        filetype_include,
        filetype_exclude,
        buftype,
        buftype_exclude,
        bufname_exclude,
        bufname
    )
        if b_enabled ~= nil then
            return b_enabled
        end
        if g_enabled ~= true then
            return false
        end
        if disable_with_nolist and not opt_list then
            return false
        end

        local plain = M._if(vim.fn.has "nvim-0.6.0" == 1, { plain = true }, true)
        local undotted_filetypes = vim.split(filetype, ".", plain)
        table.insert(undotted_filetypes, filetype)

        for _, ft in ipairs(filetype_exclude) do
            for _, undotted_filetype in ipairs(undotted_filetypes) do
                if undotted_filetype == ft then
                    return false
                end
            end
        end

        for _, bt in ipairs(buftype_exclude) do
            if bt == buftype then
                return false
            end
        end

        for _, bn in ipairs(bufname_exclude) do
            if vim.fn["matchstr"](bufname, bn) == bufname then
                return false
            end
        end

        if #filetype_include > 0 then
            for _, ft in ipairs(filetype_include) do
                if ft == filetype then
                    return true
                end
            end
            return false
        end

        return true
    end
)

M.clear_line_indent = function(buf, lnum)
    xpcall(vim.api.nvim_buf_clear_namespace, M.error_handler, buf, vim.g.indent_blankline_namespace, lnum - 1, lnum)
end

M.clear_buf_indent = function(buf)
    xpcall(vim.api.nvim_buf_clear_namespace, M.error_handler, buf, vim.g.indent_blankline_namespace, 0, -1)
end

M.get_from_list = function(list, i, default)
    if not list or #list == 0 then
        return default
    end
    return list[((i - 1) % #list) + 1]
end

M._if = function(bool, a, b)
    if bool then
        return a
    else
        return b
    end
end

M.find_indent = function(whitespace, only_whitespace, shiftwidth, strict_tabs, list_chars)
    local indent = 0
    local spaces = 0
    local tab_width
    local virtual_string = {}

    if whitespace then
        for ch in whitespace:gmatch "." do
            if ch == "\t" then
                if strict_tabs and indent == 0 and spaces ~= 0 then
                    return 0, false, {}
                end
                indent = indent + math.floor(spaces / shiftwidth) + 1
                spaces = 0
                -- replace dynamic-width tab with fixed-width string (ta..ab)
                tab_width = shiftwidth - table.maxn(virtual_string) % shiftwidth
                -- check if tab_char_end is set, see :help listchars
                if list_chars["tab_char_end"] then
                    if tab_width == 1 then
                        table.insert(virtual_string, list_chars["tab_char_end"])
                    else
                        table.insert(virtual_string, list_chars["tab_char_start"])
                        for _ = 1, (tab_width - 2) do
                            table.insert(virtual_string, list_chars["tab_char_fill"])
                        end
                        table.insert(virtual_string, list_chars["tab_char_end"])
                    end
                else
                    table.insert(virtual_string, list_chars["tab_char_start"])
                    for _ = 1, (tab_width - 1) do
                        table.insert(virtual_string, list_chars["tab_char_fill"])
                    end
                end
            else
                if strict_tabs and indent ~= 0 then
                    -- return early when no more tabs are found
                    return indent, true, virtual_string
                end
                if only_whitespace then
                    -- if the entire line is only whitespace use trail_char instead of lead_char
                    table.insert(virtual_string, list_chars["trail_char"])
                else
                    table.insert(virtual_string, list_chars["lead_char"])
                end
                spaces = spaces + 1
            end
        end
    end

    return indent + math.floor(spaces / shiftwidth), table.maxn(virtual_string) % shiftwidth ~= 0, virtual_string
end

M.get_current_context = function(type_patterns, use_treesitter_scope)
    local ts_utils_status, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
    if not ts_utils_status then
        vim.schedule_wrap(function()
            M.error_handler("nvim-treesitter not found. Context will not work", vim.log.levels.WARN)
        end)()
        return false
    end
    local locals = require "nvim-treesitter.locals"
    local cursor_node = ts_utils.get_node_at_cursor()

    if use_treesitter_scope then
        local current_scope = locals.containing_scope(cursor_node, 0)
        if not current_scope then
            return false
        end
        local node_start, _, node_end, _ = current_scope:range()
        if node_start == node_end then
            return false
        end
        return true, node_start + 1, node_end + 1, current_scope:type()
    end

    while cursor_node do
        local node_type = cursor_node:type()
        for _, rgx in ipairs(type_patterns) do
            if node_type:find(rgx) then
                local node_start, _, node_end, _ = cursor_node:range()
                if node_start ~= node_end then
                    return true, node_start + 1, node_end + 1, rgx
                end
            end
        end
        cursor_node = cursor_node:parent()
    end

    return false
end

M.reset_highlights = function()
    local whitespace_highlight = vim.fn.synIDtrans(vim.fn.hlID "Whitespace")
    local label_highlight = vim.fn.synIDtrans(vim.fn.hlID "Label")

    local whitespace_fg = {
        vim.fn.synIDattr(whitespace_highlight, "fg", "gui"),
        vim.fn.synIDattr(whitespace_highlight, "fg", "cterm"),
    }
    local label_fg = {
        vim.fn.synIDattr(label_highlight, "fg", "gui"),
        vim.fn.synIDattr(label_highlight, "fg", "cterm"),
    }

    for highlight_name, highlight in pairs {
        IndentBlanklineChar = whitespace_fg,
        IndentBlanklineSpaceChar = whitespace_fg,
        IndentBlanklineSpaceCharBlankline = whitespace_fg,
        IndentBlanklineContextChar = label_fg,
        IndentBlanklineContextStart = label_fg,
    } do
        local current_highlight = vim.fn.synIDtrans(vim.fn.hlID(highlight_name))
        if
            vim.fn.synIDattr(current_highlight, "fg") == ""
            and vim.fn.synIDattr(current_highlight, "bg") == ""
            and vim.fn.synIDattr(current_highlight, "sp") == ""
        then
            if highlight_name == "IndentBlanklineContextStart" then
                vim.cmd(
                    string.format(
                        "highlight %s guisp=%s gui=underline cterm=underline",
                        highlight_name,
                        M._if(highlight[1] == "", "NONE", highlight[1])
                    )
                )
            else
                vim.cmd(
                    string.format(
                        "highlight %s guifg=%s ctermfg=%s gui=nocombine cterm=nocombine",
                        highlight_name,
                        M._if(highlight[1] == "", "NONE", highlight[1]),
                        M._if(highlight[2] == "", "NONE", highlight[2])
                    )
                )
            end
        end
    end
end

M.first_not_nil = function(...)
    for _, value in pairs { ... } do -- luacheck: ignore
        return value
    end
end

M.get_variable = function(key)
    if vim.b[key] ~= nil then
        return vim.b[key]
    end
    if vim.t[key] ~= nil then
        return vim.t[key]
    end
    return vim.g[key]
end

M.merge_ranges = function(ranges)
    local merged_ranges = { { unpack(ranges[1]) } }

    for i = 2, #ranges do
        local current_end = merged_ranges[#merged_ranges][2]
        local next_start, next_end = unpack(ranges[i])
        if current_end >= next_start - 1 then
            if current_end < next_end then
                merged_ranges[#merged_ranges][2] = next_end
            end
        else
            table.insert(merged_ranges, { next_start, next_end })
        end
    end

    return merged_ranges
end

M.binary_search_ranges = function(ranges, target_range)
    local exact_match = false
    local idx_start = 1
    local idx_end = #ranges
    local idx_mid

    local range_start
    local target_start = target_range[1]

    while idx_start < idx_end do
        idx_mid = math.ceil((idx_start + idx_end) / 2)
        range_start = ranges[idx_mid][1]

        if range_start == target_start then
            exact_match = true
            break
        elseif range_start < target_start then
            idx_start = idx_mid -- it's important to make the low-end inclusive
        else
            idx_end = idx_mid - 1
        end
    end

    -- if we don't have an exact match, choose the smallest index
    if not exact_match then
        idx_mid = idx_start
    end

    return idx_mid
end

return M
