
source ../../bootstrap.vim

xmap u% <plug>(matchup-i%)
omap u% <plug>(matchup-i%)

" optional, for use without patch 8.1.0648
call call(matchup#motion_sid().'make_oldstyle_omaps', ['u%', 'i%'])

