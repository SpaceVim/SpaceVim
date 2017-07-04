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



func! s:self.open() abort
    call self._handle_input()
endf

func! s:self._handle_input() abort
    while self.__closed
        let char = getchar()
        if char == self._keys.close
            let self.__closed = 0
        elseif char ==# "\<Right>" || char == 6
            let self._prompt.begin = self._prompt.begin . self._prompt.cursor
            let self._prompt.cursor = matchstr(self._prompt.end, '^.')
            let self._prompt.end = substitute(self._prompt.end, '^.', '', 'g')
        elseif char ==# "\<Left>"  || char == 2
            if self._prompt.begin !=# ''
                let self._prompt.end = self._prompt.cursor . self._prompt.end
                let self._prompt.cursor = matchstr(self._prompt.begin, '.$')
                let self._prompt.begin = substitute(self._prompt.begin, '.$', '', 'g')
            endif
        else
            let self._prompt.begin .= nr2char(char)
        endif
        call self._build_prompt()
        if self._handle_fly !=# ''
            call call(self._handle_fly, [self._prompt.begin . self._prompt.cursor . self._prompt.end])
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

function! SpaceVim#api#prompt#get() abort
    return deepcopy(s:self)
endfunction
