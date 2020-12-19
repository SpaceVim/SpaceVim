" Generic postprocessor to add `length` to `a:entry`.
" The pattern can be overridden on `self` and should adhere to this:
"  - the matched word should be returned as the whole match (you can use \zs
"    and \ze).
"  - enclosing patterns should be returned as \1 and \2, where \1 is used as
"    offset when the first entry did not match.
" See tests/postprocess.vader for tests/examples.
" See neomake#postprocess#generic_length_with_pattern for a non-dict variant.
function! neomake#postprocess#generic_length(entry) abort dict
    if a:entry.lnum > 0 && a:entry.col
        let pattern = get(self, 'pattern', '\v(["''`])\zs[^\1]{-}\ze(\1)')
        let start = 0
        let best = 0
        while 1
            let m = matchlist(a:entry.text, pattern, start)
            if empty(m)
                break
            endif
            let l = len(m[0])
            if l > best
                " Ensure that the text is there.
                let line = get(getbufline(a:entry.bufnr, a:entry.lnum), 0, '')
                if line[a:entry.col-1 : a:entry.col-2+l] == m[0]
                    let best = l
                endif
            endif
            if exists('*matchstrpos')  " vim73
                let pos = matchstrpos(a:entry.text, pattern, start)
                if pos[1] == -1
                    break
                endif
                let start += pos[2] + len(m[2])
            else
                break
            endif
        endwhile
        if best
            let a:entry.length = best
        endif
    endif
endfunction

" Wrapper to call neomake#process#generic_length (a dict function).
function! neomake#postprocess#generic_length_with_pattern(entry, pattern) abort
    let this = {'pattern': a:pattern}
    return call('neomake#postprocess#generic_length', [a:entry], this)
endfunction

" Deprecated: renamed to neomake#postprocess#generic_length.
function! neomake#postprocess#GenericLengthPostprocess(entry) abort dict
    return neomake#postprocess#generic_length(a:entry)
endfunction

function! neomake#postprocess#compress_whitespace(entry) abort
    let text = a:entry.text
    let text = substitute(text, "\001", '', 'g')
    let text = substitute(text, '\r\?\n', ' ', 'g')
    let text = substitute(text, '\m\s\{2,}', ' ', 'g')
    let text = substitute(text, '\m^\s\+', '', '')
    let text = substitute(text, '\m\s\+$', '', '')
    let a:entry.text = text
endfunction

let g:neomake#postprocess#remove_duplicates = {}
function! g:neomake#postprocess#remove_duplicates.fn(entry) abort
    if exists('self._seen_entries')
        if index(self._seen_entries, a:entry) != -1
            let a:entry.valid = -1
        else
            call add(self._seen_entries, a:entry)
        endif
    else
        let self._seen_entries = [a:entry]
    endif
endfunction
lockvar g:neomake#postprocess#remove_duplicates  " Needs to be copied.
" vim: ts=4 sw=4 et
