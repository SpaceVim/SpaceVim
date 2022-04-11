scriptencoding utf-8
let s:save_cpo = &cpoptions
set cpoptions&vim
" Debug
let s:server_log = []

let s:run_script = "
            \ use local::lib;\n
            \ use Mojo::Weixin;\n
            \ my $client = Mojo::Weixin->new();\n
            \ $client->load('ShowMsg');\n
            \ $client->load('IRCShell',data=>{\n
            \ listen=>[ {host=>'127.0.0.1',port=>6668},],\n
            \ load_friend=>1,\n
            \ });\n
            \ $client->log->handle(\*STDOUT);\n
            \ $client->run();\n
            \ "
let s:run_job_id = 0
let s:irssi_job_id = 0
let s:feh_code_id = 0
let s:channels = []
let s:irssi_commands = ['/join', '/query', '/list', '/quit']
let s:history = []
let s:current_channel = ''
let s:last_channel = ''
let s:friends = []     " each item is ['channel','nickname']
let s:input_history = []
let s:complete_num = 0
let s:complete_input_history_num = [0,0]
let s:opened_channels = []
let s:irssi_log = []
let s:unread_msg_num = {}
let s:st_sep = ''

function! s:jobstart(...) abort
    if has('nvim')
        if a:0 == 1
            return jobstart(a:1)
        elseif a:0 == 2
            return jobstart(a:1, a:2)
        endif
    elseif exists('*job#start') && !has('nvim')
    endif
endfunction

function! s:jobstop(id) abort
    if has('nvim')
        call jobstop(a:id)
    elseif  exists('*job#stop') && !has('nvim')
    endif
endfunction

function! s:jobsend(id,data) abort
    if has('nvim')
        if type(a:data) == type('')
            let data = [a:data, '']
        elseif type(a:data) == type([]) && a:data[-1] !=# ''
            let data = a:data + ['']
        else
            let data = a:data
        endif
        call jobsend(a:id, data)
    elseif exists('*job#send') && !has('nvim')
        call job#send(a:id, a:data)
    endif
endfunction

function! s:feh_code(png) abort
    call s:stop_feh()
    let s:feh_code_id = s:jobstart(['feh', a:png])
endfunction

function! s:stop_feh() abort
    if s:feh_code_id != 0
        call s:jobstop(s:feh_code_id)
        let s:feh_code_id =0
    endif
endfunction

function! s:irssi_handler(id, data, event) abort
    if a:event ==# 'exit'
        let s:irssi_job_id = 0
    elseif a:event ==# 'stderr'
        call add(s:irssi_log, ['stderr', a:data])
    elseif a:event ==# 'stdout'
        call add(s:irssi_log, ['stdout', a:data])
    endif
endfunction

function! s:start_irssi() abort
    if s:irssi_job_id == 0
        let argv = ['irssi','-c', '127.0.0.1', '-p', '6668']
        let s:irssi_job_id = s:jobstart(argv, {
                    \ 'on_stdout': function('s:irssi_handler'),
                    \ 'on_stderr': function('s:irssi_handler'),
                    \ 'on_exit': function('s:irssi_handler'),
                    \ })
    endif
endfunction

function! s:handler_stdout_data(data) abort
    if !empty(a:data)
        call add(s:server_log, a:data)
    endif
    if match(a:data, '二维码已下载到本地\[ /tmp/mojo_weixin_qrcode_default.jpg') != -1
        let png = matchstr(a:data, '/tmp/mojo_weixin_qrcode_default.jpg')
        call s:feh_code(png)
    elseif matchstr(a:data, '\[\d\d/\d\d/\d\d \d\d\:\d\d\:\d\d\] \[info\] 微信登录成功') !=# ''
        call s:stop_feh()
    elseif matchstr(a:data,'频道\ #.*\ 已创建') !=# ''
        let ch = matchstr(a:data,'#[^\ .]*')
        if index(s:channels, ch) == -1
            call add(s:channels, ch)
        endif
    elseif matchstr(a:data, '\[\d\d/\d\d/\d\d \d\d\:\d\d\:\d\d\] \[info\] \[.*\:虚拟用户\] 加入频道 #我的好友') !=# ''
        " [16/10/31 20:06:09] [info] [nullptr:虚拟用户] 加入频道 #我的好友
        " [28:-42]
        let friend = ['我的好友',a:data[28:-42]]
        if index(s:friends, friend) == -1
            call add(s:friends, friend)
        endif
    elseif matchstr(a:data, '\[\d\d/\d\d/\d\d \d\d\:\d\d\:\d\d\] \[群消息\]') !=# ''
        " send:[16/10/22 18:26:58] [群消息] 我->Vim/exVim 开发讨论群 : 测试补全
        " start index 32
        if matchstr(a:data, '[^\ .]*->[^\ .]*') !=# ''
            let idx1 = match(a:data, '->')
            let idx2 = match(a:data, ' : ')
            let msg = [ a:data[32:idx1-1], '#' . a:data[idx1+2:idx2-1], a:data[idx2+3:]]
            let msg[1] = substitute(msg[1], '[\ !！@&]', '', 'g')
            call add(s:history, msg)
            let friend = [msg[1], msg[0]]
            if index(s:friends, friend) == -1
                call add(s:friends, friend)
            endif
            if msg[1] == s:current_channel
                call s:update_msg_screen()
            endif
        " get:[16/10/22 18:26:58] [群消息] 灰灰|Vim/exVim 开发讨论群 : 测试补全
        elseif matchstr(a:data, '[^\ .]*|[^\ .]*') !=# ''
            let idx1 = match(a:data, '|')
            let idx2 = match(a:data, ' : ')
            let msg = [ a:data[32:idx1-1], '#' .a:data[idx1+1:idx2-1], a:data[idx2+3:]]
            let msg[1] = substitute(msg[1], '[\ !！@&]', '', 'g')
            call add(s:history, msg)
            let friend = [msg[1], msg[0]]
            if index(s:friends, friend) == -1
                call add(s:friends, friend)
            endif
            if msg[1] == s:current_channel
                call s:update_msg_screen()
            elseif index(s:opened_channels, msg[1]) != -1 && s:current_channel !=# msg[1]
                let n = get(s:unread_msg_num, msg[1], 0)
                let n += 1
                if has_key(s:unread_msg_num, msg[1])
                    call remove(s:unread_msg_num, msg[1])
                endif
                call extend(s:unread_msg_num, {msg[1] : n})
                if s:current_channel !=# ''
                    call s:update_statusline()
                endif
            endif
        endif
    elseif matchstr(a:data, '\[\d\d/\d\d/\d\d \d\d\:\d\d\:\d\d\] \[好友消息\]') !=# ''
        " send: [16/10/22 14:25:56] [好友消息] 我->老婆 : 1
        if matchstr(a:data, '[^\ .]*->[^\ .]*') !=# ''
            let msg = split(matchstr(a:data, '[^\ .]*->[^\ .]*'), '->')
            let f = msg[1]
            let msg[1] = ''
            call add(msg, substitute(a:data,'\[\d\d/\d\d/\d\d \d\d\:\d\d\:\d\d\] \[好友消息\].*->[^\ .]*\ \:\ ','','g'))
            call add(msg, f)
            call add(s:history, msg)
            let friend = ['我的好友',f]
            if index(s:friends, friend) == -1
                call add(s:friends, friend)
            endif
            if f == s:current_channel
                call s:update_msg_screen()
            endif
        " get: [16/10/22 14:25:59] [好友消息] 老婆|我的好友 : 测试
        elseif matchstr(a:data, '[^\ .]*|[^\ .]*') !=# ''
            let msg = split(matchstr(a:data, '[^\ .]*|[^\ .]*'), '|')
            let f = msg[0]
            let msg[1] = ''
            call add(msg, substitute(a:data,'\[\d\d/\d\d/\d\d \d\d\:\d\d\:\d\d\] \[好友消息\].*|[^\ .]*\ \:\ ','','g'))
            call add(msg, f)
            call add(s:history, msg)
            let friend = ['我的好友',f]
            if index(s:friends, friend) == -1
                call add(s:friends, friend)
            endif
            if f == s:current_channel
                call s:update_msg_screen()
            elseif index(s:opened_channels, msg[3]) != -1 && s:current_channel !=# msg[3]
                let n = get(s:unread_msg_num, msg[3], 0)
                let n += 1
                if has_key(s:unread_msg_num, msg[3])
                    call remove(s:unread_msg_num, msg[3])
                endif
                call extend(s:unread_msg_num, {msg[3] : n})
                if s:current_channel !=# ''
                    call s:update_statusline()
                endif
            elseif index(s:opened_channels, msg[3]) == -1
                let n = get(s:unread_msg_num, msg[3], 0)
                let n += 1
                if has_key(s:unread_msg_num, msg[3])
                    call remove(s:unread_msg_num, msg[3])
                endif
                call extend(s:unread_msg_num, {msg[3] : n})
                call add(s:opened_channels, msg[3])
                if s:current_channel !=# ''
                    call s:update_statusline()
                endif
            endif
        endif
    endif
endfunction
function! Test(str) abort
    exe a:str
endfunction
function! s:start_handler(id, data, event) abort
    if a:event ==# 'stdout'
        if type(a:data) == type([])
            for a in a:data
                call s:handler_stdout_data(a)
            endfor
        elseif type(a:data) == type('')
            call s:handler_stdout_data(a:data)
        else
        endif

    elseif a:event ==# 'stderr'
    elseif a:event ==# 'exit'
    endif
endfunction

function! chat#weixin#start() abort
    let argv = ['perl', '-e', s:run_script]
    if s:run_job_id == 0
        let s:run_job_id = s:jobstart(argv, {
                    \ 'on_stdout': function('s:start_handler'),
                    \ 'on_stderr': function('s:start_handler'),
                    \ 'on_exit': function('s:start_handler'),
                    \ })
    endif
endfunction

function! s:send(...) abort
    if a:0 > 0
        if s:irssi_job_id == 0
            call s:start_irssi()
        endif
        call s:jobsend(s:irssi_job_id, a:1)
    endif
endfunction

let s:name = '__VimWeixin__'
function! chat#weixin#OpenMsgWin() abort
    if bufwinnr('s:name') < 0
        if bufnr('s:name') != -1
            exe 'silent! botright split ' . '+b' . bufnr(s:name)
        else
            exe 'silent! botright split ' . s:name
        endif
    else
        exec bufwinnr('s:name') . 'wincmd w'
    endif
    setl modifiable
    let s:c_base = '>>>'
    let s:c_begin = ''
    let s:c_char = ''
    let s:c_end = ''
    call s:windowsinit()
    redraw
    if s:last_channel !=# ''
        if s:last_channel =~# '^#'
            call s:send('/join ' . s:last_channel)
        else
            call s:send('/query ' . s:last_channel)
        endif
        let s:current_channel = s:last_channel
        call s:update_statusline()
        call s:update_msg_screen()
    endif
    call s:echon()
    while get(s:, 'quit_msg_win', 0) == 0
        let nr = getchar()
        if nr != 9
            let s:complete_num = 0
        endif
        if nr !=# "\<Up>" && nr !=# "\<Down>"
            let s:complete_input_history_num = [0,0]
        endif
        if nr == 13                                                             "<cr> 执行命令，或发送消息
            call s:parser_input(s:c_begin . s:c_char . s:c_end)
            let s:c_begin = ''
            let s:c_char = ''
            let s:c_end = ''
        elseif nr ==# "\<M-Left>"                                               "<Alt>+<Left> 移动到左边一个聊天窗口
            call s:previous_channel()
        elseif nr ==# "\<M-Right>"                                              "<Alt>+<Right> 移动到右边一个聊天窗口
            call s:next_channel()
        elseif nr ==# "\<Right>" || nr == 6                                     "<Right> 向右移动光标
            let s:c_begin = s:c_begin . s:c_char
            let s:c_char = matchstr(s:c_end, '^.')
            let s:c_end = substitute(s:c_end, '^.', '', 'g')
        elseif nr ==# "\<Left>"  || nr == 2                                     "<Left> 向左移动光标
            if s:c_begin !=# ''
                let s:c_end = s:c_char . s:c_end
                let s:c_char = matchstr(s:c_begin, '.$')
                let s:c_begin = substitute(s:c_begin, '.$', '', 'g')
            endif
        elseif nr ==# "\<Home>" || nr == 1                                     "<Home> 将光标移动到行首
            let s:c_end = substitute(s:c_begin . s:c_char . s:c_end, '^.', '', 'g')
            let s:c_char = matchstr(s:c_begin, '^.')
            let s:c_begin = ''
        elseif nr ==# "\<End>"  || nr == 5                                     "<End> 将光标移动到行末
            let s:c_begin = s:c_begin . s:c_char . s:c_end
            let s:c_char = ''
            let s:c_end = ''
        elseif nr ==# "\<M-x>"                                                  "<Alt>+x 关闭聊天窗口
            let s:quit_msg_win = 1
            let s:last_channel = s:current_channel
            let s:current_channel = ''
        elseif nr == 8 || nr ==# "\<bs>"                                        " ctrl+h or <bs> delete last char
            let s:c_begin = substitute(s:c_begin,'.$','','g')
        elseif nr == 23                                                         " ctrl+w delete last word
            let s:c_begin = substitute(s:c_begin,'[^\ .*]\+\s*$','','g')
        elseif nr == 11                                                         " ctrl+k delete the chars from cursor to the end
            let s:c_char = ''
            let s:c_end = ''
        elseif nr ==# "\<M-f>"                                                  " Alt + f ：按单词前移（右向）
            if matchstr(s:c_end, '^\ *[^\ .]\+') !=# ''
                let s:c_begin = s:c_begin . s:c_char . matchstr(s:c_end, '^\ *[^\ .]\+')
                let s:c_end = substitute(s:c_end, '^\ *[^\ .]\+', '', 'g')
                let s:c_char = matchstr(s:c_end, '^.')
                let s:c_end = substitute(s:c_end, '^.', '', 'g')
            endif
        elseif nr ==# "\<M-b>"
            let s:c_end = matchstr(s:c_begin, '[^\ .]\+\s*$') . s:c_char . s:c_end
            let s:c_begin = substitute(s:c_begin, '[^\ .]\+\s*$', '', 'g')
            let s:c_char = matchstr(s:c_end, '^.')
            let s:c_end = substitute(s:c_end, '^.', '', 'g')
        elseif nr ==# "\<M-d>"                                                  " Alt + d 从光标处删除至词尾
            let s:c_end = s:c_char . s:c_end
            let s:c_end = substitute(s:c_end, '^\s*[^\ .]*', '', 'g')
            let s:c_char = matchstr(s:c_end, '^.')
            let s:c_end = substitute(s:c_end, '^.', '', 'g')
        elseif nr == 4                                                          " ctrl+d delete the char under the cursor
            let s:c_char = matchstr(s:c_end, '^.')
            let s:c_end = substitute(s:c_end, '^.', '', 'g')
        elseif nr == 21                                                         " ctrl+u clean the message
            let s:c_begin = ''
        elseif nr == 9                                                          " use <tab> complete str
            if s:complete_num == 0
                let complete_base = s:c_begin
            else
                let s:c_begin = complete_base
            endif
            let s:c_begin = s:complete(complete_base, s:complete_num)
            let s:complete_num += 1
        elseif nr == 47                 " if type / and str is none, switch to en method
            if s:c_begin ==# '' && s:c_char ==# '' && s:c_end ==# '' && executable('fcitx-remote')
                call system('fcitx-remote -c')
            endif
            let s:c_begin .= nr2char(nr)
        elseif nr ==# "\<PageUp>"
            let l = line('.') - winheight('$')
            if l < 0
                exe 0
            else
                exe l
            endif
        elseif nr ==# "\<PageDown>"
            exe line('.') + winheight('$')
        elseif nr ==# "\<Up>"
            if s:complete_input_history_num == [0,0]
                let complete_input_history_base = s:c_begin
                let s:c_char = ''
                let s:c_end = ''
            else
                let s:c_begin = complete_input_history_base
            endif
            let s:complete_input_history_num[0] += 1
            let s:c_begin = s:complete_input_history(complete_input_history_base, s:complete_input_history_num)
        elseif nr ==# "\<Down>"
            if s:complete_input_history_num == [0,0]
                let complete_input_history_base = s:c_begin
                let s:c_char = ''
                let s:c_end = ''
            else
                let s:c_begin = complete_input_history_base
            endif
            let s:complete_input_history_num[1] += 1
            let s:c_begin = s:complete_input_history(complete_input_history_base, s:complete_input_history_num)
        else
            let s:c_begin .= nr2char(nr)
        endif
        call s:echon()
    endwhile
    setl nomodifiable
    exe 'bd ' . bufnr(s:name)
    let s:quit_msg_win = 0
    normal! :
    if executable('fcitx-remote')
        call system('fcitx-remote -c')          " switch 2 en
    else
        doautocmd InsertEnter
        doautocmd InsertLeave
    endif
endf

function! s:complete(str, num) abort
    if a:str =~# '^/[a-z]*$'
        let rsl = filter(copy(s:irssi_commands), "v:val =~# a:str .'[^\ .]*'")
        if len(rsl) > 0
            return rsl[a:num % len(rsl)] . ' '
        else
            return a:str
        endif
    elseif a:str =~# '/join\s\+#\?$'
        if len(s:channels) > 0
            return a:str[-1:] ==# '#' ? a:str[:-2] . s:channels[0] : a:str . s:channels[0]
        else
            return a:str
        endif
    elseif a:str =~# '/join\s\+#.\+$'
        let results = filter(deepcopy(s:channels), "v:val =~# '" . substitute(a:str , '^/join\s\+', '', 'g') . "'")
        if len(results) > 0
            return '/join ' . results[a:num % len(results)]
        endif
        return a:str
    elseif index(s:channels, s:current_channel) != -1 && a:str !~# '^/query'
        let names = filter(deepcopy(s:friends), "v:val[0] ==# s:current_channel && v:val[1] =~# '^' . a:str")
        if len(names) > 0
            return names[a:num % len(names)][1] . ': '
        endif
        return a:str
    elseif a:str =~# '^/query\s\+.\+'
        let n_base = substitute(a:str, '^/query\s\+', '', 'g')
        let names = filter(deepcopy(s:friends), "v:val[0] ==# '我的好友' && v:val[1] =~# '^' . n_base")
        if len(names) > 0
            return '/query ' . names[a:num % len(names)][1]
        endif
        return a:str
    else
        return a:str
    endif
endfunction

function! s:complete_input_history(str,num) abort
    let results = filter(copy(s:input_history), "v:val =~# '^' . a:str")
    if len(results) > 0
        call add(results, a:str)
        let index = ((len(results) - 1) - a:num[0] + a:num[1]) % len(results)
        return results[index]
    else
        return a:str
    endif
endfunction

function! s:echon() abort
    redraw
    echohl Comment | echon s:c_base
    echohl None | echon s:c_begin
    echohl Wildmenu | echon s:c_char
    echohl None | echon s:c_end
endfunction

function! s:update_msg_screen() abort
    if index(s:channels, s:current_channel) == -1
        let msgs = filter(deepcopy(s:history), 'len(v:val) == 4 && v:val[3] == s:current_channel')
        let line = [line('.'),line('$')]
        normal! ggdG
        for msg in msgs
            call append(line('$'), msg[0] . repeat(' ', 13 - strwidth(msg[0])) . ' | ' . msg[2])
        endfor
        if line[0] == line[1]
            normal! G
        else
            exe line[0]
        endif
    else
        let msgs = filter(deepcopy(s:history), 'v:val[1] == s:current_channel')
        let line = [line('.'),line('$')]
        normal! ggdG
        for msg in msgs
            call append(line('$'), msg[0] . repeat(' ', 13 - strwidth(msg[0])) . ' | ' . msg[2])
        endfor
        if line[0] == line[1]
            normal! G
        else
            exe line[0]
        endif
    endif
    redraw
    call s:echon()
endfunction

function! s:next_channel() abort
   let id = index(s:opened_channels, s:current_channel)
   let id += 1
   if id > len(s:opened_channels) - 1
       let id = id - len(s:opened_channels)
   endif
   let s:current_channel = s:opened_channels[id]
   if s:current_channel =~# '^#'
       call s:send('/join ' . s:current_channel)
   else
       call s:send('/query ' . s:current_channel)
   endif
   call s:update_msg_screen()
   call s:update_statusline()
endfunction

function! s:previous_channel() abort
   let id = index(s:opened_channels, s:current_channel)
   let id -= 1
   if id < 0
       let id = id + len(s:opened_channels)
   endif
   let s:current_channel = s:opened_channels[id]
   if s:current_channel =~# '^#'
       call s:send('/join ' . s:current_channel)
   else
       call s:send('/query ' . s:current_channel)
   endif
   call s:update_msg_screen()
   call s:update_statusline()
endfunction

function! s:parser_input(str) abort
    if a:str !=# ''
        call add(s:input_history, a:str)
    endif
    if a:str =~# '^/quit\s*$'
        let s:quit_msg_win = 1
        let s:last_channel = s:current_channel
        let s:current_channel = ''
    elseif a:str ==# '/wc'
        let cid = index(s:opened_channels, s:current_channel)
        if cid == -1
        elseif cid == len(s:opened_channels) - 1
            call remove(s:opened_channels, cid)
            call s:send('/WINDOW CLOSE')
            let s:current_channel = get(s:opened_channels, cid - 1, '')
        else
            call remove(s:opened_channels, cid)
            call s:send('/WINDOW CLOSE')
            let s:current_channel = get(s:opened_channels, cid, '')
        endif
        call s:update_statusline()
        call s:update_msg_screen()
        redraw
    elseif a:str =~# '^/join'
        call s:send(a:str)
        let s:current_channel = '#' . split(a:str, '#')[1]
        if index(s:opened_channels, s:current_channel) == -1
            call add(s:opened_channels, s:current_channel)
        endif
        call s:update_statusline()
        call s:update_msg_screen()
        redraw
    elseif a:str =~# '^/query\ \+.\+'
        call s:send(a:str)
        let s:current_channel = substitute(a:str, '^/query\ \+', '', 'g')
        if index(s:opened_channels, s:current_channel) == -1
            call add(s:opened_channels, s:current_channel)
        endif
        call s:update_statusline()
        call s:update_msg_screen()
        redraw
    elseif a:str !~# '^/.*'
        call s:send(a:str)
    endif
endfunction

function! s:update_statusline() abort
    " current channel
    hi! VimQQ1 ctermbg=003 ctermfg=Black guibg=#fabd2f guifg=#282828
    " channel with new msg
    hi! VimQQ2 ctermbg=005 ctermfg=Black guibg=#b16286 guifg=#282828
    " normal channel
    hi! VimQQ3 ctermbg=007 ctermfg=Black guibg=#8ec07c guifg=#282828
    " end
    hi! VimQQ4 ctermbg=243 guibg=#7c6f64
    " current channel + end
    hi! VimQQ5 guibg=#7c6f64 guifg=#fabd2f
    " current channel + new msg channel
    hi! VimQQ6 guibg=#b16286 guifg=#fabd2f
    " current channel + normal channel
    hi! VimQQ7 guibg=#8ec07c guifg=#fabd2f
    " new msg channel + end
    hi! VimQQ8 guibg=#7c6f64 guifg=#b16286
    " new msg channel + current channel
    hi! VimQQ9 guibg=#fabd2f guifg=#b16286
    " new msg channel + normal channel
    hi! VimQQ10 guibg=#8ec07c guifg=#b16286
    " new msg channel + new msg channel
    hi! VimQQ11 guibg=#b16286 guifg=#b16286
    " normal channel + end
    hi! VimQQ12 guibg=#7c6f64 guifg=#8ec07c
    " normal channel + normal channel
    hi! VimQQ13 guibg=#8ec07c guifg=#8ec07c
    " normal channel + new msg channel
    hi! VimQQ14 guibg=#b16286 guifg=#8ec07c
    " normal channel + current channel
    hi! VimQQ15 guibg=#fabd2f guifg=#8ec07c

    let st = ''
    for ch in s:opened_channels
        let ch = substitute(ch, ' ', '\ ', 'g')
        if ch == s:current_channel
            if has_key(s:unread_msg_num, s:current_channel)
                call remove(s:unread_msg_num, s:current_channel)
            endif
            let st .= '%#VimQQ1#[' . ch . ']'
            if index(s:opened_channels, ch) == len(s:opened_channels) - 1
                let st .= '%#VimQQ5#' . s:st_sep
            elseif get(s:unread_msg_num, s:opened_channels[index(s:opened_channels, ch) + 1], 0) > 0
                let st .= '%#VimQQ6#' . s:st_sep
            else
                let st .= '%#VimQQ7#' . s:st_sep
            endif
        else
            let n = get(s:unread_msg_num, ch, 0)
            if n > 0
                let st .= '%#VimQQ2#[' . ch . '(' . n . 'new)]'
                if index(s:opened_channels, ch) == len(s:opened_channels) - 1
                    let st .= '%#VimQQ8#' . s:st_sep
                elseif get(s:unread_msg_num, s:opened_channels[index(s:opened_channels, ch) + 1], 0) > 0
                            \ && s:opened_channels[index(s:opened_channels, ch) + 1] !=# s:current_channel
                    let st .= '%#VimQQ11#' . s:st_sep
                elseif s:opened_channels[index(s:opened_channels, ch) + 1] ==# s:current_channel
                    let st .= '%#VimQQ9#' . s:st_sep
                else
                    let st .= '%#VimQQ10#' . s:st_sep
                endif
            else
                let st .= '%#VimQQ3#[' . ch . ']'
                if index(s:opened_channels, ch) == len(s:opened_channels) - 1
                    let st .= '%#VimQQ12#' . s:st_sep
                elseif get(s:unread_msg_num, s:opened_channels[index(s:opened_channels, ch) + 1], 0) > 0
                            \ && s:opened_channels[index(s:opened_channels, ch) + 1] !=# s:current_channel
                    let st .= '%#VimQQ14#' . s:st_sep
                elseif s:opened_channels[index(s:opened_channels, ch) + 1] ==# s:current_channel
                    let st .= '%#VimQQ15#' . s:st_sep
                else
                    let st .= '%#VimQQ13#' . s:st_sep
                endif
            endif
        endif
    endfor
    let st .= '%#VimQQ4# '
    exe 'set statusline=' . st
    redraw
    call s:echon()
endfunction


fu! s:windowsinit() abort
    " option
    setl fileformat=unix
    setl fileencoding=utf-8
    setl iskeyword=@,48-57,_
    setl noreadonly
    setl buftype=nofile
    setl bufhidden=wipe
    setl noswapfile
    setl nobuflisted
    setl nolist
    setl nonumber
    setl wrap
    setl winfixwidth
    setl winfixheight
    setl textwidth=0
    setl nospell
    setl nofoldenable
endf


let &cpoptions = s:save_cpo
unlet s:save_cpo
