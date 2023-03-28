let s:save_cpo = &cpo
set cpo&vim

let g:unite#sources#grammarous#one_line = get(g:, 'unite#sources#grammarous#one_line', 0)

let s:source = {
            \ 'name' : 'grammarous',
            \ 'description' : 'Show result of grammar check by vim-grammarous',
            \ 'default_kind' : 'jump_list',
            \ 'default_action' : 'open',
            \ 'hooks' : {},
            \ 'action_table' : {},
            \ 'syntax' : 'uniteSource__Grammarous',
            \ }

function! unite#sources#grammarous#define()
    return s:source
endfunction

function! s:source.hooks.on_init(args, context)
    if exists('b:unite') && has_key(b:unite, 'prev_bufnr')
        let a:context.source__checked_bufnr = b:unite.prev_bufnr
    else
        let a:context.source__checked_bufnr = bufnr('%')
    endif
    let a:context.source__checked_bufnr
                \ = getbufvar(
                \       a:context.source__checked_bufnr,
                \       'grammarous_preview_original_bufnr',
                \       a:context.source__checked_bufnr
                \   )
    if type(getbufvar(a:context.source__checked_bufnr, 'grammarous_result', 0)) == type(0)
        let should_check_current_buf = a:context.source__checked_bufnr == bufnr('%')
        if should_check_current_buf
            execute 'GrammarousCheck' join(a:args, ' ')
        else
            let w = bufwinnr(a:context.source__checked_bufnr)
            execute w . 'wincmd w'
            execute 'GrammarousCheck' join(a:args, ' ')
            wincmd p
        endif
    endif

    call grammarous#info_win#close()
endfunction

function! s:source.hooks.on_syntax(args, context)
    if g:unite#sources#grammarous#one_line
        syntax region uniteSource__GrammarousError start="'" end="'" oneline contained containedin=uniteSource__Grammarous
        syntax match uniteSource__GrammarousArrow "->" contained containedin=uniteSource__Grammarous
        highlight default link uniteSource__GrammarousArrow Keyword
        highlight default link uniteSource__GrammarousError ErrorMsg
    else
        syntax match uniteSource__GrammarousKeyword "\%(Context\|Correct\):" contained containedin=uniteSource__Grammarous
        syntax keyword uniteSource__GrammarousError Error contained containedin=uniteSource__Grammarous
        highlight default link uniteSource__GrammarousKeyword Keyword
        highlight default link uniteSource__GrammarousError ErrorMsg
        for err in getbufvar(a:context.source__checked_bufnr, 'grammarous_result', [])
            call matchadd('GrammarousError', grammarous#generate_highlight_pattern(err), 999)
        endfor
    endif
endfunction

function! s:make_word(e)
    if g:unite#sources#grammarous#one_line
        return printf("'%s' -> %s", a:e.context[a:e.contextoffset : a:e.contextoffset+a:e.errorlength-1], a:e.msg)
    else
        let word = printf('Error:   %s\nContext: %s', a:e.msg, a:e.context)
        if a:e.replacements !=# ''
            let word .= '\nCorrect: ' . split(a:e.replacements, '#', 1)[0]
        endif
        return word
    endif
endfunction

function! s:source.change_candidates(args, context)
    return map(copy(getbufvar(a:context.source__checked_bufnr, 'grammarous_result', [])), '{
                \   "word" : s:make_word(v:val),
                \   "action__buffer_nr" : a:context.source__checked_bufnr,
                \   "action__line" : str2nr(v:val.fromy)+1,
                \   "action__col" : str2nr(v:val.fromx)+1,
                \   "action__grammar_error" : v:val,
                \   "is_multiline" : 1,
                \}')
endfunction

function! s:prepare_bufvar(c)
    let b:grammarous_preview_error = a:c.action__grammar_error
    let b:grammarous_preview_original_bufnr = a:c.action__buffer_nr
endfunction

let s:source.action_table.fixit = {
            \   'description' : 'Fix the error automatically',
            \ }

function! s:source.action_table.fixit.func(candidate)
    call s:prepare_bufvar(a:candidate)
    call grammarous#info_win#action_fixit()
endfunction

let s:source.action_table.remove_error = {
            \   'description' : 'Remove the error without fix'
            \ }

function! s:source.action_table.remove_error.func(candidate)
    call s:prepare_bufvar(a:candidate)
    call grammarous#info_win#action_remove_error()
endfunction

let s:source.action_table.disable_rule = {
            \   'description' : 'Disable the grammar rule in the checked buffer'
            \ }

function! s:source.action_table.disable_rule.func(candidate)
    call s:prepare_bufvar(a:candidate)
    call grammarous#info_win#action_disable_rule()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
