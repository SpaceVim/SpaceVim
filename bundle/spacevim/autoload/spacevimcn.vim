"=============================================================================
" SpaceVim.vim --- Initialization and core files for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section 简介, intro
" @stylized spacevim
" @library
" @order intro options config layers usage api faq changelog
" SpaceVim 是一个社区驱动的模块化 Vim 配置，这一思想概念起源于 Spacemacs。

""
" @section 选项, options
" SpaceVim 使用 `~/.SpaceVim.d/init.toml` 作为默认的全局配置文件。所有的选项
" 都可以在该文件中进行设置，同时，`~/.SpaceVim.d/` 将被加入 Vim
" 的运行时（&rtp）内。因此，可以在该目录下创建私有的 Vim 脚本文件。SpaceVim
" 也支持项目的本地配置，在项目的根目录下，`.SpaceVim.d/init.toml`
" 即为默认的本地配置，`./SpaceVim./` 目录同样会被加入到 Vim
" 的运行时（&rtp）内。
"
" 以下即为一个配置示例：
" >
"   [options]
"     enable-guicolors = true
"     max-column = 120
" <

""
" @section default_indent, options-default_indent
" @parentsection options
" 设置默认的对齐具体，默认的值为 2。
" >
"   default_indent = 2
" <

""
" 设置默认的对齐具体，默认的值为 2。
" >
"   let g:spacevim_default_indent = 2
" <
let g:spacevim_default_indent          = 2

""
" 在输入模式下，使用空格替代 `<Tab>`
let g:spacevim_expand_tab              = 1

""
" @section relativenumber, options-relativenumber
" @parentsection options
" 启用/禁用相对行号，相对行号可以用于快速上下多行移动，默认已启用。
" >
"   relativenumber = true
" <

""
" 启用/禁用相对行号，相对行号可以用于快速上下多行移动，默认已启用。
let g:spacevim_relativenumber          = 1
