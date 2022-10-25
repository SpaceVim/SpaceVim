-- Just skip on mac, it has flaky CI for some reason
if vim.fn.has "mac" == 1 then
  return
end

local tester = require "telescope.testharness"

local disp = function(val)
  return vim.inspect(val, { newline = " ", indent = "" })
end

describe("builtin.find_files", function()
  it("should find the readme", function()
    tester.run_file "find_files__readme"
  end)

  for _, configuration in ipairs {
    { sorting_strategy = "descending" },
    { sorting_strategy = "ascending" },
  } do
    it("should not display devicons when disabled: " .. disp(configuration), function()
      tester.run_string(string.format(
        [[
        local max_results = 5

        runner.picker('find_files', 'README.md', {
          post_typed = {
            { "> README.md", GetPrompt },
            { "> README.md", GetBestResult },
          },
          post_close = {
            { 'README.md', GetFile },
            { 'README.md', GetFile },
          }
        }, vim.tbl_extend("force", {
          disable_devicons = true,
          sorter = require('telescope.sorters').get_fzy_sorter(),
          layout_strategy = 'center',
          layout_config = {
            height = max_results + 1,
            width = 0.9,
          },
        }, vim.json.decode([==[%s]==])))
      ]],
        vim.json.encode(configuration)
      ))
    end)

    pending("use devicons, if it has it when enabled", function()
      if not pcall(require, "nvim-web-devicons") then
        return
      end

      local md = require("nvim-web-devicons").get_icon "md"
      tester.run_string(string.format(
        [[
        runner.picker('find_files', 'README.md', {
          post_typed = {
            { "> README.md", GetPrompt },
            { "> %s README.md", GetBestResult }
          },
          post_close = {
            { 'README.md', GetFile },
            { 'README.md', GetFile },
          }
        }, vim.tbl_extend("force", {
          disable_devicons = false,
          sorter = require('telescope.sorters').get_fzy_sorter(),
        }, vim.json.decode([==[%s]==])))
      ]],
        md,
        vim.json.encode(configuration)
      ))
    end)
  end

  it("should find the readme, using lowercase", function()
    tester.run_string [[
      runner.picker('find_files', 'readme.md', {
        post_close = {
          { 'README.md', GetFile },
        }
      })
    ]]
  end)

  it("should find the pickers.lua, using lowercase", function()
    tester.run_string [[
      runner.picker('find_files', 'pickers.lua', {
        post_close = {
          { 'pickers.lua', GetFile },
        }
      })
    ]]
  end)

  it("should find the pickers.lua", function()
    tester.run_string [[
      runner.picker('find_files', 'pickers.lua', {
        post_close = {
          { 'pickers.lua', GetFile },
          { 'pickers.lua', GetFile },
        }
      })
    ]]
  end)

  it("should be able to c-n the items", function()
    tester.run_string [[
      runner.picker('find_files', 'fixtures/file<c-n>', {
        post_typed = {
          {
            {
              "  lua/tests/fixtures/file_a.txt",
              "> lua/tests/fixtures/file_abc.txt",
            }, GetResults
          },
        },
        post_close = {
          { 'file_abc.txt', GetFile },
        },
      }, {
        sorter = require('telescope.sorters').get_fzy_sorter(),
        sorting_strategy = "ascending",
        disable_devicons = true,
      })
    ]]
  end)

  it("should be able to get the current selection", function()
    tester.run_string [[
      runner.picker('find_files', 'fixtures/file_abc', {
        post_typed = {
          { 'lua/tests/fixtures/file_abc.txt', GetSelectionValue },
        }
      })
    ]]
  end)
end)
