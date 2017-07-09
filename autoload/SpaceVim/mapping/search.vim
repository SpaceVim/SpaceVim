let s:search_tools = {}
let s:search_tools.a = {}
let s:search_tools.a.command = 'ag'
let s:search_tools.a.default_opts =
            \ '-i --vimgrep --hidden --ignore ' .
            \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let s:search_tools.a.recursive_opt = ''

let s:search_tools.t = {}
let s:search_tools.t.command = 'pt'
let s:search_tools.t.default_opts = '--nogroup --nocolor'
let s:search_tools.t.recursive_opt = ''

let s:search_tools.r = {}
let s:search_tools.r.command = 'rg'
let s:search_tools.r.default_opts = '--hidden --no-heading --vimgrep -S'
let s:search_tools.r.recursive_opt = ''

let s:search_tools.k = {}
let s:search_tools.k.command = 'ack'
let s:search_tools.k.default_opts = '-i --no-heading --no-color -k -H'
let s:search_tools.k.recursive_opt = ''

let s:search_tools.g = {}
let s:search_tools.g.command = 'grep'
let s:search_tools.g.default_opts = '-inH'
let s:search_tools.g.recursive_opt = ''

function! SpaceVim#mapping#search#grep(key, scope)
    let save_cmd = g:unite_source_grep_command
    let save_opt = g:unite_source_grep_default_opts
    let save_ropt = g:unite_source_grep_recursive_opt
    let g:unite_source_grep_command = s:search_tools[a:key]['command']
    let g:unite_source_grep_default_opts = s:search_tools[a:key]['default_opts']
    let g:unite_source_grep_recursive_opt = s:search_tools[a:key]['recursive_opt']
    if a:scope ==# 'b'
        exe 'Unite grep:$buffers'
    elseif a:scope ==# 'B'
        execute 'Unite grep:$buffers::' . expand('<cword>') . '  -start-insert'
    elseif a:scope ==# 'p'
        exe 'Unite grep:.'
    elseif a:scope ==# 'P'
        execute 'Unite grep:.::' . expand('<cword>') . '  -start-insert'
    elseif a:scope ==# 'f'
        exe 'Unite grep'
    elseif a:scope ==# 'F'
        execute 'Unite grep:::' . expand('<cword>') . '  -start-insert'
    endif
    let g:unite_source_grep_command = save_cmd
    let g:unite_source_grep_default_opts = save_opt
    let g:unite_source_grep_recursive_opt = save_ropt
endfunction

function! SpaceVim#mapping#search#default_tool()
    if has_key(s:search_tools, 'default_exe')
        return s:search_tools.default_exe
    else
        for t in g:spacevim_search_tools
            if executable(t)
                let s:search_tools.default_exe = t
                return t
            endif
        endfor
    endif
endfunction
