" statusline
let g:_spacevim_statusline_loaded = 1

function! ActiveStatus()
    let statusline=""
    let statusline.="%1*"
    let statusline.="%(%{'help'!=&filetype?'\ \ '.bufnr('%'):''}\ %)"
    let statusline.="%2*"
    let statusline.=""
    let statusline.="%{fugitive#head()!=''?'\ \ '.fugitive#head().'\ ':''}"
    let statusline.="%3*"
    let statusline.=""
    let statusline.="%4*"
    let statusline.="\ %<"
    let statusline.="%f"
    let statusline.="%{&modified?'\ \ +':''}"
    let statusline.="%{&readonly?'\ \ ':''}"
    let statusline.="%="
    let statusline.="\ %{''!=#&filetype?&filetype:'none'}"
    let statusline.="%(\ %{(&bomb\|\|'^$\|utf-8'!~#&fileencoding?'\ '.&fileencoding.(&bomb?'-bom':''):'').('unix'!=#&fileformat?'\ '.&fileformat:'')}%)"
    let statusline.="%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)"
    let statusline.="%3*"
    let statusline.="\ "
    let statusline.="%2*"
    let statusline.=""
    let statusline.="%1*"
    let statusline.="\ %2v"
    let statusline.="\ %3p%%\ "
    return statusline
endfunction

function! InactiveStatus()
    let statusline=""
    let statusline.="%(%{'help'!=&filetype?'\ \ '.bufnr('%').'\ \ ':'\ '}%)"
    let statusline.="%{fugitive#head()!=''?'\ \ '.fugitive#head().'\ ':'\ '}"
    let statusline.="\ %<"
    let statusline.="%f"
    let statusline.="%{&modified?'\ \ +':''}"
    let statusline.="%{&readonly?'\ \ ':''}"
    let statusline.="%="
    let statusline.="\ %{''!=#&filetype?&filetype:'none'}"
    let statusline.="%(\ %{(&bomb\|\|'^$\|utf-8'!~#&fileencoding?'\ '.&fileencoding.(&bomb?'-bom':''):'').('unix'!=#&fileformat?'\ '.&fileformat:'')}%)"
    let statusline.="%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)"
    let statusline.="\ \ "
    let statusline.="\ %2v"
    let statusline.="\ %3p%%\ "
    return statusline
endfunction


function! SpaceVim#layers#core#statusline#init() abort
    augroup status
        autocmd!
        autocmd WinEnter * setlocal statusline=%!ActiveStatus()
        autocmd WinLeave * setlocal statusline=%!InactiveStatus()
        autocmd ColorScheme kalisi if(&background=="dark") | hi User1 guibg=#afd700 guifg=#005f00 | endif
        autocmd ColorScheme kalisi if(&background=="dark") | hi User2 guibg=#005f00 guifg=#afd700 | endif
        autocmd ColorScheme kalisi if(&background=="dark") | hi User3 guibg=#222222 guifg=#005f00 | endif
        autocmd ColorScheme kalisi if(&background=="dark") | hi User4 guibg=#222222 guifg=#d0d0d0 | endif
        autocmd ColorScheme kalisi if(&background=="light") | hi User1 guibg=#afd700 guifg=#005f00 | endif
        autocmd ColorScheme kalisi if(&background=="light") | hi User2 guibg=#005f00 guifg=#afd700 | endif
        autocmd ColorScheme kalisi if(&background=="light") | hi User3 guibg=#707070 guifg=#005f00 | endif
        autocmd ColorScheme kalisi if(&background=="light") | hi User4 guibg=#707070 guifg=#d0d0d0 | endif
    augroup END
endfunction
