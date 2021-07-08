local M = {}

M.memo =
    setmetatable(
    {
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
        end
    },
    {
        __call = function(memo, func)
            local cache = {}

            return function(...)
                local params = {...}
                local result = memo.get(cache, params)
                if not result then
                    result = {func(...)}
                    memo.put(cache, params, result)
                end
                return unpack(result)
            end
        end
    }
)

M.error_handler = function(err)
    if vim.g.indent_blankline_debug then
        vim.cmd("echohl Error")
        vim.cmd('echomsg "' .. err .. '"')
        vim.cmd("echohl None")
    end
end

M.is_indent_blankline_enabled =
    M.memo(
    function(
        b_enabled,
        g_enabled,
        filetype,
        filetype_include,
        filetype_exclude,
        buftype,
        buftype_exclude,
        bufname_exclude,
        bufname)
        if b_enabled ~= nil then
            return b_enabled
        end
        if g_enabled == false then
            return false
        end

        for _, ft in ipairs(filetype_exclude) do
            if ft == filetype then
                return false
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

M.get_from_list = function(list, i)
    return list[((i - 1) % #list) + 1]
end

M._if = function(bool, a, b)
    if bool then
        return a
    else
        return b
    end
end

M.find_indent = function(line, shiftwidth, strict_tabs)
    local indent = 0
    local spaces = 0
    for ch in line:gmatch(".") do
        if ch == "	" then
            if strict_tabs and indent == 0 and spaces ~= 0 then
                return 0, false
            end
            indent = indent + math.floor(spaces / shiftwidth) + 1
            spaces = 0
        elseif ch == " " then
            if strict_tabs and indent ~= 0 then
                return indent, true
            end
            spaces = spaces + 1
        else
            break
        end
    end
    indent = indent + math.floor(spaces / shiftwidth)
    return indent, spaces % shiftwidth ~= 0
end

M.get_current_context = function(type_patterns)
    local ts_utils = require "nvim-treesitter.ts_utils"
    local cursor_node = ts_utils.get_node_at_cursor()

    while cursor_node do
        local node_type = cursor_node:type()
        for _, rgx in ipairs(type_patterns) do
            if node_type:find(rgx) then
                local node_start, _, node_end, _ = cursor_node:range()
                if node_start ~= node_end then
                    return true, node_start + 1, node_end + 1
                end
                node_start, node_end = nil, nil
            end
        end
        cursor_node = cursor_node:parent()
    end

    return false
end

M.reset_highlights = function()
    local whitespace_highlight = vim.fn.synIDtrans(vim.fn.hlID("Whitespace"))
    local label_highlight = vim.fn.synIDtrans(vim.fn.hlID("Label"))

    local whitespace_fg = {
        vim.fn.synIDattr(whitespace_highlight, "fg", "gui"),
        vim.fn.synIDattr(whitespace_highlight, "fg", "cterm")
    }
    local label_fg = {
        vim.fn.synIDattr(label_highlight, "fg", "gui"),
        vim.fn.synIDattr(label_highlight, "fg", "cterm")
    }

    for highlight_name, highlight in pairs(
        {
            IndentBlanklineChar = whitespace_fg,
            IndentBlanklineSpaceChar = whitespace_fg,
            IndentBlanklineSpaceCharBlankline = whitespace_fg,
            IndentBlanklineContextChar = label_fg
        }
    ) do
        local current_highlight = vim.fn.synIDtrans(vim.fn.hlID(highlight_name))
        if vim.fn.synIDattr(current_highlight, "fg") == "" and vim.fn.synIDattr(current_highlight, "bg") == "" then
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

return M
