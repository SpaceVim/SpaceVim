function! s:error(about, dir)
    let msg = printf('Could not download jar file because %s. Please download zip from %s and extract it to %s.', a:about, g:grammarous#jar_url, a:dir)
    call grammarous#error(msg)
endfunction

function! grammarous#downloader#download(jar_dir)
    if !isdirectory(a:jar_dir)
        call mkdir(a:jar_dir, 'p')
    endif

    let tmp_file = tempname() . '.zip'

    if !executable('unzip')
        call s:error("'unzip' is not found", a:jar_dir)
        return 0
    endif

    if executable('axel')
        let cmd = printf('axel -a -n 2 -o %s %s 2>&1', tmp_file, g:grammarous#jar_url)
    elseif executable('wget')
        let cmd = printf('wget -O %s %s 2>&1', tmp_file, g:grammarous#jar_url)
    elseif executable('curl')
        let cmd = printf('curl -L -o %s %s 2>&1', tmp_file, g:grammarous#jar_url)
    else
        call s:error("could not find 'axel', 'curl', or 'wget'", a:jar_dir)
        return 0
    endif

    echomsg 'Downloading jar file from ' . g:grammarous#jar_url . '...'

    let cmd = printf('%s && unzip %s -d %s', cmd, tmp_file, a:jar_dir)
    let result = system(cmd)
    if v:shell_error
        call s:error(printf("'%s' failed: %s", cmd, result), a:jar_dir)
        return 0
    endif

    echomsg 'Done!'

    " Should error handling?
    call delete(tmp_file)

    return 1
endfunction
