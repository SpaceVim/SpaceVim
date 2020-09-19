""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" xTabline - Reduced version for vim-airline
" Plugin: https://github.com/mg979/vim-xtabline
" MIT License Copyright (C) 2018-2019 Gianmaria Bajo <mg1979.git@gmail.com>
" tabpagecd:
" expanded version by mg979
" MIT License Copyright (C) 2012-2013 Kana Natsuno <http://whileimautomaton.net/>
" MIT License Copyright (C) 2018-2019 Gianmaria Bajo <mg1979.git@gmail.com>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


function! airline#extensions#tabline#xtabline#init()

    let s:state = 0

    " initialize mappings
    call airline#extensions#tabline#xtabline#maps()

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Variables
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    let g:loaded_xtabline = 1
    let s:most_recent = -1
    let s:xtabline_filtering = 1

    let t:xtl_excluded = get(g:, 'airline#extensions#tabline#exclude_buffers', [])
    let t:xtl_accepted = []

    let g:xtabline_include_previews = get(g:, 'xtabline_include_previews', 1)

    let g:xtabline_alt_action = get(g:, 'xtabline_alt_action', "buffer #")


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Autocommands
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    augroup plugin-xtabline
        autocmd!

        autocmd TabNew    * call s:Do('new')
        autocmd TabEnter  * call s:Do('enter')
        autocmd TabLeave  * call s:Do('leave')
        autocmd TabClosed * call s:Do('close')

        autocmd BufEnter  * let g:xtabline_changing_buffer = 0
        autocmd BufAdd,BufDelete,BufWrite * call airline#extensions#tabline#xtabline#filter_buffers()
    augroup END


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Commands
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    com! XTabReopen call airline#extensions#tabline#xtabline#reopen_last_tab()

endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#maps()

    if !exists('g:xtabline_disable_keybindings')

        fun! s:mapkeys(keys, plug)
            if empty(mapcheck(a:keys)) && !hasmapto(a:plug)
                silent! execute 'nmap <unique> '.a:keys.' '.a:plug
            endif
        endfun

        call s:mapkeys('<F5>','<Plug>XTablineToggleTabs')
        call s:mapkeys('<leader><F5>','<Plug>XTablineToggleFiltering')
        call s:mapkeys('<BS>','<Plug>XTablineSelectBuffer')
        call s:mapkeys(']l','<Plug>XTablineNextBuffer')
        call s:mapkeys('[l','<Plug>XTablinePrevBuffer')
        call s:mapkeys('<leader>tr','<Plug>XTablineReopen')
    endif

    nnoremap <unique> <script> <Plug>XTablineToggleTabs <SID>ToggleTabs
    nnoremap <silent> <SID>ToggleTabs :call airline#extensions#tabline#xtabline#toggle_tabs()<cr>

    nnoremap <unique> <script> <Plug>XTablineToggleFiltering <SID>ToggleFiltering
    nnoremap <silent> <SID>ToggleFiltering :call airline#extensions#tabline#xtabline#toggle_buffers()<cr>

    nnoremap <unique> <script> <Plug>XTablineSelectBuffer <SID>SelectBuffer
    nnoremap <silent> <expr> <SID>SelectBuffer g:xtabline_changing_buffer ? "\<C-c>" : ":<C-u>call airline#extensions#tabline#xtabline#select_buffer(v:count)\<cr>"

    nnoremap <unique> <script> <Plug>XTablineNextBuffer <SID>NextBuffer
    nnoremap <silent> <expr> <SID>NextBuffer airline#extensions#tabline#xtabline#next_buffer(v:count1)

    nnoremap <unique> <script> <Plug>XTablinePrevBuffer <SID>PrevBuffer
    nnoremap <silent> <expr> <SID>PrevBuffer airline#extensions#tabline#xtabline#prev_buffer(v:count1)

    nnoremap <unique> <script> <Plug>XTablineReopen <SID>ReopenLastTab
    nnoremap <silent> <SID>ReopenLastTab :XTabReopen<cr>

    if get(g:, 'xtabline_cd_commands', 0)
        map <unique> <leader>cdc <Plug>XTablineCdCurrent
        map <unique> <leader>cdd <Plug>XTablineCdDown1
        map <unique> <leader>cd2 <Plug>XTablineCdDown2
        map <unique> <leader>cd3 <Plug>XTablineCdDown3
        map <unique> <leader>cdh <Plug>XTablineCdHome
        nnoremap <unique> <script> <Plug>XTablineCdCurrent :cd %:p:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdDown1   :cd %:p:h:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdDown2   :cd %:p:h:h:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdDown3   :cd %:p:h:h:h:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdHome    :cd ~<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
    endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#toggle_tabs()
    """Toggle between tabs/buffers tabline."""

    if tabpagenr("$") == 1 | call airline#util#warning("There is only one tab.") | return | endif

    if g:airline#extensions#tabline#show_tabs
        let g:airline#extensions#tabline#show_tabs = 0
        call airline#util#warning("Showing buffers")
    else
        let g:airline#extensions#tabline#show_tabs = 1
        call airline#util#warning("Showing tabs")
    endif

    doautocmd BufAdd
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#toggle_buffers()
    """Toggle buffer filtering in the tabline."""

    if s:xtabline_filtering
        let s:xtabline_filtering = 0
        let g:airline#extensions#tabline#exclude_buffers = []
        call airline#util#warning("Buffer filtering turned off")
        doautocmd BufAdd
    else
        let s:xtabline_filtering = 1
        call airline#extensions#tabline#xtabline#filter_buffers()
        call airline#util#warning("Buffer filtering turned on")
        doautocmd BufAdd
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#reopen_last_tab()
    """Reopen the last closed tab."""

    if !exists('s:most_recently_closed_tab')
        call airline#util#warning("No recent tabs.")
        return
    endif

    let tab = s:most_recently_closed_tab
    tabnew
    let empty = bufnr("%")
    let t:cwd = tab['cwd']
    cd `=t:cwd`
    let t:name = tab['name']
    for buf in tab['buffers'] | execute "badd ".buf | endfor
    execute "edit ".tab['buffers'][0]
    execute "bdelete ".empty
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#filter_buffers()
    """Filter buffers so that only the ones within the tab's cwd will show up.

    " 'accepted' is a list of buffer numbers, for quick access.
    " 'excluded' is a list of buffer numbers, it will be used by Airline to hide buffers.

    if !s:xtabline_filtering | return | endif

    let g:airline#extensions#tabline#exclude_buffers = []
    let t:xtl_excluded = g:airline#extensions#tabline#exclude_buffers
    let t:xtl_accepted = [] | let accepted = t:xtl_accepted
    let previews = g:xtabline_include_previews

    " bufnr(0) is the alternate buffer
    for buf in range(1, bufnr("$"))

        if !buflisted(buf) | continue | endif

        " get the path
        let path = expand("#".buf.":p")

        " confront with the cwd
        if !previews && path =~ "^".getcwd()
            call add(accepted, buf)
        elseif previews && path =~ getcwd()
            call add(accepted, buf)
        else
            call add(t:xtl_excluded, buf)
        endif
    endfor

    call s:RefreshTabline()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#next_buffer(nr)
    """Switch to next visible buffer."""

    if ( s:NotEnoughBuffers() || !s:xtabline_filtering ) | return | endif
    let accepted = t:xtl_accepted

    let ix = index(accepted, bufnr("%"))
    let target = ix + a:nr
    let total = len(accepted)

    if ix == -1
        " not in index, go back to most recent or back to first
        if s:most_recent == -1 || s:most_recent >= total
            let s:most_recent = 0
        endif

    elseif target >= total
        " over last buffer
        while target >= total | let target -= total | endwhile
        let s:most_recent = target

    else
        let s:most_recent = target
    endif

    return ":buffer " . accepted[s:most_recent] . "\<cr>"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#prev_buffer(nr)
    """Switch to previous visible buffer."""

    if ( s:NotEnoughBuffers() || !s:xtabline_filtering ) | return | endif
    let accepted = t:xtl_accepted

    let ix = index(accepted, bufnr("%"))
    let target = ix - a:nr
    let total = len(accepted)

    if ix == -1
        " not in index, go back to most recent or back to first
        if s:most_recent == -1 || s:most_recent >= total
            let s:most_recent = 0
        endif

    elseif target < 0
        " before first buffer
        while target < 0 | let target += total | endwhile
        let s:most_recent = target

    else
        let s:most_recent = target
    endif

    return ":buffer " . accepted[s:most_recent] . "\<cr>"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#select_buffer(nr)
    """Switch to visible buffer in the tabline with [count]."""

    if ( a:nr == 0 || !s:xtabline_filtering ) | execute g:xtabline_alt_action | return | endif
    let accepted = t:xtl_accepted

    if (a:nr > len(accepted)) || s:NotEnoughBuffers() || accepted[a:nr - 1] == bufnr("%")
        return
    else
        let g:xtabline_changing_buffer = 1
        execute "buffer ".accepted[a:nr - 1]
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:TabBuffers()
    """Return a list of buffers names for this tab."""

    return map(copy(t:xtl_accepted), 'bufname(v:val)')
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:NotEnoughBuffers()
    """Just return if there aren't enough buffers."""

    if len(t:xtl_accepted) < 2
        if index(t:xtl_accepted, bufnr("%")) == -1
            return
        elseif !len(t:xtl_accepted)
            call airline#util#warning("No available buffers for this tab.")
        else
            call airline#util#warning("No other available buffers for this tab.")
        endif
        return 1
    endif
endfunction

function! s:RefreshTabline()
    call airline#extensions#tabline#buflist#invalidate()
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TabPageCd
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tabpagecd - Turn :cd into :tabpagecd, to use one tab page per project
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:InitCwds()
    if !exists('g:xtab_cwds') | let g:xtab_cwds = [] | endif

    while len(g:xtab_cwds) < tabpagenr("$")
        call add(g:xtab_cwds, getcwd())
    endwhile
    let s:state    = 1
    let t:cwd      = getcwd()
    let s:last_tab = 0
    call airline#extensions#tabline#xtabline#filter_buffers()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#update_obsession()
    let string = 'let g:xtab_cwds = '.string(g:xtab_cwds).' | call airline#extensions#tabline#xtabline#update_obsession()'
    if !exists('g:obsession_append')
        let g:obsession_append = [string]
    else
        call filter(g:obsession_append, 'v:val !~# "^let g:xtab_cwds"')
        call add(g:obsession_append, string)
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:Do(action)
    let arg = a:action
    if !s:state | call s:InitCwds() | return | endif

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    if arg == 'new'

        call insert(g:xtab_cwds, getcwd(), tabpagenr()-1)

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    elseif arg == 'enter'

        let t:cwd =g:xtab_cwds[tabpagenr()-1]

        cd `=t:cwd`
        call airline#extensions#tabline#xtabline#filter_buffers()

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    elseif arg == 'leave'

        let t:cwd = getcwd()
        let g:xtab_cwds[tabpagenr()-1] = t:cwd
        let s:last_tab = tabpagenr() - 1

        if !exists('t:name') | let t:name = t:cwd | endif
        let s:most_recent_tab = {'cwd': t:cwd, 'name': t:name, 'buffers': s:TabBuffers()}

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    elseif arg == 'close'

        let s:most_recently_closed_tab = copy(s:most_recent_tab)
        call remove(g:xtab_cwds, s:last_tab)
    endif

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    call airline#extensions#tabline#xtabline#update_obsession()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
