" helpHeadline do not include # which is used in 
" SpaceVim layer name
syn match helpHeadline "^[-A-Z .][-A-Z0-9 .()_#]*\ze\(\s\+\*\|$\)"
