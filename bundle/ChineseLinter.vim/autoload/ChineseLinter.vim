scriptencoding utf-8

""
" 指定需要忽略的错误、警告的编号，默认没有禁止。
" >
"   let g:chinese_linter_disabled_nr = ['E001']
" <
"
" 目前支持的检查包括：
" >
"   E001  |  中文字符后存在英文标点
"   E002  |  中英文之间没有空格
"   E003  |  中文和数字之间没有空格
"   E004  |  中文标点两侧存在空格
"   E005  |  行尾含有空格
"   E006  |  数字和单位之间存在空格
"   E007  |  数字使用了全角字符
"   E008  |  汉字之间存在空格
"   E009  |  中文标点重复
"   E010  |  英文标点符号两侧的空格数量不对
"   E011  |  中英文之间空格数量多于 1 个
"   E012  |  中文和数字之间空格数量多于 1 个
"   E013  |  英文和数字之间没有空格
"   E014  |  英文和数字之间空格数量多于 1 个
"   E015  |  英文标点重复
"   E016  |  连续的空行数量大于 2 行
"   E017  |  数字之间存在空格
"   E018  |  行首含有空格
"   E019  |  行首、行尾存在不应出现的标点
"   E020  |  省略号“…”的数量不是 2 个
"   E021  |  破折号“—”的数量不是 2 个
" <

let g:chinese_linter_disabled_nr = get(g:,'chinese_linter_disabled_nr', [])

""
" This setting will open the |location-list| or |quickfix| list (depending on
" whether it is operating on a file) when adding entries. A value of 2 will
" preserve the cursor position when the |location-list| or |quickfix| window is
" opened. Defaults to 2.
let g:chinese_linter_open_list = 2

" 中文标点符号（更全）
" let s:CHINESE_PUNCTUATION = '[\u2014\u2015\u2018\u2019\u201c\u201d\u2026\u3001\u3002\u3008\u3009\u300a\u300b\u300c\u300d\u300e\u300f\u3010\u3011\u3014\u3015\ufe43\ufe44\ufe4f\uff01\uff08\uff09\uff0c\uff1a\uff1b\uff1f\uff5e\uffe5]'
" [\u2010-\u201f] == [‐‑‒–—―‖‗‘’‚‛“”„‟]
" [\u2026] == […]
" [\uff01-\uff0f] == [！＂＃＄％＆＇（）＊＋，－．／]
" [\uff1a-\uff1f] == [：；＜＝＞？]
" [\uff3b-\uff40] == [［＼］＾＿｀]
" [\uff5b-\uff5e] == [｛｜｝～]
let s:CHINESE_PUNCTUATION = '[\u2010-\u201f\u2026\uff01-\uff0f\uff1a-\uff1f\uff3b-\uff40\uff5b-\uff5e]'

" 英文标点
let s:punctuation_en = '[､,:;?!-]'

" 中文标点符号
let s:punctuation_cn = '[、，：；。？！‘’“”（）《》『』＂＇／＜＞＝［］｛｝【】]'

" 中文汉字
let s:chars_cn = '[\u4e00-\u9fff]'

" 数字
let s:numbers = '[0-9]'

" 全角数字
let s:numbers_cn = '[\uff10-\uff19]'

" 英文字母
let s:chars_en = '[a-zA-Z]'

" 单位
" TODO: 需要添加更多的单位，单位见以下链接
" https://unicode-table.com/cn/blocks/cjk-compatibility/
" https://unicode-table.com/cn/#2031
" https://unicode-table.com/cn/#2100
let s:symbol = '[%‰‱\u3371-\u33df\u2100-\u2109]'

" 空白符号
let s:blank = '\(\s\|[\u3000]\)'

let s:ERRORS = {
            \ 'E001' : [
            \               ['中文字符后存在英文标点'              , s:chars_cn . '[､,:;?!]'],
            \          ],
            \ 'E002' : [
            \               ['中文与英文之间没有空格'              , s:chars_cn . s:chars_en],
            \               ['英文与中文之间没有空格'              , s:chars_en . s:chars_cn],
            \          ],
            \ 'E003' : [
            \               ['中文与数字之间没有空格'              , s:chars_cn . s:numbers],
            \               ['数字与中文之间没有空格'              , s:numbers . s:chars_cn],
            \          ],
            \ 'E004' : [
            \               ['中文标点前存在空格'                  , s:blank . '\+\ze' . s:CHINESE_PUNCTUATION],
            \               ['中文标点后存在空格'                  , s:CHINESE_PUNCTUATION . '\zs' . s:blank . '\+'],
            \          ],
            \ 'E005' : [
            \               ['行尾有空格'                          , s:blank . '\+$'],
            \          ],
            \ 'E006' : [
            \               ['数字和单位之间有空格'                , s:numbers . '\zs' . s:blank . '\+\ze' . s:symbol],
            \          ],
            \ 'E007' : [
            \               ['数字使用了全角数字'                  , s:numbers_cn . '\+'],
            \          ],
            \ 'E008' : [
            \               ['汉字之间存在空格'                    , s:chars_cn . '\zs' . s:blank . '\+\ze' . s:chars_cn],
            \          ],
            \ 'E009' : [
            \               ['中文标点符号重复'                    , '\(' . s:punctuation_cn . '\)\1\+'],
            \               ['连续多个中文标点符号'                , '[、，：；。！？]\{2,}'],
            \          ],
            \ 'E010' : [
            \               ['英文标点前侧存在空格'                , s:blank . '\+\ze' . '[､,:;?!]'],
            \               ['英文标点符号后侧的空格数量多于 1 个' , '[､,:;?!]' . s:blank . '\{2,}'],
            \               ['英文标点与英文之间没有空格'          , '[､,:;?!]' . s:chars_en],
            \               ['英文标点与中文之间没有空格'          , '[､,:;?!]' . s:chars_cn],
            \               ['英文标点与数字之间没有空格'          , '[､,:;?!]' . s:numbers],
            \          ],
            \ 'E011' : [
            \               ['中文与英文之间空格数量多于 1 个'     , '\%#=2' . s:chars_cn . '\zs' . s:blank . '\{2,}\ze' . s:chars_en],
            \               ['英文与中文之间空格数量多于 1 个'     , '\%#=2' . s:chars_en . '\zs' . s:blank . '\{2,}\ze' . s:chars_cn],
            \          ],
            \ 'E012' : [
            \               ['中文与数字之间空格数量多于 1 个'     , '\%#=2' . s:chars_cn . '\zs' . s:blank . '\{2,}\ze' . s:numbers],
            \               ['数字与中文之间空格数量多于 1 个'     , '\%#=2' . s:numbers . '\zs' . s:blank . '\{2,}\ze' . s:chars_cn],
            \          ],
            \ 'E013' : [
            \               ['英文与数字之间没有空格'              , s:chars_en . s:numbers],
            \               ['数字与英文之间没有空格'              , s:numbers . s:chars_en],
            \          ],
            \ 'E014' : [
            \               ['英文与数字之间空格数量多于 1 个'     , s:chars_en . '\zs' . s:blank . '\{2,}\ze' . s:numbers],
            \               ['数字与英文之间空格数量多于 1 个'     , s:numbers . '\zs' . s:blank . '\{2,}\ze' . s:chars_en],
            \          ],
            \ 'E015' : [
            \               ['英文标点符号重复'                    , '\(' . s:punctuation_en . s:blank . '*\)\1\+'],
            \               ['连续多个英文标点符号'                , '\(' . '[,:;?!-]' . s:blank . '*\)\{2,}'],
            \          ],
            \ 'E016' : [
            \               ['连续的空行数量大于 2 行'             , '^\(' . s:blank . '*\n\)\{3,}'],
            \          ],
            \ 'E017' : [
            \               ['数字之间存在空格'                    , s:numbers . '\zs' . s:blank . '\+\ze' . s:numbers],
            \          ],
            \ 'E018' : [
            \               ['行首有空格'                          , '^' . s:blank . '\+'],
            \          ],
            \ 'E019' : [
            \               ['存在不应出现在行首的标点'            , '^' . '[､,:;｡?!\/)]】}’”、，：；。？！／》』）］】｝]'],
            \               ['存在不应出现在行尾的标点'            , '[､,\/([【{‘“、，／《『（［【｛]' . '$'],
            \          ],
            \ 'E020' : [
            \               ['省略号“…”的数量只有 1 个'            , '\(^\|[^…]\)' . '\zs' . '…' . '\ze' . '\([^…]\|$\)'],
            \               ['省略号“…”的数量大于 2 个'            , '…\{3,}'],
            \          ],
            \ 'E021' : [
            \               ['破折号“—”的数量只有 1 个'            , '\(^\|[^—]\)' . '\zs' . '—' . '\ze' . '\([^—]\|$\)'],
            \               ['破折号“—”的数量大于 2 个'            , '—\{3,}'],
            \          ],
            \ }
ab
function! s:getNotIgnoreErrors()
    let s:notIgnoreErrorList = []
    for l:errors_nr in keys(s:ERRORS)
        if index(g:chinese_linter_disabled_nr, l:errors_nr) == -1
            call add(s:notIgnoreErrorList, l:errors_nr)
        endif
    endfor
endfunction

function! ChineseLinter#check(...) abort
    call s:getNotIgnoreErrors()
    let s:file = getline(1, '$')
    let s:bufnr = bufnr('%')
    let s:linenr = 0
    let s:colnr = 0
    let s:qf = []
    for l:line in s:file
        let s:linenr += 1
        call s:parser(l:line)
    endfor
    if !empty(s:qf)
        call s:update_qf(s:qf)
        if g:chinese_linter_open_list == 1
            rightbelow copen
        elseif g:chinese_linter_open_list ==2
            rightbelow copen
            wincmd p
        endif
    else
        call setqflist([])
        cclose
        doautocmd WinEnter
    endif
    unlet s:linenr
    unlet s:colnr
endfunction

function! s:parser(line) abort
    for l:errors_nr in s:notIgnoreErrorList
        call s:find_error(l:errors_nr, a:line)
    endfor
endfunction

function! s:find_error(errors_nr, line) abort
    let l:errorList = s:ERRORS[a:errors_nr]
    for l:error in l:errorList
        let s:colnr = matchend(a:line, l:error[1])
        if s:colnr != -1
            call s:add_to_qf(a:errors_nr, l:error[0])
        endif
    endfor
endfunction

function! s:add_to_qf(errors_nr, errors_text) abort
    let l:error_item = {
                \ 'bufnr': s:bufnr,
                \ 'lnum' : s:linenr,
                \ 'col'  : s:colnr,
                \ 'vcol' : 0,
                \ 'text' : a:errors_nr . ' ' . a:errors_text,
                \ 'nr'   : a:errors_nr,
                \ 'type' : 'E',
                \ }
    call add(s:qf, l:error_item)
endfunction

" TODO 加入语法分析

function! s:update_qf(listOfDicts) abort
    call setqflist(a:listOfDicts)
endfunction
