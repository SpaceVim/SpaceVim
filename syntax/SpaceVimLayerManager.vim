syntax clear
syntax region plug1 start=/\%1l/ end=/\%2l/ contains=plugNumber
syntax region plug2 start=/\%2l/ end=/\%3l/ contains=plugBracket,plugX
syn match plugNumber /[0-9]\+[0-9.]*/ contained
syn match plugBracket /[[\]]/ contained
syn match plugX /x/ contained
syn match plugDash /^-/
syn match plugPlus /^+/
syn match plugStar /^*/
syn match plugMessage /\(^- \)\@<=.*/
syntax match  rdocInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
hi def link rdocInlineURL htmlLink
syn match plugName /\(^- \)\@<=[^ ]*:/
syn match plugSha /\%(: \)\@<=[0-9a-f]\{4,}$/
syn match plugTag /(tag: [^)]\+)/
syn match plugInstall /\(^+ \)\@<=[^:]*/
syn match plugUpdate /\(^* \)\@<=[^:]*/
syn match plugCommit /^  \X*[0-9a-f]\{7,9} .*/ contains=plugRelDate,plugEdge,plugTag
syn match plugEdge /^  \X\+$/
syn match plugEdge /^  \X*/ contained nextgroup=plugSha
syn match plugSha /[0-9a-f]\{7,9}/ contained
syn match plugRelDate /([^)]*)$/ contained
syn match plugNotLoaded /(not loaded)$/
syn match plugError /^x.*/
syn region plugDeleted start=/^\~ .*/ end=/^\ze\S/
syn match plugH2 /^.*:\n-\+$/
syn keyword Function PlugInstall PlugStatus PlugUpdate PlugClean
hi def link plug1       Title
hi def link plug2       Repeat
hi def link plugH2      Type
hi def link plugX       Exception
hi def link plugBracket Structure
hi def link plugNumber  Number

hi def link plugDash    Special
hi def link plugPlus    Constant
hi def link plugStar    Boolean

hi def link plugMessage Function
hi def link plugName    Label
hi def link plugInstall Function
hi def link plugUpdate  Type

hi def link plugError   Error
hi def link plugDeleted Ignore
hi def link plugRelDate Comment
hi def link plugEdge    PreProc
hi def link plugSha     Identifier
hi def link plugTag     Constant

hi def link plugNotLoaded Comment
