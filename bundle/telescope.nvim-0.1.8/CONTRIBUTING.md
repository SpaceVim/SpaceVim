# Contributing

Thanks for taking the time to submit code to Telescope if you're reading this!
We love having new contributors and love seeing the Neovim community come around this plugin and keep making it better.

At this time, we are content with the number and functionality of the pickers we offer built
in with Telescope and so we are currently not accepting new pickers
(see this [issue](https://github.com/nvim-telescope/telescope.nvim/issues/1228) for a discussion on this).

We are also conservative with integrating picker specific actions and features.
If you're still interested in filling a particular picker need, we encourage packaging it up as its own Telescope extension.
Read our [Bundling as extension](https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#bundling-as-extension) guide here for more info on this.
See other Telescope extensions (and add yours) [here](https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions).

That said, we welcome bug fixes, documentation improvements and non-picker specific features.
If you're submitting a new feature, it is a good idea to create an issue first to gauge interest and feasibility.

To learn how we go about writing documentation for this project, keep reading below!

## Documentation with treesitter

We are generating docs based on the tree sitter syntax tree. TJ wrote a grammar that includes the documentation in this syntax tree so we can do take this function header documentation and transform it into vim documentation. All documentation that is part of the returning module will be exported. For example:

```lua
local m = {}

--- Test Header
--@return 1: Returns always 1
function m.a() -- or m:a()
  return 1
end

--- Documentation
function m.__b() -- or m:__b()
  return 2
end

--- Documentation
local c = function()
  return 2
end

return m
```

This will export function `a` with header documentation and the return value. Module function `b` and local function `c` will not be exported.

For a more in-depth look at how to write documentation take a look at this guide: [how to](https://github.com/tjdevries/tree-sitter-lua/blob/master/HOWTO.md)
This guide contains all annotations and we will update it when we add new annotations.

## What is missing?

The docgen has some problems on which people can work. This would happen in [tree-sitter-lua](https://github.com/tjdevries/tree-sitter-lua) and documentation of some modules here.
I would suggest we are documenting lua/telescope/builtin/init.lua rather than the files itself. We can use that init.lua file as "header" file, so we are not cluttering the other files.
How to help out with documentation:

## Auto-updates from CI

The easy way would be:

- write some docs
- commit, push and create draft PR
- wait a minute until the CI generates a new commit with the changes
- Look at this commit and the changes
- Modify documentation until its perfect. You can do `git commit --amend` and `git push --force` to remove the github ci commit again

## Generate on your local machine

The other option would be setting up <https://github.com/tjdevries/tree-sitter-lua>

- Install Treesitter, either with package manager or with github release
- Install plugin as usual
- cd to plugin
- `mkdir -p build parser` sadly those don't exist
- `make build_parser`
- `ln -s ../build/parser.so parser/lua.so` We need the shared object in parser/ so it gets picked up by neovim. Either copy or symbolic link
- Make sure that nvim-treesitter lua parser is not installed and also delete the lua queries in that repository. `queries/lua/*`. If you are not doing that you will have a bad time!
- cd into this project
- Write doc
- Run `make docgen`
- Repeat last two steps
