indentLine
==========

This plugin is used for displaying thin vertical lines at each indentation level for code indented with spaces. For code indented with tabs I think there is no need to support it, because you can use `:set list lcs=tab:\|\ (here is a space)`.

## Requirements
This plugin takes advantage of the newly provided `conceal` feature in Vim 7.3, so this plugin will not work with lower versions of Vim.

## Installation
If you are using VIM version 8 or higher you can use its built-in package management; see `:help packages` for more information. Just run these commands in your terminal:
```bash
git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLint
vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLint/doc" -c "q"
```

Otherwise, these are some of the other options:

* To install the plugin just put the plugin files in your `~/.vim` (Linux) or `~/vimfiles` (Windows).

* If you use a plugin manager you can put the whole directory into your `~/.vim/bundle/` directory ([Pathogen][pathogen]) or add the line `Plugin 'Yggdroot/indentLine'` to your `.vimrc` ([Vundle][vundle]).

## Customization
To apply customization, apply the variable definitions to your `.vimrc` file.

**Change Character Color**

indentLine will overwrite 'conceal' color with grey by default. If you want to highlight conceal color with your colorscheme, disable by:
```vim
let g:indentLine_setColors = 0
```

Or you can customize conceal color by: 
```vim
" Vim
let g:indentLine_color_term = 239

" GVim
let g:indentLine_color_gui = '#A4E57E'

" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

" Background (Vim, GVim)
let g:indentLine_bgcolor_term = 202
let g:indentLine_bgcolor_gui = '#FF5F00'
```

**Change Indent Char**

Vim and GVim
```vim
let g:indentLine_char = 'c'
```
where `'c'` can be any ASCII character. You can also use one of `¦`, `┆`, `│`, `⎸`, or `▏` to display more beautiful lines. However, these characters will only work with files whose encoding is UTF-8.

or
```vim
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
```
each indent level has a distinct character.

**Change Conceal Behaviour**

This plugin enables the Vim `conceal` feature which automatically hides stretches of text based on syntax highlighting. This setting will apply to all syntax items.

For example, users utilizing the built in json.vim syntax file will no longer see quotation marks in their JSON files.

indentLine will overwrite your "concealcursor" and "conceallevel" with default value:

```vim
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
```

You can customize these settings, but the plugin will not function if `conceallevel` is not set to 1 or 2.

If you want to keep your conceal setting, put this line to your vim dotfile:
```vim
let g:indentLine_setConceal = 0
```

See the [VIM Reference Manual](http://vimdoc.sourceforge.net/htmldoc/version7.html#new-conceal) for more information on the `conceal` feature.


**Disable by default**
```vim
let g:indentLine_enabled = 0
```

### Commands
`:IndentLinesToggle` toggles lines on and off.

### Font patching
If you find all the standard unicode and ASCII characters too obtrusive, you might consider patching your font with the [indentLine-dotted-guide.eps][glyph] glyph provided.  [FontForge][fontforge] makes the process amazingly simple:

 1. Download and install FontForge.
 2. Locate and open your terminal/gVim font.
 3. Open the font in FontForge, choose __Goto__ from the __View__ menu and select _Private Use Area_ from the drop down box.
 4. In the private use area, locate a blank spot for the glyph. Make a note of the code, e.g. `U+E0A3`.
 5. Double-click the selected code point to open the font drawing tool.
 6. From the __File__ menu, select __Import...__ and locate the _indentLine-dotted-guide.eps_ file.
 7. Once imported, choose __File__ -> __Generate Fonts__ and choose a location and file type for the new font.

Once completed, your new font will contain the more subtle dotted guide and all you have to do is set that glyph to `g:indentLine_char` in your `.vimrc` file.

[glyph]: glyph/indentLine-dotted-guide.eps
[fontforge]: http://fontforge.github.io/

## Self promotion
If you think this script is helpful, follow the [GitHub repository][repository], and don't forget to vote for it on Vim.org! ([vimscript #4354][script]).

[pathogen]: https://github.com/tpope/vim-pathogen
[vundle]: https://github.com/gmarik/vundle
[repository]: https://github.com/Yggdroot/indentLine
[script]: http://www.vim.org/scripts/script.php?script_id=4354

## Screenshots

### Vertical bars
![Screenshot](http://i.imgur.com/KVi0T.jpg)

### Patched font
![Screenshot](http://i.imgur.com/2ZA7oaZ.png)

### Leading Spaces
![Screenshot](http://i.imgur.com/tLYkb79.png)

![Screenshot](http://i.imgur.com/07Atrrs.png)

## License
- MIT
