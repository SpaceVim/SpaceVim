local command = require "telescope.command"

local eq = assert.are.same

describe("command_parser", function()
  local test_parse = function(should, input, output)
    it(should, function()
      command.convert_user_opts(input)
      eq(output, input)
    end)
  end

  -- Strings
  test_parse("should handle cwd", { cwd = "string" }, { cwd = "string" })

  -- Find commands
  test_parse(
    "should handle find_command 1",
    { find_command = "rg,--ignore,--hidden,files" },
    { find_command = { "rg", "--ignore", "--hidden", "files" } }
  )
  test_parse(
    "should handle find_command 2",
    { find_command = "fd,-t,f,-H" },
    { find_command = { "fd", "-t", "f", "-H" } }
  )
  test_parse(
    "should handle find_command 3",
    { find_command = "fdfind,--type,f,--no-ignore" },
    { find_command = { "fdfind", "--type", "f", "--no-ignore" } }
  )

  -- Dictionaries/tables
  test_parse(
    "should handle layout_config viml 1",
    { layout_config = "{'prompt_position':'top'}" },
    { layout_config = { prompt_position = "top" } }
  )
  test_parse(
    "should handle layout_config viml 2",
    { layout_config = "#{prompt_position:'bottom'}" },
    { layout_config = { prompt_position = "bottom" } }
  )
  test_parse(
    "should handle layout_config viml 3",
    { layout_config = "{'mirror':v:true}" },
    { layout_config = { mirror = true } }
  )
  test_parse(
    "should handle layout_config viml 4",
    { layout_config = "#{mirror:v:true}" },
    { layout_config = { mirror = true } }
  )
  test_parse(
    "should handle layout_config lua 1",
    { layout_config = "{prompt_position='bottom'}" },
    { layout_config = { prompt_position = "bottom" } }
  )
  test_parse(
    "should handle layout_config lua 2",
    { layout_config = "{mirror=true}" },
    { layout_config = { mirror = true } }
  )

  -- Lists/tables
  test_parse(
    "should handle symbols commas list",
    { symbols = "alpha,beta,gamma" },
    { symbols = { "alpha", "beta", "gamma" } }
  )
  test_parse(
    "should handle symbols viml list",
    { symbols = "['alpha','beta','gamma']" },
    { symbols = { "alpha", "beta", "gamma" } }
  )
  test_parse(
    "should handle symbols lua list",
    { symbols = "{'alpha','beta','gamma'}" },
    { symbols = { "alpha", "beta", "gamma" } }
  )

  -- Booleans
  test_parse("should handle booleans 1", { hidden = "true" }, { hidden = true })
  test_parse("should handle booleans 2", { no_ignore = "false" }, { no_ignore = false })

  -- Numbers
  test_parse("should handle numbers 1", { depth = "2" }, { depth = 2 })
  test_parse("should handle numbers 2", { bufnr_width = "4" }, { bufnr_width = 4 })
  test_parse("should handle numbers 3", { severity = "27" }, { severity = 27 })

  -- Multiple options
  test_parse(
    "should handle multiple options 1",
    { layout_config = '{prompt_position="top"}', cwd = "/foobar", severity = "27" },
    { layout_config = { prompt_position = "top" }, cwd = "/foobar", severity = 27 }
  )
  test_parse(
    "should handle multiple options 2",
    { symbols = "['alef','bet','gimel']", depth = "2", find_command = "rg,--ignore,files" },
    { symbols = { "alef", "bet", "gimel" }, depth = 2, find_command = { "rg", "--ignore", "files" } }
  )
end)
