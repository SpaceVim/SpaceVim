let s:mail_box = {}
function! mail#client#mailbox#get(dir)
    return get(s:mail_box, a:dir, {})
endfunction

function! mail#client#mailbox#updatedir(id, from, data, subject, dir)
    if !has_key(s:mail_box, a:dir)
        call extend(s:mail_box, {a:dir :
                        \ { a:id :
                            \ {
                            \ 'from' : a:from,
                            \ 'subject' : a:subject,
                            \ 'data' : a:data,
                            \ },
                        \ },
                    \ }
                    \ )
    else
        if !has_key(s:mail_box[a:dir], a:id)
            call extend(s:mail_box[a:dir],
                            \ { a:id :
                                \ {
                                \ 'from' : a:from,
                                \ 'subject' : a:subject,
                                \ 'data' : a:data,
                                \ },
                            \ },
                        \ )
        else
            call extend(s:mail_box[a:dir][a:id],
                                \ {
                                \ 'from' : a:from,
                                \ 'subject' : a:subject,
                                \ 'data' : a:data,
                                \ },
                        \ )
        endif
    endif


endfunction
