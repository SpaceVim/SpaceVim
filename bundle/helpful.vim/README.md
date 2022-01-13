# helpful.vim

A plugin for plugin developers to get the version of Vim and Neovim that
introduced or removed features.

![helpful](https://cloud.githubusercontent.com/assets/111942/16898497/2bf0a402-4baa-11e6-9f9b-3793384d5894.png)


## Usage

The command `:HelpfulVersion` takes a Vim pattern to search for helptags and
display version information.

Examples:

```vim
" Search for a function
:HelpfulVersion matchaddpos()

" Search for keys
:HelpfulVersion <.*>

" Case-insensitive search
:HelpfulVersion f11\c
```


## Options

- `b:helpful` - If set to `1`, display version information about the text under
  the cursor on `CursorMoved` in `help` or `vim` filetypes.
- `g:helpful` - Same as above but always on.  It's also less humorous to read
  out loud.

## License

MIT
