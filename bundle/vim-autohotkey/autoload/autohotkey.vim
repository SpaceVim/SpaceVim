let s:complete_dict = {
            \ 'AutoTrim' :
            \ "AutoTrim, On|Off\nDetermines whether <a href=\"SetEnv.htm\">Var1 = %Var2%</a> statements omit spaces and tabs from the beginning and end of Var2.",
            \ 'Blocks' :
            \ "{\nzero or more commands\n}\nA pair of braces denotes a block. Blocks are typically used with functions, Else, Loop, While-loop, and IF-commands.",
            \ 'BlockInput' :
            \ "BlockInput, Mode\nDisables or enables the user's ability to interact with the computer via keyboard and mouse. ",
            \ 'Break' :
            \ "Break [, LoopLabel]\nExits (terminates) a loop. Valid inside any kind of loop.",
            \ 'Catch' :
            \ '',
            \ 'Click' :
            \ '',
            \ 'ClipWait' :
            \ "ClipWait [, SecondsToWait, 1]\nWaits until the clipboard contains data.",
            \ 'ComObjActive()' :
            \ "ComObject := ComObjActive(CLSID)\nRetrieves a running object that has been registered with OLE.",
            \ 'ComObjArray()' :
            \ "ArrayObj := ComObjArray(VarType, Count1 [, Count2, ... Count8])\nCreates a SafeArray for use with COM.",
            \ 'ComObjConnect()' :
            \ "ComObjConnect(ComObject [, Prefix])\nConnects the object's event sources to functions with a given prefix.",
            \ 'ComObjCreate()' :
            \ "ComObject := ComObjCreate(CLSID [, IID])\nCreates a COM object.",
            \ 'ComObjError()' :
            \ "Enabled := ComObjError([Enable])\nEnables or disables notification of COM errors.",
            \ 'ComObjFlags()' :
            \ "Flags := ComObjFlags(ComObject [, NewFlags, Mask])\nRetrieves or changes flags which control a COM wrapper object's behaviour.",
            \ 'ComObjGet()' :
            \ "ComObject := ComObjGet(Name)\nReturns a reference to an object provided by a COM component.",
            \ 'ComObjQuery()' :
            \ "InterfacePointer := ComObjQuery(ComObject, [SID,] IID)\nQueries a COM object for an interface or service.",
            \ 'ComObjType()' :
            \ "VarType := ComObjType(ComObject)\nName    := ComObjType(ComObject, \"Name\")\nIID     := ComObjType(ComObject, \"IID\")\nRetrieves type information from a COM object.",
            \ 'ComObjValue()' :
            \ "Value := ComObjValue(ComObject)\nRetrieves the value or pointer stored in a COM wrapper object.",
            \ 'Continue' :
            \ "Continue [, LoopLabel]\nSkips the rest of the current loop iteration and begins a new one. Valid inside any kind of loop.",
            \ 'Control' :
            \ "Control, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nMakes a variety of changes to a control.",
            \ 'ControlClick' :
            \ "ControlClick [, Control-or-Pos, WinTitle, WinText, WhichButton, ClickCount, Options, ExcludeTitle, ExcludeText]\nSends a mouse  button or mouse wheel event to a  control. ",
            \ 'ControlFocus' :
            \ "ControlFocus [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nSets input focus to a given control on a window. ",
            \ 'ControlGet' :
            \ "ControlGet, OutputVar, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves various types of information about a control. ",
            \ 'ControlGetFocus' :
            \ "ControlGetFocus, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves which control of the target window has input focus, if any.",
            \ 'ControlGetPos' :
            \ "ControlGetPos [, X, Y, Width, Height, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the position and size of a control.",
            \ 'ControlGetText' :
            \ "ControlGetText, OutputVar [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves text from a control. ",
            \ 'ControlMove' :
            \ "ControlMove, Control, X, Y, Width, Height [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nMoves or resizes a control. ",
            \ 'ControlSend' :
            \ "ControlSend [, Control, Keys, WinTitle, WinText, ExcludeTitle, ExcludeText]\nControlSendRaw: Same parameters as above.\nSends simulated keystrokes to a window or control.",
            \ 'ControlSendRaw' :
            \ "ControlSend [, Control, Keys, WinTitle, WinText, ExcludeTitle, ExcludeText]\nControlSendRaw: Same parameters as above.\nSends simulated keystrokes to a window or control.",
            \ 'ControlSetText' :
            \ "ControlSetText [, Control, NewText, WinTitle, WinText, ExcludeTitle, ExcludeText]\nChanges the text of a control. ",
            \ 'CoordMode' :
            \ "CoordMode, ToolTip|Pixel|Mouse|Caret|Menu [, Screen|Window|Client]\nSets coordinate mode for various commands to be relative to either the active window or the screen.",
            \ 'Critical' :
            \ "Critical [, Off]\nCritical 50 ; See <a href=\"#Interval\">bottom of remarks</a>.\nPrevents the current thread from being interrupted by other threads.",
            \ 'DetectHiddenText' :
            \ "DetectHiddenText, On|Off\nDetermines whether invisible text in a window is \"seen\" for the purpose of finding the window. This affects commands such as IfWinExist and WinActivate.",
            \ 'DetectHiddenWindows' :
            \ "DetectHiddenWindows, On|Off\nDetermines whether invisible windows are \"seen\" by the script.",
            \ 'DllCall' :
            \ "Result := DllCall(\"[DllFile\]Function\" [, Type1, Arg1, Type2, Arg2, \"Cdecl ReturnType\"])\nCalls a function inside a DLL, such as a standard Windows API function.",
            \ 'Drive' :
            \ "Drive, Sub-command [, Drive , Value]\nEjects/retracts the tray in a CD or DVD drive, or sets a drive's volume label. ",
            \ 'DriveGet' :
            \ "DriveGet, OutputVar, Cmd [, Value]\nRetrieves various types of information about the computer's drive(s). ",
            \ 'DriveSpaceFree' :
            \ "DriveSpaceFree, OutputVar, Path\nRetrieves the free disk space of a drive, in Megabytes.",
            \ 'Edit' :
            \ "Edit\nOpens the current script for editing in the associated editor.",
            \ 'Else' :
            \ "Else\nSpecifies the command(s) to perform if an IF-statement evaluates to FALSE. When more than one command is present, enclose them in a block (braces). ",
            \ 'EnvAdd' :
            \ "EnvAdd, Var, Value [, TimeUnits]\nVar += Value [, TimeUnits]\nVar++\nSets a variable to the sum of itself plus the given value (can also add or subtract time from a date-time value). Synonymous with: var += value.",
            \ 'EnvDiv' :
            \ "EnvDiv, Var, Value\nSets a variable to itself divided by the given value. Synonymous with: Var /= Value.",
            \ 'EnvGet' :
            \ "EnvGet, OutputVar, EnvVarName\nRetrieves an environment variable.",
            \ 'EnvMult' :
            \ "EnvMult, Var, Value\nSets a variable to itself times the given value. Synonymous with: Var *= Value.",
            \ 'EnvSet' :
            \ "EnvSet, EnvVar, Value\nWrites a value to a variable contained in the  environment.",
            \ 'EnvSub' :
            \ "EnvSub, Var, Value [, TimeUnits]\nVar -= Value [, TimeUnits]\nVar--\nSets a variable to itself minus the given value (can also compare date-time values). Synonymous with: Var -= Value.",
            \ 'EnvUpdate' :
            \ "EnvUpdate\nNotifies the OS and all running applications that environment variable(s) have changed.",
            \ 'Exit' :
            \ "Exit [, ExitCode]\nExits the current thread or (if the script is not persistent and contains no hotkeys) the entire script.",
            \ 'ExitApp' :
            \ "ExitApp [, ExitCode]\nTerminates the script unconditionally.",
            \ 'FileAppend' :
            \ "FileAppend [, Text, Filename, Encoding]\nWrites text to the end of a file (first creating the file, if necessary).",
            \ 'FileCopy' :
            \ "FileCopy, SourcePattern, DestPattern [, Flag]\nCopies one or more files.",
            \ 'FileCopyDir' :
            \ "FileCopyDir, Source, Dest [, Flag]\nCopies a folder along with all its sub-folders and files (similar to xcopy).",
            \ 'FileCreateDir' :
            \ "FileCreateDir, DirName\nCreates a directory/folder. ",
            \ 'FileCreateShortcut' :
            \ "FileCreateShortcut, Target, LinkFile [, WorkingDir, Args, Description, IconFile, ShortcutKey, IconNumber, RunState]\nCreates a shortcut (.lnk) file.",
            \ 'FileDelete' :
            \ "FileDelete, FilePattern\nDeletes one or more files. ",
            \ 'FileEncoding' :
            \ "FileEncoding [, Encoding]\nSets the default encoding for FileRead, FileReadLine, Loop Read, FileAppend, and FileOpen.",
            \ 'FileGetAttrib' :
            \ "FileGetAttrib, OutputVar [, Filename]\nAttributeString := FileExist(FilePattern)\nReports whether a file or folder is read-only, hidden, etc. ",
            \ 'FileGetShortcut' :
            \ "FileGetShortcut, LinkFile [, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState]\nRetrieves information about a shortcut (.lnk) file, such as its target file. ",
            \ 'FileGetSize' :
            \ "FileGetSize, OutputVar [, Filename, Units]\nRetrieves the size of a file.",
            \ 'FileGetTime' :
            \ "FileGetTime, OutputVar [, Filename, WhichTime]\nRetrieves the datetime stamp of a file or folder.",
            \ 'FileGetVersion' :
            \ "FileGetVersion, OutputVar [, Filename]\nRetrieves the version of a file.",
            \ 'FileInstall' :
            \ "FileInstall, Source, Dest [, Flag]\nIncludes the specified file inside the compiled version of the script.",
            \ 'FileMove' :
            \ "FileMove, SourcePattern, DestPattern [, Flag]\nMoves or renames one or more files.",
            \ 'FileMoveDir' :
            \ "FileMoveDir, Source, Dest [, Flag]\nMoves a folder along with all its sub-folders and files. It can also rename a folder.",
            \ 'FileOpen' :
            \ "file := FileOpen(Filename, Flags [, Encoding])\nOpens a file.",
            \ 'FileRead' :
            \ "FileRead, OutputVar, Filename\nReads a file's contents into a variable.",
            \ 'FileReadLine' :
            \ "FileReadLine, OutputVar, Filename, LineNum\nReads the specified line  from a file and stores the text in a variable.",
            \ 'FileRecycle' :
            \ "FileRecycle, FilePattern\nSends a file or directory to the recycle bin, if possible.",
            \ 'FileRecycleEmpty' :
            \ "FileRecycleEmpty [, DriveLetter]\nEmpties the recycle bin. ",
            \ 'FileRemoveDir' :
            \ "FileRemoveDir, DirName [, Recurse?]\nDeletes a folder.",
            \ 'FileSelectFile' :
            \ "FileSelectFile, OutputVar [, Options, RootDir\Filename, Prompt, Filter]\nDisplays a standard dialog  that allows the user to open or save file(s).",
            \ 'FileSelectFolder' :
            \ "FileSelectFolder, OutputVar [, StartingFolder, Options, Prompt]\nDisplays a standard dialog  that allows the user to select a folder.",
            \ 'FileSetAttrib' :
            \ "FileSetAttrib, Attributes [, FilePattern, OperateOnFolders?, Recurse?]\nChanges the attributes of one or more files or folders. Wildcards are supported.",
            \ 'FileSetTime' :
            \ "FileSetTime [, YYYYMMDDHH24MISS, FilePattern, WhichTime, OperateOnFolders?, Recurse?]\nChanges the  datetime stamp of one or more files or folders. Wildcards are supported.",
            \ 'For-loop' :
            \ "For Key [, Value] in Expression\nRepeats a series of commands once for each key-value pair in an object.",
            \ 'FormatTime' :
            \ "FormatTime, OutputVar [, YYYYMMDDHH24MISS, Format]\nTransforms a YYYYMMDDHH24MISS timestamp into the specified date/time format.",
            \ 'GetKeyState' :
            \ "GetKeyState, OutputVar, KeyName [, Mode]\n      KeyIsDown := GetKeyState(\"KeyName\" [, \"Mode\"])\nChecks if a keyboard key or mouse/joystick button is down or up. Also retrieves joystick status.",
            \ 'Gosub' :
            \ "Gosub, Label\nJumps to the specified label and continues execution until Return is encountered.",
            \ 'Goto' :
            \ "Goto, Label\nJumps to the specified label and continues execution.",
            \ 'GroupActivate' :
            \ "GroupActivate, GroupName [, R]\nActivates the next window in a window group that was defined with GroupAdd.  ",
            \ 'GroupAdd' :
            \ "GroupAdd, GroupName [, WinTitle, WinText, Label, ExcludeTitle, ExcludeText]\nAdds a window specification to a window group, creating the group if necessary.",
            \ 'GroupClose' :
            \ "GroupClose, GroupName [, A|R]\nCloses the active window if it was just activated by GroupActivate or GroupDeactivate. It then activates the next window in the series. It can also close all windows in a group. ",
            \ 'GroupDeactivate' :
            \ "GroupDeactivate, GroupName [, R]\nSimilar to GroupActivate except activates the next window not in the group.",
            \ 'GUI' :
            \ "Gui, sub-command [, Param2, Param3, Param4]\nCreates and manages windows and controls. Such windows can be used as data entry forms or custom user interfaces.",
            \ 'GuiControl' :
            \ "GuiControl, Sub-command, ControlID [, Param3]\nMakes a variety of changes to a control in a GUI window.",
            \ 'GuiControlGet' :
            \ "GuiControlGet, OutputVar [, Sub-command, ControlID, Param4]\nRetrieves various types of information about a control in a GUI window. ",
            \ 'Hotkey' :
            \ "Hotkey, KeyName [, Label, Options]\nHotkey, IfWinActive/Exist [, WinTitle, WinText]\nHotkey, If, Expression\nCreates, modifies, enables, or disables a hotkey while the script is running.",
            \ 'If' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nif Var between LowerBound and UpperBound\nif Var not between LowerBound and UpperBound\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).\nif Var in MatchList\nif Var not in <i>MatchList<br>\n</i>if Var contains MatchList\nif Var not contains MatchList\nChecks whether a variable's contents match one of the items in a list.\n",
            \ 'IfEqual' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).",
            \ 'IfNotEqual' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).",
            \ 'IfLess' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).",
            \ 'IfLessOrEqual' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).",
            \ 'IfGreater' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).",
            \ 'IfGreaterOrEqual' :
            \ "IfEqual, var, value (same: if var = value)\nIfNotEqual, var, value (same: if var <> value) (!= can be used in place of <>)\nIfGreater, var, value (same: if var > value)\nIfGreaterOrEqual, var, value (same: if var >= value)\nIfLess, var, value (same: if var < value)\nIfLessOrEqual, var, value (same: if var <= value)\nIf var ; If var's contents are blank or 0, it is considered false. Otherwise, it is true.\nSee also: IfInString\nSpecifies the command(s) to perform if the comparison of a variable to a value evalutes to TRUE. When more than one command is present, enclose them in a block (braces).",
            \ 'IfExist' :
            \ "IfExist, FilePattern\nIfNotExist, FilePattern\nAttributeString := FileExist(FilePattern)\nChecks for the existence of a file or folder.",
            \ 'IfNotExist' :
            \ "IfExist, FilePattern\nIfNotExist, FilePattern\nAttributeString := FileExist(FilePattern)\nChecks for the existence of a file or folder.",
            \ 'if' :
            \ "if (expression)\nSpecifies the command(s) to perform if an expression evaluates to TRUE. ",
            \ 'contains' :
            \ "if Var in MatchList\nif Var not in <i>MatchList<br>\n</i>if Var contains MatchList\nif Var not contains MatchList\nChecks whether a variable's contents match one of the items in a list.",
            \ 'IfInString' :
            \ "IfInString, var, SearchString\nIfNotInString, var, SearchString\nPosition := InStr(Haystack, Needle [, CaseSensitive?, StartingPos]]) ; See the <a href=\"../Functions.htm#InStr\">InStr() function</a> for details.\nChecks if a variable contains the specified string.",
            \ 'IfNotInString' :
            \ "IfInString, var, SearchString\nIfNotInString, var, SearchString\nPosition := InStr(Haystack, Needle [, CaseSensitive?, StartingPos]]) ; See the <a href=\"../Functions.htm#InStr\">InStr() function</a> for details.\nChecks if a variable contains the specified string.",
            \ 'IfMsgBox' :
            \ "IfMsgBox, ButtonName\nChecks which button was pushed by the user during the most recent MsgBox command.",
            \ 'IfWinActive' :
            \ "IfWinActive [, WinTitle, WinText,  ExcludeTitle, ExcludeText]\nIfWinNotActive [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUniqueID := WinActive(\"WinTitle\", \"WinText\", \"ExcludeTitle\", \"ExcludeText\")\nChecks if the specified window exists and is currently active (foremost).",
            \ 'IfWinNotActive' :
            \ "IfWinActive [, WinTitle, WinText,  ExcludeTitle, ExcludeText]\nIfWinNotActive [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUniqueID := WinActive(\"WinTitle\", \"WinText\", \"ExcludeTitle\", \"ExcludeText\")\nChecks if the specified window exists and is currently active (foremost).",
            \ 'IfWinExist' :
            \ "IfWinExist [, WinTitle, WinText,  ExcludeTitle, ExcludeText]\nIfWinNotExist [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUniqueID := WinExist(\"WinTitle\", \"WinText\", \"ExcludeTitle\", \"ExcludeText\")\nChecks if a matching window exists. WinExist() returns the Unique ID (HWND) of the first matching window.",
            \ 'IfWinNotExist' :
            \ "IfWinExist [, WinTitle, WinText,  ExcludeTitle, ExcludeText]\nIfWinNotExist [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUniqueID := WinExist(\"WinTitle\", \"WinText\", \"ExcludeTitle\", \"ExcludeText\")\nChecks if a matching window exists. WinExist() returns the Unique ID (HWND) of the first matching window.",
            \ 'WinExist' :
            \ "IfWinExist [, WinTitle, WinText,  ExcludeTitle, ExcludeText]\nIfWinNotExist [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUniqueID := WinExist(\"WinTitle\", \"WinText\", \"ExcludeTitle\", \"ExcludeText\")\nChecks if a matching window exists. WinExist() returns the Unique ID (HWND) of the first matching window.",
            \ 'ImageSearch' :
            \ "ImageSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ImageFile\nSearches a region of the screen for an image.",
            \ 'IniDelete' :
            \ "IniDelete, Filename, Section [, Key]\nDeletes a value from a standard format .ini file. ",
            \ 'IniRead' :
            \ "IniRead, OutputVar, Filename [, Section, Key, Default]\nReads a value from a standard format .ini file.",
            \ 'IniWrite' :
            \ "IniWrite, Value, Filename, Section [, Key]\nWrites a value to a standard format .ini file.",
            \ 'Input' :
            \ "Input [, OutputVar, Options, EndKeys, MatchList]\nWaits for the user to type a string (not supported on Windows 9x: it does nothing).",
            \ 'InputBox' :
            \ "InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]\nDisplays an input box to ask the user to enter a string.",
            \ 'KeyHistory' :
            \ "KeyHistory\nDisplays script info and a history of the most recent keystrokes and mouse clicks.",
            \ 'KeyWait' :
            \ "KeyWait, KeyName [, Options]\nWaits for a key or mouse/joystick button to be released or pressed down. ",
            \ 'ListHotkeys' :
            \ "ListHotkeys\nDisplays the hotkeys in use by the current script, whether their subroutines are currently running, and whether or not they use the keyboard or mouse hook.",
            \ 'ListLines' :
            \ "ListLines [, On|Off]\nDisplays the script lines most recently executed.",
            \ 'ListVars' :
            \ "ListVars\nDisplays the script's variables: their names and current contents.",
            \ 'ListView' :
            \ "Gui, Add, ListView, Options, ColumnTitle1|ColumnTitle2|...\nA List-View is one of the most elaborate controls provided by the operating system. In its most recognizable form, it displays a tabular view of rows and columns, the most common example of which is Explorer's list of files and folders (detail view).</p>\n<p>Though it may be elaborate, a ListView's basic features are easy to use. The syntax for creating a ListView is:",
            \ 'Loop' :
            \ "Loop [, Count]\nPerform a series of commands repeatedly: either the specified number of times or until break is encountered.",
            \ 'Menu' :
            \ "Menu, MenuName, Cmd [, P3, P4, P5]\nCreates, deletes, modifies and displays menus and menu items. Changes the tray icon and its tooltip. Controls whether the main window of a compiled script can be opened.",
            \ 'MouseClick' :
            \ "MouseClick [, WhichButton , X, Y, ClickCount, Speed, D|U, R]\nClicks or holds down a mouse button, or turns the mouse wheel. NOTE: The Click command is generally more flexible and easier to use.",
            \ 'MouseClickDrag' :
            \ "MouseClickDrag, WhichButton, X1, Y1, X2, Y2 [, Speed, R]\nClicks and holds the specified mouse button, moves the mouse to the destination coordinates, then releases the button.",
            \ 'MouseGetPos' :
            \ "MouseGetPos, [OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1|2|3]\nRetrieves the current position of the mouse cursor, and optionally which window and control it is hovering over. ",
            \ 'MouseMove' :
            \ "MouseMove, X, Y [, Speed, R]\nMoves the mouse cursor.",
            \ 'MsgBox' :
            \ "MsgBox, Text\nMsgBox [, Options, Title, Text, Timeout]\nDisplays the specified text in a small window containing one or more buttons (such as Yes and No).",
            \ 'ObjAddRef()' :
            \ "ObjAddRef(Ptr)<br>ObjRelease(Ptr)\nIncrements or decrements an object's reference count.",
            \ 'ObjRelease()' :
            \ "ObjAddRef(Ptr)<br>ObjRelease(Ptr)\nIncrements or decrements an object's reference count.",
            \ 'OnExit' :
            \ "OnExit [, Label]\nSpecifies a subroutine to run  automatically when the script exits.",
            \ 'OnMessage' :
            \ "OnMessage(MsgNumber [, \"FunctionName\", MaxThreads])\nSpecifies a function to call automatically when the script receives the specified message.",
            \ 'OutputDebug' :
            \ "OutputDebug, Text\nSends a string to the debugger (if any) for display.",
            \ 'Pause' :
            \ "#p::Pause ; Pressing Win+P once will pause the script. Pressing it again will unpause.\nPause [, On|Off|Toggle, OperateOnUnderlyingThread?]\nPauses the script's current thread.",
            \ 'PixelGetColor' :
            \ "PixelGetColor, OutputVar, X, Y [, Alt|Slow|RGB]\nRetrieves  the color of the pixel at the specified x,y coordinates.",
            \ 'PixelSearch' :
            \ "PixelSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ColorID [, Variation, Fast|RGB]\nSearches a region of the screen for a pixel of the specified color.",
            \ 'PostMessage' :
            \ "PostMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nSendMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]\nSends a message to a window or control (SendMessage additionally waits for acknowledgement).",
            \ 'SendMessage' :
            \ "PostMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText]\nSendMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]\nSends a message to a window or control (SendMessage additionally waits for acknowledgement).",
            \ 'Process' :
            \ "Process, Cmd, PID-or-Name [, Param3]\nPerforms one of the following operations on a process: checks if it exists; changes its priority; closes it; waits for it to close.",
            \ 'Progress' :
            \ "SplashImage, Off\nSplashImage [, ImageFile, Options, SubText, MainText, WinTitle, FontName]\nProgress, Off\nProgress, ProgressParam1 [, SubText, MainText, WinTitle, FontName]\nCreates or updates a window containing a progress bar or an image.",
            \ 'SplashImage' :
            \ "SplashImage, Off\nSplashImage [, ImageFile, Options, SubText, MainText, WinTitle, FontName]\nProgress, Off\nProgress, ProgressParam1 [, SubText, MainText, WinTitle, FontName]\nCreates or updates a window containing a progress bar or an image.",
            \ 'Random' :
            \ "Random, OutputVar [, Min, Max]\nRandom, , NewSeed\nGenerates a pseudo-random number.",
            \ 'RegDelete' :
            \ "RegDelete, RootKey, SubKey [, ValueName]\nDeletes a subkey or value from the registry. ",
            \ 'RegExMatch' :
            \ "FoundPos := RegExMatch(Haystack, NeedleRegEx [, UnquotedOutputVar = \"\", StartingPosition = 1])\nDetermines whether a string contains a pattern (regular expression).",
            \ 'RegExReplace' :
            \ "NewStr := RegExReplace(Haystack, NeedleRegEx [, Replacement = \"\", OutputVarCount = \"\", Limit = -1, StartingPosition = 1])\nReplaces occurrences of a pattern (regular expression) inside a string.",
            \ 'RegisterCallback' :
            \ "Address := RegisterCallback(\"FunctionName\" [, Options = \"\", ParamCount = FormalCount, EventInfo = Address])\nCreates a machine-code address that when called, redirects the call to a function in the script.",
            \ 'RegRead' :
            \ "RegRead, OutputVar, RootKey, SubKey [, ValueName]\nReads a value from the registry.",
            \ 'RegWrite' :
            \ "RegWrite, ValueType, RootKey, SubKey [, ValueName, Value]\nWrites a value to the registry.",
            \ 'Reload' :
            \ "Reload\nReplaces the currently running instance of the script with a new one. ",
            \ 'Return' :
            \ "Return [, Expression]\nReturns from a subroutine to which execution had previously jumped via function-call, Gosub, Hotkey activation, GroupActivate, or other means. ",
            \ 'Run' :
            \ "Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]\nRuns an external program. Unlike Run, RunWait will wait until\nthe program finishes before continuing.",
            \ 'RunWait' :
            \ "Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID]\nRuns an external program. Unlike Run, RunWait will wait until\nthe program finishes before continuing.",
            \ 'RunAs' :
            \ "RunAs [, User, Password, Domain]\nSpecifies a set of user credentials to use for all subsequent uses of Run and RunWait. Requires Windows 2000/XP or later.",
            \ 'Send' :
            \ "Send Keys\nSendRaw Keys\nSendInput Keys\nSendPlay Keys\nSendEvent Keys\nSends simulated keystrokes and mouse clicks to the active window.",
            \ 'SendRaw' :
            \ "Send Keys\nSendRaw Keys\nSendInput Keys\nSendPlay Keys\nSendEvent Keys\nSends simulated keystrokes and mouse clicks to the active window.",
            \ 'SendInput' :
            \ "Send Keys\nSendRaw Keys\nSendInput Keys\nSendPlay Keys\nSendEvent Keys\nSends simulated keystrokes and mouse clicks to the active window.",
            \ 'SendPlay' :
            \ "Send Keys\nSendRaw Keys\nSendInput Keys\nSendPlay Keys\nSendEvent Keys\nSends simulated keystrokes and mouse clicks to the active window.",
            \ 'SendEvent' :
            \ "Send Keys\nSendRaw Keys\nSendInput Keys\nSendPlay Keys\nSendEvent Keys\nSends simulated keystrokes and mouse clicks to the active window.",
            \ 'SendLevel' :
            \ "SendLevel, Level\nControls which artificial keyboard and mouse events are ignored by hotkeys and hotstrings.",
            \ 'SendMode' :
            \ "SendMode Input|Play|Event|InputThenPlay\nMakes Send synonymous with SendInput or SendPlay rather than the default (SendEvent). Also makes Click and MouseMove/Click/Drag use the specified method.",
            \ 'SetBatchLines' :
            \ "SetBatchLines, 20ms\nSetBatchLines, LineCount\nDetermines how fast a script will run (affects CPU utilization).",
            \ 'SetControlDelay' :
            \ "SetControlDelay, Delay\nSets the delay that will occur after each control-modifying command.",
            \ 'SetDefaultMouseSpeed' :
            \ "SetDefaultMouseSpeed, Speed\nSets the mouse speed that will be used if unspecified in Click and MouseMove/Click/Drag.",
            \ 'SetEnv' :
            \ "SetEnv, Var, Value\nVar = Value\nAssigns the specified value to a variable.",
            \ 'SetFormat' :
            \ "SetFormat, NumberType, Format\nSets the format of integers and floating point numbers generated by math operations.",
            \ 'SetKeyDelay' :
            \ "SetKeyDelay [, Delay, PressDuration, Play]\nSets the delay that will occur after each keystroke sent by Send and ControlSend.",
            \ 'SetMouseDelay' :
            \ "SetMouseDelay, Delay [, Play]\nSets the delay that will occur after each mouse movement or click.",
            \ 'SetCapsLockState' :
            \ "SetCapsLockState [, State]\nSetNumLockState [, State]\nSetScrollLockState [, State]\nSets the state of the Capslock/NumLock/ScrollLock key. Can also force the key to stay on or off.",
            \ 'SetNumLockState' :
            \ "SetCapsLockState [, State]\nSetNumLockState [, State]\nSetScrollLockState [, State]\nSets the state of the Capslock/NumLock/ScrollLock key. Can also force the key to stay on or off.",
            \ 'SetScrollLockState' :
            \ "SetCapsLockState [, State]\nSetNumLockState [, State]\nSetScrollLockState [, State]\nSets the state of the Capslock/NumLock/ScrollLock key. Can also force the key to stay on or off.",
            \ 'SetRegView' :
            \ "SetRegView, RegView\nSets the registry view used by RegRead, RegWrite, RegDelete and registry loops.",
            \ 'SetStoreCapslockMode' :
            \ "SetStoreCapslockMode, On|Off\nWhether to restore the state of CapsLock after a Send.",
            \ 'SetTimer' :
            \ "SetTimer [, Label, Period|On|Off, Priority]\nCauses a subroutine to be launched automatically  and repeatedly at a specified time interval.",
            \ 'SetTitleMatchMode' :
            \ "SetTitleMatchMode, MatchMode\nSetTitleMatchMode, Fast|Slow\nSets the matching behavior of the WinTitle parameter in commands such as WinWait.",
            \ 'SetWinDelay' :
            \ "SetWinDelay, Delay\nSets the delay that will occur after each windowing command, such as WinActivate.",
            \ 'SetWorkingDir' :
            \ "SetWorkingDir, DirName\nChanges the script's current working directory. ",
            \ 'Shutdown' :
            \ "Shutdown, Code\nShuts down, restarts, or logs off the system.",
            \ 'Sleep' :
            \ "Sleep, DelayInMilliseconds\nWaits the specified amount of time before continuing.",
            \ 'Sort' :
            \ "Sort, VarName [, Options]\nArranges a variable's contents in alphabetical, numerical, or random order (optionally removing duplicates).",
            \ 'SoundBeep' :
            \ "SoundBeep [, Frequency, Duration]\nEmits a tone from the PC speaker.",
            \ 'SoundGet' :
            \ "SoundGet, OutputVar [, ComponentType, ControlType, DeviceNumber]\nRetrieves various settings from a sound device (master mute, master volume, etc.)",
            \ 'SoundGetWaveVolume' :
            \ "SoundGetWaveVolume, OutputVar [, DeviceNumber]\nRetrieves the wave output volume for a sound device.",
            \ 'SoundPlay' :
            \ "SoundPlay, Filename [, wait]\nPlays a sound, video, or other supported file type. ",
            \ 'SoundSet' :
            \ "SoundSet, NewSetting [, ComponentType, ControlType, DeviceNumber]\nChanges various settings of a sound device (master mute, master volume, etc.)",
            \ 'SoundSetWaveVolume' :
            \ "SoundSetWaveVolume, Percent [, DeviceNumber]\nChanges the wave output volume for a sound device.",
            \ 'SplashTextOn' :
            \ "SplashTextOff\nSplashTextOn [, Width, Height, Title, Text]\nCreates a customizable text popup window.",
            \ 'SplashTextOff' :
            \ "SplashTextOff\nSplashTextOn [, Width, Height, Title, Text]\nCreates a customizable text popup window.",
            \ 'SplitPath' :
            \ "SplitPath, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive]\nSeparates a file name or URL into its name, directory, extension, and drive.",
            \ 'StatusbarGetText' :
            \ "StatusBarGetText, OutputVar [, Part#, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the text from a standard status bar control. ",
            \ 'StatusBarWait' :
            \ "StatusBarWait [, BarText, Seconds, Part#, WinTitle, WinText, Interval, ExcludeTitle, ExcludeText]\nWaits until a window's status bar contains the specified string.",
            \ 'StringCaseSense' :
            \ "StringCaseSense, On|Off|Locale\nDetermines whether string comparisons are case sensitive (default is \"not case sensitive\"). ",
            \ 'StringGetPos' :
            \ "StringGetPos, OutputVar, InputVar, SearchText [, L#|R#, Offset]\nPosition := InStr(Haystack, Needle [, CaseSensitive?, StartingPos]) ; See the <a href=\"../Functions.htm#InStr\">InStr() function</a> for details.\nRetrieves the position of the specified substring within a string.",
            \ 'StringLeft' :
            \ "StringLeft, OutputVar, InputVar, Count\nStringRight, OutputVar, InputVar, Count\nNewStr := SubStr(String, StartPos [, Length]) ; See the <a href=\"../Functions.htm#SubStr\">SubStr() function</a> for details.\nRetrieves a number of characters from the left or right-hand side of\na string.",
            \ 'StringRight' :
            \ "StringLeft, OutputVar, InputVar, Count\nStringRight, OutputVar, InputVar, Count\nNewStr := SubStr(String, StartPos [, Length]) ; See the <a href=\"../Functions.htm#SubStr\">SubStr() function</a> for details.\nRetrieves a number of characters from the left or right-hand side of\na string.",
            \ 'StrLen' :
            \ "OutputVar := StrLen(InputVar)\nStringLen, OutputVar, InputVar\nRetrieves the count of how many characters are in a string.",
            \ 'StringLen' :
            \ "OutputVar := StrLen(InputVar)\nStringLen, OutputVar, InputVar\nRetrieves the count of how many characters are in a string.",
            \ 'StringLower' :
            \ "StringLower, OutputVar, InputVar [, T]\nStringUpper, OutputVar, InputVar [, T]\nConverts a string to lowercase or uppercase.",
            \ 'StringUpper' :
            \ "StringLower, OutputVar, InputVar [, T]\nStringUpper, OutputVar, InputVar [, T]\nConverts a string to lowercase or uppercase.",
            \ 'StringMid' :
            \ "StringMid, OutputVar, InputVar, StartChar [, Count , L]\nNewStr := SubStr(String, StartPos [, Length]) ; See the <a href=\"../Functions.htm#SubStr\">SubStr() function</a> for details.\nRetrieves one or more characters from the specified position in a string.",
            \ 'StringReplace' :
            \ "StringReplace, OutputVar, InputVar, SearchText [, ReplaceText, ReplaceAll?]\nReplaces the specified substring with a new string.",
            \ 'StringSplit' :
            \ "StringSplit, OutputArray, InputVar [, Delimiters, OmitChars]\nArray := StrSplit(String [, Delimiters, OmitChars])  ; [v1.1.13+]\nSeparates a string into an array of substrings using the specified delimiters.",
            \ 'StrSplit()' :
            \ "StringSplit, OutputArray, InputVar [, Delimiters, OmitChars]\nArray := StrSplit(String [, Delimiters, OmitChars])  ; [v1.1.13+]\nSeparates a string into an array of substrings using the specified delimiters.",
            \ 'StringTrimLeft' :
            \ "StringTrimLeft, OutputVar, InputVar, Count\nStringTrimRight, OutputVar, InputVar, Count\nNewStr := SubStr(String, StartPos [, Length]) ; See the <a href=\"../Functions.htm#SubStr\">SubStr() function</a> for details.\nRemoves a number of characters from the left or right-hand side of a\nstring.",
            \ 'StringTrimRight' :
            \ "StringTrimLeft, OutputVar, InputVar, Count\nStringTrimRight, OutputVar, InputVar, Count\nNewStr := SubStr(String, StartPos [, Length]) ; See the <a href=\"../Functions.htm#SubStr\">SubStr() function</a> for details.\nRemoves a number of characters from the left or right-hand side of a\nstring.",
            \ 'StrPut' :
            \ "StrPut(String [, Encoding = None ] )\nStrPut(String, Address [, Length] [, Encoding = None ] )\nStrGet(Address [, Length] [, Encoding = None ] )\nCopies a string to or from a memory address, optionally converting to or from a given code page.",
            \ 'StrGet' :
            \ "StrPut(String [, Encoding = None ] )\nStrPut(String, Address [, Length] [, Encoding = None ] )\nStrGet(Address [, Length] [, Encoding = None ] )\nCopies a string to or from a memory address, optionally converting to or from a given code page.",
            \ 'Suspend' :
            \ "Suspend [, Mode]\nDisables or enables all or selected hotkeys and hotstrings.",
            \ 'SysGet' :
            \ "SysGet, OutputVar, Sub-command [, Param3]\nRetrieves screen resolution, multi-monitor info, dimensions of system objects, and other system properties.",
            \ 'Thread' :
            \ "Thread, NoTimers [, false]\nThread, Priority, n\nThread, Interrupt [, Duration, LineCount]\nSets the priority or interruptibility of threads. It can also temporarily disable all timers.",
            \ 'Throw' :
            \ "Throw [, Expression]\nSignals the occurrence of an error. This signal can be caught by a try-catch statement.",
            \ 'ToolTip' :
            \ "ToolTip [, Text, X, Y, WhichToolTip]\nCreates an always-on-top window anywhere on the screen.",
            \ 'Transform' :
            \ "Transform, OutputVar, Cmd, Value1 [, Value2]\nPerforms miscellaneous math functions, bitwise operations, and tasks such as ASCII/Unicode conversion.",
            \ 'TrayTip' :
            \ "TrayTip [, Title, Text, Seconds, Options]\nCreates a balloon message window near the tray icon. Requires Windows 2000/XP or later.",
            \ 'TreeView' :
            \ "Gui, Add, TreeView, Options\nA Tree-View displays a hierarchy of items by indenting child items beneath their parents. The most common example is Explorer's tree of drives and folders.",
            \ 'Trim' :
            \ "Result :=  Trim(String, OmitChars = \" `t\")\nResult := LTrim(String, OmitChars = \" `t\")\nResult := RTrim(String, OmitChars = \" `t\")\nTrims characters from the beginning and/or end of a string.",
            \ 'Try' :
            \ "Try Statement\nGuards one or more statements (commands or expressions) against runtime errors and exceptions thrown by the throw command.",
            \ 'Until' :
            \ "Loop {\n    ...\n} Until Expression\nApplies a condition to the continuation of a Loop or For-loop.",
            \ 'UrlDownloadToFile' :
            \ "UrlDownloadToFile, URL, Filename\nDownloads a file from the Internet.",
            \ 'VarSetCapacity()' :
            \ "GrantedCapacity := VarSetCapacity(UnquotedVarName [, RequestedCapacity, FillByte])\nEnlarges a variable's holding capacity or frees its memory. Normally, this is necessary only for unusual circumstances such as DllCall.",
            \ 'While-loop' :
            \ "While Expression\nPerforms a series of commands repeatedly until the specified expression evaluates to false.",
            \ 'WinActivate' :
            \ "WinActivate [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nActivates the specified window (makes it foremost).",
            \ 'WinActivateBottom' :
            \ "WinActivateBottom [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nSame as WinActivate except that it activates the bottommost (least recently active) matching window rather than the topmost.",
            \ 'WinClose' :
            \ "WinClose [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText]\nCloses the specified  window.",
            \ 'WinGet' :
            \ "WinGet, OutputVar [, Cmd, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the specified window's unique ID, process ID, process name, or a list of its controls. It can also retrieve a list of all windows matching the specified criteria.",
            \ 'WinGetActiveStats' :
            \ "WinGetActiveStats, Title, Width, Height, X, Y\nCombines the functions of WinGetActiveTitle and WinGetPos into one command.",
            \ 'WinGetActiveTitle' :
            \ "WinGetActiveTitle, OutputVar\nRetrieves the title of the active window.",
            \ 'WinGetClass' :
            \ "WinGetClass, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the specified window's class name.",
            \ 'WinGetPos' :
            \ "WinGetPos [, X, Y, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the position and size of the specified window.",
            \ 'WinGetText' :
            \ "WinGetText, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the text from the specified window.",
            \ 'WinGetTitle' :
            \ "WinGetTitle, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nRetrieves the title of the specified window.",
            \ 'WinHide' :
            \ "WinHide [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nHides the specified window.",
            \ 'WinKill' :
            \ "WinKill [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText]\nForces the specified window to close.",
            \ 'WinMaximize' :
            \ "WinMaximize [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nEnlarges the specified window to its maximum size. ",
            \ 'WinMenuSelectItem' :
            \ "WinMenuSelectItem, WinTitle, WinText, Menu [, SubMenu1, SubMenu2, SubMenu3, SubMenu4, SubMenu5, SubMenu6, ExcludeTitle, ExcludeText]\nInvokes a menu item from the menu bar of the specified window.",
            \ 'WinMinimize' :
            \ "WinMinimize [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nCollapses the specified window into a button on the task bar.",
            \ 'WinMinimizeAll' :
            \ "WinMinimizeAll\nWinMinimizeAllUndo\nMinimizes or unminimizes all windows.",
            \ 'WinMinimizeAllUndo' :
            \ "WinMinimizeAll\nWinMinimizeAllUndo\nMinimizes or unminimizes all windows.",
            \ 'WinMove' :
            \ "WinMove, X, Y\nWinMove, WinTitle, WinText, X, Y [, Width, Height, ExcludeTitle, ExcludeText]\nChanges the position and/or size of the specified window.",
            \ 'WinRestore' :
            \ "WinRestore [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUnminimizes or unmaximizes the specified window if it is minimized or maximized.",
            \ 'WinSet' :
            \ "WinSet, Attribute, Value [, WinTitle, WinText,  ExcludeTitle, ExcludeText]\nMakes a variety of changes to the specified window, such as \"always on top\" and transparency.",
            \ 'WinSetTitle' :
            \ "WinSetTitle, NewTitle\nWinSetTitle, WinTitle, WinText, NewTitle [, ExcludeTitle, ExcludeText]\nChanges the title of the specified window.",
            \ 'WinShow' :
            \ "WinShow [, WinTitle, WinText, ExcludeTitle, ExcludeText]\nUnhides the specified window.",
            \ 'WinWait' :
            \ "WinWait [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]\nWaits until the specified window\nexists.",
            \ 'WinWaitActive' :
            \ "WinWaitActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]\nWinWaitNotActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]\nWaits until the specified window\nis active or not active. ",
            \ 'WinWaitNotActive' :
            \ "WinWaitActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]\nWinWaitNotActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]\nWaits until the specified window\nis active or not active. ",
            \ 'WinWaitClose' :
            \ "WinWaitClose [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText]\nWaits until the specified window\ndoes not exist.",
            \ '#AllowSameLineComments' :
            \ "#AllowSameLineComments\nRemoved in v1.1.09: AutoIt scripts are no longer supported.</p>\n<p>Only for AutoIt v2 (.aut) scripts: Allows a comment to appear on the same line as a command.",
            \ '#ClipboardTimeout' :
            \ "#ClipboardTimeout Milliseconds\nChanges how long the script keeps trying to access the clipboard when the first attempt fails.",
            \ '#CommentFlag' :
            \ "#CommentFlag NewString\nChanges the script's comment symbol from semicolon to some other string.",
            \ '#ErrorStdOut' :
            \ "#ErrorStdOut\nSends any syntax error that prevents a script from launching to stdout rather than displaying a dialog.",
            \ '#EscapeChar' :
            \ "#EscapeChar NewChar\nChanges the script's escape character (e.g. accent vs. backslash).",
            \ '#HotkeyInterval' :
            \ "#HotkeyInterval Milliseconds\nAlong with #MaxHotkeysPerInterval, specifies the rate of hotkey activations beyond which a warning dialog will be displayed.",
            \ '#HotkeyModifierTimeout' :
            \ "#HotkeyModifierTimeout Milliseconds\nAffects the behavior of hotkey modifiers: CTRL, ALT, WIN, and SHIFT.",
            \ '#Hotstring' :
            \ "#Hotstring NoMouse\n#Hotstring EndChars NewChars\n#Hotstring NewOptions\nChanges hotstring options or ending characters.",
            \ '#If' :
            \ "#If [, Expression ]\nCreates context-sensitive hotkeys and hotstrings. Such hotkeys perform a different action (or none at all) depending on the result of an expression.",
            \ '#IfTimeout' :
            \ "#IfTimeout Timeout\nSets the maximum time that may be spent evaluating a single #If expression.",
            \ '#IfWinActive' :
            \ "#IfWinActive [, WinTitle, WinText]\n#IfWinExist [, WinTitle, WinText]\n#IfWinNotActive [, WinTitle, WinText]\n#IfWinNotExist [, WinTitle, WinText]\n#If [, Expression]\nCreates context-sensitive hotkeys and hotstrings. Such hotkeys perform a different action (or none at all) depending on the type of window that is active or exists.",
            \ '#IfWinNotActive' :
            \ "#IfWinActive [, WinTitle, WinText]\n#IfWinExist [, WinTitle, WinText]\n#IfWinNotActive [, WinTitle, WinText]\n#IfWinNotExist [, WinTitle, WinText]\n#If [, Expression]\nCreates context-sensitive hotkeys and hotstrings. Such hotkeys perform a different action (or none at all) depending on the type of window that is active or exists.",
            \ '#IfWinExist' :
            \ "#IfWinActive [, WinTitle, WinText]\n#IfWinExist [, WinTitle, WinText]\n#IfWinNotActive [, WinTitle, WinText]\n#IfWinNotExist [, WinTitle, WinText]\n#If [, Expression]\nCreates context-sensitive hotkeys and hotstrings. Such hotkeys perform a different action (or none at all) depending on the type of window that is active or exists.",
            \ '#IfWinNotExist' :
            \ "#IfWinActive [, WinTitle, WinText]\n#IfWinExist [, WinTitle, WinText]\n#IfWinNotActive [, WinTitle, WinText]\n#IfWinNotExist [, WinTitle, WinText]\n#If [, Expression]\nCreates context-sensitive hotkeys and hotstrings. Such hotkeys perform a different action (or none at all) depending on the type of window that is active or exists.",
            \ '#Include' :
            \ "#Include FileOrDirName\n#Include <LibName>\n#IncludeAgain FileOrDirName\nCauses the script to behave as though the specified file's contents are present at this exact position.",
            \ '#InputLevel' :
            \ "#InputLevel [, Level]\nControls which artificial keyboard and mouse events are ignored by hotkeys and hotstrings.",
            \ '#InstallKeybdHook' :
            \ "#InstallKeybdHook\nForces the unconditional installation of the keyboard hook.",
            \ '#InstallMouseHook' :
            \ "#InstallMouseHook\nForces the unconditional installation of the mouse hook.",
            \ '#KeyHistory' :
            \ "#KeyHistory MaxEvents\nSets the maximum number of keyboard and mouse events displayed by the KeyHistory window. You can set it to 0 to disable key history.",
            \ '#MaxHotkeysPerInterval' :
            \ "#MaxHotkeysPerInterval Value\nAlong with #HotkeyInterval, specifies the rate of hotkey activations beyond which a warning dialog will be displayed.",
            \ '#MaxMem' :
            \ "#MaxMem Megabytes\nSets the maximum capacity of each variable to the specified number of megabytes.",
            \ '#MaxThreads' :
            \ "#MaxThreads Value\nSets the maximum number of simultaneous threads.",
            \ '#MaxThreadsBuffer' :
            \ "#MaxThreadsBuffer On|Off\nCauses some or all hotkeys to buffer rather than ignore keypresses when their #MaxThreadsPerHotkey limit has been reached. ",
            \ '#MaxThreadsPerHotkey' :
            \ "#MaxThreadsPerHotkey Value\nSets the maximum number of simultaneous threads per hotkey or hotstring.",
            \ '#MenuMaskKey' :
            \ "#MenuMaskKey KeyName\nChanges which key is used to mask Win or Alt keyup events.",
            \ '#NoEnv' :
            \ "#NoEnv\nAvoids checking empty variables to see if they are environment variables (recommended for all new scripts).",
            \ '#NoTrayIcon' :
            \ "#NoTrayIcon\nDisables the showing of a tray icon.",
            \ '#Persistent' :
            \ "#Persistent\nKeeps a script permanently running (that is, until the user closes it or ExitApp is encountered).",
            \ '#SingleInstance' :
            \ "#SingleInstance [force|ignore|off]\nDetermines whether a script is allowed to run again when it is already running.",
            \ '#UseHook' :
            \ "#UseHook [On|Off]\nForces the use of the  hook to implement all or some keyboard hotkeys.",
            \ '#Warn' :
            \ "#Warn [, WarningType, WarningMode]\nEnables or disables warnings for specific conditions which may indicate an error, such as a typo or missing \"global\" declaration.",
            \ '#WinActivateForce' :
            \ "#WinActivateForce\nSkips the gentle method of activating a window and goes straight to the forceful method. ",
            \ 'ACos': '',
            \ 'ASin': '',
            \ 'ATan': '',
            \ 'A_AhkPAth': '',
            \ 'A_AhkVersion': '',
            \ 'A_AppData': '',
            \ 'A_AppDataCommon': '',
            \ 'A_AutoTrim': '',
            \ 'A_BatchLines': '',
            \ 'A_CaretX': '',
            \ 'A_CaretY': '',
            \ 'A_ComputerName': '',
            \ 'A_ControlDelay': '',
            \ 'A_Cursor': '',
            \ 'A_DD': '',
            \ 'A_DDD': '',
            \ 'A_DDDD': '',
            \ 'A_DefaultMouseSpeed': '',
            \ 'A_Desktop': '',
            \ 'A_DesktopCommon': '',
            \ 'A_DetectHiddenText': '',
            \ 'A_DetectHiddenWindows': '',
            \ 'A_EndChar': '',
            \ 'A_EventInfo': '',
            \ 'A_ExitReason': '',
            \ 'A_FormatFloat': '',
            \ 'A_FormatInteger': '',
            \ 'A_Gui': '',
            \ 'A_GuiControl': '',
            \ 'A_GuiControlEvent': '',
            \ 'A_GuiEvent': '',
            \ 'A_GuiHeight': '',
            \ 'A_GuiWidth': '',
            \ 'A_GuiX': '',
            \ 'A_GuiY': '',
            \ 'A_Hour': '',
            \ 'A_IPAddress1': '',
            \ 'A_IPAddress2': '',
            \ 'A_IPAddress3': '',
            \ 'A_IPAddress4': '',
            \ 'A_IconFile': '',
            \ 'A_IconHidden': '',
            \ 'A_IconNumber': '',
            \ 'A_IconTip': '',
            \ 'A_Index': '',
            \ 'A_IsAdmin': '',
            \ 'A_IsCompiled': '',
            \ 'A_IsSuspended': '',
            \ 'A_KeyDelay': '',
            \ 'A_Language': '',
            \ 'A_LastError': '',
            \ 'A_LineFile': '',
            \ 'A_LineNumber': '',
            \ 'A_LoopField': '',
            \ 'A_LoopFileName': '',
            \ 'A_LoopReadLine': '',
            \ 'A_LoopRegName': '',
            \ 'A_MM': '',
            \ 'A_MMM': '',
            \ 'A_MMMM': '',
            \ 'A_MSec': '',
            \ 'A_Min': '',
            \ 'A_MouseDelay': '',
            \ 'A_MyDocuments': '',
            \ 'A_Now': '',
            \ 'A_NowUTC': '',
            \ 'A_OSType': '',
            \ 'A_OSVersion': '',
            \ 'A_PriorHotkey': '',
            \ 'A_ProgramFiles': '',
            \ 'A_Programs': '',
            \ 'A_ProgramsCommon': '',
            \ 'A_STringCaseSense': '',
            \ 'A_ScreenHeight': '',
            \ 'A_ScreenWidth': '',
            \ 'A_ScriptDir': '',
            \ 'A_ScriptFullPath': '',
            \ 'A_ScriptName': '',
            \ 'A_Sec': '',
            \ 'A_Space': '',
            \ 'A_StartMenu': '',
            \ 'A_StartMenuCommon': '',
            \ 'A_Startup': '',
            \ 'A_StartupCommon': '',
            \ 'A_Tab': '',
            \ 'A_Temp': '',
            \ 'A_ThisHotkey': '',
            \ 'A_ThisMenu': '',
            \ 'A_ThisMenuItem': '',
            \ 'A_ThisMenuItemPos': '',
            \ 'A_TickCount': '',
            \ 'A_TimeIdle': '',
            \ 'A_TimeIdlePhysical': '',
            \ 'A_TimeSincePriorHotkey': '',
            \ 'A_TimeSinceThisHotkey': '',
            \ 'A_TitleMatchMode': '',
            \ 'A_TitleMatchModeSpeed': '',
            \ 'A_UserName': '',
            \ 'A_WDay': '',
            \ 'A_WinDelay': '',
            \ 'A_WinDir': '',
            \ 'A_WorkingDir': '',
            \ 'A_YWeek': '',
            \ 'A_YYYY': '',
            \ 'Abs': '',
            \ 'AllowSameLineComments': '',
            \ 'Asc': '',
            \ 'Ceil': '',
            \ 'Chr': '',
            \ 'Clipboard': '',
            \ 'ClipboardAll': '',
            \ 'ClipboardTimeout': '',
            \ 'ComSpec': '',
            \ 'CommentFlag': '',
            \ 'Cos': '',
            \ 'ErrorLevel': '',
            \ 'ErrorStdOut': '',
            \ 'EscapeChar': '',
            \ 'Exp': '',
            \ 'FileExist': '',
            \ 'Floor': '',
            \ 'Gui': '',
            \ 'HotKeyModifierTimeout': '',
            \ 'HotkeyInterval': '',
            \ 'Hotstring': '',
            \ 'InStr': '',
            \ 'Include': '',
            \ 'IncludeAgain': '',
            \ 'InstallKeybdHook': '',
            \ 'InstallMouseHook': '',
            \ 'IsLabel': '',
            \ 'Ln': '',
            \ 'Log': '',
            \ 'MaxHotkeysPerInterval': '',
            \ 'MaxMem': '',
            \ 'MaxThreads': '',
            \ 'MaxThreadsBuffer': '',
            \ 'MaxThreadsPerHotkey': '',
            \ 'Mod': '',
            \ 'NoEnv': '',
            \ 'NoTrayIcon': '',
            \ 'Persistent': '',
            \ 'ProgramFiles': '',
            \ 'Round': '',
            \ 'SetNumScrollCapsLockState': '',
            \ 'Sin': '',
            \ 'SingleInstance': '',
            \ 'Sqrt': '',
            \ 'StatusBarGetText': '',
            \ 'SubStr': '',
            \ 'Tan': '',
            \ 'URLDownloadToFile': '',
            \ 'UseHook': '',
            \ 'VarSetCapacity': '',
            \ 'WinActivateForce': '',
            \ 'WinActive': '',
            \ 'ahk_class': '',
            \ 'ahk_group': '',
            \ 'ahk_id': '',
            \ 'ahk_pid': '',
            \ 'contained': '',
            \ 'false': '',
            \ 'global': '',
            \ 'local': '',
            \ 'true': '',
            \ }
function! autohotkey#complete(findstart, base) abort

    if a:findstart
        let line = getline('.')
        let idx = col('.') - 1
        let hasleftbrace = 0
        while idx > 0
            let idx -= 1
            let c = line[idx]
            if c =~# '\v[a-zA-Z0-9]'
                continue
            elseif c ==# '#'
                return idx
            else
                return idx+1
            endif
        endwhile
        return 0
    else
        let complete_dict = []
        for [k, v] in items(s:complete_dict)
            if  k =~ '^' . a:base
                call add(complete_dict, {'word': k, 'info': v, 'icase':1})
            endif
        endfor
        return sort(complete_dict)
    endif
endfunction
