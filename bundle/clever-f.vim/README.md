clever-[f][].vim
================
[![Build Status][]][CI]
[![Coverage Status][]][Codecov]

clever-f.vim extends `f`, `F`, `t` and `T` mappings for more convenience. Instead of `;`, `f` is available
to repeat after you type `f{char}` or `F{char}`. `F` after `f{char}` and `F{char}` is also available
to undo a jump. `t{char}` and `T{char}` are ditto. This extension makes a repeat easier and makes you
forget the existence of `;`. You can use `;` for other key mapping. In addition, this extension provides
many convenient features like target character highlighting, smart case matching and so on. 

If you want to reset the searching character without moving cursor, map `<Plug>(clever-f-reset)` to your
favorite key.

Lastly, you can customize the behavior of the mappings and features.

### [Try Online Demo][] using [vim.js][]


## USAGE

![Screen shot](https://raw.githubusercontent.com/rhysd/screenshots/master/clever-f.vim/cleverf_main.gif)

I'll show some examples of usage. `_` is the place of cursor, `->` is a move of cursor, alphabets above
`->` is input by keyboard. Note that this is a part of clever-f.vim's features.

### __`f`__

    input:       fh         f         f      e         fo         f
    move :  _---------->_------>_---------->_->_---------------->_->_
    input:                            F                            F
    move :                        _<-----------------------------_<-_
    text :  hoge        huga    hoo         hugu                ponyo

![f screencast](https://raw.githubusercontent.com/rhysd/screenshots/master/clever-f.vim/cleverf_1.gif)


### __`F`__

    input:        f        Fh       b     f                         Fo
    move :  _<----------_<------_<-_<-----------------------------_<-_
    input:        F        F          F
    move :  _---------->_------>_----------->_
    text :  hoge        huga    huyo         hugu                ponyo

![F screencast](https://raw.githubusercontent.com/rhysd/screenshots/master/clever-f.vim/cleverf_2.gif)


### __`t`__

    input:       th         t         t      e         to         t
    move :  _--------->_------>_---------->_-->_--------------->_->_
    input:                            T                            T
    move :                         _<-----------------------------__
    text :  hoge        huga    hoo         hugu                ponyo

![t screencast](https://raw.githubusercontent.com/rhysd/screenshots/master/clever-f.vim/cleverf_3.gif)


## CUSTOMIZE

### Search a character only in current line

`g:clever_f_across_no_line` controls to search a character across multi lines or not. Please set it
to `1` in your vimrc to search a character only in current line.

### Ignore case

`g:clever_f_ignore_case` controls whether or not searches are case-insensitive. If you want searches
to be case-insensitive, set it to `1` in your vimrc.

### Smart case

`g:clever_f_smart_case` controls whether searches are smart case or not. If you type a lower case character, the case will be ignored however if you type an upper case character it will only search for upper case characters. Please set it to `1` in your vimrc to enable searching by smart case.

### Target character highlighting in current line

clever-f.vim highlights the target character you input in current line. The highlight is cleared
automatically when the search ends. If you want to change the highlight group, set your favorite highlight
group to `g:clever_f_mark_char_color`.

Below is an example using `ta` in description of clever-f.vim.

![highlight example](https://raw.githubusercontent.com/rhysd/screenshots/master/clever-f.vim/cleverf_4.gif)

Here, `ta` searches `a` forward then matches the character before `a` and `Ta` searches `a` backward
then matches the character after `a`. You can see the highlighted target is dynamically changed following
the cursor's direction.

### Timeout

You can specify the timeout for `f`, `F`, `t` and `T` mappings. If the interval of these mappings
is greater than the one you specified, clever-f.vim resets its state to make you input a new character.
This feature is disabled by default. If you want to use this feature, set `g:clever_f_timeout_ms`
to proper value.

### Repeat last input

`<CR>` is easy to type but usually it isn't input as the target character of search. So by default,
when you input `<CR>` as `{char}`, the previous input is used instead of `<CR>`. For example, when
you previously input `fa` and then input `f<CR>`, `a` will be used as input instead of `<CR>`.
You can specify characters to use previous input by setting `g:clever_f_repeat_last_char_inputs`.
Adding `<Tab>` may be handy.

### Migemo support

In Japanese environment, it is convenient that `fa` matches `あ` in some cases. Originally, this
feature is provided by [migemo](http://0xcc.net/migemo/). clever-f can search multibyte Japanese
character with `f`, 'F', 't' and 'T' key mappings. A cmigemo package is **NOT** required because clever-f
includes regex patterns generated by migemo. Set `clever_f_use_migemo` to `1` to get migemo support.

### Fix a direction of search

If you always want to search forward with `f` and always want to search backward with `F`,
set `g:clever_f_fix_key_direction` to `1`.

    input:        F        Fh     b     F                         Fo
    move :  _<----------_<------_<-_<-----------------------------_<-_
    input:        f        f          f
    move :  _---------->_------>_----------->_
    text :  hoge        huga    huyo         hugu                ponyo

### Show prompt

If you want to show a prompt when you input a character for clever-f, set `g:clever_f_show_prompt`
to `1`. The prompt is disposed after a character is input.

### Match all symbols with one char

Many symbol (`{`, `(`, `"`, and so on) keys are hard to press. If you want to match `;` key to all symbols,
you can use `g:clever_f_chars_match_any_signs`. If you set it to `';'`, `f;` matches all symbols.

    input:   f;   f       f      f f       f       f
    move :  _-->_--->_--------->_>_>_------------>_>_
    text :  hoge.huga( autoloads: %w{ aaa bbb ccc } )

### Keeping the functionality of `;` and `,` via mappings

If you are used to using `;` and `,` for forward and backward searching, but still want these to work
the same way with clever-f, you can simply remap `;`and `,` to use this plugin:

```
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
```

## LICENSE

Distributed under MIT License. See `doc/clever_f.txt`


[f]: https://github.com/vim/vim/blob/0d76683e094c6cac2e879601aff3acf1163cbe0b/runtime/doc/motion.txt#L254-L262
[Build Status]: https://github.com/rhysd/clever-f.vim/workflows/CI/badge.svg?branch=master&event=push
[CI]: https://github.com/rhysd/clever-f.vim/actions?query=workflow%3ACI+branch%3Amaster
[Coverage Status]: https://codecov.io/gh/rhysd/clever-f.vim/branch/master/graph/badge.svg
[Codecov]: https://codecov.io/gh/rhysd/clever-f.vim
[Try Online Demo]: http://rhysd.github.io/clever-f.vim/
[vim.js]: https://github.com/coolwanglu/vim.js/
