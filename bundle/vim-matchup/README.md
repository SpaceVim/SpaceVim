# vim match-up

match-up is a plugin that lets you highlight, navigate, and operate on
sets of matching text.  It extends vim's `%` key to language-specific
words instead of just single characters.

<img src='https://github.com/andymass/matchup.vim/wiki/images/teaser.jpg' width='300px' alt='and in this corner...'>

## Screenshot

<img src='https://raw.githubusercontent.com/wiki/andymass/vim-matchup/images/match-up-hl1.gif' width='450px'>

## Table of contents

  * [Overview](#overview)
  * [Installation](#installation)
  * [Features](#features)
  * [Options](#options)
  * [FAQ](#faq)
  * [Interoperability](#interoperability)
  * [Acknowledgments](#acknowledgments)
  * [Development](#development)

## Overview

match-up can be used as a drop-in replacement for the classic plugin [matchit.vim].
match-up aims to enhance all of matchit's features, fix a number of its
deficiencies and bugs, and add a few totally new features.  It also
replaces the standard plugin [matchparen], allowing all of matchit's words
to be highlighted along with the `matchpairs` (`(){}[]`).

[matchit.vim]: http://ftp.vim.org/pub/vim/runtime/macros/matchit.txt
[matchparen]: http://ftp.vim.org/pub/vim/runtime/doc/pi_paren.txt

See [detailed feature documentation](#detailed-feature-documentation) for
more information.  This plugin:

- Extends vim's `%` motion to language-specific words.  The following vim
  file type plugins currently provide support for match-up:

  > abaqus, ada, aspvbs, c, clojure, cobol, config, context, csc, csh,
  > dtd, dtrace, eiffel, eruby, falcon, fortran, framescript, haml,
  > hamster, hog, html, ishd, j, jsp, kconfig, liquid, lua, make, matlab,
  > mf, mp, ocaml, pascal, pdf, perl, php, plaintex, postscr, ruby, sh,
  > spec, sql, tex, vb, verilog, vhdl, vim, xhtml, xml, zimbu, zsh

  Note: match-up uses the same `b:match_words` as matchit.
- Adds motions `g%`, `[%`, `]%`, and `z%`.
- Combines these motions into convenient text objects `i%` and `a%`.
- Highlights symbols and words under the cursor which `%` can work on,
  and highlights matching symbols and words.  Now you can easily tell
  where `%` will jump to.

## Installation

If you use [vim-plug](https://github.com/junegunn/vim-plug), then add the following line to your vimrc file:

```vim
Plug 'andymass/vim-matchup'
```

and then use `:PlugInstall`.  Or, you can use any other plugin manager such as
[vundle](https://github.com/gmarik/vundle),
[dein](https://github.com/Shougo/dein.vim),
[neobundle](https://github.com/Shougo/neobundle.vim), or
[pathogen](https://github.com/tpope/vim-pathogen).

match-up should automatically disable matchit and matchparen, but if you
are still having trouble, try placing this near the top of your vimrc:

```vim
let g:loaded_matchit = 1
```

See [Interoperability](#interoperability) for more information about working
together with other plugins.

## Features

|         | feature                          | __match-up__   | matchit       | matchparen    |
| ------- | -------------------------------- | -------------- | ------------- | ------------- |
| ([a.1]) | jump between matching words      | :thumbsup:     | :thumbsup:    | :x:           |
| ([a.2]) | jump to open & close words       | :thumbsup:     | :thumbsup:    | :x:           |
| ([a.3]) | jump inside                      | :thumbsup:     | :x:           | :x:           |
| ([b.1]) | full set of text objects         | :thumbsup:     | :question:    | :x:           |
| ([c.1]) | highlight `()`, `[]`, & `{}`     | :thumbsup:     | :x:           | :thumbsup:    |
| ([c.2]) | highlight _all_ matches          | :thumbsup:     | :x:           | :x:           |
| ([c.3]) | display matches off-screen       | :thumbsup:     | :x:           | :x:           |
| ([d.1]) | modern, modular coding style     | :thumbsup:     | :x:           | :x:           |
| ([d.2]) | actively developed               | :thumbsup:     | :x:           | :x:           |

[a.1]: #a1-jump-between-matching-words
[a.2]: #a2-jump-to-open-and-close-words
[a.3]: #a3-jump-inside
[b.1]: #b1-full-set-of-text-objects
[c.1]: #c1-highlight---and-
[c.2]: #c2-highlight-all-matches
[c.3]: #c3-display-matches-off-screen
[d.1]: #development
[d.2]: #development
[inclusive]: #inclusive-and-exclusive-motions
[exclusive]: #inclusive-and-exclusive-motions

Legend: :thumbsup: supported. :construction: TODO, planned, or in progress.
:question: poorly implemented, broken, or uncertain.  :x: not possible.

### Detailed feature documentation

What do we mean by open, close, mid?  This depends on the specific file
type and is configured through the variable `b:match_words`.  Here are a
couple examples:

#### vim-script

```vim
if l:x == 1
  call one()
elseif l:x == 2
  call two()
else
  call three()
endif
```

For the vim-script language, match-up understands the words `if`,
`else`, `elseif`, `endif` and that they form a sequential construct.  The
"open" word is `if`, the "close" word is `endif`, and the "mid"
words are `else` and `elseif`.  The `if`/`endif` pair is called an
"open-to-close" block and the `if`/`else`, `else`/`elsif`, and
`elseif`/`endif` are called "any" blocks.

#### C, C++
```c
#if 0
#else
#endif

void some_func() {
    if (true) {
      one();
    } else if (false && false) {
      two();
    } else {
      three();
    }
}
```

Since in C and C++, blocks are delimited using braces (`{` & `}`),
match-up will recognize `{` as the open word and `}` as the close word.
It will ignore the `if` and `else if` because they are not defined in
vim's C file type plugin.

On the other hand, match-up will recognize the `#if`, `#else`, `#endif`
preprocessor directives.

#### (a.1) jump between matching words
  - `%` go forwards to next matching word.  If at a close word,
  cycle back to the corresponding open word.
  - `{count}%` forwards `{count}` times.  Requires
  `{count} <= g:matchup_motion_override_Npercent`.  For larger
  `{count}`, `{count}%` goes to the `{count}` percentage in the file.
  - `g%` go backwards to `[count]`th previous matching word.  If at an
  open word, cycle around to the corresponding close word.

#### (a.2) jump to open and close words
- `[%` go to `[count]`th previous outer open word.  Allows navigation
to the start of blocks surrounding the cursor.  This is similar to vim's
built-in `[(` and `[{` and is an [exclusive] motion.
- `]%` go to `[count]`th next surrounding close word.  This is an
[exclusive] motion.

#### (a.3) jump inside
- `z%` go to inside `[count]`th nearest inner contained block.  This
  is an [exclusive] motion when used with operators, except it eats
  whitespace.  For example, where `█` is the cursor position,

```vim
  █ call somefunction(param1, param2)
```
`dz%` produces
```vim
  param1, param2)
```
but in
```vim
  █ call somefunction(      param1, param2)
```
`dz%` also produces
```vim
  param1, param2)
```

#### (b.1) full set of text objects
- `i%` the inside of an any block
- `1i%` the inside of an open-to-close block
- `{count}i%` If count is greater than 1, the inside of the `{count}`th
  surrounding open-to-close block

- `a%` an any block.
- `1a%` an open-to-close block.  Includes mids but does not include open
  and close words.
- `{count}a%` if `{count}` is greater than 1, the `{count}`th surrounding
  open-to-close block.

See [here](#line-wise-operatortext-object-combinations)
for some examples and important special cases.

#### (c.1) highlight `()`, `[]`, and `{}`

match-up emulates vim's matchparen to highlight the symbols contained
in the `matchpairs` setting.

#### (c.2) highlight _all_ matches

To disable match highlighting at startup, use
`let g:matchup_matchparen_enabled = 0`
in your vimrc.
See [here](#module-matchparen) for more information and related
options.

You can enable highlighting on the fly using `:DoMatchParen`.
Likewise, you can disable highlighting at any time using
`:NoMatchParen`.

After start-up, is better to use `:NoMatchParen` and `:DoMatchParen`
to toggle highlighting globally than setting the global variable
since these commands make sure not to leave stale matches around.

#### (c.3) display matches off screen

If a open or close which would have been highlighted is on a line
positioned outside the current window, the match is shown in the
status line.  If both the open and close match are off-screen, the
close match is preferred.
(See the option `g:matchup_matchparen_offscreen`).

### Inclusive and exclusive motions

In vim, character motions following operators (such as `d` for delete
and `c` for change) are either _inclusive_ or _exclusive_.  This means
they either include the ending position or not.  Here, "ending position"
means the line and column closest to the end of the buffer of the region
swept over by the motion.  match-up is designed so that `d]%` inside a set
of parenthesis behaves exactly like `d])`, except generalized to words.

Put differently, _forward_ exclusive motions will not include the close
word.  In this example, where `█` is the cursor position,

```vim
if █x | continue | endif
```

pressing `d]%` will produce (cursor on the `e`)

```vim
if endif
```

To include the close word, use either `dv]%` or `vd]%`.  This is also
compatible with vim's `d])` and `d]}`.

Operators over _backward_ exclusive motions will instead exclude the
position the cursor was on before the operator was invoked.  For example,
in

```vim
  if █x | continue | endif
```
pressing `d[%` will produce

```vim
  █x | continue | endif
```
This is compatible with vim's `d[(` and `d[{`.

Unlike `]%`, `%` is an _inclusive_ motion.  As a special case for the
`d` (delete) operator, if `d%` leaves behind lines white-space, they will
be deleted also.  In effect, it will be operating line-wise.  As an
example, pressing `d%` will leave behind nothing.

```text
   █(

   )
```

To operate character-wise in this situation, use `dv%` or `vd%`.
This is vim compatible with the built-in `d%` on `matchpairs`.

### Line-wise operator/text-object combinations

Normally, the text objects `i%` and `a%` work character-wise.  However,
there are some special cases.  For certain operators combined with `i%`,
under certain conditions, match-up will effectively operate line-wise
instead.  For example, in
```vim
if condition
 █call one()
  call two()
endif
```
pressing `di%` will produce
```vim
if condition
endif
```
even though deleting ` condition` would be suggested by the object `i%`.
The intention is to make operators more useful in some cases.  The
following rules apply:
1. The operator must be listed in `g:matchup_text_obj_linewise_operators`.
  By default this is `d` and `y` (e.g., `di%` and `ya%`).
2. The outer block must span multiple lines.
3. The open and close delimiters must be more than one character long.  In
  particular, `di%` involving a `(`...`)` block will not be subject to
  these special rules.

To prevent this behavior for a particular operation, use `vi%d`.  Note that
special cases involving indentation still apply (like with |i)| etc).

To disable this entirely, remove the operator from the following variable,
```vim
let g:matchup_text_obj_linewise_operators = [ 'y' ]
```

Note: unlike vim's built-in `i)`, `ab`, etc., `i%` does not make an
existing visual mode character-wise.

A second special case involves `da%`.  In this example,
```vim
    if condition
     █call one()
      call two()
    endif
```
pressing `da%` will delete all four lines and leave no white-space.  This
is vim compatible with `da(`, `dab`, etc.

## Options

To disable the plugin entirely,
```vim
let g:matchup_enabled = 0
```
default: 1

To disable a particular module,
```vim
let g:matchup_matchparen_enabled = 0
let g:matchup_motion_enabled = 0
let g:matchup_text_obj_enabled = 0
```
defaults: 1

To enable the delete surrounding (`ds%`) and change surrounding (`cs%`)
maps,
```vim
let g:matchup_surround_enabled = 1
```
default: 0

To enable the experimental [transmute](#d1-parallel-transmutation)
module,
```vim
let g:matchup_transmute_enabled = 1
```
default: 0

To configure the number of lines to search in either direction while using
motions and text objects.  Does not apply to match highlighting
(see `g:matchup_matchparen_stopline` instead).
```vim
let g:matchup_delim_stopline = 1500
```
default: 1500

To disable matching within strings and comments,
```vim
let g:matchup_delim_noskips = 1   " recognize symbols within comments
let g:matchup_delim_noskips = 2   " don't recognize anything in comments
```
default: 0 (matching is enabled within strings and comments)

### Variables

match-up understands the following variables from matchit.
- `b:match_words`
- `b:match_skip`
- `b:match_ignorecase`

These are set in the respective ftplugin files.  They may not exist for
every file type.  To support a new file type, create a file
`after/ftplugin/{filetype}.vim` which sets them appropriately.

### Module matchparen

To disable match highlighting at startup, use
`let g:matchup_matchparen_enabled = 0` in your vimrc.
Note: vim's built-in plugin |pi_paren| plugin is also disabled.
The variable `g:loaded_matchparen` has no effect on match-up.

#### Customizing the highlighting colors

match-up uses the `MatchParen` highlighting group by default, which can be
configured.  For example,
```vim
:hi MatchParen ctermbg=blue guibg=lightblue cterm=italic gui=italic
```

You may want to put this inside a `ColorScheme` `autocmd` so it is
preserved after colorscheme changes:
```vim
augroup matchup_matchparen_highlight
  autocmd!
  autocmd ColorScheme * hi MatchParen guifg=red
augroup END
```

You can also highlight words differently than parentheses using the
`MatchWord` highlighting group.  You might do this if you find the
`MatchParen` style distracting for large blocks.
```vim
:hi MatchWord ctermfg=red guifg=blue cterm=underline gui=underline
```

There are also `MatchParenCur` and `MatchWordCur` which allow you to
configure the highlight separately for the match under the cursor.
```vim
:hi MatchParenCur cterm=underline gui=underline
:hi MatchWordCur cterm=underline gui=underline
```

The matchparen module can be disabled on a per-buffer basis (there is
no command for this).  By default, when disabling highlighting for a
particular buffer, the standard plugin matchparen will still be used
for that buffer.

```vim
let b:matchup_matchparen_enabled = 0
```
default: 1

If this module is disabled on a particular buffer, match-up will still
fall-back to the vim standard plugin matchparen, which will highlight
`matchpairs` such as `()`, `[]`, & `{}`.  To disable this,
```vim
let b:matchup_matchparen_fallback = 0
```
default: 1

A common usage of these options is to automatically disable
matchparen for particular file types;
```vim
augroup matchup_matchparen_disable_ft
  autocmd!
  autocmd FileType tex let [b:matchup_matchparen_fallback,
      \ b:matchup_matchparen_enabled] = [0, 0]
augroup END
```

Whether to highlight known words even if there is no match:
```vim
let g:matchup_matchparen_singleton = 1
```
default: 0

Dictionary controlling the behavior with off-screen matches.
```vim
let g:matchup_matchparen_offscreen = { ... }
```

default: `{'method': 'status'}`

If empty, this feature is disabled.  Else, it should contain the
following optional keys:

- `method`:
  Sets the method to use to show off-screen matches.
  Possible values are:

  `'status'` (default): Replace the |status-line| for off-screen matches.

  If a match is off of the screen, the line belonging to that match will be
  displayed syntax-highlighted in the status line along with the line number
  (if line numbers are enabled).  If the match is above the screen border,
  an additional Δ symbol will be shown to indicate that the matching line is
  really above the cursor line.

  `'status_manual'`: Compute the status-line but do not display it (future
  extension).

- `scrolloff`:
  When enabled, off-screen matches will not be shown in the statusline while
  the cursor is at the screen edge (respects the value of 'scrolloff').
  This is intended to prevent flickering while scrolling with j and k.

  default: 0.

The number of lines to search in either direction while highlighting
matches.  Set this conservatively since high values may cause performance
issues.
```vim
let g:matchup_matchparen_stopline = 400  " for match highlighting only
```

default: 400

#### highlighting timeouts

Adjust timeouts in milliseconds for matchparen highlighting:
```vim
let g:matchup_matchparen_timeout = 300
let g:matchup_matchparen_insert_timeout = 60
```
default: 300, 60

#### deferred highlighting

Deferred highlighting improves cursor movement performance (for example,
when using `hjkl`) by delaying highlighting for a short time and waiting
to see if the cursor continues moving;
```vim
let g:matchup_matchparen_deferred = 1
```
default: 0 (disabled)

Note: this feature is only available if your vim version has `timers` and
the function `timer_pause`, version 7.4.2180 and after.  For neovim, this
will only work in nvim-0.2.1 and after.

Adjust delays in milliseconds for deferred highlighting:
```vim
let g:matchup_matchparen_deferred_show_delay = 50
let g:matchup_matchparen_deferred_hide_delay = 700
```
default: 50, 700

Note: these delays cannot be changed dynamically and should be configured
before the plugin loads (e.g., in your vimrc).

#### highlight surrounding

To highlight the surrounding delimiters until the cursor moves, use a map
such as the following
```vim
nmap <silent> <F7> <plug>(matchup-hi-surround)
```
There is no default map for this feature.

You can also highlight surrounding delimiters always as the cursor moves.
```vim
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_hi_surround_always = 1
```
default: 0 (off)

This can be set on a per-buffer basis:
```vim
autocmd FileType tex let b:matchup_matchparen_hi_surround_always = 1
```

Note: this feature _requires_
[deferred highlighting](#deferred-highlighting) to be supported and
enabled.

### Module motion

In vim, `{count}%` goes to the `{count}` percentage in the file.
match-up overrides this motion for small `{count}` (by default, anything
less than 7).  To allow `{count}%` for `{count}` up to 11,
```vim
g:matchup_motion_override_Npercent = 11
```
To disable this feature, and restore vim's default `{count}%`,
```vim
g:matchup_motion_override_Npercent = 0
```
default: 6

If enabled, cursor will land on the end of mid and close words while
moving downwards (`%`/`]%`).  While moving upwards (`g%`, `[%`) the cursor
will land on the beginning.  To disable,
```vim
let g:matchup_motion_cursor_end = 0
```
default: 1

### Module text_obj

Modify the set of operators which may operate
[line-wise](#line-wise-operatortext-object-combinations)
```vim
let g:matchup_text_obj_linewise_operators' = ['d', 'y']
```
default: `['d', 'y']`

### Module transmute

_Options planned_.

## FAQ

- match-up doesn't work

  This plugin requires at least vim 7.4.  It should work in vim 7.4.898
  but at least vim 7.4.1689 is better.  I recommend using the most recent
  version of vim if possible.

  If you have issues, please tell me your vim version and error messages.
  Try updating vim and see if the problem persists.

- Why does jumping not work for construct X in language Y?

  Please open a new issue

- Highlighting is not correct for construct X

  match-up uses matchit's filetype-specific data, which may not give
  enough information to create proper highlights.  To fix this, you may
  need to modify `b:match_words`.

  For help, please open a new issue and be as specific as possible.

- I'm having performance problems

  match-up aims to be as fast as possible, but highlighting matching words
  can be intensive and may be slow on less powerful machines.  There are a
  few things you can try to improve performance:

  1. Update to a recent version of vim.  Newer versions are faster, more
  extensively tested, and better supported by match-up.
  2. Try [deferred highlighting](#deferred-highlighting), which delays
  highlighting until the cursor is stationary to improve cursor movement
  performance.
  3. Lower the [highlighting timeouts](#highlighting-timeouts).  Note that
  if highlighting takes longer than the timeout, highlighting will not be
  attempted again until the cursor moves.

  If are having any other performance issues, please open a new issue and
  report the output of `:MatchupShowTimes`.

- Why is there a weird entry on the status line?

  This is a feature which helps you see matches that are outside of the
  vim screen, similar to some IDEs.  If you wish to disable it, use

  ```vim
  let g:matchup_matchparen_offscreen = {}
  ```

- Matching does not work when lines are too far apart.

  The number of search lines is limited for performance reasons.  You may
  increase the limits with the following options:

  ```vim
  let g:matchup_delim_stopline      = 1500 " generally
  let g:matchup_matchparen_stopline = 400  " for match highlighting only
  ```
- The maps `1i%` and `1a%` are difficult to press.

  You may use the following maps `I%` and `A%` for convenience:

  ```vim
  function! s:matchup_convenience_maps()
    xnoremap <sid>(std-I) I
    xnoremap <sid>(std-A) A
    xmap <expr> I mode()=='<c-v>'?'<sid>(std-I)':(v:count?'':'1').'i'
    xmap <expr> A mode()=='<c-v>'?'<sid>(std-A)':(v:count?'':'1').'a'
    for l:v in ['', 'v', 'V', '<c-v>']
      execute 'omap <expr>' l:v.'I%' "(v:count?'':'1').'".l:v."i%'"
      execute 'omap <expr>' l:v.'A%' "(v:count?'':'1').'".l:v."a%'"
    endfor
  endfunction
  call s:matchup_convenience_maps()
  ```

  Note: this is not compatible with the plugin targets.vim.

- How can I contribute?

  Read the [contribution guidelines](CONTRIBUTING.md) and [issue
  template](ISSUE_TEMPLATE.md).  Be as precise and detailed as possible
  when submitting issues and pull requests.

## Interoperability

### vimtex, for LaTeX documents

By default, match-up will be disabled automatically for tex files when
[vimtex] is detected.  To enable match-up for tex files, use

```vim
let g:matchup_override_vimtex = 1
```

match-up's matching engine is more advanced than vimtex's and supports
middle delimiters such as `\middle|` and `\else`.  The exact set of
delimiters recognized may differ between the two plugins.  For example,
the mappings `da%` and `dad` will not always match, particularly if you
have customized vimtex's delimiters.

### Surroundings

match-up provides built-in support for [vim-surround]-style `ds%` and
`cs%` operations.  If vim-surround is installed, you can use vim-surround
replacements such as `cs%)`.  `%` cannot be used as a replacement.
An alternative plugin is [vim-sandwich], which allows more complex
surround replacement rules but is not currently supported.

[vim-surround]: https://github.com/tpope/vim-surround
[vim-sandwich]: https://github.com/machakann/vim-sandwich

### Auto-closing plugins

match-up does not provide auto-complete or auto-insertion of matches.
See for instance one of the following plugins for this;

- [vim-endwise](https://github.com/tpope/vim-endwise)
- [auto-pairs](https://github.com/jiangmiao/auto-pairs)
- [delimitMate](https://github.com/Raimondi/delimitMate)
- [splitjoin.vim](https://github.com/AndrewRadev/splitjoin.vim)
- [Pear Tree](https://github.com/tmsvg/pear-tree)

### Matchit

match-up tries to work around matchit.vim in all cases, but if
you experience problems, read the following.
matchit.vim should not be loaded.  If it is loaded, it should be loaded
after match-up (in this case, matchit.vim will be disabled).  Note that
some plugins, such as
[vim-sensible](https://github.com/tpope/vim-sensible),
load matchit.vim so these should also be initialized after match-up.

### Matchparen emulation

match-up loads [matchparen] if it is not already loaded.  Ordinarily, match-up
disables matchparen's highlighting and emulates it to highlight the symbol
contained in the 'matchpairs' option (by default `()`, `[]`, and `{}`).  If match-up
is disabled per-buffer using `b:matchup_matchparen_enabled`, match-up will use
matchparen instead of its own highlighting.  See `b:matchup_matchparen_fallback`
for more information.

## Acknowledgments

### Origins

match-up was originally based on [@lervag](https://github.com/lervag)'s
[vimtex].  The concept and style of this plugin and its development are
heavily influenced by vimtex. :beers:

[vimtex]: https://github.com/lervag/vimtex

### Other inspirations

- [matchit](http://ftp.vim.org/pub/vim/runtime/macros/matchit.txt)
- [matchparen](http://ftp.vim.org/pub/vim/runtime/doc/pi_paren.txt)
- [MatchTag](https://github.com/gregsexton/MatchTag)
- [MatchTagAlways](https://github.com/Valloric/MatchTagAlways)
- [vim-textobj-anyblock](https://github.com/rhysd/vim-textobj-anyblock)

## Development

### Reporting problems

This is a new plugin and there are likely to be some bugs.
Thorough issue reports are encouraged.  Please read the [issue
template](ISSUE_TEMPLATE.md) first.  Be as precise and detailed as
possible when submitting issues.

Feature requests are also welcome.

### Contributing

Please read the [contribution guidelines](CONTRIBUTING.md) before
contributing.

A major goal of this project is to keep a modern and modular code base.
Contributions are welcome!

