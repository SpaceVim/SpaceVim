"Detect OS
function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return (has('win16') || has('win32') || has('win64'))
endfunction
function! OnmiConfigForJsp()
    let pos1 = search("</script>","nb",line("w0"))
    let pos2 = search("<script","nb",line("w0"))
    let pos3 = search("</script>","n",line("w$"))
    let pos0 = line('.')
    if pos1 < pos2 && pos2 < pos0 && pos0 < pos3
        set omnifunc=javascriptcomplete#CompleteJS
        return "\<esc>a."
    else
        set omnifunc=javacomplete#Complete
        return "\<esc>a."
    endif
endf
function! ToggleNumber()
    let s:isThereNumber = &nu
    let s:isThereRelativeNumber = &relativenumber
    if s:isThereNumber && s:isThereRelativeNumber
        set paste!
        set nonumber
        set norelativenumber
    else
        set paste!
        set number
        set relativenumber
    endif
endf
function! ToggleBG()
    let s:tbg = &background
    " Inversion
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction
function! BracketsFunc()
    let line = getline('.')
    let col = col('.')
    if line[col - 2] == "]"
        return "{}\<esc>i"
    else
        return "{\<cr>}\<esc>O"
    endif
endf
function! XmlFileTypeInit()
    set omnifunc=xmlcomplete#CompleteTags
    if filereadable("AndroidManifest.xml")
        set dict+=~/.vim/bundle/vim-dict/dict/android_xml.dic
    endif
endf
function! WSDAutoComplete(char)
    if(getline(".")=~?'^\s*.*\/\/')==0
        let line = getline('.')
        let col = col('.')
        if a:char == "."
            return a:char."\<c-x>\<c-o>\<c-p>"
        elseif line[col - 2] == " "||line[col -2] == "("||line[col - 2] == ","
            return a:char."\<c-x>\<c-o>\<c-p>"
        elseif line[col - 3] == " "&&line[col - 2] =="@"
            return a:char."\<c-x>\<c-o>\<c-p>"
        else
            return a:char
        endif
    else
        "bug exists
        normal! ma
        let commentcol = searchpos('//','b',line('.'))[1]
        normal! `a
        if commentcol == 0
            return a:char."\<c-x>\<c-o>\<c-p>"
        else
            return "\<Right>".a:char
        endif
    endif
endf
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

function! CloseBracket()
    if match(getline(line('.') + 1), '\s*}') < 0
        return "\<CR>}"
    else
        return "\<Esc>j0f}a"
    endif
endf

function! QuoteDelim(char)
    let line = getline('.')
    let col = col('.')
    if line[col - 2] == "\\"
        "Inserting a quoted quotation mark into the string
        return a:char
    elseif line[col - 1] == a:char
        "Escaping out of the string
        return "\<Right>"
    else
        "Starting a string
        return a:char.a:char."\<Esc>i"
    endif
endf
function! JspFileTypeInit()
    set tags+=~/others/openjdk-8-src/tags
    set omnifunc=javacomplete#Complete
    inoremap . <c-r>=OnmiConfigForJsp()<cr>
    nnoremap <F4> :JCimportAdd<cr>
    inoremap <F4> <esc>:JCimportAddI<cr>
endfunction
function! MyTagfunc() abort
    mark H
    let s:MyTagfunc_flag = 1
    UniteWithCursorWord -immediately tag
endfunction

function! MyTagfuncBack() abort
    if exists('s:MyTagfunc_flag')&&s:MyTagfunc_flag
        exe "normal! `H"
        let s:MyTagfunc_flag =0
    endif
endfunction


function! MyLeaderTabfunc() abort
    if g:spacevim_autocomplete_method == 'deoplete'
        if g:spacevim_enable_javacomplete2_py
            return deoplete#mappings#manual_complete(['javacomplete2'])
        else
            return deoplete#mappings#manual_complete(['omni'])
        endif
    elseif g:spacevim_autocomplete_method == 'neocomplete'
        return neocomplete#start_manual_complete(['omni'])
    endif
endfunction

func! Openpluginrepo()
    try
        exec "normal! ".'"ayi'."'"
        exec 'OpenBrowser https://github.com/'.@a
    catch
        echohl WarningMsg | echomsg "can not open the web of current plugin" | echohl None
    endtry
endf
func! Update_current_plugin()
    try
        let a_save = @a
        let @a=''
        normal! "ayi'
        let plug_name = match(@a, '/') >= 0 ? split(@a, '/')[1] : @a
    finally
        let @a = a_save
    endtry
    call dein#update([plug_name])
endf
func! Show_Log_for_current_plugin()
    try
        let a_save = @a
        let @a=''
        normal! "ayi'
        let plug = match(@a, '/') >= 0 ? @a : 'vim-scripts/'.@a
    finally
        let @a = a_save
    endtry
    call unite#start([['output/shellcmd',
                \ 'git --no-pager -C ~/.cache/vimfiles/repos/github.com/'
                \ . plug
                \ . ' log -n 15 --oneline']], {'log': 1, 'wrap': 1,'start_insert':0})
    exe "nnoremap <buffer><CR> :call <SID>Opencommit('". plug ."', strpart(split(getline('.'),'[33m')[1],0,7))<CR>"
endf
fu! s:Opencommit(repo,commit)
    exe 'OpenBrowser https://github.com/' . a:repo .'/commit/'. a:commit
endf

fu! UpdateStarredRepos()
    if empty(g:spacevim_github_username)
        call SpaceVim#logger#warn('You need to set g:spacevim_github_username')
        return 0
    endif
    let cache_file = expand('~/.data/github' . g:spacevim_github_username)
    if filereadable(cache_file)
        let repos = json_encode(readfile(cache_file, '')[0])
    else
        let repos = github#api#users#GetStarred(g:spacevim_github_username)
        echom writefile([json_decode(repos)], cache_file, '')
    endif

    for repo in repos
        let description = repo.full_name . repeat(' ', 40 - len(repo.full_name)) . repo.description
        let cmd = 'OpenBrowser ' . repo.html_url
        call add(g:unite_source_menu_menus.MyStarredrepos.command_candidates, [description,cmd])
    endfor
    return 1
endf
