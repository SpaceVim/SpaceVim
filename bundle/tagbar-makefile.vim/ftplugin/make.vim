if version < 701 || exists('g:tagbar_makefile_loaded')
    finish
endif
let g:tagbar_makefile_loaded = 1

let cwd = expand('<sfile>:p:h:h')

if has("win16") || has("win32") || has("win64") || has("win95")
    let cnf = fnamemodify(cwd."\\ctags\\makefile.cnf", ':p')
else
    let cnf = fnamemodify(cwd."/ctags/makefile.cnf", ':p')
endif

if exists(":Tagbar")
    let g:tagbar_type_make = {
                \ 'kinds':[
                \ 'm:macros',
                \ 't:targets'
                \ ],
                \ 'deffile': cnf,
                \}
endif
