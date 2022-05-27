local json = require "plenary.json"
local eq = assert.are.same

describe("json", function()
  it("replace comments with whitespace", function()
    eq(json.json_strip_comments '//comment\n{"a":"b"}', '         \n{"a":"b"}')
    eq(json.json_strip_comments '/*//comment*/{"a":"b"}', '             {"a":"b"}')
    eq(json.json_strip_comments '{"a":"b"//comment\n}', '{"a":"b"         \n}')
    eq(json.json_strip_comments '{"a":"b"/*comment*/}', '{"a":"b"           }')
    eq(json.json_strip_comments '{"a"/*\n\n\ncomment\r\n*/:"b"}', '{"a"  \n\n\n       \r\n  :"b"}')
    eq(json.json_strip_comments '/*!\n * comment\n */\n{"a":"b"}', '   \n          \n   \n{"a":"b"}')
    eq(json.json_strip_comments '{/*comment*/"a":"b"}', '{           "a":"b"}')
  end)

  it("remove comments", function()
    local options = { whitespace = false }
    eq(json.json_strip_comments('//comment\n{"a":"b"}', options), '\n{"a":"b"}')
    eq(json.json_strip_comments('/*//comment*/{"a":"b"}', options), '{"a":"b"}')
    eq(json.json_strip_comments('{"a":"b"//comment\n}', options), '{"a":"b"\n}')
    eq(json.json_strip_comments('{"a":"b"/*comment*/}', options), '{"a":"b"}')
    eq(json.json_strip_comments('{"a"/*\n\n\ncomment\r\n*/:"b"}', options), '{"a":"b"}')
    eq(json.json_strip_comments('/*!\n * comment\n */\n{"a":"b"}', options), '\n{"a":"b"}')
    eq(json.json_strip_comments('{/*comment*/"a":"b"}', options), '{"a":"b"}')
  end)

  it("doesn't strip comments inside strings", function()
    eq(json.json_strip_comments '{"a":"b//c"}', '{"a":"b//c"}')
    eq(json.json_strip_comments '{"a":"b/*c*/"}', '{"a":"b/*c*/"}')
    eq(json.json_strip_comments '{"/*a":"b"}', '{"/*a":"b"}')
    eq(json.json_strip_comments '{"\\"/*a":"b"}', '{"\\"/*a":"b"}')
  end)

  it("consider escaped slashes when checking for escaped string quote", function()
    eq(json.json_strip_comments '{"\\\\":"https://foobar.com"}', '{"\\\\":"https://foobar.com"}')
    eq(json.json_strip_comments '{"foo\\"":"https://foobar.com"}', '{"foo\\"":"https://foobar.com"}')
  end)

  it("line endings - no comments", function()
    eq(json.json_strip_comments '{"a":"b"\n}', '{"a":"b"\n}')
    eq(json.json_strip_comments '{"a":"b"\r\n}', '{"a":"b"\r\n}')
  end)

  it("line endings - single line comment", function()
    eq(json.json_strip_comments '{"a":"b"//c\n}', '{"a":"b"   \n}')
    eq(json.json_strip_comments '{"a":"b"//c\r\n}', '{"a":"b"   \r\n}')
  end)

  it("line endings - single line block comment", function()
    eq(json.json_strip_comments '{"a":"b"/*c*/\n}', '{"a":"b"     \n}')
    eq(json.json_strip_comments '{"a":"b"/*c*/\r\n}', '{"a":"b"     \r\n}')
  end)

  it("line endings - multi line block comment", function()
    eq(json.json_strip_comments '{"a":"b",/*c\nc2*/"x":"y"\n}', '{"a":"b",   \n    "x":"y"\n}')
    eq(json.json_strip_comments '{"a":"b",/*c\r\nc2*/"x":"y"\r\n}', '{"a":"b",   \r\n    "x":"y"\r\n}')
  end)

  it("line endings - works at EOF", function()
    local options = { whitespace = false }
    eq(json.json_strip_comments '{\r\n\t"a":"b"\r\n} //EOF', '{\r\n\t"a":"b"\r\n}      ')
    eq(json.json_strip_comments('{\r\n\t"a":"b"\r\n} //EOF', options), '{\r\n\t"a":"b"\r\n} ')
  end)

  it("handles weird escaping", function()
    eq(
      json.json_strip_comments [[{"x":"x \"sed -e \\\"s/^.\\\\{46\\\\}T//\\\" -e \\\"s/#033/\\\\x1b/g\\\"\""}]],
      [[{"x":"x \"sed -e \\\"s/^.\\\\{46\\\\}T//\\\" -e \\\"s/#033/\\\\x1b/g\\\"\""}]]
    )
  end)
end)
