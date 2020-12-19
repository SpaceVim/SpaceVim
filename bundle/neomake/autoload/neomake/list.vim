scriptencoding utf-8
" Create a List object from a quickfix/location list.
" TODO: (optionally?) add entries sorted?  (errors first, grouped by makers (?) etc)

let s:can_set_qf_title = has('patch-7.4.2200')
let s:can_set_qf_context = has('patch-8.0.0590')
let s:can_set_qf_items = has('patch-8.0.0657')
let s:has_support_for_qfid = has('patch-8.0.1023')
let s:use_efm_parsing = has('patch-8.0.1040')  " 'efm' in setqflist/getqflist

" Do we need to replace (instead of append) the location/quickfix list, for
" :lwindow to not open it with only invalid entries?!
" Without patch-7.4.379 this does not work though, and a new list needs to
" be created (which is not done).
" @vimlint(EVL108, 1)
let s:needs_to_replace_qf_for_lwindow = has('patch-7.4.379')
            \ && (!has('patch-7.4.1752') || (has('nvim') && !has('nvim-0.2.0')))
" @vimlint(EVL108, 0)
let s:needs_to_init_qf_for_lwindow = !has('patch-8.1.0622')

function! s:save_list_ref(list) abort
    if a:list.type ==# 'loclist'
        for d in [w:, b:]
            let info = get(d, '_neomake_info', {})
            let info['loclist'] = a:list
            let d['_neomake_info'] = info
        endfor
    else
        let info = get(g:, '_neomake_info', {})
        let info['qflist'] = a:list
        let g:_neomake_info = info
    endif
endfunction

function! neomake#list#ListForMake(make_info) abort
    let file_mode = a:make_info.options.file_mode
    let type = file_mode ? 'loclist' : 'quickfix'
    let list = neomake#list#List(type)
    let list.make_info = a:make_info
    call s:save_list_ref(list)
    return list
endfunction

" a:type: "loclist" or "quickfix"
function! neomake#list#List(type) abort
    let list = deepcopy(s:base_list)
    let list.type = a:type
    " Display debug messages about changed entries.
    let list.debug = get(g:, 'neomake_debug_list',
                \ exists('g:neomake_test_messages')
                \ || !empty(get(g:, 'neomake_logfile'))
                \ || neomake#utils#get_verbosity() >= 3)
    return list
endfunction

" Internal base list implementation.
let s:base_list = {
            \ 'need_init': 1,
            \ 'entries': [],
            \ }
" Info about contained jobs.
let s:base_list.job_entries = {}
let s:base_list.maker_info_by_jobid = {}

function! s:base_list.sort_by_location() dict abort
    let entries = get(self, '_sorted_entries_by_location', copy(self.entries))
    let self._sorted_entries_by_location = sort(entries, 's:cmp_listitem_loc')
    return self._sorted_entries_by_location
endfunction

" a:1: optional jobinfo
function! s:base_list.add_entries(entries, ...) dict abort
    let idx = len(self.entries)
    if a:0 && !has_key(self.job_entries, a:1.id)
        let self.job_entries[a:1.id] = []
        let self.maker_info_by_jobid[a:1.id] = a:1.maker
    endif
    for entry in a:entries
        let idx += 1
        let e = extend(copy(entry), {'nmqfidx': idx})
        if a:0
            call add(self.job_entries[a:1.id], e)
            let e.job_id = a:1.id
        endif
        call add(self.entries, e)
    endfor
    if self.debug
        let indexes = map(copy(self.entries), 'v:val.nmqfidx')
        if len(neomake#compat#uniq(sort(copy(indexes)))) != len(indexes)
            call neomake#log#error(printf('Duplicate qf indexes in list entries: %s.',
                        \ string(indexes)))
        endif
    endif
    " Sort if it was sorted before.
    if has_key(self, '_sorted_entries_by_location')
        call extend(self._sorted_entries_by_location, a:entries)
        call self.sort_by_location()
    endif
endfunction

" Add entries for a job (non-efm method).
function! s:base_list.add_entries_for_job(entries, jobinfo) dict abort
    let tempfiles = get(self.make_info, 'tempfiles', [])
    if !empty(tempfiles)
        let mapped = 0
        for e in a:entries
            if has_key(e, 'filename') && get(e, 'bufnr', 0) == 0
                if index(tempfiles, e.filename) != -1
                    unlet e.filename
                    let e.bufnr = a:jobinfo.bufnr
                    let mapped += 1
                endif
            endif
        endfor
        if mapped
            call neomake#log#debug(printf('Mapped %d bufnrs from temporary files.', mapped), a:jobinfo)
        endif
    endif
    return self._appendlist(a:entries, a:jobinfo)
endfunction

function! neomake#list#get_title(prefix, bufnr, maker_info) abort
    let prefix = 'Neomake'
    if !empty(a:prefix)
        let prefix .= '['.a:prefix.']'
    endif
    if a:bufnr
        let bufname = bufname(a:bufnr)
        if empty(bufname)
            let bufname = 'buf:'.a:bufnr
        else
            let bufname = pathshorten(bufname)
        endif
        let maker_info = bufname
        if empty(a:maker_info)
            let maker_info = bufname
        else
            let maker_info = bufname.' ('.a:maker_info.')'
        endif
    else
        let maker_info = a:maker_info
    endif
    let title = prefix
    if !empty(maker_info)
        let title = prefix.': '.maker_info
    endif
    return title
endfunction

function! s:base_list._get_title() abort
    let maker_info = []
    for job in self.make_info.finished_jobs
        let info = job.maker.name
        let ok = 1
        if get(job, 'aborted', 0)
            let info .= '!'
            let ok = 0
        endif
        if has_key(self.job_entries, job.id)
            let c = len(self.job_entries[job.id])
            let info .= '('.c.')'
            let ok = 0
        endif
        if ok
            let info .= '✓'
        endif
        call add(maker_info, info)
    endfor
    for job in self.make_info.active_jobs
        let info = job.maker.name
        let info .= '...'
        if has_key(self.job_entries, job.id)
            let c = len(self.job_entries[job.id])
            let info .= '('.c.')'
        endif
        call add(maker_info, info)
    endfor
    for job in self.make_info.jobs_queue
        let info = job.maker.name
        let info .= '?'
        call add(maker_info, info)
    endfor
    for job in get(self.make_info, 'aborted_jobs', [])
        let info = job.maker.name
        let info .= '-'
        call add(maker_info, info)
    endfor
    let maker_info_str = join(maker_info, ', ')
    if self.type ==# 'loclist'
        let bufnr = self.make_info.options.bufnr
    else
        let bufnr = 0
    endif
    if get(self.make_info.options, 'automake')
        let prefix = 'auto'
    elseif self.make_info.options.file_mode
        let prefix = 'file'
    else
        let prefix = 'project'
    endif
    return neomake#list#get_title(prefix, bufnr, maker_info_str)
endfunction

function! s:base_list.finish_for_make() abort
    if self.need_init
        if self.type ==# 'loclist'
            call neomake#log#debug('Cleaning location list.', self.make_info)
        else
            call neomake#log#debug('Cleaning quickfix list.', self.make_info)
        endif
        call self._call_qf_fn('set', [], ' ')
    else
        " Set title, but only if list window is still valid.
        if s:has_support_for_qfid
            let valid = self._has_valid_qf()
        elseif self.type ==# 'loclist'
            let valid = self._get_loclist_win(1) != -1
        else
            let valid = 1
        endif
        if !valid
            call neomake#log#debug('list: finish: list is not valid anymore.', self.make_info)
            return
        endif
        call self.set_title()
    endif
endfunction

function! s:base_list._call_qf_fn(action, ...) abort
    let fns_args = call(self._get_fn_args, [a:action] + a:000, self)

    if a:action ==# 'get'
        let [fn, args] = fns_args[0]
        if s:has_support_for_qfid
            let args[-1].items = 1
            if self.debug
                call neomake#log#debug(printf('list: call: "get", returning items: %s.', string(fns_args)))
            endif
            return call(fn, args).items
        endif
        if self.debug
            call neomake#log#debug(printf('list: call: "get": %s.', string(fns_args)))
        endif
        return call(fn, args)
    endif

    for fns in fns_args
        let [fn, args] = fns

        if self.debug
            if a:action ==# 'set'
                let log_args = deepcopy(args)
                " Only display 5 items.
                if self.type ==# 'loclist'
                    let log_args[1] = neomake#utils#shorten_list_for_log(log_args[1], 5)
                else
                    let log_args[0] = neomake#utils#shorten_list_for_log(log_args[0], 5)
                endif
                " Massage options dict.
                if type(log_args[-1]) == type({})
                    let neomake_context = get(get(log_args[-1], 'context', {}), 'neomake', {})
                    if !empty(neomake_context)
                        for [k, v] in items(neomake_context)
                            if k ==# 'make_info'
                                " Fixes self-ref, and makes it much shorter.
                                let neomake_context[k] = 'make_id='.v.make_id
                            endif
                        endfor
                    endif
                    " Only display 5 items.
                    if has_key(log_args[-1], 'items')
                        let log_args[-1].items = neomake#utils#shorten_list_for_log(log_args[-1].items, 5)
                    endif
                endif
                call neomake#log#debug(printf('list: call: set: %s.', string(log_args)))
            else
                call neomake#log#debug(printf('list: call: "%s": %s.', a:action, string(args)))
            endif
        endif

        call call(fn, args, self)
    endfor

    " Get qfid.
    if self.need_init
        if a:action ==# 'set' && s:has_support_for_qfid
            if self.type ==# 'loclist'
                let loclist_win = self._get_loclist_win()
                let self.qfid = getloclist(loclist_win, {'id': 0}).id
            else
                let self.qfid = getqflist({'id': 0}).id
            endif
            if self.debug
                call neomake#log#debug(printf('list: got qfid (action=%s): %s.', a:action, self.qfid))
            endif
        endif
        let self.need_init = 0
    endif
endfunction

function! s:base_list.set_title() abort
    if s:can_set_qf_title
        call self._call_qf_fn('title', self._get_title())
    endif
endfunction

" Check if quickfix list is still valid, which might not be the case anymore
" if more than 10 new lists have been opened etc.
" Returns -1 without suffort for quickfix ids.
function! s:base_list._has_valid_qf() abort
    if !s:has_support_for_qfid
        return -1
    endif

    if self.type ==# 'loclist'
        let loclist_win = self._get_loclist_win(1)
        if loclist_win is -1
            return 0
        endif
        if !get(getloclist(loclist_win, {'id': self.qfid}), 'id')
            return 0
        endif
    else
        if !get(getqflist({'id': self.qfid}), 'id')
            return 0
        endif
    endif
    return 1
endfunction

" Get winnr/winid to be used with loclist functions.
" a:1: return -1 instead of throwing when no window could be found?
function! s:base_list._get_loclist_win(...) abort
    if !has_key(self, 'make_info')
        throw 'cannot handle type=loclist without make_info'
    endif
    let loclist_win = 0
    let make_id = self.make_info.make_id
    " NOTE: prefers using 0 for when winid is not supported with
    " setloclist() yet (vim74-xenial, patch-7.4.1895).
    if index(get(w:, 'neomake_make_ids', []), make_id) == -1
        if has_key(self.make_info.options, 'winid') && has('patch-7.4.1895')
            " Can only use it with getloclist after patch-7.4.1895.
            let loclist_win = self.make_info.options.winid
        else
            let [t, w] = neomake#core#get_tabwin_for_makeid(make_id)
            if [t, w] == [-1, -1]
                for w in range(1, winnr('$'))
                    if get(get(get(neomake#compat#getwinvar(w, '_neomake_info', {}), 'loclist', {}), 'make_info', {}), 'make_id') == make_id
                        let loclist_win = w
                        break
                    endif
                endfor
                if loclist_win == 0
                    if a:0 && a:1
                        return -1
                    endif
                    throw printf('Neomake: could not find location list for make_id %d.', make_id)
                endif
                return loclist_win
            endif
            if t != tabpagenr()
                if a:0 && a:1
                    return -1
                endif
                throw printf('Neomake: trying to use location list from another tab (current=%d != target=%d).', tabpagenr(), t)
            endif
            let loclist_win = w
        endif
    endif
    return loclist_win
endfunction

" Return a list of commands to be called.
" action: "get", "set", "init", "title"
" a:000: optional args (for set/init/title)
function! s:base_list._get_fn_args(action, ...) abort
    if self.type ==# 'loclist'
        if a:action ==# 'get'
            let fn = 'getloclist'
        else
            let fn = 'setloclist'
        endif
    else
        if a:action ==# 'get'
            let fn = 'getqflist'
        else
            let fn = 'setqflist'
        endif
    endif

    if self.type ==# 'loclist'
        let args = [self._get_loclist_win()]
    else
        let args = []
    endif

    let options = {}
    if !self.need_init
        let valid = self._has_valid_qf()
        if valid == 1
            let options.id = self.qfid
        elseif valid == 0
            if self.type ==# 'loclist'
                let loclist_win = args[0]
                throw printf('Neomake: qfid %d for location list (%d) has become invalid.', self.qfid, loclist_win)
            else
                throw printf('Neomake: qfid %d for quickfix list has become invalid.', self.qfid)
            endif
        endif
    endif

    if a:action ==# 'title'
        call extend(args, [[], 'a'])
        if exists('*vader#assert#true')
            call vader#assert#true(s:can_set_qf_title)
        endif
        let options.title = a:1
    else
        call extend(args, a:000)
        if a:action ==# 'set'
            if exists('*vader#assert#equal')
                call vader#assert#equal(len(a:000), 2)
            endif
            if s:can_set_qf_items
                let options.items = a:1
                let args[-2] = []
            endif
        endif
    endif
    if !empty(options)
        call add(args, options)
    endif

    let r = []
    if a:action ==# 'set'
        if self.need_init && get(self, 'reset_existing_qflist')
            if self.type ==# 'loclist'
                let args[2] = 'r'  " action
            else
                let args[1] = 'r'  " action
            endif
            if self.type ==# 'loclist'
                let msg = 'Reusing location list for entries.'
            else
                let msg = 'Reusing quickfix list for entries.'
            endif
            call neomake#log#debug(msg, self.make_info)
        endif

        " Experimental: set make_info into context.
        " This is used to access make info from the qf window itself.
        if self.need_init && s:can_set_qf_context
            let options.context = {'neomake': {'make_info': self.make_info}}
        endif

        " Handle setting title, which gets done initially and when maker
        " names are updated.  This has to be done in a separate call
        " without patch-8.0.0657.
        if s:can_set_qf_title
            let title = self._get_title()
            if s:can_set_qf_items
                if type(args[-1]) != type({})
                    call add(args, {'title': title, 'items': args[1]})
                else
                    let args[-1].title = title
                endif
            else
                " Update title after actual call.
                call add(r, [fn, args])

                if self.type ==# 'loclist'
                    let args = [args[0], [], 'a', {'title': title}]
                else
                    let args = [[], 'a', {'title': title}]
                endif
            endif
        endif
    endif
    call add(r, [fn, args])
    return r
endfunction

function! s:mark_entry_with_nmcfg(entry, maker_info) abort
    let maker_name = a:maker_info.name
    let config = {
                \ 'name': maker_name,
                \ 'short': get(a:maker_info, 'short_name', maker_name[:3]),
                \ }
    let marker_entry = copy(a:entry)
    let marker_entry.text .= printf(' nmcfg:%s', string(config))
    return marker_entry
endfunction

function! s:base_list._replace_qflist_entries(entries) abort
    let set_entries = a:entries

    " Handle nmcfg markers when setting all entries without jobinfo.
    if neomake#quickfix#is_enabled()
        let set_entries = copy(set_entries)
        let prev_job_id = 0

        " Handle re-setting all entries.  This is meant to be used later
        " for replacing the whole list.
        let i = 0
        for e in set_entries
            if e.job_id != prev_job_id
                let maker_info = self.maker_info_by_jobid[e.job_id]
                let set_entries[i] = s:mark_entry_with_nmcfg(e, maker_info)
                let prev_job_id = e.job_id
            endif
            let i += 1
        endfor
    endif

    call self._set_qflist_entries(set_entries, 'r')
endfunction

function! s:base_list._set_qflist_entries(entries, action) abort
    let action = a:action
    if self.need_init && !get(self, 'reset_existing_qflist')
        if self.type ==# 'loclist'
            let msg = 'Creating location list for entries.'
        else
            let msg = 'Creating quickfix list for entries.'
        endif
        call neomake#log#debug(msg, self.make_info)

        if s:needs_to_init_qf_for_lwindow
            " Clean list without autocommands (customqf etc) to avoid
            " flicker.  This is only to work around a Vim bug anyway.
            noautocmd call self._call_qf_fn('set', [], ' ')
        else
            let action = ' '
        endif
    endif
    call self._call_qf_fn('set', a:entries, action)
endfunction

function! s:base_list._get_qflist_entries() abort
    return self._call_qf_fn('get')
endfunction

" Append entries to location/quickfix list.
function! s:base_list._appendlist(entries, jobinfo) abort
    call neomake#log#debug(printf('Adding %d list entries.', len(a:entries)), self.make_info)

    let set_entries = a:entries
    let action = 'a'
    if !self.need_init
        let action = 'a'
        if s:needs_to_replace_qf_for_lwindow || neomake#quickfix#is_enabled()
            " Need to replace whole list with customqf to trigger FileType
            " autocmd (which is not done for action='a').
            " This should be enhanced to only format new entries instead
            " later, but needs support for changing non-current buffer lines.
            let action = 'r'
            if self.type ==# 'loclist'
                let set_entries = self._get_qflist_entries() + set_entries
            else
                let set_entries = getqflist() + set_entries
            endif
        endif
    endif

    " Add marker for custom quickfix to the first (new) entry.
    let needs_custom_qf_marker = neomake#quickfix#is_enabled()
    if needs_custom_qf_marker
        if action ==# 'a'
            let prev_idx = 0
        else
            let prev_idx = len(self.entries)
        endif
        let set_entries = copy(set_entries)
        let set_entries[prev_idx] = s:mark_entry_with_nmcfg(set_entries[prev_idx], a:jobinfo.maker)
    endif

    " NOTE: need to fetch (or pre-parse with new patch) to get updated bufnr etc.
    call self._set_qflist_entries(set_entries, action)
    let added = self._get_qflist_entries()[len(self.entries) :]

    if needs_custom_qf_marker
        " Remove marker that should only be in the quickfix list.
        let added[0].text = substitute(added[0].text, ' nmcfg:{.\{-}}$', '', '')
    endif

    if self.debug && added != a:entries
        let diff = neomake#list#_diff_new_entries(a:entries, added)
        if !empty(diff)
            for [k, v] in items(diff)
                " TODO: handle valid=1 being added?
                call neomake#log#debug(printf(
                  \ 'Entry %d differs after adding: %s.',
                  \ k+1,
                  \ string(v)),
                  \ a:jobinfo)
            endfor
        endif
    endif

    let parsed_entries = copy(a:entries)
    let idx = 0
    for e in added
        if parsed_entries[idx].bufnr != e.bufnr
            call neomake#log#debug(printf(
                        \ 'Updating entry bufnr: %s => %s.',
                        \ a:entries[idx].bufnr, e.bufnr))
            let parsed_entries[idx].bufnr = e.bufnr
        endif
        let idx += 1
    endfor

    call self.add_entries(parsed_entries, a:jobinfo)
    return parsed_entries
endfunction

function! neomake#list#_diff_new_entries(orig, new) abort
    if a:orig == a:new
        return {}
    endif
    let i = 0
    let r = {}
    for new in a:new
        let orig = copy(get(a:orig, i, {}))
        for [k, v] in items({'pattern': '', 'module': '', 'valid': 1})
            if has_key(new, k)
                let orig[k] = v
            endif
        endfor
        if new != orig
            " 'removed': {'length': 4, 'filename': 'from.rs',
            " 'maker_name': 'cargo'}}
            let new = copy(new)
            for k in ['length', 'maker_name']
                if has_key(orig, k)
                    let new[k] = orig[k]
                endif
            endfor
            let diff = neomake#utils#diff_dict(orig, new)
            if !empty(diff)
                let r[i] = diff
            endif
        endif
        let i += 1
    endfor
    return r
endfunction

" Add raw lines using errorformat.
" This either pre-parses them with newer versions, or uses
" :laddexpr/:caddexpr.
function! s:base_list.add_lines_with_efm(lines, jobinfo) dict abort
    let maker = a:jobinfo.maker
    let file_mode = self.type ==# 'loclist'

    if s:use_efm_parsing
        let efm = a:jobinfo.maker.errorformat
        let parsed_entries = get(getqflist({'lines': a:lines, 'efm': efm}), 'items', -1)
        if parsed_entries is -1
            call neomake#log#error(printf('Failed to get items via efm-parsing. Invalid errorformat? (%s)', efm), a:jobinfo)
            let parsed_entries = getqflist({'lines': a:lines, 'efm': &errorformat}).items
        endif
        if empty(parsed_entries)
            return []
        endif
    else
        if self.need_init
            if self.type ==# 'loclist'
                let msg = 'Creating location list.'
            else
                let msg = 'Creating quickfix list.'
            endif
            call neomake#log#debug(msg, self.make_info)
            call self._call_qf_fn('set', [], ' ')
        endif
        let olderrformat = &errorformat
        try
            let &errorformat = maker.errorformat
        catch
            call neomake#log#error(printf('Failed to set errorformat (%s): %s.', string(maker.errorformat), v:exception), a:jobinfo)
        endtry
        try
            if file_mode
                let cmd = 'laddexpr'
            else
                let cmd = 'caddexpr'
            endif
            let a:jobinfo._delayed_qf_autocmd = 'QuickfixCmdPost '.cmd
            let cmd = 'noautocmd '.cmd.' a:lines'
            if self.debug
                call neomake#log#debug(printf('list: exe: %s (with %d lines).', cmd, len(a:lines)), a:jobinfo)
            endif
            exe cmd
        finally
            let &errorformat = olderrformat
            call a:jobinfo.cd_back()
        endtry

        let new_list = self._get_qflist_entries()
        let parsed_entries = new_list[len(self.entries) :]
        if empty(parsed_entries)
            return []
        endif
    endif

    let l:Postprocess = neomake#utils#GetSetting('postprocess', maker, [], a:jobinfo.ft, a:jobinfo.bufnr)
    if type(Postprocess) != type([])
        let postprocessors = [Postprocess]
    else
        let postprocessors = Postprocess
    endif

    let default_type = 'unset'

    let entries = []
    let changed_entries = {}
    let removed_entries = []
    let different_bufnrs = {}
    let bufnr_from_temp = {}
    let bufnr_from_stdin = {}
    let tempfile_bufnrs = has_key(self.make_info, 'tempfiles') ? map(copy(self.make_info.tempfiles), 'bufnr(v:val)') : []
    let uses_stdin = get(a:jobinfo, 'uses_stdin', 0)

    let entry_idx = -1
    for entry in parsed_entries
        let entry_idx += 1
        let before = copy(entry)
        " Handle unlisted buffers via tempfiles and uses_stdin.
        if entry.bufnr && entry.bufnr != a:jobinfo.bufnr
                    \ && (!empty(tempfile_bufnrs) || uses_stdin)
            let map_bufnr = index(tempfile_bufnrs, entry.bufnr)
            if map_bufnr != -1
                let entry.bufnr = a:jobinfo.bufnr
                let map_bufnr = tempfile_bufnrs[map_bufnr]
                if !has_key(bufnr_from_temp, map_bufnr)
                    let bufnr_from_temp[map_bufnr] = []
                endif
                let bufnr_from_temp[map_bufnr] += [entry_idx+1]
            elseif uses_stdin
                if !buflisted(entry.bufnr) && bufexists(entry.bufnr)
                    if !has_key(bufnr_from_stdin, entry.bufnr)
                        let bufnr_from_stdin[entry.bufnr] = []
                    endif
                    let bufnr_from_stdin[entry.bufnr] += [entry_idx+1]
                    let entry.bufnr = a:jobinfo.bufnr
                endif
            endif
        endif
        if self.debug && entry.bufnr && entry.bufnr != a:jobinfo.bufnr
            if !has_key(different_bufnrs, entry.bufnr)
                let different_bufnrs[entry.bufnr] = 1
            else
                let different_bufnrs[entry.bufnr] += 1
            endif
        endif
        if !empty(postprocessors)
            let g:neomake_postprocess_context = {'jobinfo': a:jobinfo}
            try
                for l:F in postprocessors
                    if type(F) == type({})
                        call call(F.fn, [entry], F)
                    else
                        call call(F, [entry], maker)
                    endif
                    unlet! F  " vim73
                endfor
            finally
                unlet! g:neomake_postprocess_context  " Might be unset already with sleep in postprocess.
            endtry
        endif
        if entry != before
            let changed_entries[entry_idx] = entry
            if self.debug
                " Ignore bufnr changes for tempfiles/stdin (logged together
                " later).
                let diff = neomake#utils#diff_dict(before, entry)
                let changed_bufnr = get(get(diff, 'changed', {}), 'bufnr', [])
                if !empty(changed_bufnr) && (
                            \ has_key(bufnr_from_temp, changed_bufnr[0])
                            \ || has_key(bufnr_from_stdin, changed_bufnr[0]))
                    unlet diff.changed.bufnr
                    if empty(diff.changed)
                        unlet diff.changed
                    endif
                endif
                if !empty(diff)
                    call neomake#log#debug(printf(
                      \ 'Modified list entry %d (postprocess): %s.',
                      \ entry_idx + 1,
                      \ substitute(string(diff), '\n', '\\n', 'g')),
                      \ a:jobinfo)
                endif
            endif
        endif

        if entry.valid <= 0
            if entry.valid < 0 || maker.remove_invalid_entries
                call insert(removed_entries, entry_idx)
                let entry_copy = copy(entry)
                call neomake#log#debug(printf(
                            \ 'Removing invalid entry: %s (%s).',
                            \ remove(entry_copy, 'text'),
                            \ string(entry_copy)), a:jobinfo)
                continue
            endif
        endif

        if empty(entry.type) && entry.valid
            if default_type ==# 'unset'
                let default_type = neomake#utils#GetSetting('default_entry_type', maker, 'W', a:jobinfo.ft, a:jobinfo.bufnr)
            endif
            if !empty(default_type)
                let entry.type = default_type
                let changed_entries[entry_idx] = entry
            endif
        endif
        call add(entries, entry)
    endfor

    if !s:use_efm_parsing
        let new_index = len(self.entries)
        " Add marker for custom quickfix to the first (new) entry.
        if neomake#quickfix#is_enabled()
            let changed_entries[0] = s:mark_entry_with_nmcfg(entries[0], maker)
        endif

        if !empty(changed_entries) || !empty(removed_entries)
            " Need to update/replace current list.
            let list = self._get_qflist_entries()
            if !empty(changed_entries)
                for k in keys(changed_entries)
                    let list[new_index + k] = changed_entries[k]
                endfor
            endif
            if !empty(removed_entries)
                for k in removed_entries
                    call remove(list, new_index + k)
                endfor
            endif
            call self._set_qflist_entries(list, 'r')
        endif
    endif

    if !empty(bufnr_from_temp) || !empty(bufnr_from_stdin)
        if !has_key(self.make_info, '_wipe_unlisted_buffers')
            let self.make_info._wipe_unlisted_buffers = []
        endif
        let self.make_info._wipe_unlisted_buffers += keys(bufnr_from_stdin) + keys(bufnr_from_stdin)
        if !empty(bufnr_from_temp)
            for [tempbuf, entries_idx] in items(bufnr_from_temp)
                let log_entries_idx = join(neomake#utils#shorten_list_for_log(entries_idx, 50), ', ')
                call neomake#log#debug(printf(
                            \ 'Used bufnr from temporary buffer %d (%s) for %d entries: %s.',
                            \ tempbuf,
                            \ bufname(+tempbuf),
                            \ len(entries_idx),
                            \ log_entries_idx), a:jobinfo)
            endfor
        endif
        if !empty(bufnr_from_stdin)
            for [tempbuf, entries_idx] in items(bufnr_from_stdin)
                let log_entries_idx = join(neomake#utils#shorten_list_for_log(entries_idx, 50), ', ')
                call neomake#log#debug(printf(
                            \ 'Used bufnr from stdin buffer %d (%s) for %d entries: %s.',
                            \ tempbuf,
                            \ bufname(+tempbuf),
                            \ len(entries_idx),
                            \ log_entries_idx), a:jobinfo)
            endfor
        endif
    endif
    if !empty(different_bufnrs)
        call neomake#log#debug(printf('WARN: seen entries with bufnr different from jobinfo.bufnr (%d): %s, current bufnr: %d.', a:jobinfo.bufnr, string(different_bufnrs), bufnr('%')))
    endif

    if empty(entries)
        return []
    endif

    if s:use_efm_parsing
        call self._appendlist(entries, a:jobinfo)
    else
        call self.add_entries(entries, a:jobinfo)
    endif
    return entries
endfunction

" Get location list from current window, or via buffer.
function! s:get_loclist() abort
    let win_info = neomake#compat#getwinvar(winnr(), '_neomake_info', {})
    if has_key(win_info, 'loclist')
        return win_info['loclist']
    endif
    let buf_info = neomake#compat#getbufvar(bufnr('%'), '_neomake_info', {})
    if has_key(buf_info, 'loclist')
        return buf_info['loclist']
    endif
    return {}
endfunction

" Get the current location or quickfix list.
function! neomake#list#get() abort
    let loclist = s:get_loclist()
    if !empty(loclist)
        return loclist
    endif
    let info = get(g:, '_neomake_info', {})
    if has_key(info, 'qflist')
        return info['qflist']
    endif
    return {}
endfunction

function! neomake#list#get_loclist() abort
    let loclist = s:get_loclist()
    if empty(loclist)
        " Create a new list, not bound to a job.
        call neomake#log#debug('Creating new List object.')
        let loclist = neomake#list#List('loclist')
        call loclist.add_entries(getloclist(0))
        call s:save_list_ref(loclist)
    endif
    return loclist
endfunction

" TODO: save project-maker quickfix list.
function! neomake#list#get_qflist() abort
    let info = get(g:, '_neomake_info', {})
    if !has_key(info, 'qflist')
        " Create a new list, not bound to a job.
        call neomake#log#debug('Creating new List object.')
        let list = neomake#list#List('quickfix')
        call list.add_entries(getqflist())
        let info['qflist'] = list
        let g:_neomake_info = info
    endif
    return info['qflist']
endfunction

function! s:get_list(file_mode) abort
    if a:file_mode
        let list = neomake#list#get_loclist()
        let g:unimpaired_prevnext = ['NeomakePrevLoclist', 'NeomakeNextLoclist']
    else
        let list = neomake#list#get_qflist()
        let g:unimpaired_prevnext = ['NeomakePrevQuickfix', 'NeomakeNextQuickfix']
    endif
    return list
endfunction

function! neomake#list#next(c, ...) abort
    let file_mode = a:0 ? a:1 : 1
    let list = s:get_list(file_mode)
    call s:goto_nearest(list, a:c == 0 ? 1 : a:c)
endfunction

function! neomake#list#prev(c, ...) abort
    let file_mode = a:0 ? a:1 : 1
    let list = s:get_list(file_mode)
    call s:goto_nearest(list, a:c == 0 ? -1 : -a:c)
endfunction

" TODO: global / already used somewhere else? / config
let g:neomake#list#type_prio = {
            \ 'E': 0,
            \ 'W': 1,
            \ 'I': 2,
            \ }

" TODO: allow to customize via own callback(s)?
function! s:cmp_listitem_loc(a, b) abort
    let buf_diff = a:a.bufnr - a:b.bufnr
    if buf_diff
        return buf_diff
    endif

    if exists('*vader#assert#not_equal')
        call vader#assert#not_equal(a:a.bufnr, -1)
        call vader#assert#not_equal(a:b.bufnr, -1)
    endif

    let lnum_diff = a:a.lnum - a:b.lnum
    if lnum_diff
        return lnum_diff
    endif

    let col_diff = a:a.col - a:b.col
    if col_diff
        return col_diff
    endif

    let prio = g:neomake#list#type_prio
    return get(prio, a:a.type, 99) - get(prio, a:b.type, 99)
endfunction

function! s:goto_nearest(list, offset) abort
    let [lnum, col] = getpos('.')[1:2]
    if a:offset == 0
        throw 'a:offset must not be 0'
    endif

    if !has_key(a:list, '_sorted_entries_by_location')
        call a:list.sort_by_location()
    endif
    let entries = a:list._sorted_entries_by_location
    if a:offset < 0
        call reverse(entries)
    endif

    let c = a:offset
    let step = a:offset > 0 ? 1 : -1
    let found = 0
    for item in entries
        if (a:offset > 0 && (item.lnum > lnum || (item.lnum == lnum && item.col > col)))
                    \ || (a:offset < 0 && (item.lnum < lnum || (item.lnum == lnum && item.col < col)))
            let c -= step
            let found = item.nmqfidx
            if c == 0
                break
            endif
        endif
    endfor

    if found
        if a:list.type ==# 'loclist'
            if exists('*vader#assert#equal')
                " @vimlint(EVL102, 1, l:ll_item)
                let ll_item = getloclist(0)[found-1]
                call vader#assert#equal([ll_item.bufnr, ll_item.lnum], [item.bufnr, item.lnum])
            endif
            execute 'll '.found
        else
            if exists('*vader#assert#equal')
                " @vimlint(EVL102, 1, l:cc_item)
                let cc_item = getqflist()[found-1]
                call vader#assert#equal([cc_item.bufnr, cc_item.lnum], [item.bufnr, item.lnum])
            endif
            execute 'cc '.found
        endif
    elseif c > 0
        call neomake#log#error('No more next items.')
    elseif c < 0
        call neomake#log#error('No more previous items.')
    endif
endfunction

" vim: ts=4 sw=4 et
