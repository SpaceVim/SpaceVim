[![Build Status](https://travis-ci.org/mhinz/vim-grepper.svg?branch=master)](https://travis-ci.org/mhinz/vim-grepper)

<br />
<br />

![vim-grepper](https://raw.githubusercontent.com/mhinz/vim-grepper/master/pictures/grepper-logo.png)

<br />
<br />

Use your **favorite grep tool**
([ag](https://github.com/ggreer/the_silver_searcher),
[ack](http://beyondgrep.com), [git grep](https://git-scm.com/docs/git-grep),
[ripgrep](https://github.com/BurntSushi/ripgrep),
[pt](https://github.com/monochromegane/the_platinum_searcher),
[sift](https://sift-tool.org),
[findstr](https://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/findstr.mspx),
grep) to start an **asynchronous search**. All matches will be put in a
**quickfix or location list**.

This plugin works with Vim and Neovim on Unix-like systems. It's mostly working
on Windows as well.

_Disclaimer: From my point of view it's feature-complete, so I won't add new
features or put much time into reviewing complex PRs._

---

- [Prompt](https://github.com/mhinz/vim-grepper/wiki/using-the-prompt): Use
  `:Grepper` to open a prompt, enter your query, optionally cycle through the
  list of tools, fire up the search.
- [Operator](https://github.com/mhinz/vim-grepper/wiki/using-the-operator): Use
  the current visual selection to pre-fill the prompt or start searching right
  away.
- [Commands](https://github.com/mhinz/vim-grepper/wiki/using-the-commands):
  `:Grepper` supports a wide range of flags which makes it extremely flexible.
  All supported tools come with their own command for convenience:
  `:GrepperGit`, `:GrepperAg`, and so on. They're all built atop of `:Grepper`.
- [Custom tools](https://github.com/mhinz/vim-grepper/wiki/Add-a-tool): Changing
  the behaviour of the default tools is very easy. And so is adding new tools.

---

_If you like [ack.vim](https://github.com/mileszs/ack.vim) and
[ag.vim](https://github.com/rking/ag.vim), you will love vim-grepper._

## Documentation

This README is only the tip of the iceberg. Make sure to read `:h grepper` and
[the wiki](https://github.com/mhinz/vim-grepper/wiki) to learn about every
feature.

Example configurations be be found
[here](https://github.com/mhinz/vim-grepper/wiki/example-configurations-and-mappings).

_The truth is out there._

## Installation

Use your [favorite plugin
manager](https://github.com/mhinz/vim-galore#managing-plugins), e.g.
[vim-plug](https://github.com/junegunn/vim-plug):

    Plug 'mhinz/vim-grepper'

If you prefer lazy loading:

    Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

## Demo

General usage:

![vim-grepper](https://github.com/mhinz/vim-grepper/blob/master/pictures/grepper-demo.gif)

Grepping only files currently loaded in Vim:

![vim-grepper](https://github.com/mhinz/vim-grepper/blob/master/pictures/grepper-demo2.gif)

## Feedback

If you like this plugin, star it! It's a great way of getting feedback. The same
goes for reporting issues or feature requests.

Contact: [Twitter](https://twitter.com/_mhinz_)
