" New-style config API.

let g:neomake#config#_defaults = {
            \ 'maker_defaults': {
            \   'buffer_output': 1,
            \   'output_stream': 'both',
            \   'remove_invalid_entries': 0,
            \ }}
lockvar g:neomake#config#_defaults

let g:neomake#config#undefined = {}
lockvar! g:neomake#config#undefined

" Resolve a:name (list of keys or string (split on dots)) and (optionally)
" init a:dict accordingly.
function! s:resolve_name(dict, name, init, validate) abort
    let parts = type(a:name) == type([]) ? a:name : split(a:name, '\.')
    if a:validate && parts[0] ==# 'neomake'
        throw printf(
                    \ 'Neomake: config: "neomake" is not necessary with new-style config settings (%s).',
                    \ string(a:name))
    endif
    let c = a:dict
    for p in parts[0:-2]
        if !has_key(c, p)
            if !a:init
                return [g:neomake#config#undefined, '']
            endif
            let c[p] = {}
        endif
        if type(c[p]) != type({})
            return [g:neomake#config#undefined, '']
        endif
        let c = c[p]
    endfor
    return [c, parts[-1]]
endfunction

" Get a:name (list of keys or string (split on dots)) from a:dict,
" using a:prefixes.
function! s:get(dict, parts, prefixes) abort
    for prefix in a:prefixes
        let [c, k] = s:resolve_name(a:dict, prefix + a:parts[0:-1], 0, 1)
        if has_key(c, k)
            return [prefix, get(c, k)]
        endif
    endfor
    return [[], g:neomake#config#undefined]
endfunction

" Get a:name (string (split on dots), or list of keys) from config.
" See neomake#config#get_with_source for args.
function! neomake#config#get(name, ...) abort
    return call('neomake#config#get_with_source', [a:name] + a:000)[0]
endfunction

" Get a:name (string (split on dots), or list of keys) from config, with
" information about the setting's source ('buffer', 'tab', 'global', 'maker',
" 'default').
" Optional args:
"  - a:1: default value
"  - a:2: context: defaults to {'ft': &filetype}
"    - maker: a maker dict (where maker.name is used from for prefixes, and
"             as a lookup itself)
"    - ft: filetype string (use an empty string to ignore it)
"    - bufnr: buffer number (use an empty string to ignore it)
"    - maker_only: should settings get looked up only in the maker context?
"                  (i.e. with maker.name prefix in general and in context.maker)
"    - log_source: additional information to log.
function! neomake#config#get_with_source(name, ...) abort
    let context = a:0 > 1 ? a:2 : {'ft': &filetype, 'bufnr': bufnr('%')}
    let parts = type(a:name) == type([]) ? a:name : split(a:name, '\.')

    let prefixes = [[]]
    if has_key(context, 'ft') && !empty(context.ft)
        for ft in neomake#utils#get_config_fts(context.ft, '.')
            call insert(prefixes, ['ft', ft], 0)
        endfor
    endif

    let maker_name = get(get(context, 'maker', {}), 'name', '')
    let maker_only = get(context, 'maker_only', 0)
    if parts[0][0:1] ==# 'b:'
        if !has_key(context, 'bufnr')
            let context.bufnr = bufnr('%')
        endif
        let parts[0] = parts[0][2:-1]
        if context.bufnr is# ''
            let lookups = []
        else
            let lookups = [['buffer', getbufvar(context.bufnr, 'neomake')]]
        endif
        call add(lookups, ['maker', get(context, 'maker', {})])
    elseif empty(maker_name) && maker_only
        let lookups = [['maker', get(context, 'maker', {})]]
    else
        let lookups = (has_key(context, 'bufnr') && context.bufnr isnot# ''
                    \  ? [['buffer', getbufvar(context.bufnr, 'neomake')]]
                    \  : []) + [
                    \ ['tab', get(t:, 'neomake', {})],
                    \ ['global', get(g:, 'neomake', {})],
                    \ ['maker', get(context, 'maker', {})]]
        if !empty(maker_name)
            if maker_only
                if parts[0] !=# maker_name
                    call map(prefixes, 'add(v:val, maker_name)')
                endif
            else
                for prefix in reverse(copy(prefixes))
                    call insert(prefixes, prefix + [maker_name], 0)
                endfor
            endif
        endif
    endif

    for [source, lookup] in lookups
        if !empty(lookup)
            if source ==# 'maker'
                let maker_prefixes = map(copy(prefixes), '!empty(v:val) && v:val[-1] ==# maker_name ? v:val[:-2] : v:val')
                let maker_setting_parts = parts[0] == maker_name ? parts[1:] : parts
                let [prefix, l:R] = s:get(lookup, maker_setting_parts, maker_prefixes)
            else
                let [prefix, l:R] = s:get(lookup, parts, prefixes)
            endif
            if R isnot# g:neomake#config#undefined
                let log_name = join(map(copy(parts), "substitute(v:val, '\\.', '|', '')"), '.')
                let log_source = get(context, 'log_source', '')
                call neomake#log#debug(printf(
                            \ "Using setting %s=%s from '%s'%s%s.",
                            \ log_name, string(R), source,
                            \   empty(prefix) ? '' : ' (prefix: '.string(prefix).')',
                            \   empty(log_source) ? '' : ' ('.log_source.')'),
                            \ context)
                return [R, source]
            endif
            unlet R  " for Vim without patch-7.4.1546
        endif
        unlet lookup  " for Vim without patch-7.4.1546
    endfor

    " Return default.
    if a:0
        return [a:1, 'default']
    elseif has_key(g:neomake#config#_defaults, a:name)
        return [copy(g:neomake#config#_defaults[a:name]), 'default']
    endif
    return [g:neomake#config#undefined, 'default']
endfunction


" Set a:name (list or string (split on dots)) in a:dict to a:value.
function! s:set(dict, name, value, validate) abort
    let [c, k] = s:resolve_name(a:dict, a:name, 1, a:validate)
    let c[k] = a:value
    return c
endfunction

" Set a:name to a:value in the config.
" a:name:
"  - a list (e.g. `['ft', 'javascript.jsx', 'eslint', 'exe']`, or
"  - a string (split on dots, e.g. `'ft.python.enabled_makers'`), where
"    `b:` sets a buffer-local setting (via `neomake#config#set_buffer`).
" a:value: the value to set
function! neomake#config#set(name, value) abort
    let parts = type(a:name) == type([]) ? a:name : split(a:name, '\.')
    if parts[0] =~# '^b:'
        let parts[0] = parts[0][2:-1]
        return neomake#config#set_buffer(bufnr('%'), parts, a:value)
    endif
    if !has_key(g:, 'neomake')
        let g:neomake = {}
    endif
    return s:set(g:neomake, parts, a:value, 1)
endfunction

" Set a:name (list or string (split on dots)) to a:value for buffer a:bufnr.
function! neomake#config#set_buffer(bufnr, name, value) abort
    let bufnr = +a:bufnr
    let bneomake = getbufvar(bufnr, 'neomake')
    if bneomake is# ''
        unlet bneomake  " for Vim without patch-7.4.1546
        let bneomake = {}
        call setbufvar(bufnr, 'neomake', bneomake)
    endif
    return s:set(bneomake, a:name, a:value, 1)
endfunction

" Set a:name (list or string (split on dots)) to a:value in a:scope.
" This is meant for advanced usage, e.g.:
"   set_scope(t:, 'neomake.disabled', 1)
function! neomake#config#set_dict(dict, name, value) abort
    return s:set(a:dict, a:name, a:value, 0)
endfunction

" Unset a:name (list or string (split on dots)).
" This is meant for advanced usage, e.g.:
"   unset_dict(t:, 'neomake.disabled', 1)
function! neomake#config#unset_dict(dict, name) abort
    let [c, k] = s:resolve_name(a:dict, a:name, 0, 0)
    if has_key(c, k)
        unlet c[k]
    endif
endfunction
" vim: ts=4 sw=4 et
