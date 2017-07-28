scriptencoding utf-8
let s:PASSWORD = SpaceVim#api#import('password')
let s:NUMBER = SpaceVim#api#import('data#number')
let s:LIST = SpaceVim#api#import('data#list')

function! SpaceVim#layers#edit#plugins() abort
    let plugins = [
                \ ['tpope/vim-surround'],
                \ ['junegunn/vim-emoji'],
                \ ['terryma/vim-multiple-cursors'],
                \ ['terryma/vim-expand-region', { 'loadconf' : 1}],
                \ ['kana/vim-textobj-user'],
                \ ['kana/vim-textobj-indent'],
                \ ['kana/vim-textobj-line'],
                \ ['kana/vim-textobj-entire'],
                \ ['scrooloose/nerdcommenter', { 'loadconf' : 1}],
                \ ['mattn/emmet-vim',                        { 'on_cmd' : 'EmmetInstall'}],
                \ ['gcmt/wildfire.vim',{'on_map' : '<Plug>(wildfire-'}],
                \ ['easymotion/vim-easymotion'],
                \ ['haya14busa/vim-easyoperator-line'],
                \ ['editorconfig/editorconfig-vim', { 'on_cmd' : 'EditorConfigReload'}],
                \ ['floobits/floobits-neovim',      { 'on_cmd' : ['FlooJoinWorkspace','FlooShareDirPublic','FlooShareDirPrivate']}],
                \ ]
    if executable('fcitx')
        call add(plugins,['lilydjwg/fcitx.vim',        { 'on_event' : 'InsertEnter'}])
    endif
    return plugins
endfunction

function! SpaceVim#layers#edit#config() abort
    let g:multi_cursor_next_key=get(g:, 'multi_cursor_next_key', '<C-j>')
    let g:multi_cursor_prev_key=get(g:, 'multi_cursor_prev_key', '<C-k>')
    let g:multi_cursor_skip_key=get(g:, 'multi_cursor_skip_key', '<C-x>')
    let g:multi_cursor_quit_key=get(g:, 'multi_cursor_quit_key', '<Esc>')
    let g:user_emmet_install_global = 0
    let g:user_emmet_leader_key=get(g:, 'user_emmet_leader_key', '<C-e>')
    let g:user_emmet_mode='a'
    let g:user_emmet_settings = {
                \  'jsp' : {
                \      'extends' : 'html',
                \  },
                \}
    "noremap <SPACE> <Plug>(wildfire-fuel)
    vnoremap <C-SPACE> <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']
    let g:_spacevim_mappings_space.x = {'name' : '+Text'}
    let g:_spacevim_mappings_space.x.a = {'name' : '+align'}
    let g:_spacevim_mappings_space.x.d = {'name' : '+delete'}
    let g:_spacevim_mappings_space.x.i = {'name' : '+change symbol style'}
    nnoremap <silent> <Plug>CountSelectionRegion :call <SID>count_selection_region()<Cr>
    xnoremap <silent> <Plug>CountSelectionRegion :<C-u>call <SID>count_selection_region()<Cr>
    call SpaceVim#mapping#space#def('nmap', ['x', 'c'], '<Plug>CountSelectionRegion', 'cunt in the selection region', 0, 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '&'], 'Tabularize /&', 'align region at &', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '('], 'Tabularize /(', 'align region at (', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ')'], 'Tabularize /)', 'align region at )', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '['], 'Tabularize /[', 'align region at [', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ']'], 'Tabularize /]', 'align region at ]', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '{'], 'Tabularize /{', 'align region at {', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '}'], 'Tabularize /}', 'align region at }', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ','], 'Tabularize /,', 'align region at ,', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '.'], 'Tabularize /.', 'align region at .', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ':'], 'Tabularize /:', 'align region at :', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ';'], 'Tabularize /;', 'align region at ;', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '='], 'Tabularize /=', 'align region at =', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '¦'], 'Tabularize /¦', 'align region at ¦', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', 'w'], 'StripWhitespace', 'delete trailing whitespaces', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', '[SPC]'], 'silent call call('
                \ . string(s:_function('s:delete_extra_space')) . ', [])',
                \ 'delete extra space arround cursor', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'c'], 'silent call call('
                \ . string(s:_function('s:lowerCamelCase')) . ', [])',
                \ 'change symbol style to lowerCamelCase', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'C'], 'silent call call('
                \ . string(s:_function('s:UpperCamelCase')) . ', [])',
                \ 'change symbol style to UpperCamelCase', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', '_'], 'silent call call('
                \ . string(s:_function('s:under_score')) . ', [])',
                \ 'change symbol style to under_score', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'u'], 'silent call call('
                \ . string(s:_function('s:under_score')) . ', [])',
                \ 'change symbol style to under_score', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'U'], 'silent call call('
                \ . string(s:_function('s:up_case')) . ', [])',
                \ 'change symbol style to UP_CACE', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'k'], 'silent call call('
                \ . string(s:_function('s:kebab_case')) . ', [])',
                \ 'change symbol style to kebab-case', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', '-'], 'silent call call('
                \ . string(s:_function('s:kebab_case')) . ', [])',
                \ 'change symbol style to kebab-case', 1)


    let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
    let g:_spacevim_mappings_space.i.l = {'name' : '+Lorem-ipsum'}
    let g:_spacevim_mappings_space.i.p = {'name' : '+Passwords'}
    let g:_spacevim_mappings_space.i.U = {'name' : '+UUID'}
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 1], 'call call('
                \ . string(s:_function('s:insert_simple_password')) . ', [])',
                \ 'insert simple password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 2], 'call call('
                \ . string(s:_function('s:insert_stronger_password')) . ', [])',
                \ 'insert stronger password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 3], 'call call('
                \ . string(s:_function('s:insert_paranoid_password')) . ', [])',
                \ 'insert password for paranoids', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'p'], 'call call('
                \ . string(s:_function('s:insert_phonetically_password')) . ', [])',
                \ 'insert a phonetically easy password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'n'], 'call call('
                \ . string(s:_function('s:insert_numerical_password')) . ', [])',
                \ 'insert a numerical password', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'u'], 'Unite unicode', 'search and insert unicode', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'U', 'U'], 'call call('
                \ . string(s:_function('s:uuidgen_U')) . ', [])',
                \ 'uuidgen-4', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 'l'], 'call call('
                \ . string(s:_function('s:insert_lorem_ipsum_list')) . ', [])',
                \ 'insert lorem-ipsum list', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 'p'], 'call call('
                \ . string(s:_function('s:insert_lorem_ipsum_paragraph')) . ', [])',
                \ 'insert lorem-ipsum paragraph', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 's'], 'call call('
                \ . string(s:_function('s:insert_lorem_ipsum_sentence')) . ', [])',
                \ 'insert lorem-ipsum sentence', 1)
    let g:_spacevim_mappings_space.x.g = {'name' : '+translate'}
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'g', 't'], 'Ydc', 'translate current word', 1)

    " move line
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'J'], 'call call('
                \ . string(s:_function('s:move_text_down_transient_state')) . ', [])',
                \ 'move text down(enter transient state)', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 'K'], 'call call('
                \ . string(s:_function('s:move_text_up_transient_state')) . ', [])',
                \ 'move text up(enter transient state)', 1)

    " transpose
    let g:_spacevim_mappings_space.x.t = {'name' : '+transpose'}
    call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'c'], 'call call('
                \ . string(s:_function('s:transpose_with_previous')) . ', ["character"])',
                \ 'swap current character with previous one', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'w'], 'call call('
                \ . string(s:_function('s:transpose_with_previous')) . ', ["word"])',
                \ 'swap current word with previous one', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'l'], 'call call('
                \ . string(s:_function('s:transpose_with_previous')) . ', ["line"])',
                \ 'swap current line with previous one', 1)

endfunction

function! s:transpose_with_previous(type) abort
    if a:type ==# 'line'
        if line('.') > 1
            normal! kddp
        endif
    elseif a:type ==# 'word'
        let save_register = @k
        normal! "kyiw
        let cw = @k
        normal! ge"kyiw
        let tw = @k
        if cw !=# tw
            let @k = cw
            normal! viw"kp
            let @k = tw
            normal! eviw"kp
        endif
        let @k =save_register
    elseif a:type ==# 'character'
        if col('.') > 1
            let save_register_k = @k
            let save_register_m = @m
            normal! v"kyhv"myv"kplv"mp
            let @k =save_register_k
            let @m =save_register_m
        endif
    endif
endfunction

function! s:move_text_down_transient_state() abort   
    normal! ddp
    call s:text_transient_state()
endfunction

function! s:move_text_up_transient_state() abort
    normal! ddkP
    call s:text_transient_state()
endfunction

function! s:text_transient_state() abort
    let state = SpaceVim#api#import('transient_state') 
    call state.set_title('Move Text Transient State')
    call state.defind_keys(
                \ {
                \ 'layout' : 'vertical split',
                \ 'left' : [
                \ {
                \ 'key' : 'J',
                \ 'desc' : 'move text down',
                \ 'func' : '',
                \ 'cmd' : 'normal! "_ddp',
                \ 'exit' : 0,
                \ },
                \ ],
                \ 'right' : [
                \ {
                \ 'key' : 'K',
                \ 'desc' : 'move text up',
                \ 'func' : '',
                \ 'cmd' : 'normal! "_ddkP',
                \ 'exit' : 0,
                \ },
                \ ],
                \ }
                \ )
    call state.open()
endfunction

function! s:lowerCamelCase() abort
    " fooFzz
    let cword = s:parse_symbol(expand('<cword>'))
    if !empty(cword)
        let rst = [cword[0]]
        if len(cword) > 1
            let rst += map(cword[1:], "substitute(v:val, '^.', '\\u&', 'g')")
        endif
        let save_register = @k
        let save_cursor = getcurpos()
        let @k = join(rst, '')
        normal! viw"kp
        call setpos('.', save_cursor)
        let @k = save_register
    endif
endfunction

function! s:UpperCamelCase() abort
    " FooFzz
    let cword = s:parse_symbol(expand('<cword>'))
    if !empty(cword)
        let rst = map(cword, "substitute(v:val, '^.', '\\u&', 'g')")
        let save_register = @k
        let save_cursor = getcurpos()
        let @k = join(rst, '')
        normal! viw"kp
        call setpos('.', save_cursor)
        let @k = save_register
    endif
endfunction

function! s:kebab_case() abort
    " foo-fzz
    let cword = s:parse_symbol(expand('<cword>'))
    if !empty(cword)
        let save_register = @k
        let save_cursor = getcurpos()
        let @k = join(cword, '-')
        normal! viw"kp
        call setpos('.', save_cursor)
        let @k = save_register
    endif
endfunction

function! s:under_score() abort
    " foo_fzz
    let cword = s:parse_symbol(expand('<cword>'))
    if !empty(cword)
        let save_register = @k
        let save_cursor = getcurpos()
        let @k = join(cword, '_')
        normal! viw"kp
        call setpos('.', save_cursor)
        let @k = save_register
    endif
endfunction

function! s:up_case() abort
    " FOO_FZZ
    let cword =map(s:parse_symbol(expand('<cword>')), 'toupper(v:val)')
    if !empty(cword)
        let save_register = @k
        let save_cursor = getcurpos()
        let @k = join(cword, '_')
        normal! viw"kp
        call setpos('.', save_cursor)
        let @k = save_register
    endif
endfunction

let s:STRING = SpaceVim#api#import('data#string')
function! s:parse_symbol(symbol) abort
    if a:symbol =~# '^[a-z]\+\(-[a-zA-Z]\+\)*$'
        return split(a:symbol, '-')
    elseif a:symbol =~# '^[a-z]\+\(_[a-zA-Z]\+\)*$'
        return split(a:symbol, '_')
    elseif a:symbol =~# '^[a-z]\+\([A-Z][a-z]\+\)*$'
        let chars = s:STRING.string2chars(a:symbol)
        let rst = []
        let word = ''
        for char in chars
            if char =~# '[a-z]'
                let word .= char
            else
                call add(rst, tolower(word))
                let word = char
            endif
        endfor
        call add(rst, tolower(word))
        return rst
    elseif a:symbol =~# '^[A-Z][a-z]\+\([A-Z][a-z]\+\)*$'
        let chars = s:STRING.string2chars(a:symbol)
        let rst = []
        let word = ''
        for char in chars
            if char =~# '[a-z]'
                let word .= char
            else
                if !empty(word)
                    call add(rst, tolower(word))
                endif
                let word = char
            endif
        endfor
        call add(rst, tolower(word))
        return rst
    else
        return [a:symbol]
    endif
endfunction

function! s:count_selection_region() abort
    call feedkeys("gvg\<c-g>\<Esc>", 'ti')
endfunction


function! s:delete_extra_space() abort
    if !empty(getline('.'))
        if getline('.')[col('.')-1] ==# ' '
            exe "normal! viw\"_di\<Space>\<Esc>"
        endif
    endif
endfunction
let s:local_lorem_ipsum = [
            \ 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
            \ 'Donec hendrerit tempor tellus.',
            \ 'Donec pretium posuere tellus.',
            \ 'Proin quam nisl, tincidunt et, mattis eget, convallis nec, purus.',
            \ 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
            \ 'Nulla posuere.',
            \ 'Donec vitae dolor.',
            \ 'Nullam tristique diam non turpis.',
            \ 'Cras placerat accumsan nulla.',
            \ 'Nullam rutrum.',
            \ 'Nam vestibulum accumsan nisl.',
            \ 'Pellentesque dapibus suscipit ligula.',
            \ 'Donec posuere augue in quam.',
            \ 'Etiam vel tortor sodales tellus ultricies commodo.',
            \ 'Suspendisse potenti.',
            \ 'Aenean in sem ac leo mollis blandit.',
            \ 'Donec neque quam, dignissim in, mollis nec, sagittis eu, wisi.',
            \ 'Phasellus lacus.',
            \ 'Etiam laoreet quam sed arcu.',
            \ 'Phasellus at dui in ligula mollis ultricies.',
            \ 'Integer placerat tristique nisl.',
            \ 'Praesent augue.',
            \ 'Fusce commodo.',
            \ 'Vestibulum convallis, lorem a tempus semper, dui dui euismod elit, vitae placerat urna tortor vitae lacus.',
            \ 'Nullam libero mauris, consequat quis, varius et, dictum id, arcu.',
            \ 'Mauris mollis tincidunt felis.',
            \ 'Aliquam feugiat tellus ut neque.',
            \ 'Nulla facilisis, risus a rhoncus fermentum, tellus tellus lacinia purus, et dictum nunc justo sit amet elit.',
            \ 'Aliquam erat volutpat.',
            \ 'Nunc eleifend leo vitae magna.',
            \ 'In id erat non orci commodo lobortis.',
            \ 'Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.',
            \ 'Sed diam.',
            \ 'Praesent fermentum tempor tellus.',
            \ 'Nullam tempus.',
            \ 'Mauris ac felis vel velit tristique imperdiet.',
            \ 'Donec at pede.',
            \ 'Etiam vel neque nec dui dignissim bibendum.',
            \ 'Vivamus id enim.',
            \ 'Phasellus neque orci, porta a, aliquet quis, semper a, massa.',
            \ 'Phasellus purus.',
            \ 'Pellentesque tristique imperdiet tortor.',
            \ 'Nam euismod tellus id erat.',
            \ 'Nullam eu ante vel est convallis dignissim.',
            \ 'Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio.',
            \ 'Nunc porta vulputate tellus.',
            \ 'Nunc rutrum turpis sed pede.',
            \ 'Sed bibendum.',
            \ 'Aliquam posuere.',
            \ 'Nunc aliquet, augue nec adipiscing interdum, lacus tellus malesuada massa, quis varius mi purus non odio.',
            \ 'Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.',
            \ 'Curabitur vulputate vestibulum lorem.',
            \ 'Fusce sagittis, libero non molestie mollis, magna orci ultrices dolor, at vulputate neque nulla lacinia eros.',
            \ 'Sed id ligula quis est convallis tempor.',
            \ 'Curabitur lacinia pulvinar nibh.',
            \ 'Nam a sapien.',
            \ ]

let s:lorem_ipsum_paragraph_separator = "\n\n"
let s:lorem_ipsum_sentence_separator = '  '
let s:lorem_ipsum_list_beginning = ''
let s:lorem_ipsum_list_bullet = '* '
let s:lorem_ipsum_list_item_end = "\n"
let s:lorem_ipsum_list_end = ''

function! s:insert_lorem_ipsum_list() abort
    let save_register = @k
    let @k =  '* ' . s:local_lorem_ipsum[s:NUMBER.random(0, len(s:local_lorem_ipsum))] . "\n"
    normal! "kgP
    let @k = save_register
endfunction

function! s:insert_lorem_ipsum_paragraph() abort
    let save_register = @k
    let pids = len(s:local_lorem_ipsum) / 11
    let pid = s:NUMBER.random(0, pids) * 11
    let @k = join(s:LIST.listpart(s:local_lorem_ipsum, pid, 11), s:lorem_ipsum_sentence_separator) . s:lorem_ipsum_paragraph_separator
    normal! "kgP
    let @k = save_register
endfunction

function! s:insert_lorem_ipsum_sentence() abort
    let save_register = @k
    let @k =  s:local_lorem_ipsum[s:NUMBER.random(0, len(s:local_lorem_ipsum))] . s:lorem_ipsum_sentence_separator
    normal! "kgP
    let @k = save_register
endfunction

function! s:insert_simple_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_simple(8)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_stronger_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_strong(12)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_paranoid_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_paranoid(20)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_numerical_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_numeric(4)
    normal! "kPl
    let @k = save_register
endfunction
function! s:insert_phonetically_password() abort
    let save_register = @k
    let @k = s:PASSWORD.generate_phonetic(8)
    normal! "kPl
    let @k = save_register
endfunction

function! s:uuidgen_U() abort
    let uuid = system('uuidgen')
    let save_register = @k
    let @k = uuid
    normal! "kPl
    let @k = save_register
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
    function! s:_function(fstr) abort
        return function(a:fstr)
    endfunction
else
    function! s:_SID() abort
        return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
    endfunction
    let s:_s = '<SNR>' . s:_SID() . '_'
    function! s:_function(fstr) abort
        return function(substitute(a:fstr, 's:', s:_s, 'g'))
    endfunction
endif

augroup spacevim_layer_edit
    au!
    autocmd BufNewFile *.py call <SID>add_buffer_head()
augroup END
let s:ft_head_tp = {}
function! s:add_buffer_head() abort
    if has_key(s:ft_head_tp, &ft)
        call setline(1, s:ft_head_tp[&ft])
    endif
endfunction

function! SpaceVim#layers#edit#add_ft_head_tamplate(ft, tamp)
    call extend(s:ft_head_tp, {a:ft : a:tamp})
endfunction
