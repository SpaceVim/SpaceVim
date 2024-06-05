local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
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

describe("configuration", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    it("can define own add mappings", function()
        require("nvim-surround").setup({
            surrounds = {
                ["1"] = { add = { "1", "1" } },
                ["2"] = { add = { "2", { "2" } } },
                ["3"] = { add = { { "3" }, "3" } },
                ["f"] = { add = { { "int main() {", "    " }, { "", "}" } } },
            },
        })

        set_lines({
            "hello world",
            "more text",
            "another line",
            "interesting stuff",
        })
        set_curpos({ 1, 1 })
        vim.cmd("normal yss1")
        set_curpos({ 2, 1 })
        vim.cmd("normal yss2")
        set_curpos({ 3, 1 })
        vim.cmd("normal yss3")
        set_curpos({ 4, 1 })
        vim.cmd("normal yssf")
        check_lines({
            "1hello world1",
            "2more text2",
            "3another line3",
            "int main() {",
            "    interesting stuff",
            "}",
        })
    end)

    it("can define and use multi-byte mappings", function()
        require("nvim-surround").setup({
            surrounds = {
                -- multi-byte quote
                ["’"] = {
                    add = { "’", "’" },
                    delete = "^(’)().-(’)()$",
                },
            },
        })
        set_lines({ "hey! hello world" })
        set_curpos({ 1, 7 })
        vim.cmd("normal ysiw’")
        check_lines({ "hey! ’hello’ world" })
        vim.cmd("normal ds’")
        check_lines({ "hey! hello world" })
    end)

    it("can define and use 'interpreted' multi-byte mappings", function()
        require("nvim-surround").setup({
            surrounds = {
                -- interpreted multi-byte
                ["<M-]>"] = {
                    add = { "[[", "]]" },
                    find = "%[%b[]%]",
                    delete = "^(%[%[)().-(%]%])()$",
                },
            },
        })
        local meta_close_bracket = vim.api.nvim_replace_termcodes("<M-]>", true, false, true)
        set_lines({ "hey! hello world" })
        set_curpos({ 1, 7 })
        vim.cmd("normal ysiw" .. meta_close_bracket)
        check_lines({ "hey! [[hello]] world" })
        vim.cmd("normal ds" .. meta_close_bracket)
        check_lines({ "hey! hello world" })
    end)

    it("default deletes using invalid_key_behavior for an 'interpreted' multi-byte mapping", function()
        require("nvim-surround").setup({
            surrounds = {
                -- interpreted multi-byte
                ["<C-q>"] = {
                    add = { "‘", "’" },
                    find = "‘.-’",
                },
            },
        })
        local ctrl_q = vim.api.nvim_replace_termcodes("<C-q>", true, false, true)
        set_lines({ "hey! hello world" })
        set_curpos({ 1, 7 })
        vim.cmd("normal ysiw" .. ctrl_q)
        check_lines({ "hey! ‘hello’ world" })
        vim.cmd("normal ds" .. ctrl_q)
        check_lines({ "hey! hello world" })
    end)

    it("can disable surrounds", function()
        require("nvim-surround").setup({
            surrounds = {
                ["("] = false,
            },
        })

        set_lines({
            "hello world",
        })
        vim.cmd("normal yss(")
        check_lines({
            "(hello world(",
        })
    end)

    it("can change invalid_key_behavior", function()
        require("nvim-surround").setup({
            surrounds = {
                invalid_key_behavior = {
                    add = function(char)
                        return { { "begin" .. char }, { char .. "end" } }
                    end,
                },
            },
        })

        set_lines({
            "hello world",
        })
        vim.cmd("normal yss|")
        check_lines({
            "begin|hello world|end",
        })
    end)

    it("can disable indent_lines", function()
        require("nvim-surround").setup({
            indent_lines = false,
        })

        vim.bo.filetype = "html"
        set_lines({ "some text" })
        vim.cmd("normal ySStdiv" .. cr)
        check_lines({
            "<div>",
            "some text",
            "</div>",
        })
        vim.bo.filetype = nil
    end)

    it("can disable invalid_key_behavior", function()
        require("nvim-surround").setup({
            surrounds = {
                invalid_key_behavior = false,
            },
        })

        set_lines({
            "hello world",
        })
        vim.cmd("normal yssx")
        check_lines({
            "hello world",
        })
    end)

    it("can disable cursor movement for actions", function()
        require("nvim-surround").buffer_setup({ move_cursor = false })
        set_lines({
            [[And jump "forwards" and `backwards` to 'the' "nearest" surround.]],
        })
        set_curpos({ 1, 27 })

        vim.cmd("normal dsq")
        assert.are.same(get_curpos(), { 1, 27 })
        check_lines({
            [[And jump "forwards" and backwards to 'the' "nearest" surround.]],
        })

        vim.cmd("normal ysa'\"")
        check_lines({
            [[And jump "forwards" and backwards to "'the'" "nearest" surround.]],
        })

        vim.cmd("normal dsq")
        assert.are.same(get_curpos(), { 1, 27 })
        vim.cmd("normal! ..")
        assert.are.same(get_curpos(), { 1, 27 })
        check_lines({
            [[And jump forwards and backwards to the "nearest" surround.]],
        })

        vim.cmd("normal csqb")
        assert.are.same(get_curpos(), { 1, 27 })
        check_lines({
            [[And jump forwards and backwards to the (nearest) surround.]],
        })

        set_curpos({ 1, 5 })
        vim.cmd("normal v")
        set_curpos({ 1, 31 })
        vim.cmd('normal S"')
        assert.are.same(get_curpos(), { 1, 31 })
        check_lines({
            [[And "jump forwards and backwards" to the (nearest) surround.]],
        })
        vim.cmd("normal yss)")
        assert.are.same(get_curpos(), { 1, 31 })
        check_lines({
            [[(And "jump forwards and backwards" to the (nearest) surround.)]],
        })
    end)

    it("can move the cursor to the beginning of an action", function()
        set_lines({
            [[And jump "forwards" and `backwards` to 'the' "nearest" surround.]],
        })
        set_curpos({ 1, 27 })

        vim.cmd("normal dsq")
        assert.are.same(get_curpos(), { 1, 25 })
        check_lines({
            [[And jump "forwards" and backwards to 'the' "nearest" surround.]],
        })

        vim.cmd("normal ysa'\"")
        assert.are.same(get_curpos(), { 1, 38 })
        check_lines({
            [[And jump "forwards" and backwards to "'the'" "nearest" surround.]],
        })

        vim.cmd("normal dsq")
        assert.are.same(get_curpos(), { 1, 38 })
        vim.cmd("normal! ..")
        assert.are.same(get_curpos(), { 1, 19 })
        check_lines({
            [[And jump "forwards and backwards to the nearest" surround.]],
        })

        vim.cmd("normal csqb")
        assert.are.same(get_curpos(), { 1, 10 })
        check_lines({
            [[And jump (forwards and backwards to the nearest) surround.]],
        })

        set_curpos({ 1, 11 })
        vim.cmd("normal v")
        set_curpos({ 1, 32 })
        vim.cmd('normal S"')
        assert.are.same(get_curpos(), { 1, 11 })
        check_lines({
            [[And jump ("forwards and backwards" to the nearest) surround.]],
        })
    end)

    it("can partially define surrounds", function()
        require("nvim-surround").buffer_setup({
            surrounds = {
                ["t"] = {
                    delete = "^()().-()()$",
                },
            },
        })

        assert.are_not.same(require("nvim-surround.config").get_opts().surrounds.t.add, false)
        assert.are_not.same(require("nvim-surround.config").get_opts().surrounds.t.find, false)
        assert.are_not.same(require("nvim-surround.config").get_opts().surrounds.t.change, false)
    end)

    it("can disable keymaps", function()
        require("nvim-surround").buffer_setup({
            keymaps = {
                normal = false,
            },
        })

        set_lines({ "Hello, world!" })
        vim.cmd("normal ysiwb")
        check_lines({ "wbHello, world!" })
    end)

    it("can cancel surrounds, without moving the cursor", function()
        require("nvim-surround").buffer_setup({
            move_cursor = false,
        })

        set_lines({ "(some 'text')" })
        set_curpos({ 1, 5 })
        vim.cmd("normal ysiw" .. esc)
        vim.cmd("normal ds" .. esc)
        vim.cmd("normal cs'" .. esc)
        vim.cmd("normal csb" .. esc)
        assert.are.same(get_curpos(), { 1, 5 })
        check_lines({ "(some 'text')" })
    end)
end)
