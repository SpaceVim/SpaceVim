""
" @dict VlimeConnection.FuzzyCompletions
" @usage {symbol} [callback]
" @public
"
" Get a completion list for {symbol}, using a more clever fuzzy algorithm.
" {symbol} should be a plain string containing a (partial) symbol name.
"
" This method needs the SWANK-FUZZY contrib module. See
" @function(VlimeConnection.SwankRequire).
function! vlime#contrib#fuzzy#FuzzyCompletions(symbol, ...) dict
    let Callback = get(a:000, 0, v:null)
    let cur_package = self.GetCurrentPackage()
    if type(cur_package) != type(v:null)
        let cur_package = cur_package[0]
    endif
    call self.Send(self.EmacsRex(
                    \ [vlime#SYM('SWANK', 'FUZZY-COMPLETIONS'), a:symbol, cur_package]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#contrib#fuzzy#FuzzyCompletions']))
endfunction

function! vlime#contrib#fuzzy#Init(conn)
    let a:conn['FuzzyCompletions'] =
                \ function('vlime#contrib#fuzzy#FuzzyCompletions')
endfunction
