scriptencoding utf8

let s:last_completion = []
function! neomake#cmd#complete_makers(ArgLead, CmdLine, ...) abort
    if a:CmdLine !~# '\s'
        " Just 'Neomake!' without following space.
        return [' ']
    endif

    " Filter only by name before non-breaking space.
    let filter_name = split(a:ArgLead, ' ', 1)[0]

    let file_mode = a:CmdLine =~# '\v^(Neomake|NeomakeFile)\s'

    let compl_info = [bufnr('%'), &filetype, a:CmdLine]
    if empty(&filetype)
        let maker_names = neomake#GetProjectMakers()
    else
        let maker_names = neomake#GetMakers(&filetype)

        " Prefer (only) makers for the current filetype.
        if file_mode
            if !empty(filter_name)
                call filter(maker_names, 'v:val[:len(filter_name)-1] ==# filter_name')
            endif
            if empty(maker_names) || s:last_completion == compl_info
                call extend(maker_names, neomake#GetProjectMakers())
            endif
        else
            call extend(maker_names, neomake#GetProjectMakers())
        endif
    endif

    " Only display executable makers.
    let makers = []
    for maker_name in maker_names
        try
            let maker = neomake#GetMaker(maker_name)
        catch /^Neomake: /
            let error = substitute(v:exception, '^Neomake: ', '', '').'.'
            call neomake#log#debug(printf('Could not get maker %s: %s',
                  \ maker_name, error))
            continue
        endtry
        if type(get(maker, 'exe', 0)) != type('') || executable(maker.exe)
            let makers += [[maker_name, maker]]
        endif
    endfor

    " Append maker.name if it differs, uses non-breaking-space.
    let r = []
    for [maker_name, maker] in makers
        if maker.name !=# maker_name
                    \ && (empty(a:ArgLead) || stridx(maker_name, a:ArgLead) != 0)
            let r += [printf('%s (%s)', maker_name, maker.name)]
        else
            let r += [maker_name]
        endif
    endfor

    let s:last_completion = compl_info
    if !empty(filter_name)
        call filter(r, 'v:val[:len(filter_name)-1] ==# filter_name')
    endif
    return r
endfunction

function! neomake#cmd#complete_jobs(...) abort
    return join(map(neomake#GetJobs(), "v:val.id.': '.v:val.maker.name"), "\n")
endfunction

function! s:is_neomake_list(list) abort
    if empty(a:list)
        return 0
    endif
    return a:list[0].text =~# ' nmcfg:{.\{-}}$'
endfunction

function! neomake#cmd#clean(file_mode) abort
    let buf = bufnr('%')
    call neomake#_clean_errors({
          \ 'file_mode': a:file_mode,
          \ 'bufnr': buf,
          \ })
    if a:file_mode
        if s:is_neomake_list(getloclist(0))
            call setloclist(0, [], 'r')
            lclose
        endif
        call neomake#signs#ResetFile(buf)
        call neomake#statusline#ResetCountsForBuf(buf)
    else
        if s:is_neomake_list(getqflist())
            call setqflist([], 'r')
            cclose
        endif
        call neomake#signs#ResetProject()
        call neomake#statusline#ResetCountsForProject()
    endif
    call neomake#EchoCurrentError(1)
    call neomake#virtualtext#handle_current_error()
endfunction

" Enable/disable/toggle commands.  {{{
function! s:handle_disabled_status(scope, disabled) abort
    if a:scope is# g:
        if a:disabled
            if exists('#neomake')
                autocmd! neomake
                augroup! neomake
            endif
            call neomake#configure#disable_automake()
            call neomake#virtualtext#handle_current_error()
        else
            call neomake#setup#setup_autocmds()
        endif
    elseif a:scope is# t:
        let buffers = neomake#compat#uniq(sort(tabpagebuflist()))
        if a:disabled
            for b in buffers
                call neomake#configure#disable_automake_for_buffer(b)
            endfor
        else
            for b in buffers
                call neomake#configure#enable_automake_for_buffer(b)
            endfor
        endif
    elseif a:scope is# b:
        let bufnr = bufnr('%')
        if a:disabled
            call neomake#configure#disable_automake_for_buffer(bufnr)
        else
            call neomake#configure#enable_automake_for_buffer(bufnr)
        endif
    endif
    call neomake#cmd#display_status()
    call neomake#configure#automake()
    call neomake#statusline#clear_cache()
endfunction

function! neomake#cmd#disable(scope) abort
    let old = get(get(a:scope, 'neomake', {}), 'disabled', -1)
    if old ==# 1
        return
    endif
    call neomake#config#set_dict(a:scope, 'neomake.disabled', 1)
    call s:handle_disabled_status(a:scope, 1)
endfunction

function! neomake#cmd#enable(scope) abort
    let old = get(get(a:scope, 'neomake', {}), 'disabled', -1)
    if old ==# 0
        return
    endif
    call neomake#config#set_dict(a:scope, 'neomake.disabled', 0)
    call s:handle_disabled_status(a:scope, 0)
endfunction

function! neomake#cmd#toggle(scope) abort
    let new = !get(get(a:scope, 'neomake', {}), 'disabled', 0)
    if new
        call neomake#config#set_dict(a:scope, 'neomake.disabled', 1)
        call s:handle_disabled_status(a:scope, 1)
    else
        call neomake#config#unset_dict(a:scope, 'neomake.disabled')
        call s:handle_disabled_status(a:scope, 0)
    endif
endfunction

function! neomake#cmd#display_status() abort
    let [disabled, source] = neomake#config#get_with_source('disabled', 0)
    let msg = 'Neomake is ' . (disabled ? 'disabled' : 'enabled')
    if source !=# 'default'
        let msg .= ' ('.source.')'
    endif

    " Add information from different scopes (if explicitly configured there).
    for [scope_name, scope] in [['buffer', b:], ['tab', t:], ['global', g:]]
        if scope_name ==# source
            continue
        endif
        let disabled = get(get(scope, 'neomake', {}), 'disabled', -1)
        if disabled != -1
            let msg .= printf(' [%s: %s]', scope_name, disabled ? 'disabled' : 'enabled')
        endif
    endfor
    let msg .= '.'

    echom msg
    call neomake#log#debug(msg)
endfunction
" }}}

" vim: ts=4 sw=4 et
