if version < 701 || exists('g:tagbar_proto_loaded')
    finish
endif
let g:tagbar_proto_loaded = 1


let cwd = expand('<sfile>:p:h:h')

if has("win16") || has("win32") || has("win64") || has("win95")
    let cnf = fnamemodify(cwd."\\ctags\\proto.cnf", ':p')
else
    let cnf = fnamemodify(cwd."/ctags/proto.cnf", ':p')
endif

let g:tagbar_type_proto = {
            \ 'ctagstype': 'proto',
            \ 'kinds': [
            \ 'm:message:0:1',
            \ 'e:enum:0:1',
            \ ],
            \ 'sro': '.',
            \ 'deffile': cnf,
            \}
