# vim-chat

The chatting client for vim and neovim. This plugin is based on [SpaceVim](https://spacevim.org)'s API, and it is detached automatically.

![vim-chat](https://user-images.githubusercontent.com/13142418/166140007-d11d5e92-b32d-414f-b56b-64e28d03fd0e.png)

<!-- vim-markdown-toc GFM -->

- [Usage](#usage)
- [Feedback & Contribute](#feedback--contribute)

<!-- vim-markdown-toc -->

## Usage

If you are SpaceVim user, just load the [chat](https://spacevim.org/layers/chat/) layer.

```toml
[[layers]]
  name = "chat"
```

The default key binding in SpaceVim is `SPC a h`.

Of cause you can install this standalone plugin with vim-plug:

```
Plug 'wsdjeg/vim-chat'
```

and create your own key binding:

```
nnoremap <silent> <Leader>h :call chat#windows#open()<Cr>
```

## Feedback & Contribute

The development of vim-chat is in SpaceVim repository, including the SpaceVim api and [bundle/vim-chat](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/vim-chat)
