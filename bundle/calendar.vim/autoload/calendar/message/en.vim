" =============================================================================
" Filename: autoload/calendar/message/en.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/05/09 08:07:17.
" =============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! calendar#message#en#get() abort
  return s:message
endfunction

let s:message = {}

let s:message.day_name = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ]

let s:message.day_name_long = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ]

let s:message.month_name = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]

let s:message.month_name_long = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ]

let s:message.today = 'today'

let s:message.multiple_argument = 'There are multiple possible arguments'

let s:message.mkdir_fail = 'Could not create the directory for cache files'

let s:message.cache_file_unwritable = 'The cache file is not writable'

let s:message.cache_write_fail = 'Could not write the cache file'

let s:message.access_url_input_code = 'Access %s and paste the code'

let s:message.google_access_token_fail = 'Fail in authorization to Google'

let s:message.delete_event = 'Delete the event? (cannot be undone) y/N: '

let s:message.delete_task = 'Delete the task? (cannot be undone) y/N: '

let s:message.clear_completed_task = 'Clear all the completed tasks? (cannot be undone) y/N: '

let s:message.curl_wget_not_found = 'curl and wget not found'

let s:message.mark_not_set = 'Mark not set: '

let s:message.start_date_time = 'Starting date and time: '

let s:message.end_date_time = 'Ending date and time: '

let s:message.input_calendar_index = 'Input the index of the calendar: '

let s:message.input_calendar_name = 'Input the name of a new calendar: '

let s:message.hit_any_key = '[Hit any key]'

let s:message.input_code = 'CODE: '

let s:message.input_task = 'TASK: '

let s:message.input_event = 'EVENT: '

let s:message.help = {
      \ 'title': calendar#util#name() . ' help',
      \ 'message': join([" This is a calendar application for Vim. ",
        \ "This calendar provides many views. Press the < and > keys. ",
        \ "There are year view, month view, week view, days view, day view and clock view.\n",
        \ " This calendar supports to download calendars from Google Calendar and show the events. ",
        \ "Add the following configuration to your vimrc file.\n",
        \ "    let g:calendar_google_calendar = 1\n",
        \ "On starting the calendar, it will start authorization. ",
        \ "Press the E key to view and edit the events of the selected day. ",
        \ "Moreover, you can also download tasks from Google Task with the following configuration.\n",
        \ "    let g:calendar_google_task = 1\n",
        \ "In order to see tasks, press the T key. You can edit and create tasks in the task window.\n",
        \ " For more information, open the help file with the following command.\n",
        \ "    :help calendar\n",
        \ ], ''),
      \ 'credit': join(["  Name: " . calendar#util#name(),
        \ "  Version: " . calendar#util#version(),
        \ "  Author: " . calendar#util#author(),
        \ "  License: " . calendar#util#license(),
        \ "  Repository: " . calendar#util#repository(),
        \ "  Bug tracker: " . calendar#util#issue(),
        \ ], "\n"),
      \ 'view_left': 'Left view',
      \ 'view_right': 'Right view',
      \ 'today': 'Go to today',
      \ 'task': 'Toggle task window',
      \ 'event': 'Toggle event window',
      \ 'delete_line': 'Delete the event / Complete the task',
      \ 'clear': 'Clear completed tasks',
      \ 'undo_line': 'Uncomplete the task',
      \ 'help': 'Toggle this help',
      \ 'exit': 'Exit',
      \ }

let s:message.task = {
      \ 'title': 'Task list',
      \ }

let &cpo = s:save_cpo
unlet s:save_cpo
