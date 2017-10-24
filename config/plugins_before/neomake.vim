let s:neomake_automake_events = {}
if get(g:, 'spacevim_lint_on_save', 0)
    let s:neomake_automake_events['BufWritePost'] = {'delay': 0}
endif

if get(g:, 'spacevim_lint_on_the_fly', 0)
    let s:neomake_automake_events['TextChanged'] = {'delay': 750}
endif

if !empty(s:neomake_automake_events)
    call neomake#configure#automake(s:neomake_automake_events)
endif
