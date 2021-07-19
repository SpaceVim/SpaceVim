function! vlime#contrib#presentation_streams#Init(conn)
    call a:conn.Send(
                \ a:conn.EmacsRex(
                    \ [vlime#SYM('SWANK', 'INIT-PRESENTATION-STREAMS')]),
                \ function('vlime#SimpleSendCB',
                    \ [a:conn, v:null, 'vlime#contrib#presentation_streams#Init']))
endfunction
