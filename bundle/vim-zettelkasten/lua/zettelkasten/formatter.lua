local M = {}
local s_formatters = {
    ["%r"] = function(line)
        return #line.references
    end,
    ["%b"] = function(line)
        return #line.back_references
    end,
    ["%f"] = function(line)
        return vim.fn.fnamemodify(line.file_name, ":t")
    end,
    ["%h"] = function(line)
        return line.title
    end,
    ["%d"] = function(line)
        return line.id
    end,
    ["%t"] = function(line)
        local tags = {}
        for _, tag in ipairs(line.tags) do
            if vim.tbl_contains(tags, tag.name) == false then
                table.insert(tags, tag.name)
            end
        end

        return table.concat(tags, " ")
    end,
}

local function get_format_keys(format)
    local matches = {}
    for w in string.gmatch(format, "%%%a") do
        table.insert(matches, w)
    end

    return matches
end

function M.format(lines, format)
    local formatted_lines = {}
    local modifiers = get_format_keys(format)
    for _, line in ipairs(lines) do
        local cmps = format
        for _, modifier in ipairs(modifiers) do
            cmps = string.gsub(cmps, "%" .. modifier, s_formatters[modifier](line))
        end

        table.insert(formatted_lines, cmps)
    end

    return formatted_lines
end

return M
