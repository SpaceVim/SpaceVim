unstack.vim
=============

Parse stack traces or quickfix entries and open the result in vim splits!

Go from this:

<img src="http://i.imgur.com/DgXSAkq.png" width="800"/>

To this!

<img src="http://i.imgur.com/Q31wohX.png" width="800"/>

Version 0.5.0

No backwards compatability is guaranteed at this time.

Usage
-----
Visually select part/all of a stacktrace and hit `<leader>s`. If you want to use a different map key, put `let g:unstack_mapkey=<F10>` (replacing `<F10>` with the key of your choice, or an empty string to disable the mapping).

You can also copy a stack trace to your system clipboard (from any program) and run `:UnstackFromClipboard`.

Tmux users can copy a stack trace to the tmux paste buffer and call `:UnstackFromTmux`.

If this results in too many vsplits crowding the screen, consider taking a look at the [accordion](https://github.com/mattboehm/vim-accordion) plugin (shameless plug).

Signs
-----
By default, Unstack uses signs to highlight lines from stack traces in red. Signs are removed when the tab they were created in is closed. Sometimes a sign will appear to stick around after it's been removed until you switch tabs again. If you want to disable this feature add `set unstack_showsigns=0` to your .vimrc.

Portrait Layout
---------------
If you want the levels of the stack to open in hsplits (top to bottom instead of left to right), add the following to your .vimrc:

    let g:unstack_layout = "portrait"

Line Positioning
----------------
By default, the line will be centered on the screen. Alternatively, you can tell Unstack to move the line to the top or bottom of the screen by adding `let g:unstack_vertical_alignment = "top"' (or `"bottom"`) to your vimrc.

This will respect your `scrolloff` setting. If you wish unstack to have a different amount of padding than your scrolloff, you can use `let g:unstack_scrolloff = 5`. Combined with changing the alignment to top, this would put the highlighted line 5 lines from the top of the file.

Note that because vim doesn't let the first line of the file go below the top of the window, if the highlighted line is close to the start of the file, a vertical alignment of middle or bottom will not move the line all the way to the middle/bottom of the window.

Supported Languages
-------------------
Currently the following stack traces are supported:

* Python
* Ruby
* C#
* Perl
* Go
* Node.js
* Erlang (R15+)
* Valgrind
* GDB / LLDB

Is there another language you'd like supported? Open an issue with some sample stack traces or read on to learn how to add custom languages (pull requests welcome).

Customizing Languages
---------------------
Unstack can easily be extended to support additional stack trace formats. Check out `:help unstack_extractors` and `:help unstack_regex_extractors` for more information.

Feel free to submit pull requests or open issues for other stack trace languages.

License
-------
Copyright (c) Matthew Boehm.  Distributed under the same terms as Vim itself.
See `:help license`.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mattboehm/vim-unstack/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

