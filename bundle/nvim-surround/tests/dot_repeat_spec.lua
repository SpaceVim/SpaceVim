local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
local set_curpos = function(pos)
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
end
local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
local check_lines = function(lines)
    assert.are.same(lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
end
local check_curpos = function(pos)
    assert.are.same({ pos[1], pos[2] - 1 }, vim.api.nvim_win_get_cursor(0))
end

describe("dot-repeat", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    it("can add static delimiter pairs", function()
        set_lines({ "test" })
        vim.cmd("normal ysiWb")
        vim.cmd("normal! ..")
        check_lines({ "(((test)))" })
    end)

    it("can delete static delimiter pairs", function()
        set_lines({ "(((test)))" })
        vim.cmd("normal dsb")
        vim.cmd("normal! ..")
        check_lines({ "test" })
    end)

    it("can change static delimiter pairs", function()
        set_lines({ "(((test)))" })
        vim.cmd("normal csba")
        vim.cmd("normal! ..")
        check_lines({ "<<<test>>>" })
    end)

    it("can add non-static delimiter pairs based on user input", function()
        set_lines({ "here", "are", "some", "lines" })
        vim.cmd("normal ysiwffunc_name" .. cr)
        set_curpos({ 2, 3 })
        vim.cmd("normal! .")
        set_curpos({ 3, 4 })
        vim.cmd("normal! .")
        set_curpos({ 4, 2 })
        vim.cmd("normal! .")
        check_lines({
            "func_name(here)",
            "func_name(are)",
            "func_name(some)",
            "func_name(lines)",
        })
    end)

    it("can delete non-static delimiter pairs", function()
        set_lines({
            [[<div id="test"]],
            [[     class="another"]],
            [[     some="other stuff">]],
            [[    <div id="bruh"]],
            [[         class="hi"]],
            [[         some="more things">]],
            [[        hello]],
            [[        <h2>]],
            [[            hello world]],
            [[        </h2>]],
            [[    </div>]],
            [[</div>]],
        })
        set_curpos({ 9, 5 })
        vim.cmd("normal dsT..")
        check_lines({
            [[]],
            [[    ]],
            [[        hello]],
            [[        ]],
            [[            hello world]],
            [[        ]],
            [[    ]],
            [[]],
        })
    end)

    it("can change non-static delimiter pairs", function()
        set_lines({
            [[<div id="test"]],
            [[     class="another"]],
            [[     some="other stuff">]],
            [[    <div id="bruh"]],
            [[         class="hi"]],
            [[         some="more things">]],
            [[        hello]],
            [[        <h2>]],
            [[            hello world]],
            [[        </h2>]],
            [[    </div>]],
            [[</div>]],
        })
        set_curpos({ 4, 15 })
        vim.cmd("normal csTh1" .. cr)
        check_lines({
            [[<div id="test"]],
            [[     class="another"]],
            [[     some="other stuff">]],
            [[    <h1>]],
            [[        hello]],
            [[        <h2>]],
            [[            hello world]],
            [[        </h2>]],
            [[    </h1>]],
            [[</div>]],
        })
        set_curpos({ 1, 5 })
        vim.cmd("normal! .")
        check_lines({
            [[<h1>]],
            [[    <h1>]],
            [[        hello]],
            [[        <h2>]],
            [[            hello world]],
            [[        </h2>]],
            [[    </h1>]],
            [[</h1>]],
        })
    end)

    it("can replace non-static delimiter pairs based on user input", function()
        set_lines({
            "func_name(here)",
            "func_name(are)",
            "func_name(some)",
            "func_name(lines)",
        })
        vim.cmd("normal csfnew_name" .. cr)
        vim.cmd("normal j.j.j.")
        check_lines({
            "new_name(here)",
            "new_name(are)",
            "new_name(some)",
            "new_name(lines)",
        })
    end)

    it("can perform a dot-repeat deletion without moving the cursor", function()
        require("nvim-surround").buffer_setup({
            move_cursor = false,
        })

        set_lines({
            "'here'",
            "'there is'",
            "'another'",
            "'line'",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal ds'")
        vim.cmd("normal j.j.j.3k")
        check_curpos({ 1, 3 })
    end)

    it("can perform a dot-repeat addition without moving the cursor", function()
        require("nvim-surround").buffer_setup({
            move_cursor = false,
        })

        set_lines({
            "here",
            "there is",
            "another",
            "line",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal ysiwfhi" .. cr)
        vim.cmd("normal j.j.j.3k")
        check_curpos({ 1, 3 })
        vim.cmd("normal yss]")
        vim.cmd("normal j.j.j.3k")
        check_curpos({ 1, 3 })
        check_lines({
            "[hi(here)]",
            "[hi(there) is]",
            "[hi(another)]",
            "[hi(line)]",
        })
    end)

    it("can perform a dot-repeat addition, moving the cursor to the beginning of the surround", function()
        require("nvim-surround").buffer_setup({
            move_cursor = "begin",
        })

        set_lines({
            "here",
            "there is",
            "another",
            "line",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal ysiw'")
        vim.cmd("normal j.j.j.3k")
        check_curpos({ 1, 1 })
    end)

    it("can perform a dot-repeat addition (containing `.`) without moving the cursor", function()
        require("nvim-surround").buffer_setup({
            move_cursor = false,
        })

        set_lines({
            "here",
            "there is",
            "another",
            "line",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal ysiw.")
        vim.cmd("normal j.j.j.3k")
        check_curpos({ 1, 3 })
    end)

    it("does not have improper dot-repeat cursor functionality when other dots are inputted", function()
        require("nvim-surround").buffer_setup({
            move_cursor = false,
        })

        set_lines({
            "this is a line",
            "there is another",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal ysiw)")
        vim.cmd("normal :echo 'this. is. a. dot.'" .. cr)
        vim.cmd("normal j.")
        check_curpos({ 2, 3 })
    end)

    it("maintains cursor position correctly after dot-repeating after cancelling a motion", function()
        require("nvim-surround").buffer_setup({
            move_cursor = false,
        })

        set_lines({
            "this is a line",
            "there is another",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal ysiw" .. esc)
        set_curpos({ 2, 13 })
        vim.cmd("normal ..")
        check_curpos({ 2, 13 })
        check_lines({
            "this is a line",
            "there is .another.",
        })
    end)
end)
