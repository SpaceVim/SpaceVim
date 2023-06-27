if exists('b:current_syntax') && b:current_syntax ==# 'leaderguide'
  finish
endif
let b:current_syntax = 'leaderguide'

if g:spacevim_leader_guide_theme == 'whichkey'
  syn region LeaderGuideDesc start='^' end='$' contains=LeaderGuideGroupName,LeaderGuideSep,LeaderGuideKeys
  syn match LeaderGuideSep /->/ contained
  syn match LeaderGuideGroupName /+\S*\(\s\S\+\)*/ contained
  syn match LeaderGuideKeys /[^ ]*\s\ze->/ contained

  hi def link LeaderGuideDesc Identifier
  hi def link LeaderGuideSep Comment
  hi def link LeaderGuideKeys Type
  hi def link LeaderGuideGroupName SpaceVimLeaderGuiderGroupName


else
  syn region LeaderGuideKeys start="\["hs=e+1 end="\]\s"he=s-1
        \ contained
  syn match LeaderGuideBrackets /\[[^ ]\+\]/
        \ contains=LeaderGuideKeys keepend
  syn match LeaderGuideGroupName / +[^\[^\]]\+/ contained
  syn region LeaderGuideDesc start="^" end="$"
        \ contains=LeaderGuideBrackets,LeaderGuideGroupName

  hi def link LeaderGuideDesc Identifier
  hi def link LeaderGuideKeys Type
  hi def link LeaderGuideBrackets Delimiter
  hi def link LeaderGuideGroupName SpaceVimLeaderGuiderGroupName


endif

