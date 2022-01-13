" http://blog.csdn.net/thundercumt/article/details/51742115
" http://blog.csdn.net/shanghaojiabohetang/article/details/74486196

" LOGIN
" LIST
" SELECT

let s:PASSWORD = SpaceVim#api#import('password')
let s:cmd_prefix = s:PASSWORD.generate_simple(5)
function! mail#command#login(username, password)
    return join([s:cmd_prefix, 'LOGIN', a:username, a:password], ' ')
endfunction

function! mail#command#list(dir, patten)
    return join([s:cmd_prefix, 'LIST', a:dir, a:patten], ' ')
endfunction

" msg should be a list like ['MESSAGES', 'UNSEEN', 'RECENT']
function! mail#command#status(dir, msg)

endfunction

function! mail#command#select(dir)
    return join([s:cmd_prefix, 'SELECT', a:dir], ' ')
endfunction


" A FETCH 1:4 BODY[HEADER.FIELDS ("DATA" "FROM" "SUBJECT")]
function! mail#command#fetch(id, data)
    return join([s:cmd_prefix, 'FETCH', a:id, a:data], ' ')
endfunction

function! mail#command#noop()
    return join([s:cmd_prefix, 'NOOP'], ' ')
endfunction
