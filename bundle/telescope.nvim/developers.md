# Developers

- [Introduction](#introduction)
- [Guide to your first Picker](#guide-to-your-first-picker)
  - [Requires](#requires)
  - [First Picker](#first-picker)
  - [Replacing Actions](#replacing-actions)
  - [Entry Maker](#entry-maker)
  - [Oneshot job](#oneshot-job)
  - [Previewer](#previewer)
  - [More examples](#more-examples)
  - [Bundling as Extension](#bundling-as-extension)
- [Technical](#technical)
  - [picker](#picker)
  - [finders](#finders)
  - [actions](#actions)
  - [previewers](#previewers)

## Introduction

So you want to develop your own picker and/or extension for telescope? Then you
are in the right place! This file will first present an introduction on how to
do this. After that, this document will present a technical explanation of
pickers, finders, actions and the previewer. Should you now yet have an idea of
the general telescope architecture and its components, it is first recommend to
familiarize yourself with the architectural flow-chart that is provided in
vim docs (`:h telescope.nvim`). You can find more information in specific help
pages and we will probably move some of the technical stuff to our vim help docs
in the future.

This guide is mainly for telescope so it will assume that you already have some knowledge of the Lua
programming language. If not then you can find information for Lua here:
- [Lua 5.1 Manual](https://www.lua.org/manual/5.1/)
- [Getting started using Lua in Neovim](https://github.com/nanotee/nvim-lua-guide)

## Guide to your first Picker

To guide you along the way to your first picker we will open an empty lua
scratch file, in which we will develop the picker and run it each time using
`:luafile %`. Later we will bundle this file as an extension.

### Requires

The most important includes are the following modules:
```lua
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
```

- `pickers`: main module which is used to create a new picker.
- `finders`: provides interfaces to fill the picker with items.
- `config`: `values` table which holds the user's configuration.
So to make it easier we access this table directly in `conf`.

### First Picker

We will now make the simplest color picker. (We will approach this example step by step,
you will still need to have the previous requires section above this code.)

```lua
-- our picker function: colors
local colors = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = { "red", "green", "blue" }
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- to execute the function
colors()
```

Running this code with `:luafile %` should open a telescope picker with the entries `red`,
`green`, `blue`. Selecting a color and pressing enter will open a new file. In this case
it's not what we want, so we will address this after explaining this snippet.

We will define a new function `colors` which accepts a table `opts`. This is good
practice because now the user can change how telescope behaves by passing in their
own `opts` table when calling `colors`.

For example the user can pass in a configuration in `opts` which allows them to change
the theme used for the picker. To allow this, we make sure to pass the `opts` table
as the first argument to `pickers.new`. The second argument is a table
which defines the default behavior of the picker.

We have defined a `prompt_title` but this isn't required. This will default to use
the text `Prompt` if not set.

`finder` is a required field that needs to be set to the result of a `finders`
function. In this case we take `new_table` which allows us to define a static
set of values, `results`, which is an array of elements, in this case our colors
as strings. It doesn't have to be an array of strings, it can also be an array of
tables. More on this later.

`sorter` on the other hand is not a required field but it's good practice to
define it, because the default value will set it to `empty()`, meaning no sorter
is attached and you can't filter the results. Good practice is to set the sorter
to either `conf.generic_sorter(opts)` or `conf.file_sorter(opts)`.

Setting it to a value from `conf` will respect the user's configuration, so if a user has set-up
`fzf-native` as the sorter then this decision will be respected and the `fzf-native` sorter
will be attached. It's also suggested to pass in `opts` here because the sorter
could make use of it. As an example the fzf sorter can be configured to be case
sensitive or insensitive. A user can set-up a default behavior and then alter
this behavior with the `opts` table.

After the picker is defined you need to call `find()` to actually start the
picker.

### Replacing Actions

Now calling `colors()` will result in the opening of telescope with the values:
`red`, `green` and `blue`. The default theme isn't optimal for this picker so we
want to change it and thanks to the acceptance of `opts` we can. We will replace
the last line with the following to open the picker with the `dropdown` theme.

```lua
colors(require("telescope.themes").get_dropdown{})
```

Now let's address the issue that selecting a color opens a new buffer. For that
we need to replace the default select action. The benefit of replacing rather than
mapping a new function to `<CR>` is that it will respect the user's configuration. So
if a user has remapped `select_default` to another key then this decision will
be respected and it works as expected for the user.

To make this work we need more requires at the top of the file.

```lua
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
```

- `actions`: holds all actions that can be mapped by a user. We also need it to
  access the default action so we can replace it. Also see `:help
  telescope.actions`

- `action_state`: gives us a few utility functions we can use to get the
  current picker, current selection or current line. Also see `:help
  telescope.actions.state`

So let's replace the default action. For that we need to define a new key value
pair in our table that we pass into `pickers.new`, for example after `sorter`.

```lua
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- print(vim.inspect(selection))
        vim.api.nvim_put({ selection[1] }, "", false, true)
      end)
      return true
    end,
```

We do this by setting the `attach_mappings` key to a function. This function
needs to return either `true` or `false`. If it returns false it means that only
the actions defined in the function should be attached. In this case it would
remove the default actions to move the selected item in the picker,
`move_selection_{next,previous}`. So in most cases you'll want to return `true`.
If the function does not return anything then an error is thrown.

The `attach_mappings` function has two parameters, `prompt_bufnr` is the buffer number
of the prompt buffer, which we can use to get the pickers object and `map` is a function
we can use to map actions or functions to arbitrary key sequences.

Now we are replacing `select_default` the default action, which is mapped to `<CR>`
by default. To do this we need to call `actions.select_default:replace` and
pass in a new function.

In this new function we first close the picker with `actions.close` and then
get the `selection` with `action_state`. It's important
to notice that you can still get the selection and current prompt input
(`action_state.get_current_line()`) with `action_state` even after the picker is
closed.

You can look at the selection with `print(vim.inspect(selection))` and see that it differs from our input
(string), this is because internally we pack it into a table with different
keys. You can specify this behavior and we'll talk about that in the next
section. Now all that is left is to do something with the selection we have. In
this case we just put the text in the current buffer with `vim.api.nvim_put`.

### Entry Maker

Entry maker is a function used to transform an item from the finder to an
internal entry table, which has a few required keys. It allows us to display
one string but match something completly different. It also allows us to set
an absolute path when working with files (so the file will always be found)
and a relative file path for display and sorting. This means the relative file
path doesn't even need to be valid in the context of the current working directory.

We will now try to define our entry maker for our example by providing an
`entry_maker` to `finders.new_table` and changing our table to be a little bit
more interesting. We will end up with the following new code for `finders.new_table`:

```lua
    finder = finders.new_table {
      results = {
        { "red", "#ff0000" },
        { "green", "#00ff00" },
        { "blue", "#0000ff" },
      },
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
```

With the new snippet, we no longer have an array of strings but an array of
tables. Each table has a color, name, and the color's hex value.

`entry_maker` is a function that will receive each table and then we can set the
values we need. It's best practice to have a `value` reference to the
original entry, that way we will always have access to the complete table in our
action.

The `display` key is required and is either a string or a `function(tbl)`,
where `tbl` is the table returned by `entry_maker`. So in this example `tbl` would
give our `display` function access to `value` and `ordinal`.

If our picker will have a lot of values it's suggested to use a function for `display`,
especially if you are modifying the text to display. This way the function will only be executed
for the entries being displayed. For an example of an entry maker take a look at
`lua/telescope/make_entry.lua`.

A good way to make your `display` more like a table is to use a `displayer` which can be found in
`lua/telescope/pickers/entry_display.lua`. A simpler example of `displayer` is the
function `gen_from_git_commits` in `make_entry.lua`.

The `ordinal` is also required, which is used for sorting. As already mentioned
this allows us to have different display and sorting values. This allows `display`
to be more complex with icons and special indicators but `ordinal` could be a simpler
sorting key.

There are other important keys which can be set, but do not make sense in the
current context as we are not dealing with files:
- `path`: to set the absolute path of the file to make sure it's always found
- `lnum`: to specify a line number in the file. This will allow the
  `conf.grep_previewer` to show that line and the default action to jump to
  that line.

### Previewer

We will not write a previewer for this picker because it isn't required for
basic colors and is a more advanced topic. It's already well documented in `:help
telescope.previewers` so you can read this section if you want to write your
own `previewer`. If you want a file previewer without columns you should
default to `conf.file_previewer` or `conf.grep_previewer`.

### Oneshot Job

The `oneshot_job` finder can be used to have an asynchronous external process which will
find results and call `entry_maker` for each entry. An example usage would be
`find`.

```lua
finder = finders.new_oneshot_job({ "find" }, opts ),
```

### More examples

A good way to find more examples is to look into the [lua/telescope/builtin](https://github.com/nvim-telescope/telescope.nvim/tree/master/lua/telescope/builtin)
directory which contains all of the builtin pickers. Another way to find more examples
is to take a look at the [extension wiki page](https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions)
as this provides many extensions people have already written which use these concepts.

If you still have any questions after reading this guide please feel free to ask us for
more information on [gitter](https://gitter.im/nvim-telescope/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
and we will happily answer your questions and hopefully allow us to improve this guide. You can also
help us to improve this guide by sending a PR.

### Bundling as extension

If you now want to bundle your picker as extension, so it is available as
picker via the `:Telescope` command, the following has to be done.

Structure your plugin as follows, so it can be found by telescope:

```
.
└── lua
    ├── plugin_name             # Your actual plugin code
    │   ├── init.lua
    │   └── some_file.lua
    └── telescope
        └── _extensions         # The underscore is significant
            └─ plugin_name.lua  # Init and register your extension
```

The `lua/telescope/_extensions/plugin_name.lua` file needs to return the
following: (see `:help telescope.register_extension`)

```lua
return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    stuff = require("plugin_name").stuff
  },
}
```

The setup function can be used to access the extension config and setup
extension specific global configuration. You also have access to the user
telescope default config, so you can override specific internal function. For
example sorters if you have an extension that provides a replacement sorter,
like
[telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim).

The exports table declares the exported pickers that can then be accessed via
`Telescope plugin_name stuff`. If you only provide one export it is suggested
that you name the key like the plugin, so you can access it with `Telescope
plugin_name`.


## Technical

### Picker

This section is an overview of how custom pickers can be created and configured.

```lua
-- lua/telescope/pickers.lua
Picker:new{
  prompt_title            = "",
  finder                  = FUNCTION, -- see lua/telescope/finder.lua
  sorter                  = FUNCTION, -- see lua/telescope/sorter.lua
  previewer               = FUNCTION, -- see lua/telescope/previewer.lua
  selection_strategy      = "reset", -- follow, reset, row
  border                  = {},
  borderchars             = {"─", "│", "─", "│", "┌", "┐", "┘", "└"},
  default_selection_index = 1, -- Change the index of the initial selection row
}
```

### Finders
<!-- TODO what are finders -->
```lua
-- lua/telescope/finders.lua
Finder:new{
  entry_maker     = function(line) end,
  fn_command      = function() { command = "", args  = { "ls-files" } } end,
  static          = false,
  maximum_results = false
}
```

### Actions

#### Overriding actions/action_set

How to override what different functions / keys do.

TODO: Talk about what actions vs actions sets are

##### Relevant Files

- `lua/telescope/actions/init.lua`
    - The most "user-facing" of the files, which has the builtin actions that we provide
- `lua/telescope/actions/set.lua`
    - The second most "user-facing" of the files. This provides actions that are consumed by several builtin actions, which allows for only overriding ONE item, instead of copying the same configuration / function several times.
- `lua/telescope/actions/state.lua`
    - Provides APIs for interacting with the state of telescope from within actions.
    - These are useful for writing your own actions and interacting with telescope
- `lua/telescope/actions/mt.lua`
    - You probably don't need to look at this, but it defines the behavior of actions.

##### `:replace(function)`

Directly override an action with a new function

```lua
local actions = require('telescope.actions')
actions.select_default:replace(git_checkout_function)
```

##### `:replace_if(conditional, function)`

Override an action only when `conditional` returns true.

```lua
local action_set = require('telescope.actions.set')
action_set.select:replace_if(
  function()
    return action_state.get_selected_entry().path:sub(-1) == os_sep
  end, function(_, type)
    -- type is { "default", "horizontal", "vertical", "tab" }
    local path = actions.get_selected_entry().path
    action_state.get_current_picker(prompt_bufnr):refresh(gen_new_finder(new_cwd), { reset_prompt = true})
  end
)
```

##### `:replace_map(configuration)`

```lua
local action_set = require('telescope.actions.set')
-- Use functions as keys to map to which function to execute when called.
action_set.select:replace_map {
  [function(e) return e > 0 end] = function(e) return (e / 10) end,
  [function(e) return e == 0 end] = function(e) return (e + 10) end,
}
```

### Previewers

See `:help telescope.previewers`
