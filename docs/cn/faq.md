### 我应该把我的配置文件放到什么位置?

SpaceVim 默认从 ~/.SpaceVim.d/init.vim 中加载配置文件.

1. E492: 未编辑的命令: ^M

这个问题是git在克隆过程中,自动添加了^M, 可以通过下面的方法来解决:

```sh
git config --global core.autocrlf input
```
