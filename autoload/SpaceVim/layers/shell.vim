""
" @section shell, layer-shell
" @parentsection layers
" SpaceVim uses deol.nvim for shell support in neovim and uses vimshell for
" vim. For more info, read |deol| and |vimshell|.
" @subsection variable
" default_shell
"

function! SpaceVim#layers#shell#plugins() abort
    let plugins = []
    if has('nvim')
        call add(plugins,['Shougo/deol.nvim'])
    else
        call add(plugins,['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}])
    endif
    return plugins
endfunction

function! SpaceVim#layers#shell#config()

    call SpaceVim#mapping#space#def('nnoremap', ["'"], 'call call('
                \ . string(function('s:open_default_shell')) . ', [])',
                \ 'open shell', 1)

endfunction

function! SpaceVim#layers#shell#set_variable(var)
   let s:default_shell = get(a:var, 'defaut_shell', 'terminal')
   let s:default_position = get(a:var, 'default_position', 'top')
   let s:default_height = get(a:var, 'default_height', 30)
endfunction


function! s:open_default_shell() abort
    let cmd = s:default_position ==# 'top' ?
                \ 'topleft split' :
                \ s:default_position ==# 'bottom' ?
                \ 'botright split' :
                \ s:default_position ==# 'right' ?
                \ 'rightbelow vsplit' : 'leftabove vsplit'
    exe cmd
    let lines = &lines * s:default_height / 100
    if lines < winheight(0) && (s:default_position ==# 'top' || s:default_position ==# 'bottom')
        exe 'resize ' . lines
    endif
endfunction
