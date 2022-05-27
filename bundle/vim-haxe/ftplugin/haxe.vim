compiler haxe
setlocal omnifunc=vaxe#HaxeComplete



let run_once = 0

if (!run_once)
   " Start a server the first time a hx file is edited
   if g:vaxe_cache_server && ! exists('g:vaxe_cache_server_pid')
      call vaxe#StartCacheServer()
   endif

   " Utility variable that stores the directory that this script resides in
   "Load the first time a haxe file is opened
   let s:plugin_path = escape(expand('<sfile>:p:h') . '/../python/', '\')
   if has("python3")
      exe 'py3file '.s:plugin_path.'/vaxe.py'
   elseif has("python")
      exe 'pyfile '.s:plugin_path.'/vaxe.py'
   endif

   " load special configuration for vim-airline if it exists
   if (exists("g:loaded_airline") && g:vaxe_enable_airline_defaults )
      function! AirlineBuild(...)
         if &filetype == 'haxe'
            let w:airline_section_c =
                     \  '%{VaxeAirlineProject()}'
                     \. ' %{pathshorten(fnamemodify(vaxe#CurrentBuild(), ":."))}'
                     \. ' [%{vaxe#CurrentBuildPlatform()}] '
                     \. g:airline_left_alt_sep
                     \. ' %f%m'
         endif
      endfunction
      call add(g:airline_statusline_funcrefs, function('AirlineBuild'))
   endif
endif

function! VaxeAirlineProject()
   return exists("g:vaxe_hxml") ? '★ ' : '☆ '
endfunction

" we need to show single entry completions for haxe, because I use those for
" info messages on occasion
if (g:vaxe_completeopt_menuone)
    setlocal completeopt+=menuone
endif
