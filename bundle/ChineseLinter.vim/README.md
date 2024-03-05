# ChineseLinter.vim

> 中文文档语言规范检查工具

[![Build Status](https://travis-ci.org/wsdjeg/ChineseLinter.vim.svg?branch=master)](https://travis-ci.org/wsdjeg/ChineseLinter.vim)
[![codecov](https://codecov.io/gh/wsdjeg/ChineseLinter.vim/branch/master/graph/badge.svg)](https://codecov.io/gh/wsdjeg/ChineseLinter.vim)

## 使用说明

在编辑中文文档时，使用如下命令即可检查，错误信息将被展示在 `local list` 窗口。

```vim
:CheckChinese
```

## 错误代码

| 代码   | 描述                            |
| ------ | ------------------------------- |
| `E001` | 中文字符后存在英文标点          |
| `E002` | 中英文之间没有空格              |
| `E003` | 中文与数字之间没有空格          |
| `E004` | 中文标点两侧存在空格            |
| `E005` | 行尾含有空格                    |
| `E006` | 数字和单位之间存在空格          |
| `E007` | 数字使用了全角字符              |
| `E008` | 汉字之间存在空格                |
| `E009` | 中文标点重复                    |
| `E010` | 英文标点符号两侧的空格数量不对  |
| `E011` | 中英文之间空格数量多于 1 个     |
| `E012` | 中文和数字之间空格数量多于 1 个 |
| `E013` | 英文和数字之间没有空格          |
| `E014` | 英文和数字之间空格数量多于 1 个 |
| `E015` | 英文标点重复                    |
| `E016` | 连续的空行数量大于 2 行         |
| `E017` | 数字之间存在空格                |

## 配置

如果需要忽略某些错误，可以将错误代码加入选项：`g:chinese_linter_disabled_nr`

```vim
let g:chinese_linter_disabled_nr = ['E002', 'E005']
```

## 参考指南：

- [中文文案排版指北（简体中文版）](https://github.com/mzlogin/chinese-copywriting-guidelines)
