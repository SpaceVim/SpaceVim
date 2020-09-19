" vim: ts=4 sw=4 et
scriptencoding utf-8

if !has('signs')
    call neomake#log#error('Trying to load signs.vim, without +signs.')
    finish
endif

let s:base_sign_id = 5000
let s:placed_signs = {'project': {}, 'file': {}}
let s:last_placed_signs = {'project': {}, 'file': {}}

exe 'sign define neomake_invisible'

" Reset signs placed by a :Neomake! call
function! neomake#signs#ResetProject() abort
    for buf in keys(s:placed_signs.project)
        call neomake#signs#Reset(buf, 'project')
        call neomake#signs#CleanOldSigns(buf, 'project')
    endfor
endfunction

" Reset signs placed by a :Neomake call in a buffer
function! neomake#signs#ResetFile(bufnr) abort
    call neomake#signs#Reset(a:bufnr, 'file')
    call neomake#signs#CleanOldSigns(a:bufnr, 'file')
endfunction

function! neomake#signs#Reset(bufnr, type) abort
    if has_key(s:placed_signs[a:type], a:bufnr)
        " Clean any lingering, already retired signs.
        call neomake#signs#CleanOldSigns(a:bufnr, a:type)
        let s:last_placed_signs[a:type][a:bufnr] = s:placed_signs[a:type][a:bufnr]
        unlet s:placed_signs[a:type][a:bufnr]
    endif
endfunction

let s:sign_order = {'neomake_file_err': 0, 'neomake_file_warn': 1,
                 \  'neomake_file_info': 2, 'neomake_file_msg': 3,
                 \  'neomake_project_err': 4, 'neomake_project_warn': 5,
                 \  'neomake_project_info': 6, 'neomake_project_msg': 7}

" Get the defined signs for a:bufnr.
" It returns a dictionary with line numbers as keys.
function! neomake#signs#by_lnum(bufnr) abort
    let bufnr = a:bufnr + 0
    if !bufexists(bufnr)
        return {}
    endif

    let r = {}
    if exists('*sign_getplaced')  " patch-8.1.0614
        for sign in sign_getplaced(bufnr)[0].signs
            if has_key(r, sign.lnum)
                call add(r[sign.lnum], [sign.id, sign.name])
            else
                let r[sign.lnum] = [[sign.id, sign.name]]
            endif
        endfor
        return r
    endif

    let signs_output = split(neomake#utils#redir('sign place buffer='.a:bufnr), '\n')

    " Originally via ALE.
    " Matches output like :
    " line=4  id=1  name=neomake_err
    " строка=1  id=1000001  имя=neomake_err
    " 行=1  識別子=1000001  名前=neomake_err
    " línea=12 id=1000001 nombre=neomake_err
    " riga=1 id=1000001, nome=neomake_err
    for line in reverse(signs_output[2:])
        " XXX: does not really match "name="
        "      (broken by patch-8.1.0614, but handled above)
        let sign_type = line[strridx(line, '=')+1:]
        let lnum_idx = stridx(line, '=')
        let lnum = line[lnum_idx+1:] + 0
        if lnum
            let sign_id = line[stridx(line, '=', lnum_idx+1)+1:] + 0
            if has_key(r, lnum)
                call insert(r[lnum], [sign_id, sign_type])
            else
                let r[lnum] = [[sign_id, sign_type]]
            endif
        endif
    endfor
    return r
endfunction

let s:entry_to_sign_type = {'W': 'warn', 'I': 'info', 'M': 'msg'}

" Place signs for list a:entries in a:bufnr for a:type ('file' or 'project').
" List items in a:entries need to have a "type" and "lnum" (non-zero) property.
function! neomake#signs#PlaceSigns(bufnr, entries, type) abort
    " Query the list of currently placed signs.
    " This allows to cope with movements, e.g. when lines were added.
    let all_placed_signs = neomake#signs#by_lnum(a:bufnr)
    let placed_signs = filter(map(copy(all_placed_signs),
                \ 'filter(copy(v:val), "v:val[1] =~# ''^neomake_''")'),
                \ '!empty(v:val)')

    " TEMP: use the first sign only for now.
    call map(placed_signs, 'v:val[0]')

    let entries_by_linenr = {}
    for entry in a:entries
        let lnum = entry.lnum
        let sign_type = printf('neomake_%s_%s',
                    \ a:type,
                    \ get(s:entry_to_sign_type, toupper(entry.type), 'err'))
        if !exists('entries_by_linenr[lnum]')
                    \ || s:sign_order[entries_by_linenr[lnum]]
                    \    > s:sign_order[sign_type]
            let entries_by_linenr[lnum] = sign_type
        endif
    endfor

    let place_new = []
    let log_context = {'bufnr': a:bufnr}
    let count_reused = 0
    for [lnum, sign_type] in items(entries_by_linenr)
        let existing_sign = get(placed_signs, lnum, [])
        if empty(existing_sign) || existing_sign[1] !~# '^neomake_'.a:type.'_'
            call add(place_new, [lnum, sign_type])
            continue
        endif

        let sign_id = existing_sign[0]
        if existing_sign[1] == sign_type
            let count_reused += 1
            " call neomake#log#debug(printf(
            "             \ 'Reusing sign: id=%d, type=%s, lnum=%d.',
            "             \ sign_id, existing_sign[1], lnum), log_context)
        else
            let cmd = printf('sign place %s name=%s buffer=%d',
                        \ sign_id, sign_type, a:bufnr)
            call neomake#log#debug('Upgrading sign for lnum='.lnum.': '.cmd.'.', log_context)
            exe cmd
        endif

        " Keep this sign from being cleaned.
        if exists('s:last_placed_signs[a:type][a:bufnr][sign_id]')
            unlet s:last_placed_signs[a:type][a:bufnr][sign_id]
        endif
    endfor
    if count_reused
        call neomake#log#debug(printf('Reused %d signs.', count_reused), log_context)
    endif

    for [lnum, sign_type] in place_new
        if !exists('next_sign_id')
            if !empty(all_placed_signs)
                let next_sign_id = max(map(map(values(all_placed_signs), 'map(copy(v:val), ''v:val[0]'')'), 'v:val[0]')) + 1
                if next_sign_id < s:base_sign_id
                    let next_sign_id = s:base_sign_id
                endif
            else
                let next_sign_id = s:base_sign_id
            endif
        else
            let next_sign_id += 1
        endif
        let cmd = 'sign place '.next_sign_id.' line='.lnum.
                    \ ' name='.sign_type.
                    \ ' buffer='.a:bufnr
        call neomake#log#debug('Placing sign: '.cmd.'.', log_context)
        let placed_signs[lnum] = [next_sign_id, sign_type]
        exe cmd
    endfor

    let s:placed_signs[a:type][a:bufnr] = {}
    for [lnum, sign_info] in items(placed_signs)
        let s:placed_signs[a:type][a:bufnr][sign_info[0]] = sign_info[1]
    endfor
endfunction

function! neomake#signs#CleanAllOldSigns(type) abort
    call neomake#log#debug_obj('Removing signs', s:last_placed_signs)
    for buf in keys(s:last_placed_signs[a:type])
        call neomake#signs#CleanOldSigns(buf, a:type)
    endfor
endfunction

" type may be either 'file' or 'project'
function! neomake#signs#CleanOldSigns(bufnr, type) abort
    if !has_key(s:last_placed_signs[a:type], a:bufnr)
        return
    endif
    let placed_signs = s:last_placed_signs[a:type][a:bufnr]
    unlet s:last_placed_signs[a:type][a:bufnr]
    if bufexists(+a:bufnr)
        call neomake#log#debug(printf('Cleaning %d old signs.', len(placed_signs)), {'bufnr': a:bufnr})
        for sign_id in keys(placed_signs)
            exe 'sign unplace '.sign_id.' buffer='.a:bufnr
            if has_key(s:placed_signs[a:type], a:bufnr)
                if has_key(s:placed_signs[a:type][a:bufnr], sign_id)
                    unlet s:placed_signs[a:type][a:bufnr][sign_id]
                endif
            endif
        endfor
    else
        call neomake#log#debug_obj('Skipped cleaning of old signs in non-existing buffer '.a:bufnr, placed_signs)
    endif
endfunction

function! neomake#signs#RedefineSign(name, opts) abort
    let sign_define = 'sign define '.a:name
    for attr in keys(a:opts)
        let sign_define .= ' '.attr.'='.a:opts[attr]
    endfor
    call neomake#log#debug(printf('Defining sign: %s.', sign_define))
    exe sign_define
endfunction

function! neomake#signs#RedefineErrorSign(...) abort
    let default_opts = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
    let opts = {}
    if a:0
        call extend(opts, a:1)
    elseif exists('g:neomake_error_sign')
        call extend(opts, g:neomake_error_sign)
    endif
    call extend(opts, default_opts, 'keep')
    call neomake#signs#RedefineSign('neomake_file_err', opts)
    call neomake#signs#RedefineSign('neomake_project_err', opts)
endfunction

function! neomake#signs#RedefineWarningSign(...) abort
    let default_opts = {'text': '‼', 'texthl': 'NeomakeWarningSign'}
    let opts = {}
    if a:0
        call extend(opts, a:1)
    elseif exists('g:neomake_warning_sign')
        call extend(opts, g:neomake_warning_sign)
    endif
    call extend(opts, default_opts, 'keep')
    call neomake#signs#RedefineSign('neomake_file_warn', opts)
    call neomake#signs#RedefineSign('neomake_project_warn', opts)
endfunction

function! neomake#signs#RedefineMessageSign(...) abort
    let default_opts = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
    let opts = {}
    if a:0
        call extend(opts, a:1)
    elseif exists('g:neomake_message_sign')
        call extend(opts, g:neomake_message_sign)
    endif
    call extend(opts, default_opts, 'keep')
    call neomake#signs#RedefineSign('neomake_file_msg', opts)
    call neomake#signs#RedefineSign('neomake_project_msg', opts)
endfunction

function! neomake#signs#RedefineInfoSign(...) abort
    let default_opts = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
    let opts = {}
    if a:0
        call extend(opts, a:1)
    elseif exists('g:neomake_info_sign')
        call extend(opts, g:neomake_info_sign)
    endif
    call extend(opts, default_opts, 'keep')
    call neomake#signs#RedefineSign('neomake_file_info', opts)
    call neomake#signs#RedefineSign('neomake_project_info', opts)
endfunction

function! neomake#signs#DefineHighlights() abort
    " Use background from SignColumn.
    let ctermbg = neomake#utils#GetHighlight('SignColumn', 'bg', 'Normal')
    let guibg = neomake#utils#GetHighlight('SignColumn', 'bg#', 'Normal')

    " Define NeomakeErrorSign, NeomakeWarningSign etc.
    call neomake#utils#define_derived_highlights('Neomake%sSign', [ctermbg, guibg])
endfunction

function! neomake#signs#DefineSigns() abort
    call neomake#signs#RedefineErrorSign()
    call neomake#signs#RedefineWarningSign()
    call neomake#signs#RedefineInfoSign()
    call neomake#signs#RedefineMessageSign()
endfunction

function! s:wipe_signs(bufnr) abort
    for type in ['file', 'project']
        if has_key(s:placed_signs[type], a:bufnr)
            unlet s:placed_signs[type][a:bufnr]
        endif
        if has_key(s:last_placed_signs[type], a:bufnr)
            unlet s:last_placed_signs[type][a:bufnr]
        endif
    endfor
endfunction
augroup neomake_signs
    au!
    autocmd BufWipeout * call s:wipe_signs(expand('<abuf>'))
augroup END

call neomake#signs#DefineSigns()
call neomake#signs#DefineHighlights()
