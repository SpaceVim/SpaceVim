local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
local ctrl_c = vim.api.nvim_replace_termcodes("<C-c>", true, false, true)
local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, false, true)
local set_curpos = function(pos)
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
end
local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
local check_lines = function(lines)
    assert.are.same(lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

describe("nvim-surround", function()
    before_each(function()
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(0, bufnr)
    end)

    it("can surround text-objects (ys, yss)", function()
        set_lines({ "local str = test" })
        set_curpos({ 1, 13 })
        vim.cmd('normal ysiw"')
        check_lines({ 'local str = "test"' })
        vim.cmd('normal ysa"b')
        check_lines({ 'local str = ("test")' })

        set_lines({ "string x = some text" })
        set_curpos({ 1, 12 })
        vim.cmd('normal ys$"')
        check_lines({ 'string x = "some text"' })

        set_lines({
            "this is a",
            "part of a paragraph",
            "with multiple lines",
        })
        set_curpos({ 2, 8 })
        vim.cmd("normal ysipB")
        check_lines({
            "{this is a",
            "part of a paragraph",
            "with multiple lines}",
        })

        set_lines({ "hello world" })
        vim.cmd("normal yssb")
        check_lines({ "(hello world)" })

        set_curpos({ 1, 5 })
        set_lines({ "this is the first line", "followed by the second line", "and finally the third" })
        vim.cmd("normal 2yssB")
        set_lines({ "{this is the first line", "followed by the second line}", "and finally the third" })
    end)

    it("can surround text-objects (yS, ySS)", function()
        set_lines({ "local str = test" })
        set_curpos({ 1, 13 })
        vim.cmd("normal yS2br")
        check_lines({ "local [", "str =", "] test" })
        set_curpos({ 1, 1 })
        vim.cmd("normal ySa]B")
        check_lines({ "local {", "[", "str =", "]", "} test" })

        set_lines({
            "this is a",
            "part of a paragraph",
            "with multiple lines",
        })
        set_curpos({ 2, 8 })
        vim.cmd("normal ySipB")
        check_lines({
            "{",
            "this is a",
            "part of a paragraph",
            "with multiple lines",
            "}",
        })

        set_lines({ "current line" })
        set_curpos({ 1, 7 })
        vim.cmd("normal ySSr")
        check_lines({ "[", "current line", "]" })

        set_lines({ "here", "we", "have", "several", "lines" })
        set_curpos({ 2, 2 })
        vim.cmd("normal 3ySS`")
        check_lines({ "here", "`", "we", "have", "several", "`", "lines" })
    end)

    it("can surround empty lines", function()
        set_lines({ "" })
        vim.cmd("normal ysla")
        check_lines({ "<>" })

        set_lines({ "" })
        set_curpos({ 1, 1 })
        vim.cmd("normal ySla")
        check_lines({ "<", "", ">" })

        set_lines({ "" })
        set_curpos({ 1, 1 })
        vim.cmd("normal vSb")
        check_lines({ "()" })

        set_lines({ "" })
        set_curpos({ 1, 1 })
        vim.cmd("normal vgSB")
        check_lines({ "{", "", "}" })

        set_lines({ "" })
        set_curpos({ 1, 1 })
        vim.cmd("normal VSr")
        check_lines({ "[", "", "]" })

        set_lines({ "" })
        set_curpos({ 1, 1 })
        vim.cmd("normal " .. ctrl_v .. "Sb")
        check_lines({ "()" })
    end)

    it("properly handles whitespace for open/close pairs", function()
        set_lines({ "sample_text" })
        vim.cmd("normal ysiw}")
        check_lines({ "{sample_text}" })

        set_lines({ "sample_text" })
        vim.cmd("normal ysiw{")
        check_lines({ "{ sample_text }" })

        set_lines({ "({ sample_text })" })
        vim.cmd("normal ds{")
        check_lines({ "(sample_text)" })

        set_lines({ "({sample_text})" })
        vim.cmd("normal ds{")
        check_lines({ "(sample_text)" })

        set_lines({ "({sample_text })" })
        vim.cmd("normal ds{")
        check_lines({ "(sample_text)" })

        set_lines({ "({ sample_text })" })
        vim.cmd("normal ds}")
        check_lines({ "( sample_text )" })
        vim.cmd("normal cs()")
        check_lines({ "(sample_text)" })
    end)

    it("properly handles whitespace next to line boundaries", function()
        set_lines({ "sample_text" })
        vim.cmd("normal ySS{")
        check_lines({ "{", "sample_text", "}" })
        vim.cmd("normal cs}[")
        check_lines({ "[", "sample_text", "]" })

        set_lines({ "(", "    sample_text", ")" })
        vim.cmd("normal cs)<")
        check_lines({ "<", "    sample_text", ">" })

        set_lines({
            "    <texta",
            "        textb",
            "    >",
        })
        vim.cmd("normal cs><")
        check_lines({
            "    < texta",
            "        textb",
            "    >",
        })
        vim.cmd("normal cs>{")
        check_lines({
            "    {  texta",
            "        textb",
            "    }",
        })
        vim.cmd("normal cs{]")
        check_lines({
            "    [ texta",
            "        textb",
            "    ]",
        })
        vim.cmd("normal cs[)")
        check_lines({
            "    (texta",
            "        textb",
            "    )",
        })

        set_lines({
            "    {texta",
            "        textb",
            "    textc}",
        })
        vim.cmd("normal cs{{")
        check_lines({
            "    { texta",
            "        textb",
            "    textc }",
        })
        vim.cmd("normal cs{{")
        check_lines({
            "    { texta",
            "        textb",
            "    textc }",
        })
        vim.cmd("normal cs}{")
        check_lines({
            "    {  texta",
            "        textb",
            "    textc  }",
        })
        vim.cmd("normal cs{}")
        check_lines({
            "    { texta",
            "        textb",
            "    textc }",
        })
        vim.cmd("normal cs{}")
        check_lines({
            "    {texta",
            "        textb",
            "    textc}",
        })
    end)

    it("can surround charwise visual selections", function()
        set_lines({ "this is", "a full", "sentence" })
        set_curpos({ 1, 2 })
        vim.cmd("normal! v")
        set_curpos({ 3, 5 })
        vim.cmd("normal SB")
        check_lines({ "t{his is", "a full", "sente}nce" })
        set_curpos({ 3, 7 })
        vim.cmd("normal! v")
        set_curpos({ 2, 2 })
        vim.cmd("normal Sa")
        check_lines({ "t{his is", "a< full", "sente}n>ce" })

        set_lines({ "this is", "a full", "sentence" })
        set_curpos({ 1, 1 })
        vim.cmd("normal! v")
        set_curpos({ 3, 8 })
        vim.cmd("normal gS'")
        check_lines({ "'", "this is", "a full", "sentence", "'" })
    end)

    it("can surround linewise visual selections", function()
        set_lines({ "current line" })
        vim.cmd("normal VSB")
        check_lines({ "{", "current line", "}" })

        set_lines({ "multiple", "lines" })
        set_curpos({ 2, 2 })
        vim.cmd("normal! V")
        set_curpos({ 1, 3 })
        vim.cmd("normal Sb")
        check_lines({ "(", "multiple", "lines", ")" })

        set_curpos({ 1, 1 })
        set_lines({
            "'hello',",
            "'hello',",
            "'hello',",
        })
        vim.cmd("normal VSB")
        check_lines({
            "{",
            "'hello',",
            "}",
            "'hello',",
            "'hello',",
        })
        set_curpos({ 5, 1 })
        vim.cmd("normal VSB")
        check_lines({
            "{",
            "'hello',",
            "}",
            "'hello',",
            "{",
            "'hello',",
            "}",
        })
        vim.cmd("normal ggVGSb")
        check_lines({
            "(",
            "{",
            "'hello',",
            "}",
            "'hello',",
            "{",
            "'hello',",
            "}",
            ")",
        })
    end)

    it("can surround blockwise visual selections", function()
        set_lines({
            "there happen",
            "to be",
            "quite a few lines",
            "in this buffer",
            "or so I had thought",
        })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 5, 2 })
        vim.cmd("normal Sb")
        check_lines({ "(th)ere happen", "(to) be", "(qu)ite a few lines", "(in) this buffer", "(or) so I had thought" })
        set_curpos({ 5, 21 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 1, 1 })
        vim.cmd("normal SB")
        check_lines({
            "{(th)ere happen}",
            "{(to) be}",
            "{(qu)ite a few lines}",
            "{(in) this buffer}",
            "{(or) so I had thought}",
        })
        set_curpos({ 4, 3 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 3, 7 })
        vim.cmd("normal Sa")
        check_lines({
            "{(th)ere happen}",
            "{(to) be}",
            "{(<qu)it>e a few lines}",
            "{(<in) t>his buffer}",
            "{(or) so I had thought}",
        })
        set_curpos({ 1, 16 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 3, 16 })
        vim.cmd("normal S'")
        check_lines({
            "{(th)ere happen'}'",
            "{(to) be}''",
            "{(<qu)it>e a fe'w' lines}",
            "{(<in) t>his buffer}",
            "{(or) so I had thought}",
        })

        set_lines({ "hello world", "more text here" })
        set_curpos({ 1, 3 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 2, 10 })
        vim.cmd("normal gSB")
        check_lines({
            "he{",
            "llo worl",
            "}d",
            "mo{",
            "re text ",
            "}here",
        })
    end)

    it("can delete delimiter pairs", function()
        set_lines({
            "local func = function()",
            "    local config = require('nvim-surround.config')",
            "    local tab = {",
            "        `weird stuff`,",
            "    },",
            "end",
        })
        vim.cmd("normal dsb")
        check_lines({
            "local func = function",
            "    local config = require('nvim-surround.config')",
            "    local tab = {",
            "        `weird stuff`,",
            "    },",
            "end",
        })
        vim.cmd("normal dsf")
        check_lines({
            "local func = function",
            "    local config = 'nvim-surround.config'",
            "    local tab = {",
            "        `weird stuff`,",
            "    },",
            "end",
        })
        vim.cmd("normal dsB")
        check_lines({
            "local func = function",
            "    local config = 'nvim-surround.config'",
            "    local tab = ",
            "        `weird stuff`,",
            "    ,",
            "end",
        })

        set_lines({ "()" })
        vim.cmd("normal dsb")
        check_lines({ "" })

        set_lines({ "{", "", "}" })
        vim.cmd("normal dsB")
        check_lines({ "", "", "" })
    end)

    it("can change delimiter pairs", function()
        set_lines({
            "require'nvim-surround'.setup(",
            "",
            ")",
        })
        set_curpos({ 1, 8 })
        vim.cmd("normal ysa'b")
        set_curpos({ 1, 9 })
        vim.cmd([[normal cs'"]])
        set_curpos({ 2, 1 })
        vim.cmd("normal csbB")
        vim.cmd("normal ysaBb")
        check_lines({
            'require("nvim-surround").setup({',
            "",
            "})",
        })

        set_lines({ "()" })
        vim.cmd("normal csba")
        check_lines({ "<>" })

        set_lines({ "{", "", "}" })
        vim.cmd("normal csBr")
        check_lines({ "[", "", "]" })
    end)

    it("can change delimiter pairs on new lines", function()
        set_lines({
            "require'nvim-surround'.setup(args)",
        })
        set_curpos({ 1, 29 })
        vim.cmd("normal cS))")
        check_lines({
            "require'nvim-surround'.setup(",
            "args",
            ")",
        })
        set_curpos({ 2, 1 })
        vim.cmd([[normal ysab}]])
        set_curpos({ 1, 29 })
        vim.cmd("normal cS}]")
        check_lines({
            "require'nvim-surround'.setup[",
            "(",
            "args",
            ")",
            "]",
        })
        vim.cmd("normal cS]{")
        check_lines({
            "require'nvim-surround'.setup{",
            "",
            "(",
            "args",
            ")",
            "",
            "}",
        })

        set_lines({ "()" })
        vim.cmd("normal cSbb")
        check_lines({ "(", "", ")" })

        set_lines({ "{", "", "}" })
        vim.cmd("normal cSBB")
        check_lines({ "{", "", "", "", "}" })
    end)

    it("can handle invalid key behavior", function()
        set_lines({ "sample text" })
        vim.cmd("normal yss|")
        check_lines({ "|sample text|" })
        vim.cmd("normal cs|^")
        check_lines({ "^sample text^" })
        vim.cmd("normal ds^")
        check_lines({ "sample text" })

        set_lines({ "one|two|three|four|five" })
        set_curpos({ 1, 2 })
        vim.cmd("normal ds|")
        check_lines({ "onetwothree|four|five" })

        set_lines({ "one|two|three|four|five" })
        set_curpos({ 1, 7 })
        vim.cmd("normal ds|")
        check_lines({ "onetwothree|four|five" })

        set_lines({ "one|two|three|four|five" })
        set_curpos({ 1, 8 })
        vim.cmd("normal ds|")
        check_lines({ "one|twothreefour|five" })

        set_lines({ "one|two|three|four|five" })
        set_curpos({ 1, 15 })
        vim.cmd("normal ds|")
        check_lines({ "one|two|threefourfive" })

        set_lines({ "one|two|three|four|five" })
        set_curpos({ 1, 23 })
        vim.cmd("normal ds|")
        check_lines({ "one|two|threefourfive" })

        set_lines({ "some |text|", "more |text|" })
        set_curpos({ 2, 2 })
        vim.cmd("normal ds|")
        check_lines({
            "some |text",
            "more text|",
        })
    end)

    it("can handle multi-byte characters", function()
        set_lines({ "。。。。" })
        vim.cmd("normal ys3lb")
        check_lines({ "(。。。)。" })
        vim.cmd("normal ysibB")
        check_lines({ "({。。。})。" })
        set_curpos({ 1, 3 })
        vim.cmd("normal yslr")
        check_lines({ "({[。]。。})。" })
        vim.cmd("normal VS|")
        check_lines({ "|", "({[。]。。})。", "|" })

        set_lines({
            "1234567890",
            "。。。。。",
            "1234567890",
        })
        set_curpos({ 2, 4 })
        vim.cmd("normal! v")
        set_curpos({ 3, 7 })
        vim.cmd("normal Sb")
        check_lines({
            "1234567890",
            "。(。。。。",
            "1234567)890",
        })
        set_curpos({ 2, 16 })
        vim.cmd("normal! v")
        set_curpos({ 2, 11 })
        vim.cmd("normal Sr")
        check_lines({
            "1234567890",
            "。(。。[。。]",
            "1234567)890",
        })

        set_lines({
            "1234567890",
            "。。。。。",
            "1234567890",
        })
        set_curpos({ 1, 10 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 3, 10 })
        vim.cmd("normal Sb")
        check_lines({
            "123456789(0)",
            "。。。。(。)",
            "123456789(0)",
        })
        set_curpos({ 1, 7 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 3, 4 })
        vim.cmd("normal Sr")
        check_lines({
            "123[4567]89(0)",
            "。[。。。](。)",
            "123[4567]89(0)",
        })
        set_curpos({ 3, 1 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 1, 1 })
        vim.cmd("normal Sa")
        check_lines({
            "<1>23[4567]89(0)",
            "<。>[。。。](。)",
            "<1>23[4567]89(0)",
        })

        set_lines({
            "我现在在写中文字。",
            "我不太知道应该些什么。",
            "这样也可以练中文哈哈。",
        })
        set_curpos({ 1, 1 })
        vim.cmd("normal! 3l" .. ctrl_v .. "2j2h")
        vim.cmd("normal Sa")
        check_lines({
            "我<现在在>写中文字。",
            "我<不太知>道应该些什么。",
            "这<样也可>以练中文哈哈。",
        })

        set_lines({
            "𐍈𐍈𐍈𐍈𐍈𐍈𐍈𐍈𐍈𐍈",
            "。。。。。",
            "𐍈𐍈𐍈𐍈𐍈𐍈𐍈𐍈𐍈𐍈",
        })
        set_curpos({ 1, 25 })
        vim.cmd("normal! " .. ctrl_v)
        set_curpos({ 3, 13 })
        vim.cmd("normal Sb")
        check_lines({
            "𐍈𐍈𐍈(𐍈𐍈𐍈𐍈)𐍈𐍈𐍈",
            "。(。。。)。",
            "𐍈𐍈𐍈(𐍈𐍈𐍈𐍈)𐍈𐍈𐍈",
        })

        require("nvim-surround").setup({
            surrounds = {
                ["x"] = {
                    add = { "‘", "’" },
                    find = "‘[^‘’]*’",
                },
                ["y"] = {
                    add = { "‘‘", "’’" },
                    find = "‘‘[^‘’]*’’",
                    delete = "^(‘‘)().-(’’)()$",
                },
            },
        })
        set_lines({
            "‘foo bar’",
        })
        set_curpos({ 1, 5 })
        vim.cmd("normal csx_")
        check_lines({
            "_foo bar_",
        })

        set_lines({
            "‘‘foo bar baz’’",
        })
        set_curpos({ 1, 3 })
        vim.cmd("normal dsy")
        check_lines({
            "foo bar baz",
        })
    end)

    it("can properly use line-wise surrounds", function()
        vim.bo.filetype = "lua"
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = true
        set_lines({
            "local f = function()",
            "    local a = 123",
            "end",
        })
        set_curpos({ 2, 2 })
        vim.cmd('normal VS"')

        check_lines({
            "local f = function()",
            '    "',
            "    local a = 123",
            '    "',
            "end",
        })
        vim.bo.filetype = nil
        vim.bo.shiftwidth = 8
        vim.bo.expandtab = false
    end)

    it("can surround linewise normal mode selections", function()
        set_lines({
            "I have this text file, and my cursor is here | let's say",
            "then I want to surround these two lines with parenthesis",
        })
        set_curpos({ 1, 46 })
        vim.cmd("normal ysjb")
        check_lines({
            "(I have this text file, and my cursor is here | let's say",
            "then I want to surround these two lines with parenthesis)",
        })

        set_lines({
            "some more arbitrary",
            "text that's spread across",
            "multiple lines",
            "or something",
            "i guess",
        })
        set_curpos({ 2, 6 })
        vim.cmd("normal ys2jB")
        check_lines({
            "some more arbitrary",
            "{text that's spread across",
            "multiple lines",
            "or something}",
            "i guess",
        })
    end)

    it("can cancel adding delimiters to the buffer", function()
        set_lines({
            "Hello, world!",
        })
        set_curpos({ 1, 8 })
        vim.cmd("normal ysiw" .. esc)
        vim.cmd("normal ysiw" .. ctrl_c)
        check_lines({
            "Hello, world!",
        })
    end)

    it("can cancel deleting delimiters from the buffer", function()
        set_lines({
            "Hello, (world)!",
        })
        vim.cmd("normal ds" .. esc)
        vim.cmd("normal ds" .. ctrl_c)
        check_lines({
            "Hello, (world)!",
        })
    end)

    it("can cancel changing delimiters in the buffer", function()
        set_lines({
            "Hello, (world)!",
        })
        vim.cmd("normal cs" .. esc)
        vim.cmd("normal csb" .. esc)
        vim.cmd("normal cs" .. ctrl_c)
        vim.cmd("normal cs" .. ctrl_c)
        check_lines({
            "Hello, (world)!",
        })
    end)

    it("doesn't re-indent visual surrounds for one line", function()
        set_lines({
            "data Foo = Foo",
            "  { fooA :: !Decimal",
            "  , fooB :: !Decimal",
            "  }",
        })
        vim.opt.cindent = true
        set_curpos({ 3, 14 })
        vim.cmd("normal viwS)")
        check_lines({
            "data Foo = Foo",
            "  { fooA :: !Decimal",
            "  , fooB :: !(Decimal)",
            "  }",
        })
    end)

    it("can handle $ for visual block surround", function()
        set_lines({
            "some more placeholder text",
            "some more lines",
            "hello world",
        })
        set_curpos({ 1, 1 })
        vim.cmd("normal " .. ctrl_v .. "jj$S}")
        check_lines({
            "{some more placeholder text}",
            "{some more lines}",
            "{hello world}",
        })
    end)
end)
