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
    wincmd p
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

if has('nvim')
    function! s:self.highlight_keys(exit, line, begin, end) abort
        if a:exit
            call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Exit', a:line, a:begin, a:end)
        else
            call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Notexit', a:line, a:begin, a:end)
        endif
    endfunction
else
    function! s:self.highlight_keys(exit, line, begin, end) abort
        if a:exit
            call matchaddpos('SpaceVim_Transient_State_Exit', [[a:line + 1, a:begin + 1, a:end - a:begin]])
        else
            call matchaddpos('SpaceVim_Transient_State_Notexit', [[a:line + 1, a:begin + 1, a:end - a:begin]])
        endif
    endfunction
endif

if has('nvim')
    function! s:self.highlight_title() abort
        call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Title', 0, 0, len(self._title))
    endfunction
else
    function! s:self.highlight_title() abort
        call matchaddpos('SpaceVim_Transient_State_Title', [1])
    endfunction
endif

function! s:self._update_content() abort
    if get(self._keys, 'layout', '') == 'vertical split'
        let linenum = max([len(self._keys.right), len(self._keys.left)])
        let left_max_key_len = 0
        for key in self._keys.left
            if type(key.key) == 1   " is a string
                let left_max_key_len = max([len(key.key), left_max_key_len])
            elseif type(key.key) == 3  " is a list
                let left_max_key_len = max([len(join(key.key, '/')), left_max_key_len])
            elseif type(key.key) == 4  " is a list
                let left_max_key_len = max([len(key.key.name), left_max_key_len])
            endif
        endfor
        let right_max_key_len = 0
        for key in self._keys.right
            if type(key.key) == 1   " is a string
                let right_max_key_len = max([len(key.key), right_max_key_len])
            elseif type(key.key) == 3  " is a list
                let g:wsd = key.key
                let right_max_key_len = max([len(join(key.key, '/')), right_max_key_len])
            elseif type(key.key) == 4  " is a list
                let right_max_key_len = max([len(key.key.name), right_max_key_len])
            endif
        endfor
        for i in range(linenum)
            let left = get(self._keys.left, i)
            let right = get(self._keys.right, i)
            let line = ''
            if !empty(left)
                if type(left.key) == 1
                    let line .= '[' . left.key . '] ' . repeat(' ', left_max_key_len - len(left.key)) . left.desc 
                    call self.highlight_keys(left.exit, i + 2, 1, 1 + len(left.key))
                    if !empty(left.cmd)
                        call extend(self._handle_inputs, {left.key : left.cmd})
                    elseif !empty(left.func)
                        call extend(self._handle_inputs, {left.key : left.func})
                    endif
                elseif type(left.key) == 3
                elseif type(left.key) == 4
                    let line .= '[' . left.key.name . '] '
                    let line .= repeat(' ', left_max_key_len - len(left.key.name))
                    let line .= left.desc 
                    for pos in left.key.pos
                        call self.highlight_keys(left.exit, i + 2, pos[0], pos[1])
                    endfor
                    for handles in left.key.handles
                        call extend(self._handle_inputs, {handles[0] : handles[1]})
                    endfor
                endif
            endif
            let line .= repeat(' ', 40 - len(line))
            if !empty(right)
                if type(right.key) == 1
                    let line .= '[' . right.key . '] ' . repeat(' ', right_max_key_len - len(right.key)) . right.desc 
                    call self.highlight_keys(right.exit, i + 2, 41, 41 + len(right.key))
                    if !empty(right.cmd)
                        call extend(self._handle_inputs, {right.key : right.cmd})
                    elseif !empty(right.func)
                        call extend(self._handle_inputs, {right.key : right.func})
                    endif
                elseif type(right.key) == 3
                    let line .= '[' . join(right.key, '/') . '] '
                    let line .= repeat(' ', right_max_key_len - len(join(right.key, '/')))
                    let line .= right.desc 
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
