require("plenary.reload").reload_module "telescope"

local tester = require "telescope.pickers._test"

local disp = function(val)
  return vim.inspect(val, { newline = " ", indent = "" })
end

describe("builtin.find_files", function()
  it("should find the readme", function()
    tester.run_file "find_files__readme"
  end)

  it("should be able to move selections", function()
    tester.run_file "find_files__with_ctrl_n"
  end)

  for _, configuration in ipairs {
    { sorting_strategy = "descending" },
    { sorting_strategy = "ascending" },
  } do
    it("should not display devicons when disabled: " .. disp(configuration), function()
      tester.run_string(string.format(
        [[
        local max_results = 5

        tester.builtin_picker('find_files', 'README.md', {
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
          border = false,
        }, vim.json.decode([==[%s]==])))
      ]],
        vim.json.encode(configuration)
      ))
    end)

    it("should only save one line for ascending, but many for descending", function()
      local expected
      if configuration.sorting_strategy == "descending" then
        expected = 5
      else
        expected = 1
      end

      tester.run_string(string.format(
        [[
        local max_results = 5

        tester.builtin_picker('find_files', 'README.md', {
          post_typed = {
            { %s, function() return #GetResults() end },
          },
        }, vim.tbl_extend("force", {
          disable_devicons = true,
          sorter = require('telescope.sorters').get_fzy_sorter(),
          layout_strategy = 'center',
          layout_config = {
            height = max_results + 1,
            width = 0.9,
          },
          border = false,
        }, vim.json.decode([==[%s]==])))
      ]],
        expected,
        vim.json.encode(configuration)
      ))
    end)

    it("use devicons, if it has it when enabled", function()
      if not pcall(require, "nvim-web-devicons") then
        return
      end

      tester.run_string(string.format(
        [[
        tester.builtin_picker('find_files', 'README.md', {
          post_typed = {
            { "> README.md", GetPrompt },
            { ">  README.md", GetBestResult }
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
        vim.json.encode(configuration)
      ))
    end)
  end

  it("should find the readme, using lowercase", function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'readme.md', {
        post_close = {
          { 'README.md', GetFile },
        }
      })
    ]]
  end)

  it("should find the pickers.lua, using lowercase", function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'pickers.lua', {
        post_close = {
          { 'pickers.lua', GetFile },
        }
      })
    ]]
  end)

  it("should find the pickers.lua", function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'pickers.lua', {
        post_close = {
          { 'pickers.lua', GetFile },
          { 'pickers.lua', GetFile },
        }
      })
    ]]
  end)

  it("should be able to c-n the items", function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'fixtures/file<c-p>', {
        post_typed = {
          {
            {
              "  lua/tests/fixtures/file_abc.txt",
              "> lua/tests/fixtures/file_a.txt",
            }, function()
            local res = GetResults()

              return {
                res[#res - 1],
                res[#res],
              }
            end
          },
        },
        post_close = {
          { 'file_abc.txt', GetFile },
        },
      }, {
        sorter = require('telescope.sorters').get_fzy_sorter(),
        disable_devicons = true,
      })
    ]]
  end)

  it("should be able to get the current selection", function()
    tester.run_string [[
      tester.builtin_picker('find_files', 'fixtures/file_abc', {
        post_typed = {
          { 'lua/tests/fixtures/file_abc.txt', GetSelectionValue },
        }
      })
    ]]
  end)
end)
