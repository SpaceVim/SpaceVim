" =============================================================================
" Filename: autoload/calendar/task.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/07/21 00:14:40.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Task controller.
" This object handles both local task and Google Task.
function! calendar#task#new() abort
  let self = copy(s:self)
  if calendar#setting#get('google_task')
    let self.task_source_name = 'google'
  else
    let self.task_source_name = 'local'
  endif
  let self.task_source = calendar#task#{self.task_source_name}#new()
  return self
endfunction

let s:self = {}

let s:self._updated = 0

function! s:self.updated() dict abort
  return [self._updated]
endfunction

function! s:self.clear_cache() dict abort
  let self._updated = 1
endfunction

function! s:self.get_taskList() dict abort
  return self.task_source.get_taskList()
endfunction

function! s:self.get_task() dict abort
  if self._updated || !has_key(self, 'task')
    let self.task = self.task_source.get_task()
  endif
  let self._updated = 0
  return self.task
endfunction

function! s:self.insert(listid, previous, parent, title, ...) dict abort
  let self._updated = 1
  call self.task_source.insert(a:listid, a:previous, a:parent, a:title, a:0 ? a:1 : {})
endfunction

function! s:self.move(listid, taskid, previous, parent) dict abort
  let self._updated = 1
  call self.task_source.move(a:listid, a:taskid, a:previous, a:parent)
endfunction

function! s:self.update(listid, taskid, title, ...) dict abort
  let self._updated = 1
  call self.task_source.update(a:listid, a:taskid, a:title, a:0 ? a:1 : {})
endfunction

function! s:self.complete(listid, taskid) dict abort
  let self._updated = 1
  call self.task_source.complete(a:listid, a:taskid)
endfunction

function! s:self.uncomplete(listid, taskid) dict abort
  let self._updated = 1
  call self.task_source.uncomplete(a:listid, a:taskid)
endfunction

function! s:self.clear_completed(listid) dict abort
  let self._updated = 1
  call self.task_source.clear_completed(a:listid)
endfunction

function! s:self.delete(listid, taskid) dict abort
  let self._updated = 1
  call self.task_source.delete(a:listid, a:taskid)
endfunction

function! calendar#task#width() abort
  let frame = calendar#setting#frame()
  return min([
        \ max([calendar#setting#get("task_width"), 10])
        \ + strdisplaywidth(frame.left) + strdisplaywidth(frame.right) + 2,
        \ calendar#util#winwidth()])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
