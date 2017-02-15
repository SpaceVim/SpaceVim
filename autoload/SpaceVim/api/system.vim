let s:system = {}

let s:system['isWindows'] = has('win16') || has('win32') || has('win64')

let s:system['isLinux'] = has('unix') && !has('macunix') && !has('win32unix')

let s:system['isOSX'] = has('macunix')


function! SpaceVim#api#system#get() abort
    return deepcopy(s:system)
endfunction
