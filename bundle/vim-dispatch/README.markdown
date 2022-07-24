# dispatch.vim

Leverage the power of Vim's compiler plugins without being bound by
synchronicity.  Kick off builds and test suites using one of several
asynchronous adapters (including tmux, screen, iTerm, Windows, and a headless
mode), and when the job completes, errors will be loaded and parsed
automatically.

If that doesn't excite you, then perhaps [this video][teaser] will change your
mind.

[teaser]: http://vimeo.com/tpope/vim-dispatch-teaser

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/dispatch.git
    vim -u NONE -c "helptags dispatch/doc" -c q


## Usage

The core of Vim's compiler system is `:make`, a command similar to `:grep`
that runs a build tool and parses the resulting errors.  The default build
tool is of course `make`, but you can switch it (and the associated error
parser) with `:compiler`.  There are lots of built-in compilers, and they do
more than just compile things.  Plus you can make your own.

We'll start by looking at dispatch.vim's `:make` wrapper `:Make`, and then
move on to higher abstractions.

### Foreground builds

Kick off quick tasks with `:Make`.  What happens next depends on which adapter
takes charge.

* If you're in tmux, a small split will be opened at the bottom.
* On Windows, a minimized cmd.exe window is spawned.
* Otherwise, you get a plain old `:make` invocation.

When the task completes, the window closes, the errors are loaded and parsed,
and the quickfix window automatically opens.  At no point will your focus be
stolen.

### Background builds

Use `:Make!` for longer running tasks, like "run the entire test suite".

* If you're in tmux or GNU screen, a new window is created in the background.
* Windows still spawns a minimized cmd.exe window.
* Otherwise, you get a headless invocation.  You can't see it, but it's
  running in the background.

You won't be interrupted with a quickfix window for a background build.
Instead, open it at your leisure with `:Copen`.

You can also use `:Copen` on a build that's still running to retrieve and
parse any errors that have already happened.

### Compiler switching

As hinted earlier, it's easy to switch compilers.

    :compiler rubyunit
    :make test/models/user_test.rb

Wait, that's still twice as many commands as it needs to be.  Plus, it
requires you to make the leap from `testrb` (the executable) to `rubyunit`
(the compiler plugin).  The `:Dispatch` command looks for a compiler for an
executable and sets it up automatically.

    :Dispatch testrb test/models/user_test.rb

If no compiler plugin is found, `:Dispatch` simply captures all output.

    :Dispatch bundle install

As with `:make`, you can use `%` expansions for the current filename.

    :Dispatch rspec %

The `:Dispatch` command switches the compiler back afterwards, so you can pick
a primary compiler for `:Make`, and use `:Dispatch` for secondary concerns.

### Default dispatch

With no arguments, `:Dispatch` looks for a `b:dispatch` variable.  You
can set it interactively, or in an autocommand:

    autocmd FileType java let b:dispatch = 'javac %'

If no `b:dispatch` is found, it falls back to `:Make`.

`:Dispatch` makes a great map.  By default dispatch.vim provides `` `<CR>`` for
`:Dispatch<CR>`.  You can find all default maps under `:h dispatch-maps`.

### Focusing

Use `:FocusDispatch` (or just `:Focus`) to temporarily, globally override the
default dispatch:

    :Focus rake spec:models

Now every bare call to `:Dispatch` will call `:Dispatch rake spec:models`.
You'll be getting a lot of mileage out of that `:Dispatch` map.

Use `:Focus!` to reset back to the default.

### Spawning interactive processes

Sometimes you just want to kick off a process without any output capturing or
error parsing.  That's what `:Start` is for:

    :Start lein repl

Unlike `:Make`, the new window will be in focus, since the idea is that you
want to interact with it.  Use `:Start!` to launch it in the background.

### Plugin support

Using dispatch.vim from a plugin is a simple matter of checking for and using
`:Make` and `:Start` if they're available instead of `:make` and `:!`.  Your
favorite plugin already supports it, assuming your favorite plugin is
[rails.vim](https://github.com/tpope/vim-rails).

## FAQ

> How can I have `:Dispatch!` or `:Make!` open the quickfix window on
> completion?

Use `:Dispatch` or `:Make`.  The entire point of the `!` is to run in the
background without interrupting you.

> But that blocks Vim.

Then the adapter in use doesn't support foreground builds.  Adjust your setup.

## Self-Promotion

Like dispatch.vim?  Follow the repository on
[GitHub](https://github.com/tpope/vim-dispatch) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=4504).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
