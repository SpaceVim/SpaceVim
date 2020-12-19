### Expected behavior

<!-- What did you expect or want to happen? -->

### Steps to reproduce

<!--
For bugs please provide steps to reproduce the issue.

1. Please set `g:neomake_logfile`, e.g.
   `:let g:neomake_logfile = '/tmp/neomake.log'` first.
2. Look at the logfile for the generated output, which might help revealing the
   issue already.
   You can use `make tail_log` from Neomake's source directory
   for following the logfile in a separate terminal.
3. Please describe how you run Neomake: manually (how?), via automake config,
   or via some custom autocommand(s) (which?).

You can create a minimal vimrc like the following in Neomake's source directory, and use it with `(n)vim -u minimal.init.vim`:

```
set noloadplugins
let &runtimepath = expand('<sfile>:p:h') . ',' . &runtimepath
runtime plugin/neomake.vim

let g:neomake_logfile = '/tmp/neomake.log'
```

-->

### Output from :NeomakeInfo

<!--

1. Paste the output from `:NeomakeInfo` here.
   You can use `:NeomakeInfo!` (with a bang at the end) to copy it to
   your clipboard.

2. If relevant (it is always useful with bug reports) paste the contents of the
   logfile (via `g:neomake_logfile`).

-->
