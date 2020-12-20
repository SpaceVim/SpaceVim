if !exists('s:action_queue')
    let s:action_queue = []
endif
if !exists('s:action_queue_registered_events')
    let s:action_queue_registered_events = []
endif
let s:action_queue_timer_timeouts = get(g:, 'neomake_action_queue_timeouts', {1: 100, 2: 200, 3: 500})

let g:neomake#action_queue#processed = {}
let g:neomake#action_queue#not_processed = {}
let g:neomake#action_queue#any_event = []

let g:neomake#action_queue#_s = s:

function! s:actionname(funcref) abort
    let s = string(a:funcref)
    let r = matchstr(s, '\v^^function\(''\zs.*\ze''\)$')
    if empty(r)
        return s
    endif
    return substitute(r, '\v^(\<SNR\>\d+_|s:)', '', '')
endfunction

" Queue an action to be processed later for autocmd a:event or through a timer
" for a:event=Timer.
" It will call a:data[0], with a:data[1] as args (where the first should be
" a jobinfo object).  The callback should return 1 if it was successful,
" with 0 it will be re-queued.
" When called recursively (queuing the same event/data again, it will be
" re-queued also).
function! neomake#action_queue#add(events, data) abort
    let job_or_make_info = a:data[1][0]
    if a:events is# g:neomake#action_queue#any_event
        call neomake#log#debug(printf('Queuing action %s for any event.',
                    \ s:actionname(a:data[0])), job_or_make_info)
    else
        call neomake#log#debug(printf('Queuing action %s for %s.',
                    \ s:actionname(a:data[0]), join(a:events, ', ')), job_or_make_info)
    endif

    for event in a:events
        if event ==# 'Timer'
            if !has_key(job_or_make_info, 'action_queue_timer_tries')
                let job_or_make_info.action_queue_timer_tries = {'count': 1, 'data': a:data[0]}
            else
                let job_or_make_info.action_queue_timer_tries.count += 1
            endif
            if has_key(s:action_queue_timer_timeouts, job_or_make_info.action_queue_timer_tries.count)
                let timeout = s:action_queue_timer_timeouts[job_or_make_info.action_queue_timer_tries.count]
            else
                throw printf('Neomake: Giving up handling Timer callbacks after %d attempts. Please report this. See :messages for more information.', len(s:action_queue_timer_timeouts))
            endif
            if has('timers')
                if exists('s:action_queue_timer')
                    call timer_stop(s:action_queue_timer)
                endif
                let s:action_queue_timer = timer_start(timeout, function('s:process_action_queue_timer_cb'))
                call neomake#log#debug(printf(
                            \ 'Retrying Timer event in %dms (timer %d).',
                            \ timeout, s:action_queue_timer), job_or_make_info)
            else
                call neomake#log#debug('Retrying Timer event on CursorHold(I).', job_or_make_info)
                if !exists('#neomake_event_queue#CursorHold')
                    let s:action_queue_registered_events += ['CursorHold', 'CursorHoldI']
                    augroup neomake_event_queue
                        exe 'autocmd CursorHold,CursorHoldI * call s:process_action_queue('''.event.''')'
                    augroup END
                endif
            endif
        else
            if !exists('#neomake_event_queue#'.event)
                let s:action_queue_registered_events += [event]
                augroup neomake_event_queue
                    exe 'autocmd '.event.' * call s:process_action_queue('''.event.''')'
                augroup END
            endif
        endif
    endfor
    call add(s:action_queue, [a:events, a:data])
    return g:neomake#action_queue#not_processed
endfunction

" Remove any queued actions for a jobinfo or make_info object.
function! neomake#action_queue#clean(job_or_make_info) abort
    let len_before = len(s:action_queue)
    call filter(s:action_queue, 'v:val[1][1][0] != a:job_or_make_info')
    let removed = len_before - len(s:action_queue)
    if removed
        call s:clean_action_queue_events()
        call neomake#log#debug(printf(
                    \ 'Removed %d action queue entries.',
                    \ removed), a:job_or_make_info)
    endif
endfunction

" Remove given action for a jobinfo or make_info object.
function! neomake#action_queue#remove(job_or_make_info, action) abort
    let len_before = len(s:action_queue)
    call filter(s:action_queue, 'v:val[1][1][0] != a:job_or_make_info || v:val[1][0] != a:action')
    let removed = len_before - len(s:action_queue)
    if removed
        call s:clean_action_queue_events()
        call neomake#log#debug(printf(
                    \ 'Removed %d action queue entries for %s.',
                    \ removed, s:actionname(a:action)), a:job_or_make_info)
    endif
endfunction

function! s:process_action_queue_timer_cb(...) abort
    call neomake#log#debug(printf(
                \ 'action queue: callback for Timer queue (%d).', s:action_queue_timer))
    unlet s:action_queue_timer
    call s:process_action_queue('Timer')
endfunction

function! s:process_action_queue(event) abort
    let queue = s:action_queue
    let q_for_this_event = []
    let i = 0
    if g:neomake#core#_ignore_autocommands
        call neomake#log#debug(printf('action queue: skip processing for %s (ignore_autocommands=%d).',
                    \ a:event, g:neomake#core#_ignore_autocommands),
                    \ {'bufnr': bufnr('%'), 'winnr': winnr()})
        return
    endif
    for [events, v] in queue
        if index(events, a:event) != -1 || events is# g:neomake#action_queue#any_event
            call add(q_for_this_event, [i, v])
        endif
        let i += 1
    endfor
    call neomake#log#debug(printf('action queue: processing for %s (%d items).',
                \ a:event, len(q_for_this_event)), {'bufnr': bufnr('%'), 'winnr': winnr()})
    call neomake#log#indent(1)

    let processed = []
    let removed = 0
    let stop_processing = {'make_id': [], 'job_id': []}
    for [idx_q_for_this_event, data] in q_for_this_event
        let job_or_make_info = data[1][0]
        let current_event = remove(queue, idx_q_for_this_event - removed)
        let removed += 1

        let make_id_job_id = {}  " make_id/job_id relevant to re-queue following.
        if has_key(job_or_make_info, 'make_id')
            if has_key(job_or_make_info, 'options')
                let make_id_job_id = {
                            \ 'make_id': job_or_make_info.make_id,
                            \ }
            else
                let make_id_job_id = {
                            \ 'make_id': job_or_make_info.make_id,
                            \ 'job_id': job_or_make_info.id,
                            \ }
            endif
        endif

        " Skip/re-queue entries for same make/job.
        let skip = 0
        for [prop_name, prop_value] in items(make_id_job_id)
            if index(stop_processing[prop_name], prop_value) != -1
                call neomake#log#debug(printf('action queue: skipping %s for not processed %s.',
                            \ s:actionname(data[0]), prop_name), job_or_make_info)
                call add(queue, current_event)
                let skip = 1
                break
            endif
        endfor
        if skip
            continue
        endif

        call neomake#log#debug(printf('action queue: calling %s.',
                    \ s:actionname(data[0])), job_or_make_info)
        let queue_before_call = copy(queue)
        try
            " Call the queued action.  On failure they should have requeued
            " themselves already.
            let rv = call(data[0], data[1])
        catch
            if v:exception =~# '^Neomake: '
                let error = substitute(v:exception, '^Neomake: ', '', '')
            else
                let error = printf('Error during action queue processing: %s.',
                      \ v:exception)
            endif
            call neomake#log#exception(error, job_or_make_info)

            " Cancel job in case its action failed to get re-queued after X
            " attempts.
            if has_key(job_or_make_info, 'id')
                call neomake#CancelJob(job_or_make_info.id)
            endif
            continue
        endtry
        if rv is# g:neomake#action_queue#processed
            let processed += [data]
            continue
        endif

        if rv is# g:neomake#action_queue#not_processed
            if a:event !=# 'Timer' && has_key(job_or_make_info, 'action_queue_timer_tries')
                call neomake#log#debug('s:process_action_queue: decrementing timer tries for non-Timer event.', job_or_make_info)
                let job_or_make_info.action_queue_timer_tries.count -= 1
            endif

            " Requeue any entries for the same job.
            let i = 0
            for q in queue_before_call
                for [prop_name, prop_value] in items(make_id_job_id)
                    " Assert current_event != q
                    if get(q[1][1][0], prop_name) == prop_value
                        call neomake#log#debug(printf('action queue: re-queuing %s for not processed %s.',
                                    \ s:actionname(q[1][0]), prop_name), job_or_make_info)
                        call add(queue, remove(queue, i))
                        let i -= 1
                        break
                    endif
                endfor
                let i += 1
            endfor
            for [prop_name, prop_value] in items(make_id_job_id)
                call add(stop_processing[prop_name], prop_value)
            endfor
        else
            let args_str = neomake#utils#Stringify(data[1])
            throw printf('Internal Neomake error: hook function %s(%s) returned unexpected value (%s)', data[0], args_str, rv)
        endif
    endfor
    call neomake#log#debug(printf('action queue: processed %d items.',
                \ len(processed)), {'bufnr': bufnr('%')})
    call neomake#log#indent(-1)

    call s:clean_action_queue_events()
endfunction

if has('timers')
    function! s:get_left_events() abort
        let r = {}
        for [events, _] in s:action_queue
            for event in events
                let r[event] = 1
            endfor
        endfor
        return keys(r)
    endfunction
else
    function! s:get_left_events() abort
        let r = {}
        for [events, _] in s:action_queue
            for event in events
                if event ==# 'Timer'
                    let r['CursorHold'] = 1
                    let r['CursorHoldI'] = 1
                else
                    let r[event] = 1
                endif
            endfor
        endfor
        return keys(r)
    endfunction
endif

function! neomake#action_queue#get_queued_actions(jobinfo) abort
    " Check if there are any queued actions for this job.
    let queued_actions = []
    for [events, v] in s:action_queue
        if v[1][0] == a:jobinfo
            let queued_actions += [[s:actionname(v[0]), events]]
        endif
    endfor
    return queued_actions
endfunction

function! s:clean_action_queue_events() abort
    let left_events = s:get_left_events()

    if empty(left_events)
        if exists('#neomake_event_queue')
            autocmd! neomake_event_queue
            augroup! neomake_event_queue
        endif
    else
        let clean_events = []
        for event in s:action_queue_registered_events
            if index(left_events, event) == -1
                let clean_events += [event]
            endif
        endfor
        if !empty(clean_events)
            augroup neomake_event_queue
            for event in clean_events
                if exists('#neomake_event_queue#'.event)
                    exe 'au! '.event
                endif
            endfor
            augroup END
        endif
    endif
    let s:action_queue_registered_events = left_events

    if index(left_events, 'Timer') == -1
        if exists('s:action_queue_timer')
            call timer_stop(s:action_queue_timer)
            unlet s:action_queue_timer
        endif
    endif
endfunction
" vim: ts=4 sw=4 et
