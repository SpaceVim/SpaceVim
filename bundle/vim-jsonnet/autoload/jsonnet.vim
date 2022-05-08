

" Options.

if !exists("g:jsonnet_command")
  let g:jsonnet_command = "jsonnet"
endif

if !exists("g:jsonnet_fmt_command")
  let g:jsonnet_fmt_command = "jsonnetfmt"
endif

if !exists('g:jsonnet_fmt_options')
  let g:jsonnet_fmt_options = ''
endif

if !exists('g:jsonnet_fmt_fail_silently')
  let g:jsonnet_fmt_fail_silently = 1
endif


" System runs a shell command. It will reset the shell to /bin/sh for Unix-like
" systems if it is executable.
function! jsonnet#System(str, ...)
  let l:shell = &shell
  if executable('/bin/sh')
    let &shell = '/bin/sh'
  endif

  try
    let l:output = call("system", [a:str] + a:000)
    return l:output
  finally
    let &shell = l:shell
  endtry
endfunction


" CheckBinPath checks whether the given binary exists or not and returns the
" path of the binary. It returns an empty string if it doesn't exists.
function! jsonnet#CheckBinPath(binName)

    if executable(a:binName)
        if exists('*exepath')
            let binPath = exepath(a:binName)
	    return binPath
        else
	   return a:binName
        endif
    else
        echo "vim-jsonnet: could not find '" . a:binName . "'."
        return ""
    endif

endfunction

" Format calls `jsonnetfmt ... ` on the file and replaces the file with the
" auto formatted version. Does some primitive error checking of the
" jsonnetfmt command too.
function! jsonnet#Format()

    " Save cursor position and many other things.
    let l:curw = winsaveview()

    " Write current unsaved buffer to a temp file
    let l:tmpname = tempname()
    call writefile(getline(1, '$'), l:tmpname)

    " get the command first so we can test it
    let l:binName = g:jsonnet_fmt_command

   " check if the user has installed command binary.
    let l:binPath = jsonnet#CheckBinPath(l:binName)
    if empty(l:binPath)
      return
    endif


    " Populate the final command.
    let l:command = l:binPath
    " The inplace modification is default. Makes file management easier
    let l:command = l:command . ' -i '
    let l:command = l:command . g:jsonnet_fmt_options

    " Execute the compiled jsonnetfmt command and save the return value
    let l:out = jsonnet#System(l:command . " " . l:tmpname)
    let l:errorCode = v:shell_error

    if l:errorCode == 0
        " The format command succeeded Move the formatted temp file over the
        " current file and restore other settings

        " stop undo recording
        try | silent undojoin | catch | endtry

        let l:originalFileFormat = &fileformat
        if exists("*getfperm")
          " save old file permissions
          let l:originalFPerm = getfperm(expand('%'))
        endif
        " Overwrite current file with the formatted temp file
        call rename(l:tmpname, expand('%'))

        if exists("*setfperm") && l:originalFPerm != ''
          call setfperm(expand('%'), l:originalFPerm)
        endif
        " the file has been changed outside of vim, enable reedit
        silent edit!
        let &fileformat = l:originalFileFormat
        let &syntax = &syntax
    elseif g:jsonnet_fmt_fail_silently == 0
        " FixMe: We could leverage the errors coming from the `jsonnetfmt` and
        " give immediate feedback to the user at every save time.
        " Our inspiration, vim-go, opens a new list below the current edit
        " window and shows the errors (the output of the fmt command).
        " We are not sure whether this is desired in the vim-jsonnet community
        " or not. Nevertheless, this else block is a suitable place to benefit
        " from the `jsonnetfmt` errors.
    endif

    " Restore our cursor/windows positions.
    call winrestview(l:curw)
endfunction


