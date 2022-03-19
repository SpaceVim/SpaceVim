function! s:maybe_map_scope(scopestr) abort
    if !empty(g:tagbar_scopestrs)
        if has_key(g:tagbar_scopestrs, a:scopestr)
            return g:tagbar_scopestrs[a:scopestr]
        endif
    endif
    return a:scopestr
endfunction

function! tagbar#prototypes#normaltag#new(name) abort
    let newobj = tagbar#prototypes#basetag#new(a:name)

    let newobj.isNormalTag = function(s:add_snr('s:isNormalTag'))
    let newobj.strfmt = function(s:add_snr('s:strfmt'))
    let newobj.str = function(s:add_snr('s:str'))
    let newobj.getPrototype = function(s:add_snr('s:getPrototype'))
    let newobj.getDataType = function(s:add_snr('s:getDataType'))

    return newobj
endfunction

" s:isNormalTag() {{{1
function! s:isNormalTag() abort dict
    return 1
endfunction

" s:strfmt() {{{1
function! s:strfmt() abort dict
    let typeinfo = self.typeinfo

    let suffix = get(self.fields, 'signature', '')
    if has_key(self.fields, 'type')
        let suffix .= ' : ' . self.fields.type
    elseif has_key(get(typeinfo, 'kind2scope', {}), self.fields.kind)
        let scope = s:maybe_map_scope(typeinfo.kind2scope[self.fields.kind])
        if !g:tagbar_show_data_type
            let suffix .= ' : ' . scope
        endif
    endif
    let prefix = self._getPrefix()

    if g:tagbar_show_data_type && self.getDataType() !=# ''
        let suffix .= ' : ' . self.getDataType()
    endif

    if g:tagbar_show_tag_linenumbers == 1
        let suffix .= ' [' . self.fields.line . ']'
    elseif g:tagbar_show_tag_linenumbers == 2
        let prefix .= '[' . self.fields.line . '] '
    endif

    return prefix . self.name . suffix
endfunction

" s:str() {{{1
function! s:str(longsig, full) abort dict
    if a:full && self.path !=# ''
        let str = self.path . self.typeinfo.sro . self.name
    else
        let str = self.name
    endif

    if has_key(self.fields, 'signature')
        if a:longsig
            let str .= self.fields.signature
        else
            let str .= '()'
        endif
    endif

    return str
endfunction

" s:getPrototype() {{{1
function! s:getPrototype(short) abort dict
    if self.prototype !=# ''
        let prototype = self.prototype
    else
        let bufnr = self.fileinfo.bufnr

        if self.fields.line == 0 || !bufloaded(bufnr)
            " No linenumber available or buffer not loaded (probably due to
            " 'nohidden'), try the pattern instead
            return substitute(self.pattern, '^\\M\\^\\C\s*\(.*\)\\$$', '\1', '')
        endif

        let line = getbufline(bufnr, self.fields.line)[0]
        " If prototype includes declaration, remove the '=' and anything after
        " FIXME: Need to remove this code. This breaks python prototypes that
        " can include a '=' in the function paramter list.
        "   ex: function(arg1, optional_arg2=False)
        " let line = substitute(line, '\s*=.*', '', '')
        let list = split(line, '\zs')

        let start = index(list, '(')
        if start == -1
            return substitute(line, '^\s\+', '', '')
        endif

        let opening = count(list, '(', 0, start)
        let closing = count(list, ')', 0, start)
        if closing >= opening
            return substitute(line, '^\s\+', '', '')
        endif

        let balance = opening - closing

        let prototype = line
        let curlinenr = self.fields.line + 1
        while balance > 0 && curlinenr < line('$')
            let curline = getbufline(bufnr, curlinenr)[0]
            let curlist = split(curline, '\zs')
            let balance += count(curlist, '(')
            let balance -= count(curlist, ')')
            let prototype .= "\n" . curline
            let curlinenr += 1
        endwhile

        let self.prototype = prototype
    endif

    if a:short
        " join all lines and remove superfluous spaces
        let prototype = substitute(prototype, '^\s\+', '', '')
        let prototype = substitute(prototype, '\_s\+', ' ', 'g')
        let prototype = substitute(prototype, '(\s\+', '(', 'g')
        let prototype = substitute(prototype, '\s\+)', ')', 'g')
        " Avoid hit-enter prompts
        let maxlen = &columns - 12
        if len(prototype) > maxlen
            let prototype = prototype[:maxlen - 1 - 3]
            let prototype .= '...'
        endif
    endif

    return prototype
endfunction

" s:getDataType() {{{1
function! s:getDataType() abort dict
    if self.data_type !=# ''
        let data_type = self.data_type
    else
        " This is a fallthrough attempt to derive the data_type from the line
        " in the event ctags doesn't return the typeref field
        let bufnr = self.fileinfo.bufnr

        if self.fields.line == 0 || !bufloaded(bufnr)
            " No linenumber available or buffer not loaded (probably due to
            " 'nohidden'), try the pattern instead
            return substitute(self.pattern, '^\\M\\^\\C\s*\(.*\)\\$$', '\1', '')
        endif

        let line = getbufline(bufnr, self.fields.line)[0]
        let data_type = substitute(line, '\s*' . escape(self.name, '~') . '.*', '', '')

        " Strip off the path if we have one along with any spaces prior to the
        " path
        if self.path !=# ''
            let data_type = substitute(data_type, '\s*' . self.path . self.typeinfo.sro, '', '')
        endif

        " Strip off leading spaces
        let data_type = substitute(data_type, '^\s\+', '', '')

        let self.data_type = data_type
    endif

    return data_type
endfunction

" s:add_snr() {{{1
function! s:add_snr(funcname) abort
    if !exists('s:snr')
        let s:snr = matchstr(expand('<sfile>'), '<SNR>\d\+_\zeget_snr$')
    endif
    return s:snr . a:funcname
endfunction

" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
