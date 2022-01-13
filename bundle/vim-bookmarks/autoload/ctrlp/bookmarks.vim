if v:version < 700 || &cp
  finish
endif

call add(g:ctrlp_ext_vars, {
  \ 'init': 'ctrlp#bookmarks#init()',
  \ 'accept': 'ctrlp#bookmarks#accept',
  \ 'lname': 'vim-bookmarks',
  \ 'sname': '',
  \ 'type': 'line',
  \ 'sort': 0,
  \ 'specinput': 0,
  \ })


function! ctrlp#bookmarks#init() abort
    let l:text=[]
    let l:files = sort(bm#all_files())
    for l:file in l:files
        let l:line_nrs = sort(bm#all_lines(l:file), "bm#compare_lines")
        for l:line_nr in l:line_nrs
            let l:bookmark = bm#get_bookmark_by_line(l:file, l:line_nr)
            let l:detail = printf("%s", l:bookmark.annotation !~ '^\s*$' ?
                  \ l:bookmark.annotation 
                  \ : l:bookmark.content !~ '^\s*$' ?
                  \ l:bookmark.content 
                  \ : "EMPTY LINE")
            call add(l:text, l:detail)
        endfor
    endfor
    return l:text
endfunction

function! ctrlp#bookmarks#accept(mode, str) abort
  if a:mode ==# 'e'
      let l:HowToOpen='e'
  elseif a:mode ==# 't'
      let l:HowToOpen='tabnew'
  elseif a:mode ==# 'v'
      let l:HowToOpen='vsplit'
  elseif a:mode ==# 'h'
      let l:HowToOpen='sp'
  endif
  call ctrlp#exit()
    let l:text=[]
    let l:files = sort(bm#all_files())
    for l:file in l:files
        let l:line_nrs = sort(bm#all_lines(l:file), "bm#compare_lines")
        for l:line_nr in l:line_nrs
            let l:bookmark = bm#get_bookmark_by_line(l:file, l:line_nr)
            if a:str ==# l:bookmark.annotation 
                execute l:HowToOpen." ".l:file
                execute ":".l:line_nr
                break
            elseif a:str ==# l:bookmark.content
                execute l:HowToOpen." ".l:file
                execute ":".l:line_nr
                break
            elseif a:str ==# "EMPTY LINE"
                execute l:HowToOpen." ".l:file
                execute ":".l:line_nr
                break
            endif
        endfor
    endfor
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#bookmarks#id() abort
  return s:id
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
