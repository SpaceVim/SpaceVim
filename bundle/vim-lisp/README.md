# vim-lisp

> Common Lisp dev environment for [SpaceVim](https://spacevim.org/layers/lang/lisp/)

# Dependencies

- Vim 8.0.0312+ with +channel, or Neovim 0.2.0+ with [ncat](https://nmap.org/ncat/)
- [ASDF](https://common-lisp.net/project/asdf/)
- [Quicklisp](https://www.quicklisp.org/beta/#installation)
- An Internet connection to install other dependencies from Quicklisp

recommands:

- [parinfer](https://github.com/bhurlow/vim-parinfer)
- [paredit](https://github.com/kovisoft/paredit) 

# Supported CL Implementations

The CL implementations listed below are supported. If you tried out Vlime with
an implementation not listed here, please let me know.

```
Implementation  Version  Notes
-----------------------------------------------------
ABCL            1.4.0    Supported by the vlime-patched backend
Allegro CL      10.0     Tested with the Express Edition
CLISP           2.49+    No multithreading support
ECL             16.1.3   No SLDB support
CCL             1.11
SBCL            1.3.13
LispWorks       6.1      Tested with the Personal Edition
```
