if exists('g:loaded_neomake') || &compatible
    finish
endif
let g:loaded_neomake = 1

command! -nargs=* -bang -bar -complete=customlist,neomake#cmd#complete_makers
            \ Neomake call neomake#Make(<bang>1, [<f-args>])

" These commands are available for clarity
command! -nargs=* -bar -complete=customlist,neomake#cmd#complete_makers
            \ NeomakeProject Neomake! <args>
command! -nargs=* -bar -complete=customlist,neomake#cmd#complete_makers
            \ NeomakeFile Neomake <args>

command! -nargs=+ -bang -complete=shellcmd
            \ NeomakeSh call neomake#ShCommand(<bang>0, <q-args>)
command! NeomakeListJobs call neomake#ListJobs()
command! -bang -nargs=1 -complete=custom,neomake#cmd#complete_jobs
            \ NeomakeCancelJob call neomake#CancelJob(<q-args>, <bang>0)
command! -bang NeomakeCancelJobs call neomake#CancelJobs(<bang>0)

command! -bang -bar -nargs=? -complete=customlist,neomake#cmd#complete_makers
            \ NeomakeInfo call neomake#debug#display_info(<bang>0, <f-args>)

command! -bang -bar NeomakeClean call neomake#cmd#clean(<bang>1)

" Enable/disable/toggle commands.
command! -bar NeomakeToggle call neomake#cmd#toggle(g:)
command! -bar NeomakeToggleBuffer call neomake#cmd#toggle(b:)
command! -bar NeomakeToggleTab call neomake#cmd#toggle(t:)
command! -bar NeomakeDisable call neomake#cmd#disable(g:)
command! -bar NeomakeDisableBuffer call neomake#cmd#disable(b:)
command! -bar NeomakeDisableTab call neomake#cmd#disable(t:)
command! -bar NeomakeEnable call neomake#cmd#enable(g:)
command! -bar NeomakeEnableBuffer call neomake#cmd#enable(b:)
command! -bar NeomakeEnableTab call neomake#cmd#enable(t:)

command! NeomakeStatus call neomake#cmd#display_status()

" NOTE: experimental, no default mappings.
" NOTE: uses -addr=lines (default), and therefore negative counts do not work
"       (see https://github.com/vim/vim/issues/3654).
command! -bar -count=1 NeomakeNextLoclist call neomake#list#next(<count>, 1)
command! -bar -count=1 NeomakePrevLoclist call neomake#list#prev(<count>, 1)
command! -bar -count=1 NeomakeNextQuickfix call neomake#list#next(<count>, 0)
command! -bar -count=1 NeomakePrevQuickfix call neomake#list#prev(<count>, 0)

call neomake#setup#setup_autocmds()

" vim: ts=4 sw=4 et
