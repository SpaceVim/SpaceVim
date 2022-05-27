## Beginner's Guide

phpcomplete.vim complements Vim's built-in omnicomplete functions. It relies on Vim's access to a `tags` file.

A `tags` file is a metadata file that can describe your code and the relationships between its elements, like Classes, Interfaces, Methods, etc.

phpcomplete.vim does **not** generate that file for you, so before using phpcomplete.vim, you'll need to generate it for your PHP project on your own.

### Generating a `tags` file

First, you'll need a program that can parse your PHP project and output a tags file. There are a few choices for doing so and they're outlined here: [Getting Better Tags](https://github.com/shawncplus/phpcomplete.vim/wiki/Getting-better-tags).

Once you have a `ctags` or `phpctags` program installed, make sure it's in your `$PATH` ([relevant StackExchange post](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path)).

The rest of this guide will assume you're using `phpctags`; if you're using something else, substitute the `phpctags` command with `ctags`.

Now we're ready to generate our tags file. First, change directories to your project root, then you'll run the command to generate a `tags` file. Like so:

```sh
$ cd /path/to/your/project
$ phpctags -R
```

This should output a `tags` file in the current directory.

You may want to add that file to your `.gitignore`. If you're working with non-Vim users, you can try adding it to `.git/info/exclude` so as not to pollute your project's `.gitignore` with your Vim-specific rules.

**Note**: If you're using `phpctags` and your project is large enough, `phpctags` might run out of memory. If that happens, it will silently fail by not outputting a `tags` file at all. You can try replacing the command above with: `phpctags --memory=-1 -R` to give `phpctags` unlimited memory.

### Making sure Vim can read your `tags` file

By default, Vim will look for your `tags` file in your `cwd` under the following files: `./tags,tags`, this default behaviour is usually good enough. 
The file lookup is controlled by the option `tags`. Some plugins like fugitive will add your project's `.git/tags` file to this list. If for some reason you need to add an another path you can do it like this:

```
set tags+=./some/path/to/extra/tags
```
See more under `:help 'tags'`

### Getting completions

Once you have everything set up above, you can finally get completions! The command to get Vim to open up suggestions is `<ctrl-x><ctrl-o>`.

That means hitting the <kbd>CTRL</kbd>+<kbd>x</kbd> keys at the same time, then hitting <kbd>CTRL</kbd>+<kbd>o</kbd> right after.

If there are multiple suggestions, you can use <kbd>CTRL</kbd>+<kbd>n</kbd> to scroll down the list and <kbd>CTRL</kbd>+<kbd>p</kbd> to scroll up the list.

Hitting <kbd>TAB</kbd> will complete the word under your cursor with your selection.

**That's it, enjoy!**
