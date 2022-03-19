# Vim SuperMan

Read Unix `man` pages faster than a speeding bullet!

Unix man pages by default open with the `less` pager. Getting them to open with
Vim can be a little bit of a pain, but in recent versions of Vim there's a
plugin (`$VIMRUNTIME/ftplugin/man.vim`) that makes this easy.

This is a simple Vim plugin and sh function that makes replacing `man` from the
command line a cinch.

## Installation

Use your favorite plugin manager. If you don't have one, I'd recommend Vundle,
though you should probably also take a look at Pathogen, as it's more common.

```bash
# if your ~/.vim folder isn't under source control:
git clone https://github.com/Z1MM32M4N/vim-superman ~/.vim/bundle/

# if your ~/.vim folder is under source control:
git submodule add https://github.com/Z1MM32M4N/vim-superman ~/.vim/bundle/
```

Then, add the following to your `.bashrc`, `.bash_profile`, `.zshrc`, or
whatever file you use to configure your shell:

```bash
vman() {
  vim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}
```

Close and reopen your terminal and you're set!

## Usage

This predominantly a command line tool. To open the man page for `vim`:

```bash
$ vman vim
```

![vman vim](http://blog.zimmerman.io/images/vim.1.png)

It's that simple. The underlying `:Man` command supports specifying a specific
section, so you could also do something like

```bash
$ vman 3 printf
```

To see the man page for the C `printf()` library call.

![vman 3 printf](http://blog.zimmerman.io/images/printf.3.png)

## FAQ

For more information, see the [associated blog post][blog].

### Jake, why not just call the bash function `man`?

The actual `man` command supports many more features than the Vim plugin does
(for a complete list, see `man(1)`). If you shadow the real `man` command,
things start to break, for example `apropos`, which uses `man` under the hood.

### When I install `vim-superman` it looks nothing like this!

There are a couple other plugins of mine featured prominently here, including
[Solarized Dark][sdark] for the color scheme and [Vim Airline][vairline] for the
statusbar. If you're curious about my whole setup, be sure to check out my
[dotfiles repository][dotfiles].

## License

MIT License. See LICENSE.


[blog]: http://blog.zimmerman.io/2014/12/20/vim-as-a-man-page-viewer/
[sdark]: https://github.com/altercation/vim-colors-solarized
[vairline]: https://github.com/bling/vim-airline
[dotfiles]: https://github.com/Z1MM32M4N/dotfiles

