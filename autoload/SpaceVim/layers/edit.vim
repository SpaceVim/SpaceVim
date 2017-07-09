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
    let g:multi_cursor_next_key='<C-j>'
    let g:multi_cursor_prev_key='<C-k>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'
    let g:user_emmet_install_global = 0
    let g:user_emmet_leader_key='<C-e>'
    let g:user_emmet_mode='a'
    let g:user_emmet_settings = {
                \  'jsp' : {
                \      'extends' : 'html',
                \  },
                \}
    "noremap <SPACE> <Plug>(wildfire-fuel)
    vnoremap <C-SPACE> <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']
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
