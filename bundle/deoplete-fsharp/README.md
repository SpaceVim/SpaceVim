[![MIT-LICENSE](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/callmekohei/deoplete-fsharp/blob/master/LICENSE)
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/fsugjp/public)


![alt text](./pic/sample.gif)

# deoplete-fsharp

[deoplete.nvim](https://github.com/Shougo/deoplete.nvim) source for F#  
Using [deopletefs](https://github.com/callmekohei/deopletefs) that is command-line interface to the [FSharp.Compiler.Service](https://github.com/fsharp/FSharp.Compiler.Service).  
It's useful to write a small code in F# script file ( .fsx ) .

## Requires
[mono](https://github.com/mono/mono)  ( >= Mono 5.4.0 )  
[fsharp](https://github.com/fsharp/fsharp)

## Install

Vim
```
// download
$ git clone --depth 1 https://github.com/Shougo/deoplete.nvim
$ git clone --depth 1 https://github.com/callmekohei/deoplete-fsharp
$ git clone --depth 1 https://github.com/roxma/nvim-yarp
$ git clone --depth 1 https://github.com/roxma/vim-hug-neovim-rpc

// install
$ cd ./deoplete-fsharp/
$ bash install.bash ( or install.cmd )

// set runtimepath
$ vim .vimrc
    set runtimepath+=/path/to/deoplete
    set runtimepath+=/path/to/deoplete-fsharp
    set runtimepath+=/path/to/nvim-yarp
    set runtimepath+=/path/to/vim-hug-neovim-rpc
```

NeoVim
```
// download
$ git clone --depth 1 https://github.com/Shougo/deoplete.nvim
$ git clone --depth 1 https://github.com/callmekohei/deoplete-fsharp

// install
$ cd ./deoplete-fsharp/
$ bash install.bash ( or install.cmd )

// set runtimepath
$ vim .vimrc
    set runtimepath+=/path/to/deoplete
    set runtimepath+=/path/to/deoplete-fsharp
```

Example of deoplete setting

```vim
" .vimrc ( or init.vim )

autocmd MyAutoCmd VimEnter *.fsx,*.fs call s:foo()
function s:foo() abort
  call deoplete#custom#option({
    \   'auto_refresh_delay' : 20
    \ , 'min_pattern_length' : 999
    \ , 'ignore_case'        : v:true
    \ , 'refresh_always'     : v:false
    \ , 'ignore_sources' : {'fsharp':['member']}
  \ })
  call deoplete#enable()
endfunction
```

---


# More info. for F# script file

## 01. Run

![alt text](./pic/quickrun2.png)

### Requires  
[vim-quickrun](https://github.com/thinca/vim-quickrun)  
[vimproc.vim](https://github.com/Shougo/vimproc.vim)

### Install and build
```
// download
$ git clone --depth 1 https://github.com/thinca/vim-quickrun
$ git clone --depth 1 https://github.com/Shougo/vimproc.vim

// build
$ cd ./vimproc/
$ make

// set runtimepath
$ vim .vimrc
    set runtimepath+=/path/to/vim-quickrun
    set runtimepath+=/path/to/vimproc.vim
```

### Example of vim-quickrun setting
```vim
" .vimrc ( or init.vim )
let g:quickrun_config = {}

let g:quickrun_config._ = {
    \  'runner'                          : 'vimproc'
    \ ,'runner/vimproc/updatetime'       : 60
    \ ,'hook/time/enable'                : 1
    \ ,'hook/time/format'                : "\n*** time : %g s ***"
    \ ,'hook/time/dest'                  : ''
    \ ,"outputter/buffer/split"          : 'vertical'
    \ ,'outputter/buffer/close_on_empty' : 1
\}

let g:quickrun_config.fsharp = {
    \  'command'                         : 'fsharpi --readline-'
    \ ,'runner'                          : 'concurrent_process'
    \ ,'runner/concurrent_process/load'  : '#load "%S";;'
    \ ,'runner/concurrent_process/prompt': '> '
\}
```
If you use window's Vim / Neovim
```
'command': 'mono "path\to\fsi.exe" --readline-'
```

### Run F# script file
```
: w
: QuickRun
```

## 02. Test

![alt text](./pic/persimmon2.png)

### Requires  
[Persimmon.Script](https://github.com/persimmon-projects/Persimmon.Script)

### Install ( requires [Paket](https://github.com/fsprojects/Paket) )
```
// make foo folder and move to foo folder
$ mkdir foo/
$ cd foo/

// install
$ paket init
$ vim paket.dependencies
    generate_load_scripts: true
    source https://www.nuget.org/api/v2
    nuget persimmon.script
$ paket install
```

### Test F# script file
```
: w
: QuickRun
```

### Sample code
```fsharp
#load "./.paket/load/net471/main.group.fsx"

open Persimmon
open UseTestNameByReflection
open System.Reflection

/// write your test code here.
let ``a unit test`` = test {
  do! assertEquals 1 2
}

/// print out test report.
new Persimmon.ScriptContext()
|> FSI.collectAndRun( fun _ -> Assembly.GetExecutingAssembly() )
```


## 03. Debug

![alt text](./pic/tigadebugger.gif)


### Requires
[sdb](https://github.com/mono/sdb)  
[sdbplg](https://github.com/callmekohei/sdbplg)  
[tigaDebugger](https://github.com/callmekohei/tigaDebugger)  

`tigaDebugger` is available with only Vim8 ( +python3, +terminal ).

### Install

sdb
```shell
// download
$ git clone --depth 1 https://github.com/mono/sdb

// clone the submodules
$ cd ./sdb/
$ git submodule update --init --recursive

// build
$ make
$ make install
```

sdbplg
```shell
// download
$ git clone --depth 1 https://github.com/callmekohei/sdbplg

// build 
$ cd ./sdbplg/
$ bash build.bash

// put `.sdb.rc` file on `$HOME`
$ cp .sdb.rc $HOME/

// set path
$ vim $HOME/.bash_profile
    export SDB_PATH=/PATH/TO/sdbplg/bin/
```

tigaDebugger
```shell
// download
$ git clone --depth 1 https://github.com/callmekohei/tigaDebugger
$ git clone --depth 1 https://github.com/roxma/nvim-yarp
$ git clone --depth 1 https://github.com/roxma/vim-hug-neovim-rpc

// install neovim plugins
$ pip3 install neovim

// set runtimepath
$ vim .vimrc
    set runtimepath+=/path/to/tigaDebugger
    set runtimepath+=/path/to/nvim-yarp
    set runtimepath+=/path/to/vim-hug-neovim-rpc
```

### Usage
```shell
// write fsharp code
$ vim foo.fsx

    let foo() =
        let mutable x = 1
        x <- 2
        x <- 3
        x

    foo ()
    |> stdout.WriteLine


// compile file
$ fsharpc -g --optimize- foo.fsx

// open file
$ vim foo.fsx

// start debug mode
: TigaSetDebugger sdb
: Tiga foo.exe

// set break point
: TigaCommand bp add at foo.fsx 3

// run
: TigaCommand r

// next
: TigaCommand n

// quit debug mode
: TigaQuit
```

### tigaDebugger Shortcut Keys

| Press         | To            |
| :------------ | :-------------|
| ctrl b        | Add or delete <b>B</span></b>reakpoint |
| ctrl d        | <b>D</b>elete all breakpoints |
| ctrl r        | <b>R</b>un |
| ctrl k        | <b>K</b>ill (Break) |
| ctrl p        | Re<b>p</b>lace watch variable |
| ctrl y        | Add watch variable |
| ctrl t        | Delete watch variable |
| ctrl n        | Step over ( <b>N</b>ext ) |
| ctrl i        | Step <b>I</b>n |
| ctrl u        | Step out ( <b>U</b>p ) | 
| ctrl c        | <b>C</b>ontinue |

