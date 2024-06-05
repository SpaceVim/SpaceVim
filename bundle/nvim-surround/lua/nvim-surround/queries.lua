local utils = require("nvim-surround.utils")
local ts_query = require("nvim-treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_parsers = require("nvim-treesitter.parsers")

local M = {}

-- Retrieves the node that corresponds exactly to a given selection.
---@param selection selection The given selection.
---@return _ @The corresponding node.
---@nodiscard
M.get_node = function(selection)
    -- Convert the selection into a list
    local range = {
        selection.first_pos[1],
        selection.first_pos[2],
        selection.last_pos[1],
        selection.last_pos[2],
    }

    -- Get the root node of the current tree
    local lang_tree = ts_parsers.get_parser(0)
    local tree = lang_tree:trees()[1]
    local root = tree:root()
    -- DFS through the tree and find all nodes that have the given type
    local stack = { root }
    while #stack > 0 do
        local cur = stack[#stack]
        -- If the current node's range is equal to the desired selection, return the node
        if vim.deep_equal(range, { ts_utils.get_vim_range({ cur:range() }) }) then
            return cur
        end
        -- Pop off of the stack
        stack[#stack] = nil
        -- Add the current node's children to the stack
        for child in cur:iter_children() do
            stack[#stack + 1] = child
        end
    end
    return nil
end

-- Filters an existing parent selection down to a capture.
---@param sexpr string The given S-expression containing the capture.
---@param capture string The name of the capture to be returned.
---@param parent_selection selection The parent selection to be filtered down.
M.filter_selection = function(sexpr, capture, parent_selection)
    local parent_node = M.get_node(parent_selection)

    local range = { ts_utils.get_vim_range({ parent_node:range() }) }
    local lang_tree = ts_parsers.get_parser(0)
    local ok, parsed_query = pcall(function()
        return vim.treesitter.query.parse and vim.treesitter.query.parse(lang_tree:lang(), sexpr)
            or vim.treesitter.parse_query(lang_tree:lang(), sexpr)
    end)
    if not ok or not parent_node then
        return {}
    end

    for id, node in parsed_query:iter_captures(parent_node, 0, 0, -1) do
        local name = parsed_query.captures[id]
        if name == capture then
            range = { ts_utils.get_vim_range({ node:range() }) }
            return {
                first_pos = { range[1], range[2] },
                last_pos = { range[3], range[4] },
            }
        end
    end
    return nil
end

-- Finds the nearest selection of a given query capture and its source.
---@param capture string The capture to be retrieved.
---@param type string The type of query to get the capture from.
---@return selection|nil @The selection of the capture.
---@nodiscard
M.get_selection = function(capture, type)
    -- Get a table of all nodes that match the query
    local table_list = ts_query.get_capture_matches_recursively(0, capture, type)
    -- Convert the list of nodes into a list of selections
    local selections_list = {}
    for _, tab in ipairs(table_list) do
        local range = { ts_utils.get_vim_range({ tab.node:range() }) }
        selections_list[#selections_list + 1] = {
            left = {
                first_pos = { range[1], range[2] },
                last_pos = { range[3], range[4] },
            },
            right = {
                first_pos = { range[3], range[4] + 1 },
                last_pos = { range[3], range[4] },
            },
        }
    end
    -- Filter out the best pair of selections from the list
    local best_selections = utils.filter_selections_list(selections_list)
    return best_selections
        and {
            first_pos = best_selections.left.first_pos,
            last_pos = best_selections.right.last_pos,
        }
end

return M
