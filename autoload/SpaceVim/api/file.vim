let s:file = {}
let s:system = SpaceVim#api#import('system')

if s:system.isWindows
    let s:file['separator'] = '\'
    let s:file['pathSeparator'] = ';'
else
    let s:file['separator'] = '/'
    let s:file['pathSeparator'] = ':'
endif

function! SpaceVim#api#file#get() abort
    return deepcopy(s:file)
endfunction



