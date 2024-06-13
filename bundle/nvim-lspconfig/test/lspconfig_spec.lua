local helpers = require 'test.functional.helpers'(after_each)
local clear = helpers.clear
local exec_lua = helpers.exec_lua
local eq = helpers.eq
local ok = helpers.ok

before_each(function()
  clear()
  -- add plugin module path to package.path in Lua runtime in Nvim
  exec_lua(
    [[
    package.path = ...
  ]],
    package.path
  )
end)

describe('lspconfig', function()
  describe('util', function()
    describe('path', function()
      describe('exists', function()
        it('is present directory', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            local cwd = vim.fn.getcwd()
            return not (lspconfig.util.path.exists(cwd) == false)
          ]])
        end)

        it('is not present directory', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            local not_exist_dir = vim.fn.getcwd().."/not/exsts"
            return lspconfig.util.path.exists(not_exist_dir) == false
          ]])
        end)

        it('is present file', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            -- change the working directory to test directory
            vim.api.nvim_command("cd ../test/test_dir/")
            local file = vim.fn.getcwd().."/root_marker.txt"

            return not (lspconfig.util.path.exists(file) == false)
          ]])
        end)

        it('is not present file', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            -- change the working directory to test directory
            vim.api.nvim_command("cd ../test/test_dir/")
            local file = vim.fn.getcwd().."/not_exists.txt"

            return lspconfig.util.path.exists(file) == false
          ]])
        end)
      end)

      describe('is_dir', function()
        it('is directory', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            local cwd = vim.fn.getcwd()
            return lspconfig.util.path.is_dir(cwd)
          ]])
        end)

        it('is not present directory', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            local not_exist_dir = vim.fn.getcwd().."/not/exsts"
            return not lspconfig.util.path.is_dir(not_exist_dir)
          ]])
        end)

        it('is file', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            -- change the working directory to test directory
            vim.api.nvim_command("cd ../test/test_dir/")
            local file = vim.fn.getcwd().."/root_marker.txt"

            return not lspconfig.util.path.is_dir(file)
          ]])
        end)
      end)

      describe('is_file', function()
        it('is file', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            -- change the working directory to test directory
            vim.api.nvim_command("cd ../test/test_dir/")
            local file = vim.fn.getcwd().."/root_marker.txt"

            return lspconfig.util.path.is_file(file)
          ]])
        end)

        it('is not present file', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            -- change the working directory to test directory
            vim.api.nvim_command("cd ../test/test_dir/")
            local file = vim.fn.getcwd().."/not_exists.txt"

            return not lspconfig.util.path.is_file(file)
          ]])
        end)

        it('is directory', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            local cwd = vim.fn.getcwd()
            return not lspconfig.util.path.is_file(cwd)
          ]])
        end)
      end)

      describe('is_absolute', function()
        it('is absolute', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")
            return not (lspconfig.util.path.is_absolute("/foo/bar") == nil)
          ]])
        end)

        it('is not absolute', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")
            return lspconfig.util.path.is_absolute("foo/bar") == nil
          ]])

          ok(exec_lua [[
            local lspconfig = require("lspconfig")
            return lspconfig.util.path.is_absolute("../foo/bar") == nil
          ]])
        end)
      end)

      describe('join', function()
        it('', function()
          eq(
            exec_lua [[
            local lspconfig = require("lspconfig")
            return lspconfig.util.path.join("foo", "bar", "baz")
          ]],
            'foo/bar/baz'
          )
        end)
      end)
    end)

    describe('root_pattern', function()
      it('resolves to a_marker.txt', function()
        ok(exec_lua [[
          local lspconfig = require("lspconfig")

          -- change the working directory to test directory
          vim.api.nvim_command("cd ../test/test_dir/a")
          local cwd = vim.fn.getcwd()
          return cwd == lspconfig.util.root_pattern({"root_marker.txt", "a_marker.txt"})(cwd)
        ]])
      end)

      it('resolves to root_marker.txt', function()
        ok(exec_lua [[
          local lspconfig = require("lspconfig")

          -- change the working directory to test directory
          vim.api.nvim_command("cd ../test/test_dir/a")

          local cwd = vim.fn.getcwd()
          local resolved = lspconfig.util.root_pattern({"root_marker.txt"})(cwd)
          vim.api.nvim_command("cd ..")

          return vim.fn.getcwd() == resolved
        ]])
      end)
    end)
  end)
end)
