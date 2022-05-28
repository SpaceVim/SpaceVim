" =============================================================================
" Filename: autoload/calendar/message/ja.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/05/09 08:06:55.
" =============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! calendar#message#ja#get() abort
  return s:message
endfunction

let s:message = {}

let s:message.day_name = [ '日', '月', '火', '水', '木', '金', '土' ]

let s:message.day_name_long = [ '日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日' ]

let s:message.month_name = [ '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月' ]

let s:message.month_name_long = s:message.month_name

let s:message.today = '今日'

let s:message.multiple_argument = '複数の引数候補があります'

let s:message.mkdir_fail = 'キャッシュ用のディレクトリーの作成に失敗しました'

let s:message.cache_file_unwritable = 'キャッシュファイルの書き込みが許されていません'

let s:message.cache_write_fail = 'キャッシュファイルの書き込みに失敗しました'

let s:message.access_url_input_code = '%s にアクセスして、コードを入力して下さい'

let s:message.google_access_token_fail = 'Googleへの認証に失敗しました'

let s:message.delete_event = 'イベントを削除しますか？ (この操作は元に戻せません) y/N: '

let s:message.delete_task = 'タスクを削除しますか？ (この操作は元に戻せません) y/N: '

let s:message.clear_completed_task = '完了したタスクを全て削除しますか？ (この操作は元に戻せません) y/N: '

let s:message.curl_wget_not_found = 'curl または wget が必要です'

let s:message.mark_not_set = 'マークが設定されていません: '

let s:message.start_date_time = '開始日時: '

let s:message.end_date_time = '終了日時: '

let s:message.input_calendar_index = 'カレンダーの番号を指定して下さい: '

let s:message.input_calendar_name = '新しいカレンダーの名前を入力して下さい: '

let s:message.hit_any_key = '[キーを押して下さい]'

let s:message.input_code = 'コード: '

let s:message.input_task = 'タスク: '

let s:message.input_event = 'イベント: '

let s:message.help = {
      \ 'title': calendar#util#name() . ' ヘルプ',
      \ 'message': join([" Vimで動くカレンダーアプリケーションです。",
        \ "このカレンダーは、様々なビューを備えています。< と > を押してみてください。",
        \ "一年のビュー、一か月ビュー、週間ビュー、数日ビュー、一日ビュー、そして時計ビューがあります。\n",
        \ " また、Google Calendarからカレンダーをダウンロードし、表示することも出来ます。",
        \ "次の設定をvimrcに書いて下さい。\n",
        \ "    let g:calendar_google_calendar = 1\n",
        \ "カレンダーを起動すると、認証が始まります。",
        \ "選択した日のイベント一覧を表示したり、編集したりするには、Eを押して下さい。",
        \ "また、次の設定を書くとGoogle Taskからあなたのタスクをダウンロードすることも出来ます。\n",
        \ "    let g:calendar_google_task = 1\n",
        \ "タスクを表示するには、Tを押して下さい。",
        \ "その画面で、タスクを編集したり新しく作成したりすることも出来ます。\n",
        \ " 更に詳細な事は、アプリケーションのヘルプファイルを参照して下さい。\n",
        \ "    :help calendar\n",
        \ ], ''),
      \ 'credit': join(["  アプリケーション名: " . calendar#util#name(),
        \ "  バージョン: " . calendar#util#version(),
        \ "  作者: " . calendar#util#author(),
        \ "  ライセンス: " . calendar#util#license(),
        \ "  リポジトリ: " . calendar#util#repository(),
        \ "  バグ報告: " . calendar#util#issue(),
        \ ], "\n"),
      \ 'Credit': 'クレジット',
      \ 'Mapping': 'マッピング',
      \ 'View': 'ビュー',
      \ 'Utility': 'ユーティリティー',
      \ 'view_left': '左のビュー',
      \ 'view_right': '右のビュー',
      \ 'today': '今日',
      \ 'Event window / Task window': 'イベントウィンドウ / タスクウィンドウ',
      \ 'task': 'タスクウィンドウを表示/非表示',
      \ 'event': 'イベントウィンドウを表示/非表示',
      \ 'delete_line': 'イベントを削除 / 選択中のタスクを完了状態にする',
      \ 'clear': '完了したタスクを全て削除する',
      \ 'undo_line': '完了状態にしたタスクを未完にする',
      \ 'help': 'このヘルプを表示/非表示',
      \ 'exit': 'カレンダーを終了する',
      \ }

let s:message.task = {
      \ 'title': 'タスク',
      \ }

let &cpo = s:save_cpo
unlet s:save_cpo
