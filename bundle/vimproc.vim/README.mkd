# vimproc

[![Travis Build Status](https://travis-ci.org/Shougo/vimproc.vim.svg?branch=master)](https://travis-ci.org/Shougo/vimproc.vim)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/nutwxuj2poauar2b/branch/master?svg=true)](https://ci.appveyor.com/project/Shougo/vimproc-vim/branch/master)
[![GitHub release](https://img.shields.io/github/release/Shougo/vimproc.vim.svg)](https://github.com/Shougo/vimproc.vim/releases)

vimproc is a great asynchronous execution library for Vim.  It is a fork of
proc.vim by Yukihiro Nakadaira.  I added some features and fixed some bugs and
I'm maintaining it now.  Instead of an external shell (example: 'shell'),
vimproc uses an external DLL file.

Supported platforms:
* Windows 32/64bit (Compiled by MinGW or Visual Studio)
* macOS (10.5 or later)
* Linux
* Cygwin
* Solaris
* BSD (but cannot check)
* Android (experimental)

Not supported platforms:
* Other UNIX platforms

## Install

### Manual Install

* Clone this repo
* Build vimproc's native extensions (see Building for details)
* Copy `autoload/*`, `lib/*` and `plugin/*` files to your 'runtimepath'
  directory (see `:help runtimepath`).

### dein.vim

If you use [dein.vim](http://github.com/Shougo/dein.vim), you can
update and build vimproc automatically. This is the recommended package manager.

```vim
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
```

### Vim-Plug

If you use [vim-plug](https://github.com/junegunn/vim-plug), you can update and build vimproc automatically.

```vim
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
```
### Vundle

If you use [Vundle](https://github.com/VundleVim/Vundle.vim), add the following to your `.vimrc`.

```vim
Plugin 'Shougo/vimproc.vim'
```
Then compile the plugin manually where it was installed.

i.e. on Linux & Mac
```bash
$ cd ~/.vim/bundle/vimproc.vim && make
```

See [building](https://github.com/Shougo/vimproc.vim#building)

### NeoBundle

If you use [neobundle.vim](http://github.com/Shougo/neobundle.vim), you can
update and build vimproc automatically.

```vim
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
```

### Pathogen

vimproc uses a pathogen compatible structure, so it can be managed with
[pathogen](https://github.com/tpope/vim-pathogen), however you must remember to
compile after cloning the repo.

```sh
git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim
cd ~/.vim/bundle/vimproc.vim
make
```

## Building

Note: You must use GNU make to build vimproc.

You can install the dll using |VimProcInstall|. If you are having any trouble
or want to build manually then read on.

### Linux

    $ make

### macOS

Note: Users of macOS 10.15 (Catalina) cannot directly use this library with the system-provided vi. (SIP prevents binaries in the write-only `/usr/bin` directory from calling `dlopen` on unsigned libraries like `vimproc_mac.so`.) The simplest solution is to build or install another version of vi in a non-SIP protected location. For example, using homebrew, `brew install vim` (or `nvim`) will install an unrestricted executable in `/usr/local/bin`. (Don't forget to set up aliases or `$PATH` so that you don't accidentally invoke the system `vi`.)

    $ make

Note: If you want to build for multiple architectures, you can use `ARCHS` and `CC` variables.

Build for i386 and x86-64:

    $ make ARCHS='i386 x86_64'

### FreeBSD

    $ gmake

If you want to use BSD make, use the platform specific makefile:

    $ make -f make_bsd.mak

### Solaris

    $ gmake

Note: If you want to use Sun Compiler, you can use `SUNCC` variable.

    $ gmake SUNCC=cc

### Windows

Note: In Windows, using MinGW is recommended.
Note: If you have not "gcc" binary, you must change $CC value.

Windows using MinGW (32bit Vim):

    $ mingw32-make -f make_mingw32.mak

Windows using MinGW (If you want to use MinGW compiler in Cygwin):

    $ mingw32-make -f make_mingw32.mak CC=mingw32-gcc

Windows using MinGW (64bit Vim):

    $ mingw32-make -f make_mingw64.mak

Windows using Visual Studio (32bit/64bit Vim):

    $ nmake -f make_msvc.mak

You should run this from VS command prompt.
The architecture will be automatically detected, but you can also specify the
architecture explicitly. E.g.:

    32bit: nmake -f make_msvc.mak CPU=i386
    64bit: nmake -f make_msvc.mak CPU=AMD64

Cygwin:

    $ make

Note: The `vimproc_cygwin.dll` compiled in Cygwin won't work with Windows Vim.

### Windows Binaries

* [Kaoriya Vim](http://www.kaoriya.net/software/vim/) comes bundled with a precompiled version
for vimproc in Windows environment
* https://github.com/Shougo/vimproc.vim/releases
