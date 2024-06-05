local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
local set_curpos = function(pos)
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
end
local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
local check_lines = function(lines)
    assert.are.same(lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

describe("HTML tags", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    for _, tag in ipairs({ "div", "<div>", "<div", "div>" }) do
        it("can surround with an HTML tag " .. tag, function()
            set_lines({ "some text" })
            set_curpos({ 1, 3 })
            vim.cmd("normal ysst" .. tag .. cr)
            check_lines({ "<div>some text</div>" })
        end)
    end

    for _, tag in ipairs({ 'div class="test"', '<div class="test"', '<div class="test">', 'div class="test">' }) do
        it("can surround with an HTML tag with attributes " .. tag, function()
            set_lines({ "some text" })
            set_curpos({ 1, 3 })
            vim.cmd("normal ysst" .. tag .. cr)
            check_lines({ '<div class="test">some text</div>' })
        end)
    end
end)
