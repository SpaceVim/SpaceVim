" Vim compiler file
" Compiler:     haxe
" Maintainer:   Justin Donaldson <jdonaldson@gmail.com>



" select a build file if none is available
" this function sets the makeprg and errorformat
if !exists("b:vaxe_hxml")
    call vaxe#AutomaticHxml()
endif


