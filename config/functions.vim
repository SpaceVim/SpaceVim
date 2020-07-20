"=============================================================================
" functions.vim --- public function for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! OnmiConfigForJsp()
    let pos1 = search('</script>','nb',line('w0'))
    let pos2 = search('<script','nb',line('w0'))
    let pos3 = search('</script>','n',line('w$'))
    let pos0 = line('.')
    if pos1 < pos2 && pos2 < pos0 && pos0 < pos3
        set omnifunc=javascriptcomplete#CompleteJS
        return "\<esc>a."
    else
        set omnifunc=javacomplete#Complete
        return "\<esc>a."
    endif
endf
function! MyLeaderTabfunc() abort
    if g:spacevim_autocomplete_method ==# 'deoplete'
        if g:spacevim_enable_javacomplete2_py
            return deoplete#mappings#manual_complete(['javacomplete2'])
        else
            return deoplete#mappings#manual_complete(['omni'])
        endif
    elseif g:spacevim_autocomplete_method ==# 'neocomplete'
        return neocomplete#start_manual_complete(['omni'])
    endif
endfunction

func! Openpluginrepo()
    try
        exec 'normal! '.'"ayi'."'"
        exec 'OpenBrowser https://github.com/'.@a
    catch
        echohl WarningMsg | echomsg 'can not open the web of current plugin' | echohl None
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
                \ 'git --no-pager -C '.g:spacevim_data_dir.'/vimfiles/repos/github.com/'
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
