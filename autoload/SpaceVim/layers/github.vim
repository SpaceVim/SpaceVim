"=============================================================================
" github.vim --- SpaceVim github layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section github, layers-github
" @parentsection layers
" This layer provides GitHub integration for SpaceVim
"
" @subsection Mappings
" >
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC g h i     show issues
"   normal    SPC g h a     show activities
"   normal    SPC g h d     show dashboard
"   normal    SPC g h f     show current file in browser
"   normal    SPC g h I     show issues in browser
"   normal    SPC g h p     show PRs in browser
" <

function! SpaceVim#layers#github#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/github-issues.vim', {'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/vim-github-dashboard', {'merged' : 0}],
        \ ['tyru/open-browser-github.vim',  {
        \ 'depends': 'open-browser.vim',
        \ 'on_cmd': ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq'],
        \ }],
        \ ['wsdjeg/GitHub-api.vim', {'merged' : 0}],
        \ ['lambdalisue/vim-gista', {'merged' : 0}],
        \ ]
endfunction

function! SpaceVim#layers#github#config() abort
  " TODO Remove duplicated line exists in git layer
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {
        \ 'name' : '+VCS/git',
        \ })

	if !exists('g:_spacevim_mappings_space.g.h')
		let g:_spacevim_mappings_space.g.h = {'name' : ''}
	endif
	let l:h_submenu_name = SpaceVim#layers#isLoaded('git') ? '+GitHub/Hunks' : '+GitHub'
	let g:_spacevim_mappings_space.g.h['name'] = l:h_submenu_name

	let g:_spacevim_mappings_space.g.g = { 'name': '+Gist' }

  " @todo remove the username
  " autoload to set default username
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'g', 'l'], 'Gista list',
        \ 'list gist', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'g', 'p'], 'Gista post',
        \ 'post selection or current file', 1, 1)

  "" jaxbot/github-issues.vim {{{
  " Disable completion by github-issues.vim. Because github-complete.vim
  " provides more powerful completion.
  let g:github_issues_no_omni = 1

  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'i'], 'Gissues',
        \ 'show issues', 1)
  "" }}}

  "" junegunn/vim-github-dashboard {{{
  let g:github_dashboard = {
        \ 'username': g:spacevim_github_username,
        \ }

  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'a'], 'GHActivity',
        \ 'show activities', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'd'], 'GHDashboard',
        \ 'show dashboard', 1)
  "" }}}

  "" tyru/open-browser-github.vim {{{
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'f'], 'OpenGithubFile',
        \ 'show current file in browser', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'I'],
        \ 'OpenGithubIssue', 'show issues in browser', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'h', 'p'],
        \ 'OpenGithubPullReq', 'show PRs in browser', 1)
  "" }}}
endfunction

function! SpaceVim#layers#github#health() abort
  call SpaceVim#layers#github#plugins()
  call SpaceVim#layers#github#config()
  return 1
endfunction

function! s:update_stared_repo_list() abort
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
