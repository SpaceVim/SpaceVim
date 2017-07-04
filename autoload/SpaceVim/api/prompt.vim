let s:self = {}


let s:self._keys = {
            \ 'close' : 27,
            \ 'cursor_back' : '<Left>',
            \ 'cursor_forword' : '<Right>',
            \ }
let s:self._prompt = {
            \ 'mpt' : '==>',
            \ 'begin' : '',
            \ 'cursor' : '',
            \ 'end' : '',
            \ }
" '==>'

let s:self.__closed = 1

let s:self._handle_fly = ''
let s:self._onclose = ''



func! s:self.open() abort
    call self._build_prompt()
    call self._handle_input()
endf

func! s:self._handle_input() abort
    while self.__closed
        let char = getchar()
        if char ==# "\<Right>" || char == 6
            let self._prompt.begin = self._prompt.begin . self._prompt.cursor
            let self._prompt.cursor = matchstr(self._prompt.end, '^.')
            let self._prompt.end = substitute(self._prompt.end, '^.', '', 'g')
            call self._build_prompt()
        elseif char ==# "\<Left>"  || char == 2
            if self._prompt.begin !=# ''
                let self._prompt.end = self._prompt.cursor . self._prompt.end
                let self._prompt.cursor = matchstr(self._prompt.begin, '.$')
                let self._prompt.begin = substitute(self._prompt.begin, '.$', '', 'g')
                call self._build_prompt()
            endif
        elseif char == self._keys.close
            let self.__closed = 0
            if self._onclose !=# ''
                call call(self._onclose, [])
            endif
            call self._clear_prompt()
        else
            let self._prompt.begin .= nr2char(char)
            call self._build_prompt()
            if self._handle_fly !=# ''
                call call(self._handle_fly, [self._prompt.begin . self._prompt.cursor . self._prompt.end])
            endif
        endif
    endwhile
    let self.__closed = 1
endf

func! s:self._build_prompt() abort
    redraw!
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
