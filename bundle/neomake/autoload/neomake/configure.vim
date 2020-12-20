" Default settings, setup in global config dict.
let s:default_settings = {
            \ 'ignore_filetypes': ['startify'],
            \ }
let g:neomake = get(g:, 'neomake', {})
let g:neomake.automake = get(g:neomake, 'automake', {})
call extend(g:neomake.automake, s:default_settings, 'keep')

if !exists('s:timer_info')
    let s:timer_info = {}
    let s:timer_by_bufnr = {}
endif

let s:default_delay = has('timers') ? 500 : 0

" A mapping of configured buffers with cached settings (maker_jobs).
let s:configured_buffers = {}
" A list of configured/used autocommands.
let s:registered_events = []

" TextChanged gets triggered in this case when loading a buffer (Vim
" issue #2742).
let s:need_to_skip_first_textchanged = !has('nvim-0.3.2') && has('patch-8.0.1494') && !has('patch-8.0.1633')


" TODO: allow for namespaces, and prefer 'automake' here.
" TODO: handle bufnr!  (getbufvar)
function! s:get_setting(name, default) abort
    return get(get(b:, 'neomake', {}), a:name,
                \ get(get(t:, 'neomake', {}), a:name,
                \ get(get(g:, 'neomake', {}), a:name, a:default)))
endfunction


function! s:debug_log(msg, ...) abort
    let context = {'bufnr': bufnr('%')}
    if a:0
        call extend(context, a:1)
    endif
    call neomake#log#debug(printf('automake: %s.', a:msg), context)
endfunction

" Check if buffer's tick (or ft) changed.
function! s:tick_changed(context) abort
    let bufnr = +a:context.bufnr
    let ft = get(a:context, 'ft', getbufvar(bufnr, '&filetype'))
    let prev_tick = getbufvar(bufnr, '_neomake_automake_tick')
    let r = 1
    if empty(prev_tick)
        call s:debug_log('tick changed (new)')
    else
        let cur_tick = [getbufvar(bufnr, 'changedtick'), ft]
        if cur_tick == prev_tick
            call s:debug_log('tick is unchanged')
            return 0
        endif
    endif
    return r
endfunction

function! neomake#configure#_update_automake_tick(bufnr, ft) abort
    if has_key(s:configured_buffers, a:bufnr)
        let tick = getbufvar(a:bufnr, 'changedtick')
        call s:debug_log('updating tick: '.tick)
        call setbufvar(a:bufnr, '_neomake_automake_tick', [tick, a:ft])
    endif
endfunction

function! neomake#configure#_reset_automake_cancelations(bufnr) abort
    if has_key(s:configured_buffers, a:bufnr)
        call setbufvar(a:bufnr, '_neomake_cancelations', [0, 0])
    endif
endfunction

function! s:update_cancel_rate(bufnr, via_timer) abort
    let canceled = getbufvar(a:bufnr, '_neomake_cancelations', [0, 0])
    if a:via_timer
        let canceled[0] += 1
    else
        let canceled[1] += 1
    endif
    call setbufvar(a:bufnr, '_neomake_cancelations', canceled)
    return canceled
endfunction

function! s:handle_changed_buffer(make_id, event) abort
    " Cleanup always.
    if exists('b:_neomake_automake_changed_context')
        let [make_id, prev_tick, changedtick, context] = b:_neomake_automake_changed_context

        if s:need_to_skip_first_textchanged && a:event ==# 'TextChanged'
            if !get(b:, '_neomake_seen_TextChanged', 0)
                call s:debug_log('ignoring first TextChanged')
                let b:_neomake_seen_TextChanged = 1
                return
            endif
        endif

        if changedtick == b:changedtick
            call s:debug_log(printf('handle_changed_buffer: %s: tick was not changed', a:event))
            return
        endif

        unlet b:_neomake_automake_changed_context
        augroup neomake_automake_abort
            au! * <buffer>
        augroup END
    else
        return
    endif

    if make_id != a:make_id
        call neomake#log#warning(printf('automake: handle_changed_buffer: mismatched make_id: %d != %d.', make_id, a:make_id))
        return
    endif

    let window_make_ids = get(w:, 'neomake_make_ids', [])
    if index(window_make_ids, a:make_id) == -1
        return
    endif

    call setbufvar(context.bufnr, '_neomake_automake_tick', prev_tick)
    call filter(b:_neomake_automake_make_ids, 'v:val != '.a:make_id)
    call s:update_cancel_rate(context.bufnr, 0)

    call s:debug_log(printf('buffer was changed (%s), canceling make', a:event), {'make_id': a:make_id})
    call neomake#CancelMake(a:make_id)

    if a:event ==# 'TextChangedI'
        call s:debug_log('queueing make restart for InsertLeave', {'make_id': a:make_id})
        let b:_neomake_postponed_automake_context = [1, context]
        augroup neomake_automake_retry
            au! * <buffer>
            autocmd InsertLeave <buffer> call s:do_postponed_automake(2)
        augroup END
    elseif context.delay
        call s:debug_log(printf('restarting timer for original event %s', context.event), {'make_id': a:make_id})
        if has_key(context, '_via_timer_cb')
            unlet context._via_timer_cb
        endif
        if has_key(context, 'pos')
            unlet context.pos
        endif
        call s:neomake_do_automake(context)
    else
        call s:debug_log(printf('restarting for original event (%s) without delay', context.event))
        call s:neomake_do_automake(context)
    endif
endfunction

function! s:neomake_do_automake(context) abort
    let bufnr = +a:context.bufnr
    if s:skip_for_running_jobs(bufnr)
        return
    endif

    if !get(a:context, '_via_timer_cb') && a:context.delay
        if exists('s:timer_by_bufnr[bufnr]')
            let timer = s:timer_by_bufnr[bufnr]
            call s:stop_timer(timer)
            call s:debug_log(printf('stopped existing timer: %d', timer), {'bufnr': bufnr})
            call s:update_cancel_rate(bufnr, 1)
        endif
        if !s:tick_changed(a:context)
            call s:debug_log('buffer was not changed', {'bufnr': bufnr})
            return
        endif

        " Cancel any already running automake runs.
        let prev_make_ids = getbufvar(bufnr, '_neomake_automake_make_ids')
        if !empty(prev_make_ids)
            call s:debug_log(printf('stopping previous make runs: %s', join(prev_make_ids, ', ')))
            for prev_make_id in prev_make_ids
                call neomake#CancelMake(prev_make_id)
            endfor
            let canceled = s:update_cancel_rate(bufnr, 0)
        else
            let canceled = getbufvar(bufnr, '_neomake_cancelations', [0, 0])
        endif

        let delay = a:context.delay

        " Increase delay for canceled/restarted timers, and canceled makes.
        " IDEA: take into account the mean duration of this make run.
        if canceled[0] || canceled[1]
            let [mult_timers, mult_makes, max_delay] = neomake#config#get('automake.cancelation_delay', [0.2, 0.5, 3000], {'bufnr': bufnr})
            let cancel_rate = 1 + (canceled[0]*mult_timers + canceled[1]*mult_makes)
            let delay = min([max_delay, float2nr(ceil(delay * cancel_rate))])
            call s:debug_log(printf('increasing delay (%d/%d canceled timers/makes, rate=%.2f): %d => %d/%d', canceled[0], canceled[1], cancel_rate, a:context.delay, delay, max_delay))
        endif

        let timer = timer_start(delay, function('s:automake_delayed_cb'))
        let s:timer_info[timer] = a:context
        if !has_key(a:context, 'pos')
            let s:timer_info[timer].pos = s:get_position_context()
        endif
        let s:timer_by_bufnr[bufnr] = timer
        call s:debug_log(printf('started timer (%dms): %d', delay, timer),
                    \ {'bufnr': a:context.bufnr})
        return
    endif

    let ft = getbufvar(bufnr, '&filetype')
    let event = a:context.event

    call s:debug_log('neomake_do_automake: '.event, {'bufnr': bufnr})
    if !s:tick_changed({'event': event, 'bufnr': bufnr, 'ft': ft})
        call s:debug_log('buffer was not changed', {'bufnr': bufnr})
        return
    endif
    let prev_tick = getbufvar(bufnr, '_neomake_automake_tick')

    call s:debug_log(printf('enabled makers: %s', join(map(copy(a:context.maker_jobs), 'v:val.maker.name'), ', ')))
    let make_options = {
                \ 'file_mode': 1,
                \ 'jobs': deepcopy(a:context.maker_jobs),
                \ 'ft': ft,
                \ 'automake': 1}
    let jobinfos = neomake#Make(make_options)

    let started_jobs = filter(copy(jobinfos), "!get(v:val, 'finished', 0)")
    call s:debug_log(printf('started jobs: %s', string(map(copy(started_jobs), 'v:val.id'))))
    if !empty(started_jobs)
        let make_id = jobinfos[0].make_id
        call setbufvar(bufnr, '_neomake_automake_make_ids',
                    \ neomake#compat#getbufvar(bufnr, '_neomake_automake_make_ids', []) + [make_id])

        " Setup buffer autocmd to cancel/restart make for changed buffer.
        let events = []
        for event in ['TextChangedI', 'TextChanged']
            if a:context.event !=# event
                call add(events, event)
            endif
        endfor
        call setbufvar(bufnr, '_neomake_automake_changed_context', [make_id, prev_tick, getbufvar(bufnr, 'changedtick'), a:context])
        augroup neomake_automake_abort
            exe printf('au! * <buffer=%d>', bufnr)
            for event in events
                exe printf('autocmd %s <buffer=%d> call s:handle_changed_buffer(%s, %s)',
                            \ event, bufnr, string(make_id), string(event))
            endfor
        augroup END
    endif
endfunction

function! s:get_position_context() abort
    let w = exists('*win_getid') ? win_getid() : winnr()
    return [w, getpos('.'), neomake#compat#get_mode()]
endfunction

function! s:automake_delayed_cb(timer) abort
    let timer_info = s:timer_info[a:timer]
    unlet s:timer_info[a:timer]
    unlet s:timer_by_bufnr[timer_info.bufnr]

    if !bufexists(timer_info.bufnr)
        call s:debug_log(printf('buffer does not exist anymore for timer %d', a:timer),
                    \ {'bufnr': timer_info.bufnr})
        return
    endif

    call s:debug_log(printf('callback for timer %d (via %s)', string(a:timer), timer_info.event),
                \ {'bufnr': timer_info.bufnr})

    let bufnr = bufnr('%')
    if timer_info.bufnr != bufnr
        call s:debug_log(printf('buffer changed: %d => %d, queueing make restart for BufEnter,WinEnter',
                    \ timer_info.bufnr, bufnr))
        let restart_context = copy(timer_info)
        call setbufvar(restart_context.bufnr, '_neomake_postponed_automake_context', [1, restart_context])
        let b:_neomake_postponed_automake_context = [1, restart_context]
        augroup neomake_automake_retry
            exe 'au! * <buffer='.timer_info.bufnr.'>'
            exe 'autocmd BufEnter,WinEnter <buffer='.restart_context.bufnr.'> call s:do_postponed_automake(2)'
        augroup END
        return
    endif

    if neomake#compat#in_completion()
        call s:debug_log('postponing automake during completion')
        if has_key(timer_info, 'pos')
            unlet timer_info.pos
        endif
        let b:_neomake_postponed_automake_context = [0, timer_info]

        augroup neomake_automake_retry
            au! * <buffer>
            autocmd CompleteDone <buffer> call s:do_postponed_automake(1)
            autocmd InsertLeave <buffer> call s:do_postponed_automake(2)
        augroup END
        return
    endif

    " Verify context/position is the same.
    " This is meant to give an additional delay after e.g. TextChanged.
    " Only events with delay are coming here, so this does not affect
    " BufWritePost etc typically.
    if !empty(timer_info.pos)
        let current_context = s:get_position_context()
        if current_context != timer_info.pos
            if current_context[2] != timer_info.pos[2]
                " Mode was changed.
                if current_context[2][0] ==# 'i' && timer_info.event !=# 'TextChangedI'
                    " Changed to insert mode, trigger on InsertLeave.
                    call s:debug_log(printf('context/position changed: %s => %s, restarting on InsertLeave',
                                \ string(timer_info.pos), string(current_context)))
                    let context = copy(timer_info)
                    let context.delay = 0
                    unlet context.pos
                    call s:update_cancel_rate(bufnr, 1)
                    let b:_neomake_postponed_automake_context = [1, context]
                    augroup neomake_automake_retry
                        au! * <buffer>
                        autocmd InsertLeave <buffer> call s:do_postponed_automake(2)
                    augroup END
                    return
                endif
            endif
            call s:debug_log(printf('context/position changed: %s => %s, restarting',
                        \ string(timer_info.pos), string(current_context)))
            unlet timer_info.pos
            call s:update_cancel_rate(bufnr, 1)
            call s:neomake_do_automake(timer_info)
            return
        endif
    endif
    " endif

    let context = copy(timer_info)
    let context._via_timer_cb = 1
    call s:neomake_do_automake(context)
endfunction

function! s:do_postponed_automake(step) abort
    if exists('b:_neomake_postponed_automake_context')
        let context = b:_neomake_postponed_automake_context

        if context[0] == a:step - 1
            if a:step == 2
                call s:debug_log('re-starting postponed automake')
                let context[1].pos = s:get_position_context()
                call s:neomake_do_automake(context[1])
            else
                let context[0] = a:step
                return
            endif
        else
            call s:debug_log('postponed automake: unexpected step '.a:step.', cleaning up')
        endif
        unlet b:_neomake_postponed_automake_context
    else
        call s:debug_log('missing context information for postponed automake')
    endif
    " Cleanup.
    augroup neomake_automake_retry
        autocmd! * <buffer>
    augroup END
endfunction

" Parse/get events dict from args.
" a:config: config dict to write into.
" a:string_or_dict_config: a string or dict describing the config.
" a:1: default delay.
function! s:parse_events_from_args(config, string_or_dict_config, ...) abort
    " Get default delay from a:1.
    if a:0
        if has('timers')
            let delay = a:1
        else
            if a:1 != 0
                call neomake#log#warning('automake: timer support is required for delayed events.')
            endif
            let delay = 0
        endif
    else
        let delay = s:default_delay
    endif

    if type(a:string_or_dict_config) == type({})
        let events = copy(a:string_or_dict_config)

        " Validate events.
        for [event, config] in items(events)
            if !exists('##'.event)
                call neomake#log#error(printf(
                            \ 'automake: event %s does not exist.', event))
                unlet events[event]
                continue
            endif

            if get(config, 'delay', 0) && !has('timers')
                call neomake#log#error(printf(
                            \ 'automake: timer support is required for automaking, removing event %s.',
                            \ event))
                unlet events[event]
            endif
        endfor
        call neomake#config#set_dict(a:config, 'automake.events', events)
        if a:0
            let a:config.automake_delay = a:1
        endif
    else
        " Map string config to events dict.
        let modes = split(a:string_or_dict_config, '\zs')
        let events = {}
        let default_with_delay = {}

        let unknown = []
        for mode in modes
            " Insert mode.
            if mode ==# 'i'
                if exists('##TextChangedI') && has('timers')
                    let events['TextChangedI'] = default_with_delay
                else
                    call s:debug_log('using CursorHoldI instead of TextChangedI')
                    let events['CursorHoldI'] = (delay != 0 ? {'delay': 0} : {})
                endif
            " Normal mode.
            elseif mode ==# 'n'
                if exists('##TextChanged') && has('timers')
                    let events['TextChanged'] = default_with_delay
                    if !has_key(events, 'TextChangedI')
                        " Run when leaving insert mode, since only TextChangedI would be triggered
                        " for `ciw` etc.
                        let events['InsertLeave'] = default_with_delay
                    endif
                else
                    call s:debug_log('using CursorHold instead of TextChanged')
                    let events['CursorHold'] = (delay != 0 ? {'delay': 0} : {})
                    let events['InsertLeave'] = (delay != 0 ? {'delay': 0} : {})
                endif
            " On writes.
            elseif mode ==# 'w'
                let events['BufWritePost'] = (delay != 0 ? {'delay': 0} : {})
            " On reads.
            elseif mode ==# 'r'
                let events['BufWinEnter'] = {}
                let events['FileType'] = {}

                " When a file was changed outside of Vim.
                " TODO: test
                let events['FileChangedShellPost'] = {}
                " XXX: FileType might work better, at least when wanting to skip filetypes.
                " let events['FileType'] = {'delay': a:0 > 1 ? delay : 0}
            else
                let unknown += [mode]
            endif
        endfor
        if !empty(unknown)
            call neomake#log#error(printf('unknown modes in string automake config (%s): %s.',
                        \ a:string_or_dict_config, join(unknown, ', ')))
        endif
    endif

    call neomake#config#set_dict(a:config, 'automake.events', events)
    if a:0
        let a:config.automake_delay = delay
    endif
endfunction

" Setup automake for buffer (current, or options.bufnr).
" a:1: delay
" a:2: options ('bufnr', 'makers') / or list of makers  TODO
function! neomake#configure#automake_for_buffer(string_or_dict_config, ...) abort
    let options = {}
    if a:0
        let options.delay = a:1
    endif
    let bufnr = bufnr('%')
    if a:0 > 1
        if type(a:2) == type([])
            let options.makers = a:2
        else
            call extend(options, a:2)
            if has_key(options, 'bufnr')
                let bufnr = options.bufnr
                unlet options.bufnr
            endif
        endif
    endif
    return call('s:configure_buffer', [bufnr, a:string_or_dict_config, options])
endfunction

" Workaround for getbufvar not having support for defaults.
function! s:getbufvar(bufnr, name, default) abort
    let b_dict = getbufvar(+a:bufnr, '')
    if empty(b_dict)
        " NOTE: it is an empty string for non-existing buffers.
        return a:default
    endif
    return get(b_dict, a:name, a:default)
endfunction

function! s:is_buffer_ignored(bufnr) abort
    " TODO: blacklist/whitelist.
    let bufnr = +a:bufnr
    let buftype = getbufvar(bufnr, '&buftype')
    if !empty(buftype)
        call s:debug_log(printf('ignoring buffer with buftype=%s', buftype), {'bufnr': bufnr})
        return 1
    endif

    let ft = getbufvar(bufnr, '&filetype')
    if index(neomake#config#get('automake.ignore_filetypes', []), ft) != -1
        call s:debug_log(printf('ignoring buffer with filetype=%s', ft), {'bufnr': bufnr})
        return 1
    endif
endfunction

if exists('##OptionSet')
    function! s:update_buffer_options() abort
        let bufnr = bufnr('%')
        call s:maybe_reconfigure_buffer(bufnr)
    endfunction
    augroup neomake_automake_update
        au!
        au OptionSet buftype call s:update_buffer_options()
    augroup END
endif

" a:1: string or dict describing the events
" a:2: options ('delay', 'makers')
function! s:configure_buffer(bufnr, ...) abort
    let bufnr = +a:bufnr
    let ft = getbufvar(bufnr, '&filetype')
    let config = s:getbufvar(bufnr, 'neomake', {})
    let old_config = deepcopy(config)
    if a:0
        let args = [config, a:1]
        if a:0 > 1 && has_key(a:2, 'delay')
            let args += [a:2.delay]
        endif
        call call('s:parse_events_from_args', args)
        call setbufvar(bufnr, 'neomake', config)

        let implicit_config = {'custom': 1, 'ignore': 0}
    else
        let implicit_config = {'custom': 0, 'ignore': s:is_buffer_ignored(bufnr)}
    endif

    " Register the buffer, and remember if it is custom.
    if has_key(s:configured_buffers, bufnr)
        let old_registration = copy(get(s:configured_buffers, bufnr, {}))
        call extend(s:configured_buffers[bufnr], implicit_config, 'force')
    else
        let s:configured_buffers[bufnr] = implicit_config

        augroup neomake_automake_clean
            autocmd BufWipeout <buffer> call s:neomake_automake_clean(expand('<abuf>'))
        augroup END
    endif

    if implicit_config.ignore
        return s:configured_buffers[bufnr]
    endif

    let s:configured_buffers[bufnr].events_config = neomake#config#get('automake.events', {})

    " Create jobs.
    let options = a:0 > 1 ? a:2 : {}
    if has_key(options, 'makers')
        let makers = neomake#map_makers(options.makers, ft, 0)
        let source = 'options'
    else
        let [makers, source] = neomake#config#get_with_source('automake.enabled_makers')
        if makers is g:neomake#config#undefined
            unlet makers
            let makers = neomake#GetEnabledMakers(ft)
        else
            let makers = neomake#map_makers(makers, ft, 0)
        endif
    endif
    let options = {'file_mode': 1, 'ft': ft, 'bufnr': bufnr, 'automake': 1}
    let jobs = neomake#core#create_jobs(options, makers)
    let s:configured_buffers[bufnr].maker_jobs = jobs
    call s:debug_log(printf('configured buffer for ft=%s (%s)',
                \ ft, empty(jobs) ? 'no enabled makers' : join(map(copy(jobs), 'v:val.maker.name'), ', ').' ('.source.')'), {'bufnr': bufnr})
    if old_config != config
        call s:debug_log('resetting tick because of config changes')
        call setbufvar(bufnr, '_neomake_automake_tick', [])
    elseif exists('old_registration')
        if old_registration != s:configured_buffers[bufnr]
            call s:debug_log('resetting tick because of registration changes')
            call setbufvar(bufnr, '_neomake_automake_tick', [])
        endif
    else
        call s:debug_log('setting tick for new buffer')
        call setbufvar(bufnr, '_neomake_automake_tick', [])
    endif

    if a:0
        " Setup autocommands etc (when called manually)?!
        call neomake#configure#automake()
    endif
    return config
endfunction

function! s:maybe_reconfigure_buffer(bufnr) abort
    if has_key(s:configured_buffers, a:bufnr) && !s:configured_buffers[a:bufnr].custom
        call s:configure_buffer(a:bufnr)
    endif
endfunction

function! s:skip_for_running_jobs(bufnr) abort
    let running_jobs = values(filter(copy(neomake#_get_s().jobs),
                        \ 'v:val.bufnr == a:bufnr'
                        \ .' && v:val.file_mode == 1'
                        \ .' && !get(v:val, "automake", 0)'
                        \ ." && !get(v:val, 'canceled')"))
    if !empty(running_jobs)
        call s:debug_log(printf('skipping for already running jobs: %s',
                    \ string(map(running_jobs, 'v:val.as_string()'))),
                    \ {'bufnr': a:bufnr})
        return 1
    endif
endfunction

" Called from autocommands.
function! s:neomake_automake(event, bufnr) abort
    let disabled = neomake#config#get_with_source('disabled', 0)
    if disabled[0]
        call s:debug_log(printf('disabled (%s)', disabled[1]))
        return
    endif
    let bufnr = +a:bufnr

    if has_key(s:configured_buffers, bufnr)
        let buffer_config = s:configured_buffers[bufnr]
    else
        " Register the buffer, and remember that it's automatic.
        let buffer_config = s:configure_buffer(bufnr)
    endif
    if get(buffer_config, 'ignore', 0)
        " NOTE: might be too verbose.
        call s:debug_log('buffer is ignored')
        return
    endif

    if s:need_to_skip_first_textchanged && a:event ==# 'TextChanged'
        if !getbufvar(bufnr, '_neomake_seen_TextChanged', 0)
            call s:debug_log('ignoring first TextChanged')
            call setbufvar(bufnr, '_neomake_seen_TextChanged', 1)
            return
        endif
    endif

    call s:debug_log(printf('handling event %s', a:event), {'bufnr': bufnr})

    if empty(s:configured_buffers[bufnr].maker_jobs)
        call s:debug_log('no enabled makers', {'bufnr': bufnr})
        return
    endif

    if s:skip_for_running_jobs(bufnr)
        return
    endif

    call s:debug_log(printf('automake for event %s', a:event), {'bufnr': bufnr})
    let config = s:configured_buffers[bufnr].events_config
    if !has_key(config, a:event)
        call s:debug_log('event is not registered', {'bufnr': bufnr})
        return
    endif
    let config = config[a:event]

    let event = a:event
    let bufnr = +a:bufnr
    " TODO: rename to neomake.automake.delay
    let delay = get(config, 'delay', s:get_setting('automake_delay', s:default_delay))
    let context = {
                \ 'delay': delay,
                \ 'bufnr': bufnr,
                \ 'event': a:event,
                \ 'maker_jobs': s:configured_buffers[bufnr].maker_jobs,
                \ }
    if event ==# 'BufWinEnter'
        " Ignore context, so that e.g. with vim-stay restoring the view
        " (cursor position), it will still be triggered.
        let context.pos = []
    endif
    call s:neomake_do_automake(context)
endfunction

function! s:stop_timer(timer) abort
    let timer_info = s:timer_info[a:timer]
    unlet s:timer_info[a:timer]
    unlet s:timer_by_bufnr[timer_info.bufnr]
    call timer_stop(+a:timer)
endfunction

function! s:stop_timers() abort
    let timers = keys(s:timer_info)
    if !empty(timers)
        call s:debug_log(printf('stopping timers: %s', join(timers, ', ')))
        for timer in timers
            call s:stop_timer(timer)
        endfor
    endif
endfunction

function! neomake#configure#reset_automake() abort
    for bufnr in keys(s:configured_buffers)
        call s:neomake_automake_clean(bufnr)
    endfor
    let s:registered_events = []
    call s:stop_timers()
    call neomake#configure#automake()
endfunction

function! s:neomake_automake_clean(bufnr) abort
    if has_key(s:timer_by_bufnr, a:bufnr)
        let timer = s:timer_by_bufnr[a:bufnr]
        call s:stop_timer(timer)
        call s:debug_log('stopped timer for cleaned buffer: '.timer)
    endif
    if has_key(s:configured_buffers, a:bufnr)
        unlet s:configured_buffers[a:bufnr]
        augroup neomake_automake_clean
            exe printf('au! * <buffer=%d>', a:bufnr)
        augroup END
    endif
endfunction

function! neomake#configure#disable_automake() abort
    call s:debug_log('disabling globally')
    call s:stop_timers()
endfunction

function! neomake#configure#disable_automake_for_buffer(bufnr) abort
    call s:debug_log(printf('disabling buffer %d', a:bufnr))
    if has_key(s:timer_by_bufnr, a:bufnr)
        let timer = s:timer_by_bufnr[a:bufnr]
        call s:stop_timer(timer)
        call s:debug_log('stopped timer for buffer: '.timer)
    endif
    if has_key(s:configured_buffers, a:bufnr)
        let s:configured_buffers[a:bufnr].disabled = 1
    endif
endfunction

function! neomake#configure#enable_automake_for_buffer(bufnr) abort
    if exists('s:configured_buffers[a:bufnr].disabled')
        call s:debug_log(printf('Re-enabled buffer %d', a:bufnr))
        unlet s:configured_buffers[a:bufnr].disabled
    endif
endfunction

function! neomake#configure#reset_automake_for_buffer(...) abort
    let bufnr = a:0 ? +a:1 : bufnr('%')
    call s:neomake_automake_clean(bufnr)
endfunction

function! neomake#configure#automake(...) abort
    call s:debug_log(printf('configuring automake: %s', string(a:000)))
    if !exists('g:neomake')
        let g:neomake = {}
    endif
    if a:0
        call call('s:parse_events_from_args', [g:neomake] + a:000)
    endif

    let disabled_globally = get(get(g:, 'neomake', {}), 'disabled', 0)
    if disabled_globally
        let s:registered_events = []
    else
        let s:registered_events = keys(get(get(g:neomake, 'automake', {}), 'events', {}))
    endif
    " Keep custom configured buffers.
    call filter(s:configured_buffers, 'v:val.custom')
    for b in keys(s:configured_buffers)
        if empty(s:configured_buffers[b].maker_jobs)
            continue
        endif
        if get(s:configured_buffers[b], 'disabled', 0)
            continue
        endif
        let b_cfg = neomake#config#get('b:automake.events', {})
        for event_config in items(b_cfg)
            let event = event_config[0]
            if index(s:registered_events, event) == -1
                call add(s:registered_events, event)
            endif
        endfor
    endfor
    call s:debug_log('registered events: '.join(s:registered_events, ', '))

    augroup neomake_automake
        au!
        for event in s:registered_events
            exe 'autocmd '.event." * call s:neomake_automake('".event."', expand('<abuf>'))"
        endfor
    augroup END
    if empty(s:registered_events)
        augroup! neomake_automake
    endif
endfunction

augroup neomake_automake_base
    au!
    autocmd FileType * call s:maybe_reconfigure_buffer(expand('<abuf>'))
augroup END
" vim: ts=4 sw=4 et
