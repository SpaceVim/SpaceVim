""
" @dict VlimeConnection.Autodoc
" @usage {raw_form} [margin] [callback]
" @public
"
" Get the arglist description for {raw_form}. {raw_form} should be a value
" returned by @function(vlime#ui#CurRawForm) or @function(vlime#ToRawForm).
" See the source of SWANK:AUTODOC for an explanation of the raw forms.
" [margin], if specified and not v:null, gives the line width to wrap to.
"
" This method needs the SWANK-ARGLISTS contrib module. See
" @function(VlimeConnection.SwankRequire).
function! vlime#contrib#arglists#Autodoc(raw_form, ...) dict
    let margin = get(a:000, 0, v:null)
    let Callback = get(a:000, 1, v:null)
    let cmd = (type(margin) == type(v:null)) ?
                \ [vlime#SYM('SWANK', 'AUTODOC'), a:raw_form] :
                \ [vlime#SYM('SWANK', 'AUTODOC'), a:raw_form,
                    \ vlime#KW('PRINT-RIGHT-MARGIN'), margin]
    call self.Send(self.EmacsRex(cmd),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#contrib#arglists#Autodoc']))
endfunction

function! vlime#contrib#arglists#Init(conn)
    let a:conn['Autodoc'] = function('vlime#contrib#arglists#Autodoc')
endfunction
