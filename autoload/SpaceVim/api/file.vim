let s:file = {}
let s:system = SpaceVim#api#import('system')

if s:system.isWindows
    let s:file['separator'] = '\'
else
    let s:file['separator'] = '/'
endif

function! SpaceVim#api#file#get() abort
    return deepcopy(s:file)
endfunction



