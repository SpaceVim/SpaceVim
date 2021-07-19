if !exists('g:vlime_contrib_initializers')
    let g:vlime_contrib_initializers = {
                \ 'SWANK-REPL': function('vlime#contrib#repl#Init'),
                \ 'SWANK-MREPL': function('vlime#contrib#mrepl#Init'),
                \ 'SWANK-PRESENTATIONS': function('vlime#contrib#presentations#Init'),
                \ 'SWANK-PRESENTATION-STREAMS': function('vlime#contrib#presentation_streams#Init'),
                \ 'SWANK-FUZZY': function('vlime#contrib#fuzzy#Init'),
                \ 'SWANK-ARGLISTS': function('vlime#contrib#arglists#Init'),
                \ 'SWANK-TRACE-DIALOG': function('vlime#contrib#trace_dialog#Init'),
                \ }
endif

" vlime#contrib#CallInitializers(conn[, contribs[, callback]])
function! vlime#contrib#CallInitializers(conn, ...)
    let contribs = get(a:000, 0, v:null)
    let Callback = get(a:000, 1, v:null)

    if type(contribs) == type(v:null)
        let contribs = get(a:conn.cb_data, 'contribs', [])
    endif

    for c in contribs
        let InitFunc = get(g:vlime_contrib_initializers, c, v:null)
        if type(InitFunc) != v:t_func && exists('g:vlime_user_contrib_initializers')
            let InitFunc = get(g:vlime_user_contrib_initializers, c, v:null)
        endif
        if type(InitFunc) == v:t_func
            let ToCall = function(InitFunc, [a:conn])
            call ToCall()
        endif
    endfor

    if type(Callback) == v:t_func
        let ToCall = function(Callback, [a:conn])
        call ToCall()
    endif
endfunction
