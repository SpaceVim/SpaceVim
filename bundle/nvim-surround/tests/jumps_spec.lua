local get_curpos = function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    return { curpos[1], curpos[2] + 1 }
end
local set_curpos = function(pos)
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
end
local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
local check_lines = function(lines)
    assert.are.same(lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

describe("jumps", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    it("can do lookahead/lookbehind", function()
        set_lines({
            [[And jump "forwards" and `backwards` to 'the' "nearest" surround.]],
        })
        set_curpos({ 1, 27 })

        vim.cmd("normal dsq")
        assert.are_not.same(get_curpos(), { 1, 27 })
        check_lines({
            [[And jump "forwards" and backwards to 'the' "nearest" surround.]],
        })

        vim.cmd("normal ysa'\"")
        check_lines({
            [[And jump "forwards" and backwards to "'the'" "nearest" surround.]],
        })

        vim.cmd("normal dsq")
        assert.are_not.same(get_curpos(), { 1, 27 })
        vim.cmd("normal! ..")
        assert.are_not.same(get_curpos(), { 1, 27 })
        check_lines({
            [[And jump "forwards and backwards to the nearest" surround.]],
        })

        vim.cmd("normal csqb")
        assert.are_not.same(get_curpos(), { 1, 27 })
        check_lines({
            [[And jump (forwards and backwards to the nearest) surround.]],
        })
    end)

    it("can change multiple quotes on a line", function()
        set_lines({
            [["hello "world""]],
        })
        set_curpos({ 1, 10 })
        vim.cmd("normal cs\"'")
        check_lines({
            [["hello 'world'"]],
        })
        set_curpos({ 1, 8 })
        vim.cmd("normal cs'\"")
        check_lines({
            [["hello "world""]],
        })
        set_curpos({ 1, 14 })
        vim.cmd("normal cs\"'")
        check_lines({
            [["hello "world'']],
        })
    end)

    it("for quotes only target the current line", function()
        set_lines({
            [[This 'line' has quotes]],
            [[While this does "not"]],
            [[This `one` does as well]],
        })
        set_curpos({ 2, 7 })
        vim.cmd("normal dsq")
        check_lines({
            [[This 'line' has quotes]],
            [[While this does not]],
            [[This `one` does as well]],
        })
        vim.cmd("normal! .")
        check_lines({
            [[This 'line' has quotes]],
            [[While this does not]],
            [[This `one` does as well]],
        })
        vim.cmd("normal cs'`")
        vim.cmd("normal cs`'")
        check_lines({
            [[This 'line' has quotes]],
            [[While this does not]],
            [[This `one` does as well]],
        })
    end)

    it("can jump to pattern-based surrounds", function()
        set_lines({
            [[int f(a, b, c)]],
        })
        vim.cmd("normal dsf")
        check_lines({
            [[int a, b, c]],
        })

        set_curpos({ 1, 1 })
        set_lines({
            [[// Some comment here]],
            [[string function(vector<int> v) {}]],
        })
        vim.cmd("normal dsf")
        set_lines({
            [[// Some comment here]],
            [[string function(vector<int> v) {}]],
        })

        set_lines({
            [[outer_func(inner_func(some, args)) -- Comment]],
        })
        set_curpos({ 1, 11 })
        vim.cmd("normal dsf")
        set_lines({
            [[inner_func(some, args) -- Comment]],
        })

        set_lines({
            [[outer_func(inner_func(some, args)) -- Comment]],
        })
        set_curpos({ 1, 12 })
        vim.cmd("normal dsf")
        set_lines({
            [[outer_func(some, args) -- Comment]],
        })

        set_lines({
            [[outer_func(inner_func(some, args)) -- Comment]],
        })
        set_curpos({ 1, 33 })
        vim.cmd("normal dsf")
        set_lines({
            [[outer_func(some, args) -- Comment]],
        })

        set_lines({
            [[outer_func(inner_func(some, args)) -- Comment]],
        })
        set_curpos({ 1, 34 })
        vim.cmd("normal dsf")
        set_lines({
            [[inner_func(some, args) -- Comment]],
        })

        set_lines({
            [[outer_func(inner_func(some, args)) -- Comment]],
        })
        set_curpos({ 1, 39 })
        vim.cmd("normal dsf")
        set_lines({
            [[inner_func(some, args) -- Comment]],
        })
    end)

    it("has intended behavior for single-character delimiter pairs", function()
        require("nvim-surround").buffer_setup({
            surrounds = {
                ["*"] = {
                    find = "%*.-%*",
                    delete = "^(.)().-(.)()$",
                    change = {
                        target = "^(.)().-(.)()$",
                    },
                },
            },
        })

        set_lines({ "*hello*world*" })
        vim.cmd("normal ds*")
        check_lines({ "helloworld*" })

        set_lines({ "*hello*world*" })
        set_curpos({ 1, 6 })
        vim.cmd("normal ds*")
        check_lines({ "helloworld*" })

        set_lines({ "*hello*world*" })
        set_curpos({ 1, 7 })
        vim.cmd("normal ds*")
        check_lines({ "*helloworld" })

        set_lines({ "*hello*world*end" })
        set_curpos({ 1, 15 })
        vim.cmd("normal ds*")
        check_lines({ "*helloworldend" })
    end)
end)
