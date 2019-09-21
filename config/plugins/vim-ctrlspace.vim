" CtrlSpace default settings

let g:CtrlSpaceDefaultMappingKey = "<C-space> "

let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

if executable("rg")
  let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
elseif executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
else
  echoerr "no suitable grepping executable found; please install rg or ag"
endif
