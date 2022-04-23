[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/jdonaldson/vaxe?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Vaxe is a vim bundle for [Haxe][haxe] and [Hss][ncannasse].  It provides support
for syntax highlighting, indenting, compiling, and many more options.  Vaxe has
[vimdoc][github], accessible using `:help vaxe` within vim.

Vaxe requires additional vim features in order to work fully:

1. Vim version >= 7 : (Vim versions prior to this may work,
   but are not tested)
2. Vim with python scripting support : Many default vim environments do not have
   python support, but it's typically very easy to get an appropriate version
   via a package manager like brew or apt-get.


This page will describe some of the special or optional features that vaxe
supports, in addition to recommended configuration settings.

![Vaxe Screenshot][imgur] (screenshot shows
neocomplcache completion mode, vim-airline, tagbar, and monokai color theme)

The recommended way to install vaxe is using a bundle management system such
as [pathogen][], [vundle][], [vam][], or [vim-plug][].

# Install with Pathogen

1. Install pathogen using the [instructions][pathogen].
2. Create/cd into `~/.vim/bundle/`
3. Make a clone of the vaxe repo:
    `git clone https://github.com/jdonaldson/vaxe.git`

To update:

1. cd into `~/.vim/bundle/vaxe/`
2. git pull

# Install with Vundle

1. Install vundle using the [instructions][vundle]
2. Add vaxe to your plugin list in `.vimrc` and re-source it:
    `Plugin 'jdonaldson/vaxe'`
3. Run `:PluginInstall`

To update, just run `:PluginUpdate`

# Install with VAM

1. Install VAM using the [instructions][vam]
2. Add vaxe to the list of your activated bundles and re-source it:
    `call vam#ActivateAddons(['github:jdonaldson/vaxe'])`

# Install with vim-plug

1. Install vim-plug using the [instructions][vim-plug]
2. Add vaxe to your plugin list in `.vimrc` and re-source it:

    insert vaxe
    ```
    '' Haxe Plugin
    Plug 'jdonaldson/vaxe'
    ```
    between
    `call plug#begin('~/.vim/plugged')`

    and
    `call plug#end()`
3. Run `:PlugInstall`


[pathogen]:https://github.com/tpope/vim-pathogen

[vundle]:https://github.com/gmarik/vundle

[vam]:https://github.com/MarcWeber/vim-addon-manager

[vim-plug]:https://github.com/junegunn/vim-plug

# Compiling Haxe Projects with vaxe

## HXML File Support
Vaxe supports [hxml build files][haxe 2], which provide
all of the arguments for the compiler, similar to a  [make
file][wikipedia].

Vaxe will automatically try to determine the appropriate hxml file you are
using.  It will also let you easily override this with a specific file
(see vim docs for more details).

Vaxe will specify a custom
[makeprg][sourceforge] using
the given hxml file. The makeprg will cd to the directory containing the hxml,
execute the haxe compiler with the hxml file, and pipe output to stdout.

If vaxe has found your build file, you can just run the make command:

```viml
:make
```

Vaxe will also specify an
[errorformat][sourceforge 2],
so that errors and trace messages show up in the
[quickfix][sourceforge 3]
window.

## Lime Project Support
![Lime][imgur 2]

Vaxe supports [Lime][github 2]
workflows.  If a Lime project is found, Vaxe will use it for builds and
completions. You can specify a default target if you only work with one
platform.

## Flow Project Support

Vaxe supports [Flow][github 13]
workflows.  If a flow project is found, Vaxe will use it for builds and
completions. You can specify a default target if you only work with one
platform.

## Omni-completions

Vaxe provides an
[omnicompletion][sourceforge 4]
function that can use the haxe compiler in order to [display field
completions][haxe 3].  Visual Studio users will
recognize this as being similar to "intellisense".

You can trigger an omnicompletion (C-X C-O in Insert Mode) after the period at
the start of a field, submodule, or class access, or after the first
parentheses of a function invocation. See the [haxe
documentation][haxe 3] for more details.

### Active Targets: Dealing with --next

In some cases, an hxml file may specify multiple targets via a `--next`
directive.  Vaxe will use the first target it finds in order to generate
completions.  It is possible to specify a different target by
inserting a line like this into your hxml:

    # display completions

If Vaxe finds that line, it will use that target to generate completions and
perform other miscellaneous tasks.  The target that Vaxe uses is called the
"active" target here.

# HSS Support
Vaxe will also support the [hss][ncannasse] language,
with support for syntax highlighting, and compilation to css.

# Recommended Plugins/Additions/Config

Vaxe will work fine on its own, but it is designed to integrate cleanly with
a number of other bundles and plugins. Once again, it is recommended to use
pathogen, vundle, or vam to manage installation and updates.

## Misc Config
Vaxe provides a full completion specification for vim, which includes providing
function documentation via the [preview
window]( http://vimdoc.sourceforge.net/htmldoc/windows.html#preview-window ).
This can be turned off with:

```viml
set completeopt=menu
```

This will only use the menu, and not the preview window.  See ```:help
preview-window``` for more details.

Also, it is recommended that ```autowrite``` is set for haxe/hxml files.
Otherwise, completions will not be available as you type.  See ```help
autowrite``` for more details.  If autowrite is not set, Vaxe will return an
error message when completions are requested.  It is possible to turn this off,
see the help for g:vaxe_completion_require_autowrite.

## Airline

Airline ( [by Bailey Ling][github 3]) is a handy
[status line][sourceforge 5]
replacement.  I think it looks better, and provides a good deal more
functionality over a normal status line setting.  Airline support is provided by
default in vaxe.  Current support enables the display of the current hxml build
file.  The hxml name has an empty star if it's in default mode (☆ ), and a
filled star if it's in project mode (★ ).  You can disable all of this by
changing ```g:vaxe_enable_airline_defaults``` to 0.

Personally, I'm perfectly happy using airline, but If you're looking for support
for the original [powerline][github 4], you can
check [my repo][github 5].  The original
powerline version is more powerful, but much more difficult to install and
configure.  Copy the configuration information from my linepower repo instead of
the configuration information from the main powerline repo in order to enable
the vaxe plugin.

## Tags

Vim has great support for
[ctags][sourceforge 6], which are really
useful for navigating a large code base.

You'll need to define some patterns for ctags in order for it to work with
Haxe.  Put these lines in your `.ctags` file in your home directory:

```bash
--langdef=haxe
--langmap=haxe:.hx
--regex-haxe=/^[ \t]*((@:?[a-zA-Z]+)[ \t]+)*((inline|macro|override|private|public|static)[ \t]+)*function[ \t]+([A-Za-z0-9_]+)/\5/f,function/
--regex-haxe=/^[ \t]*((@:?[a-zA-Z]+)[ \t]+)*((inline|private|public|static)[ \t]+)*var[ \t]+([A-Za-z0-9_]+)/\5/v,variable/
--regex-haxe=/^[ \t]*package[ \t]*([A-Za-z0-9_\.]+)/\1/p,package/
--regex-haxe=/^[ \t]*((@:?[a-zA-Z]+)[ \t]+)*((extern|private)[ \t]+)?abstract[ \t]+([A-Za-z0-9_]+)[ \t]*[^\{]*/\5/a,abstract/
--regex-haxe=/^[ \t]*((@:?[a-zA-Z]+)[ \t]+)*((extern|private)[ \t]+)?class[ \t]+([A-Za-z0-9_]+)[ \t]*[^\{]*/\5/c,class/
--regex-haxe=/^[ \t]*((@:?[a-zA-Z]+)[ \t]+)*((extern|private)[ \t]+)?interface[ \t]+([A-Za-z0-9_]+)/\5/i,interface/
--regex-haxe=/^[ \t]*((private)[ \t]+)?typedef[ \t]+([A-Za-z0-9_]+)/\3/t,typedef/
--regex-haxe=/^[ \t]*enum[ \t]+([A-Za-z0-9_]+)/\1/e,enum/
```

Vaxe can generate a set of tags specific to the given build by running:
    vaxe#Ctags()
This will feed the paths used by the compiler into ctags.  Only the relevant
paths for the current target will be used.

Other utilities, like vaxe#ImportClass() can then use this tag information in
order to programmatically import classes.  E.g. calling vaxe#ImportClass on
this line:

```haxe
    var l = new haxe.ds.StringMap<Int>();
```

will generate:

```haxe
    import haxe.ds.StringMap;
    ...
    var l = new StringMap<Int>();
```

Keep in mind that jumping to files defined by ctags may jump to a location
outside of the current working directory.  If you want to keep the reference
to you current hxml file when doing so, it is advised that you select a project
mode hxml with ```:ProjectHxml```.

## Tagbar

Using the ctags lines above, the
[Tagbar][github 6] bundle can display a nice
overview of the classes, methods, and variables in your current haxe file.  You
do not need to call `vaxe#Ctags()` in order to use Tagbar, it works
automatically, but only for the current vaxe buffer.

## Syntastic

[Syntastic][github 7] is a popular bundle that
enables syntax errors to be displayed in a small gutter on the left of the
editor buffer.  I've patched Syntastic to use vaxe compilation information for
haxe and hss, including errors and traces.  All that is necessary is to install
the bundle.


## YouCompleteMe
[YouCompleteMe][github 8] (YCM) is a bundle that
provides completions for c-style languages.  However, it has the ability to
provide support for other languages as well, such as the completion methods
provided through vaxe.  Vaxe will let YCM use its completion methods
automatically, all that is required is that YCM (and its libraries) be compiled
and installed.

## Autocomplpop
[AutoComplPop][vim] is an
older vim script that automatically pops up a completion menu when an
omnicompletion is available.  It should offer good basic completions using
pure vimscript. Vaxe will let ACP use its completion methods automatically.

## Neocomplcache
[Neocomplcache][github 9] is a plugin for vim
that can manage virtually any type of completion (omni, keyword, file, etc). It
can be tricky to set up, so follow their documentation carefully.

# Acknowledgements
* [Marc Weber][github 14] : Most of the early work for the bundle was
based off of his [vim-haxe bundle][github 10].
Some of the hss functionality comes from his work on
[scss-vim][github 11].

* [Ganesh Gunasegaran][github 15]  : I based my hxml syntax file off of [his
version][motion-twin].

* [Laurence Taylor][github 16] : I based my ctags description of of [his mailing list post]
[haxe 4]

* [Luca Deltodesco][github 17] : The main Haxe syntax file is based
off of [his version][github 12].

* [Roger Duran][github 18] : Provided suport for
[flow][github 19]



[github]: https://raw.github.com/jdonaldson/vaxe/master/doc/vaxe.txt
[github 10]: https://github.com/MarcWeber/vim-haxe
[github 11]: https://github.com/cakebaker/scss-syntax.vim
[github 12]: https://gist.github.com/deltaluca/6330630
[github 13]: https://underscorediscovery.github.io/flow/
[github 14]: https://github.com/MarcWeber
[github 15]: https://github.com/itsgg
[github 16]: https://github.com/0b1kn00b
[github 17]: https://github.com/deltaluca
[github 18]: https://github.com/Roger
[github 19]: https://github.com/underscorediscovery/flow
[github 2]: https://github.com/openfl/lime
[github 3]: https://github.com/bling/vim-airline
[github 4]: https://github.com/Lokaltog/powerline
[github 5]: https://github.com/jdonaldson/linepower.vim
[github 6]: http://majutsushi.github.com/tagbar/
[github 7]: https://github.com/scrooloose/syntastic
[github 8]: https://github.com/Valloric/YouCompleteMe
[github 9]: https://github.com/Shougo/neocomplcache
[haxe]: http://www.haxe.org
[haxe 2]: http://haxe.org/doc/compiler
[haxe 3]: http://haxe.org/manual/completion
[haxe 4]: http://haxe.org/forum/thread/3395#nabble-td3443583
[imgur]: http://i.imgur.com/JFvze.png
[imgur 2]: http://i.imgur.com/rc8vLi2.png
[motion-twin]: http://lists.motion-twin.com/pipermail/haxe/2008-July/018220.html
[ncannasse]: http://ncannasse.fr/projects/hss
[sourceforge]: http://vimdoc.sourceforge.net/htmldoc/options.html#'makeprg'
[sourceforge 2]: http://vimdoc.sourceforge.net/htmldoc/options.html#'errorformat'
[sourceforge 3]: http://vimdoc.sourceforge.net/htmldoc/quickfix.html#quickfix
[sourceforge 4]: http://vimdoc.sourceforge.net/htmldoc/version7.html#new-omni-completion
[sourceforge 5]: http://vimdoc.sourceforge.net/htmldoc/windows.html#status-line
[sourceforge 6]: http://vimdoc.sourceforge.net/htmldoc/tagsrch.html
[vim]: http://www.vim.org/scripts/script.php?script_id=1879
[wikipedia]: http://en.wikipedia.org/wiki/Make_(software)
