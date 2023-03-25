Oh shit! Lock up your daughters it's ...

```
███████╗██╗     ██╗   ██╗███╗   ███╗██╗      ██████╗ ██████╗ ██████╗ 
██╔════╝██║     ██║   ██║████╗ ████║██║     ██╔═══██╗██╔══██╗██╔══██╗
███████╗██║     ██║   ██║██╔████╔██║██║     ██║   ██║██████╔╝██║  ██║
╚════██║██║     ██║   ██║██║╚██╔╝██║██║     ██║   ██║██╔══██╗██║  ██║
███████║███████╗╚██████╔╝██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║██████╔╝
╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ 
```

Introduction
============

Slumlord is built atop the wang-hardeningly awesome [plantuml](http://plantuml.com).
It gives you a "live preview" of your UML diagrams when you save.

![Demo](https://github.com/scrooloose/vim-slumlord/raw/master/_assets/demo.gif)


Installation
============

First you need Java installed.

Then, install this plugin with your favourite vim plugin manager.

For [vundle](https://github.com/VundleVim/Vundle.vim), just stick this in your
vimrc and smoke it:

```
Plugin 'scrooloose/vim-slumlord'
```

Then run `:Vundle install`

I also recommend installing the
[plantuml-syntax](https://github.com/aklt/plantuml-syntax) plugin as Slumlord
uses this for its syntax file.

```
Plugin 'aklt/plantuml-syntax'
```

Usage
=====

Edit a `.uml` file and enter some plantuml code. When you save it, a preview
will be forcefully inserted/updated at the top of your file!

Note: I have only used this for sequence diagrams - the ASCII output of
plantuml seems to be less than stellar for other diagram types.
