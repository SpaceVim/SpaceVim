let s:self = {}


let s:self._keys = {
            \ 'close' : "\<Esc>",
            \ 'cursor_back' : '<Left>',
            \ 'cursor_forword' : '<Right>',
            \ }
let s:self._prompt = {
            \ 'mpt' : '==>',
            \ 'begin' : '',
            \ 'cursor' : '',
            \ 'end' : '',
            \ }

let s:self._handle_fly = ''
let s:self._onclose = ''
let s:self._oninputpro = ''



func! s:self.open() abort
    let save_redraw = &lazyredraw
    set nolazyredraw
    call self._build_prompt()
    call self._handle_input()
    let &lazyredraw = save_redraw
endf

function! s:self._getchar(...) abort
    let ret = call('getchar', a:000)
    return (type(ret) == type(0) ? nr2char(ret) : ret)
endfunction

func! s:self._handle_input() abort
    while 1
        let char = self._getchar()
        if char ==# "\<Right>" || char == 6
            let self._prompt.begin = self._prompt.begin . self._prompt.cursor
            let self._prompt.cursor = matchstr(self._prompt.end, '^.')
            let self._prompt.end = substitute(self._prompt.end, '^.', '', 'g')
            call self._build_prompt()
            continue
        elseif char ==# "\<Left>"  || char == 2
            if self._prompt.begin !=# ''
                let self._prompt.end = self._prompt.cursor . self._prompt.end
                let self._prompt.cursor = matchstr(self._prompt.begin, '.$')
                let self._prompt.begin = substitute(self._prompt.begin, '.$', '', 'g')
                call self._build_prompt()
            endif
            continue
        elseif char ==# "\<C-w>"
            let self._prompt.begin = substitute(self._prompt.begin,'[^\ .*]\+\s*$','','g')
            call self._build_prompt()
        elseif char ==# "\<C-u>"
            let self._prompt.begin = ''
            call self._build_prompt()
        elseif char ==# "\<bs>"
            let self._prompt.begin = substitute(self._prompt.begin,'.$','','g')
            call self._build_prompt()
        elseif char == self._keys.close
            if self._onclose !=# ''
                call call(self._onclose, [])
            endif
            call self._clear_prompt()
            normal! :
            break
        else
            let self._prompt.begin .= char
            call self._build_prompt()
        endif
        if self._oninputpro !=# ''
            call call(self._oninputpro, [])
        endif
        if self._handle_fly !=# ''
            call call(self._handle_fly, [self._prompt.begin . self._prompt.cursor . self._prompt.end])
        endif
    endwhile
endf

func! s:self._build_prompt() abort
    redraw
    echohl Comment | echon self._prompt.mpt
    echohl None | echon self._prompt.begin
    echohl Wildmenu | echon self._prompt.cursor
    echohl None | echon self._prompt.end
endf

function! s:self._clear_prompt() abort
    let self._prompt = {
                \ 'mpt' : self._prompt.mpt,
                \ 'begin' : '',
                \ 'cursor' : '',
                \ 'end' : '',
                \ }
endfunction

function! SpaceVim#api#prompt#get() abort
    return deepcopy(s:self)
endfunction
