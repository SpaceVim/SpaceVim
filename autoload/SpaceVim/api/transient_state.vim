let s:self = {}

let s:self._keys = {}
let s:self._on_syntax = ''
let s:self._title = 'Transient State'

function! s:self.open() abort
    noautocmd rightbelow split __transient_state__
    let self._bufid = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
    " let save_tve = &t_ve
    " setlocal t_ve=
    " setlocal nomodifiable
    " setf SpaceVimFlyGrep
    " let &t_ve = save_tve
    if !empty(self._on_syntax) && type(self._on_syntax) ==# 2
        call call(self._on_syntax, [])
    else
        hi def link SpaceVim_Transient_State_Exit Keyword
        hi def link SpaceVim_Transient_State_Notexit Number
        hi def link SpaceVim_Transient_State_Title Title
    endif
    call setline(1, self._title)
    call append(line('$'), '')
    call self.highlight_title()
    call self._update_content()
    call append(line('$'), '')
    call append(line('$'), '[KEY] exits state   [KEY] will not exit')
    call self.highlight_keys(1, line('$') - 1, 1, 4)
    call self.highlight_keys(0, line('$') - 1, 21, 24)
    " move to prvious window
    wincmd w
    redraw!
    while 1
        let char = getchar()
        if char ==# "\<FocusLost>" || char ==# "\<FocusGained>" || char2nr(char) == 128
            continue
        endif
        if !has_key(self._keys, char)
            break
        endif
    endwhile
    exe 'bd ' . self._bufid
endfunction

function! s:self.defind_keys(dict) abort
    let self._keys = a:dict
endfunction

function! s:self.set_syntax(func) abort
    let self._on_syntax = a:func
endfunction

function! s:self.set_title(title) abort
    let self._title = a:title
endfunction

function! s:self.highlight_keys(exit, line, begin, end) abort
    if a:exit
        call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Exit', a:line, a:begin, a:end)
    else
        call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Notexit', a:line, a:begin, a:end)
    endif
endfunction

function! s:self.highlight_title() abort
    call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Title', 0, 0, len(self._title))
endfunction

function! s:self._update_content() abort
    
endfunction

function! SpaceVim#api#transient_state#get() abort
    return deepcopy(s:self)
endfunction
