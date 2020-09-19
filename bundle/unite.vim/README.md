[![Stories in Ready](https://badge.waffle.io/Shougo/unite.vim.png)](https://waffle.io/Shougo/unite.vim)
![Unite.vim](https://s3.amazonaws.com/github-csexton/unite-brand.png)


**Note**: Active development on unite.vim has stopped. The only future changes
will be bug fixes.

Please see [Denite.nvim](https://github.com/Shougo/denite.nvim).


The unite or unite.vim plug-in can search and display information from
arbitrary sources like files, buffers, recently used files or registers.  You
can run several pre-defined actions on a target displayed in the unite window.

The difference between unite and similar plug-ins like fuzzyfinder,
ctrl-p or ku is that unite provides an integration interface for several
sources and you can create new interfaces using unite.

![](https://s3.amazonaws.com/github-csexton/unite-01.gif)

## Usage

[![Join the chat at https://gitter.im/Shougo/unite.vim](https://badges.gitter.im/Shougo/unite.vim.svg)](https://gitter.im/Shougo/unite.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Run unite to display files and buffers as sources to pick from.

	:Unite file buffer


Run unite with an initial filter value (foo) to narrow down files.

	:Unite -input=foo file


If you start unite it splits the window horizontally and pops up
from the top of Vim by default.

	:Unite file

The example call above lists all the files in the current directory. You can
choose one of them in the unite window by moving the cursor up and down
as usual with j and k. If you type Enter on an active candidate it will open
it in a new buffer. Enter triggers the default action for a candidate which is
"open" for candidates of the kind "file". You can also select an alternative
action for a candidate with <Tab>. See also `unite-action` to read on about
actions.

You can also narrow down the list of candidates by a keyword. If you change
into the insert mode inside of a unite window, the cursor drops you behind the
">" in the second line from above. There you can start typing to filter the
candidates.  You can also use the wild card `*` as an arbitrary character
sequence. For example,

	*hisa

matches hisa, ujihisa, or ujihisahisa. Furthermore, two consecutive wild cards
match a directory recursively.

	**/foo

So the example above matches bar/foo or buzz/bar/foo.
Note: The unite action `file_rec` does a recursive file matching by default
without the need to set wildcards.

You can also specify multiple keywords to narrow down the candidates. Multiple
keywords need to be separated either by a space " " or a dash "|". The
examples below match for candidates that meet both conditions "foo" and "bar".

	foo bar
	foo|bar

You can also specify negative conditions with an exclamation mark "!".  This
matches candidates that meet "foo" but do not meet "bar".

	foo !bar

Wild cards are added automatically if you add a "/" in the filter and you have
specified "files" as the buffer name with the option "-buffer-name". That's
handy in case you select files with unite.

	:Unite -buffer-name=files file

See also `unite_default_key_mappings` for other actions.

## Install

Install the distributed files into your Vim script directory which is usually
`~/.vim/`, or `$HOME/vimfiles` on Windows. You should consider using one of the
famous package managers for Vim like vundle or neobundle to install the
plugin.

After installation you can run unite with the `:Unite` command and append the
sources to the command you wish to select from as parameters. However, it's a
pain in the ass to run the command explicitly every time, so I recommend you
to set a key mapping for the command. See `:h unite`.

Note: MRU sources are splitted.  To use mru sources, you must install neomru.
https://github.com/Shougo/neomru.vim

## Resources

* [Unite plugins (in Japanese)](https://github.com/Shougo/unite.vim/wiki/unite-plugins)
* [Unite.vim, the Plugin You Didn't Know You Need](http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/)
* [Replacing All The Things with Unite.vim — Codeography](http://www.codeography.com/2013/06/17/replacing-all-the-things-with-unite-vim.html)
* [Beginner's Guide to Unite](http://usevim.com/2013/06/19/unite/)
* [Standards: How to make a Unite plugin](http://ujihisa.blogspot.jp/2010/11/how-to-make-unite-plugin.html)
* [FAQ (`:h unite-faq`)](https://github.com/Shougo/unite.vim/blob/master/doc/unite.txt#L3608)


## Screen shots

unite action source
-------------------
![Unite action source.](http://gyazo.com/c5c000170f28926aaf83d0c47bc5fcbb.png)

unite output source
-------------------
![Unite output source.](http://cdn-ak.f.st-hatena.com/images/fotolife/o/osyo-manga/20130307/20130307101224.png)

unite mapping source
--------------------
![Unite mapping source.](http://cdn-ak.f.st-hatena.com/images/fotolife/o/osyo-manga/20130307/20130307101225.png)

unite menu source
-----------------
![Unite menu source.](http://cdn-ak.f.st-hatena.com/images/fotolife/o/osyo-manga/20130307/20130307101227.png)

unite menu source with customization
------------------------------------
![Unite menu source with customization.](https://f.cloud.github.com/assets/390964/734885/82b91006-e2e1-11e2-9957-fb279bc71311.png)

```viml
let g:unite_source_menu_menus = get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.git = {
    \ 'description' : '            gestionar repositorios git
        \                            ⌘ [espacio]g',
    \}
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ tig                                                        ⌘ ,gt',
        \'normal ,gt'],
    \['▷ git status       (Fugitive)                                ⌘ ,gs',
        \'Gstatus'],
    \['▷ git diff         (Fugitive)                                ⌘ ,gd',
        \'Gdiff'],
    \['▷ git commit       (Fugitive)                                ⌘ ,gc',
        \'Gcommit'],
    \['▷ git log          (Fugitive)                                ⌘ ,gl',
        \'exe "silent Glog | Unite quickfix"'],
    \['▷ git blame        (Fugitive)                                ⌘ ,gb',
        \'Gblame'],
    \['▷ git stage        (Fugitive)                                ⌘ ,gw',
        \'Gwrite'],
    \['▷ git checkout     (Fugitive)                                ⌘ ,go',
        \'Gread'],
    \['▷ git rm           (Fugitive)                                ⌘ ,gr',
        \'Gremove'],
    \['▷ git mv           (Fugitive)                                ⌘ ,gm',
        \'exe "Gmove " input("destino: ")'],
    \['▷ git push         (Fugitive, salida por buffer)             ⌘ ,gp',
        \'Git! push'],
    \['▷ git pull         (Fugitive, salida por buffer)             ⌘ ,gP',
        \'Git! pull'],
    \['▷ git prompt       (Fugitive, salida por buffer)             ⌘ ,gi',
        \'exe "Git! " input("comando git: ")'],
    \['▷ git cd           (Fugitive)',
        \'Gcd'],
    \]
nnoremap <silent>[menu]g :Unite -silent -start-insert menu:git<CR>
```

## Video

https://www.youtube.com/watch?v=fwqhBSxhGU0&hd=1

It is a good introduction about the possibilities of Unite by ReneFroger.


## Special Thanks

* Dragon Image was originally from [Stanislav](http://All-Silhouettes.com)
