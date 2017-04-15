scriptencoding utf-8
" Enable nocompatible
if has('vim_starting')
    if &compatible
        set nocompatible
    endif
endif

" Fsep && Psep
if has('win16') || has('win32') || has('win64')
    let s:Psep = ';'
    let s:Fsep = '\'
else
    let s:Psep = ':'
    let s:Fsep = '/'
endif
"Use English for anything in vim
try
    if WINDOWS()
        silent exec 'lan mes en_US.UTF-8'
    elseif OSX()
        silent exec 'language en_US'
    else
        let s:uname = system('uname -s')
        if s:uname ==# "Darwin\n"
            " in mac-terminal
            silent exec 'language en_US'
        elseif s:uname ==# "SunOS\n"
            " in Sun-OS terminal
            silent exec 'lan en_US.UTF-8'
        else
            " in linux-terminal
            silent exec 'lan en_US.utf8'
        endif
    endif
catch /^Vim\%((\a\+)\)\=:E197/
    call SpaceVim#logger#error('Can not set language to en_US.utf8')
endtry

" try to set encoding to utf-8
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif

else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8
endif

" Enable 256 colors
if $COLORTERM ==# 'gnome-terminal'
    set t_Co=256
endif


