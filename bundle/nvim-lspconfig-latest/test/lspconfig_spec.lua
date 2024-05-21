local root = vim.fn.getcwd()

describe('lspconfig', function()
  local eq = assert.are.equal
  local same = assert.are.same

  before_each(function()
    vim.api.nvim_command('cd ' .. root)
  end)

  describe('util', function()
    describe('path', function()
      describe('escape_wildcards', function()
        it('doesnt escape if not needed', function()
          local lspconfig = require 'lspconfig'

          local res = lspconfig.util.path.escape_wildcards '/usr/local/test/fname.lua'
          eq('/usr/local/test/fname.lua', res)
        end)
        it('escapes if needed', function()
          local lspconfig = require 'lspconfig'

          local res = lspconfig.util.path.escape_wildcards '/usr/local/test/[sq brackets] fname?*.lua'
          eq('/usr/local/test/\\[sq brackets\\] fname\\?\\*.lua', res)
        end)
      end)
      describe('exists', function()
        it('is present directory', function()
          local lspconfig = require 'lspconfig'

          local cwd = vim.fn.getcwd()
          eq(true, lspconfig.util.path.exists(cwd) ~= false)
        end)

        it('is not present directory', function()
          local lspconfig = require 'lspconfig'
          local not_exist_dir = vim.fn.getcwd() .. '/not/exists'
          eq(true, lspconfig.util.path.exists(not_exist_dir) == false)
        end)

        it('is present file', function()
          local lspconfig = require 'lspconfig'
          -- change the working directory to test directory
          vim.api.nvim_command 'cd ./test/test_dir/'
          local file = vim.fn.getcwd() .. '/root_marker.txt'
          eq(true, lspconfig.util.path.exists(file) ~= false)
        end)

        it('is not present file', function()
          local lspconfig = require 'lspconfig'
          -- change the working directory to test directory
          vim.api.nvim_command 'cd ./test/test_dir/'
          local file = vim.fn.getcwd() .. '/not_exists.txt'
          assert.is_false(lspconfig.util.path.exists(file))
        end)
      end)

      describe('is_dir', function()
        it('is directory', function()
          local lspconfig = require 'lspconfig'
          local cwd = vim.fn.getcwd()
          assert.is_true(lspconfig.util.path.is_dir(cwd))
        end)

        it('is not present directory', function()
          local lspconfig = require 'lspconfig'
          local not_exist_dir = vim.fn.getcwd() .. '/not/exists'
          eq(true, not lspconfig.util.path.is_dir(not_exist_dir))
        end)

        it('is file', function()
          local lspconfig = require 'lspconfig'

          -- change the working directory to test directory
          vim.api.nvim_command 'cd ./test/test_dir/'
          local file = vim.fn.getcwd() .. '/root_marker.txt'

          eq(true, not lspconfig.util.path.is_dir(file))
        end)
      end)

      describe('is_file', function()
        it('is file', function()
          local lspconfig = require 'lspconfig'

          -- change the working directory to test directory
          vim.api.nvim_command 'cd ./test/test_dir/'
          local file = vim.fn.getcwd() .. '/root_marker.txt'

          eq(true, lspconfig.util.path.is_file(file))
        end)

        it('is not present file', function()
          local lspconfig = require 'lspconfig'

          -- change the working directory to test directory
          vim.api.nvim_command 'cd ./test/test_dir/'
          local file = vim.fn.getcwd() .. '/not_exists.txt'

          eq(true, not lspconfig.util.path.is_file(file))
        end)

        it('is directory', function()
          local lspconfig = require 'lspconfig'

          local cwd = vim.fn.getcwd()
          eq(true, not lspconfig.util.path.is_file(cwd))
        end)
      end)

      describe('is_absolute', function()
        it('is absolute', function()
          local lspconfig = require 'lspconfig'
          eq(true, lspconfig.util.path.is_absolute '/foo/bar' ~= nil)
        end)

        it('is not absolute', function()
          local lspconfig = require 'lspconfig'
          assert.is_nil(lspconfig.util.path.is_absolute 'foo/bar')
          assert.is_nil(lspconfig.util.path.is_absolute '../foo/bar')
        end)
      end)

      describe('join', function()
        it('', function()
          local lspconfig = require 'lspconfig'
          local res = lspconfig.util.path.join('foo', 'bar', 'baz')
          eq('foo/bar/baz', res)
        end)
      end)
    end)

    describe('root_pattern', function()
      it('resolves to a_marker.txt', function()
        local lspconfig = require 'lspconfig'
        -- change the working directory to test directory
        vim.api.nvim_command 'cd ./test/test_dir/a'
        local cwd = vim.fn.getcwd()
        eq(true, cwd == lspconfig.util.root_pattern { 'a_marker.txt', 'root_marker.txt' }(cwd))
      end)

      it('resolves to root_marker.txt', function()
        local lspconfig = require 'lspconfig'

        -- change the working directory to test directory
        vim.api.nvim_command 'cd ./test/test_dir/a'

        local cwd = vim.fn.getcwd()
        local resolved = lspconfig.util.root_pattern { 'root_marker.txt' }(cwd)
        vim.api.nvim_command 'cd ..'

        eq(true, vim.fn.getcwd() == resolved)
      end)
    end)

    describe('strip_archive_subpath', function()
      it('strips zipfile subpaths', function()
        local lspconfig = require 'lspconfig'
        local res = lspconfig.util.strip_archive_subpath 'zipfile:///one/two.zip::three/four'
        eq('/one/two.zip', res)
      end)

      it('strips tarfile subpaths', function()
        local lspconfig = require 'lspconfig'
        local res = lspconfig.util.strip_archive_subpath 'tarfile:/one/two.tgz::three/four'
        eq('/one/two.tgz', res)
      end)

      it('returns non-archive paths as-is', function()
        local lspconfig = require 'lspconfig'
        local res = lspconfig.util.strip_archive_subpath '/one/two.zip'
        eq('/one/two.zip', res)
      end)
    end)

    describe('user commands', function()
      it('should translate command definition to nvim_create_user_command options', function()
        local util = require 'lspconfig.util'
        local res = util._parse_user_command_options {
          function() end,
          '-nargs=* -complete=custom,v:lua.some_global',
        }

        same({
          nargs = '*',
          complete = 'custom,v:lua.some_global',
        }, res)

        res = util._parse_user_command_options {
          function() end,
          ['-nargs'] = '*',
          '-complete=custom,v:lua.another_global',
          description = 'My awesome description.',
        }
        same({
          desc = 'My awesome description.',
          nargs = '*',
          complete = 'custom,v:lua.another_global',
        }, res)
      end)
    end)
  end)

  describe('config', function()
    it('normalizes user, server, and base default configs', function()
      local lspconfig = require 'lspconfig'
      local configs = require 'lspconfig.configs'

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
          bar = {
            val3 = 'user3',
            val4 = 'user4',
          },
        },
      }

      configs['test'] = server_config
      configs['test'].setup(user_config)
      same({
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
      }, actual)
      configs['test'] = nil
    end)

    it("excludes indexed server configs that haven't been set up", function()
      local lspconfig = require 'lspconfig'
      local _ = lspconfig.lua_ls
      local _ = lspconfig.tsserver
      lspconfig.rust_analyzer.setup {}
      same({ 'rust_analyzer' }, require('lspconfig.util').available_servers())
    end)

    it('provides user_config to the on_setup hook', function()
      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      local user_config
      util.on_setup = function(_, conf)
        user_config = conf
      end
      lspconfig.rust_analyzer.setup { custom_user_config = 'custom' }
      same({
        custom_user_config = 'custom',
      }, user_config)
    end)
  end)
end)
