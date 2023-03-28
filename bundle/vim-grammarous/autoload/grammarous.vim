let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#grammarous#new()
let s:XML = s:V.import('Web.XML')
let s:O = s:V.import('OptionParser')
let s:P = s:V.import('Process')
let s:is_cygwin = has('win32unix')
let s:is_windows = has('win32') || has('win64')
let s:job_is_available = has('job') && has('patch-8.0.0027')

let s:grammarous_root                            = fnamemodify(expand('<sfile>'), ':p:h:h')

let g:grammarous#jar_dir                         = get(g:, 'grammarous#jar_dir', s:grammarous_root . '/misc')
let g:grammarous#jar_url                         = get(g:, 'grammarous#jar_url', 'https://www.languagetool.org/download/LanguageTool-stable.zip')
let g:grammarous#java_cmd                        = get(g:, 'grammarous#java_cmd', 'java')
let g:grammarous#default_lang                    = get(g:, 'grammarous#default_lang', 'en')
let g:grammarous#use_vim_spelllang               = get(g:, 'grammarous#use_vim_spelllang', 0)
let g:grammarous#info_window_height              = get(g:, 'grammarous#info_window_height', 10)
let g:grammarous#info_win_direction              = get(g:, 'grammarous#info_win_direction', 'botright')
let g:grammarous#use_fallback_highlight          = get(g:, 'grammarous#use_fallback_highlight', !exists('*matchaddpos'))
let g:grammarous#enabled_rules                   = get(g:, 'grammarous#enabled_rules', {})
let g:grammarous#disabled_rules                  = get(g:, 'grammarous#disabled_rules', {'*' : ['WHITESPACE_RULE', 'EN_QUOTES']})
let g:grammarous#enabled_categories              = get(g:, 'grammarous#enabled_categories', {})
let g:grammarous#disabled_categories             = get(g:, 'grammarous#disabled_categories', {})
let g:grammarous#default_comments_only_filetypes = get(g:, 'grammarous#default_comments_only_filetypes', {'*' : 0})
let g:grammarous#enable_spell_check              = get(g:, 'grammarous#enable_spell_check', 0)
let g:grammarous#move_to_first_error             = get(g:, 'grammarous#move_to_first_error', 1)
let g:grammarous#hooks                           = get(g:, 'grammarous#hooks', {})
let g:grammarous#languagetool_cmd                = get(g:, 'grammarous#languagetool_cmd', '')
let g:grammarous#show_first_error                = get(g:, 'grammarous#show_first_error', 0)
let g:grammarous#use_location_list               = get(g:, 'grammarous#use_location_list', 0)

highlight default link GrammarousError SpellBad
highlight default link GrammarousInfoError ErrorMsg
highlight default link GrammarousInfoSection Keyword
highlight default link GrammarousInfoHelp Special

augroup pluging-rammarous-highlight
    autocmd ColorScheme * highlight default link GrammarousError SpellBad
    autocmd ColorScheme * highlight default link GrammarousInfoError ErrorMsg
    autocmd ColorScheme * highlight default link GrammarousInfoSection Keyword
    autocmd ColorScheme * highlight default link GrammarousInfoHelp Special
augroup END

function! s:get_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeget_SID$')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

function! grammarous#_import_vital_modules()
    return [s:XML, s:O, s:P]
endfunction

function! grammarous#error(...)
    echohl ErrorMsg
    try
        if a:0 > 1
            let msg = 'vim-grammarous: ' . call('printf', a:000)
        else
            let msg = 'vim-grammarous: ' . a:1
        endif
        for l in split(msg, "\n")
            echomsg l
        endfor
    finally
        echohl None
    endtry
endfunction

function! s:delete_jar_dir() abort
    if !isdirectory(g:grammarous#jar_dir)
        return
    endif

    let dir = g:grammarous#jar_dir
    if s:is_cygwin
        let dir = s:cygpath(dir)
    endif

    if dir ==# '' || !isdirectory(dir)
        call grammarous#error("Directory '%s' does not exist", dir)
        return
    endif

    if s:is_windows && !s:is_cygwin
        let cmd = 'rmdir /s /q ' . dir
    else
        let cmd = 'rm -rf ' . dir
    endif

    let out = system(cmd)
    if v:shell_error
        call grammarous#error("Cannot remove the directory '%s': %s", dir, out)
        return
    endif

    echomsg 'Deleted ' . dir
    unlet! s:jar_file
endfunction

function! s:find_jar(dir)
    return findfile('languagetool-commandline.jar', a:dir . '/**')
endfunction

function! s:prepare_jar(dir)
    let jar = s:find_jar(a:dir)
    if jar ==# ''
        if grammarous#downloader#download(a:dir)
            let jar = s:find_jar(a:dir)
        endif
    endif
    return fnamemodify(jar, ':p')
endfunction

function! s:find_jar_path()
    if exists('s:jar_file')
        return s:jar_file
    endif

    if !executable(g:grammarous#java_cmd)
        call grammarous#error('"java" command not found. Please install Java 8+')
        return ''
    endif

    " TODO:
    " Check java version

    let jar = s:prepare_jar(g:grammarous#jar_dir)
    if jar ==# ''
        call grammarous#error('Failed to get LanguageTool')
        return ''
    endif

    if s:is_cygwin
        let jar = s:cygpath(jar)
    endif

    let s:jar_file = jar
    return jar
endfunction

function! s:cygpath(path) abort
    if !executable('cygpath')
        return a:path
    endif

    " On Cygwin environment, paths should be converted with cygpath.
    "   /cygdrive/c/... -> C:/...
    " https://github.com/rhysd/vim-grammarous/issues/30
    let converted = substitute(s:P.system('cygpath -aw ' . a:path), '\n\+$', '', '')

    if s:P.get_last_status()
        return a:path
    endif

    return converted
endfunction

function! s:make_text(text)
    if type(a:text) == type('')
        return a:text
    else
        return join(a:text, "\n")
    endif
endfunction

function! s:set_errors_to_location_list() abort
    let f = expand('%:p')
    let saved_efm = &l:errorformat
    try
        setlocal errorformat=%f:%l:%c:%m
        let lines = map(copy(b:grammarous_result), '
                \   printf("%s:%s:%s:%s [%s]", f, v:val.fromy + 1, v:val.fromx + 1, v:val.msg, v:val.category)
                \')
        lgetexpr lines
    finally
        let &l:errorformat = saved_efm
    endtry
endfunction

function! s:set_errors_from_xml_string(xml) abort
    let b:grammarous_result = grammarous#get_errors_from_xml(s:XML.parse(substitute(a:xml, "\n", '', 'g')))
    let parsed = s:last_parsed_options

    if s:is_comment_only(parsed['comments-only'])
        call filter(b:grammarous_result, 'synIDattr(synID(v:val.fromy+1, v:val.fromx+1, 0), "name") =~? "comment"')
    endif

    redraw!
    if empty(b:grammarous_result)
        echomsg 'Yay! No grammatical errors detected.'
        return
    endif

    let len = len(b:grammarous_result)
    echomsg printf('Detected %d grammatical error%s', len, len > 1 ? 's' : '')
    call grammarous#highlight_errors_in_current_buffer(b:grammarous_result)
    if parsed['move-to-first-error']
        call cursor(b:grammarous_result[0].fromy+1, b:grammarous_result[0].fromx+1)
    endif

    if g:grammarous#enable_spell_check
        let s:saved_spell = &l:spell
        setlocal spell
    endif

    if g:grammarous#use_location_list
        call s:set_errors_to_location_list()
    endif

    if g:grammarous#show_first_error
        call grammarous#create_update_info_window_of(b:grammarous_result)
    endif

    if has_key(g:grammarous#hooks, 'on_check')
        call call(g:grammarous#hooks.on_check, [b:grammarous_result], g:grammarous#hooks)
    endif
endfunction

function! s:on_check_done_vim8(channel) abort
    let xml = ''
    while ch_status(a:channel, {'part' : 'out'}) ==# 'buffered'
        let xml .= ch_read(a:channel)
    endwhile
    if xml ==# ''
        return
    endif
    call s:set_errors_from_xml_string(xml)
endfunction

function! s:on_check_exit_vim8(channel, status) abort
    if a:status == 0
        return
    endif
    let err = ''
    while ch_status(a:channel, {'part' : 'err'}) ==# 'buffered'
        let err .= ch_read(a:channel, {'part' : 'err'})
    endwhile
    call grammarous#error('Grammar check failed with exit status ' . a:status . ': ' . err)
endfunction

function! s:on_exit_nvim(job, status, event) abort dict
    if a:status != 0
        call grammarous#error('Grammar check failed: ' . self._stderr)
        return
    endif

    call s:set_errors_from_xml_string(self._stdout)
endfunction

function! s:on_output_nvim(job, lines, event) abort dict
    let output = join(a:lines, "\n")
    if a:event ==# 'stdout'
        let self._stdout .= output
    else
        let self._stderr .= output
    endif
endfunction

function! s:invoke_check(range_start, ...)
    if g:grammarous#languagetool_cmd ==# ''
        let jar = s:find_jar_path()
        if jar ==# ''
            return
        endif
    endif

    if a:0 < 1
        call grammarous#error('Invalid argument. At least one argument is required.')
        return
    endif

    if g:grammarous#use_vim_spelllang
      " Convert vim spelllang to languagetool spelllang
      if len(split(&spelllang, '_')) == 1
        let lang = split(&spelllang, '_')[0]
      elseif len(split(&spelllang, '_')) == 2
        let lang = split(&spelllang, '_')[0].'-'.toupper(split(&spelllang, '_')[1])
      endif
    else
      let lang = a:0 == 1 ? g:grammarous#default_lang : a:1
    endif
    let text = s:make_text(a:0 == 1 ? a:1 : a:2)

    let tmpfile = tempname()
    execute 'redir! >' tmpfile
        let l = 1
        while l < a:range_start
            silent echo ""
            let l += 1
        endwhile
        silent echon text
    redir END

    if s:is_cygwin
        let tmpfile = s:cygpath(tmpfile)
    endif

    let cmdargs = printf(
            \   '-c %s -l %s --api %s',
            \   &fileencoding ? &fileencoding : &encoding,
            \   lang,
            \   substitute(tmpfile, '\\\s\@!', '\\\\', 'g')
            \ )

    let disabled_rules = get(g:grammarous#disabled_rules, &filetype, get(g:grammarous#disabled_rules, '*', []))
    if !empty(disabled_rules)
        let cmdargs = '-d ' . join(disabled_rules, ',') . ' ' . cmdargs
    endif

    let enabled_rules = get(g:grammarous#enabled_rules, &filetype, get(g:grammarous#enabled_rules, '*', []))
    if !empty(enabled_rules)
        let cmdargs = '-e ' . join(enabled_rules, ',') . ' ' . cmdargs
    endif

    let disabled_categories = get(g:grammarous#disabled_categories, &filetype, get(g:grammarous#disabled_categories, '*', []))
    if !empty(disabled_categories)
        let cmdargs = '--disablecategories ' . join(disabled_categories, ',') . ' ' . cmdargs
    endif

    let enabled_categories = get(g:grammarous#enabled_categories, &filetype, get(g:grammarous#enabled_categories, '*', []))
    if !empty(enabled_categories)
        let cmdargs = '--enablecategories ' . join(enabled_categories, ',') . ' ' . cmdargs
    endif

    if g:grammarous#languagetool_cmd !=# ''
        let cmd = printf('%s %s', g:grammarous#languagetool_cmd, cmdargs)
    else
        let cmd = printf('%s -jar %s %s', g:grammarous#java_cmd, substitute(jar, '\\\s\@!', '\\\\', 'g'), cmdargs)
    endif

    if s:job_is_available
        let job = job_start(cmd, {'close_cb' : s:SID . 'on_check_done_vim8', 'exit_cb' : s:SID . 'on_check_exit_vim8'})
        echo 'Grammar check has started with job(' . job . ')...'
        return
    endif

    if has('nvim')
        let opts = {
            \   'on_stdout' : function('s:on_output_nvim'),
            \   'on_stderr' : function('s:on_output_nvim'),
            \   'on_exit' : function('s:on_exit_nvim'),
            \   '_stdout' : '',
            \   '_stderr' : '',
            \ }
        let job = jobstart(cmd, opts)
        echo 'Grammar check has started with job(id: ' . job . ')...'
        return
    endif

    let xml = s:P.system(cmd)
    call delete(tmpfile)

    if s:P.get_last_status()
        call grammarous#error("Command '%s' failed:\n%s", cmd, xml)
        return
    endif
    call s:set_errors_from_xml_string(xml)
endfunction

function! s:sanitize(s)
    return substitute(escape(a:s, "'\\"), ' ', '\\_\\s', 'g')
endfunction

function! grammarous#generate_highlight_pattern(error)
    let line = a:error.fromy + 1
    let prefix = a:error.contextoffset > 0 ? s:sanitize(a:error.context[: a:error.contextoffset-1]) : ''
    let rest = a:error.context[a:error.contextoffset :]
    let the_error = s:sanitize(rest[: a:error.errorlength-1])
    let rest = s:sanitize(rest[a:error.errorlength :])
    return '\V' . prefix . '\zs' . the_error . '\ze' . rest
endfunction

function! s:unescape_xml(str)
    let s = substitute(a:str, '&quot;', '"',  'g')
    let s = substitute(s, '&apos;', "'",  'g')
    let s = substitute(s, '&gt;',   '>',  'g')
    let s = substitute(s, '&lt;',   '<',  'g')
    return  substitute(s, '&amp;',  '\&', 'g')
endfunction

function! s:unescape_error(err)
    for e in ['context', 'msg', 'replacements']
        let a:err[e] = s:unescape_xml(a:err[e])
    endfor
    return a:err
endfunction

function! grammarous#get_errors_from_xml(xml)
    return map(filter(a:xml.childNodes(), 'v:val.name ==# "error"'), 's:unescape_error(v:val.attr)')
endfunction

function! s:matcherrpos(...)
    return matchaddpos('GrammarousError', [a:000], 999)
endfunction

function! s:highlight_error(from, to)
    if a:from[0] == a:to[0]
        return s:matcherrpos(a:from[0], a:from[1], a:to[1] - a:from[1])
    endif

    let ids = [s:matcherrpos(a:from[0], a:from[1], strlen(getline(a:from[0]))+1 - a:from[1])]
    let line = a:from[0] + 1
    while line < a:to[0]
        call add(ids, s:matcherrpos(line))
        let line += 1
    endwhile
    call add(ids, s:matcherrpos(a:to[0], 1, a:to[1] - 1))
    return ids
endfunction

function! s:remove_3dots(str)
    return substitute(substitute(a:str, '\.\.\.$', '', ''), '\\V\zs\.\.\.', '', '')
endfunction

function! grammarous#highlight_errors_in_current_buffer(errs)
    if !g:grammarous#use_fallback_highlight
        for e in a:errs
            let e.id = s:highlight_error(
                    \   [str2nr(e.fromy)+1, str2nr(e.fromx)+1],
                    \   [str2nr(e.toy)+1, str2nr(e.tox)+1],
                    \ )
        endfor
    else
        for e in a:errs
            let e.id = matchadd(
                    \   'GrammarousError',
                    \   s:remove_3dots(grammarous#generate_highlight_pattern(e)),
                    \   999
                    \ )
        endfor
    endif
endfunction

function! grammarous#reset_highlights()
    for m in filter(getmatches(), 'v:val.group ==# "GrammarousError"')
        call matchdelete(m.id)
    endfor
endfunction

function! grammarous#find_checked_winnr() abort
    if exists('b:grammarous_result')
        return winnr()
    endif
    for bufnr in tabpagebuflist()
        let result = getbufvar(bufnr, 'grammarous_result', [])
        if empty(result)
            continue
        endif

        let winnr = bufwinnr(bufnr)
        if winnr == -1
            continue
        endif

        return winnr
    endfor
    return -1
endfunction

function! grammarous#reset()
    let win = grammarous#find_checked_winnr()
    if win == -1
        return
    endif

    let prev_win = winnr()
    if win != prev_win
        execute win . 'wincmd w'
    endif

    if g:grammarous#use_location_list
        lclose
        lgetexpr []
    endif

    call grammarous#reset_highlights()
    call grammarous#info_win#stop_auto_preview()
    call grammarous#info_win#close()
    if exists('s:saved_spell')
        let &l:spell = s:saved_spell
        unlet s:saved_spell
    endif
    if has_key(g:grammarous#hooks, 'on_reset')
        call call(g:grammarous#hooks.on_reset, [b:grammarous_result], g:grammarous#hooks)
    endif
    unlet! b:grammarous_result b:grammarous_preview_bufnr

    if win != prev_win
        wincmd p
    endif
endfunction

let s:opt_parser = s:O.new()
    \.on('--lang=VALUE',               'language to check',   {'default' : g:grammarous#default_lang})
    \.on('--[no-]preview',             'enable auto preview', {'default' : 1})
    \.on('--[no-]comments-only',       'check comment only',  {'default' : ''})
    \.on('--[no-]move-to-first-error', 'move to first error', {'default' : g:grammarous#move_to_first_error})
    \.on('--reinstall-languagetool',   'reinstall LanguageTool', {'default' : 0})

function! grammarous#complete_opt(arglead, cmdline, cursorpos)
    return s:opt_parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

function! s:is_comment_only(option)
    if type(a:option) == type(0)
        return a:option
    endif

    return get(
        \   g:grammarous#default_comments_only_filetypes,
        \   &filetype,
        \   get(g:grammarous#default_comments_only_filetypes, '*', 0)
        \ )
endfunction

function! grammarous#check_current_buffer(qargs, range)
    if exists('b:grammarous_result')
        call grammarous#reset()
        redraw!
    endif

    let parsed = s:opt_parser.parse(a:qargs, a:range, '')
    if has_key(parsed, 'help')
        return
    endif

    let b:grammarous_auto_preview = parsed.preview
    if parsed.preview
        call grammarous#info_win#start_auto_preview()
    endif

    if parsed['reinstall-languagetool']
        call s:delete_jar_dir()
    endif

    " XXX
    let s:last_parsed_options = parsed

    call s:invoke_check(
                \ parsed.__range__[0],
                \ parsed.lang,
                \ getline(parsed.__range__[0], parsed.__range__[1])
              \ )
endfunction

function! s:less_position(p1, p2)
    if a:p1[0] != a:p2[0]
        return a:p1[0] < a:p2[0]
    endif

    return a:p1[1] < a:p2[1]
endfunction

function! s:binary_search_by_pos(errors, the_pos, start, end)
    if a:start > a:end
        return {}
    endif

    let m = (a:start + a:end) / 2
    let from = [a:errors[m].fromy+1, a:errors[m].fromx+1]
    let to = [a:errors[m].toy+1, a:errors[m].tox]

    if s:less_position(a:the_pos, from)
        return s:binary_search_by_pos(a:errors, a:the_pos, a:start, m-1)
    endif

    if s:less_position(to, a:the_pos)
        return s:binary_search_by_pos(a:errors, a:the_pos, m+1, a:end)
    endif

    return a:errors[m]
endfunction

" Note:
" It believes all errors are sorted by its position
function! grammarous#get_error_at(pos, errs)
    return s:binary_search_by_pos(a:errs, a:pos, 0, len(a:errs)-1)
endfunction

function! grammarous#fixit(err)
    if empty(a:err)
     \ || !grammarous#move_to_checked_buf(a:err.fromy+1, a:err.fromx+1)
     \ || a:err.replacements ==# ''
        call grammarous#error('Cannot fix this error automatically.')
        return
    endif

    let sel_save = &l:selection
    let &l:selection = 'inclusive'
    let save_g_reg = getreg('g', 1)
    let save_g_regtype = getregtype('g')
    try
        normal! v
        call cursor(a:err.toy+1, a:err.tox)
        noautocmd normal! "gy
        let from = getreg('g')
        let to = split(a:err.replacements, '#', 1)[0]
        call setreg('g', to, 'v')
        normal! gv"gp

        call grammarous#remove_error(a:err, get(a:, 1, b:grammarous_result))

        echomsg printf("Fixed: '%s' -> '%s'", from, to)
    finally
        call setreg('g', save_g_reg, save_g_regtype)
        let &l:selection = sel_save
    endtry
endfunction

function! grammarous#fixall(errs)
    for e in a:errs
        call grammarous#fixit(e)
    endfor
endfunction

function! s:move_to_pos(pos)
    let p = type(a:pos[0]) == type([]) ? a:pos[0] : a:pos
    return cursor(a:pos[0], a:pos[1]) != -1
endfunction

function! s:move_to(buf, pos)
    if a:buf != bufnr('%')
        let winnr = bufwinnr(a:buf)
        if winnr == -1
            return 0
        endif

        execute winnr . 'wincmd w'
    endif
    return s:move_to_pos(a:pos)
endfunction

function! grammarous#move_to_checked_buf(...)
    if exists('b:grammarous_result')
        return s:move_to_pos(a:000)
    endif

    if exists('b:grammarous_preview_original_bufnr')
        return s:move_to(b:grammarous_preview_original_bufnr, a:000)
    endif

    for b in tabpagebuflist()
        if !empty(getbufvar(b, 'grammarous_result', []))
            return s:move_to(b, a:000)
        endif
    endfor

    return 0
endfunction

function! grammarous#create_update_info_window_of(errs)
    let e = grammarous#get_error_at(getpos('.')[1 : 2], a:errs)
    if empty(e)
        return
    endif

    if exists('b:grammarous_preview_bufnr')
        let winnr = bufwinnr(b:grammarous_preview_bufnr)
        if winnr == -1
            let bufnr = grammarous#info_win#open(e, bufnr('%'))
        else
            execute winnr . 'wincmd w'
            let bufnr = grammarous#info_win#update(e)
        endif
    else
        let bufnr = grammarous#info_win#open(e, bufnr('%'))
    endif

    wincmd p
    let b:grammarous_preview_bufnr = bufnr
endfunction

function! grammarous#create_and_jump_to_info_window_of(errs)
    call grammarous#create_update_info_window_of(a:errs)
    wincmd p
endfunction

function! s:remove_error_highlight(e)
    let ids = type(a:e.id) == type([]) ? a:e.id : [a:e.id]
    for i in ids
        silent! if matchdelete(i) == -1
            return 0
        endif
    endfor
    return 1
endfunction

function! grammarous#remove_error(e, errs)
    if !s:remove_error_highlight(a:e)
        return 0
    endif

    for i in range(len(a:errs))
        if type(a:errs[i].id) == type(a:e.id) && a:errs[i].id == a:e.id
            call grammarous#info_win#close()
            unlet a:errs[i]
            return 1
        endif
    endfor

    return 0
endfunction

function! grammarous#remove_error_at(pos, errs)
    let e = grammarous#get_error_at(a:pos, a:errs)
    if empty(e)
        return 0
    endif

    return grammarous#remove_error(e, a:errs)
endfunction

function! grammarous#disable_rule(rule, errs)
    call grammarous#info_win#close()

    " Note:
    " reverse() is needed because of removing elements in list
    for i in reverse(range(len(a:errs)))
        let e = a:errs[i]
        if e.ruleId ==# a:rule
            if !s:remove_error_highlight(e)
                return 0
            endif
            unlet a:errs[i]
        endif
    endfor

    echomsg 'Disabled rule: ' . a:rule

    return 1
endfunction

function! grammarous#disable_rule_at(pos, errs)
    let e = grammarous#get_error_at(a:pos, a:errs)
    if empty(e)
        return 0
    endif

    return grammarous#disable_rule(e.ruleId, a:errs)
endfunction

function! grammarous#disable_category(category, errs)
    call grammarous#info_win#close()

    " Note:
    " reverse() is needed because of removing elements in list
    for i in reverse(range(len(a:errs)))
        let e = a:errs[i]

        if e.categoryid ==# a:category
            if !s:remove_error_highlight(e)
                return 0
            endif
            unlet a:errs[i]
        endif
    endfor

    echomsg 'Disabled category: ' . a:category

    return 1
endfunction

function! grammarous#disable_category_at(pos, errs)
    let e = grammarous#get_error_at(a:pos, a:errs)
    if empty(e)
        return 0
    endif

    return grammarous#disable_category(e.categoryid, a:errs)
endfunction

function! grammarous#move_to_next_error(pos, errs)
    for e in a:errs
        let p = [e.fromy+1, e.fromx+1]
        if s:less_position(a:pos, p)
            return s:move_to_pos(p)
        endif
    endfor
    call grammarous#error('No next error found.')
    return 0
endfunction

function! grammarous#move_to_previous_error(pos, errs)
    for e in reverse(copy(a:errs))
        let p = [e.fromy+1, e.fromx+1]
        if s:less_position(p, a:pos)
            return s:move_to_pos(p)
        endif
    endfor
    call grammarous#error('No previous error found.')
    return 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
