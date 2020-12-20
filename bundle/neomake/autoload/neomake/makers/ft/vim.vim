function! neomake#makers#ft#vim#EnabledMakers() abort
    return ['vint']
endfunction

let s:slash = neomake#utils#Slash()
let s:neomake_root = expand('<sfile>:p:h:h:h:h:h', 1)

let s:vint_supports_stdin = {}

function! neomake#makers#ft#vim#neomake_checks() abort
    let maker = {
                \ 'exe': join([s:neomake_root, 'contrib', 'vim-checks'], s:slash),
                \ 'errorformat': '%f:%l: %m',
                \ }

    return maker
endfunction

function! neomake#makers#ft#vim#vint() abort
    let args = ['--style-problem', '--no-color',
        \ '-f', '{file_path}:{line_number}:{column_number}:{severity}:{description} ({policy_name})']

    if has('nvim')
        call add(args, '--enable-neovim')
    endif

    let maker = {
        \ 'args': args,
        \ 'errorformat': '%I%f:%l:%c:style_problem:%m,'
        \   .'%f:%l:%c:%t%*[^:]:E%n: %m,'
        \   .'%f:%l:%c:%t%*[^:]:%m',
        \ 'output_stream': 'stdout',
        \ 'postprocess': {
        \   'fn': function('neomake#postprocess#generic_length'),
        \   'pattern': '\v%(^:|%([^:]+: ))\zs(\S+)',
        \ }}

    function! maker.supports_stdin(_jobinfo) abort
        let exe = exists('*exepath') ? exepath(self.exe) : self.exe
        let support = get(s:vint_supports_stdin, exe, -1)
        if support == -1
            let ver = neomake#compat#systemlist(['vint', '--version'])
            let ver_split = split(ver[0], '\.')
            if len(ver_split) > 1 && (ver_split[0] > 0 || +ver_split[1] >= 4)
                let support = 1
            else
                let support = 0
            endif
            let s:vint_supports_stdin[exe] = support
            call neomake#log#debug('vint: stdin support: '.support.'.')
        endif
        if support
            let self.args += ['--stdin-display-name', '%:.']
        endif
        return support
    endfunction
    return maker
endfunction

function! neomake#makers#ft#vim#vimlint() abort
    return {
        \ 'args': ['-u'],
        \ 'errorformat': '%f:%l:%c:%trror: EVL%n: %m,'
        \   . '%f:%l:%c:%tarning: EVL%n: %m,'
        \   . '%f:%l:%c:%t%*[^:]: EVP_%#E%#%n: %m',
        \ 'postprocess': function('neomake#makers#ft#vim#PostprocessVimlint'),
        \ 'output_stream': 'stdout',
        \ }
endfunction

function! neomake#makers#ft#vim#PostprocessVimlint(entry) abort
    let m = matchlist(a:entry.text, '\v`\zs[^`]{-}\ze`')
    if empty(m)
        return
    endif

    " Ensure that the text is there.
    let l = len(m[0])
    let line = getline(a:entry.lnum)
    if line[a:entry.col-1 : a:entry.col-2+l] == m[0]
        let a:entry.length = l
    elseif m[0][0:1] ==# 'l:' && line[a:entry.col-1 : a:entry.col-4+l] == m[0][2:]
        " Ignore implicit 'l:' prefix.
        let a:entry.length = l - 2
    endif
endfunction
" vim: ts=4 sw=4 et
