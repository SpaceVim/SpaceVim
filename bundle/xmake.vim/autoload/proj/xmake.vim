
fun! s:CheckXMake()
    let f = g:Proj.workdir . '/xmake.lua'
    if filereadable(f)
        call xmake#load()
    endif
endf

au User AfterProjLoaded call <SID>CheckXMake()
