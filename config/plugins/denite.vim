let s:sys = SpaceVim#api#import('system')
if !s:sys.isWindows
    if executable('ag')
        " Change file_rec command.
        call denite#custom#var('file_rec', 'command',
                    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
    elseif executable('rg')
        " For ripgrep
        " Note: It is slower than ag
        call denite#custom#var('file_rec', 'command',
                    \ ['rg', '--files', '--glob', '!.git', ''])
    endif
else
    if executable('pt')
        " For Pt(the platinum searcher)
        " NOTE: It also supports windows.
        call denite#custom#var('file_rec', 'command',
                    \ ['pt', '--follow', '--nocolor', '--nogroup', '-g:', ''])
    endif
endif
