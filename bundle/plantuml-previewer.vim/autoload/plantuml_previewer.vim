let s:Process = vital#plantuml_previewer#new().import('System.Process')
let s:Job = vital#plantuml_previewer#new().import('System.Job')
let s:is_win = has('win32') || has('win64') || has('win95')

let s:base_path = fnameescape(expand("<sfile>:p:h")) . '/..'

let s:default_jar_path = s:base_path . '/lib/plantuml.jar'

let s:default_java_path = 'java'

let s:default_include_path = ''

let s:tmp_path = (s:is_win ? s:base_path . '/tmp' : '/tmp/plantuml-previewer')

let s:save_as_script_path = s:base_path . '/script/save-as' . (s:is_win ? '.cmd' : '.sh')

let s:update_viewer_script_path = s:base_path . '/script/update-viewer' . (s:is_win ? '.cmd' : '.sh')

let s:watched_bufnr = 0

let s:started = v:false

function! plantuml_previewer#start() "{{{
  if !executable(s:java_path())
    echoerr 'require java command'
    return v:false
  endif
  let viewer_path = s:viewer_path()
  if !isdirectory(viewer_path) && !filereadable(viewer_path)
    call plantuml_previewer#copy_viewer_directory()
  endif
  call delete(s:viewer_tmp_puml_path())
  call delete(s:viewer_tmp_svg_path())
  let s:watched_bufnr = bufnr('%')
  call plantuml_previewer#refresh(s:watched_bufnr)
  augroup plantuml_previewer
    autocmd!
    autocmd BufWritePost *.pu,*.uml,*.plantuml,*.puml,*.iuml call plantuml_previewer#refresh(s:watched_bufnr)
  augroup END
  return v:true
endfunction "}}}

function! plantuml_previewer#open() "{{{
  if !exists('*OpenBrowser')
    echoerr 'require open-browser.vim'
    return v:false
  endif
  let start_result = plantuml_previewer#start()
  if !start_result
    return v:false
  endif
  call OpenBrowser(s:viewer_html_path())
  let s:started = v:true
  return v:true
endfunction "}}}

function! plantuml_previewer#stop() "{{{
  augroup plantuml_previewer
    autocmd!
  augroup END
  let s:started = v:false
endfunction "}}}

function! plantuml_previewer#toggle() abort
  if s:started
    call plantuml_previewer#stop()
    echo 'plantuml-previewer stopped'
  else
    let open_result = plantuml_previewer#open()
    if open_result
      echo 'plantuml-previewer opened'
    endif
  endif
endfunction

function! s:is_zero(val) "{{{
  return type(a:val) == type(0) && a:val == 0
endfunction "}}}

function! plantuml_previewer#copy_viewer_directory() "{{{
  let viewer_path = s:viewer_path()
  let default_viewer_path = plantuml_previewer#default_viewer_path()
  if viewer_path != default_viewer_path
    if s:is_win
      call system('xcopy ' . default_viewer_path . ' ' . g:plantuml_previewer#viewer_path . ' /O /X /E /H /K')
    else
      call system('cp -r ' . default_viewer_path . ' ' . g:plantuml_previewer#viewer_path)
      call system('chmod a=rwX ' . g:plantuml_previewer#viewer_path)
    endif
    echom 'copy ' . default_viewer_path . ' -> ' . viewer_path
  endif
endfunction "}}}

function! plantuml_previewer#default_viewer_path() "{{{
  return s:base_path . '/viewer'
endfunction "}}}

function! s:viewer_path() "{{{
  let path = get(g:, 'plantuml_previewer#viewer_path', 0)
  return s:is_zero(path) ? plantuml_previewer#default_viewer_path() : fnameescape(path)
endfunction "}}}

function! s:viewer_tmp_puml_path() "{{{
  return s:viewer_path() . '/tmp.puml'
endfunction "}}}

function! s:viewer_tmp_svg_path() "{{{
  return s:viewer_path() . '/tmp.svg'
endfunction "}}}

function! s:viewer_tmp_js_path() "{{{
  return s:viewer_path() . '/tmp.js'
endfunction "}}}

function! s:viewer_html_path() "{{{
  return s:viewer_path() . '/index.html'
endfunction "}}}

function! s:is_debug_mode() "{{{
  return get(g:, 'plantuml_previewer#debug_mode', 0)
endfunction "}}}

function! s:java_path() "{{{
  let path = get(g:, 'plantuml_previewer#java_path', 0)
  return s:is_zero(path) ? s:default_java_path : path
endfunction "}}}

function! s:jar_path() "{{{
  let path = get(g:, 'plantuml_previewer#plantuml_jar_path', 0)
  return s:is_zero(path) ? s:default_jar_path : path
endfunction "}}}

function! s:include_path() "{{{
  let path = get(g:, 'plantuml_previewer#include_path', 0)
  return s:is_zero(path) ? s:default_include_path : path
endfunction "}}}

function! s:save_format() "{{{
  return get(g:, 'plantuml_previewer#save_format', 'png')
endfunction "}}}

function! s:ext_to_fmt(ext) "{{{
  return a:ext == 'tex' ? 'latex' : a:ext
endfunction "}}}

function! s:fmt_to_ext(fmt) "{{{
  return a:fmt == 'latex' ? 'tex' : a:fmt
endfunction "}}}

function! s:print_stdout(lines) "{{{
  let msg = trim(join(a:lines))
  if !empty(msg)
    echomsg msg
  endif
endfunction "}}}

function! s:print_stderr(lines) "{{{
  let msg = trim(join(a:lines))
  if !empty(msg)
    echoerr msg
  endif
endfunction "}}}

function! s:run_in_background(cmd) "{{{
  if s:is_debug_mode()
    if s:Job.is_available()
      call s:Job.start(a:cmd, {'on_stdout': function('s:print_stdout'), 'on_stderr': function('s:print_stderr')})
    else
      call s:print_stdout(s:Process.execute(a:cmd))
    endif
  else
    if s:Job.is_available()
      call s:Job.start(a:cmd)
    else
      try
        call s:Process.execute(a:cmd, {
              \ 'background': 1,
              \})
      catch
        call s:Process.execute(a:cmd)
      endtry
    endif
  endif
endfunction "}}}

function! s:normalize_path(path) "{{{
  return simplify(expand(a:path, 1))
endfunction "}}}

function! plantuml_previewer#refresh(bufnr) "{{{
  let puml_src_path = fnamemodify(bufname(a:bufnr), ':p')
  let puml_filename = fnamemodify(puml_src_path, ':t:r')
  let image_type = 'svg'
  let image_ext = s:fmt_to_ext(image_type)
  let output_dir_path = s:tmp_path
  let output_path = output_dir_path . '/' . puml_filename . '.' . image_ext
  let finial_path = s:viewer_path() . '/tmp.' . image_ext
  let cmd = [
       \ s:update_viewer_script_path,
       \ s:java_path(),
       \ s:jar_path(),
       \ puml_src_path,
       \ s:normalize_path(output_dir_path),
       \ s:normalize_path(output_path),
       \ s:normalize_path(finial_path),
       \ image_type,
       \ localtime(),
       \ s:normalize_path(s:viewer_tmp_js_path()),
       \ s:include_path(),
       \ ]
  call s:run_in_background(cmd)
endfunction "}}}

function! plantuml_previewer#save_as(...) "{{{
  if !executable(s:java_path())
    echoerr 'require java command'
    return
  endif

  let save_path = get(a:000, 0, 0)
  let image_type = get(a:000, 1, 0)
  if s:is_zero(save_path)
    let source_name = expand('%:t:r')
    let save_path = printf("%s.%s", source_name, s:fmt_to_ext(s:save_format()))
  else
    let save_path = fnamemodify(save_path, ':p')
  endif
  if s:is_zero(image_type)
    let ext = fnamemodify(save_path, ':e')
    let image_type = ext == '' ? s:save_format() : s:ext_to_fmt(ext)
  endif

  let puml_src_path = expand('%:p')
  let puml_filename = fnamemodify(puml_src_path, ':t:r')
  let image_ext = s:fmt_to_ext(image_type)
  let output_dir_path = s:tmp_path
  let output_path = output_dir_path . '/' . puml_filename . '.' . image_ext
  call mkdir(fnamemodify(save_path, ':p:h'), 'p')
  let cmd = [
        \ s:save_as_script_path,
        \ s:java_path(),
        \ s:jar_path(),
        \ puml_src_path,
        \ s:normalize_path(output_dir_path),
        \ s:normalize_path(output_path),
        \ s:normalize_path(save_path),
        \ image_type,
        \ s:include_path(),
        \ ]
  call s:run_in_background(cmd)
endfunction "}}}
