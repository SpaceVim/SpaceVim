## vim-chat

chat in neovim and vim8


### Install

```viml
call dein#add('wsdjeg/vim-chat')
```

now you can chatting with me by `call chat#chatting#OpenMsgWin()`, insert `/help` for help message;

### 微信及QQ聊天

#### 依赖

- [mojo-webqq](https://github.com/sjdy521/Mojo-Webqq) 和 [mojo-weixin](https://github.com/sjdy521/Mojo-Weixin)：用于将QQ及微信协议转换成irc协议
- IRC 依赖模块: `cpanm -v Mojo::IRC::Server::Chinese`, 详见： [irc.md](https://github.com/sjdy521/Mojo-Webqq/blob/master/IRC.md)
- [irssi](https://irssi.org/): irc 聊天客户端
- [feh](https://feh.finalrewind.org/): 图片查看器，用于打开二维码
- [neovim](https://github.com/neovim/neovim)： vim8 的异步存在[问题](https://github.com/vim/vim/issues/1198)，无法实现相应功能，故只能在neovim下使用
- Linux: 目前仅在Linux下测试成功， Windows 下请直接使用QQ客户端

#### 启动

首先启动 QQ 服务器 `call chat#qq#start()`, 然后会自动弹出一个二维码，手机扫描下就可以登录了。neovim 默认使用 `Alt + x` 打开/关闭聊天窗口。

#### 效果图

![Markdown](http://i2.kiimg.com/1949/c18404d7afdc7f3a.gif)
