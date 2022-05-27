if exists("g:loaded_MarkdownTocPlugin")
  finish
elseif v:version < 704
  finish
endif

let g:loaded_MarkdownTocPlugin = 1

if !exists("g:vmt_auto_update_on_save")
  let g:vmt_auto_update_on_save = 1
endif

if !exists("g:vmt_dont_insert_fence")
  let g:vmt_dont_insert_fence = 0
endif

if !exists("g:vmt_fence_text")
  let g:vmt_fence_text = 'vim-markdown-toc'
endif

if !exists("g:vmt_fence_closing_text")
  let g:vmt_fence_closing_text = g:vmt_fence_text
endif

if !exists("g:vmt_fence_hidden_markdown_style")
  let g:vmt_fence_hidden_markdown_style = ''
endif

if !exists("g:vmt_list_item_char")
  let g:vmt_list_item_char = '*'
endif

if !exists("g:vmt_list_indent_text")
  let g:vmt_list_indent_text = ''
endif

if !exists("g:vmt_cycle_list_item_markers")
  let g:vmt_cycle_list_item_markers = 0
endif

if !exists("g:vmt_include_headings_before")
  let g:vmt_include_headings_before = 0
endif

if !exists("g:vmt_link")
  let g:vmt_link = 1
endif

if !exists("g:vmt_min_level")
  let g:vmt_min_level = 1
endif

if !exists("g:vmt_max_level")
  let g:vmt_max_level = 6
endif

let g:GFMHeadingIds = {}

let s:supportMarkdownStyles = ['GFM', 'Redcarpet', 'GitLab', 'Marked']

let s:GFM_STYLE_INDEX = 0
let s:REDCARPET_STYLE_INDEX = 1
let s:GITLAB_STYLE_INDEX = 2
let s:MARKED_STYLE_INDEX = 3

function! s:HeadingLineRegex()
  return '\v(^.+$\n^\=+$|^.+$\n^\-+$|^#{1,6})'
endfunction

function! s:GetSections(beginRegex, endRegex)
  let l:winview = winsaveview()
  let l:sections = {}

  keepjumps normal! gg0
  let l:flags = "Wc"
  let l:beginLine = 0
  let l:regex = a:beginRegex
  while search(l:regex, l:flags)
    let l:lineNum = line(".")
    if l:beginLine == 0
      let l:beginLine = l:lineNum
      let l:regex = a:endRegex
    else
      let l:sections[l:beginLine] = l:lineNum
      let l:beginLine = 0
      let l:regex = a:beginRegex
    endif
    let l:flags = "W"
  endwhile

  call winrestview(l:winview)

  return l:sections
endfunction

function! s:GetCodeSections()
  let l:codeSections = {}

  call extend(l:codeSections, <SID>GetSections("^```", "^```"))
  call extend(l:codeSections, <SID>GetSections("^\\~\\~\\~", "^\\~\\~\\~"))
  call extend(l:codeSections, <SID>GetSections("^{% highlight", "^{% endhighlight"))

  return l:codeSections
endfunction

function! s:IsLineInCodeSections(codeSections, lineNum)
  for beginLine in keys(a:codeSections)
    if a:lineNum >= str2nr(beginLine)
      if a:lineNum <= a:codeSections[beginLine]
        return 1
      endif
    endif
  endfor

  return 0
endfunction

function! s:GetHeadingLines()
  let l:winview = winsaveview()
  let l:headingLines = []
  let l:codeSections = <SID>GetCodeSections()

  let l:flags = "W"
  if g:vmt_include_headings_before == 1
    keepjumps normal! gg0
    let l:flags = "Wc"
  endif

  let l:headingLineRegex = <SID>HeadingLineRegex()

  while search(l:headingLineRegex, l:flags) != 0
    let l:line = getline(".")
    let l:lineNum = line(".")
    if <SID>IsLineInCodeSections(l:codeSections, l:lineNum) == 0
      " === compatible with Setext Style headings
      let l:nextLine = getline(l:lineNum + 1)
      if matchstr(l:nextLine, '\v^\=+$') != ""
        let l:line = "# " . l:line
      elseif matchstr(l:nextLine, '\v^\-+$') != ""
        let l:line = "## " . l:line
      endif
      " ===

      call add(l:headingLines, l:line)
    endif
    let l:flags = "W"
  endwhile

  call winrestview(l:winview)

  return l:headingLines
endfunction

function! s:GetHeadingLevel(headingLine)
  return match(a:headingLine, '[^#]')
endfunction

function! s:GetHeadingLinkGFM(headingName)
  let l:headingLink = tr(a:headingName, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")

  " \_^ : start of line
  " _\+ : one of more underscore _
  " \| : OR
  " _\+ : one of more underscore _
  " \_$ : end of line
  let l:headingLink = substitute(l:headingLink, "\\_^_\\+\\|_\\+\\_$", "", "g")
  " Characters that are not alphanumeric, latin1 extended (for accents) and
  " chinese/korean chars are removed.
  " \\%#=0: allow this pattern to use the regexp engine he wants. Having
  " `set re=1` in the vimrc could break this behavior. cf. issue #19
  let l:headingLink = substitute(l:headingLink, "\\%#=0[^[:alnum:]\u00C0-\u00FF\u0400-\u04ff\u4e00-\u9fbf\u3040-\u309F\u30A0-\u30FF\uAC00-\uD7AF _-]", "", "g")
  let l:headingLink = substitute(l:headingLink, " ", "-", "g")

  if l:headingLink ==# ""
    let l:nullKey = "<null>"
    if has_key(g:GFMHeadingIds, l:nullKey)
      let g:GFMHeadingIds[l:nullKey] += 1
      let l:headingLink = l:headingLink . "-" . g:GFMHeadingIds[l:nullKey]
    else
      let g:GFMHeadingIds[l:nullKey] = 0
    endif
  elseif has_key(g:GFMHeadingIds, l:headingLink)
    let g:GFMHeadingIds[l:headingLink] += 1
    let l:headingLink = l:headingLink . "-" . g:GFMHeadingIds[l:headingLink]
  else
    let g:GFMHeadingIds[l:headingLink] = 0
  endif

  return l:headingLink
endfunction

" suppport for GitLab, fork of GetHeadingLinkGFM
" it's dirty to copy & paste code but more clear for maintain
function! s:GetHeadingLinkGitLab(headingName)
  let l:headingLink = tolower(a:headingName)

  let l:headingLink = substitute(l:headingLink, "\\_^_\\+\\|_\\+\\_$", "", "g")
  let l:headingLink = substitute(l:headingLink, "\\%#=0[^[:alnum:]\u00C0-\u00FF\u0400-\u04ff\u4e00-\u9fbf _-]", "", "g")
  let l:headingLink = substitute(l:headingLink, " ", "-", "g")
  let l:headingLink = substitute(l:headingLink, "-\\{2,}", "-", "g")

  if l:headingLink ==# ""
    let l:nullKey = "<null>"
    if has_key(g:GFMHeadingIds, l:nullKey)
      let g:GFMHeadingIds[l:nullKey] += 1
      let l:headingLink = l:headingLink . "-" . g:GFMHeadingIds[l:nullKey]
    else
      let g:GFMHeadingIds[l:nullKey] = 0
    endif
  elseif has_key(g:GFMHeadingIds, l:headingLink)
    let g:GFMHeadingIds[l:headingLink] += 1
    let l:headingLink = l:headingLink . "-" . g:GFMHeadingIds[l:headingLink]
  else
    let g:GFMHeadingIds[l:headingLink] = 0
  endif

  return l:headingLink
endfunction

function! s:GetHeadingLinkRedcarpet(headingName)
  let l:headingLink = tolower(a:headingName)

  let l:headingLink = substitute(l:headingLink, "<[^>]\\+>", "", "g")
  let l:headingLink = substitute(l:headingLink, "&", "&amp;", "g")
  let l:headingLink = substitute(l:headingLink, "\"", "&quot;", "g")
  let l:headingLink = substitute(l:headingLink, "'", "&#39;", "g")

  let l:headingLink = substitute(l:headingLink, "[ \\-&+\\$,/:;=?@\"#{}|\\^\\~\\[\\]`\\*()%.!']\\+", "-", "g")
  let l:headingLink = substitute(l:headingLink, "-\\{2,}", "-", "g")
  let l:headingLink = substitute(l:headingLink, "\\%^[\\-_]\\+\\|[\\-_]\\+\\%$", "", "g")

  return l:headingLink
endfunction

function! s:GetHeadingLinkMarked(headingName)
  let l:headingLink = tolower(a:headingName)

  let l:headingLink = substitute(l:headingLink, "[ ]\\+", "-", "g")

  return l:headingLink
endfunction

function! s:GetHeadingName(headingLine)
  let l:headingName = substitute(a:headingLine, '^#*\s*', "", "")
  let l:headingName = substitute(l:headingName, '\s*#*$', "", "")

  let l:headingName = substitute(l:headingName, '\[\([^\[\]]*\)\]([^()]*)', '\1', "g")
  let l:headingName = substitute(l:headingName, '\[\([^\[\]]*\)\]\[[^\[\]]*\]', '\1', "g")

  return l:headingName
endfunction

function! s:GetHeadingLink(headingName, markdownStyle)
  if a:markdownStyle ==# s:supportMarkdownStyles[s:GFM_STYLE_INDEX]
    return <SID>GetHeadingLinkGFM(a:headingName)
  elseif a:markdownStyle ==# s:supportMarkdownStyles[s:REDCARPET_STYLE_INDEX]
    return <SID>GetHeadingLinkRedcarpet(a:headingName)
  elseif a:markdownStyle ==# s:supportMarkdownStyles[s:GITLAB_STYLE_INDEX]
    return <SID>GetHeadingLinkGitLab(a:headingName)
  elseif a:markdownStyle ==# s:supportMarkdownStyles[s:MARKED_STYLE_INDEX]
    return <SID>GetHeadingLinkMarked(a:headingName)
  endif
endfunction

function! GetHeadingLinkTest(headingLine, markdownStyle)
  let l:headingName = <SID>GetHeadingName(a:headingLine)
  return <SID>GetHeadingLink(l:headingName, a:markdownStyle)
endfunction

function! s:GenToc(markdownStyle)
  call <SID>GenTocInner(a:markdownStyle, 0)
endfunction

function! s:GenTocInner(markdownStyle, isModeline)
  if index(s:supportMarkdownStyles, a:markdownStyle) == -1
    echom "Unsupport markdown style: " . a:markdownStyle
    return
  endif

  let l:headingLines = <SID>GetHeadingLines()
  let l:levels = []
  let l:listItemChars = [g:vmt_list_item_char]

  let g:GFMHeadingIds = {}

  for headingLine in l:headingLines
    call add(l:levels, <SID>GetHeadingLevel(headingLine))
  endfor

  let l:minLevel = max([min(l:levels),g:vmt_min_level])

  if g:vmt_dont_insert_fence == 0
    silent put =<SID>GetBeginFence(a:markdownStyle, a:isModeline)
  endif

  if g:vmt_cycle_list_item_markers == 1
    let l:listItemChars = ['*', '-', '+']
  endif

  let l:i = 0
  " a black line before toc
  if !empty(l:headingLines)
    silent put =''
  endif

  for headingLine in l:headingLines
    let l:headingName = <SID>GetHeadingName(headingLine)
    " only add line if less than max level and greater than min level
    if l:levels[i] <= g:vmt_max_level && l:levels[i] >= g:vmt_min_level
      let l:headingIndents = l:levels[i] - l:minLevel
      let l:listItemChar = l:listItemChars[(l:levels[i] + 1) % len(l:listItemChars)]
      " make link if desired, otherwise just bullets
      if g:vmt_link
        let l:headingLink = <SID>GetHeadingLink(l:headingName, a:markdownStyle)
        let l:heading = repeat(s:GetIndentText(), l:headingIndents)
        let l:heading = l:heading . l:listItemChar
        let l:heading = l:heading . " [" . l:headingName . "]"
        let l:heading = l:heading . "(#" . l:headingLink . ")"
      else
        let l:heading = repeat(s:GetIndentText(), l:headingIndents)
        let l:heading = l:heading . l:listItemChar
        let l:heading = l:heading . " " . l:headingName
      endif
      silent put =l:heading
    endif
    let l:i += 1
  endfor

  " a blank line after toc to avoid effect typo of content below
  silent put =''

  if g:vmt_dont_insert_fence == 0
    silent put =<SID>GetEndFence()
  endif
endfunction

function! s:GetIndentText()
  if !empty(g:vmt_list_indent_text)
    return g:vmt_list_indent_text
  endif
  if &expandtab
    return repeat(" ", &shiftwidth)
  else
    return "\t"
  endif
endfunction

function! s:GetBeginFence(markdownStyle, isModeline)
  if a:isModeline != 0
    return "<!-- " . g:vmt_fence_text . " -->"
  else
    return "<!-- ". g:vmt_fence_text . " " . a:markdownStyle . " -->"
  endif
endfunction

function! s:GetEndFence()
  return "<!-- " . g:vmt_fence_closing_text . " -->"
endfunction

function! s:GetBeginFencePattern(isModeline)
  if a:isModeline != 0
    return "<!-- " . g:vmt_fence_text . " -->"
  else
    return "<!-- " . g:vmt_fence_text . " \\([[:alpha:]]\\+\\)\\? \\?-->"
  endif
endfunction

function! s:GetEndFencePattern()
  return "<!-- " . g:vmt_fence_closing_text . " -->"
endfunction

function! s:GetMarkdownStyleInModeline()
  let l:myFileType = &filetype
  let l:lst = split(l:myFileType, "\\.")
  if len(l:lst) == 2 && l:lst[1] ==# "markdown"
    return l:lst[0]
  else
    return "Unknown"
  endif
endfunction

function! s:UpdateToc()
  let l:winview = winsaveview()

  let l:totalLineNum = line("$")

  let [l:markdownStyle, l:beginLineNumber, l:endLineNumber, l:isModeline] = <SID>DeleteExistingToc()

  if l:markdownStyle ==# ""
    echom "Cannot find existing toc"
  elseif l:markdownStyle ==# "Unknown"
    echom "Find unsupported style toc"
  else
    let l:isFirstLine = (l:beginLineNumber == 1)
    if l:beginLineNumber > 1
      let l:beginLineNumber -= 1
    endif

    if l:isFirstLine != 0
      call cursor(l:beginLineNumber, 1)
      put! =''
    endif

    call cursor(l:beginLineNumber, 1)
    call <SID>GenTocInner(l:markdownStyle, l:isModeline)

    if l:isFirstLine != 0
      call cursor(l:beginLineNumber, 1)
      delete _
    endif

    " fix line number to avoid shake
    if l:winview['lnum'] > l:endLineNumber
      let l:diff = line("$") - l:totalLineNum
      let l:winview['lnum'] += l:diff
      let l:winview['topline'] += l:diff
    endif
  endif

  call winrestview(l:winview)
endfunction

function! s:DeleteExistingToc()
  let l:winview = winsaveview()

  keepjumps normal! gg0

  let l:markdownStyle = <SID>GetMarkdownStyleInModeline()

  let l:isModeline = 0

  if index(s:supportMarkdownStyles, l:markdownStyle) != -1
    let l:isModeline = 1
  endif

  let l:tocBeginPattern = <SID>GetBeginFencePattern(l:isModeline)
  let l:tocEndPattern = <SID>GetEndFencePattern()

  let l:beginLineNumber = -1
  let l:endLineNumber= -1

  if search(l:tocBeginPattern, "Wc") != 0
    let l:beginLine = getline(".")
    let l:beginLineNumber = line(".")

    if search(l:tocEndPattern, "W") != 0
      if l:isModeline == 0
        let l:markdownStyle = matchlist(l:beginLine, l:tocBeginPattern)[1]
      endif

      let l:doDelete = 0
      if index(s:supportMarkdownStyles, l:markdownStyle) == -1
        if l:markdownStyle ==# "" && index(s:supportMarkdownStyles, g:vmt_fence_hidden_markdown_style) != -1
          let l:markdownStyle = g:vmt_fence_hidden_markdown_style
          let l:isModeline = 1
          let l:doDelete = 1
        else
          let l:markdownStyle = "Unknown"
        endif
      else
        let l:doDelete = 1
      endif

      if l:doDelete == 1
        let l:endLineNumber = line(".")
        silent execute l:beginLineNumber. "," . l:endLineNumber. "delete_"
        end
      else
        let l:markdownStyle = ""
        echom "Cannot find toc end fence"
      endif
    else
      let l:markdownStyle = ""
      echom "Cannot find toc begin fence"
    endif

    call winrestview(l:winview)

    return [l:markdownStyle, l:beginLineNumber, l:endLineNumber, l:isModeline]
  endfunction

  command! GenTocGFM :call <SID>GenToc(s:supportMarkdownStyles[s:GFM_STYLE_INDEX])
  command! GenTocGitLab :call <SID>GenToc(s:supportMarkdownStyles[s:GITLAB_STYLE_INDEX])
  command! GenTocRedcarpet :call <SID>GenToc(s:supportMarkdownStyles[s:REDCARPET_STYLE_INDEX])
  command! GenTocMarked :call <SID>GenToc(s:supportMarkdownStyles[s:MARKED_STYLE_INDEX])
  command! GenTocModeline :call <SID>GenTocInner(<SID>GetMarkdownStyleInModeline(), 1)
  command! UpdateToc :call <SID>UpdateToc()
  command! RemoveToc :call <SID>DeleteExistingToc()

  if g:vmt_auto_update_on_save == 1
    autocmd BufWritePre *.{md,mdown,mkd,mkdn,markdown,mdwn} if !&diff | exe 'silent! UpdateToc' | endif
  endif
