source ../../bootstrap.vim

call matchup#custom#define_motion('nox', '%',
      \ 'matchup#custom#example_motion', { 'down': 1 })
call matchup#custom#define_motion('nox', 'g%',
      \ 'matchup#custom#example_motion', { 'down': 0 })

