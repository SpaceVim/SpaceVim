# Vim Better Whitespace Plugin

This plugin causes all trailing whitespace characters (see [Supported Whitespace
Characters](#supported-whitespace-characters) below) to be highlighted. Whitespace for the current line will
not be highlighted while in insert mode. It is possible to disable current line highlighting while in other
modes as well (see options below). A helper function `:StripWhitespace` is also provided to make whitespace
cleaning painless.

Here is a screenshot of this plugin at work:
![Example Screenshot](http://i.imgur.com/St7yHth.png)

## Installation
There are a few ways you can go about installing this plugin:

1.  If you have [Vundle](https://github.com/gmarik/Vundle.vim) you can simply add:
    ```vim
    Plugin 'ntpeters/vim-better-whitespace'
    ```
    to your `.vimrc` file then run:
    ```vim
    :PluginInstall
    ```
2.  If you are using [Pathogen](https://github.com/tpope/vim-pathogen), you can just run the following command:
    ```
    git clone git://github.com/ntpeters/vim-better-whitespace.git ~/.vim/bundle/vim-better-whitespace
    ```
3.  While this plugin can also be installed by copying its contents into your `~/.vim/` directory, I would
    highly recommend using one of the above methods as they make managing your Vim plugins painless.

## Usage
Whitespace highlighting is enabled by default, with a highlight color of red.

*  To set a custom highlight color, just call:
    ```vim
    highlight ExtraWhitespace ctermbg=<desired_color>
    ```
   or

    ```vim
    let g:better_whitespace_ctermcolor='<desired_color>'
    ```
   Similarly, to set gui color:

    ```vim
    let g:better_whitespace_guicolor='<desired_color>'
    ```

*  To enable highlighting and stripping whitespace on save by default, use respectively
    ```vim
    let g:better_whitespace_enabled=1
    let g:strip_whitespace_on_save=1
    ```
    Set them to 0 to disable this default behaviour. See below for the blacklist of file types
    and per-buffer settings.

*  To enable/disable/toggle whitespace highlighting in a buffer, call one of:
    ```vim
    :EnableWhitespace
    :DisableWhitespace
    :ToggleWhitespace
    ```

*  The highlighting for the current line in normal mode can be disabled in two ways:
    *  ```vim
       let g:current_line_whitespace_disabled_hard=1
       ```
        This will maintain whitespace highlighting as it is, but may cause a
        slow down in Vim since it uses the CursorMoved event to detect and
        exclude the current line.

    *  ```vim
       let g:current_line_whitespace_disabled_soft=1
       ```
       This will use syntax based highlighting, so there shouldn't be a
       performance hit like with the `hard` option.  The drawback is that this
       highlighting will have a lower priority and may be overwritten by higher
       priority highlighting.

*  To clean extra whitespace, call:
    ```vim
    :StripWhitespace
    ```
    By default this operates on the entire file. To restrict the portion of
    the file that it cleans, either give it a range or select a group of lines
    in visual mode and then execute it.

    *  There is an operator (defaulting to `<leader>s`) to clean whitespace.
        For example, in normal mode, `<leader>sip` will remove trailing whitespace from the
        current paragraph.

        You can change the operator it, for example to set it to _s, using:
        ```vim
        let g:better_whitespace_operator='_s'
        ```
        Now `<number>_s<space>` strips whitespace on \<number\> lines, and `_s<motion>` on the
        lines affected by the motion given. Set to the empty string to deactivate the operator.

        Note: This operator will not be mapped if an existing, user-defined
        mapping is detected for the provided operator value.

*  To enable/disable stripping of extra whitespace on file save for a buffer, call one of:
    ```vim
    :EnableStripWhitespaceOnSave
    :DisableStripWhitespaceOnSave
    :ToggleStripWhitespaceOnSave
    ```
    This will strip all trailing whitespace everytime you save the file for all file types.

    *  If you want this behaviour by default for all filetypes, add the following to your `~/.vimrc`:

        ```vim
        let g:strip_whitespace_on_save = 1
        ```

        For exceptions of all see ```g:better_whitespace_filetypes_blacklist```.

    *  If you would prefer to only strip whitespace for certain filetypes, add
        the following to your `~/.vimrc`:

        ```vim
        autocmd FileType <desired_filetypes> EnableStripWhitespaceOnSave
        ```

        where `<desired_filetypes>` is a comma separated list of the file types you want
        to be stripped of whitespace on file save ( ie. `javascript,c,cpp,java,html,ruby` )

    *  If you want to disable automatically stripping whitespace for large files, you can specify
       a maximum number of lines (e.g. 1000) by adding the following to your `~/.vimrc`:

       ```vim
       let g:strip_max_file_size = 1000
       ```

       This overrides `let g:strip_whitespace_on_save` but not `:EnableStripWhitespaceOnSave`.
       Set to `0` to deactivate.

    *  By default, you will be asked for confirmation before whitespace is
       stripped when you save the file. This can be disabled by adding the
       following to your `~/.vimrc`:
       ```
       let g:strip_whitespace_confirm=0
       ```

    *  By default, all the lines in the file will have their trailing whitespace stripped
       when you save the file. This can be changed to only the modified lines, by adding
       the following to your `~/.vimrc`:
       ```
       let g:strip_only_modified_lines=1
       ```

    *  You can override the binary used to check which lines have been modified in the file.
       For example to force a 'diff' installed in a different prefix and ignoring the changes
       due to tab expansions, you can set the following:
       ```
       let g:diff_binary='/usr/local/bin/diff -E'
       ```

*  To disable the highlighting for specific file types, add the following to your `~/.vimrc`:
    ```vim
    let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>']
    ```
    This replaces the filetypes from the default list of blacklisted filetypes. The
    default types that are blacklisted are:
    ```vim
    ['diff', 'gitcommit', 'unite', 'qf', 'help', 'markdown']
    ```
    If you prefer to also keep these default filetypes ignored, simply include them in the
    blacklist:
    ```vim
    let g:better_whitespace_filetypes_blacklist=['<filetype1>', '<filetype2>', '<etc>',
                                            'diff', 'gitcommit', 'unite', 'qf', 'help']
    ```

    This blacklist can be overriden on a per-buffer basis using the buffer toggle enable and
    disable commands presented above. For example:
    ```vim
    " highlight whitespace in markdown files, though stripping remains disabled by the blacklist
    :autocmd FileType markdown EnableWhitespace
    " Do not modify kernel files, even though their type is not blacklisted and highlighting is enabled
    :autocmd BufRead /usr/src/linux* DisableStripWhitespaceOnSave
    ```

*  To strip white lines at the end of the file when stripping whitespace, set this option in your `.vimrc`:
    ```vim
    let g:strip_whitelines_at_eof=1
    ```

*  To highlight space characters that appear before or in-between tabs, add the following to your `.vimrc`:
    ```vim
    let g:show_spaces_that_precede_tabs=1
    ```
    Such spaces can **not** be automatically removed by this plugin, though you can try
    [`=` to fix indentation](http://vimdoc.sourceforge.net/htmldoc/change.html#=).
    You can still navigate to the highlighted spaces with Next/PrevTrailingWhitespace (see below), and fix
    them manually.

*  To ignore lines that contain only whitespace, set the following in your `.vimrc`:
    ```vim
    let g:better_whitespace_skip_empty_lines=1
    ```

*  To navigate to the previous or next trailing whitespace, you can use commands that you
    can map thusly in your `.vimrc`:
    ```vim
    nnoremap ]w :NextTrailingWhitespace<CR>
    nnoremap [w :PrevTrailingWhitespace<CR>
    ```
    Note: those command take an optional range as argument, so you can for example select some
    text in visual mode and search only inside it:
    ```vim
    :'<,'>NextTrailingWhitespace
    ```

*  To enable verbose output for each command, set verbosity in your `.vimrc`:
    ```vim
    let g:better_whitespace_verbosity=1
    ```

## Supported Whitespace Characters
Due to the fact that the built-in whitespace character class for patterns (`\s`)
only matches against tabs and spaces, this plugin defines its own list of
horizontal whitespace characters to match for both highlighting and stripping.

This is list should match against all ASCII and Unicode horizontal whitespace
characters:
```
    U+0009   TAB
    U+0020   SPACE
    U+00A0   NO-BREAK SPACE
    U+1680   OGHAM SPACE MARK
    U+180E   MONGOLIAN VOWEL SEPARATOR
    U+2000   EN QUAD
    U+2001   EM QUAD
    U+2002   EN SPACE
    U+2003   EM SPACE
    U+2004   THREE-PER-EM SPACE
    U+2005   FOUR-PER-EM SPACE
    U+2006   SIX-PER-EM SPACE
    U+2007   FIGURE SPACE
    U+2008   PUNCTUATION SPACE
    U+2009   THIN SPACE
    U+200A   HAIR SPACE
    U+200B   ZERO WIDTH SPACE
    U+202F   NARROW NO-BREAK SPACE
    U+205F   MEDIUM MATHEMATICAL SPACE
    U+3000   IDEOGRAPHIC SPACE
    U+FEFF   ZERO WIDTH NO-BREAK SPACE
```

A file is provided with samples of each of these characters to check the plugin
working with them: whitespace_examples.txt

If you encounter any additional whitespace characters I have missed here,
please submit a pull request.

## Screenshots
Here are a couple more screenshots of the plugin at work.

This screenshot shows the current line not being highlighted in insert mode:
![Insert Screenthot](http://i.imgur.com/RNHR9KX.png)

This screenshot shows the current line not being highlighted in normal mode(`CurrentLineWhitespaceOff hard`):
![Normal Screenshot](http://i.imgur.com/o888Z7b.png)

This screenshot shows that highlighting works fine for spaces, tabs, and a mixture of both:
![Tabs Screenshot](http://i.imgur.com/bbsVRUf.png)

## Frequently Asked Questions
Hopefully some of the most common questions will be answered here.  If you still have a question
that I have failed to address, please open an issue and ask it!

**Q:  Why is trailing whitespace such a big deal?**

A:  In most cases it is not a syntactical issue, but rather is a common annoyance among
    programmers.


**Q:  Why not just use `listchars` with `SpecialKey` highlighting?**

A:  I tried using `listchars` to show trail characters with `SpecialKey` highlighting applied.
    Using this method the characters would still show on the current line for me even when the
    `SpecialKey` foreground highlight matched the `CursorLine` background highlight.


**Q:  Okay, so `listchars` doesn't do exactly what you want, why not just use a `match` in your `vimrc`?**

A:  I am using `match` in this plugin, but I've also added a way to exclude the current line in
    insert mode and/or normal mode.


**Q:  If you just want to exclude the current line, why not just use syntax-based highlight rather
    than using `match` and `CursorMoved` events?**

A:  Syntax-based highlighting is an option in this plugin.  It is used to omit the current line when
    using `CurrentLineWhitespaceOff soft`. The only issue with this method is that `match` highlighing
    takes higher priorty than syntax highlighting. For example, when using a plugin such as
    [Indent Guides](https://github.com/nathanaelkane/vim-indent-guides), syntax-based highlighting of
    extra whitespace will not highlight additional white space on emtpy lines.


**Q:  I already have my own method of removing white space, why is the method used in this plugin better?**

A:  It may not be, depending on the method you are using. The method used in this plugin strips extra
    white space and then restores the cursor position and last search history.


**Q:  Most of this is pretty easy to just add to users' `vimrc` files. Why make it a plugin?**

A:  It is true that a large part of this is fairly simple to make a part of an individuals
    configuration in their `vimrc`.  I wanted to provide something that is easy to setup and use
    for both those new to Vim and others who don't want to mess around setting up this
    functionality in their `vimrc`.

**Q:  Can you add indentation highlighting for spaces/tabs? Can you add highlighting for other
    types of white space?**

A:  No, and no. Sorry, but both are outside the scope of this plugin. The purpose of this plugin
    is to provide a better experience for showing and dealing with extra white space. There is already an
    amazing plugin for showing indentation in Vim called [Indent
    Guides](https://github.com/nathanaelkane/vim-indent-guides). For other types of white space highlighting,
    [listchars](http://vimdoc.sourceforge.net/htmldoc/options.html#'listchars') should be sufficient.

**Q:  I have a better way to do something in this plugin. OR You're doing something stupid/wrong/bad.**

A:  If you know of a better way to do something I am attempting in this plugin, or if I am doing
    something improperly/not reccomended then let me know! Please either open an issue informing
    me or make the changes yourself and open a pull request. If I am doing something that is bad
    or can be improved, I am more than willing to hear about it!

## Deprecated commands
Toggling the current line whitespace mode is now a plugin configuration,
and can not be done dynamically anymore. Thus the folowing commands are now deprecated:

```vim
:CurrentLineWhitespaceOff <level>
```
where `<level>` is either `hard` or `soft`, and:

```vim
:CurrentLineWhitespaceOn
```

If you really miss this feature, its withdrawal can easily be overriden
by adding the following to the vimrc (after loading the plugin initially):

```vim
fun! BetterWhitespaceCurrentLineMode(type)
        " set setting to whatever was passed
        let g:current_line_whitespace_disabled_soft=a:type == 'soft'
        let g:current_line_whitespace_disabled_hard=a:type == 'hard'
        " reload plugin
        unlet! g:loaded_better_whitespace_plugin
        runtime plugin/better-whitespace.vim
        " Re-override the deprecated commands
        command! -nargs=1 CurrentLineWhitespaceOff call BetterWhitespaceCurrentLineMode(<f-args>)
        command! CurrentLineWhitespaceOn call BetterWhitespaceCurrentLineMode('off')
        " Manually trigger change for current buffer.
        " BufWinEnter will take care of the rest.
        filetype detect
endfun

" Override deprecated commands, after (!) loading plugin
command! -nargs=1 CurrentLineWhitespaceOff call BetterWhitespaceCurrentLineMode(<f-args>)
command! CurrentLineWhitespaceOn call BetterWhitespaceCurrentLineMode('off')
```

## Promotion
If you like this plugin, please star it on Github and vote it up at Vim.org!

Repository exists at: http://github.com/ntpeters/vim-better-whitespace

Plugin also hosted at: http://www.vim.org/scripts/script.php?script_id=4859

## Credits
Originally inspired by: https://github.com/bronson/vim-trailing-whitespace

Based on:

http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html

http://vim.wikia.com/wiki/Highlight_unwanted_spaces
