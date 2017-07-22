let s:self = {}

let s:self._keys = {}
let s:self._on_syntax = ''
let s:self._title = 'Transient State'
let s:self._handle_inputs = {}

function! s:self.open() abort
    noautocmd botright split __transient_state__
    let self._bufid = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
    set filetype=TransientState
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
    let b:transient_state_title = self._title
    call append(line('$'), '')
    call self.highlight_title()
    call self._update_content()
    call append(line('$'), '')
    call append(line('$'), '[KEY] exits state   [KEY] will not exit')
    call self.highlight_keys(1, line('$') - 1, 1, 4)
    call self.highlight_keys(0, line('$') - 1, 21, 24)
    if winheight(0) > line('$')
        exe 'resize ' .  line('$')
    endif
    " move to prvious window
    wincmd w
    while 1
        redraw!
        let char = self._getchar()
        if char ==# "\<FocusLost>" || char ==# "\<FocusGained>" || char2nr(char) == 128
            continue
        endif
        if !has_key(self._handle_inputs, char)
            break
        else
            if type(self._handle_inputs[char]) == 2
                call call(self._handle_inputs[char], [])
            elseif type(self._handle_inputs[char]) == 1
                exe self._handle_inputs[char]
            endif
        endif
    endwhile
    exe 'bd ' . self._bufid
    doautocmd WinEnter
endfunction


function! s:self._getchar(...) abort
    let ret = call('getchar', a:000)
    return (type(ret) == type(0) ? nr2char(ret) : ret)
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
    if get(self._keys, 'layout', '') == 'vertical split'
        let linenum = max([len(self._keys.right), len(self._keys.left)])
        for i in range(linenum)
            let left = get(self._keys.left, i)
            let right = get(self._keys.right, i)
            let line = ''
            if !empty(left)
                if type(left.key) ==# type('')
                    let line .= '[' . left.key . '] ' . left.desc 
                    call self.highlight_keys(left.exit, i + 2, 1, 1 + len(left.key))
                    if !empty(left.cmd)
                        call extend(self._handle_inputs, {left.key : left.cmd})
                    elseif !empty(left.func)
                        call extend(self._handle_inputs, {left.key : left.func})
                    endif
                endif
            endif
            let line .= repeat(' ', 40 - len(line))
            if !empty(right)
                if type(right.key) == 1
                    let line .= '[' . right.key . '] ' . right.desc 
                    call self.highlight_keys(right.exit, i + 2, 41, 41 + len(right.key))
                    if !empty(right.cmd)
                        call extend(self._handle_inputs, {right.key : right.cmd})
                    elseif !empty(right.func)
                        call extend(self._handle_inputs, {right.key : right.func})
                    endif
                elseif type(right.key) == 3
                    let line .= '[' . join(right.key, '/') . '] ' . right.desc 
                    let begin = 41
                    for key in right.key
                        call self.highlight_keys(right.exit, i + 2, begin, begin + len(key))
                        let begin = begin + len(key) + 1
                    endfor
                    if !empty(right.cmd)
                        for key in right.key
                            call extend(self._handle_inputs, {key : right.cmd})
                        endfor
                    elseif !empty(right.func)
                        for key in right.key
                            call extend(self._handle_inputs, {key : right.func})
                        endfor
                    endif
                endif
            endif
            call append(line('$'), line)
        endfor
    endif
endfunction

function! SpaceVim#api#transient_state#get() abort
    return deepcopy(s:self)
endfunction
