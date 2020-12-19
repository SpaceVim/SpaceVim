# vim-airline-themes [![Build Status](https://travis-ci.org/vim-airline/vim-airline-themes.svg?branch=master)](https://travis-ci.org/vim-airline/vim-airline-themes) [![reviewdog](https://github.com/vim-airline/vim-airline-themes/workflows/reviewdog/badge.svg?branch=master&event=push)](https://github.com/vim-airline/vim-airline-themes/actions?query=workflow%3Areviewdog+event%3Apush+branch%3Amaster)

This is the official theme repository for [vim-airline][11]

# Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

| Plugin Manager | Install with... |
| -------------  | ------------- |
| [Pathogen][4]  | `git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes`<br/>Remember to run `:Helptags` to generate help tags |
| [NeoBundle][5] | `NeoBundle 'vim-airline/vim-airline-themes'` |
| [Vundle][6]    | `Plugin 'vim-airline/vim-airline-themes'` |
| [Plug][7]      | `Plug 'vim-airline/vim-airline-themes'` |
| [VAM][8]       | `call vam#ActivateAddons([ 'vim-airline-themes' ])` |
| [Dein][9]      | `call dein#add('vim-airline/vim-airline-themes')` |
| [minpac][10]   | `call minpac#add('vim-airline/vim-airline-themes')` |
| pack feature (native Vim 8 package feature)| `git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/pack/dist/start/vim-airline-themes`<br/>Remember to run `:helptags ~/.vim/pack/dist/start/vim-airline-themes/doc` to generate help tags |
| manual         | copy all of the files into your `~/.vim` directory |

# Using a Theme

Once installed, use  `:AirlineTheme <theme>` to set the theme, e.g. `:AirlineTheme simple`

To set in .vimrc, use `let g:airline_theme='<theme>'`, e.g. `let g:airline_theme='simple'`

**Note:** The command `:AirlineTheme` is only available, if you have also cloned and installed the main [vim-airline][11] repository.

# Contribution Guidelines

## New themes

* Pull requests for new themes are welcome.  Please be sure to include a screenshot.  You can paste an image into issue [#1](https://github.com/vim-airline/vim-airline-themes/issues/1), and then editing the post to reveal the uploaded image URL.  Please don't forgot to update the documentation.

## Modifications to existing themes

* Themes are subjective, so if you are going to make modifications to an existing theme, please expose a configurable variable to allow users to choose how the theme will react.

# Screenshots

Screenshots are in the process of being migrated here.  In the meantime you can find screenshots in the existing repository's [Wiki](https://github.com/vim-airline/vim-airline/wiki/Screenshots).

# Maintenance

If you are interested in becoming the official maintainer of this project, please contact [**@bling**][1], [**@chrisbra**][2], or [**@mhartington**][3].

# License

MIT License. Copyright (c) 2013-2020 Bailey Ling & Contributors.


[1]: https://github.com/bling
[2]: https://github.com/chrisbra
[3]: https://github.com/mhartington
[4]: https://github.com/tpope/vim-pathogen
[5]: https://github.com/Shougo/neobundle.vim
[6]: https://github.com/VundleVim/Vundle.vim
[7]: https://github.com/junegunn/vim-plug
[8]: https://github.com/MarcWeber/vim-addon-manager
[9]: https://github.com/Shougo/dein.vim
[10]: https://github.com/k-takata/minpac/
[11]: https://github.com/vim-airline/vim-airline
