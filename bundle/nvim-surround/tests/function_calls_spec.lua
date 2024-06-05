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

describe("function calls", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    it("can be added", function()
        set_lines({ "hello world" })
        vim.cmd("normal yssfprint" .. cr)
        check_lines({ "print(hello world)" })

        set_curpos({ 1, 7 })
        vim.cmd("normal yswfnew_func" .. cr)
        check_lines({ "print(new_func(hello) world)" })

        vim.cmd("normal ySSfon_a_new_line" .. cr)
        check_lines({ "on_a_new_line(", "print(new_func(hello) world)", ")" })

        set_lines({ "some, args" })
        vim.cmd("normal yssfcompose" .. cr .. "...")
        check_lines({ "compose(compose(compose(compose(some, args))))" })
    end)

    it("can be deleted", function()
        set_lines({ "some_func(some_args)" })
        vim.cmd("normal dsf")
        check_lines({ "some_args" })

        set_lines({
            "multiline_func(",
            "    arg1,",
            "    arg2,",
            "    arg3",
            ")",
        })
        vim.cmd("normal dsf")
        check_lines({
            "",
            "    arg1,",
            "    arg2,",
            "    arg3",
            "",
        })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 1 })
        vim.cmd("normal dsf")
        check_lines({ "functions(here)" })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 7 })
        vim.cmd("normal dsf")
        check_lines({ "functions(here)" })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 8 })
        vim.cmd("normal dsf")
        check_lines({ "nested(here)" })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 17 })
        vim.cmd("normal dsf")
        check_lines({ "nested(here)" })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 19 })
        vim.cmd("normal dsf")
        check_lines({ "nested(here)" })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 22 })
        vim.cmd("normal dsf")
        check_lines({ "nested(here)" })

        set_lines({ "nested(functions(here))" })
        set_curpos({ 1, 23 })
        vim.cmd("normal dsf")
        check_lines({ "functions(here)" })

        set_lines({ "int x = node->get_value(args);" })
        vim.cmd("normal dsf")
        check_lines({ "int x = args;" })

        set_lines({ "int Namespace::function(char x, string y)" })
        vim.cmd("normal dsf")
        check_lines({ "int char x, string y" })

        set_lines({ "local res = M.get_input(prompt)" })
        vim.cmd("normal dsf")
        check_lines({ "local res = prompt" })
    end)

    it("can be renamed", function()
        set_lines({ "int x = node->get_value(args);" })
        vim.cmd("normal csfget_val" .. cr)
        check_lines({ "int x = node->get_val(args);" })

        set_lines({ "int Namespace::function(char x, string y)" })
        vim.cmd("normal csfother" .. cr)
        check_lines({ "int Namespace::other(char x, string y)" })

        set_lines({ "local res = M.get_input(prompt)" })
        vim.cmd("normal csfto_lower" .. cr)
        check_lines({ "local res = M.to_lower(prompt)" })
    end)
end)
