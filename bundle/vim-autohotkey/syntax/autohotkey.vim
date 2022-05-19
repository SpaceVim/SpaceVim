if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

" add the ; for ahk comments to work well (wrap and continue)
set comments=s1:/*,mb:*,ex:*/,:;

sy case ignore


sy keyword ahkKeyword ahk_id ahk_pid ahk_class ahk_group ahk_parent true false


" this is a great hack by savage. The problem is that it colors whatever you are
" writing in ahkFunction color, and then it turns normal when you leave. Very
" distracting. The solution is less elegant: list all posible ahk commands,
" which we do next.

" sy match ahkFunction "^\s*\w\{1,},"
" sy match ahkFunction "\w\{1,}," contained
" sy match ahkFunction "^\s*\w\{1,}\s*$" contains=ahkStatement
" sy match ahkFunction "\w\{1,}\s*$" contained
syn keyword ahkFunction
      \ ClipWait EnvGet EnvSet EnvUpdate
      \ Drive DriveGet DriveSpaceFree FileAppend FileCopy FileCopyDir
      \ FileCreateDir FileCreateShortcut FileDelete FileGetAttrib
      \ FileGetShortcut FileGetSize FileGetTime FileGetVersion FileInstall
      \ FileMove FileMoveDir FileReadLine FileRead FileRecycle FileRecycleEmpty
      \ FileRemoveDir FileSelectFolder FileSelectFile FileSetAttrib FileSetTime
      \ IniDelete IniRead IniWrite SetWorkingDir
      \ SplitPath
      \ Gui GuiControl GuiControlGet IfMsgBox InputBox MsgBox Progress
      \ SplashImage SplashTextOn SplashTextOff ToolTip TrayTip
      \ Hotkey ListHotkeys BlockInput ControlSend ControlSendRaw GetKeyState
      \ KeyHistory KeyWait Input Send SendRaw SendInput SendPlay SendEvent
      \ SendMode SetKeyDelay SetNumScrollCapsLockState SetStoreCapslockMode
      \ EnvAdd EnvDiv EnvMult EnvSub Random SetFormat Transform
      \ AutoTrim BlockInput CoordMode Critical Edit ImageSearch
      \ ListLines ListVars Menu OutputDebug PixelGetColor PixelSearch
      \ SetBatchLines SetEnv SetTimer SysGet Thread Transform URLDownloadToFile
      \ Click ControlClick MouseClick MouseClickDrag MouseGetPos MouseMove
      \ SetDefaultMouseSpeed SetMouseDelay
      \ Process Run RunWait RunAs Shutdown Sleep
      \ RegDelete RegRead RegWrite
      \ SoundBeep SoundGet SoundGetWaveVolume SoundPlay SoundSet
      \ SoundSetWaveVolume
      \ FormatTime IfInString IfNotInString Sort StringCaseSense StringGetPos
      \ StringLeft StringRight StringLower StringUpper StringMid StringReplace
      \ StringSplit StringTrimLeft StringTrimRight
      \ Control ControlClick ControlFocus ControlGet ControlGetFocus
      \ ControlGetPos ControlGetText ControlMove ControlSend ControlSendRaw
      \ ControlSetText Menu PostMessage SendMessage SetControlDelay
      \ WinMenuSelectItem GroupActivate GroupAdd GroupClose GroupDeactivate
      \ DetectHiddenText DetectHiddenWindows SetTitleMatchMode SetWinDelay
      \ StatusBarGetText StatusBarWait WinActivate WinActivateBottom WinClose
      \ WinGet WinGetActiveStats WinGetActiveTitle WinGetClass WinGetPos
      \ WinGetText WinGetTitle WinHide WinKill WinMaximize WinMinimize
      \ WinMinimizeAll WinMinimizeAllUndo WinMove WinRestore WinSet
      \ WinSetTitle WinShow WinWait WinWaitActive WinWaitNotActive WinWaitClose
      \ InStr RegExMatch RegExReplace StrLen SubStr Asc Chr
      \ DllCall VarSetCapacity WinActive WinExist IsLabel OnMessage
      \ Abs Ceil Exp Floor Log Ln Mod Round Sqrt Sin Cos Tan ASin ACos ATan
      \ FileExist GetKeyState numput numget RegisterCallback

" these are user-defined functions, in dark green
sy match ahkNewFunction "\s*\w\{1,}(.*)"
sy match ahkNewFunctionParams "(\@<=.*)\@=" containedin=ahkNewFunction

sy match ahkEscape "`." containedin=ahkFunction,ahkLabel,ahkVariable,ahkNewFunctionParams

" I don't like %var value% being in a different color than the var itself, so
" commented out.
"sy match ahkVariable "%.\{-}%" containedin=ahkNewFunctionParams
"sy match ahkVariable "%.\{-}%"

sy match ahkKey "[!#^+]\{1,4}`\=.\n" contains=ahkEscape
sy match ahkKey "[!#^+]\{0,4}{.\{-}}"


sy match ahkDirective "^#[a-zA-Z]\{2,\}"

sy match ahkLabel "^\w\+:\s*$"
sy match ahkLabel "^[^,]\+:\{2\}\(\w\+,\)\="  contains=ahkFunction
sy match ahkLabel "^[^,]\+:\{2\}\w\+\s*$" contains=ahkFunction
sy match ahkLabel "^:.\+:.*::"
sy keyword ahkLabel return containedin=ahkFunction

sy match ahkStatement "^\s*if\w*\(,\)\="
sy keyword ahkStatement If Else Loop Loop, exitapp containedin=ahkFunction

sy match ahkComment "`\@<!;.*" contains=NONE
sy match ahkComment "\/\*\_.\{-}\*\/" contains=NONE

sy keyword ahkBuiltinVariable
      \ A_Space A_Tab
      \ A_WorkingDir A_ScriptDir A_ScriptName A_ScriptFullPath A_LineNumber
      \ A_LineFile A_AhkVersion A_AhkPAth A_IsCompiled A_ExitReason
      \ A_YYYY A_MM A_DD A_MMMM A_MMM A_DDDD A_DDD A_WDay A_YWeek A_Hour A_Min
      \ A_Sec A_MSec A_Now A_NowUTC A_TickCount
      \ A_IsSuspended A_BatchLines A_TitleMatchMode A_TitleMatchModeSpeed
      \ A_DetectHiddenWindows A_DetectHiddenText A_AutoTrim A_STringCaseSense
      \ A_FormatInteger A_FormatFloat A_KeyDelay A_WinDelay A_ControlDelay
      \ A_MouseDelay A_DefaultMouseSpeed A_IconHidden A_IconTip A_IconFile
      \ A_IconNumber
      \ A_TimeIdle A_TimeIdlePhysical
      \ A_Gui A_GuiControl A_GuiWidth A_GuiHeight A_GuiX A_GuiY A_GuiEvent
      \ A_GuiControlEvent A_EventInfo
      \ A_ThisMenuItem A_ThisMenu A_ThisMenuItemPos A_ThisHotkey A_PriorHotkey
      \ A_TimeSinceThisHotkey A_TimeSincePriorHotkey A_EndChar
      \ ComSpec A_Temp A_OSType A_OSVersion A_Language A_ComputerName A_UserName
      \ A_WinDir A_ProgramFiles ProgramFiles A_AppData A_AppDataCommon A_Desktop
      \ A_DesktopCommon A_StartMenu A_StartMenuCommon A_Programs
      \ A_ProgramsCommon A_Startup A_StartupCommon A_MyDocuments A_IsAdmin
      \ A_ScreenWidth A_ScreenHeight A_IPAddress1 A_IPAddress2 A_IPAddress3
      \ A_IPAddress4
      \ A_Cursor A_CaretX A_CaretY Clipboard ClipboardAll ErrorLevel A_LastError
      \ A_Index A_LoopFileName A_LoopRegName A_LoopReadLine A_LoopField
		\ A_thisLabel A_thisFunc

sy match   ahkBuiltinVariable
      \ contained
      \ display
      \ '%\d\+%'

syn region ahkString
      \ display
      \ oneline
      \ matchgroup=autohotkeyStringDelimiter
      \ start=+"+
      \ end=+"+
      \ contains=ahkEscape

" relative
syn keyword ahkRelative
	\Pixel Mouse Screen Relative RGB

" Continuation sections:
syn keyword ahkContinuation
	\ LTrim RTrim Join

" Priority of processes
syn keyword ahkPriority
	\ Low BelowNormal Normal AboveNormal High Realtime

" Keywords inside the WinTitle parameter of various commands:
syn keyword ahkWinTitle
	\ ahk_id ahk_pid ahk_class ahk_group

" Used with SetFormat and/or -if Var is [not] type- & BETWEEN/IN
"syn keyword ahkSetFormatFamily
"	\ Between Contains In Is Integer Float Number Digit Xdigit Alpha Upper Lower Alnum Time Date

" Expression keywords:
syn keyword ahkLogicOperators
	\ Not Or And

" Used with Drive/DriveGet and/or WinGet/WinSet:
syn keyword ahkWingetFamily
	\ AlwaysOnTop Topmost Top Bottom Transparent TransColor Redraw Region ID IDLast ProcessName
	\ MinMax ControlList Count List Capacity StatusCD Eject Lock Unlock Label FileSystem Label
	\ SetLabel Serial Type Status

" For functions:
syn keyword ahkScopes
	\ static global local ByRef

" Time units for use with addition and subtraction:
syn keyword ahkTimeUnits
	\ Seconds Minutes Hours Days

" For use with the Loop command:
syn keyword ahkLoop
	\ Read Parse

" A_ExitReason
syn keyword ahkExitReasons
	\ Logoff Close Error Single

" Keywords used with the "menu" command:
syn keyword ahkMenuCommand
	\ Tray Add Rename Check UnCheck ToggleCheck Enable Disable ToggleEnable
	\ Default NoDefault Standard NoStandard Color Delete DeleteAll Icon NoIcon Tip
	\ Click Show MainWindow NoMainWindow UseErrorLevel

" Gui control types (note that Edit, Progress and Hotkey aren't included since they are already command keywords):
syn keyword ahkGUIcontrol
	\ Text Picture Pic GroupBox Button Checkbox Radio DropDownList DDL ComboBox
	\ ListBox ListView DateTime MonthCal Slider StatusBar Tab Tab2 TreeView UpDown

" ListView:
syn keyword ahkListView
	\ IconSmall Tile Report SortDesc NoSort NoSortHdr Grid Hdr AutoSize Range

" General GUI keywords:
syn keyword ahkGeneralGUI
	\ xm ym ys xs xp yp Font Resize Owner Submit NoHide Minimize Maximize Restore
	\ NoActivate NA Cancel Destroy Center Margin MaxSize MinSize OwnDialogs GuiEscape
	\ GuiClose GuiSize GuiContextMenu GuiDropFiles TabStop Section AltSubmit Wrap
	\ HScroll VScroll Border Top Bottom Buttons Expand First ImageList Lines
	\ WantCtrlA WantF2 Vis VisFirst Number Uppercase Lowercase Limit Password Multi
	\ WantReturn Group Background bold italic strike underline norm BackgroundTrans
	\ Theme Caption Delimiter MinimizeBox MaximizeBox SysMenu ToolWindow Flash
	\ Style ExStyle Check3 Checked CheckedGray ReadOnly Password Hidden Left
	\ Right Center NoTab Section Move Focus Hide Choose ChooseString Text Pos
	\ Enabled Disabled Visible LastFound LastFoundExist

" Keywords used with the Hotkey command:
syn keyword ahkHotkeyCommand
	\ AltTab ShiftAltTab AltTabMenu AltTabAndMenu AltTabMenuDismiss

" Keywords used with the Thread/Process commands
syn keyword ahkThread
	\ NoTimers Interrupt Priority WaitClose Wait Exist Close


" Keywords used with the Transform command:
syn keyword ahkTransformCommand
	\ Unicode Asc Chr Deref Mod Pow Exp Sqrt Log Ln Round Ceil Floor Abs Sin Cos Tan ASin
	\ ACos ATan BitNot BitAnd BitOr BitXOr BitShiftLeft BitShiftRight


" Keywords used with "IfMsgBox" ("continue" is not present here because it's a command too):
syn keyword ahkButtons
	\ Yes No Ok Cancel Abort Retry Ignore TryAgain

" Misc. eywords used with various commands:
syn keyword ahkOn
	\ On Off All

" Registry root keys:
syn keyword ahkRegistry
	\ HKEY_LOCAL_MACHINE HKEY_USERS HKEY_CURRENT_USER HKEY_CLASSES_ROOT HKEY_CURRENT_CONFIG
	\ HKLM HKU HKCU HKCR HKCC REG_SZ REG_EXPAND_SZ REG_MULTI_SZ REG_DWORD REG_BINARY



"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
hi def link ahkKeyword Special
hi def link ahkEscape Special
hi def link ahkComment Comment
hi def link ahkStatement Conditional
hi def link ahkFunction Keyword
hi def link ahkDirective PreProc "sent keys
hi def link ahkLabel Label
hi def link ahkKey Special
hi def link ahkVariable Constant "this is anything enclosed in %%
hi def link ahkNewFunction Function
hi def link ahkBuiltinVariable Macro
hi def link ahkString String
hi def link ahkScope Type
hi def link ahkOtherCommands 			Typedef
hi def link ahkRelative 				ahkOtherCommands
hi def link ahkContinuation 			ahkOtherCommands
hi def link ahkPriority 				ahkOtherCommands
hi def link ahkWinTitle 				ahkOtherCommands
hi def link ahkSetFormatFamily 		ahkOtherCommands
hi def link ahkLogicOperators 		ahkOtherCommands
hi def link ahkWingetFamily 			ahkOtherCommands
hi def link ahkScopes 					ahkOtherCommands
hi def link ahkTimeUnits 				ahkOtherCommands
hi def link ahkLoop 						ahkOtherCommands
hi def link ahkExitReasons 			ahkOtherCommands
hi def link ahkMenuCommand 			ahkOtherCommands
hi def link ahkGUIcontrol 				ahkOtherCommands
hi def link ahkListView 				ahkOtherCommands
hi def link ahkGeneralGUI 				ahkOtherCommands
hi def link ahkHotkeyCommand 			ahkOtherCommands
hi def link ahkThread 					ahkOtherCommands
hi def link ahkTransformCommand 		ahkOtherCommands
hi def link ahkButtons 					ahkOtherCommands
hi def link ahkOn 						ahkOtherCommands
hi def link ahkRegistry 				ahkOtherCommands

sy sync fromstart
let b:current_syntax = 'autohotkey'
