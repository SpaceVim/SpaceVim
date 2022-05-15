# plenary.nvim

All the lua functions I don't want to write twice.

> plenary:
>
>     full; complete; entire; absolute; unqualified.

Note that this library is useless outside of Neovim since it requires Neovim functions. It should be usable with any recent version of Neovim though.

At the moment, it is very much in pre-alpha :smile: Expect changes to the way some functions are structured. I'm hoping to finish some document generators to provide better documentation for people to use and consume and then at some point we'll stabilize on a few more stable APIs.

## Installation

```vim
Plug 'nvim-lua/plenary.nvim'
```

## Modules

- `plenary.async`
- `plenary.async_lib`
- `plenary.job`
- `plenary.path`
- `plenary.scandir`
- `plenary.context_manager`
- `plenary.test_harness`
- `plenary.filetype`
- `plenary.strings`

### plenary.async

A Lua module for asynchronous programming using coroutines. This library is built on native lua coroutines and `libuv`. Coroutines make it easy to avoid callback hell and allow for easy cooperative concurrency and cancellation. Apart from allowing users to perform asynchronous io easily, this library also functions as an abstraction for coroutines.

#### Getting started

You can do
```lua
local async = require "plenary.async"
```
All other modules are automatically required and can be accessed by indexing `async`.
You needn't worry about performance as this will require all the submodules lazily.

#### A quick example

Libuv luv provides this example of reading a file.

```lua
local uv = vim.loop

local read_file = function(path, callback)
  uv.fs_open(path, "r", 438, function(err, fd)
    assert(not err, err)
    uv.fs_fstat(fd, function(err, stat)
      assert(not err, err)
      uv.fs_read(fd, stat.size, 0, function(err, data)
        assert(not err, err)
        uv.fs_close(fd, function(err)
          assert(not err, err)
          callback(data)
        end)
      end)
    end)
  end)
end
```

We can write it using the library like this:
```lua
local a = require "plenary.async"

local read_file = function(path)
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)

  local err, stat = a.uv.fs_fstat(fd)
  assert(not err, err)

  local err, data = a.uv.fs_read(fd, stat.size, 0)
  assert(not err, err)

  local err = a.uv.fs_close(fd)
  assert(not err, err)

  return data
end
```

#### Plugins using this

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [vgit.nvim](https://github.com/tanvirtin/vgit.nvim)
- [neogit](https://github.com/TimUntersberger/neogit)

### plenary.async_lib

Please use `plenary.async` instead. This was version 1 and is just here for compatibility reasons.

### plenary.job

A Lua module to interact with system processes. Pass in your `command`, the desired `args`, `env` and `cwd`.
Define optional callbacks for `on_stdout`, `on_stderr` and `on_exit` and `start` your Job.

Note: Each job has an empty environment.

```lua
local Job = require'plenary.job'

Job:new({
  command = 'rg',
  args = { '--files' },
  cwd = '/usr/bin',
  env = { ['a'] = 'b' },
  on_exit = function(j, return_val)
    print(return_val)
    print(j:result())
  end,
}):sync() -- or start()
```

### plenary.path

A Lua module that implements a bunch of the things from `pathlib` from Python, so that paths are easy to work with.

### plenary.scandir

`plenery.scandir` is fast recursive file operations. It is similar to unix `find` or `fd` in that it can do recursive scans over a given directory, or a set of directories.

It offers a wide range of opts for limiting the depth, show hidden and more. `plenary.scan_dir` can be ran synchronously and asynchronously and offers `on_insert(file, typ)` and `on_exit(files)` callbacks. `on_insert(file, typ)` is available for both while `on_exit(files)` is only available for async.

```lua
local scan = require'plenary.scandir`
scan.scan_dir('.', { hidden = true, depth = 2 })
```

This module also offers `ls -la` sync and async functions that will return a formated string for all files in the directory.
Why? Just for fun

### plenary.context_manager

Implements `with` and `open` just like in Python. For example:

```lua
local with = context_manager.with
local open = context_manager.open

local result = with(open("README.md"), function(reader)
  return reader:read()
end)

assert(result == "# plenary.nvim")
```


### plenary.test_harness

Supports (simple) busted-style testing. It implements a mock-ed busted interface, that will allow you to run simple
busted style tests in separate neovim instances.

To run the current spec file in a floating window, you can use the keymap `<Plug>PlenaryTestFile`. For example:

```
nmap <leader>t <Plug>PlenaryTestFile
```

To run a whole directory from the command line, you could do something like:

```
nvim --headless -c "PlenaryBustedDirectory tests/plenary/ {minimal_init = 'tests/minimal_init.vim'}"
```

Where the first argument is the directory you'd like to test. It will search for files with
the pattern `*_spec.lua` and execute them in separate neovim instances.

The second argument is a Lua option table with the following fields:
- `minimal_init`: specify an init.vim to use for this instance, uses `--noplugin`
- `minimal`: uses `--noplugin` without an init script (overrides `minimal_init`)
- `sequential`: whether to run tests sequentially (default is to run in parallel)
- `keep_going`: if `sequential`, whether to continue on test failure (default true)
- `timeout`: controls the maximum time allotted to each job in parallel or
  sequential operation (defaults to 50,000 milliseconds)

The exit code is 0 when success and 1 when fail, so you can use it easily in a `Makefile`!


NOTE:

So far, the only supported busted items are:

- `describe`
- `it`
- `pending`
- `before_each`
- `after_each`
- `clear`
- `assert.*` etc. (from luassert, which is bundled)

OTHER NOTE:

We used to support `luaunit` and original `busted` but it turns out it was way too hard and not worthwhile
for the difficulty of getting them setup, particularly on other platforms or in CI. Now, we have a dep free
(or at least, no other installation steps necessary) `busted` implementation that can be used more easily.

Please take a look at the new APIs and make any issues for things that aren't clear. I am happy to fix them
and make it work well :)

OTHER OTHER NOTE:
Take a look at some test examples [here](TESTS_README.md).

#### Colors

You no longer need nvim-terminal to get this to work. We use `nvim_open_term` now.

### plenary.filetype

Will detect the filetype based on `extension`/`special filename`/`shebang` or `modeline`

- `require'plenary.filetype'.detect(filepath, opts)` is a function that does all of above and exits as soon as a filetype is found
- `require'plenary.filetype'.detect_from_extension(filepath)`
- `require'plenary.filetype'.detect_from_name(filepath)`
- `require'plenary.filetype'.detect_from_modeline(filepath)`
- `require'plenary.filetype'.detect_from_shebang(filepath)`

Add filetypes by creating a new file named `~/.config/nvim/data/plenary/filetypes/foo.lua` and register that file with
`:lua require'plenary.filetype'.add_file('foo')`. Content of the file should look like that:
```lua
return {
  extension = {
    -- extension = filetype
    -- example:
    ['jl'] = 'julia',
  },
  file_name = {
    -- special filenames, likes .bashrc
    -- we provide a decent amount
    -- name = filetype
    -- example:
    ['.bashrc'] = 'bash',
  },
  shebang = {
    -- Shebangs are supported as well. Currently we provide
    -- sh, bash, zsh, python, perl with different prefixes like
    -- /usr/bin, /bin/, /usr/bin/env, /bin/env
    -- shebang = filetype
    -- example:
    ['/usr/bin/node'] = 'javascript',
  }
}
```

### plenary.strings

Re-implement VimL funcs to use them in Lua loop.

* `strings.strdisplaywidth`
* `strings.strcharpart`

And some other funcs are here to deal with common problems.

* `strings.truncate`
* `strings.align_str`
* `strings.dedent`

### plenary.profile

Thin wrapper around LuaJIT's [`jit.p` profiler](https://blast.hk/moonloader/luajit/ext_profiler.html).

```lua
require'plenary.profile'.start("profile.log")

-- code to be profiled

require'plenary.profile'.stop()
```

You can use `start("profile.log", {flame = true})` to output the log in a
flamegraph-compatible format. A flamegraph can be created from this using
https://github.com/jonhoo/inferno via
```
inferno-flamegraph profile.log > flame.svg
```
The resulting interactive SVG file can be viewed in any browser.

Status: WIP

### plenary.popup

See [popup documentation](./POPUP.md) for both progress tracking and implemented APIs.

### plenary.window

Window helper functions to wrap some of the more difficult cases. Particularly for floating windows.

Status: WIP

### plenary.collections

Contains pure lua implementations for various standard collections.

```lua
local List = require 'plenary.collections.py_list'

local myList = List { 9, 14, 32, 5 }

for i, v in myList:iter() do
    print(i, v)
end

```

Status: WIP

### Troubleshooting

If you're having trouble / things are hanging / other problems:

```
$ export DEBUG_PLENARY=true
```

This will enable debuggin for the plugin.

### plenary.neorocks

DELETED: Please use packer.nvim or other lua-rocks wrapper instead. This no longer exists.

### FAQ

1. Error: Too many open files
- \*nix systems have a setting to configure the maximum amount of open file
  handles. It can occur that the default value is pretty low and that you end
  up getting this error after opening a couple of files. You can see the
  current limit with `ulimit -n` and set it with `ulimit -n 4096`. (macos might
  work different)
