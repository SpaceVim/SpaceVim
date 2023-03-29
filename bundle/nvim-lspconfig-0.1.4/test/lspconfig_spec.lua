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
      describe('escape_wildcards', function()
        it('doesnt escape if not needed', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            return lspconfig.util.path.escape_wildcards('/usr/local/test/fname.lua') == '/usr/local/test/fname.lua'
          ]])
        end)
        it('escapes if needed', function()
          ok(exec_lua [[
            local lspconfig = require("lspconfig")

            return lspconfig.util.path.escape_wildcards('/usr/local/test/[sq brackets] fname?*.lua') == '/usr/local/test/\\[sq brackets\\] fname\\?\\*.lua'
          ]])
        end)
      end)
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

            local not_exist_dir = vim.fn.getcwd().."/not/exists"
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

            local not_exist_dir = vim.fn.getcwd().."/not/exists"
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

    describe('strip_archive_subpath', function()
      it('strips zipfile subpaths', function()
        ok(exec_lua [[
          local lspconfig = require("lspconfig")
          return lspconfig.util.strip_archive_subpath("zipfile:///one/two.zip::three/four") == "/one/two.zip"
        ]])
      end)

      it('strips tarfile subpaths', function()
        ok(exec_lua [[
          local lspconfig = require("lspconfig")
          return lspconfig.util.strip_archive_subpath("tarfile:/one/two.tgz::three/four") == "/one/two.tgz"
        ]])
      end)

      it('returns non-archive paths as-is', function()
        ok(exec_lua [[
          local lspconfig = require("lspconfig")
          return lspconfig.util.strip_archive_subpath("/one/two.zip") == "/one/two.zip"
        ]])
      end)
    end)

    describe('user commands', function()
      it('should translate command definition to nvim_create_user_command options', function()
        eq(
          {
            nargs = '*',
            complete = 'custom,v:lua.some_global',
          },
          exec_lua [[
            local util = require("lspconfig.util")
            return util._parse_user_command_options({
              function () end,
              "-nargs=* -complete=custom,v:lua.some_global"
            })
          ]]
        )

        eq(
          {
            desc = 'My awesome description.',
            nargs = '*',
            complete = 'custom,v:lua.another_global',
          },
          exec_lua [[
            local util = require("lspconfig.util")
            return util._parse_user_command_options({
              function () end,
              ["-nargs"] = "*",
              "-complete=custom,v:lua.another_global",
              description = "My awesome description."
            })
          ]]
        )
      end)
    end)
  end)

  describe('config', function()
    it('normalizes user, server, and base default configs', function()
      eq(
        exec_lua [[
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")

        local actual = nil
        lspconfig.util.on_setup = function(config)
          actual = config
        end

        lspconfig.util.default_config = {
          foo = {
            bar = {
              val1 = 'base1',
              val2 = 'base2',
            },
          },
        }

        local server_config = {
          default_config = {
            foo = {
              bar = {
                val2 = 'server2',
                val3 = 'server3',
              },
              baz = 'baz',
            },
          },
        }

        local user_config = {
          foo = {
            bar =  {
              val3 = 'user3',
              val4 = 'user4',
            }
          },
        }

        configs['test'] = server_config
        configs['test'].setup(user_config)
        return actual
      ]],
        {
          foo = {
            bar = {
              val1 = 'base1',
              val2 = 'server2',
              val3 = 'user3',
              val4 = 'user4',
            },
            baz = 'baz',
          },
          name = 'test',
        }
      )
    end)

    it("excludes indexed server configs that haven't been set up", function()
      eq(
        exec_lua [[
        local lspconfig = require("lspconfig")
        local actual = nil
        local _ = lspconfig.sumneko_lua
        local _ = lspconfig.tsserver
        lspconfig.rust_analyzer.setup {}
        return require("lspconfig.util").available_servers()
      ]],
        { 'rust_analyzer' }
      )
    end)

    it('provides user_config to the on_setup hook', function()
      eq(
        exec_lua [[
        local lspconfig = require "lspconfig"
        local util = require "lspconfig.util"
        local user_config
        util.on_setup = function (_, _user_config)
          user_config = _user_config
        end
        lspconfig.rust_analyzer.setup { custom_user_config = "custom" }
        return user_config
      ]],
        {
          custom_user_config = 'custom',
        }
      )
    end)
  end)
end)
