"=============================================================================
" FILE: deoplete.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
"         TJ DeVries <devries.timothyj at gmail.com>
" License: MIT license
"=============================================================================

function! s:check_t_list() abort
  if exists('v:t_list')
    call health#report_ok('exists("v:t_list") was successful')
  else
    call health#report_error('exists("v:t_list") was not successful',
          \ 'Deoplete requires neovim 0.3.0+!')
  endif
endfunction

function! s:check_timers() abort
  if has('timers')
    call health#report_ok('has("timers") was successful')
  else
    call health#report_error('has("timers") was not successful',
          \ 'Deoplete requires timers support("+timers").')
  endif
endfunction

function! s:check_required_python() abort
  if has('python3')
    call health#report_ok('has("python3") was successful')
  else
    call health#report_error('has("python3") was not successful', [
          \ 'Please install the python3 package for neovim.',
          \ 'A good guide can be found here: ' .
          \ 'https://github.com/tweekmonster/nvim-python-doctor/'
          \ . 'wiki/Advanced:-Using-pyenv'
          \ ]
          \ )
  endif

  if !deoplete#init#_python_version_check()
    call health#report_ok('Require Python 3.6.1+ was successful')
  else
    call health#report_error(
          \ 'Require Python 3.6.1+ was not successful',
          \ 'Please use Python 3.6.1+.')
  endif
endfunction

function! s:check_required_msgpack() abort
  if !deoplete#init#_msgpack_version_check()
    call health#report_ok('Require msgpack 1.0.0+ was successful')
  else
    call health#report_error(
          \ 'Require msgpack 1.0.0+ was not successful',
          \ 'Please install/upgrade msgpack 1.0.0+.')
  endif
endfunction

function! s:still_have_issues() abort
  let indentation = '        '
  call health#report_info("If you're still having problems, " .
        \ "try the following commands:\n" .
        \ indentation . "$ export NVIM_PYTHON_LOG_FILE=/tmp/log\n" .
        \ indentation . "$ export NVIM_PYTHON_LOG_LEVEL=DEBUG\n" .
        \ indentation . "$ nvim\n" .
        \ indentation . "$ cat /tmp/log_{PID}\n" .
        \ indentation . ' and then create an issue on github'
        \ )
endfunction

function! health#deoplete#check() abort
  call health#report_start('deoplete.nvim')

  call s:check_t_list()
  call s:check_timers()
  call s:check_required_python()
  call s:check_required_msgpack()

  call s:still_have_issues()
endfunction
