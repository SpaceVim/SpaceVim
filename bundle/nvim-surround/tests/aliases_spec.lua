local set_curpos = function(pos)
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
end
local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
local check_lines = function(lines)
    assert.are.same(lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

describe("aliases", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    it("can be used for deleting delimiter pairs", function()
        set_lines({ [["This 'sentence' has `so many` types of 'quotes' in it"]] })

        set_curpos({ 1, 7 })
        vim.cmd("normal dsq")
        check_lines({ [["This sentence has `so many` types of 'quotes' in it"]] })

        set_curpos({ 1, 28 })
        vim.cmd("normal dsq")
        check_lines({ [["This sentence has so many types of 'quotes' in it"]] })

        set_curpos({ 1, 40 })
        vim.cmd("normal dsq")
        check_lines({ [["This sentence has so many types of quotes in it"]] })
        vim.cmd("normal dsq")
        check_lines({ [[This sentence has so many types of quotes in it]] })
    end)

    it("can be used for changing delimiter pairs", function()
        set_lines({ [["This 'sentence' has `so many` types of 'quotes' in it"]] })

        set_curpos({ 1, 7 })
        vim.cmd("normal csqB")
        check_lines({ [["This {sentence} has `so many` types of 'quotes' in it"]] })

        set_curpos({ 1, 28 })
        vim.cmd("normal csqa")
        check_lines({ [["This {sentence} has <so many> types of 'quotes' in it"]] })

        set_curpos({ 1, 42 })
        vim.cmd("normal csqr")
        check_lines({ [["This {sentence} has <so many> types of [quotes] in it"]] })
        vim.cmd("normal csqb")
        check_lines({ [[(This {sentence} has <so many> types of [quotes] in it)]] })
    end)
end)
