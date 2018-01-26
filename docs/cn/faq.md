### Where should I put my configration?

SpaceVim load custom configuration from `~/.SpaceVim.d/init.vim`.

1. E492: Not an editor command: ^M

The problem was git auto added ^M when cloning, solved by:

```sh
git config --global core.autocrlf input
```
