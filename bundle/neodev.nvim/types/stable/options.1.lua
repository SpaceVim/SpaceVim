---@meta

-- `'cursorline'`  `'cul'` 	boolean	(default off)
-- 			local to window
-- 	Highlight the text line of the cursor with CursorLine |hl-CursorLine|.
-- 	Useful to easily spot the cursor.  Will make screen redrawing slower.
-- 	When Visual mode is active the highlighting isn't used to make it
-- 	easier to see the selected text.
vim.wo.cursorline = false
vim.wo.cul = vim.wo.cursorline
-- `'cursorlineopt'`  `'culopt'`  string (default: "number,line")
-- 			local to window
-- 	Comma-separated list of settings for how `'cursorline'`  is displayed.
-- 	Valid values:
-- 	"line"		Highlight the text line of the cursor with
-- 			CursorLine |hl-CursorLine|.
-- 	"screenline"	Highlight only the screen line of the cursor with
-- 			CursorLine |hl-CursorLine|.
-- 	"number"	Highlight the line number of the cursor with
-- 			CursorLineNr |hl-CursorLineNr|.
-- 
-- 	Special value:
-- 	"both"		Alias for the values "line,number".
-- 
-- 	"line" and "screenline" cannot be used together.
vim.wo.cursorlineopt = "both"
vim.wo.culopt = vim.wo.cursorlineopt
-- `'diff'` 			boolean	(default off)
-- 			local to window
-- 	Join the current window in the group of windows that shows differences
-- 	between files.  See |diff-mode|.
vim.wo.diff = false
-- `'fillchars'`  `'fcs'` 	string	(default "")
-- 			global or local to window |global-local|
-- 	Characters to fill the statuslines, vertical separators and special
-- 	lines in the window.
-- 	It is a comma-separated list of items.  Each item has a name, a colon
-- 	and the value of that item:
-- 
-- 	  item		default		Used for ~
-- 	  stl		' ' or `'^'` 	statusline of the current window
-- 	  stlnc		' ' or `'='` 	statusline of the non-current windows
-- 	  wbr		' '		window bar
-- 	  horiz		`'─'`  or `'-'` 	horizontal separators |:split|
-- 	  horizup	`'┴'`  or `'-'` 	upwards facing horizontal separator
-- 	  horizdown	`'┬'`  or `'-'` 	downwards facing horizontal separator
-- 	  vert		`'│'`  or `'|'` 	vertical separators |:vsplit|
-- 	  vertleft	`'┤'`  or `'|'` 	left facing vertical separator
-- 	  vertright	`'├'`  or `'|'` 	right facing vertical separator
-- 	  verthoriz	`'┼'`  or `'+'` 	overlapping vertical and horizontal
-- 					separator
-- 	  fold		`'·'`  or `'-'` 	filling `'foldtext'` 
-- 	  foldopen	`'-'` 		mark the beginning of a fold
-- 	  foldclose	`'+'` 		show a closed fold
-- 	  foldsep	`'│'`  or `'|'`       open fold middle marker
-- 	  diff		`'-'` 		deleted lines of the `'diff'`  option
-- 	  msgsep	' '		message separator `'display'` 
-- 	  eob		`'~'` 		empty lines at the end of a buffer
-- 	  lastline	`'@'` 		`'display'`  contains lastline/truncate
-- 
-- 	Any one that is omitted will fall back to the default.  For "stl" and
-- 	"stlnc" the space will be used when there is highlighting, `'^'`  or `'='` 
-- 	otherwise.
-- 
-- 	Note that "horiz", "horizup", "horizdown", "vertleft", "vertright" and
-- 	"verthoriz" are only used when `'laststatus'`  is 3, since only vertical
-- 	window separators are used otherwise.
-- 
-- 	If `'ambiwidth'`  is "double" then "horiz", "horizup", "horizdown",
-- 	"vert", "vertleft", "vertright", "verthoriz", "foldsep" and "fold"
-- 	default to single-byte alternatives.
-- 
-- 	Example: >
-- 	    :set fillchars=stl:^,stlnc:=,vert:│,fold:·,diff:-
-- <	This is similar to the default, except that these characters will also
-- 	be used when there is highlighting.
-- 
-- 	For the "stl", "stlnc", "foldopen", "foldclose" and "foldsep" items
-- 	single-byte and multibyte characters are supported.  But double-width
-- 	characters are not supported.
-- 
-- 	The highlighting used for these items:
-- 	  item		highlight group ~
-- 	  stl		StatusLine		|hl-StatusLine|
-- 	  stlnc		StatusLineNC		|hl-StatusLineNC|
-- 	  wbr		WinBar			|hl-WinBar| or |hl-WinBarNC|
-- 	  horiz		WinSeparator		|hl-WinSeparator|
-- 	  horizup	WinSeparator		|hl-WinSeparator|
-- 	  horizdown	WinSeparator		|hl-WinSeparator|
-- 	  vert		WinSeparator		|hl-WinSeparator|
-- 	  vertleft	WinSeparator		|hl-WinSeparator|
-- 	  vertright	WinSeparator		|hl-WinSeparator|
-- 	  verthoriz	WinSeparator		|hl-WinSeparator|
-- 	  fold		Folded			|hl-Folded|
-- 	  diff		DiffDelete		|hl-DiffDelete|
-- 	  eob		EndOfBuffer		|hl-EndOfBuffer|
-- 	  lastline	NonText			|hl-NonText|
vim.wo.fillchars = ""
vim.wo.fcs = vim.wo.fillchars
-- `'foldcolumn'`  `'fdc'` 	string (default "0")
-- 			local to window
-- 	When and how to draw the foldcolumn. Valid values are:
-- 	    "auto":       resize to the minimum amount of folds to display.
-- 	    "auto:[1-9]": resize to accommodate multiple folds up to the
-- 			  selected level
--             0:            to disable foldcolumn
-- 	    "[1-9]":      to display a fixed number of columns
-- 	See |folding|.
vim.wo.foldcolumn = "0"
vim.wo.fdc = vim.wo.foldcolumn
-- `'foldenable'`  `'fen'` 	boolean (default on)
-- 			local to window
-- 	When off, all folds are open.  This option can be used to quickly
-- 	switch between showing all text unfolded and viewing the text with
-- 	folds (including manually opened or closed folds).  It can be toggled
-- 	with the |zi| command.  The `'foldcolumn'`  will remain blank when
-- 	`'foldenable'`  is off.
-- 	This option is set by commands that create a new fold or close a fold.
-- 	See |folding|.
vim.wo.foldenable = true
vim.wo.fen = vim.wo.foldenable
-- `'foldexpr'`  `'fde'` 	string (default: "0")
-- 			local to window
-- 	The expression used for when `'foldmethod'`  is "expr".  It is evaluated
-- 	for each line to obtain its fold level.  See |fold-expr|.
-- 
-- 	The expression will be evaluated in the |sandbox| if set from a
-- 	modeline, see |sandbox-option|.
-- 	This option can't be set from a |modeline| when the `'diff'`  option is
-- 	on or the `'modelineexpr'`  option is off.
-- 
-- 	It is not allowed to change text or jump to another window while
-- 	evaluating `'foldexpr'`  |textlock|.
vim.wo.foldexpr = "0"
vim.wo.fde = vim.wo.foldexpr
-- `'foldignore'`  `'fdi'` 	string (default: "#")
-- 			local to window
-- 	Used only when `'foldmethod'`  is "indent".  Lines starting with
-- 	characters in `'foldignore'`  will get their fold level from surrounding
-- 	lines.  White space is skipped before checking for this character.
-- 	The default "#" works well for C programs.  See |fold-indent|.
vim.wo.foldignore = "#"
vim.wo.fdi = vim.wo.foldignore
-- `'foldlevel'`  `'fdl'` 	number (default: 0)
-- 			local to window
-- 	Sets the fold level: Folds with a higher level will be closed.
-- 	Setting this option to zero will close all folds.  Higher numbers will
-- 	close fewer folds.
-- 	This option is set by commands like |zm|, |zM| and |zR|.
-- 	See |fold-foldlevel|.
vim.wo.foldlevel = 0
vim.wo.fdl = vim.wo.foldlevel
-- `'foldmarker'`  `'fmr'` 	string (default: "{{{,}}}")
-- 			local to window
-- 	The start and end marker used when `'foldmethod'`  is "marker".  There
-- 	must be one comma, which separates the start and end marker.  The
-- 	marker is a literal string (a regular expression would be too slow).
-- 	See |fold-marker|.
vim.wo.foldmarker = "{{{,}}}"
vim.wo.fmr = vim.wo.foldmarker
-- `'foldmethod'`  `'fdm'` 	string (default: "manual")
-- 			local to window
-- 	The kind of folding used for the current window.  Possible values:
-- 	|fold-manual|	manual	    Folds are created manually.
-- 	|fold-indent|	indent	    Lines with equal indent form a fold.
-- 	|fold-expr|	expr	    `'foldexpr'`  gives the fold level of a line.
-- 	|fold-marker|	marker	    Markers are used to specify folds.
-- 	|fold-syntax|	syntax	    Syntax highlighting items specify folds.
-- 	|fold-diff|	diff	    Fold text that is not changed.
vim.wo.foldmethod = "manual"
vim.wo.fdm = vim.wo.foldmethod
-- `'foldminlines'`  `'fml'` 	number (default: 1)
-- 			local to window
-- 	Sets the number of screen lines above which a fold can be displayed
-- 	closed.  Also for manually closed folds.  With the default value of
-- 	one a fold can only be closed if it takes up two or more screen lines.
-- 	Set to zero to be able to close folds of just one screen line.
-- 	Note that this only has an effect on what is displayed.  After using
-- 	"zc" to close a fold, which is displayed open because it's smaller
-- 	than `'foldminlines'` , a following "zc" may close a containing fold.
vim.wo.foldminlines = 1
vim.wo.fml = vim.wo.foldminlines
-- `'foldnestmax'`  `'fdn'` 	number (default: 20)
-- 			local to window
-- 	Sets the maximum nesting of folds for the "indent" and "syntax"
-- 	methods.  This avoids that too many folds will be created.  Using more
-- 	than 20 doesn't work, because the internal limit is 20.
vim.wo.foldnestmax = 20
vim.wo.fdn = vim.wo.foldnestmax
-- `'foldtext'`  `'fdt'` 	string (default: "foldtext()")
-- 			local to window
-- 	An expression which is used to specify the text displayed for a closed
-- 	fold.  See |fold-foldtext|.
-- 
-- 	The expression will be evaluated in the |sandbox| if set from a
-- 	modeline, see |sandbox-option|.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	It is not allowed to change text or jump to another window while
-- 	evaluating `'foldtext'`  |textlock|.
vim.wo.foldtext = "foldtext()"
vim.wo.fdt = vim.wo.foldtext
-- `'linebreak'`  `'lbr'` 	boolean	(default off)
-- 			local to window
-- 	If on, Vim will wrap long lines at a character in `'breakat'`  rather
-- 	than at the last character that fits on the screen.  Unlike
-- 	`'wrapmargin'`  and `'textwidth'` , this does not insert <EOL>s in the file,
-- 	it only affects the way the file is displayed, not its contents.
-- 	If `'breakindent'`  is set, line is visually indented. Then, the value
-- 	of `'showbreak'`  is used to put in front of wrapped lines. This option
-- 	is not used when the `'wrap'`  option is off.
-- 	Note that <Tab> characters after an <EOL> are mostly not displayed
-- 	with the right amount of white space.
vim.wo.linebreak = false
vim.wo.lbr = vim.wo.linebreak
-- `'list'` 			boolean	(default off)
-- 			local to window
-- 	List mode: By default, show tabs as ">", trailing spaces as "-", and
-- 	non-breakable space characters as "+". Useful to see the difference
-- 	between tabs and spaces and for trailing blanks. Further changed by
-- 	the `'listchars'`  option.
-- 
-- 	The cursor is displayed at the start of the space a Tab character
-- 	occupies, not at the end as usual in Normal mode.  To get this cursor
-- 	position while displaying Tabs with spaces, use: >
-- 		:set list lcs=tab:\ \
-- <
-- 	Note that list mode will also affect formatting (set with `'textwidth'` 
-- 	or `'wrapmargin'` ) when `'cpoptions'`  includes `'L'` .  See `'listchars'`  for
-- 	changing the way tabs are displayed.
vim.wo.list = false
-- `'listchars'`  `'lcs'` 	string	(default: "tab:> ,trail:-,nbsp:+")
-- 			global or local to window |global-local|
-- 	Strings to use in `'list'`  mode and for the |:list| command.  It is a
-- 	comma-separated list of string settings.
-- 
-- 
-- 	  eol:c		Character to show at the end of each line.  When
-- 			omitted, there is no extra character at the end of the
-- 			line.
-- 
-- 	  tab:xy[z]	Two or three characters to be used to show a tab.
-- 			The third character is optional.
-- 
-- 	  tab:xy	The `'x'`  is always used, then `'y'`  as many times as will
-- 			fit.  Thus "tab:>-" displays: >
-- 				>
-- 				>-
-- 				>--
-- 				etc.
-- <
-- 	  tab:xyz	The `'z'`  is always used, then `'x'`  is prepended, and
-- 			then `'y'`  is used as many times as will fit.  Thus
-- 			"tab:<->" displays: >
-- 				>
-- 				<>
-- 				<->
-- 				<-->
-- 				etc.
-- <
-- 			When "tab:" is omitted, a tab is shown as ^I.
-- 
-- 	  space:c	Character to show for a space.  When omitted, spaces
-- 			are left blank.
-- 
-- 	  multispace:c...
-- 			One or more characters to use cyclically to show for
-- 			multiple consecutive spaces.  Overrides the "space"
-- 			setting, except for single spaces.  When omitted, the
-- 			"space" setting is used.  For example,
-- 			`:set listchars=multispace:---+` shows ten consecutive
-- 			spaces as: >
-- 				---+---+--
-- <
-- 
-- 	  lead:c	Character to show for leading spaces.  When omitted,
-- 			leading spaces are blank.  Overrides the "space" and
-- 			"multispace" settings for leading spaces.  You can
-- 			combine it with "tab:", for example: >
-- 				:set listchars+=tab:>-,lead:.
-- <
-- 
-- 	  leadmultispace:c...
-- 			Like the |lcs-multispace| value, but for leading
-- 			spaces only.  Also overrides |lcs-lead| for leading
-- 			multiple spaces.
-- 			`:set listchars=leadmultispace:---+` shows ten
-- 			consecutive leading spaces as: >
-- 				---+---+--XXX
-- <
-- 			Where "XXX" denotes the first non-blank characters in
-- 			the line.
-- 
-- 	  trail:c	Character to show for trailing spaces.  When omitted,
-- 			trailing spaces are blank.  Overrides the "space" and
-- 			"multispace" settings for trailing spaces.
-- 
-- 	  extends:c	Character to show in the last column, when `'wrap'`  is
-- 			off and the line continues beyond the right of the
-- 			screen.
-- 
-- 	  precedes:c	Character to show in the first visible column of the
-- 			physical line, when there is text preceding the
-- 			character visible in the first column.
-- 
-- 	  conceal:c	Character to show in place of concealed text, when
-- 			`'conceallevel'`  is set to 1.  A space when omitted.
-- 
-- 	  nbsp:c	Character to show for a non-breakable space character
-- 			(0xA0 (160 decimal) and U+202F).  Left blank when
-- 			omitted.
-- 
-- 	The characters `':'`  and `','`  should not be used.  UTF-8 characters can
-- 	be used.  All characters must be single width.
-- 
-- 	Each character can be specified as hex: >
-- 		set listchars=eol:\\x24
-- 		set listchars=eol:\\u21b5
-- 		set listchars=eol:\\U000021b5
-- <	Note that a double backslash is used.  The number of hex characters
-- 	must be exactly 2 for \\x, 4 for \\u and 8 for \\U.
-- 
-- 	Examples: >
-- 	    :set lcs=tab:>-,trail:-
-- 	    :set lcs=tab:>-,eol:<,nbsp:%
-- 	    :set lcs=extends:>,precedes:<
-- <	|hl-NonText| highlighting will be used for "eol", "extends" and
-- 	"precedes". |hl-Whitespace| for "nbsp", "space", "tab", "multispace",
-- 	"lead" and "trail".
vim.wo.listchars = "tab:> ,trail:-,nbsp:+"
vim.wo.lcs = vim.wo.listchars
-- `'number'`  `'nu'` 		boolean	(default off)
-- 			local to window
-- 	Print the line number in front of each line.  When the `'n'`  option is
-- 	excluded from `'cpoptions'`  a wrapped line will not use the column of
-- 	line numbers.
-- 	Use the `'numberwidth'`  option to adjust the room for the line number.
-- 	When a long, wrapped line doesn't start with the first character, `'-'` 
-- 	characters are put before the number.
-- 	For highlighting see |hl-LineNr|, |hl-CursorLineNr|, and the
-- 	|:sign-define| "numhl" argument.
-- 
-- 	The `'relativenumber'`  option changes the displayed number to be
-- 	relative to the cursor.  Together with `'number'`  there are these
-- 	four combinations (cursor in line 3):
-- 
-- 		`'nonu'`           `'nu'`             `'nonu'`           `'nu'` 
-- 		`'nornu'`          `'nornu'`          `'rnu'`            `'rnu'` 
-- >
-- 	    |apple          |  1 apple      |  2 apple      |  2 apple
-- 	    |pear           |  2 pear       |  1 pear       |  1 pear
-- 	    |nobody         |  3 nobody     |  0 nobody     |3   nobody
-- 	    |there          |  4 there      |  1 there      |  1 there
-- <
vim.wo.number = false
vim.wo.nu = vim.wo.number
-- `'numberwidth'`  `'nuw'` 	number	(default: 4)
-- 			local to window
-- 	Minimal number of columns to use for the line number.  Only relevant
-- 	when the `'number'`  or `'relativenumber'`  option is set or printing lines
-- 	with a line number. Since one space is always between the number and
-- 	the text, there is one less character for the number itself.
-- 	The value is the minimum width.  A bigger width is used when needed to
-- 	fit the highest line number in the buffer respectively the number of
-- 	rows in the window, depending on whether `'number'`  or `'relativenumber'` 
-- 	is set. Thus with the Vim default of 4 there is room for a line number
-- 	up to 999. When the buffer has 1000 lines five columns will be used.
-- 	The minimum value is 1, the maximum value is 20.
vim.wo.numberwidth = 4
vim.wo.nuw = vim.wo.numberwidth
-- `'previewwindow'`  `'pvw'` 	boolean (default off)
-- 			local to window
-- 	Identifies the preview window.  Only one window can have this option
-- 	set.  It's normally not set directly, but by using one of the commands
-- 	|:ptag|, |:pedit|, etc.
vim.wo.previewwindow = false
vim.wo.pvw = vim.wo.previewwindow
-- `'relativenumber'`  `'rnu'` 	boolean	(default off)
-- 			local to window
-- 	Show the line number relative to the line with the cursor in front of
-- 	each line. Relative line numbers help you use the |count| you can
-- 	precede some vertical motion commands (e.g. j k + -) with, without
-- 	having to calculate it yourself. Especially useful in combination with
-- 	other commands (e.g. y d c < > gq gw =).
-- 	When the `'n'`  option is excluded from `'cpoptions'`  a wrapped
-- 	line will not use the column of line numbers.
-- 	The `'numberwidth'`  option can be used to set the room used for the line
-- 	number.
-- 	When a long, wrapped line doesn't start with the first character, `'-'` 
-- 	characters are put before the number.
-- 	See |hl-LineNr|  and |hl-CursorLineNr| for the highlighting used for
-- 	the number.
-- 
-- 	The number in front of the cursor line also depends on the value of
-- 	`'number'` , see |number_relativenumber| for all combinations of the two
-- 	options.
vim.wo.relativenumber = false
vim.wo.rnu = vim.wo.relativenumber
-- `'rightleft'`  `'rl'` 	boolean	(default off)
-- 			local to window
-- 	When on, display orientation becomes right-to-left, i.e., characters
-- 	that are stored in the file appear from the right to the left.
-- 	Using this option, it is possible to edit files for languages that
-- 	are written from the right to the left such as Hebrew and Arabic.
-- 	This option is per window, so it is possible to edit mixed files
-- 	simultaneously, or to view the same file in both ways (this is
-- 	useful whenever you have a mixed text file with both right-to-left
-- 	and left-to-right strings so that both sets are displayed properly
-- 	in different windows).  Also see |rileft.txt|.
vim.wo.rightleft = false
vim.wo.rl = vim.wo.rightleft
-- `'rightleftcmd'`  `'rlc'` 	string	(default "search")
-- 			local to window
-- 	Each word in this option enables the command line editing to work in
-- 	right-to-left mode for a group of commands:
-- 
-- 		search		"/" and "?" commands
-- 
-- 	This is useful for languages such as Hebrew, Arabic and Farsi.
-- 	The `'rightleft'`  option must be set for `'rightleftcmd'`  to take effect.
vim.wo.rightleftcmd = "search"
vim.wo.rlc = vim.wo.rightleftcmd
-- `'scroll'`  `'scr'` 		number	(default: half the window height)
-- 			local to window
-- 	Number of lines to scroll with CTRL-U and CTRL-D commands.  Will be
-- 	set to half the number of lines in the window when the window size
-- 	changes.  This may happen when enabling the |status-line| or
-- 	`'tabline'`  option after setting the `'scroll'`  option.
-- 	If you give a count to the CTRL-U or CTRL-D command it will
-- 	be used as the new value for `'scroll'` .  Reset to half the window
-- 	height with ":set scroll=0".
vim.wo.scroll = 0
vim.wo.scr = vim.wo.scroll
-- `'scrollbind'`  `'scb'` 	boolean  (default off)
-- 			local to window
-- 	See also |scroll-binding|.  When this option is set, the current
-- 	window scrolls as other scrollbind windows (windows that also have
-- 	this option set) scroll.  This option is useful for viewing the
-- 	differences between two versions of a file, see `'diff'` .
-- 	See |`'scrollopt'` | for options that determine how this option should be
-- 	interpreted.
-- 	This option is mostly reset when splitting a window to edit another
-- 	file.  This means that ":split | edit file" results in two windows
-- 	with scroll-binding, but ":split file" does not.
vim.wo.scrollbind = false
vim.wo.scb = vim.wo.scrollbind
-- `'scrolloff'`  `'so'` 	number	(default 0)
-- 			global or local to window |global-local|
-- 	Minimal number of screen lines to keep above and below the cursor.
-- 	This will make some context visible around where you are working.  If
-- 	you set it to a very large value (999) the cursor line will always be
-- 	in the middle of the window (except at the start or end of the file or
-- 	when long lines wrap).
-- 	After using the local value, go back the global value with one of
-- 	these two: >
-- 		setlocal scrolloff<
-- 		setlocal scrolloff=-1
-- <	For scrolling horizontally see `'sidescrolloff'` .
vim.wo.scrolloff = 0
vim.wo.so = vim.wo.scrolloff
-- `'showbreak'`  `'sbr'` 	string	(default "")
-- 			global or local to window |global-local|
-- 	String to put at the start of lines that have been wrapped.  Useful
-- 	values are "> " or "+++ ": >
-- 		:set showbreak=>\
-- <	Note the backslash to escape the trailing space.  It's easier like
-- 	this: >
-- 		:let &showbreak = '+++ '
-- <	Only printable single-cell characters are allowed, excluding <Tab> and
-- 	comma (in a future version the comma might be used to separate the
-- 	part that is shown at the end and at the start of a line).
-- 	The |hl-NonText| highlight group determines the highlighting.
-- 	Note that tabs after the showbreak will be displayed differently.
-- 	If you want the `'showbreak'`  to appear in between line numbers, add the
-- 	"n" flag to `'cpoptions'` .
-- 	A window-local value overrules a global value.  If the global value is
-- 	set and you want no value in the current window use NONE: >
-- 		:setlocal showbreak=NONE
-- <
vim.wo.showbreak = ""
vim.wo.sbr = vim.wo.showbreak
-- `'sidescrolloff'`  `'siso'` 	number (default 0)
-- 			global or local to window |global-local|
-- 	The minimal number of screen columns to keep to the left and to the
-- 	right of the cursor if `'nowrap'`  is set.  Setting this option to a
-- 	value greater than 0 while having |`'sidescroll'` | also at a non-zero
-- 	value makes some context visible in the line you are scrolling in
-- 	horizontally (except at beginning of the line).  Setting this option
-- 	to a large value (like 999) has the effect of keeping the cursor
-- 	horizontally centered in the window, as long as one does not come too
-- 	close to the beginning of the line.
-- 	After using the local value, go back the global value with one of
-- 	these two: >
-- 		setlocal sidescrolloff<
-- 		setlocal sidescrolloff=-1
-- <
-- 	Example: Try this together with `'sidescroll'`  and `'listchars'`  as
-- 		 in the following example to never allow the cursor to move
-- 		 onto the "extends" character: >
-- 
-- 		 :set nowrap sidescroll=1 listchars=extends:>,precedes:<
-- 		 :set sidescrolloff=1
-- <
vim.wo.sidescrolloff = 0
vim.wo.siso = vim.wo.sidescrolloff
-- `'signcolumn'`  `'scl'` 	string	(default "auto")
-- 			local to window
-- 	When and how to draw the signcolumn. Valid values are:
-- 	   "auto"	only when there is a sign to display
-- 	   "auto:[1-9]" resize to accommodate multiple signs up to the
-- 	                given number (maximum 9), e.g. "auto:4"
-- 	   "auto:[1-8]-[2-9]"
-- 	                resize to accommodate multiple signs up to the
-- 			given maximum number (maximum 9) while keeping
-- 			at least the given minimum (maximum 8) fixed
-- 			space. The minimum number should always be less
-- 			than the maximum number, e.g. "auto:2-5"
-- 	   "no"		never
-- 	   "yes"	always
-- 	   "yes:[1-9]"  always, with fixed space for signs up to the given
-- 	                number (maximum 9), e.g. "yes:3"
-- 	   "number"	display signs in the `'number'`  column. If the number
-- 			column is not present, then behaves like "auto".
-- 
-- 	Note regarding "orphaned signs": with signcolumn numbers higher than
-- 	1, deleting lines will also remove the associated signs automatically,
-- 	in contrast to the default Vim behavior of keeping and grouping them.
-- 	This is done in order for the signcolumn appearance not appear weird
-- 	during line deletion.
vim.wo.signcolumn = "auto"
vim.wo.scl = vim.wo.signcolumn
-- `'spell'` 			boolean	(default off)
-- 			local to window
-- 	When on spell checking will be done.  See |spell|.
-- 	The languages are specified with `'spelllang'` .
vim.wo.spell = false
-- `'statuscolumn'`  `'stc'` 	string	(default: empty)
-- 			local to window
-- 	EXPERIMENTAL
-- 	When non-empty, this option determines the content of the area to the
-- 	side of a window, normally containing the fold, sign and number columns.
-- 	The format of this option is like that of `'statusline'` .
-- 
-- 	Some of the items from the `'statusline'`  format are different for
-- 	`'statuscolumn'` :
-- 
-- 	%l	line number of currently drawn line
-- 	%r	relative line number of currently drawn line
-- 	%s	sign column for currently drawn line
-- 	%C	fold column for currently drawn line
-- 
-- 	NOTE: To draw the sign and fold columns, their items must be included in
-- 	`'statuscolumn'` . Even when they are not included, the status column width
-- 	will adapt to the `'signcolumn'`  and `'foldcolumn'`  width.
-- 
-- 	The |v:lnum|    variable holds the line number to be drawn.
-- 	The |v:relnum|  variable holds the relative line number to be drawn.
-- 	The |v:virtnum| variable is negative when drawing virtual lines, zero
-- 		      when drawing the actual buffer line, and positive when
-- 		      drawing the wrapped part of a buffer line.
-- 
-- 	NOTE: The %@ click execute function item is supported as well but the
-- 	specified function will be the same for each row in the same column.
-- 	It cannot be switched out through a dynamic `'statuscolumn'`  format, the
-- 	handler should be written with this in mind.
-- 
-- 	Examples: >vim
-- 		" Relative number with bar separator and click handlers:
-- 		:set statuscolumn=%@SignCb@%s%=%T%@NumCb@%r│%T
-- 
-- 		" Right aligned relative cursor line number:
-- 		:let &stc='%=%{v:relnum?v:relnum:v:lnum} '
-- 
-- 		" Line numbers in hexadecimal for non wrapped part of lines:
-- 		:let &stc='%=%{v:virtnum>0?"":printf("%x",v:lnum)} '
-- 
-- 		" Human readable line numbers with thousands separator:
-- 		:let &stc=`'%{substitute(v:lnum,"\\d\\zs\\ze\\'` 
-- 			   . `'%(\\d\\d\\d\\)\\+$",",","g")}'` 
-- 
-- 		" Both relative and absolute line numbers with different
-- 		" highlighting for odd and even relative numbers:
-- 		:let &stc=`'%#NonText#%{&nu?v:lnum:""}'`  .
-- 		 '%=%{&rnu&&(v:lnum%2)?"\ ".v:relnum:""}' .
-- 		 '%#LineNr#%{&rnu&&!(v:lnum%2)?"\ ".v:relnum:""}'
-- 
-- <	WARNING: this expression is evaluated for each screen line so defining
-- 	an expensive expression can negatively affect render performance.
vim.wo.statuscolumn = ""
vim.wo.stc = vim.wo.statuscolumn
-- `'statusline'`  `'stl'` 	string	(default empty)
-- 			global or local to window |global-local|
-- 	When non-empty, this option determines the content of the status line.
-- 	Also see |status-line|.
-- 
-- 	The option consists of printf style `'%'`  items interspersed with
-- 	normal text.  Each status line item is of the form:
-- 	  %-0{minwid}.{maxwid}{item}
-- 	All fields except the {item} are optional.  A single percent sign can
-- 	be given as "%%".
-- 
-- 	When the option starts with "%!" then it is used as an expression,
-- 	evaluated and the result is used as the option value.  Example: >
-- 		:set statusline=%!MyStatusLine()
-- <	The  variable will be set to the |window-ID| of the
-- 	window that the status line belongs to.
-- 	The result can contain %{} items that will be evaluated too.
-- 	Note that the "%!" expression is evaluated in the context of the
-- 	current window and buffer, while %{} items are evaluated in the
-- 	context of the window that the statusline belongs to.
-- 
-- 	When there is error while evaluating the option then it will be made
-- 	empty to avoid further errors.  Otherwise screen updating would loop.
-- 	When the result contains unprintable characters the result is
-- 	unpredictable.
-- 
-- 	Note that the only effect of `'ruler'`  when this option is set (and
-- 	`'laststatus'`  is 2 or 3) is controlling the output of |CTRL-G|.
-- 
-- 	field	    meaning ~
-- 	-	    Left justify the item.  The default is right justified
-- 		    when minwid is larger than the length of the item.
-- 	0	    Leading zeroes in numeric items.  Overridden by "-".
-- 	minwid	    Minimum width of the item, padding as set by "-" & "0".
-- 		    Value must be 50 or less.
-- 	maxwid	    Maximum width of the item.  Truncation occurs with a "<"
-- 		    on the left for text items.  Numeric items will be
-- 		    shifted down to maxwid-2 digits followed by ">"number
-- 		    where number is the amount of missing digits, much like
-- 		    an exponential notation.
-- 	item	    A one letter code as described below.
-- 
-- 	Following is a description of the possible statusline items.  The
-- 	second character in "item" is the type:
-- 		N for number
-- 		S for string
-- 		F for flags as described below
-- 		- not applicable
-- 
-- 	item  meaning ~
-- 	f S   Path to the file in the buffer, as typed or relative to current
-- 	      directory.
-- 	F S   Full path to the file in the buffer.
-- 	t S   File name (tail) of file in the buffer.
-- 	m F   Modified flag, text is "[+]"; "[-]" if `'modifiable'`  is off.
-- 	M F   Modified flag, text is ",+" or ",-".
-- 	r F   Readonly flag, text is "[RO]".
-- 	R F   Readonly flag, text is ",RO".
-- 	h F   Help buffer flag, text is "[help]".
-- 	H F   Help buffer flag, text is ",HLP".
-- 	w F   Preview window flag, text is "[Preview]".
-- 	W F   Preview window flag, text is ",PRV".
-- 	y F   Type of file in the buffer, e.g., "[vim]".  See `'filetype'` .
-- 	Y F   Type of file in the buffer, e.g., ",VIM".  See `'filetype'` .
-- 	q S   "[Quickfix List]", "[Location List]" or empty.
-- 	k S   Value of "b:keymap_name" or `'keymap'`  when |:lmap| mappings are
-- 	      being used: "<keymap>"
-- 	n N   Buffer number.
-- 	b N   Value of character under cursor.
-- 	B N   As above, in hexadecimal.
-- 	o N   Byte number in file of byte under cursor, first byte is 1.
-- 	      Mnemonic: Offset from start of file (with one added)
-- 	O N   As above, in hexadecimal.
-- 	l N   Line number.
-- 	L N   Number of lines in buffer.
-- 	c N   Column number (byte index).
-- 	v N   Virtual column number (screen column).
-- 	V N   Virtual column number as -{num}.  Not displayed if equal to `'c'` .
-- 	p N   Percentage through file in lines as in |CTRL-G|.
-- 	P S   Percentage through file of displayed window.  This is like the
-- 	      percentage described for `'ruler'` .  Always 3 in length, unless
-- 	      translated.
-- 	S S   `'showcmd'`  content, see `'showcmdloc'` .
-- 	a S   Argument list status as in default title.  ({current} of {max})
-- 	      Empty if the argument file count is zero or one.
-- 	{ NF  Evaluate expression between "%{" and "}" and substitute result.
-- 	      Note that there is no "%" before the closing "}".  The
-- 	      expression cannot contain a "}" character, call a function to
-- 	      work around that.  See |stl-%{| below.
-- 	`{%` -  This is almost same as "{" except the result of the expression is
-- 	      re-evaluated as a statusline format string.  Thus if the
-- 	      return value of expr contains "%" items they will get expanded.
-- 	      The expression can contain the "}" character, the end of
-- 	      expression is denoted by "%}".
-- 	      For example: >
-- 		func! Stl_filename() abort
-- 		    return "%t"
-- 		endfunc
-- <	        `stl=%{Stl_filename()}`   results in `"%t"`
-- 	        `stl=%{%Stl_filename()%}` results in `"Name of current file"`
-- 	%} -  End of "{%" expression
-- 	( -   Start of item group.  Can be used for setting the width and
-- 	      alignment of a section.  Must be followed by %) somewhere.
-- 	) -   End of item group.  No width fields allowed.
-- 	T N   For `'tabline'` : start of tab page N label.  Use %T or %X to end
-- 	      the label.  Clicking this label with left mouse button switches
-- 	      to the specified tab page.
-- 	X N   For `'tabline'` : start of close tab N label.  Use %X or %T to end
-- 	      the label, e.g.: %3Xclose%X.  Use %999X for a "close current
-- 	      tab" label.    Clicking this label with left mouse button closes
-- 	      specified tab page.
-- 	@ N   Start of execute function label. Use %X or %T to
-- 	      end the label, e.g.: %10@SwitchBuffer@foo.c%X.  Clicking this
-- 	      label runs specified function: in the example when clicking once
-- 	      using left mouse button on "foo.c" "SwitchBuffer(10, 1, `'l'` ,
-- 	      '    ')" expression will be run.  Function receives the
-- 	      following arguments in order:
-- 	      1. minwid field value or zero if no N was specified
-- 	      2. number of mouse clicks to detect multiple clicks
-- 	      3. mouse button used: "l", "r" or "m" for left, right or middle
-- 	         button respectively; one should not rely on third argument
-- 	         being only "l", "r" or "m": any other non-empty string value
-- 	         that contains only ASCII lower case letters may be expected
-- 	         for other mouse buttons
-- 	      4. modifiers pressed: string which contains "s" if shift
-- 	         modifier was pressed, "c" for control, "a" for alt and "m"
-- 	         for meta; currently if modifier is not pressed string
-- 	         contains space instead, but one should not rely on presence
-- 	         of spaces or specific order of modifiers: use |stridx()| to
-- 	         test whether some modifier is present; string is guaranteed
-- 	         to contain only ASCII letters and spaces, one letter per
-- 	         modifier; "?" modifier may also be present, but its presence
-- 	         is a bug that denotes that new mouse button recognition was
-- 	         added without modifying code that reacts on mouse clicks on
-- 	         this label.
-- 	      Use |getmousepos()|.winid in the specified function to get the
-- 	      corresponding window id of the clicked item.
-- 	< -   Where to truncate line if too long.  Default is at the start.
-- 	      No width fields allowed.
-- 	= -   Separation point between alignment sections.  Each section will
-- 	      be separated by an equal number of spaces.  With one %= what
-- 	      comes after it will be right-aligned.  With two %= there is a
-- 	      middle part, with white space left and right of it.
-- 	      No width fields allowed.
-- 	# -   Set highlight group.  The name must follow and then a # again.
-- 	      Thus use %#HLname# for highlight group HLname.  The same
-- 	      highlighting is used, also for the statusline of non-current
-- 	      windows.
-- 	* -   Set highlight group to User{N}, where {N} is taken from the
-- 	      minwid field, e.g. %1*.  Restore normal highlight with %* or %0*.
-- 	      The difference between User{N} and StatusLine will be applied to
-- 	      StatusLineNC for the statusline of non-current windows.
-- 	      The number N must be between 1 and 9.  See |hl-User1..9|
-- 
-- 	When displaying a flag, Vim removes the leading comma, if any, when
-- 	that flag comes right after plaintext.  This will make a nice display
-- 	when flags are used like in the examples below.
-- 
-- 	When all items in a group becomes an empty string (i.e. flags that are
-- 	not set) and a minwid is not set for the group, the whole group will
-- 	become empty.  This will make a group like the following disappear
-- 	completely from the statusline when none of the flags are set. >
-- 		:set statusline=...%(\ [%M%R%H]%)...
-- <	Beware that an expression is evaluated each and every time the status
-- 	line is displayed.
-- 
-- 	While evaluating %{} the current buffer and current window will be set
-- 	temporarily to that of the window (and buffer) whose statusline is
-- 	currently being drawn.  The expression will evaluate in this context.
-- 	The variable "g:actual_curbuf" is set to the `bufnr()` number of the
-- 	real current buffer and "g:actual_curwin" to the |window-ID| of the
-- 	real current window.  These values are strings.
-- 
-- 	The `'statusline'`  option will be evaluated in the |sandbox| if set from
-- 	a modeline, see |sandbox-option|.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	It is not allowed to change text or jump to another window while
-- 	evaluating `'statusline'`  |textlock|.
-- 
-- 	If the statusline is not updated when you want it (e.g., after setting
-- 	a variable that's used in an expression), you can force an update by
-- 	using `:redrawstatus`.
-- 
-- 	A result of all digits is regarded a number for display purposes.
-- 	Otherwise the result is taken as flag text and applied to the rules
-- 	described above.
-- 
-- 	Watch out for errors in expressions.  They may render Vim unusable!
-- 	If you are stuck, hold down `':'`  or `'Q'`  to get a prompt, then quit and
-- 	edit your vimrc or whatever with "vim --clean" to get it right.
-- 
-- 	Examples:
-- 	Emulate standard status line with `'ruler'`  set >
-- 	  :set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
-- <	Similar, but add ASCII value of char under the cursor (like "ga") >
-- 	  :set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
-- <	Display byte count and byte value, modified flag in red. >
-- 	  :set statusline=%<%f%=\ [%1%n%R%H]\ %-19(%3l,%02c%03V%)%O`'%02b'` 
-- 	  :hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red
-- <	Display a ,GZ flag if a compressed file is loaded >
-- 	  :set statusline=...%r%{VarExists(`'b:gzflag'` ,'\ [GZ]')}%h...
-- <	In the |:autocmd|'s: >
-- 	  :let b:gzflag = 1
-- <	And: >
-- 	  :unlet b:gzflag
-- <	And define this function: >
-- 	  :function VarExists(var, val)
-- 	  :    if exists(a:var) | return a:val | else | return `''`  | endif
-- 	  :endfunction
-- <
vim.wo.statusline = ""
vim.wo.stl = vim.wo.statusline
-- `'virtualedit'`  `'ve'` 	string	(default "")
-- 			global or local to window |global-local|
-- 	A comma-separated list of these words:
-- 	    block	Allow virtual editing in Visual block mode.
-- 	    insert	Allow virtual editing in Insert mode.
-- 	    all		Allow virtual editing in all modes.
-- 	    onemore	Allow the cursor to move just past the end of the line
-- 	    none	When used as the local value, do not allow virtual
-- 			editing even when the global value is set.  When used
-- 			as the global value, "none" is the same as "".
-- 	    NONE	Alternative spelling of "none".
-- 
-- 	Virtual editing means that the cursor can be positioned where there is
-- 	no actual character.  This can be halfway into a tab or beyond the end
-- 	of the line.  Useful for selecting a rectangle in Visual mode and
-- 	editing a table.
-- 	"onemore" is not the same, it will only allow moving the cursor just
-- 	after the last character of the line.  This makes some commands more
-- 	consistent.  Previously the cursor was always past the end of the line
-- 	if the line was empty.  But it is far from Vi compatible.  It may also
-- 	break some plugins or Vim scripts.  For example because |l| can move
-- 	the cursor after the last character.  Use with care!
-- 	Using the `$` command will move to the last character in the line, not
-- 	past it.  This may actually move the cursor to the left!
-- 	The `g$` command will move to the end of the screen line.
-- 	It doesn't make sense to combine "all" with "onemore", but you will
-- 	not get a warning for it.
-- 	When combined with other words, "none" is ignored.
vim.wo.virtualedit = ""
vim.wo.ve = vim.wo.virtualedit
-- `'winbar'`  `'wbr'` 		string (default empty)
-- 			global or local to window |global-local|
-- 	When non-empty, this option enables the window bar and determines its
-- 	contents. The window bar is a bar that's shown at the top of every
-- 	window with it enabled. The value of `'winbar'`  is evaluated like with
-- 	`'statusline'` .
-- 
-- 	When changing something that is used in `'winbar'`  that does not trigger
-- 	it to be updated, use |:redrawstatus|.
-- 
-- 	Floating windows do not use the global value of `'winbar'` . The
-- 	window-local value of `'winbar'`  must be set for a floating window to
-- 	have a window bar.
-- 
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
vim.wo.winbar = ""
vim.wo.wbr = vim.wo.winbar
-- `'winblend'`  `'winbl'` 		number	(default 0)
-- 			local to window
-- 	Enables pseudo-transparency for a floating window. Valid values are in
-- 	the range of 0 for fully opaque window (disabled) to 100 for fully
-- 	transparent background. Values between 0-30 are typically most useful.
-- 
-- 	UI-dependent. Works best with RGB colors. `'termguicolors'` 
vim.wo.winblend = 0
vim.wo.winbl = vim.wo.winblend
-- `'winfixheight'`  `'wfh'` 	boolean	(default off)
-- 			local to window
-- 	Keep the window height when windows are opened or closed and
-- 	`'equalalways'`  is set.  Also for |CTRL-W_=|.  Set by default for the
-- 	|preview-window| and |quickfix-window|.
-- 	The height may be changed anyway when running out of room.
vim.wo.winfixheight = false
vim.wo.wfh = vim.wo.winfixheight
-- `'winfixwidth'`  `'wfw'` 	boolean	(default off)
-- 			local to window
-- 	Keep the window width when windows are opened or closed and
-- 	`'equalalways'`  is set.  Also for |CTRL-W_=|.
-- 	The width may be changed anyway when running out of room.
vim.wo.winfixwidth = false
vim.wo.wfw = vim.wo.winfixwidth
-- `'winhighlight'`  `'winhl'` 	string (default empty)
-- 			local to window
-- 	Window-local highlights.  Comma-delimited list of highlight
-- 	|group-name| pairs "{hl-from}:{hl-to},..." where each {hl-from} is
-- 	a |highlight-groups| item to be overridden by {hl-to} group in
-- 	the window.
-- 
-- 	Note: highlight namespaces take precedence over `'winhighlight'` .
-- 	See |nvim_win_set_hl_ns()| and |nvim_set_hl()|.
-- 
-- 	Highlights of vertical separators are determined by the window to the
-- 	left of the separator.  The `'tabline'`  highlight of a tabpage is
-- 	decided by the last-focused window of the tabpage.  Highlights of
-- 	the popupmenu are determined by the current window.  Highlights in the
-- 	message area cannot be overridden.
-- 
-- 	Example: show a different color for non-current windows: >
-- 		set winhighlight=Normal:MyNormal,NormalNC:MyNormalNC
-- <
vim.wo.winhighlight = ""
vim.wo.winhl = vim.wo.winhighlight
-- `'wrap'` 			boolean	(default on)
-- 			local to window
-- 	This option changes how text is displayed.  It doesn't change the text
-- 	in the buffer, see `'textwidth'`  for that.
-- 	When on, lines longer than the width of the window will wrap and
-- 	displaying continues on the next line.  When off lines will not wrap
-- 	and only part of long lines will be displayed.  When the cursor is
-- 	moved to a part that is not shown, the screen will scroll
-- 	horizontally.
-- 	The line will be broken in the middle of a word if necessary.  See
-- 	`'linebreak'`  to get the break at a word boundary.
-- 	To make scrolling horizontally a bit more useful, try this: >
-- 		:set sidescroll=5
-- 		:set listchars+=precedes:<,extends:>
-- <	See `'sidescroll'` , `'listchars'`  and |wrap-off|.
-- 	This option can't be set from a |modeline| when the `'diff'`  option is
-- 	on.
vim.wo.wrap = true


---@class vim.bo
vim.bo = {}

-- `'autoindent'`  `'ai'` 	boolean	(default on)
-- 			local to buffer
-- 	Copy indent from current line when starting a new line (typing <CR>
-- 	in Insert mode or when using the "o" or "O" command).  If you do not
-- 	type anything on the new line except <BS> or CTRL-D and then type
-- 	<Esc>, CTRL-O or <CR>, the indent is deleted again.  Moving the cursor
-- 	to another line has the same effect, unless the `'I'`  flag is included
-- 	in `'cpoptions'` .
-- 	When autoindent is on, formatting (with the "gq" command or when you
-- 	reach `'textwidth'`  in Insert mode) uses the indentation of the first
-- 	line.
-- 	When `'smartindent'`  or `'cindent'`  is on the indent is changed in
-- 	a different way.
-- 	{small difference from Vi: After the indent is deleted when typing
-- 	<Esc> or <CR>, the cursor position when moving up or down is after the
-- 	deleted indent; Vi puts the cursor somewhere in the deleted indent}.
vim.bo.autoindent = true
vim.bo.ai = vim.bo.autoindent
-- `'autoread'`  `'ar'` 		boolean	(default on)
-- 			global or local to buffer |global-local|
-- 	When a file has been detected to have been changed outside of Vim and
-- 	it has not been changed inside of Vim, automatically read it again.
-- 	When the file has been deleted this is not done, so you have the text
-- 	from before it was deleted.  When it appears again then it is read.
-- 	|timestamp|
-- 	If this option has a local value, use this command to switch back to
-- 	using the global value: >
-- 		:set autoread<
-- <
vim.bo.autoread = true
vim.bo.ar = vim.bo.autoread
-- `'backupcopy'`  `'bkc'` 	string	(default: "auto")
-- 			global or local to buffer |global-local|
-- 	When writing a file and a backup is made, this option tells how it's
-- 	done.  This is a comma-separated list of words.
-- 
-- 	The main values are:
-- 	"yes"	make a copy of the file and overwrite the original one
-- 	"no"	rename the file and write a new one
-- 	"auto"	one of the previous, what works best
-- 
-- 	Extra values that can be combined with the ones above are:
-- 	"breaksymlink"	always break symlinks when writing
-- 	"breakhardlink"	always break hardlinks when writing
-- 
-- 	Making a copy and overwriting the original file:
-- 	- Takes extra time to copy the file.
-- 	+ When the file has special attributes, is a (hard/symbolic) link or
-- 	  has a resource fork, all this is preserved.
-- 	- When the file is a link the backup will have the name of the link,
-- 	  not of the real file.
-- 
-- 	Renaming the file and writing a new one:
-- 	+ It's fast.
-- 	- Sometimes not all attributes of the file can be copied to the new
-- 	  file.
-- 	- When the file is a link the new file will not be a link.
-- 
-- 	The "auto" value is the middle way: When Vim sees that renaming the
-- 	file is possible without side effects (the attributes can be passed on
-- 	and the file is not a link) that is used.  When problems are expected,
-- 	a copy will be made.
-- 
-- 	The "breaksymlink" and "breakhardlink" values can be used in
-- 	combination with any of "yes", "no" and "auto".  When included, they
-- 	force Vim to always break either symbolic or hard links by doing
-- 	exactly what the "no" option does, renaming the original file to
-- 	become the backup and writing a new file in its place.  This can be
-- 	useful for example in source trees where all the files are symbolic or
-- 	hard links and any changes should stay in the local source tree, not
-- 	be propagated back to the original source.
-- 
-- 	One situation where "no" and "auto" will cause problems: A program
-- 	that opens a file, invokes Vim to edit that file, and then tests if
-- 	the open file was changed (through the file descriptor) will check the
-- 	backup file instead of the newly created file.  "crontab -e" is an
-- 	example.
-- 
-- 	When a copy is made, the original file is truncated and then filled
-- 	with the new text.  This means that protection bits, owner and
-- 	symbolic links of the original file are unmodified.  The backup file,
-- 	however, is a new file, owned by the user who edited the file.  The
-- 	group of the backup is set to the group of the original file.  If this
-- 	fails, the protection bits for the group are made the same as for
-- 	others.
-- 
-- 	When the file is renamed, this is the other way around: The backup has
-- 	the same attributes of the original file, and the newly written file
-- 	is owned by the current user.  When the file was a (hard/symbolic)
-- 	link, the new file will not!  That's why the "auto" value doesn't
-- 	rename when the file is a link.  The owner and group of the newly
-- 	written file will be set to the same ones as the original file, but
-- 	the system may refuse to do this.  In that case the "auto" value will
-- 	again not rename the file.
vim.bo.backupcopy = "auto"
vim.bo.bkc = vim.bo.backupcopy
-- `'binary'`  `'bin'` 		boolean	(default off)
-- 			local to buffer
-- 	This option should be set before editing a binary file.  You can also
-- 	use the |-b| Vim argument.  When this option is switched on a few
-- 	options will be changed (also when it already was on):
-- 		`'textwidth'`   will be set to 0
-- 		`'wrapmargin'`  will be set to 0
-- 		`'modeline'`    will be off
-- 		`'expandtab'`   will be off
-- 	Also, `'fileformat'`  and `'fileformats'`  options will not be used, the
-- 	file is read and written like `'fileformat'`  was "unix" (a single <NL>
-- 	separates lines).
-- 	The `'fileencoding'`  and `'fileencodings'`  options will not be used, the
-- 	file is read without conversion.
-- 	NOTE: When you start editing a(nother) file while the `'bin'`  option is
-- 	on, settings from autocommands may change the settings again (e.g.,
-- 	`'textwidth'` ), causing trouble when editing.  You might want to set
-- 	`'bin'`  again when the file has been loaded.
-- 	The previous values of these options are remembered and restored when
-- 	`'bin'`  is switched from on to off.  Each buffer has its own set of
-- 	saved option values.
-- 	To edit a file with `'binary'`  set you can use the |++bin| argument.
-- 	This avoids you have to do ":set bin", which would have effect for all
-- 	files you edit.
-- 	When writing a file the <EOL> for the last line is only written if
-- 	there was one in the original file (normally Vim appends an <EOL> to
-- 	the last line if there is none; this would make the file longer).  See
-- 	the `'endofline'`  option.
vim.bo.binary = false
vim.bo.bin = vim.bo.binary
-- `'bomb'` 			boolean	(default off)
-- 			local to buffer
-- 	When writing a file and the following conditions are met, a BOM (Byte
-- 	Order Mark) is prepended to the file:
-- 	- this option is on
-- 	- the `'binary'`  option is off
-- 	- `'fileencoding'`  is "utf-8", "ucs-2", "ucs-4" or one of the little/big
-- 	  endian variants.
-- 	Some applications use the BOM to recognize the encoding of the file.
-- 	Often used for UCS-2 files on MS-Windows.  For other applications it
-- 	causes trouble, for example: "cat file1 file2" makes the BOM of file2
-- 	appear halfway through the resulting file.  Gcc doesn't accept a BOM.
-- 	When Vim reads a file and `'fileencodings'`  starts with "ucs-bom", a
-- 	check for the presence of the BOM is done and `'bomb'`  set accordingly.
-- 	Unless `'binary'`  is set, it is removed from the first line, so that you
-- 	don't see it when editing.  When you don't change the options, the BOM
-- 	will be restored when writing the file.
vim.bo.bomb = false
-- `'bufhidden'`  `'bh'` 	string (default: "")
-- 			local to buffer
-- 	This option specifies what happens when a buffer is no longer
-- 	displayed in a window:
-- 	  <empty>	follow the global `'hidden'`  option
-- 	  hide		hide the buffer (don't unload it), even if `'hidden'`  is
-- 			not set
-- 	  unload	unload the buffer, even if `'hidden'`  is set; the
-- 			|:hide| command will also unload the buffer
-- 	  delete	delete the buffer from the buffer list, even if
-- 			`'hidden'`  is set; the |:hide| command will also delete
-- 			the buffer, making it behave like |:bdelete|
-- 	  wipe		wipe the buffer from the buffer list, even if
-- 			`'hidden'`  is set; the |:hide| command will also wipe
-- 			out the buffer, making it behave like |:bwipeout|
-- 
-- 	CAREFUL: when "unload", "delete" or "wipe" is used changes in a buffer
-- 	are lost without a warning.  Also, these values may break autocommands
-- 	that switch between buffers temporarily.
-- 	This option is used together with `'buftype'`  and `'swapfile'`  to specify
-- 	special kinds of buffers.   See |special-buffers|.
vim.bo.bufhidden = ""
vim.bo.bh = vim.bo.bufhidden
-- `'buflisted'`  `'bl'` 	boolean (default: on)
-- 			local to buffer
-- 	When this option is set, the buffer shows up in the buffer list.  If
-- 	it is reset it is not used for ":bnext", "ls", the Buffers menu, etc.
-- 	This option is reset by Vim for buffers that are only used to remember
-- 	a file name or marks.  Vim sets it when starting to edit a buffer.
-- 	But not when moving to a buffer with ":buffer".
vim.bo.buflisted = true
vim.bo.bl = vim.bo.buflisted
-- `'buftype'`  `'bt'` 		string (default: "")
-- 			local to buffer
-- 	The value of this option specifies the type of a buffer:
-- 	  <empty>	normal buffer
-- 	  acwrite	buffer will always be written with |BufWriteCmd|s
-- 	  help		help buffer (do not set this manually)
-- 	  nofile	buffer is not related to a file, will not be written
-- 	  nowrite	buffer will not be written
-- 	  quickfix	list of errors |:cwindow| or locations |:lwindow|
-- 	  terminal	|terminal-emulator| buffer
-- 	  prompt	buffer where only the last line can be edited, meant
-- 			to be used by a plugin, see |prompt-buffer|
-- 
-- 	This option is used together with `'bufhidden'`  and `'swapfile'`  to
-- 	specify special kinds of buffers.   See |special-buffers|.
-- 	Also see |win_gettype()|, which returns the type of the window.
-- 
-- 	Be careful with changing this option, it can have many side effects!
-- 	One such effect is that Vim will not check the timestamp of the file,
-- 	if the file is changed by another program this will not be noticed.
-- 
-- 	A "quickfix" buffer is only used for the error list and the location
-- 	list.  This value is set by the |:cwindow| and |:lwindow| commands and
-- 	you are not supposed to change it.
-- 
-- 	"nofile" and "nowrite" buffers are similar:
-- 	both:		The buffer is not to be written to disk, ":w" doesn't
-- 			work (":w filename" does work though).
-- 	both:		The buffer is never considered to be |`'modified'` |.
-- 			There is no warning when the changes will be lost, for
-- 			example when you quit Vim.
-- 	both:		A swap file is only created when using too much memory
-- 			(when `'swapfile'`  has been reset there is never a swap
-- 			file).
-- 	nofile only:	The buffer name is fixed, it is not handled like a
-- 			file name.  It is not modified in response to a |:cd|
-- 			command.
-- 	both:		When using ":e bufname" and already editing "bufname"
-- 			the buffer is made empty and autocommands are
-- 			triggered as usual for |:edit|.
-- 
-- 	"acwrite" implies that the buffer name is not related to a file, like
-- 	"nofile", but it will be written.  Thus, in contrast to "nofile" and
-- 	"nowrite", ":w" does work and a modified buffer can't be abandoned
-- 	without saving.  For writing there must be matching |BufWriteCmd|,
-- 	|FileWriteCmd| or |FileAppendCmd| autocommands.
vim.bo.buftype = ""
vim.bo.bt = vim.bo.buftype
-- `'channel'` 		number (default: 0)
-- 			local to buffer
-- 	|channel| connected to the buffer, or 0 if no channel is connected.
-- 	In a |:terminal| buffer this is the terminal channel.
-- 	Read-only.
vim.bo.channel = 0
-- `'cindent'`  `'cin'` 		boolean	(default off)
-- 			local to buffer
-- 	Enables automatic C program indenting.  See `'cinkeys'`  to set the keys
-- 	that trigger reindenting in insert mode and `'cinoptions'`  to set your
-- 	preferred indent style.
-- 	If `'indentexpr'`  is not empty, it overrules `'cindent'` .
-- 	If `'lisp'`  is not on and both `'indentexpr'`  and `'equalprg'`  are empty,
-- 	the "=" operator indents using this algorithm rather than calling an
-- 	external program.
-- 	See |C-indenting|.
-- 	When you don't like the way `'cindent'`  works, try the `'smartindent'` 
-- 	option or `'indentexpr'` .
vim.bo.cindent = false
vim.bo.cin = vim.bo.cindent
-- `'cinkeys'`  `'cink'` 	string	(default "0{,0},0),0],:,0#,!^F,o,O,e")
-- 			local to buffer
-- 	A list of keys that, when typed in Insert mode, cause reindenting of
-- 	the current line.  Only used if `'cindent'`  is on and `'indentexpr'`  is
-- 	empty.
-- 	For the format of this option see |cinkeys-format|.
-- 	See |C-indenting|.
vim.bo.cinkeys = "0{,0},0),0],:,0#,!^F,o,O,e"
vim.bo.cink = vim.bo.cinkeys
-- `'cinoptions'`  `'cino'` 	string	(default "")
-- 			local to buffer
-- 	The `'cinoptions'`  affect the way `'cindent'`  reindents lines in a C
-- 	program.  See |cinoptions-values| for the values of this option, and
-- 	|C-indenting| for info on C indenting in general.
vim.bo.cinoptions = ""
vim.bo.cino = vim.bo.cinoptions
-- `'cinscopedecls'`  `'cinsd'` 	string	(default "public,protected,private")
-- 			local to buffer
-- 	Keywords that are interpreted as a C++ scope declaration by |cino-g|.
-- 	Useful e.g. for working with the Qt framework that defines additional
-- 	scope declarations "signals", "public slots" and "private slots": >
-- 		set cinscopedecls+=signals,public\ slots,private\ slots
-- 
-- <
vim.bo.cinscopedecls = "public,protected,private"
vim.bo.cinsd = vim.bo.cinscopedecls
-- `'cinwords'`  `'cinw'` 	string	(default "if,else,while,do,for,switch")
-- 			local to buffer
-- 	These keywords start an extra indent in the next line when
-- 	`'smartindent'`  or `'cindent'`  is set.  For `'cindent'`  this is only done at
-- 	an appropriate place (inside {}).
-- 	Note that `'ignorecase'`  isn't used for `'cinwords'` .  If case doesn't
-- 	matter, include the keyword both the uppercase and lowercase:
-- 	"if,If,IF".
vim.bo.cinwords = "if,else,while,do,for,switch"
vim.bo.cinw = vim.bo.cinwords
-- `'comments'`  `'com'` 	string	(default
-- 				"s1:/,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-")
-- 			local to buffer
-- 	A comma-separated list of strings that can start a comment line.  See
-- 	|format-comments|.  See |option-backslash| about using backslashes to
-- 	insert a space.
vim.bo.comments = "s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-"
vim.bo.com = vim.bo.comments
-- `'commentstring'`  `'cms'` 	string	(default "")
-- 			local to buffer
-- 	A template for a comment.  The "%s" in the value is replaced with the
-- 	comment text.  Currently only used to add markers for folding, see
-- 	|fold-marker|.
vim.bo.commentstring = ""
vim.bo.cms = vim.bo.commentstring
-- `'complete'`  `'cpt'` 	string	(default: ".,w,b,u,t")
-- 			local to buffer
-- 	This option specifies how keyword completion |ins-completion| works
-- 	when CTRL-P or CTRL-N are used.  It is also used for whole-line
-- 	completion |i_CTRL-X_CTRL-L|.  It indicates the type of completion
-- 	and the places to scan.  It is a comma-separated list of flags:
-- 	.	scan the current buffer (`'wrapscan'`  is ignored)
-- 	w	scan buffers from other windows
-- 	b	scan other loaded buffers that are in the buffer list
-- 	u	scan the unloaded buffers that are in the buffer list
-- 	U	scan the buffers that are not in the buffer list
-- 	k	scan the files given with the `'dictionary'`  option
-- 	kspell  use the currently active spell checking |spell|
-- 	k{dict}	scan the file {dict}.  Several "k" flags can be given,
-- 		patterns are valid too.  For example: >
-- 			:set cpt=k/usr/dict/*,k~/spanish
-- <	s	scan the files given with the `'thesaurus'`  option
-- 	s{tsr}	scan the file {tsr}.  Several "s" flags can be given, patterns
-- 		are valid too.
-- 	i	scan current and included files
-- 	d	scan current and included files for defined name or macro
-- 		|i_CTRL-X_CTRL-D|
-- 	]	tag completion
-- 	t	same as "]"
-- 
-- 	Unloaded buffers are not loaded, thus their autocmds |:autocmd| are
-- 	not executed, this may lead to unexpected completions from some files
-- 	(gzipped files for example).  Unloaded buffers are not scanned for
-- 	whole-line completion.
-- 
-- 	As you can see, CTRL-N and CTRL-P can be used to do any `'iskeyword'` -
-- 	based expansion (e.g., dictionary |i_CTRL-X_CTRL-K|, included patterns
-- 	|i_CTRL-X_CTRL-I|, tags |i_CTRL-X_CTRL-]| and normal expansions).
vim.bo.complete = ".,w,b,u,t"
vim.bo.cpt = vim.bo.complete
-- `'completefunc'`  `'cfu'` 	string	(default: empty)
-- 			local to buffer
-- 	This option specifies a function to be used for Insert mode completion
-- 	with CTRL-X CTRL-U. |i_CTRL-X_CTRL-U|
-- 	See |complete-functions| for an explanation of how the function is
-- 	invoked and what it should return.  The value can be the name of a
-- 	function, a |lambda| or a |Funcref|. See |option-value-function| for
-- 	more information.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.completefunc = ""
vim.bo.cfu = vim.bo.completefunc
-- `'copyindent'`  `'ci'` 	boolean	(default off)
-- 			local to buffer
-- 	Copy the structure of the existing lines indent when autoindenting a
-- 	new line.  Normally the new indent is reconstructed by a series of
-- 	tabs followed by spaces as required (unless |`'expandtab'` | is enabled,
-- 	in which case only spaces are used).  Enabling this option makes the
-- 	new line copy whatever characters were used for indenting on the
-- 	existing line.  `'expandtab'`  has no effect on these characters, a Tab
-- 	remains a Tab.  If the new indent is greater than on the existing
-- 	line, the remaining space is filled in the normal manner.
-- 	See `'preserveindent'` .
vim.bo.copyindent = false
vim.bo.ci = vim.bo.copyindent
-- `'define'`  `'def'` 		string	(default "^\sdefine")
-- 			global or local to buffer |global-local|
-- 	Pattern to be used to find a macro definition.  It is a search
-- 	pattern, just like for the "/" command.  This option is used for the
-- 	commands like "[i" and "[d" |include-search|.  The `'isident'`  option is
-- 	used to recognize the defined name after the match:
-- 		{match with `'define'` }{non-ID chars}{defined name}{non-ID char}
-- 	See |option-backslash| about inserting backslashes to include a space
-- 	or backslash.
-- 	The default value is for C programs.  For C++ this value would be
-- 	useful, to include const type declarations: >
-- 		^\(#\s\s[a-z]*\)
-- <	You can also use "\ze" just before the name and continue the pattern
-- 	to check what is following.  E.g. for Javascript, if a function is
-- 	defined with `func_name = function(args)`: >
-- 		^\s=\s*function(
-- <	If the function is defined with `func_name : function() {...`: >
-- 	        ^\s[:]\sfunction\s*(
-- <	When using the ":set" command, you need to double the backslashes!
-- 	To avoid that use `:let` with a single quote string: >
-- 		let &l:define = `'^\s=\s*function('` 
-- <
vim.bo.define = "^\\s*#\\s*define"
vim.bo.def = vim.bo.define
-- `'dictionary'`  `'dict'` 	string	(default "")
-- 			global or local to buffer |global-local|
-- 	List of file names, separated by commas, that are used to lookup words
-- 	for keyword completion commands |i_CTRL-X_CTRL-K|.  Each file should
-- 	contain a list of words.  This can be one word per line, or several
-- 	words per line, separated by non-keyword characters (white space is
-- 	preferred).  Maximum line length is 510 bytes.
-- 
-- 	When this option is empty or an entry "spell" is present, and spell
-- 	checking is enabled, words in the word lists for the currently active
-- 	`'spelllang'`  are used. See |spell|.
-- 
-- 	To include a comma in a file name precede it with a backslash.  Spaces
-- 	after a comma are ignored, otherwise spaces are included in the file
-- 	name.  See |option-backslash| about using backslashes.
-- 	This has nothing to do with the |Dictionary| variable type.
-- 	Where to find a list of words?
-- 	- BSD/macOS include the "/usr/share/dict/words" file.
-- 	- Try "apt install spell" to get the "/usr/share/dict/words" file on
-- 	  apt-managed systems (Debian/Ubuntu).
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	directories from the list.  This avoids problems when a future version
-- 	uses another default.
-- 	Backticks cannot be used in this option for security reasons.
vim.bo.dictionary = ""
vim.bo.dict = vim.bo.dictionary
-- `'endoffile'`  `'eof'` 	boolean	(default off)
-- 			local to buffer
-- 	Indicates that a CTRL-Z character was found at the end of the file
-- 	when reading it.  Normally only happens when `'fileformat'`  is "dos".
-- 	When writing a file and this option is off and the `'binary'`  option
-- 	is on, or `'fixeol'`  option is off, no CTRL-Z will be written at the
-- 	end of the file.
-- 	See |eol-and-eof| for example settings.
vim.bo.endoffile = false
vim.bo.eof = vim.bo.endoffile
-- `'endofline'`  `'eol'` 	boolean	(default on)
-- 			local to buffer
-- 	When writing a file and this option is off and the `'binary'`  option
-- 	is on, or `'fixeol'`  option is off, no <EOL> will be written for the
-- 	last line in the file.  This option is automatically set or reset when
-- 	starting to edit a new file, depending on whether file has an <EOL>
-- 	for the last line in the file.  Normally you don't have to set or
-- 	reset this option.
-- 	When `'binary'`  is off and `'fixeol'`  is on the value is not used when
-- 	writing the file.  When `'binary'`  is on or `'fixeol'`  is off it is used
-- 	to remember the presence of a <EOL> for the last line in the file, so
-- 	that when you write the file the situation from the original file can
-- 	be kept.  But you can change it if you want to.
-- 	See |eol-and-eof| for example settings.
vim.bo.endofline = true
vim.bo.eol = vim.bo.endofline
-- `'equalprg'`  `'ep'` 		string	(default "")
-- 			global or local to buffer |global-local|
-- 	External program to use for "=" command.  When this option is empty
-- 	the internal formatting functions are used; either `'lisp'` , `'cindent'` 
-- 	or `'indentexpr'` .
-- 	Environment variables are expanded |:set_env|.  See |option-backslash|
-- 	about including spaces and backslashes.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.equalprg = ""
vim.bo.ep = vim.bo.equalprg
-- `'errorformat'`  `'efm'` 	string	(default is very long)
-- 			global or local to buffer |global-local|
-- 	Scanf-like description of the format for the lines in the error file
-- 	(see |errorformat|).
vim.bo.errorformat = "%*[^\"]\"%f\"%*\\D%l: %m,\"%f\"%*\\D%l: %m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,\"%f\"\\, line %l%*\\D%c%*[^ ] %m,%D%*\\a[%*\\d]: Entering directory %*[`']%f',%X%*\\a[%*\\d]: Leaving directory %*[`']%f',%D%*\\a: Entering directory %*[`']%f',%X%*\\a: Leaving directory %*[`']%f',%DMaking %*\\a in %f,%f|%l| %m"
vim.bo.efm = vim.bo.errorformat
-- `'expandtab'`  `'et'` 	boolean	(default off)
-- 			local to buffer
-- 	In Insert mode: Use the appropriate number of spaces to insert a
-- 	<Tab>.  Spaces are used in indents with the `'>'`  and `'<'`  commands and
-- 	when `'autoindent'`  is on.  To insert a real tab when `'expandtab'`  is
-- 	on, use CTRL-V<Tab>.  See also |:retab| and |ins-expandtab|.
vim.bo.expandtab = false
vim.bo.et = vim.bo.expandtab
-- `'fileencoding'`  `'fenc'` 	string (default: "")
-- 			local to buffer
-- 	File-content encoding for the current buffer. Conversion is done with
-- 	iconv() or as specified with `'charconvert'` .
-- 
-- 	When `'fileencoding'`  is not UTF-8, conversion will be done when
-- 	writing the file.  For reading see below.
-- 	When `'fileencoding'`  is empty, the file will be saved with UTF-8
-- 	encoding (no conversion when reading or writing a file).
-- 
-- 	WARNING: Conversion to a non-Unicode encoding can cause loss of
-- 	information!
-- 
-- 	See |encoding-names| for the possible values.  Additionally, values may be
-- 	specified that can be handled by the converter, see
-- 	|mbyte-conversion|.
-- 
-- 	When reading a file `'fileencoding'`  will be set from `'fileencodings'` .
-- 	To read a file in a certain encoding it won't work by setting
-- 	`'fileencoding'` , use the |++enc| argument.  One exception: when
-- 	`'fileencodings'`  is empty the value of `'fileencoding'`  is used.
-- 	For a new file the global value of `'fileencoding'`  is used.
-- 
-- 	Prepending "8bit-" and "2byte-" has no meaning here, they are ignored.
-- 	When the option is set, the value is converted to lowercase.  Thus
-- 	you can set it with uppercase values too.  `'_'`  characters are
-- 	replaced with `'-'` .  If a name is recognized from the list at
-- 	|encoding-names|, it is replaced by the standard name.  For example
-- 	"ISO8859-2" becomes "iso-8859-2".
-- 
-- 	When this option is set, after starting to edit a file, the `'modified'` 
-- 	option is set, because the file would be different when written.
-- 
-- 	Keep in mind that changing `'fenc'`  from a modeline happens
-- 	AFTER the text has been read, thus it applies to when the file will be
-- 	written.  If you do set `'fenc'`  in a modeline, you might want to set
-- 	`'nomodified'`  to avoid not being able to ":q".
-- 
-- 	This option cannot be changed when `'modifiable'`  is off.
vim.bo.fileencoding = ""
vim.bo.fenc = vim.bo.fileencoding
-- `'fileformat'`  `'ff'` 	string (Windows default: "dos",
-- 				Unix default: "unix")
-- 			local to buffer
-- 	This gives the <EOL> of the current buffer, which is used for
-- 	reading/writing the buffer from/to a file:
-- 	    dos	    <CR><NL>
-- 	    unix    <NL>
-- 	    mac	    <CR>
-- 	When "dos" is used, CTRL-Z at the end of a file is ignored.
-- 	See |file-formats| and |file-read|.
-- 	For the character encoding of the file see `'fileencoding'` .
-- 	When `'binary'`  is set, the value of `'fileformat'`  is ignored, file I/O
-- 	works like it was set to "unix".
-- 	This option is set automatically when starting to edit a file and
-- 	`'fileformats'`  is not empty and `'binary'`  is off.
-- 	When this option is set, after starting to edit a file, the `'modified'` 
-- 	option is set, because the file would be different when written.
-- 	This option cannot be changed when `'modifiable'`  is off.
vim.bo.fileformat = "unix"
vim.bo.ff = vim.bo.fileformat
-- `'filetype'`  `'ft'` 		string (default: "")
-- 			local to buffer
-- 	When this option is set, the FileType autocommand event is triggered.
-- 	All autocommands that match with the value of this option will be
-- 	executed.  Thus the value of `'filetype'`  is used in place of the file
-- 	name.
-- 	Otherwise this option does not always reflect the current file type.
-- 	This option is normally set when the file type is detected.  To enable
-- 	this use the ":filetype on" command. |:filetype|
-- 	Setting this option to a different value is most useful in a modeline,
-- 	for a file for which the file type is not automatically recognized.
-- 	Example, for in an IDL file: >
-- 		/* vim: set filetype=idl : */
-- <	|FileType| |filetypes|
-- 	When a dot appears in the value then this separates two filetype
-- 	names.  Example: >
-- 		/* vim: set filetype=c.doxygen : */
-- <	This will use the "c" filetype first, then the "doxygen" filetype.
-- 	This works both for filetype plugins and for syntax files.  More than
-- 	one dot may appear.
-- 	This option is not copied to another buffer, independent of the `'s'`  or
-- 	`'S'`  flag in `'cpoptions'` .
-- 	Only normal file name characters can be used, "/\*?[|<>" are illegal.
vim.bo.filetype = ""
vim.bo.ft = vim.bo.filetype
-- `'fixendofline'`  `'fixeol'` 	boolean	(default on)
-- 			local to buffer
-- 	When writing a file and this option is on, <EOL> at the end of file
-- 	will be restored if missing.  Turn this option off if you want to
-- 	preserve the situation from the original file.
-- 	When the `'binary'`  option is set the value of this option doesn't
-- 	matter.
-- 	See the `'endofline'`  option.
-- 	See |eol-and-eof| for example settings.
vim.bo.fixendofline = true
vim.bo.fixeol = vim.bo.fixendofline
-- `'formatexpr'`  `'fex'` 	string (default "")
-- 			local to buffer
-- 	Expression which is evaluated to format a range of lines for the |gq|
-- 	operator or automatic formatting (see `'formatoptions'` ).  When this
-- 	option is empty `'formatprg'`  is used.
-- 
-- 	The |v:lnum|  variable holds the first line to be formatted.
-- 	The |v:count| variable holds the number of lines to be formatted.
-- 	The |v:char|  variable holds the character that is going to be
-- 		      inserted if the expression is being evaluated due to
-- 		      automatic formatting.  This can be empty.  Don't insert
-- 		      it yet!
-- 
-- 	Example: >
-- 		:set formatexpr=mylang#Format()
-- <	This will invoke the mylang#Format() function in the
-- 	autoload/mylang.vim file in `'runtimepath'` . |autoload|
-- 
-- 	The expression is also evaluated when `'textwidth'`  is set and adding
-- 	text beyond that limit.  This happens under the same conditions as
-- 	when internal formatting is used.  Make sure the cursor is kept in the
-- 	same spot relative to the text then!  The |mode()| function will
-- 	return "i" or "R" in this situation.
-- 
-- 	When the expression evaluates to non-zero Vim will fall back to using
-- 	the internal format mechanism.
-- 
-- 	If the expression starts with s: or |<SID>|, then it is replaced with
-- 	the script ID (|local-function|). Example: >
-- 		set formatexpr=s:MyFormatExpr()
-- 		set formatexpr=<SID>SomeFormatExpr()
-- <
-- 	The expression will be evaluated in the |sandbox| when set from a
-- 	modeline, see |sandbox-option|.  That stops the option from working,
-- 	since changing the buffer text is not allowed.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 	NOTE: This option is set to "" when `'compatible'`  is set.
vim.bo.formatexpr = ""
vim.bo.fex = vim.bo.formatexpr
-- `'formatlistpat'`  `'flp'` 	string (default: "^\s*\d\+[\]:.)}\t ]\s*")
-- 			local to buffer
-- 	A pattern that is used to recognize a list header.  This is used for
-- 	the "n" flag in `'formatoptions'` .
-- 	The pattern must match exactly the text that will be the indent for
-- 	the line below it.  You can use |/\ze| to mark the end of the match
-- 	while still checking more characters.  There must be a character
-- 	following the pattern, when it matches the whole line it is handled
-- 	like there is no match.
-- 	The default recognizes a number, followed by an optional punctuation
-- 	character and white space.
vim.bo.formatlistpat = "^\\s*\\d\\+[\\]:.)}\\t ]\\s*"
vim.bo.flp = vim.bo.formatlistpat
-- `'formatoptions'`  `'fo'` 	string (default: "tcqj")
-- 			local to buffer
-- 	This is a sequence of letters which describes how automatic
-- 	formatting is to be done.  See |fo-table|.  Commas can be inserted for
-- 	readability.
-- 	To avoid problems with flags that are added in the future, use the
-- 	"+=" and "-=" feature of ":set" |add-option-flags|.
vim.bo.formatoptions = "tcqj"
vim.bo.fo = vim.bo.formatoptions
-- `'formatprg'`  `'fp'` 	string (default "")
-- 			global or local to buffer |global-local|
-- 	The name of an external program that will be used to format the lines
-- 	selected with the |gq| operator.  The program must take the input on
-- 	stdin and produce the output on stdout.  The Unix program "fmt" is
-- 	such a program.
-- 	If the `'formatexpr'`  option is not empty it will be used instead.
-- 	Otherwise, if `'formatprg'`  option is an empty string, the internal
-- 	format function will be used |C-indenting|.
-- 	Environment variables are expanded |:set_env|.  See |option-backslash|
-- 	about including spaces and backslashes.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.formatprg = ""
vim.bo.fp = vim.bo.formatprg
-- `'grepprg'`  `'gp'` 		string	(default "grep -n ",
-- 				 Unix: "grep -n $* /dev/null")
-- 			global or local to buffer |global-local|
-- 	Program to use for the |:grep| command.  This option may contain `'%'` 
-- 	and `'#'`  characters, which are expanded like when used in a command-
-- 	line.  The placeholder "$*" is allowed to specify where the arguments
-- 	will be included.  Environment variables are expanded |:set_env|.  See
-- 	|option-backslash| about including spaces and backslashes.
-- 	When your "grep" accepts the "-H" argument, use this to make ":grep"
-- 	also work well with a single file: >
-- 		:set grepprg=grep\ -nH
-- <	Special value: When `'grepprg'`  is set to "internal" the |:grep| command
-- 	works like |:vimgrep|, |:lgrep| like |:lvimgrep|, |:grepadd| like
-- 	|:vimgrepadd| and |:lgrepadd| like |:lvimgrepadd|.
-- 	See also the section |:make_makeprg|, since most of the comments there
-- 	apply equally to `'grepprg'` .
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.grepprg = "grep -n $* /dev/null"
vim.bo.gp = vim.bo.grepprg
-- `'iminsert'`  `'imi'` 	number (default 0)
-- 			local to buffer
-- 	Specifies whether :lmap or an Input Method (IM) is to be used in
-- 	Insert mode.  Valid values:
-- 		0	:lmap is off and IM is off
-- 		1	:lmap is ON and IM is off
-- 		2	:lmap is off and IM is ON
-- 	To always reset the option to zero when leaving Insert mode with <Esc>
-- 	this can be used: >
-- 		:inoremap <ESC> <ESC>:set iminsert=0<CR>
-- <	This makes :lmap and IM turn off automatically when leaving Insert
-- 	mode.
-- 	Note that this option changes when using CTRL-^ in Insert mode
-- 	|i_CTRL-^|.
-- 	The value is set to 1 when setting `'keymap'`  to a valid keymap name.
-- 	It is also used for the argument of commands like "r" and "f".
vim.bo.iminsert = 0
vim.bo.imi = vim.bo.iminsert
-- `'imsearch'`  `'ims'` 	number (default -1)
-- 			local to buffer
-- 	Specifies whether :lmap or an Input Method (IM) is to be used when
-- 	entering a search pattern.  Valid values:
-- 		-1	the value of `'iminsert'`  is used, makes it look like
-- 			`'iminsert'`  is also used when typing a search pattern
-- 		0	:lmap is off and IM is off
-- 		1	:lmap is ON and IM is off
-- 		2	:lmap is off and IM is ON
-- 	Note that this option changes when using CTRL-^ in Command-line mode
-- 	|c_CTRL-^|.
-- 	The value is set to 1 when it is not -1 and setting the `'keymap'` 
-- 	option to a valid keymap name.
vim.bo.imsearch = -1
vim.bo.ims = vim.bo.imsearch
-- `'include'`  `'inc'` 		string	(default "^\sinclude")
-- 			global or local to buffer |global-local|
-- 	Pattern to be used to find an include command.  It is a search
-- 	pattern, just like for the "/" command (See |pattern|).  The default
-- 	value is for C programs.  This option is used for the commands "[i",
-- 	"]I", "[d", etc.
-- 	Normally the `'isfname'`  option is used to recognize the file name that
-- 	comes after the matched pattern.  But if "\zs" appears in the pattern
-- 	then the text matched from "\zs" to the end, or until "\ze" if it
-- 	appears, is used as the file name.  Use this to include characters
-- 	that are not in `'isfname'` , such as a space.  You can then use
-- 	`'includeexpr'`  to process the matched text.
-- 	See |option-backslash| about including spaces and backslashes.
vim.bo.include = "^\\s*#\\s*include"
vim.bo.inc = vim.bo.include
-- `'includeexpr'`  `'inex'` 	string	(default "")
-- 			local to buffer
-- 	Expression to be used to transform the string found with the `'include'` 
-- 	option to a file name.  Mostly useful to change "." to "/" for Java: >
-- 		:setlocal includeexpr=substitute(v:fname,`'\\.'` ,`'/'` ,`'g'` )
-- <	The "v:fname" variable will be set to the file name that was detected.
-- 	Note the double backslash: the `:set` command first halves them, then
-- 	one remains in the value, where "\." matches a dot literally.  For
-- 	simple character replacements `tr()` avoids the need for escaping: >
-- 		:setlocal includeexpr=tr(v:fname,`'.'` ,`'/'` )
-- <
-- 	Also used for the |gf| command if an unmodified file name can't be
-- 	found.  Allows doing "gf" on the name after an `'include'`  statement.
-- 	Also used for |<cfile>|.
-- 
-- 	If the expression starts with s: or |<SID>|, then it is replaced with
-- 	the script ID (|local-function|). Example: >
-- 		set includeexpr=s:MyIncludeExpr(v:fname)
-- 		set includeexpr=<SID>SomeIncludeExpr(v:fname)
-- <
-- 	The expression will be evaluated in the |sandbox| when set from a
-- 	modeline, see |sandbox-option|.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	It is not allowed to change text or jump to another window while
-- 	evaluating `'includeexpr'`  |textlock|.
vim.bo.includeexpr = ""
vim.bo.inex = vim.bo.includeexpr
-- `'indentexpr'`  `'inde'` 	string	(default "")
-- 			local to buffer
-- 	Expression which is evaluated to obtain the proper indent for a line.
-- 	It is used when a new line is created, for the |=| operator and
-- 	in Insert mode as specified with the `'indentkeys'`  option.
-- 	When this option is not empty, it overrules the `'cindent'`  and
-- 	`'smartindent'`  indenting.  When `'lisp'`  is set, this option is
-- 	is only used when `'lispoptions'`  contains "expr:1".
-- 	The expression is evaluated with |v:lnum| set to the line number for
-- 	which the indent is to be computed.  The cursor is also in this line
-- 	when the expression is evaluated (but it may be moved around).
-- 	If the expression starts with s: or |<SID>|, then it is replaced with
-- 	the script ID (|local-function|). Example: >
-- 		set indentexpr=s:MyIndentExpr()
-- 		set indentexpr=<SID>SomeIndentExpr()
-- <
-- 	The expression must return the number of spaces worth of indent.  It
-- 	can return "-1" to keep the current indent (this means `'autoindent'`  is
-- 	used for the indent).
-- 	Functions useful for computing the indent are |indent()|, |cindent()|
-- 	and |lispindent()|.
-- 	The evaluation of the expression must not have side effects!  It must
-- 	not change the text, jump to another window, etc.  Afterwards the
-- 	cursor position is always restored, thus the cursor may be moved.
-- 	Normally this option would be set to call a function: >
-- 		:set indentexpr=GetMyIndent()
-- <	Error messages will be suppressed, unless the `'debug'`  option contains
-- 	"msg".
-- 	See |indent-expression|.
-- 
-- 	The expression will be evaluated in the |sandbox| when set from a
-- 	modeline, see |sandbox-option|.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	It is not allowed to change text or jump to another window while
-- 	evaluating `'indentexpr'`  |textlock|.
vim.bo.indentexpr = ""
vim.bo.inde = vim.bo.indentexpr
-- `'indentkeys'`  `'indk'` 	string	(default "0{,0},0),0],:,0#,!^F,o,O,e")
-- 			local to buffer
-- 	A list of keys that, when typed in Insert mode, cause reindenting of
-- 	the current line.  Only happens if `'indentexpr'`  isn't empty.
-- 	The format is identical to `'cinkeys'` , see |indentkeys-format|.
-- 	See |C-indenting| and |indent-expression|.
vim.bo.indentkeys = "0{,0},0),0],:,0#,!^F,o,O,e"
vim.bo.indk = vim.bo.indentkeys
-- `'infercase'`  `'inf'` 	boolean	(default off)
-- 			local to buffer
-- 	When doing keyword completion in insert mode |ins-completion|, and
-- 	`'ignorecase'`  is also on, the case of the match is adjusted depending
-- 	on the typed text.  If the typed text contains a lowercase letter
-- 	where the match has an upper case letter, the completed part is made
-- 	lowercase.  If the typed text has no lowercase letters and the match
-- 	has a lowercase letter where the typed text has an uppercase letter,
-- 	and there is a letter before it, the completed part is made uppercase.
-- 	With `'noinfercase'`  the match is used as-is.
vim.bo.infercase = false
vim.bo.inf = vim.bo.infercase
-- `'iskeyword'`  `'isk'` 	string (default: @,48-57,_,192-255)
-- 			local to buffer
-- 	Keywords are used in searching and recognizing with many commands:
-- 	"w", "*", "[i", etc.  It is also used for "\k" in a |pattern|.  See
-- 	`'isfname'`  for a description of the format of this option.  For `'@'` 
-- 	characters above 255 check the "word" character class (any character
-- 	that is not white space or punctuation).
-- 	For C programs you could use "a-z,A-Z,48-57,_,.,-,>".
-- 	For a help file it is set to all non-blank printable characters except
-- 	`'*'` , `'"'`  and `'|'`  (so that CTRL-] on a command finds the help for that
-- 	command).
-- 	When the `'lisp'`  option is on the `'-'`  character is always included.
-- 	This option also influences syntax highlighting, unless the syntax
-- 	uses |:syn-iskeyword|.
vim.bo.iskeyword = "@,48-57,_,192-255"
vim.bo.isk = vim.bo.iskeyword
-- `'keymap'`  `'kmp'` 		string	(default "")
-- 			local to buffer
-- 	Name of a keyboard mapping.  See |mbyte-keymap|.
-- 	Setting this option to a valid keymap name has the side effect of
-- 	setting `'iminsert'`  to one, so that the keymap becomes effective.
-- 	`'imsearch'`  is also set to one, unless it was -1
-- 	Only normal file name characters can be used, "/\*?[|<>" are illegal.
vim.bo.keymap = ""
vim.bo.kmp = vim.bo.keymap
-- `'keywordprg'`  `'kp'` 	string	(default ":Man", Windows: ":help")
-- 			global or local to buffer |global-local|
-- 	Program to use for the |K| command.  Environment variables are
-- 	expanded |:set_env|.  ":help" may be used to access the Vim internal
-- 	help.  (Note that previously setting the global option to the empty
-- 	value did this, which is now deprecated.)
-- 	When the first character is ":", the command is invoked as a Vim
-- 	Ex command prefixed with [count].
-- 	When "man" or "man -s" is used, Vim will automatically translate
-- 	a [count] for the "K" command to a section number.
-- 	See |option-backslash| about including spaces and backslashes.
-- 	Example: >
-- 		:set keywordprg=man\ -s
-- 		:set keywordprg=:Man
-- <	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.keywordprg = ":Man"
vim.bo.kp = vim.bo.keywordprg
-- `'lisp'` 			boolean	(default off)
-- 			local to buffer
-- 	Lisp mode: When <Enter> is typed in insert mode set the indent for
-- 	the next line to Lisp standards (well, sort of).  Also happens with
-- 	"cc" or "S".  `'autoindent'`  must also be on for this to work.  The `'p'` 
-- 	flag in `'cpoptions'`  changes the method of indenting: Vi compatible or
-- 	better.  Also see `'lispwords'` .
-- 	The `'-'`  character is included in keyword characters.  Redefines the
-- 	"=" operator to use this same indentation algorithm rather than
-- 	calling an external program if `'equalprg'`  is empty.
vim.bo.lisp = false
-- `'lispoptions'`  `'lop'` 	string	(default "")
-- 			local to buffer
-- 	Comma-separated list of items that influence the Lisp indenting when
-- 	enabled with the |`'lisp'` | option.  Currently only one item is
-- 	supported:
-- 		expr:1	use `'indentexpr'`  for Lisp indenting when it is set
-- 		expr:0	do not use `'indentexpr'`  for Lisp indenting (default)
-- 	Note that when using `'indentexpr'`  the `=` operator indents all the
-- 	lines, otherwise the first line is not indented (Vi-compatible).
vim.bo.lispoptions = ""
vim.bo.lop = vim.bo.lispoptions
-- `'lispwords'`  `'lw'` 	string	(default is very long)
-- 			global or local to buffer |global-local|
-- 	Comma-separated list of words that influence the Lisp indenting when
-- 	enabled with the |`'lisp'` | option.
vim.bo.lispwords = "defun,define,defmacro,set!,lambda,if,case,let,flet,let*,letrec,do,do*,define-syntax,let-syntax,letrec-syntax,destructuring-bind,defpackage,defparameter,defstruct,deftype,defvar,do-all-symbols,do-external-symbols,do-symbols,dolist,dotimes,ecase,etypecase,eval-when,labels,macrolet,multiple-value-bind,multiple-value-call,multiple-value-prog1,multiple-value-setq,prog1,progv,typecase,unless,unwind-protect,when,with-input-from-string,with-open-file,with-open-stream,with-output-to-string,with-package-iterator,define-condition,handler-bind,handler-case,restart-bind,restart-case,with-simple-restart,store-value,use-value,muffle-warning,abort,continue,with-slots,with-slots*,with-accessors,with-accessors*,defclass,defmethod,print-unreadable-object"
vim.bo.lw = vim.bo.lispwords
-- `'makeencoding'`  `'menc'` 	string	(default "")
-- 			global or local to buffer |global-local|
-- 	Encoding used for reading the output of external commands.  When empty,
-- 	encoding is not converted.
-- 	This is used for `:make`, `:lmake`, `:grep`, `:lgrep`, `:grepadd`,
-- 	`:lgrepadd`, `:cfile`, `:cgetfile`, `:caddfile`, `:lfile`, `:lgetfile`,
-- 	and `:laddfile`.
-- 
-- 	This would be mostly useful when you use MS-Windows.  If iconv is
-- 	enabled, setting `'makeencoding'`  to "char" has the same effect as
-- 	setting to the system locale encoding.  Example: >
-- 		:set makeencoding=char	" system locale is used
-- <
vim.bo.makeencoding = ""
vim.bo.menc = vim.bo.makeencoding
-- `'makeprg'`  `'mp'` 		string	(default "make")
-- 			global or local to buffer |global-local|
-- 	Program to use for the ":make" command.  See |:make_makeprg|.
-- 	This option may contain `'%'`  and `'#'`  characters (see  |:_%| and |:_#|),
-- 	which are expanded to the current and alternate file name.  Use |::S|
-- 	to escape file names in case they contain special characters.
-- 	Environment variables are expanded |:set_env|.  See |option-backslash|
-- 	about including spaces and backslashes.
-- 	Note that a `'|'`  must be escaped twice: once for ":set" and once for
-- 	the interpretation of a command.  When you use a filter called
-- 	"myfilter" do it like this: >
-- 	    :set makeprg=gmake\ \\\|\ myfilter
-- <	The placeholder "$*" can be given (even multiple times) to specify
-- 	where the arguments will be included, for example: >
-- 	    :set makeprg=latex\ \\\\nonstopmode\ \\\\input\\{$*}
-- <	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.makeprg = "make"
vim.bo.mp = vim.bo.makeprg
-- `'matchpairs'`  `'mps'` 	string	(default "(:),{:},[:]")
-- 			local to buffer
-- 	Characters that form pairs.  The |%| command jumps from one to the
-- 	other.
-- 	Only character pairs are allowed that are different, thus you cannot
-- 	jump between two double quotes.
-- 	The characters must be separated by a colon.
-- 	The pairs must be separated by a comma.  Example for including `'<'`  and
-- 	`'>'`  (for HTML): >
-- 		:set mps+=<:>
-- 
-- <	A more exotic example, to jump between the `'='`  and `';'`  in an
-- 	assignment, useful for languages like C and Java: >
-- 		:au FileType c,cpp,java set mps+==:;
-- 
-- <	For a more advanced way of using "%", see the matchit.vim plugin in
-- 	the $VIMRUNTIME/plugin directory. |add-local-help|
vim.bo.matchpairs = "(:),{:},[:]"
vim.bo.mps = vim.bo.matchpairs
-- `'modeline'`  `'ml'` 		boolean	(default: on (off for root))
-- 			local to buffer
-- 	If `'modeline'`  is on `'modelines'`  gives the number of lines that is
-- 	checked for set commands.  If `'modeline'`  is off or `'modelines'`  is zero
-- 	no lines are checked.  See |modeline|.
vim.bo.modeline = true
vim.bo.ml = vim.bo.modeline
-- `'modifiable'`  `'ma'` 	boolean	(default on)
-- 			local to buffer
-- 	When off the buffer contents cannot be changed.  The `'fileformat'`  and
-- 	`'fileencoding'`  options also can't be changed.
-- 	Can be reset on startup with the |-M| command line argument.
vim.bo.modifiable = true
vim.bo.ma = vim.bo.modifiable
-- `'modified'`  `'mod'` 	boolean	(default off)
-- 			local to buffer
-- 	When on, the buffer is considered to be modified.  This option is set
-- 	when:
-- 	1. A change was made to the text since it was last written.  Using the
-- 	   |undo| command to go back to the original text will reset the
-- 	   option.  But undoing changes that were made before writing the
-- 	   buffer will set the option again, since the text is different from
-- 	   when it was written.
-- 	2. `'fileformat'`  or `'fileencoding'`  is different from its original
-- 	   value.  The original value is set when the buffer is read or
-- 	   written.  A ":set nomodified" command also resets the original
-- 	   values to the current values and the `'modified'`  option will be
-- 	   reset.
-- 	   Similarly for `'eol'`  and `'bomb'` .
-- 	This option is not set when a change is made to the buffer as the
-- 	result of a BufNewFile, BufRead/BufReadPost, BufWritePost,
-- 	FileAppendPost or VimLeave autocommand event.  See |gzip-example| for
-- 	an explanation.
-- 	When `'buftype'`  is "nowrite" or "nofile" this option may be set, but
-- 	will be ignored.
-- 	Note that the text may actually be the same, e.g. `'modified'`  is set
-- 	when using "rA" on an "A".
vim.bo.modified = false
vim.bo.mod = vim.bo.modified
-- `'nrformats'`  `'nf'` 	string	(default "bin,hex")
-- 			local to buffer
-- 	This defines what bases Vim will consider for numbers when using the
-- 	CTRL-A and CTRL-X commands for adding to and subtracting from a number
-- 	respectively; see |CTRL-A| for more info on these commands.
-- 	alpha	If included, single alphabetical characters will be
-- 		incremented or decremented.  This is useful for a list with a
-- 		letter index a), b), etc.
-- 	octal	If included, numbers that start with a zero will be considered
-- 		to be octal.  Example: Using CTRL-A on "007" results in "010".
-- 	hex	If included, numbers starting with "0x" or "0X" will be
-- 		considered to be hexadecimal.  Example: Using CTRL-X on
-- 		"0x100" results in "0x0ff".
-- 	bin	If included, numbers starting with "0b" or "0B" will be
-- 		considered to be binary.  Example: Using CTRL-X on
-- 		"0b1000" subtracts one, resulting in "0b0111".
-- 	unsigned    If included, numbers are recognized as unsigned. Thus a
-- 		leading dash or negative sign won't be considered as part of
-- 		the number.  Examples:
-- 		    Using CTRL-X on "2020" in "9-2020" results in "9-2019"
-- 		    (without "unsigned" it would become "9-2021").
-- 		    Using CTRL-A on "2020" in "9-2020" results in "9-2021"
-- 		    (without "unsigned" it would become "9-2019").
-- 		    Using CTRL-X on "0" or CTRL-A on "18446744073709551615"
-- 		    (2^64 - 1) has no effect, overflow is prevented.
-- 	Numbers which simply begin with a digit in the range 1-9 are always
-- 	considered decimal.  This also happens for numbers that are not
-- 	recognized as octal or hex.
vim.bo.nrformats = "bin,hex"
vim.bo.nf = vim.bo.nrformats
-- `'omnifunc'`  `'ofu'` 	string	(default: empty)
-- 			local to buffer
-- 	This option specifies a function to be used for Insert mode omni
-- 	completion with CTRL-X CTRL-O. |i_CTRL-X_CTRL-O|
-- 	See |complete-functions| for an explanation of how the function is
-- 	invoked and what it should return.  The value can be the name of a
-- 	function, a |lambda| or a |Funcref|. See |option-value-function| for
-- 	more information.
-- 	This option is usually set by a filetype plugin:
-- 	|:filetype-plugin-on|
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.omnifunc = ""
vim.bo.ofu = vim.bo.omnifunc
-- `'path'`  `'pa'` 		string	(default on Unix: ".,/usr/include,,"
-- 				   other systems: ".,,")
-- 			global or local to buffer |global-local|
-- 	This is a list of directories which will be searched when using the
-- 	|gf|, [f, ]f, ^Wf, |:find|, |:sfind|, |:tabfind| and other commands,
-- 	provided that the file being searched for has a relative path (not
-- 	starting with "/", "./" or "../").  The directories in the `'path'` 
-- 	option may be relative or absolute.
-- 	- Use commas to separate directory names: >
-- 		:set path=.,/usr/local/include,/usr/include
-- <	- Spaces can also be used to separate directory names (for backwards
-- 	  compatibility with version 3.0).  To have a space in a directory
-- 	  name, precede it with an extra backslash, and escape the space: >
-- 		:set path=.,/dir/with\\\ space
-- <	- To include a comma in a directory name precede it with an extra
-- 	  backslash: >
-- 		:set path=.,/dir/with\\,comma
-- <	- To search relative to the directory of the current file, use: >
-- 		:set path=.
-- <	- To search in the current directory use an empty string between two
-- 	  commas: >
-- 		:set path=,,
-- <	- A directory name may end in a `':'`  or `'/'` .
-- 	- Environment variables are expanded |:set_env|.
-- 	- When using |netrw.vim| URLs can be used.  For example, adding
-- 	  "https://www.vim.org" will make ":find index.html" work.
-- 	- Search upwards and downwards in a directory tree using "*", "" and
-- 	  ";".  See |file-searching| for info and syntax.
-- 	- Careful with `'\'`  characters, type two to get one in the option: >
-- 		:set path=.,c:\\include
-- <	  Or just use `'/'`  instead: >
-- 		:set path=.,c:/include
-- <	Don't forget "." or files won't even be found in the same directory as
-- 	the file!
-- 	The maximum length is limited.  How much depends on the system, mostly
-- 	it is something like 256 or 1024 characters.
-- 	You can check if all the include files are found, using the value of
-- 	`'path'` , see |:checkpath|.
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	directories from the list.  This avoids problems when a future version
-- 	uses another default.  To remove the current directory use: >
-- 		:set path-=
-- <	To add the current directory use: >
-- 		:set path+=
-- <	To use an environment variable, you probably need to replace the
-- 	separator.  Here is an example to append $INCL, in which directory
-- 	names are separated with a semi-colon: >
-- 		:let &path = &path .. "," .. substitute($INCL, `';'` , `','` , `'g'` )
-- <	Replace the `';'`  with a `':'`  or whatever separator is used.  Note that
-- 	this doesn't work when $INCL contains a comma or white space.
vim.bo.path = ".,/usr/include,,"
vim.bo.pa = vim.bo.path
-- `'preserveindent'`  `'pi'` 	boolean	(default off)
-- 			local to buffer
-- 	When changing the indent of the current line, preserve as much of the
-- 	indent structure as possible.  Normally the indent is replaced by a
-- 	series of tabs followed by spaces as required (unless |`'expandtab'` | is
-- 	enabled, in which case only spaces are used).  Enabling this option
-- 	means the indent will preserve as many existing characters as possible
-- 	for indenting, and only add additional tabs or spaces as required.
-- 	`'expandtab'`  does not apply to the preserved white space, a Tab remains
-- 	a Tab.
-- 	NOTE: When using ">>" multiple times the resulting indent is a mix of
-- 	tabs and spaces.  You might not like this.
-- 	Also see `'copyindent'` .
-- 	Use |:retab| to clean up white space.
vim.bo.preserveindent = false
vim.bo.pi = vim.bo.preserveindent
-- `'quoteescape'`  `'qe'` 	string	(default "\")
-- 			local to buffer
-- 	The characters that are used to escape quotes in a string.  Used for
-- 	objects like a', a" and a` |a'|.
-- 	When one of the characters in this option is found inside a string,
-- 	the following character will be skipped.  The default value makes the
-- 	text "foo\"bar\\" considered to be one string.
vim.bo.quoteescape = "\\"
vim.bo.qe = vim.bo.quoteescape
-- `'readonly'`  `'ro'` 		boolean	(default off)
-- 			local to buffer
-- 	If on, writes fail unless you use a `'!'` .  Protects you from
-- 	accidentally overwriting a file.  Default on when Vim is started
-- 	in read-only mode ("vim -R") or when the executable is called "view".
-- 	When using ":w!" the `'readonly'`  option is reset for the current
-- 	buffer, unless the `'Z'`  flag is in `'cpoptions'` .
-- 	When using the ":view" command the `'readonly'`  option is set for the
-- 	newly edited buffer.
-- 	See `'modifiable'`  for disallowing changes to the buffer.
vim.bo.readonly = false
vim.bo.ro = vim.bo.readonly
-- `'scrollback'`  `'scbk'` 	number	(default: 10000)
-- 			local to buffer
-- 	Maximum number of lines kept beyond the visible screen. Lines at the
-- 	top are deleted if new lines exceed this limit.
-- 	Minimum is 1, maximum is 100000.
-- 	Only in |terminal| buffers.
vim.bo.scrollback = -1
vim.bo.scbk = vim.bo.scrollback
-- `'shiftwidth'`  `'sw'` 	number	(default 8)
-- 			local to buffer
-- 	Number of spaces to use for each step of (auto)indent.  Used for
-- 	|`'cindent'` |, |>>|, |<<|, etc.
-- 	When zero the `'ts'`  value will be used.  Use the |shiftwidth()|
-- 	function to get the effective shiftwidth value.
vim.bo.shiftwidth = 8
vim.bo.sw = vim.bo.shiftwidth
-- `'smartindent'`  `'si'` 	boolean	(default off)
-- 			local to buffer
-- 	Do smart autoindenting when starting a new line.  Works for C-like
-- 	programs, but can also be used for other languages.  `'cindent'`  does
-- 	something like this, works better in most cases, but is more strict,
-- 	see |C-indenting|.  When `'cindent'`  is on or `'indentexpr'`  is set,
-- 	setting `'si'`  has no effect.  `'indentexpr'`  is a more advanced
-- 	alternative.
-- 	Normally `'autoindent'`  should also be on when using `'smartindent'` .
-- 	An indent is automatically inserted:
-- 	- After a line ending in "{".
-- 	- After a line starting with a keyword from `'cinwords'` .
-- 	- Before a line starting with "}" (only with the "O" command).
-- 	When typing `'}'`  as the first character in a new line, that line is
-- 	given the same indent as the matching "{".
-- 	When typing `'#'`  as the first character in a new line, the indent for
-- 	that line is removed, the `'#'`  is put in the first column.  The indent
-- 	is restored for the next line.  If you don't want this, use this
-- 	mapping: ":inoremap # X^H#", where ^H is entered with CTRL-V CTRL-H.
-- 	When using the ">>" command, lines starting with `'#'`  are not shifted
-- 	right.
vim.bo.smartindent = false
vim.bo.si = vim.bo.smartindent
-- `'softtabstop'`  `'sts'` 	number	(default 0)
-- 			local to buffer
-- 	Number of spaces that a <Tab> counts for while performing editing
-- 	operations, like inserting a <Tab> or using <BS>.  It "feels" like
-- 	<Tab>s are being inserted, while in fact a mix of spaces and <Tab>s is
-- 	used.  This is useful to keep the `'ts'`  setting at its standard value
-- 	of 8, while being able to edit like it is set to `'sts'` .  However,
-- 	commands like "x" still work on the actual characters.
-- 	When `'sts'`  is zero, this feature is off.
-- 	When `'sts'`  is negative, the value of `'shiftwidth'`  is used.
-- 	See also |ins-expandtab|.  When `'expandtab'`  is not set, the number of
-- 	spaces is minimized by using <Tab>s.
-- 	The `'L'`  flag in `'cpoptions'`  changes how tabs are used when `'list'`  is
-- 	set.
-- 
-- 	The value of `'softtabstop'`  will be ignored if |`'varsofttabstop'` | is set
-- 	to anything other than an empty string.
vim.bo.softtabstop = 0
vim.bo.sts = vim.bo.softtabstop
-- `'spellcapcheck'`  `'spc'` 	string	(default "[.?!]\_[\])'" \t]\+")
-- 			local to buffer
-- 	Pattern to locate the end of a sentence.  The following word will be
-- 	checked to start with a capital letter.  If not then it is highlighted
-- 	with SpellCap |hl-SpellCap| (unless the word is also badly spelled).
-- 	When this check is not wanted make this option empty.
-- 	Only used when `'spell'`  is set.
-- 	Be careful with special characters, see |option-backslash| about
-- 	including spaces and backslashes.
-- 	To set this option automatically depending on the language, see
-- 	|set-spc-auto|.
vim.bo.spellcapcheck = "[.?!]\\_[\\])'\"\t ]\\+"
vim.bo.spc = vim.bo.spellcapcheck
-- `'spellfile'`  `'spf'` 	string	(default empty)
-- 			local to buffer
-- 	Name of the word list file where words are added for the |zg| and |zw|
-- 	commands.  It must end in ".{encoding}.add".  You need to include the
-- 	path, otherwise the file is placed in the current directory.
-- 	The path may include characters from `'isfname'` , space, comma and `'@'` .
-- 
-- 	It may also be a comma-separated list of names.  A count before the
-- 	|zg| and |zw| commands can be used to access each.  This allows using
-- 	a personal word list file and a project word list file.
-- 	When a word is added while this option is empty Vim will set it for
-- 	you: Using the first directory in `'runtimepath'`  that is writable.  If
-- 	there is no "spell" directory yet it will be created.  For the file
-- 	name the first language name that appears in `'spelllang'`  is used,
-- 	ignoring the region.
-- 	The resulting ".spl" file will be used for spell checking, it does not
-- 	have to appear in `'spelllang'` .
-- 	Normally one file is used for all regions, but you can add the region
-- 	name if you want to.  However, it will then only be used when
-- 	`'spellfile'`  is set to it, for entries in `'spelllang'`  only files
-- 	without region name will be found.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.spellfile = ""
vim.bo.spf = vim.bo.spellfile
-- `'spelllang'`  `'spl'` 	string	(default "en")
-- 			local to buffer
-- 	A comma-separated list of word list names.  When the `'spell'`  option is
-- 	on spellchecking will be done for these languages.  Example: >
-- 		set spelllang=en_us,nl,medical
-- <	This means US English, Dutch and medical words are recognized.  Words
-- 	that are not recognized will be highlighted.
-- 	The word list name must consist of alphanumeric characters, a dash or
-- 	an underscore.  It should not include a comma or dot.  Using a dash is
-- 	recommended to separate the two letter language name from a
-- 	specification.  Thus "en-rare" is used for rare English words.
-- 	A region name must come last and have the form "_xx", where "xx" is
-- 	the two-letter, lower case region name.  You can use more than one
-- 	region by listing them: "en_us,en_ca" supports both US and Canadian
-- 	English, but not words specific for Australia, New Zealand or Great
-- 	Britain. (Note: currently en_au and en_nz dictionaries are older than
-- 	en_ca, en_gb and en_us).
-- 	If the name "cjk" is included East Asian characters are excluded from
-- 	spell checking.  This is useful when editing text that also has Asian
-- 	words.
-- 	Note that the "medical" dictionary does not exist, it is just an
-- 	example of a longer name.
-- 
-- 	As a special case the name of a .spl file can be given as-is.  The
-- 	first "_xx" in the name is removed and used as the region name
-- 	(_xx is an underscore, two letters and followed by a non-letter).
-- 	This is mainly for testing purposes.  You must make sure the correct
-- 	encoding is used, Vim doesn't check it.
-- 	How the related spell files are found is explained here: |spell-load|.
-- 
-- 	If the |spellfile.vim| plugin is active and you use a language name
-- 	for which Vim cannot find the .spl file in `'runtimepath'`  the plugin
-- 	will ask you if you want to download the file.
-- 
-- 	After this option has been set successfully, Vim will source the files
-- 	"spell/LANG.vim" in `'runtimepath'` .  "LANG" is the value of `'spelllang'` 
-- 	up to the first character that is not an ASCII letter or number and
-- 	not a dash.  Also see |set-spc-auto|.
vim.bo.spelllang = "en"
vim.bo.spl = vim.bo.spelllang
-- `'spelloptions'`  `'spo'` 	string	(default "")
-- 			local to buffer
-- 	A comma-separated list of options for spell checking:
-- 	camel		When a word is CamelCased, assume "Cased" is a
-- 			separate word: every upper-case character in a word
-- 			that comes after a lower case character indicates the
-- 			start of a new word.
-- 	noplainbuffer	Only spellcheck a buffer when `'syntax'`  is enabled,
-- 			or when extmarks are set within the buffer. Only
-- 			designated regions of the buffer are spellchecked in
-- 			this case.
vim.bo.spelloptions = ""
vim.bo.spo = vim.bo.spelloptions
-- `'suffixesadd'`  `'sua'` 	string	(default "")
-- 			local to buffer
-- 	Comma-separated list of suffixes, which are used when searching for a
-- 	file for the "gf", "[I", etc. commands.  Example: >
-- 		:set suffixesadd=.java
-- <
vim.bo.suffixesadd = ""
vim.bo.sua = vim.bo.suffixesadd
-- `'swapfile'`  `'swf'` 	boolean (default on)
-- 			local to buffer
-- 	Use a swapfile for the buffer.  This option can be reset when a
-- 	swapfile is not wanted for a specific buffer.  For example, with
-- 	confidential information that even root must not be able to access.
-- 	Careful: All text will be in memory:
-- 		- Don't use this for big files.
-- 		- Recovery will be impossible!
-- 	A swapfile will only be present when |`'updatecount'` | is non-zero and
-- 	`'swapfile'`  is set.
-- 	When `'swapfile'`  is reset, the swap file for the current buffer is
-- 	immediately deleted.  When `'swapfile'`  is set, and `'updatecount'`  is
-- 	non-zero, a swap file is immediately created.
-- 	Also see |swap-file|.
-- 	If you want to open a new buffer without creating a swap file for it,
-- 	use the |:noswapfile| modifier.
-- 	See `'directory'`  for where the swap file is created.
-- 
-- 	This option is used together with `'bufhidden'`  and `'buftype'`  to
-- 	specify special kinds of buffers.   See |special-buffers|.
vim.bo.swapfile = true
vim.bo.swf = vim.bo.swapfile
-- `'synmaxcol'`  `'smc'` 	number	(default 3000)
-- 			local to buffer
-- 	Maximum column in which to search for syntax items.  In long lines the
-- 	text after this column is not highlighted and following lines may not
-- 	be highlighted correctly, because the syntax state is cleared.
-- 	This helps to avoid very slow redrawing for an XML file that is one
-- 	long line.
-- 	Set to zero to remove the limit.
vim.bo.synmaxcol = 3000
vim.bo.smc = vim.bo.synmaxcol
-- `'syntax'`  `'syn'` 		string	(default empty)
-- 			local to buffer
-- 	When this option is set, the syntax with this name is loaded, unless
-- 	syntax highlighting has been switched off with ":syntax off".
-- 	Otherwise this option does not always reflect the current syntax (the
-- 	b:current_syntax variable does).
-- 	This option is most useful in a modeline, for a file which syntax is
-- 	not automatically recognized.  Example, in an IDL file: >
-- 		/* vim: set syntax=idl : */
-- <	When a dot appears in the value then this separates two filetype
-- 	names.  Example: >
-- 		/* vim: set syntax=c.doxygen : */
-- <	This will use the "c" syntax first, then the "doxygen" syntax.
-- 	Note that the second one must be prepared to be loaded as an addition,
-- 	otherwise it will be skipped.  More than one dot may appear.
-- 	To switch off syntax highlighting for the current file, use: >
-- 		:set syntax=OFF
-- <	To switch syntax highlighting on according to the current value of the
-- 	`'filetype'`  option: >
-- 		:set syntax=ON
-- <	What actually happens when setting the `'syntax'`  option is that the
-- 	Syntax autocommand event is triggered with the value as argument.
-- 	This option is not copied to another buffer, independent of the `'s'`  or
-- 	`'S'`  flag in `'cpoptions'` .
-- 	Only normal file name characters can be used, "/\*?[|<>" are illegal.
vim.bo.syntax = ""
vim.bo.syn = vim.bo.syntax
-- `'tabstop'`  `'ts'` 		number	(default 8)
-- 			local to buffer
-- 	Number of spaces that a <Tab> in the file counts for.  Also see
-- 	the |:retab| command, and the `'softtabstop'`  option.
-- 
-- 	Note: Setting `'tabstop'`  to any other value than 8 can make your file
-- 	appear wrong in many places.
-- 	The value must be more than 0 and less than 10000.
-- 
-- 	There are four main ways to use tabs in Vim:
-- 	1. Always keep `'tabstop'`  at 8, set `'softtabstop'`  and `'shiftwidth'`  to 4
-- 	   (or 3 or whatever you prefer) and use `'noexpandtab'` .  Then Vim
-- 	   will use a mix of tabs and spaces, but typing <Tab> and <BS> will
-- 	   behave like a tab appears every 4 (or 3) characters.
-- 	2. Set `'tabstop'`  and `'shiftwidth'`  to whatever you prefer and use
-- 	   `'expandtab'` .  This way you will always insert spaces.  The
-- 	   formatting will never be messed up when `'tabstop'`  is changed.
-- 	3. Set `'tabstop'`  and `'shiftwidth'`  to whatever you prefer and use a
-- 	   |modeline| to set these values when editing the file again.  Only
-- 	   works when using Vim to edit the file.
-- 	4. Always set `'tabstop'`  and `'shiftwidth'`  to the same value, and
-- 	   `'noexpandtab'` .  This should then work (for initial indents only)
-- 	   for any tabstop setting that people use.  It might be nice to have
-- 	   tabs after the first non-blank inserted as spaces if you do this
-- 	   though.  Otherwise aligned comments will be wrong when `'tabstop'`  is
-- 	   changed.
-- 
-- 	The value of `'tabstop'`  will be ignored if |`'vartabstop'` | is set to
-- 	anything other than an empty string.
vim.bo.tabstop = 8
vim.bo.ts = vim.bo.tabstop
-- `'tagcase'`  `'tc'` 		string	(default "followic")
-- 			global or local to buffer |global-local|
-- 	This option specifies how case is handled when searching the tags
-- 	file:
-- 	   followic	Follow the `'ignorecase'`  option
-- 	   followscs    Follow the `'smartcase'`  and `'ignorecase'`  options
-- 	   ignore	Ignore case
-- 	   match	Match case
-- 	   smart	Ignore case unless an upper case letter is used
vim.bo.tagcase = "followic"
vim.bo.tc = vim.bo.tagcase
-- `'tagfunc'`  `'tfu'` 		string	(default: empty)
-- 			local to buffer
-- 	This option specifies a function to be used to perform tag searches.
-- 	The function gets the tag pattern and should return a List of matching
-- 	tags.  See |tag-function| for an explanation of how to write the
-- 	function and an example.  The value can be the name of a function, a
-- 	|lambda| or a |Funcref|. See |option-value-function| for more
-- 	information.
vim.bo.tagfunc = ""
vim.bo.tfu = vim.bo.tagfunc
-- `'tags'`  `'tag'` 		string	(default "./tags;,tags")
-- 			global or local to buffer |global-local|
-- 	Filenames for the tag command, separated by spaces or commas.  To
-- 	include a space or comma in a file name, precede it with a backslash
-- 	(see |option-backslash| about including spaces and backslashes).
-- 	When a file name starts with "./", the `'.'`  is replaced with the path
-- 	of the current file.  But only when the `'d'`  flag is not included in
-- 	`'cpoptions'` .  Environment variables are expanded |:set_env|.  Also see
-- 	|tags-option|.
-- 	"*", "" and other wildcards can be used to search for tags files in
-- 	a directory tree.  See |file-searching|.  E.g., "/lib//tags" will
-- 	find all files named "tags" below "/lib".  The filename itself cannot
-- 	contain wildcards, it is used as-is.  E.g., "/lib//tags?" will find
-- 	files called "tags?".
-- 	The |tagfiles()| function can be used to get a list of the file names
-- 	actually used.
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	file names from the list.  This avoids problems when a future version
-- 	uses another default.
vim.bo.tags = "./tags;,tags"
vim.bo.tag = vim.bo.tags
-- `'textwidth'`  `'tw'` 	number	(default 0)
-- 			local to buffer
-- 	Maximum width of text that is being inserted.  A longer line will be
-- 	broken after white space to get this width.  A zero value disables
-- 	this.
-- 	When `'textwidth'`  is zero, `'wrapmargin'`  may be used.  See also
-- 	`'formatoptions'`  and |ins-textwidth|.
-- 	When `'formatexpr'`  is set it will be used to break the line.
vim.bo.textwidth = 0
vim.bo.tw = vim.bo.textwidth
-- `'thesaurus'`  `'tsr'` 	string	(default "")
-- 			global or local to buffer |global-local|
-- 	List of file names, separated by commas, that are used to lookup words
-- 	for thesaurus completion commands |i_CTRL-X_CTRL-T|.  See
-- 	|compl-thesaurus|.
-- 
-- 	This option is not used if `'thesaurusfunc'`  is set, either for the
-- 	buffer or globally.
-- 
-- 	To include a comma in a file name precede it with a backslash.  Spaces
-- 	after a comma are ignored, otherwise spaces are included in the file
-- 	name.  See |option-backslash| about using backslashes.  The use of
-- 	|:set+=| and |:set-=| is preferred when adding or removing directories
-- 	from the list.  This avoids problems when a future version uses
-- 	another default.  Backticks cannot be used in this option for security
-- 	reasons.
vim.bo.thesaurus = ""
vim.bo.tsr = vim.bo.thesaurus
-- `'thesaurusfunc'`  `'tsrfu'` 	string	(default: empty)
-- 			global or local to buffer |global-local|
-- 	This option specifies a function to be used for thesaurus completion
-- 	with CTRL-X CTRL-T. |i_CTRL-X_CTRL-T| See |compl-thesaurusfunc|.
-- 	The value can be the name of a function, a |lambda| or a |Funcref|.
-- 	See |option-value-function| for more information.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.bo.thesaurusfunc = ""
vim.bo.tsrfu = vim.bo.thesaurusfunc
-- `'undofile'`  `'udf'` 	boolean	(default off)
-- 			local to buffer
-- 	When on, Vim automatically saves undo history to an undo file when
-- 	writing a buffer to a file, and restores undo history from the same
-- 	file on buffer read.
-- 	The directory where the undo file is stored is specified by `'undodir'` .
-- 	For more information about this feature see |undo-persistence|.
-- 	The undo file is not read when `'undoreload'`  causes the buffer from
-- 	before a reload to be saved for undo.
-- 	When `'undofile'`  is turned off the undo file is NOT deleted.
vim.bo.undofile = false
vim.bo.udf = vim.bo.undofile
-- `'undolevels'`  `'ul'` 	number	(default 1000)
-- 			global or local to buffer |global-local|
-- 	Maximum number of changes that can be undone.  Since undo information
-- 	is kept in memory, higher numbers will cause more memory to be used.
-- 	Nevertheless, a single change can already use a large amount of memory.
-- 	Set to 0 for Vi compatibility: One level of undo and "u" undoes
-- 	itself: >
-- 		set ul=0
-- <	But you can also get Vi compatibility by including the `'u'`  flag in
-- 	`'cpoptions'` , and still be able to use CTRL-R to repeat undo.
-- 	Also see |undo-two-ways|.
-- 	Set to -1 for no undo at all.  You might want to do this only for the
-- 	current buffer: >
-- 		setlocal ul=-1
-- <	This helps when you run out of memory for a single change.
-- 
-- 	The local value is set to -123456 when the global value is to be used.
-- 
-- 	Also see |clear-undo|.
vim.bo.undolevels = 1000
vim.bo.ul = vim.bo.undolevels
-- `'varsofttabstop'`  `'vsts'` 	string	(default "")
-- 			local to buffer
-- 	A list of the number of spaces that a <Tab> counts for while editing,
-- 	such as inserting a <Tab> or using <BS>.  It "feels" like variable-
-- 	width <Tab>s are being inserted, while in fact a mixture of spaces
-- 	and <Tab>s is used.  Tab widths are separated with commas, with the
-- 	final value applying to all subsequent tabs.
-- 
-- 	For example, when editing assembly language files where statements
-- 	start in the 9th column and comments in the 41st, it may be useful
-- 	to use the following: >
-- 		:set varsofttabstop=8,32,8
-- <	This will set soft tabstops with 8 and 8 + 32 spaces, and 8 more
-- 	for every column thereafter.
-- 
-- 	Note that the value of |`'softtabstop'` | will be ignored while
-- 	`'varsofttabstop'`  is set.
vim.bo.varsofttabstop = ""
vim.bo.vsts = vim.bo.varsofttabstop
-- `'vartabstop'`  `'vts'` 	string	(default "")
-- 			local to buffer
-- 	A list of the number of spaces that a <Tab> in the file counts for,
-- 	separated by commas.  Each value corresponds to one tab, with the
-- 	final value applying to all subsequent tabs. For example: >
-- 		:set vartabstop=4,20,10,8
-- <	This will make the first tab 4 spaces wide, the second 20 spaces,
-- 	the third 10 spaces, and all following tabs 8 spaces.
-- 
-- 	Note that the value of |`'tabstop'` | will be ignored while `'vartabstop'` 
-- 	is set.
vim.bo.vartabstop = ""
vim.bo.vts = vim.bo.vartabstop
-- `'wrapmargin'`  `'wm'` 	number	(default 0)
-- 			local to buffer
-- 	Number of characters from the right window border where wrapping
-- 	starts.  When typing text beyond this limit, an <EOL> will be inserted
-- 	and inserting continues on the next line.
-- 	Options that add a margin, such as `'number'`  and `'foldcolumn'` , cause
-- 	the text width to be further reduced.
-- 	When `'textwidth'`  is non-zero, this option is not used.
-- 	See also `'formatoptions'`  and |ins-textwidth|.
vim.bo.wrapmargin = 0
vim.bo.wm = vim.bo.wrapmargin


--- @class vim.opt.aleph: vim.Option,number
--- @operator add: vim.opt.aleph
--- @operator sub: vim.opt.aleph
--- @operator pow: vim.opt.aleph
vim.opt.aleph = 224
vim.opt.al = vim.opt.aleph
--- @return number
function vim.opt.aleph:get()end

-- `'allowrevins'`  `'ari'` 	boolean	(default off)
-- 			global
-- 	Allow CTRL-_ in Insert and Command-line mode.  This is default off, to
-- 	avoid that users that accidentally type CTRL-_ instead of SHIFT-_ get
-- 	into reverse Insert mode, and don't know how to get out.  See
-- 	`'revins'` .
--- @class vim.opt.allowrevins: vim.Option,boolean
--- @operator add: vim.opt.allowrevins
--- @operator sub: vim.opt.allowrevins
--- @operator pow: vim.opt.allowrevins
vim.opt.allowrevins = false
vim.opt.ari = vim.opt.allowrevins
--- @return boolean
function vim.opt.allowrevins:get()end

-- `'ambiwidth'`  `'ambw'` 	string (default: "single")
-- 			global
-- 	Tells Vim what to do with characters with East Asian Width Class
-- 	Ambiguous (such as Euro, Registered Sign, Copyright Sign, Greek
-- 	letters, Cyrillic letters).
-- 
-- 	There are currently two possible values:
-- 	"single":	Use the same width as characters in US-ASCII.  This is
-- 			expected by most users.
-- 	"double":	Use twice the width of ASCII characters.
-- 
-- 	The value "double" cannot be used if `'listchars'`  or `'fillchars'` 
-- 	contains a character that would be double width.  These errors may
-- 	also be given when calling setcellwidths().
-- 
-- 	The values are overruled for characters specified with
-- 	|setcellwidths()|.
-- 
-- 	There are a number of CJK fonts for which the width of glyphs for
-- 	those characters are solely based on how many octets they take in
-- 	legacy/traditional CJK encodings.  In those encodings, Euro,
-- 	Registered sign, Greek/Cyrillic letters are represented by two octets,
-- 	therefore those fonts have "wide" glyphs for them.  This is also
-- 	true of some line drawing characters used to make tables in text
-- 	file.  Therefore, when a CJK font is used for GUI Vim or
-- 	Vim is running inside a terminal (emulators) that uses a CJK font
-- 	(or Vim is run inside an xterm invoked with "-cjkwidth" option.),
-- 	this option should be set to "double" to match the width perceived
-- 	by Vim with the width of glyphs in the font.  Perhaps it also has
-- 	to be set to "double" under CJK MS-Windows when the system locale is
-- 	set to one of CJK locales.  See Unicode Standard Annex #11
-- 	(https://www.unicode.org/reports/tr11).
--- @class vim.opt.ambiwidth: vim.Option,string
--- @operator add: vim.opt.ambiwidth
--- @operator sub: vim.opt.ambiwidth
--- @operator pow: vim.opt.ambiwidth
vim.opt.ambiwidth = "single"
vim.opt.ambw = vim.opt.ambiwidth
--- @return string
function vim.opt.ambiwidth:get()end

-- `'arabic'`  `'arab'` 		boolean (default off)
-- 			local to window
-- 	This option can be set to start editing Arabic text.
-- 	Setting this option will:
-- 	- Set the `'rightleft'`  option, unless `'termbidi'`  is set.
-- 	- Set the `'arabicshape'`  option, unless `'termbidi'`  is set.
-- 	- Set the `'keymap'`  option to "arabic"; in Insert mode CTRL-^ toggles
-- 	  between typing English and Arabic key mapping.
-- 	- Set the `'delcombine'`  option
-- 
-- 	Resetting this option will:
-- 	- Reset the `'rightleft'`  option.
-- 	- Disable the use of `'keymap'`  (without changing its value).
-- 	Note that `'arabicshape'`  and `'delcombine'`  are not reset (it is a global
-- 	option).
-- 	Also see |arabic.txt|.
--- @class vim.opt.arabic: vim.Option,boolean
--- @operator add: vim.opt.arabic
--- @operator sub: vim.opt.arabic
--- @operator pow: vim.opt.arabic
vim.opt.arabic = false
vim.opt.arab = vim.opt.arabic
--- @return boolean
function vim.opt.arabic:get()end

-- `'arabicshape'`  `'arshape'` 	boolean (default on)
-- 			global
-- 	When on and `'termbidi'`  is off, the required visual character
-- 	corrections that need to take place for displaying the Arabic language
-- 	take effect.  Shaping, in essence, gets enabled; the term is a broad
-- 	one which encompasses:
-- 	  a) the changing/morphing of characters based on their location
-- 	     within a word (initial, medial, final and stand-alone).
-- 	  b) the enabling of the ability to compose characters
-- 	  c) the enabling of the required combining of some characters
-- 	When disabled the display shows each character's true stand-alone
-- 	form.
-- 	Arabic is a complex language which requires other settings, for
-- 	further details see |arabic.txt|.
--- @class vim.opt.arabicshape: vim.Option,boolean
--- @operator add: vim.opt.arabicshape
--- @operator sub: vim.opt.arabicshape
--- @operator pow: vim.opt.arabicshape
vim.opt.arabicshape = true
vim.opt.arshape = vim.opt.arabicshape
--- @return boolean
function vim.opt.arabicshape:get()end

-- `'autochdir'`  `'acd'` 	boolean (default off)
-- 			global
-- 	When on, Vim will change the current working directory whenever you
-- 	open a file, switch buffers, delete a buffer or open/close a window.
-- 	It will change to the directory containing the file which was opened
-- 	or selected.  When a buffer has no name it also has no directory, thus
-- 	the current directory won't change when navigating to it.
-- 	Note: When this option is on some plugins may not work.
--- @class vim.opt.autochdir: vim.Option,boolean
--- @operator add: vim.opt.autochdir
--- @operator sub: vim.opt.autochdir
--- @operator pow: vim.opt.autochdir
vim.opt.autochdir = false
vim.opt.acd = vim.opt.autochdir
--- @return boolean
function vim.opt.autochdir:get()end

-- `'autoindent'`  `'ai'` 	boolean	(default on)
-- 			local to buffer
-- 	Copy indent from current line when starting a new line (typing <CR>
-- 	in Insert mode or when using the "o" or "O" command).  If you do not
-- 	type anything on the new line except <BS> or CTRL-D and then type
-- 	<Esc>, CTRL-O or <CR>, the indent is deleted again.  Moving the cursor
-- 	to another line has the same effect, unless the `'I'`  flag is included
-- 	in `'cpoptions'` .
-- 	When autoindent is on, formatting (with the "gq" command or when you
-- 	reach `'textwidth'`  in Insert mode) uses the indentation of the first
-- 	line.
-- 	When `'smartindent'`  or `'cindent'`  is on the indent is changed in
-- 	a different way.
-- 	{small difference from Vi: After the indent is deleted when typing
-- 	<Esc> or <CR>, the cursor position when moving up or down is after the
-- 	deleted indent; Vi puts the cursor somewhere in the deleted indent}.
--- @class vim.opt.autoindent: vim.Option,boolean
--- @operator add: vim.opt.autoindent
--- @operator sub: vim.opt.autoindent
--- @operator pow: vim.opt.autoindent
vim.opt.autoindent = true
vim.opt.ai = vim.opt.autoindent
--- @return boolean
function vim.opt.autoindent:get()end

-- `'autoread'`  `'ar'` 		boolean	(default on)
-- 			global or local to buffer |global-local|
-- 	When a file has been detected to have been changed outside of Vim and
-- 	it has not been changed inside of Vim, automatically read it again.
-- 	When the file has been deleted this is not done, so you have the text
-- 	from before it was deleted.  When it appears again then it is read.
-- 	|timestamp|
-- 	If this option has a local value, use this command to switch back to
-- 	using the global value: >
-- 		:set autoread<
-- <
--- @class vim.opt.autoread: vim.Option,boolean
--- @operator add: vim.opt.autoread
--- @operator sub: vim.opt.autoread
--- @operator pow: vim.opt.autoread
vim.opt.autoread = true
vim.opt.ar = vim.opt.autoread
--- @return boolean
function vim.opt.autoread:get()end

-- `'autowrite'`  `'aw'` 	boolean	(default off)
-- 			global
-- 	Write the contents of the file, if it has been modified, on each
-- 	`:next`, `:rewind`, `:last`, `:first`, `:previous`, `:stop`,
-- 	`:suspend`, `:tag`, `:!`, `:make`, CTRL-] and CTRL-^ command; and when
-- 	a `:buffer`, CTRL-O, CTRL-I, '{A-Z0-9}, or `{A-Z0-9} command takes one
-- 	to another file.
-- 	A buffer is not written if it becomes hidden, e.g. when `'bufhidden'`  is
-- 	set to "hide" and `:next` is used.
-- 	Note that for some commands the `'autowrite'`  option is not used, see
-- 	`'autowriteall'`  for that.
-- 	Some buffers will not be written, specifically when `'buftype'`  is
-- 	"nowrite", "nofile", "terminal" or "prompt".
--- @class vim.opt.autowrite: vim.Option,boolean
--- @operator add: vim.opt.autowrite
--- @operator sub: vim.opt.autowrite
--- @operator pow: vim.opt.autowrite
vim.opt.autowrite = false
vim.opt.aw = vim.opt.autowrite
--- @return boolean
function vim.opt.autowrite:get()end

-- `'autowriteall'`  `'awa'` 	boolean	(default off)
-- 			global
-- 	Like `'autowrite'` , but also used for commands ":edit", ":enew", ":quit",
-- 	":qall", ":exit", ":xit", ":recover" and closing the Vim window.
-- 	Setting this option also implies that Vim behaves like `'autowrite'`  has
-- 	been set.
--- @class vim.opt.autowriteall: vim.Option,boolean
--- @operator add: vim.opt.autowriteall
--- @operator sub: vim.opt.autowriteall
--- @operator pow: vim.opt.autowriteall
vim.opt.autowriteall = false
vim.opt.awa = vim.opt.autowriteall
--- @return boolean
function vim.opt.autowriteall:get()end

-- `'background'`  `'bg'` 	string	(default "dark")
-- 			global
-- 	When set to "dark" or "light", adjusts the default color groups for
-- 	that background type.  The |TUI| or other UI sets this on startup
-- 	(triggering |OptionSet|) if it can detect the background color.
-- 
-- 	This option does NOT change the background color, it tells Nvim what
-- 	the "inherited" (terminal/GUI) background looks like.
-- 	See |:hi-normal| if you want to set the background color explicitly.
-- 
-- 	When a color scheme is loaded (the "g:colors_name" variable is set)
-- 	setting `'background'`  will cause the color scheme to be reloaded.  If
-- 	the color scheme adjusts to the value of `'background'`  this will work.
-- 	However, if the color scheme sets `'background'`  itself the effect may
-- 	be undone.  First delete the "g:colors_name" variable when needed.
-- 
-- 	Normally this option would be set in the vimrc file.  Possibly
-- 	depending on the terminal name.  Example: >
-- 		:if $TERM ==# "xterm"
-- 		:  set background=dark
-- 		:endif
-- <	When this option is set, the default settings for the highlight groups
-- 	will change.  To use other settings, place ":highlight" commands AFTER
-- 	the setting of the `'background'`  option.
-- 	This option is also used in the "$VIMRUNTIME/syntax/syntax.vim" file
-- 	to select the colors for syntax highlighting.  After changing this
-- 	option, you must load syntax.vim again to see the result.  This can be
-- 	done with ":syntax on".
--- @class vim.opt.background: vim.Option,string
--- @operator add: vim.opt.background
--- @operator sub: vim.opt.background
--- @operator pow: vim.opt.background
vim.opt.background = "dark"
vim.opt.bg = vim.opt.background
--- @return string
function vim.opt.background:get()end

-- `'backspace'`  `'bs'` 	string	(default "indent,eol,start")
-- 			global
-- 	Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert
-- 	mode.  This is a list of items, separated by commas.  Each item allows
-- 	a way to backspace over something:
-- 	value	effect	~
-- 	indent	allow backspacing over autoindent
-- 	eol	allow backspacing over line breaks (join lines)
-- 	start	allow backspacing over the start of insert; CTRL-W and CTRL-U
-- 		stop once at the start of insert.
-- 	nostop	like start, except CTRL-W and CTRL-U do not stop at the start of
-- 		insert.
-- 
-- 	When the value is empty, Vi compatible backspacing is used, none of
-- 	the ways mentioned for the items above are possible.
-- 
-- 	For backwards compatibility with version 5.4 and earlier:
-- 	value	effect	~
-- 	  0	same as ":set backspace=" (Vi compatible)
-- 	  1	same as ":set backspace=indent,eol"
-- 	  2	same as ":set backspace=indent,eol,start"
-- 	  3	same as ":set backspace=indent,eol,nostop"
--- @class vim.opt.backspace: vim.Option,string[]
--- @operator add: vim.opt.backspace
--- @operator sub: vim.opt.backspace
--- @operator pow: vim.opt.backspace
vim.opt.backspace = "indent,eol,start"
vim.opt.bs = vim.opt.backspace
--- @return string[]
function vim.opt.backspace:get()end

-- `'backup'`  `'bk'` 		boolean	(default off)
-- 			global
-- 	Make a backup before overwriting a file.  Leave it around after the
-- 	file has been successfully written.  If you do not want to keep the
-- 	backup file, but you do want a backup while the file is being
-- 	written, reset this option and set the `'writebackup'`  option (this is
-- 	the default).  If you do not want a backup file at all reset both
-- 	options (use this if your file system is almost full).  See the
-- 	|backup-table| for more explanations.
-- 	When the `'backupskip'`  pattern matches, a backup is not made anyway.
-- 	When `'patchmode'`  is set, the backup may be renamed to become the
-- 	oldest version of a file.
--- @class vim.opt.backup: vim.Option,boolean
--- @operator add: vim.opt.backup
--- @operator sub: vim.opt.backup
--- @operator pow: vim.opt.backup
vim.opt.backup = false
vim.opt.bk = vim.opt.backup
--- @return boolean
function vim.opt.backup:get()end

-- `'backupcopy'`  `'bkc'` 	string	(default: "auto")
-- 			global or local to buffer |global-local|
-- 	When writing a file and a backup is made, this option tells how it's
-- 	done.  This is a comma-separated list of words.
-- 
-- 	The main values are:
-- 	"yes"	make a copy of the file and overwrite the original one
-- 	"no"	rename the file and write a new one
-- 	"auto"	one of the previous, what works best
-- 
-- 	Extra values that can be combined with the ones above are:
-- 	"breaksymlink"	always break symlinks when writing
-- 	"breakhardlink"	always break hardlinks when writing
-- 
-- 	Making a copy and overwriting the original file:
-- 	- Takes extra time to copy the file.
-- 	+ When the file has special attributes, is a (hard/symbolic) link or
-- 	  has a resource fork, all this is preserved.
-- 	- When the file is a link the backup will have the name of the link,
-- 	  not of the real file.
-- 
-- 	Renaming the file and writing a new one:
-- 	+ It's fast.
-- 	- Sometimes not all attributes of the file can be copied to the new
-- 	  file.
-- 	- When the file is a link the new file will not be a link.
-- 
-- 	The "auto" value is the middle way: When Vim sees that renaming the
-- 	file is possible without side effects (the attributes can be passed on
-- 	and the file is not a link) that is used.  When problems are expected,
-- 	a copy will be made.
-- 
-- 	The "breaksymlink" and "breakhardlink" values can be used in
-- 	combination with any of "yes", "no" and "auto".  When included, they
-- 	force Vim to always break either symbolic or hard links by doing
-- 	exactly what the "no" option does, renaming the original file to
-- 	become the backup and writing a new file in its place.  This can be
-- 	useful for example in source trees where all the files are symbolic or
-- 	hard links and any changes should stay in the local source tree, not
-- 	be propagated back to the original source.
-- 
-- 	One situation where "no" and "auto" will cause problems: A program
-- 	that opens a file, invokes Vim to edit that file, and then tests if
-- 	the open file was changed (through the file descriptor) will check the
-- 	backup file instead of the newly created file.  "crontab -e" is an
-- 	example.
-- 
-- 	When a copy is made, the original file is truncated and then filled
-- 	with the new text.  This means that protection bits, owner and
-- 	symbolic links of the original file are unmodified.  The backup file,
-- 	however, is a new file, owned by the user who edited the file.  The
-- 	group of the backup is set to the group of the original file.  If this
-- 	fails, the protection bits for the group are made the same as for
-- 	others.
-- 
-- 	When the file is renamed, this is the other way around: The backup has
-- 	the same attributes of the original file, and the newly written file
-- 	is owned by the current user.  When the file was a (hard/symbolic)
-- 	link, the new file will not!  That's why the "auto" value doesn't
-- 	rename when the file is a link.  The owner and group of the newly
-- 	written file will be set to the same ones as the original file, but
-- 	the system may refuse to do this.  In that case the "auto" value will
-- 	again not rename the file.
--- @class vim.opt.backupcopy: vim.Option,string[]
--- @operator add: vim.opt.backupcopy
--- @operator sub: vim.opt.backupcopy
--- @operator pow: vim.opt.backupcopy
vim.opt.backupcopy = "auto"
vim.opt.bkc = vim.opt.backupcopy
--- @return string[]
function vim.opt.backupcopy:get()end

-- `'backupdir'`  `'bdir'` 	string	(default ".,$XDG_STATE_HOME/nvim/backup//")
-- 			global
-- 	List of directories for the backup file, separated with commas.
-- 	- The backup file will be created in the first directory in the list
-- 	  where this is possible.  If none of the directories exist Nvim will
-- 	  attempt to create the last directory in the list.
-- 	- Empty means that no backup file will be created (`'patchmode'`  is
-- 	  impossible!).  Writing may fail because of this.
-- 	- A directory "." means to put the backup file in the same directory
-- 	  as the edited file.
-- 	- A directory starting with "./" (or ".\" for MS-Windows) means to put
-- 	  the backup file relative to where the edited file is.  The leading
-- 	  "." is replaced with the path name of the edited file.
-- 	  ("." inside a directory name has no special meaning).
-- 	- Spaces after the comma are ignored, other spaces are considered part
-- 	  of the directory name.  To have a space at the start of a directory
-- 	  name, precede it with a backslash.
-- 	- To include a comma in a directory name precede it with a backslash.
-- 	- A directory name may end in an `'/'` .
-- 	- For Unix and Win32, if a directory ends in two path separators "//",
-- 	  the swap file name will be built from the complete path to the file
-- 	  with all path separators changed to percent `'%'`  signs. This will
-- 	  ensure file name uniqueness in the backup directory.
-- 	  On Win32, it is also possible to end with "\\".  However, When a
-- 	  separating comma is following, you must use "//", since "\\" will
-- 	  include the comma in the file name. Therefore it is recommended to
-- 	  use `'//'` , instead of `'\\'` .
-- 	- Environment variables are expanded |:set_env|.
-- 	- Careful with `'\'`  characters, type one before a space, type two to
-- 	  get one in the option (see |option-backslash|), for example: >
-- 	    :set bdir=c:\\tmp,\ dir\\,with\\,commas,\\\ dir\ with\ spaces
-- <	- For backwards compatibility with Vim version 3.0 a `'>'`  at the start
-- 	  of the option is removed.
-- 	See also `'backup'`  and `'writebackup'`  options.
-- 	If you want to hide your backup files on Unix, consider this value: >
-- 		:set backupdir=./.backup,~/.backup,.,/tmp
-- <	You must create a ".backup" directory in each directory and in your
-- 	home directory for this to work properly.
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	directories from the list.  This avoids problems when a future version
-- 	uses another default.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.backupdir: vim.Option,string[]
--- @operator add: vim.opt.backupdir
--- @operator sub: vim.opt.backupdir
--- @operator pow: vim.opt.backupdir
vim.opt.backupdir = ".,/home/runner/.local/state/nvim/backup//"
vim.opt.bdir = vim.opt.backupdir
--- @return string[]
function vim.opt.backupdir:get()end

-- `'backupext'`  `'bex'` 	string	(default "~")
-- 			global
-- 	String which is appended to a file name to make the name of the
-- 	backup file.  The default is quite unusual, because this avoids
-- 	accidentally overwriting existing files with a backup file.  You might
-- 	prefer using ".bak", but make sure that you don't have files with
-- 	".bak" that you want to keep.
-- 	Only normal file name characters can be used; "/\*?[|<>" are illegal.
-- 
-- 	If you like to keep a lot of backups, you could use a BufWritePre
-- 	autocommand to change `'backupext'`  just before writing the file to
-- 	include a timestamp. >
-- 		:au BufWritePre * let &bex = `'-'`  .. strftime("%Y%b%d%X") .. `'~'` 
-- <	Use `'backupdir'`  to put the backup in a different directory.
--- @class vim.opt.backupext: vim.Option,string
--- @operator add: vim.opt.backupext
--- @operator sub: vim.opt.backupext
--- @operator pow: vim.opt.backupext
vim.opt.backupext = "~"
vim.opt.bex = vim.opt.backupext
--- @return string
function vim.opt.backupext:get()end

-- `'backupskip'`  `'bsk'` 	string	(default: "$TMPDIR/,$TEMP/*"
-- 				 Unix: "/tmp/,$TMP/"
-- 				 Mac: "/private/tmp/,$TMP/")
-- 			global
-- 	A list of file patterns.  When one of the patterns matches with the
-- 	name of the file which is written, no backup file is created.  Both
-- 	the specified file name and the full path name of the file are used.
-- 	The pattern is used like with |:autocmd|, see |autocmd-pattern|.
-- 	Watch out for special characters, see |option-backslash|.
-- 	When $TMPDIR, $TMP or $TEMP is not defined, it is not used for the
-- 	default value.  "/tmp/*" is only used for Unix.
-- 
-- 	WARNING: Not having a backup file means that when Vim fails to write
-- 	your buffer correctly and then, for whatever reason, Vim exits, you
-- 	lose both the original file and what you were writing.  Only disable
-- 	backups if you don't care about losing the file.
-- 
-- 	Note that environment variables are not expanded.  If you want to use
-- 	$HOME you must expand it explicitly, e.g.: >
-- 		:let &backupskip = escape(expand(`'$HOME'` ), `'\'` ) .. `'/tmp/*'` 
-- 
-- <	Note that the default also makes sure that "crontab -e" works (when a
-- 	backup would be made by renaming the original file crontab won't see
-- 	the newly created file).  Also see `'backupcopy'`  and |crontab|.
--- @class vim.opt.backupskip: vim.Option,string[]
--- @operator add: vim.opt.backupskip
--- @operator sub: vim.opt.backupskip
--- @operator pow: vim.opt.backupskip
vim.opt.backupskip = "/tmp/*"
vim.opt.bsk = vim.opt.backupskip
--- @return string[]
function vim.opt.backupskip:get()end

-- `'belloff'`  `'bo'` 		string	(default "all")
-- 			global
-- 	Specifies for which events the bell will not be rung. It is a comma-
-- 	separated list of items. For each item that is present, the bell
-- 	will be silenced. This is most useful to specify specific events in
-- 	insert mode to be silenced.
-- 
-- 	item	    meaning when present	~
-- 	all	    All events.
-- 	backspace   When hitting <BS> or <Del> and deleting results in an
-- 		    error.
-- 	cursor	    Fail to move around using the cursor keys or
-- 		    <PageUp>/<PageDown> in |Insert-mode|.
-- 	complete    Error occurred when using |i_CTRL-X_CTRL-K| or
-- 		    |i_CTRL-X_CTRL-T|.
-- 	copy	    Cannot copy char from insert mode using |i_CTRL-Y| or
-- 		    |i_CTRL-E|.
-- 	ctrlg	    Unknown Char after <C-G> in Insert mode.
-- 	error	    Other Error occurred (e.g. try to join last line)
-- 		    (mostly used in |Normal-mode| or |Cmdline-mode|).
-- 	esc	    hitting <Esc> in |Normal-mode|.
-- 	hangul	    Ignored.
-- 	lang	    Calling the beep module for Lua/Mzscheme/TCL.
-- 	mess	    No output available for |g<|.
-- 	showmatch   Error occurred for `'showmatch'`  function.
-- 	operator    Empty region error |cpo-E|.
-- 	register    Unknown register after <C-R> in |Insert-mode|.
-- 	shell	    Bell from shell output |:!|.
-- 	spell	    Error happened on spell suggest.
-- 	wildmode    More matches in |cmdline-completion| available
-- 		    (depends on the `'wildmode'`  setting).
-- 
-- 	This is most useful to fine tune when in Insert mode the bell should
-- 	be rung. For Normal mode and Ex commands, the bell is often rung to
-- 	indicate that an error occurred. It can be silenced by adding the
-- 	"error" keyword.
--- @class vim.opt.belloff: vim.Option,string[]
--- @operator add: vim.opt.belloff
--- @operator sub: vim.opt.belloff
--- @operator pow: vim.opt.belloff
vim.opt.belloff = "all"
vim.opt.bo = vim.opt.belloff
--- @return string[]
function vim.opt.belloff:get()end

-- `'binary'`  `'bin'` 		boolean	(default off)
-- 			local to buffer
-- 	This option should be set before editing a binary file.  You can also
-- 	use the |-b| Vim argument.  When this option is switched on a few
-- 	options will be changed (also when it already was on):
-- 		`'textwidth'`   will be set to 0
-- 		`'wrapmargin'`  will be set to 0
-- 		`'modeline'`    will be off
-- 		`'expandtab'`   will be off
-- 	Also, `'fileformat'`  and `'fileformats'`  options will not be used, the
-- 	file is read and written like `'fileformat'`  was "unix" (a single <NL>
-- 	separates lines).
-- 	The `'fileencoding'`  and `'fileencodings'`  options will not be used, the
-- 	file is read without conversion.
-- 	NOTE: When you start editing a(nother) file while the `'bin'`  option is
-- 	on, settings from autocommands may change the settings again (e.g.,
-- 	`'textwidth'` ), causing trouble when editing.  You might want to set
-- 	`'bin'`  again when the file has been loaded.
-- 	The previous values of these options are remembered and restored when
-- 	`'bin'`  is switched from on to off.  Each buffer has its own set of
-- 	saved option values.
-- 	To edit a file with `'binary'`  set you can use the |++bin| argument.
-- 	This avoids you have to do ":set bin", which would have effect for all
-- 	files you edit.
-- 	When writing a file the <EOL> for the last line is only written if
-- 	there was one in the original file (normally Vim appends an <EOL> to
-- 	the last line if there is none; this would make the file longer).  See
-- 	the `'endofline'`  option.
--- @class vim.opt.binary: vim.Option,boolean
--- @operator add: vim.opt.binary
--- @operator sub: vim.opt.binary
--- @operator pow: vim.opt.binary
vim.opt.binary = false
vim.opt.bin = vim.opt.binary
--- @return boolean
function vim.opt.binary:get()end

-- `'bomb'` 			boolean	(default off)
-- 			local to buffer
-- 	When writing a file and the following conditions are met, a BOM (Byte
-- 	Order Mark) is prepended to the file:
-- 	- this option is on
-- 	- the `'binary'`  option is off
-- 	- `'fileencoding'`  is "utf-8", "ucs-2", "ucs-4" or one of the little/big
-- 	  endian variants.
-- 	Some applications use the BOM to recognize the encoding of the file.
-- 	Often used for UCS-2 files on MS-Windows.  For other applications it
-- 	causes trouble, for example: "cat file1 file2" makes the BOM of file2
-- 	appear halfway through the resulting file.  Gcc doesn't accept a BOM.
-- 	When Vim reads a file and `'fileencodings'`  starts with "ucs-bom", a
-- 	check for the presence of the BOM is done and `'bomb'`  set accordingly.
-- 	Unless `'binary'`  is set, it is removed from the first line, so that you
-- 	don't see it when editing.  When you don't change the options, the BOM
-- 	will be restored when writing the file.
--- @class vim.opt.bomb: vim.Option,boolean
--- @operator add: vim.opt.bomb
--- @operator sub: vim.opt.bomb
--- @operator pow: vim.opt.bomb
vim.opt.bomb = false
--- @return boolean
function vim.opt.bomb:get()end

-- `'breakat'`  `'brk'` 		string	(default " ^I!@*-+;:,./?")
-- 			global
-- 	This option lets you choose which characters might cause a line
-- 	break if `'linebreak'`  is on.  Only works for ASCII characters.
--- @class vim.opt.breakat: vim.Option,string[]
--- @operator add: vim.opt.breakat
--- @operator sub: vim.opt.breakat
--- @operator pow: vim.opt.breakat
vim.opt.breakat = " \t!@*-+;:,./?"
vim.opt.brk = vim.opt.breakat
--- @return string[]
function vim.opt.breakat:get()end

-- `'breakindent'`  `'bri'` 	boolean (default off)
-- 			local to window
-- 	Every wrapped line will continue visually indented (same amount of
-- 	space as the beginning of that line), thus preserving horizontal blocks
-- 	of text.
--- @class vim.opt.breakindent: vim.Option,boolean
--- @operator add: vim.opt.breakindent
--- @operator sub: vim.opt.breakindent
--- @operator pow: vim.opt.breakindent
vim.opt.breakindent = false
vim.opt.bri = vim.opt.breakindent
--- @return boolean
function vim.opt.breakindent:get()end

-- `'breakindentopt'`  `'briopt'`  string (default empty)
-- 			local to window
-- 	Settings for `'breakindent'` . It can consist of the following optional
-- 	items and must be separated by a comma:
-- 		min:{n}	    Minimum text width that will be kept after
-- 			    applying `'breakindent'` , even if the resulting
-- 			    text should normally be narrower. This prevents
-- 			    text indented almost to the right window border
-- 			    occupying lot of vertical space when broken.
-- 			    (default: 20)
-- 		shift:{n}   After applying `'breakindent'` , the wrapped line's
-- 			    beginning will be shifted by the given number of
-- 			    characters.  It permits dynamic French paragraph
-- 			    indentation (negative) or emphasizing the line
-- 			    continuation (positive).
-- 			    (default: 0)
-- 		sbr	    Display the `'showbreak'`  value before applying the
-- 			    additional indent.
-- 			    (default: off)
-- 		list:{n}    Adds an additional indent for lines that match a
-- 			    numbered or bulleted list (using the
-- 			    `'formatlistpat'`  setting).
-- 		list:-1	    Uses the length of a match with `'formatlistpat'` 
-- 			    for indentation.
-- 			    (default: 0)
-- 		column:{n}  Indent at column {n}. Will overrule the other
-- 			    sub-options. Note: an additional indent may be
-- 			    added for the `'showbreak'`  setting.
-- 			    (default: off)
--- @class vim.opt.breakindentopt: vim.Option,string[]
--- @operator add: vim.opt.breakindentopt
--- @operator sub: vim.opt.breakindentopt
--- @operator pow: vim.opt.breakindentopt
vim.opt.breakindentopt = ""
vim.opt.briopt = vim.opt.breakindentopt
--- @return string[]
function vim.opt.breakindentopt:get()end

-- `'browsedir'`  `'bsdir'` 	string	(default: "last")
-- 			global
-- 	Which directory to use for the file browser:
-- 	   last		Use same directory as with last file browser, where a
-- 			file was opened or saved.
-- 	   buffer	Use the directory of the related buffer.
-- 	   current	Use the current directory.
-- 	   {path}	Use the specified directory
--- @class vim.opt.browsedir: vim.Option,string
--- @operator add: vim.opt.browsedir
--- @operator sub: vim.opt.browsedir
--- @operator pow: vim.opt.browsedir
vim.opt.browsedir = ""
vim.opt.bsdir = vim.opt.browsedir
--- @return string
function vim.opt.browsedir:get()end

-- `'bufhidden'`  `'bh'` 	string (default: "")
-- 			local to buffer
-- 	This option specifies what happens when a buffer is no longer
-- 	displayed in a window:
-- 	  <empty>	follow the global `'hidden'`  option
-- 	  hide		hide the buffer (don't unload it), even if `'hidden'`  is
-- 			not set
-- 	  unload	unload the buffer, even if `'hidden'`  is set; the
-- 			|:hide| command will also unload the buffer
-- 	  delete	delete the buffer from the buffer list, even if
-- 			`'hidden'`  is set; the |:hide| command will also delete
-- 			the buffer, making it behave like |:bdelete|
-- 	  wipe		wipe the buffer from the buffer list, even if
-- 			`'hidden'`  is set; the |:hide| command will also wipe
-- 			out the buffer, making it behave like |:bwipeout|
-- 
-- 	CAREFUL: when "unload", "delete" or "wipe" is used changes in a buffer
-- 	are lost without a warning.  Also, these values may break autocommands
-- 	that switch between buffers temporarily.
-- 	This option is used together with `'buftype'`  and `'swapfile'`  to specify
-- 	special kinds of buffers.   See |special-buffers|.
--- @class vim.opt.bufhidden: vim.Option,string
--- @operator add: vim.opt.bufhidden
--- @operator sub: vim.opt.bufhidden
--- @operator pow: vim.opt.bufhidden
vim.opt.bufhidden = ""
vim.opt.bh = vim.opt.bufhidden
--- @return string
function vim.opt.bufhidden:get()end

-- `'buflisted'`  `'bl'` 	boolean (default: on)
-- 			local to buffer
-- 	When this option is set, the buffer shows up in the buffer list.  If
-- 	it is reset it is not used for ":bnext", "ls", the Buffers menu, etc.
-- 	This option is reset by Vim for buffers that are only used to remember
-- 	a file name or marks.  Vim sets it when starting to edit a buffer.
-- 	But not when moving to a buffer with ":buffer".
--- @class vim.opt.buflisted: vim.Option,boolean
--- @operator add: vim.opt.buflisted
--- @operator sub: vim.opt.buflisted
--- @operator pow: vim.opt.buflisted
vim.opt.buflisted = true
vim.opt.bl = vim.opt.buflisted
--- @return boolean
function vim.opt.buflisted:get()end

-- `'buftype'`  `'bt'` 		string (default: "")
-- 			local to buffer
-- 	The value of this option specifies the type of a buffer:
-- 	  <empty>	normal buffer
-- 	  acwrite	buffer will always be written with |BufWriteCmd|s
-- 	  help		help buffer (do not set this manually)
-- 	  nofile	buffer is not related to a file, will not be written
-- 	  nowrite	buffer will not be written
-- 	  quickfix	list of errors |:cwindow| or locations |:lwindow|
-- 	  terminal	|terminal-emulator| buffer
-- 	  prompt	buffer where only the last line can be edited, meant
-- 			to be used by a plugin, see |prompt-buffer|
-- 
-- 	This option is used together with `'bufhidden'`  and `'swapfile'`  to
-- 	specify special kinds of buffers.   See |special-buffers|.
-- 	Also see |win_gettype()|, which returns the type of the window.
-- 
-- 	Be careful with changing this option, it can have many side effects!
-- 	One such effect is that Vim will not check the timestamp of the file,
-- 	if the file is changed by another program this will not be noticed.
-- 
-- 	A "quickfix" buffer is only used for the error list and the location
-- 	list.  This value is set by the |:cwindow| and |:lwindow| commands and
-- 	you are not supposed to change it.
-- 
-- 	"nofile" and "nowrite" buffers are similar:
-- 	both:		The buffer is not to be written to disk, ":w" doesn't
-- 			work (":w filename" does work though).
-- 	both:		The buffer is never considered to be |`'modified'` |.
-- 			There is no warning when the changes will be lost, for
-- 			example when you quit Vim.
-- 	both:		A swap file is only created when using too much memory
-- 			(when `'swapfile'`  has been reset there is never a swap
-- 			file).
-- 	nofile only:	The buffer name is fixed, it is not handled like a
-- 			file name.  It is not modified in response to a |:cd|
-- 			command.
-- 	both:		When using ":e bufname" and already editing "bufname"
-- 			the buffer is made empty and autocommands are
-- 			triggered as usual for |:edit|.
-- 
-- 	"acwrite" implies that the buffer name is not related to a file, like
-- 	"nofile", but it will be written.  Thus, in contrast to "nofile" and
-- 	"nowrite", ":w" does work and a modified buffer can't be abandoned
-- 	without saving.  For writing there must be matching |BufWriteCmd|,
-- 	|FileWriteCmd| or |FileAppendCmd| autocommands.
--- @class vim.opt.buftype: vim.Option,string
--- @operator add: vim.opt.buftype
--- @operator sub: vim.opt.buftype
--- @operator pow: vim.opt.buftype
vim.opt.buftype = ""
vim.opt.bt = vim.opt.buftype
--- @return string
function vim.opt.buftype:get()end

-- `'casemap'`  `'cmp'` 		string	(default: "internal,keepascii")
-- 			global
-- 	Specifies details about changing the case of letters.  It may contain
-- 	these words, separated by a comma:
-- 	internal	Use internal case mapping functions, the current
-- 			locale does not change the case mapping. When
-- 			"internal" is omitted, the towupper() and towlower()
-- 			system library functions are used when available.
-- 	keepascii	For the ASCII characters (0x00 to 0x7f) use the US
-- 			case mapping, the current locale is not effective.
-- 			This probably only matters for Turkish.
--- @class vim.opt.casemap: vim.Option,string[]
--- @operator add: vim.opt.casemap
--- @operator sub: vim.opt.casemap
--- @operator pow: vim.opt.casemap
vim.opt.casemap = "internal,keepascii"
vim.opt.cmp = vim.opt.casemap
--- @return string[]
function vim.opt.casemap:get()end

-- `'cdhome'`  `'cdh'` 		boolean	(default: off)
-- 			global
-- 	When on, |:cd|, |:tcd| and |:lcd| without an argument changes the
-- 	current working directory to the |$HOME| directory like in Unix.
-- 	When off, those commands just print the current directory name.
-- 	On Unix this option has no effect.
--- @class vim.opt.cdhome: vim.Option,boolean
--- @operator add: vim.opt.cdhome
--- @operator sub: vim.opt.cdhome
--- @operator pow: vim.opt.cdhome
vim.opt.cdhome = false
vim.opt.cdh = vim.opt.cdhome
--- @return boolean
function vim.opt.cdhome:get()end

-- `'cdpath'`  `'cd'` 		string	(default: equivalent to $CDPATH or ",,")
-- 			global
-- 	This is a list of directories which will be searched when using the
-- 	|:cd|, |:tcd| and |:lcd| commands, provided that the directory being
-- 	searched for has a relative path, not an absolute part starting with
-- 	"/", "./" or "../", the `'cdpath'`  option is not used then.
-- 	The `'cdpath'`  option's value has the same form and semantics as
-- 	|`'path'` |.  Also see |file-searching|.
-- 	The default value is taken from $CDPATH, with a "," prepended to look
-- 	in the current directory first.
-- 	If the default value taken from $CDPATH is not what you want, include
-- 	a modified version of the following command in your vimrc file to
-- 	override it: >
-- 	  :let &cdpath = `','`  .. substitute(substitute($CDPATH, '[, ]', `'\\\0'` , `'g'` ), `':'` , `','` , `'g'` )
-- <	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
-- 	(parts of `'cdpath'`  can be passed to the shell to expand file names).
--- @class vim.opt.cdpath: vim.Option,string[]
--- @operator add: vim.opt.cdpath
--- @operator sub: vim.opt.cdpath
--- @operator pow: vim.opt.cdpath
vim.opt.cdpath = ",,"
vim.opt.cd = vim.opt.cdpath
--- @return string[]
function vim.opt.cdpath:get()end

-- `'cedit'` 			string	(default: CTRL-F)
-- 			global
-- 	The key used in Command-line Mode to open the command-line window.
-- 	Only non-printable keys are allowed.
-- 	The key can be specified as a single character, but it is difficult to
-- 	type.  The preferred way is to use the <> notation.  Examples: >
-- 		:exe "set cedit=\<C-Y>"
-- 		:exe "set cedit=\<Esc>"
-- <	|Nvi| also has this option, but it only uses the first character.
-- 	See |cmdwin|.
--- @class vim.opt.cedit: vim.Option,string
--- @operator add: vim.opt.cedit
--- @operator sub: vim.opt.cedit
--- @operator pow: vim.opt.cedit
vim.opt.cedit = "\6"
--- @return string
function vim.opt.cedit:get()end

-- `'channel'` 		number (default: 0)
-- 			local to buffer
-- 	|channel| connected to the buffer, or 0 if no channel is connected.
-- 	In a |:terminal| buffer this is the terminal channel.
-- 	Read-only.
--- @class vim.opt.channel: vim.Option,number
--- @operator add: vim.opt.channel
--- @operator sub: vim.opt.channel
--- @operator pow: vim.opt.channel
vim.opt.channel = 0
--- @return number
function vim.opt.channel:get()end

-- `'charconvert'`  `'ccv'` 	string (default "")
-- 			global
-- 	An expression that is used for character encoding conversion.  It is
-- 	evaluated when a file that is to be read or has been written has a
-- 	different encoding from what is desired.
-- 	`'charconvert'`  is not used when the internal iconv() function is
-- 	supported and is able to do the conversion.  Using iconv() is
-- 	preferred, because it is much faster.
-- 	`'charconvert'`  is not used when reading stdin |--|, because there is no
-- 	file to convert from.  You will have to save the text in a file first.
-- 	The expression must return zero, false or an empty string for success,
-- 	non-zero or true for failure.
-- 	See |encoding-names| for possible encoding names.
-- 	Additionally, names given in `'fileencodings'`  and `'fileencoding'`  are
-- 	used.
-- 	Conversion between "latin1", "unicode", "ucs-2", "ucs-4" and "utf-8"
-- 	is done internally by Vim, `'charconvert'`  is not used for this.
-- 	Also used for Unicode conversion.
-- 	Example: >
-- 		set charconvert=CharConvert()
-- 		fun CharConvert()
-- 		  system("recode "
-- 			\ .. v:charconvert_from .. ".." .. v:charconvert_to
-- 			\ .. " <" .. v:fname_in .. " >" .. v:fname_out)
-- 		  return v:shell_error
-- 		endfun
-- <	The related Vim variables are:
-- 		v:charconvert_from	name of the current encoding
-- 		v:charconvert_to	name of the desired encoding
-- 		v:fname_in		name of the input file
-- 		v:fname_out		name of the output file
-- 	Note that v:fname_in and v:fname_out will never be the same.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.charconvert: vim.Option,string
--- @operator add: vim.opt.charconvert
--- @operator sub: vim.opt.charconvert
--- @operator pow: vim.opt.charconvert
vim.opt.charconvert = ""
vim.opt.ccv = vim.opt.charconvert
--- @return string
function vim.opt.charconvert:get()end

-- `'cindent'`  `'cin'` 		boolean	(default off)
-- 			local to buffer
-- 	Enables automatic C program indenting.  See `'cinkeys'`  to set the keys
-- 	that trigger reindenting in insert mode and `'cinoptions'`  to set your
-- 	preferred indent style.
-- 	If `'indentexpr'`  is not empty, it overrules `'cindent'` .
-- 	If `'lisp'`  is not on and both `'indentexpr'`  and `'equalprg'`  are empty,
-- 	the "=" operator indents using this algorithm rather than calling an
-- 	external program.
-- 	See |C-indenting|.
-- 	When you don't like the way `'cindent'`  works, try the `'smartindent'` 
-- 	option or `'indentexpr'` .
--- @class vim.opt.cindent: vim.Option,boolean
--- @operator add: vim.opt.cindent
--- @operator sub: vim.opt.cindent
--- @operator pow: vim.opt.cindent
vim.opt.cindent = false
vim.opt.cin = vim.opt.cindent
--- @return boolean
function vim.opt.cindent:get()end

-- `'cinkeys'`  `'cink'` 	string	(default "0{,0},0),0],:,0#,!^F,o,O,e")
-- 			local to buffer
-- 	A list of keys that, when typed in Insert mode, cause reindenting of
-- 	the current line.  Only used if `'cindent'`  is on and `'indentexpr'`  is
-- 	empty.
-- 	For the format of this option see |cinkeys-format|.
-- 	See |C-indenting|.
--- @class vim.opt.cinkeys: vim.Option,string[]
--- @operator add: vim.opt.cinkeys
--- @operator sub: vim.opt.cinkeys
--- @operator pow: vim.opt.cinkeys
vim.opt.cinkeys = "0{,0},0),0],:,0#,!^F,o,O,e"
vim.opt.cink = vim.opt.cinkeys
--- @return string[]
function vim.opt.cinkeys:get()end

-- `'cinoptions'`  `'cino'` 	string	(default "")
-- 			local to buffer
-- 	The `'cinoptions'`  affect the way `'cindent'`  reindents lines in a C
-- 	program.  See |cinoptions-values| for the values of this option, and
-- 	|C-indenting| for info on C indenting in general.
--- @class vim.opt.cinoptions: vim.Option,string[]
--- @operator add: vim.opt.cinoptions
--- @operator sub: vim.opt.cinoptions
--- @operator pow: vim.opt.cinoptions
vim.opt.cinoptions = ""
vim.opt.cino = vim.opt.cinoptions
--- @return string[]
function vim.opt.cinoptions:get()end

-- `'cinscopedecls'`  `'cinsd'` 	string	(default "public,protected,private")
-- 			local to buffer
-- 	Keywords that are interpreted as a C++ scope declaration by |cino-g|.
-- 	Useful e.g. for working with the Qt framework that defines additional
-- 	scope declarations "signals", "public slots" and "private slots": >
-- 		set cinscopedecls+=signals,public\ slots,private\ slots
-- 
-- <
--- @class vim.opt.cinscopedecls: vim.Option,string[]
--- @operator add: vim.opt.cinscopedecls
--- @operator sub: vim.opt.cinscopedecls
--- @operator pow: vim.opt.cinscopedecls
vim.opt.cinscopedecls = "public,protected,private"
vim.opt.cinsd = vim.opt.cinscopedecls
--- @return string[]
function vim.opt.cinscopedecls:get()end

-- `'cinwords'`  `'cinw'` 	string	(default "if,else,while,do,for,switch")
-- 			local to buffer
-- 	These keywords start an extra indent in the next line when
-- 	`'smartindent'`  or `'cindent'`  is set.  For `'cindent'`  this is only done at
-- 	an appropriate place (inside {}).
-- 	Note that `'ignorecase'`  isn't used for `'cinwords'` .  If case doesn't
-- 	matter, include the keyword both the uppercase and lowercase:
-- 	"if,If,IF".
--- @class vim.opt.cinwords: vim.Option,string[]
--- @operator add: vim.opt.cinwords
--- @operator sub: vim.opt.cinwords
--- @operator pow: vim.opt.cinwords
vim.opt.cinwords = "if,else,while,do,for,switch"
vim.opt.cinw = vim.opt.cinwords
--- @return string[]
function vim.opt.cinwords:get()end

-- `'clipboard'`  `'cb'` 	string	(default "")
-- 			global
-- 	This option is a list of comma-separated names.
-- 	These names are recognized:
-- 
-- 
-- 	unnamed		When included, Vim will use the clipboard register "*"
-- 			for all yank, delete, change and put operations which
-- 			would normally go to the unnamed register.  When a
-- 			register is explicitly specified, it will always be
-- 			used regardless of whether "unnamed" is in `'clipboard'` 
-- 			or not.  The clipboard register can always be
-- 			explicitly accessed using the "* notation.  Also see
-- 			|clipboard|.
-- 
-- 
-- 	unnamedplus	A variant of the "unnamed" flag which uses the
-- 			clipboard register "+" (|quoteplus|) instead of
-- 			register "*" for all yank, delete, change and put
-- 			operations which would normally go to the unnamed
-- 			register.  When "unnamed" is also included to the
-- 			option, yank and delete operations (but not put)
-- 			will additionally copy the text into register
-- 			`'*'` . See |clipboard|.
--- @class vim.opt.clipboard: vim.Option,string[]
--- @operator add: vim.opt.clipboard
--- @operator sub: vim.opt.clipboard
--- @operator pow: vim.opt.clipboard
vim.opt.clipboard = ""
vim.opt.cb = vim.opt.clipboard
--- @return string[]
function vim.opt.clipboard:get()end

-- `'cmdheight'`  `'ch'` 	number	(default 1)
-- 			global or local to tab page
-- 	Number of screen lines to use for the command-line.  Helps avoiding
-- 	|hit-enter| prompts.
-- 	The value of this option is stored with the tab page, so that each tab
-- 	page can have a different value.
-- 
-- 	When `'cmdheight'`  is zero, there is no command-line unless it is being
-- 	used.  The command-line will cover the last line of the screen when
-- 	shown.
-- 
-- 	WARNING: `cmdheight=0` is considered experimental. Expect some
-- 	unwanted behaviour. Some `'shortmess'`  flags and similar
-- 	mechanism might fail to take effect, causing unwanted hit-enter
-- 	prompts.  Some informative messages, both from Nvim itself and
-- 	plugins, will not be displayed.
--- @class vim.opt.cmdheight: vim.Option,number
--- @operator add: vim.opt.cmdheight
--- @operator sub: vim.opt.cmdheight
--- @operator pow: vim.opt.cmdheight
vim.opt.cmdheight = 1
vim.opt.ch = vim.opt.cmdheight
--- @return number
function vim.opt.cmdheight:get()end

-- `'cmdwinheight'`  `'cwh'` 	number	(default 7)
-- 			global
-- 	Number of screen lines to use for the command-line window. |cmdwin|
--- @class vim.opt.cmdwinheight: vim.Option,number
--- @operator add: vim.opt.cmdwinheight
--- @operator sub: vim.opt.cmdwinheight
--- @operator pow: vim.opt.cmdwinheight
vim.opt.cmdwinheight = 7
vim.opt.cwh = vim.opt.cmdwinheight
--- @return number
function vim.opt.cmdwinheight:get()end

-- `'colorcolumn'`  `'cc'` 	string	(default "")
-- 			local to window
-- 	`'colorcolumn'`  is a comma-separated list of screen columns that are
-- 	highlighted with ColorColumn |hl-ColorColumn|.  Useful to align
-- 	text.  Will make screen redrawing slower.
-- 	The screen column can be an absolute number, or a number preceded with
-- 	`'+'`  or `'-'` , which is added to or subtracted from `'textwidth'` . >
-- 
-- 		:set cc=+1  " highlight column after `'textwidth'` 
-- 		:set cc=+1,+2,+3  " highlight three columns after `'textwidth'` 
-- 		:hi ColorColumn ctermbg=lightgrey guibg=lightgrey
-- <
-- 	When `'textwidth'`  is zero then the items with `'-'`  and `'+'`  are not used.
-- 	A maximum of 256 columns are highlighted.
--- @class vim.opt.colorcolumn: vim.Option,string[]
--- @operator add: vim.opt.colorcolumn
--- @operator sub: vim.opt.colorcolumn
--- @operator pow: vim.opt.colorcolumn
vim.opt.colorcolumn = ""
vim.opt.cc = vim.opt.colorcolumn
--- @return string[]
function vim.opt.colorcolumn:get()end

-- `'columns'`  `'co'` 		number	(default 80 or terminal width)
-- 			global
-- 	Number of columns of the screen.  Normally this is set by the terminal
-- 	initialization and does not have to be set by hand.
-- 	When Vim is running in the GUI or in a resizable window, setting this
-- 	option will cause the window size to be changed.  When you only want
-- 	to use the size for the GUI, put the command in your |ginit.vim| file.
-- 	When you set this option and Vim is unable to change the physical
-- 	number of columns of the display, the display may be messed up.  For
-- 	the GUI it is always possible and Vim limits the number of columns to
-- 	what fits on the screen.  You can use this command to get the widest
-- 	window possible: >
-- 		:set columns=9999
-- <	Minimum value is 12, maximum value is 10000.
--- @class vim.opt.columns: vim.Option,number
--- @operator add: vim.opt.columns
--- @operator sub: vim.opt.columns
--- @operator pow: vim.opt.columns
vim.opt.columns = 80
vim.opt.co = vim.opt.columns
--- @return number
function vim.opt.columns:get()end

-- `'comments'`  `'com'` 	string	(default
-- 				"s1:/,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-")
-- 			local to buffer
-- 	A comma-separated list of strings that can start a comment line.  See
-- 	|format-comments|.  See |option-backslash| about using backslashes to
-- 	insert a space.
--- @class vim.opt.comments: vim.Option,string[]
--- @operator add: vim.opt.comments
--- @operator sub: vim.opt.comments
--- @operator pow: vim.opt.comments
vim.opt.comments = "s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-"
vim.opt.com = vim.opt.comments
--- @return string[]
function vim.opt.comments:get()end

-- `'commentstring'`  `'cms'` 	string	(default "")
-- 			local to buffer
-- 	A template for a comment.  The "%s" in the value is replaced with the
-- 	comment text.  Currently only used to add markers for folding, see
-- 	|fold-marker|.
--- @class vim.opt.commentstring: vim.Option,string
--- @operator add: vim.opt.commentstring
--- @operator sub: vim.opt.commentstring
--- @operator pow: vim.opt.commentstring
vim.opt.commentstring = ""
vim.opt.cms = vim.opt.commentstring
--- @return string
function vim.opt.commentstring:get()end

--- @class vim.opt.compatible: vim.Option,boolean
--- @operator add: vim.opt.compatible
--- @operator sub: vim.opt.compatible
--- @operator pow: vim.opt.compatible
vim.opt.compatible = false
vim.opt.cp = vim.opt.compatible
--- @return boolean
function vim.opt.compatible:get()end

-- `'complete'`  `'cpt'` 	string	(default: ".,w,b,u,t")
-- 			local to buffer
-- 	This option specifies how keyword completion |ins-completion| works
-- 	when CTRL-P or CTRL-N are used.  It is also used for whole-line
-- 	completion |i_CTRL-X_CTRL-L|.  It indicates the type of completion
-- 	and the places to scan.  It is a comma-separated list of flags:
-- 	.	scan the current buffer (`'wrapscan'`  is ignored)
-- 	w	scan buffers from other windows
-- 	b	scan other loaded buffers that are in the buffer list
-- 	u	scan the unloaded buffers that are in the buffer list
-- 	U	scan the buffers that are not in the buffer list
-- 	k	scan the files given with the `'dictionary'`  option
-- 	kspell  use the currently active spell checking |spell|
-- 	k{dict}	scan the file {dict}.  Several "k" flags can be given,
-- 		patterns are valid too.  For example: >
-- 			:set cpt=k/usr/dict/*,k~/spanish
-- <	s	scan the files given with the `'thesaurus'`  option
-- 	s{tsr}	scan the file {tsr}.  Several "s" flags can be given, patterns
-- 		are valid too.
-- 	i	scan current and included files
-- 	d	scan current and included files for defined name or macro
-- 		|i_CTRL-X_CTRL-D|
-- 	]	tag completion
-- 	t	same as "]"
-- 
-- 	Unloaded buffers are not loaded, thus their autocmds |:autocmd| are
-- 	not executed, this may lead to unexpected completions from some files
-- 	(gzipped files for example).  Unloaded buffers are not scanned for
-- 	whole-line completion.
-- 
-- 	As you can see, CTRL-N and CTRL-P can be used to do any `'iskeyword'` -
-- 	based expansion (e.g., dictionary |i_CTRL-X_CTRL-K|, included patterns
-- 	|i_CTRL-X_CTRL-I|, tags |i_CTRL-X_CTRL-]| and normal expansions).
--- @class vim.opt.complete: vim.Option,string[]
--- @operator add: vim.opt.complete
--- @operator sub: vim.opt.complete
--- @operator pow: vim.opt.complete
vim.opt.complete = ".,w,b,u,t"
vim.opt.cpt = vim.opt.complete
--- @return string[]
function vim.opt.complete:get()end

-- `'completefunc'`  `'cfu'` 	string	(default: empty)
-- 			local to buffer
-- 	This option specifies a function to be used for Insert mode completion
-- 	with CTRL-X CTRL-U. |i_CTRL-X_CTRL-U|
-- 	See |complete-functions| for an explanation of how the function is
-- 	invoked and what it should return.  The value can be the name of a
-- 	function, a |lambda| or a |Funcref|. See |option-value-function| for
-- 	more information.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.completefunc: vim.Option,string
--- @operator add: vim.opt.completefunc
--- @operator sub: vim.opt.completefunc
--- @operator pow: vim.opt.completefunc
vim.opt.completefunc = ""
vim.opt.cfu = vim.opt.completefunc
--- @return string
function vim.opt.completefunc:get()end

-- `'completeopt'`  `'cot'` 	string	(default: "menu,preview")
-- 			global
-- 	A comma-separated list of options for Insert mode completion
-- 	|ins-completion|.  The supported values are:
-- 
-- 	   menu	    Use a popup menu to show the possible completions.  The
-- 		    menu is only shown when there is more than one match and
-- 		    sufficient colors are available.  |ins-completion-menu|
-- 
-- 	   menuone  Use the popup menu also when there is only one match.
-- 		    Useful when there is additional information about the
-- 		    match, e.g., what file it comes from.
-- 
-- 	   longest  Only insert the longest common text of the matches.  If
-- 		    the menu is displayed you can use CTRL-L to add more
-- 		    characters.  Whether case is ignored depends on the kind
-- 		    of completion.  For buffer text the `'ignorecase'`  option is
-- 		    used.
-- 
-- 	   preview  Show extra information about the currently selected
-- 		    completion in the preview window.  Only works in
-- 		    combination with "menu" or "menuone".
-- 
-- 	  noinsert  Do not insert any text for a match until the user selects
-- 		    a match from the menu. Only works in combination with
-- 		    "menu" or "menuone". No effect if "longest" is present.
-- 
-- 	  noselect  Do not select a match in the menu, force the user to
-- 		    select one from the menu. Only works in combination with
-- 		    "menu" or "menuone".
--- @class vim.opt.completeopt: vim.Option,string[]
--- @operator add: vim.opt.completeopt
--- @operator sub: vim.opt.completeopt
--- @operator pow: vim.opt.completeopt
vim.opt.completeopt = "menu,preview"
vim.opt.cot = vim.opt.completeopt
--- @return string[]
function vim.opt.completeopt:get()end

-- `'completeslash'`  `'csl'` 	string	(default: "")
-- 			local to buffer
-- 			{only for MS-Windows}
-- 	When this option is set it overrules `'shellslash'`  for completion:
-- 	- When this option is set to "slash", a forward slash is used for path
-- 	  completion in insert mode. This is useful when editing HTML tag, or
-- 	  Makefile with `'noshellslash'`  on MS-Windows.
-- 	- When this option is set to "backslash", backslash is used. This is
-- 	  useful when editing a batch file with `'shellslash'`  set on MS-Windows.
-- 	- When this option is empty, same character is used as for
-- 	  `'shellslash'` .
-- 	For Insert mode completion the buffer-local value is used.  For
-- 	command line completion the global value is used.
--- @class vim.opt.completeslash: vim.Option,string
--- @operator add: vim.opt.completeslash
--- @operator sub: vim.opt.completeslash
--- @operator pow: vim.opt.completeslash
vim.opt.completeslash = ""
vim.opt.csl = vim.opt.completeslash
--- @return string
function vim.opt.completeslash:get()end

-- `'concealcursor'`  `'cocu'` 	string (default: "")
-- 			local to window
-- 	Sets the modes in which text in the cursor line can also be concealed.
-- 	When the current mode is listed then concealing happens just like in
-- 	other lines.
-- 	  n		Normal mode
-- 	  v		Visual mode
-- 	  i		Insert mode
-- 	  c		Command line editing, for `'incsearch'` 
-- 
-- 	`'v'`  applies to all lines in the Visual area, not only the cursor.
-- 	A useful value is "nc".  This is used in help files.  So long as you
-- 	are moving around text is concealed, but when starting to insert text
-- 	or selecting a Visual area the concealed text is displayed, so that
-- 	you can see what you are doing.
-- 	Keep in mind that the cursor position is not always where it's
-- 	displayed.  E.g., when moving vertically it may change column.
--- @class vim.opt.concealcursor: vim.Option,string
--- @operator add: vim.opt.concealcursor
--- @operator sub: vim.opt.concealcursor
--- @operator pow: vim.opt.concealcursor
vim.opt.concealcursor = ""
vim.opt.cocu = vim.opt.concealcursor
--- @return string
function vim.opt.concealcursor:get()end

-- `'conceallevel'`  `'cole'` 	number (default 0)
-- 			local to window
-- 	Determine how text with the "conceal" syntax attribute |:syn-conceal|
-- 	is shown:
-- 
-- 	Value		Effect ~
-- 	0		Text is shown normally
-- 	1		Each block of concealed text is replaced with one
-- 			character.  If the syntax item does not have a custom
-- 			replacement character defined (see |:syn-cchar|) the
-- 			character defined in `'listchars'`  is used.
-- 			It is highlighted with the "Conceal" highlight group.
-- 	2		Concealed text is completely hidden unless it has a
-- 			custom replacement character defined (see
-- 			|:syn-cchar|).
-- 	3		Concealed text is completely hidden.
-- 
-- 	Note: in the cursor line concealed text is not hidden, so that you can
-- 	edit and copy the text.  This can be changed with the `'concealcursor'` 
-- 	option.
--- @class vim.opt.conceallevel: vim.Option,number
--- @operator add: vim.opt.conceallevel
--- @operator sub: vim.opt.conceallevel
--- @operator pow: vim.opt.conceallevel
vim.opt.conceallevel = 0
vim.opt.cole = vim.opt.conceallevel
--- @return number
function vim.opt.conceallevel:get()end

-- `'confirm'`  `'cf'` 		boolean (default off)
-- 			global
-- 	When `'confirm'`  is on, certain operations that would normally
-- 	fail because of unsaved changes to a buffer, e.g. ":q" and ":e",
-- 	instead raise a dialog asking if you wish to save the current
-- 	file(s).  You can still use a ! to unconditionally |abandon| a buffer.
-- 	If `'confirm'`  is off you can still activate confirmation for one
-- 	command only (this is most useful in mappings) with the |:confirm|
-- 	command.
-- 	Also see the |confirm()| function and the `'v'`  flag in `'guioptions'` .
--- @class vim.opt.confirm: vim.Option,boolean
--- @operator add: vim.opt.confirm
--- @operator sub: vim.opt.confirm
--- @operator pow: vim.opt.confirm
vim.opt.confirm = false
vim.opt.cf = vim.opt.confirm
--- @return boolean
function vim.opt.confirm:get()end

-- `'copyindent'`  `'ci'` 	boolean	(default off)
-- 			local to buffer
-- 	Copy the structure of the existing lines indent when autoindenting a
-- 	new line.  Normally the new indent is reconstructed by a series of
-- 	tabs followed by spaces as required (unless |`'expandtab'` | is enabled,
-- 	in which case only spaces are used).  Enabling this option makes the
-- 	new line copy whatever characters were used for indenting on the
-- 	existing line.  `'expandtab'`  has no effect on these characters, a Tab
-- 	remains a Tab.  If the new indent is greater than on the existing
-- 	line, the remaining space is filled in the normal manner.
-- 	See `'preserveindent'` .
--- @class vim.opt.copyindent: vim.Option,boolean
--- @operator add: vim.opt.copyindent
--- @operator sub: vim.opt.copyindent
--- @operator pow: vim.opt.copyindent
vim.opt.copyindent = false
vim.opt.ci = vim.opt.copyindent
--- @return boolean
function vim.opt.copyindent:get()end

-- `'cpoptions'`  `'cpo'` 	string	(default: "aABceFs_")
-- 			global
-- 	A sequence of single character flags.  When a character is present
-- 	this indicates Vi-compatible behavior.  This is used for things where
-- 	not being Vi-compatible is mostly or sometimes preferred.
-- 	`'cpoptions'`  stands for "compatible-options".
-- 	Commas can be added for readability.
-- 	To avoid problems with flags that are added in the future, use the
-- 	"+=" and "-=" feature of ":set" |add-option-flags|.
-- 
-- 	    contains	behavior	~
-- 
-- 		a	When included, a ":read" command with a file name
-- 			argument will set the alternate file name for the
-- 			current window.
-- 
-- 		A	When included, a ":write" command with a file name
-- 			argument will set the alternate file name for the
-- 			current window.
-- 
-- 		b	"\|" in a ":map" command is recognized as the end of
-- 			the map command.  The `'\'`  is included in the mapping,
-- 			the text after the `'|'`  is interpreted as the next
-- 			command.  Use a CTRL-V instead of a backslash to
-- 			include the `'|'`  in the mapping.  Applies to all
-- 			mapping, abbreviation, menu and autocmd commands.
-- 			See also |map_bar|.
-- 
-- 		B	A backslash has no special meaning in mappings,
-- 			abbreviations, user commands and the "to" part of the
-- 			menu commands.  Remove this flag to be able to use a
-- 			backslash like a CTRL-V.  For example, the command
-- 			":map X \<Esc>" results in X being mapped to:
-- 				`'B'`  included:	"\^["	 (^[ is a real <Esc>)
-- 				`'B'`  excluded:	"<Esc>"  (5 characters)
-- 
-- 		c	Searching continues at the end of any match at the
-- 			cursor position, but not further than the start of the
-- 			next line.  When not present searching continues
-- 			one character from the cursor position.  With `'c'` 
-- 			"abababababab" only gets three matches when repeating
-- 			"/abab", without `'c'`  there are five matches.
-- 
-- 		C	Do not concatenate sourced lines that start with a
-- 			backslash.  See |line-continuation|.
-- 
-- 		d	Using "./" in the `'tags'`  option doesn't mean to use
-- 			the tags file relative to the current file, but the
-- 			tags file in the current directory.
-- 
-- 		D	Can't use CTRL-K to enter a digraph after Normal mode
-- 			commands with a character argument, like |r|, |f| and
-- 			|t|.
-- 
-- 		e	When executing a register with ":@r", always add a
-- 			<CR> to the last line, also when the register is not
-- 			linewise.  If this flag is not present, the register
-- 			is not linewise and the last line does not end in a
-- 			<CR>, then the last line is put on the command-line
-- 			and can be edited before hitting <CR>.
-- 
-- 		E	It is an error when using "y", "d", "c", "g~", "gu" or
-- 			"gU" on an Empty region.  The operators only work when
-- 			at least one character is to be operated on.  Example:
-- 			This makes "y0" fail in the first column.
-- 
-- 		f	When included, a ":read" command with a file name
-- 			argument will set the file name for the current buffer,
-- 			if the current buffer doesn't have a file name yet.
-- 
-- 		F	When included, a ":write" command with a file name
-- 			argument will set the file name for the current
-- 			buffer, if the current buffer doesn't have a file name
-- 			yet.  Also see |cpo-P|.
-- 
-- 		i	When included, interrupting the reading of a file will
-- 			leave it modified.
-- 
-- 		I	When moving the cursor up or down just after inserting
-- 			indent for `'autoindent'` , do not delete the indent.
-- 
-- 		J	A |sentence| has to be followed by two spaces after
-- 			the `'.'` , `'!'`  or `'?'` .  A <Tab> is not recognized as
-- 			white space.
-- 
-- 		K	Don't wait for a key code to complete when it is
-- 			halfway through a mapping.  This breaks mapping
-- 			<F1><F1> when only part of the second <F1> has been
-- 			read.  It enables cancelling the mapping by typing
-- 			<F1><Esc>.
-- 
-- 		l	Backslash in a [] range in a search pattern is taken
-- 			literally, only "\]", "\^", "\-" and "\\" are special.
-- 			See |/[]|
-- 			   `'l'`  included: "/[ \t]"  finds <Space>, `'\'`  and `'t'` 
-- 			   `'l'`  excluded: "/[ \t]"  finds <Space> and <Tab>
-- 
-- 		L	When the `'list'`  option is set, `'wrapmargin'` ,
-- 			`'textwidth'` , `'softtabstop'`  and Virtual Replace mode
-- 			(see |gR|) count a <Tab> as two characters, instead of
-- 			the normal behavior of a <Tab>.
-- 
-- 		m	When included, a showmatch will always wait half a
-- 			second.  When not included, a showmatch will wait half
-- 			a second or until a character is typed.  |`'showmatch'` |
-- 
-- 		M	When excluded, "%" matching will take backslashes into
-- 			account.  Thus in "( \( )" and "\( ( \)" the outer
-- 			parenthesis match.  When included "%" ignores
-- 			backslashes, which is Vi compatible.
-- 
-- 		n	When included, the column used for `'number'`  and
-- 			`'relativenumber'`  will also be used for text of wrapped
-- 			lines.
-- 
-- 		o	Line offset to search command is not remembered for
-- 			next search.
-- 
-- 		O	Don't complain if a file is being overwritten, even
-- 			when it didn't exist when editing it.  This is a
-- 			protection against a file unexpectedly created by
-- 			someone else.  Vi didn't complain about this.
-- 
-- 		p	Vi compatible Lisp indenting.  When not present, a
-- 			slightly better algorithm is used.
-- 
-- 		P	When included, a ":write" command that appends to a
-- 			file will set the file name for the current buffer, if
-- 			the current buffer doesn't have a file name yet and
-- 			the `'F'`  flag is also included |cpo-F|.
-- 
-- 		q	When joining multiple lines leave the cursor at the
-- 			position where it would be when joining two lines.
-- 
-- 		r	Redo ("." command) uses "/" to repeat a search
-- 			command, instead of the actually used search string.
-- 
-- 		R	Remove marks from filtered lines.  Without this flag
-- 			marks are kept like |:keepmarks| was used.
-- 
-- 		s	Set buffer options when entering the buffer for the
-- 			first time.  This is like it is in Vim version 3.0.
-- 			And it is the default.  If not present the options are
-- 			set when the buffer is created.
-- 
-- 		S	Set buffer options always when entering a buffer
-- 			(except `'readonly'` , `'fileformat'` , `'filetype'`  and
-- 			`'syntax'` ).  This is the (most) Vi compatible setting.
-- 			The options are set to the values in the current
-- 			buffer.  When you change an option and go to another
-- 			buffer, the value is copied.  Effectively makes the
-- 			buffer options global to all buffers.
-- 
-- 			`'s'`     `'S'`      copy buffer options
-- 			no     no      when buffer created
-- 			yes    no      when buffer first entered (default)
-- 			 X     yes     each time when buffer entered (vi comp.)
-- 
-- 		t	Search pattern for the tag command is remembered for
-- 			"n" command.  Otherwise Vim only puts the pattern in
-- 			the history for search pattern, but doesn't change the
-- 			last used search pattern.
-- 
-- 		u	Undo is Vi compatible.  See |undo-two-ways|.
-- 
-- 		v	Backspaced characters remain visible on the screen in
-- 			Insert mode.  Without this flag the characters are
-- 			erased from the screen right away.  With this flag the
-- 			screen newly typed text overwrites backspaced
-- 			characters.
-- 
-- 		W	Don't overwrite a readonly file.  When omitted, ":w!"
-- 			overwrites a readonly file, if possible.
-- 
-- 		x	<Esc> on the command-line executes the command-line.
-- 			The default in Vim is to abandon the command-line,
-- 			because <Esc> normally aborts a command.  |c_<Esc>|
-- 
-- 		X	When using a count with "R" the replaced text is
-- 			deleted only once.  Also when repeating "R" with "."
-- 			and a count.
-- 
-- 		y	A yank command can be redone with ".".  Think twice if
-- 			you really want to use this, it may break some
-- 			plugins, since most people expect "." to only repeat a
-- 			change.
-- 
-- 		Z	When using "w!" while the `'readonly'`  option is set,
-- 			don't reset `'readonly'` .
-- 
-- 		!	When redoing a filter command, use the last used
-- 			external command, whatever it was.  Otherwise the last
-- 			used -filter- command is used.
-- 
-- 		$	When making a change to one line, don't redisplay the
-- 			line, but put a `'$'`  at the end of the changed text.
-- 			The changed text will be overwritten when you type the
-- 			new text.  The line is redisplayed if you type any
-- 			command that moves the cursor from the insertion
-- 			point.
-- 
-- 		%	Vi-compatible matching is done for the "%" command.
-- 			Does not recognize "#if", "#endif", etc.
-- 			Does not recognize "/*" and "*/".
-- 			Parens inside single and double quotes are also
-- 			counted, causing a string that contains a paren to
-- 			disturb the matching.  For example, in a line like
-- 			"if (strcmp("foo(", s))" the first paren does not
-- 			match the last one.  When this flag is not included,
-- 			parens inside single and double quotes are treated
-- 			specially.  When matching a paren outside of quotes,
-- 			everything inside quotes is ignored.  When matching a
-- 			paren inside quotes, it will find the matching one (if
-- 			there is one).  This works very well for C programs.
-- 			This flag is also used for other features, such as
-- 			C-indenting.
-- 
-- 		+	When included, a ":write file" command will reset the
-- 			`'modified'`  flag of the buffer, even though the buffer
-- 			itself may still be different from its file.
-- 
-- 		>	When appending to a register, put a line break before
-- 			the appended text.
-- 
-- 		;	When using |,| or |;| to repeat the last |t| search
-- 			and the cursor is right in front of the searched
-- 			character, the cursor won't move. When not included,
-- 			the cursor would skip over it and jump to the
-- 			following occurrence.
-- 
-- 		_	When using |cw| on a word, do not include the
-- 			whitespace following the word in the motion.
--- @class vim.opt.cpoptions: vim.Option,string[]
--- @operator add: vim.opt.cpoptions
--- @operator sub: vim.opt.cpoptions
--- @operator pow: vim.opt.cpoptions
vim.opt.cpoptions = "aABceFs_"
vim.opt.cpo = vim.opt.cpoptions
--- @return string[]
function vim.opt.cpoptions:get()end

-- `'cursorbind'`  `'crb'` 	boolean  (default off)
-- 			local to window
-- 	When this option is set, as the cursor in the current
-- 	window moves other cursorbound windows (windows that also have
-- 	this option set) move their cursors to the corresponding line and
-- 	column.  This option is useful for viewing the
-- 	differences between two versions of a file (see `'diff'` ); in diff mode,
-- 	inserted and deleted lines (though not characters within a line) are
-- 	taken into account.
--- @class vim.opt.cursorbind: vim.Option,boolean
--- @operator add: vim.opt.cursorbind
--- @operator sub: vim.opt.cursorbind
--- @operator pow: vim.opt.cursorbind
vim.opt.cursorbind = false
vim.opt.crb = vim.opt.cursorbind
--- @return boolean
function vim.opt.cursorbind:get()end

-- `'cursorcolumn'`  `'cuc'` 	boolean	(default off)
-- 			local to window
-- 	Highlight the screen column of the cursor with CursorColumn
-- 	|hl-CursorColumn|.  Useful to align text.  Will make screen redrawing
-- 	slower.
-- 	If you only want the highlighting in the current window you can use
-- 	these autocommands: >
-- 		au WinLeave * set nocursorline nocursorcolumn
-- 		au WinEnter * set cursorline cursorcolumn
-- <
--- @class vim.opt.cursorcolumn: vim.Option,boolean
--- @operator add: vim.opt.cursorcolumn
--- @operator sub: vim.opt.cursorcolumn
--- @operator pow: vim.opt.cursorcolumn
vim.opt.cursorcolumn = false
vim.opt.cuc = vim.opt.cursorcolumn
--- @return boolean
function vim.opt.cursorcolumn:get()end

-- `'cursorline'`  `'cul'` 	boolean	(default off)
-- 			local to window
-- 	Highlight the text line of the cursor with CursorLine |hl-CursorLine|.
-- 	Useful to easily spot the cursor.  Will make screen redrawing slower.
-- 	When Visual mode is active the highlighting isn't used to make it
-- 	easier to see the selected text.
--- @class vim.opt.cursorline: vim.Option,boolean
--- @operator add: vim.opt.cursorline
--- @operator sub: vim.opt.cursorline
--- @operator pow: vim.opt.cursorline
vim.opt.cursorline = false
vim.opt.cul = vim.opt.cursorline
--- @return boolean
function vim.opt.cursorline:get()end

-- `'cursorlineopt'`  `'culopt'`  string (default: "number,line")
-- 			local to window
-- 	Comma-separated list of settings for how `'cursorline'`  is displayed.
-- 	Valid values:
-- 	"line"		Highlight the text line of the cursor with
-- 			CursorLine |hl-CursorLine|.
-- 	"screenline"	Highlight only the screen line of the cursor with
-- 			CursorLine |hl-CursorLine|.
-- 	"number"	Highlight the line number of the cursor with
-- 			CursorLineNr |hl-CursorLineNr|.
-- 
-- 	Special value:
-- 	"both"		Alias for the values "line,number".
-- 
-- 	"line" and "screenline" cannot be used together.
--- @class vim.opt.cursorlineopt: vim.Option,string[]
--- @operator add: vim.opt.cursorlineopt
--- @operator sub: vim.opt.cursorlineopt
--- @operator pow: vim.opt.cursorlineopt
vim.opt.cursorlineopt = "both"
vim.opt.culopt = vim.opt.cursorlineopt
--- @return string[]
function vim.opt.cursorlineopt:get()end

-- `'debug'` 			string	(default "")
-- 			global
-- 	These values can be used:
-- 	msg	Error messages that would otherwise be omitted will be given
-- 		anyway.
-- 	throw	Error messages that would otherwise be omitted will be given
-- 		anyway and also throw an exception and set |v:errmsg|.
-- 	beep	A message will be given when otherwise only a beep would be
-- 		produced.
-- 	The values can be combined, separated by a comma.
-- 	"msg" and "throw" are useful for debugging `'foldexpr'` , `'formatexpr'`  or
-- 	`'indentexpr'` .
--- @class vim.opt.debug: vim.Option,string
--- @operator add: vim.opt.debug
--- @operator sub: vim.opt.debug
--- @operator pow: vim.opt.debug
vim.opt.debug = ""
--- @return string
function vim.opt.debug:get()end

-- `'define'`  `'def'` 		string	(default "^\sdefine")
-- 			global or local to buffer |global-local|
-- 	Pattern to be used to find a macro definition.  It is a search
-- 	pattern, just like for the "/" command.  This option is used for the
-- 	commands like "[i" and "[d" |include-search|.  The `'isident'`  option is
-- 	used to recognize the defined name after the match:
-- 		{match with `'define'` }{non-ID chars}{defined name}{non-ID char}
-- 	See |option-backslash| about inserting backslashes to include a space
-- 	or backslash.
-- 	The default value is for C programs.  For C++ this value would be
-- 	useful, to include const type declarations: >
-- 		^\(#\s\s[a-z]*\)
-- <	You can also use "\ze" just before the name and continue the pattern
-- 	to check what is following.  E.g. for Javascript, if a function is
-- 	defined with `func_name = function(args)`: >
-- 		^\s=\s*function(
-- <	If the function is defined with `func_name : function() {...`: >
-- 	        ^\s[:]\sfunction\s*(
-- <	When using the ":set" command, you need to double the backslashes!
-- 	To avoid that use `:let` with a single quote string: >
-- 		let &l:define = `'^\s=\s*function('` 
-- <
--- @class vim.opt.define: vim.Option,string
--- @operator add: vim.opt.define
--- @operator sub: vim.opt.define
--- @operator pow: vim.opt.define
vim.opt.define = "^\\s*#\\s*define"
vim.opt.def = vim.opt.define
--- @return string
function vim.opt.define:get()end

-- `'delcombine'`  `'deco'` 	boolean (default off)
-- 			global
-- 	If editing Unicode and this option is set, backspace and Normal mode
-- 	"x" delete each combining character on its own.  When it is off (the
-- 	default) the character along with its combining characters are
-- 	deleted.
-- 	Note: When `'delcombine'`  is set "xx" may work differently from "2x"!
-- 
-- 	This is useful for Arabic, Hebrew and many other languages where one
-- 	may have combining characters overtop of base characters, and want
-- 	to remove only the combining ones.
--- @class vim.opt.delcombine: vim.Option,boolean
--- @operator add: vim.opt.delcombine
--- @operator sub: vim.opt.delcombine
--- @operator pow: vim.opt.delcombine
vim.opt.delcombine = false
vim.opt.deco = vim.opt.delcombine
--- @return boolean
function vim.opt.delcombine:get()end

-- `'dictionary'`  `'dict'` 	string	(default "")
-- 			global or local to buffer |global-local|
-- 	List of file names, separated by commas, that are used to lookup words
-- 	for keyword completion commands |i_CTRL-X_CTRL-K|.  Each file should
-- 	contain a list of words.  This can be one word per line, or several
-- 	words per line, separated by non-keyword characters (white space is
-- 	preferred).  Maximum line length is 510 bytes.
-- 
-- 	When this option is empty or an entry "spell" is present, and spell
-- 	checking is enabled, words in the word lists for the currently active
-- 	`'spelllang'`  are used. See |spell|.
-- 
-- 	To include a comma in a file name precede it with a backslash.  Spaces
-- 	after a comma are ignored, otherwise spaces are included in the file
-- 	name.  See |option-backslash| about using backslashes.
-- 	This has nothing to do with the |Dictionary| variable type.
-- 	Where to find a list of words?
-- 	- BSD/macOS include the "/usr/share/dict/words" file.
-- 	- Try "apt install spell" to get the "/usr/share/dict/words" file on
-- 	  apt-managed systems (Debian/Ubuntu).
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	directories from the list.  This avoids problems when a future version
-- 	uses another default.
-- 	Backticks cannot be used in this option for security reasons.
--- @class vim.opt.dictionary: vim.Option,string[]
--- @operator add: vim.opt.dictionary
--- @operator sub: vim.opt.dictionary
--- @operator pow: vim.opt.dictionary
vim.opt.dictionary = ""
vim.opt.dict = vim.opt.dictionary
--- @return string[]
function vim.opt.dictionary:get()end

-- `'diff'` 			boolean	(default off)
-- 			local to window
-- 	Join the current window in the group of windows that shows differences
-- 	between files.  See |diff-mode|.
--- @class vim.opt.diff: vim.Option,boolean
--- @operator add: vim.opt.diff
--- @operator sub: vim.opt.diff
--- @operator pow: vim.opt.diff
vim.opt.diff = false
--- @return boolean
function vim.opt.diff:get()end

-- `'diffexpr'`  `'dex'` 	string	(default "")
-- 			global
-- 	Expression which is evaluated to obtain a diff file (either ed-style
-- 	or unified-style) from two versions of a file.  See |diff-diffexpr|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.diffexpr: vim.Option,string
--- @operator add: vim.opt.diffexpr
--- @operator sub: vim.opt.diffexpr
--- @operator pow: vim.opt.diffexpr
vim.opt.diffexpr = ""
vim.opt.dex = vim.opt.diffexpr
--- @return string
function vim.opt.diffexpr:get()end

-- `'diffopt'`  `'dip'` 		string	(default "internal,filler,closeoff")
-- 			global
-- 	Option settings for diff mode.  It can consist of the following items.
-- 	All are optional.  Items must be separated by a comma.
-- 
-- 		filler		Show filler lines, to keep the text
-- 				synchronized with a window that has inserted
-- 				lines at the same position.  Mostly useful
-- 				when windows are side-by-side and `'scrollbind'` 
-- 				is set.
-- 
-- 		context:{n}	Use a context of {n} lines between a change
-- 				and a fold that contains unchanged lines.
-- 				When omitted a context of six lines is used.
-- 				When using zero the context is actually one,
-- 				since folds require a line in between, also
-- 				for a deleted line.
-- 				See |fold-diff|.
-- 
-- 		iblank		Ignore changes where lines are all blank.  Adds
-- 				the "-B" flag to the "diff" command if
-- 				`'diffexpr'`  is empty.  Check the documentation
-- 				of the "diff" command for what this does
-- 				exactly.
-- 				NOTE: the diff windows will get out of sync,
-- 				because no differences between blank lines are
-- 				taken into account.
-- 
-- 		icase		Ignore changes in case of text.  "a" and "A"
-- 				are considered the same.  Adds the "-i" flag
-- 				to the "diff" command if `'diffexpr'`  is empty.
-- 
-- 		iwhite		Ignore changes in amount of white space.  Adds
-- 				the "-b" flag to the "diff" command if
-- 				`'diffexpr'`  is empty.  Check the documentation
-- 				of the "diff" command for what this does
-- 				exactly.  It should ignore adding trailing
-- 				white space, but not leading white space.
-- 
-- 		iwhiteall	Ignore all white space changes.  Adds
-- 				the "-w" flag to the "diff" command if
-- 				`'diffexpr'`  is empty.  Check the documentation
-- 				of the "diff" command for what this does
-- 				exactly.
-- 
-- 		iwhiteeol	Ignore white space changes at end of line.
-- 				Adds the "-Z" flag to the "diff" command if
-- 				`'diffexpr'`  is empty.  Check the documentation
-- 				of the "diff" command for what this does
-- 				exactly.
-- 
-- 		horizontal	Start diff mode with horizontal splits (unless
-- 				explicitly specified otherwise).
-- 
-- 		vertical	Start diff mode with vertical splits (unless
-- 				explicitly specified otherwise).
-- 
-- 		closeoff	When a window is closed where `'diff'`  is set
-- 				and there is only one window remaining in the
-- 				same tab page with `'diff'`  set, execute
-- 				`:diffoff` in that window.  This undoes a
-- 				`:diffsplit` command.
-- 
-- 		hiddenoff	Do not use diff mode for a buffer when it
-- 				becomes hidden.
-- 
-- 		foldcolumn:{n}	Set the `'foldcolumn'`  option to {n} when
-- 				starting diff mode.  Without this 2 is used.
-- 
-- 		followwrap	Follow the `'wrap'`  option and leave as it is.
-- 
-- 		internal	Use the internal diff library.  This is
-- 				ignored when `'diffexpr'`  is set.
-- 				When running out of memory when writing a
-- 				buffer this item will be ignored for diffs
-- 				involving that buffer.  Set the `'verbose'` 
-- 				option to see when this happens.
-- 
-- 		indent-heuristic
-- 				Use the indent heuristic for the internal
-- 				diff library.
-- 
-- 		linematch:{n}   Enable a second stage diff on each generated
-- 				hunk in order to align lines. When the total
-- 				number of lines in a hunk exceeds {n}, the
-- 				second stage diff will not be performed as
-- 				very large hunks can cause noticeable lag. A
-- 				recommended setting is "linematch:60", as this
-- 				will enable alignment for a 2 buffer diff with
-- 				hunks of up to 30 lines each, or a 3 buffer
-- 				diff with hunks of up to 20 lines each.
-- 
--                 algorithm:{text} Use the specified diff algorithm with the
-- 				internal diff engine. Currently supported
-- 				algorithms are:
-- 				myers      the default algorithm
-- 				minimal    spend extra time to generate the
-- 					   smallest possible diff
-- 				patience   patience diff algorithm
-- 				histogram  histogram diff algorithm
-- 
-- 	Examples: >
-- 		:set diffopt=internal,filler,context:4
-- 		:set diffopt=
-- 		:set diffopt=internal,filler,foldcolumn:3
-- 		:set diffopt-=internal  " do NOT use the internal diff parser
-- <
--- @class vim.opt.diffopt: vim.Option,string[]
--- @operator add: vim.opt.diffopt
--- @operator sub: vim.opt.diffopt
--- @operator pow: vim.opt.diffopt
vim.opt.diffopt = "internal,filler,closeoff"
vim.opt.dip = vim.opt.diffopt
--- @return string[]
function vim.opt.diffopt:get()end

-- `'digraph'`  `'dg'` 		boolean	(default off)
-- 			global
-- 	Enable the entering of digraphs in Insert mode with {char1} <BS>
-- 	{char2}.  See |digraphs|.
--- @class vim.opt.digraph: vim.Option,boolean
--- @operator add: vim.opt.digraph
--- @operator sub: vim.opt.digraph
--- @operator pow: vim.opt.digraph
vim.opt.digraph = false
vim.opt.dg = vim.opt.digraph
--- @return boolean
function vim.opt.digraph:get()end

-- `'directory'`  `'dir'` 	string	(default "$XDG_STATE_HOME/nvim/swap//")
-- 			global
-- 	List of directory names for the swap file, separated with commas.
-- 
-- 	Possible items:
-- 	- The swap file will be created in the first directory where this is
-- 	  possible.  If it is not possible in any directory, but last
-- 	  directory listed in the option does not exist, it is created.
-- 	- Empty means that no swap file will be used (recovery is
-- 	  impossible!) and no |E303| error will be given.
-- 	- A directory "." means to put the swap file in the same directory as
-- 	  the edited file.  On Unix, a dot is prepended to the file name, so
-- 	  it doesn't show in a directory listing.  On MS-Windows the "hidden"
-- 	  attribute is set and a dot prepended if possible.
-- 	- A directory starting with "./" (or ".\" for MS-Windows) means to put
-- 	  the swap file relative to where the edited file is.  The leading "."
-- 	  is replaced with the path name of the edited file.
-- 	- For Unix and Win32, if a directory ends in two path separators "//",
-- 	  the swap file name will be built from the complete path to the file
-- 	  with all path separators replaced by percent `'%'`  signs (including
-- 	  the colon following the drive letter on Win32). This will ensure
-- 	  file name uniqueness in the preserve directory.
-- 	  On Win32, it is also possible to end with "\\".  However, When a
-- 	  separating comma is following, you must use "//", since "\\" will
-- 	  include the comma in the file name. Therefore it is recommended to
-- 	  use `'//'` , instead of `'\\'` .
-- 	- Spaces after the comma are ignored, other spaces are considered part
-- 	  of the directory name.  To have a space at the start of a directory
-- 	  name, precede it with a backslash.
-- 	- To include a comma in a directory name precede it with a backslash.
-- 	- A directory name may end in an `':'`  or `'/'` .
-- 	- Environment variables are expanded |:set_env|.
-- 	- Careful with `'\'`  characters, type one before a space, type two to
-- 	  get one in the option (see |option-backslash|), for example: >
-- 	    :set dir=c:\\tmp,\ dir\\,with\\,commas,\\\ dir\ with\ spaces
-- <	- For backwards compatibility with Vim version 3.0 a `'>'`  at the start
-- 	  of the option is removed.
-- 	Using "." first in the list is recommended.  This means that editing
-- 	the same file twice will result in a warning.  Using "/tmp" on Unix is
-- 	discouraged: When the system crashes you lose the swap file.
-- 	"/var/tmp" is often not cleared when rebooting, thus is a better
-- 	choice than "/tmp".  But others on the computer may be able to see the
-- 	files, and it can contain a lot of files, your swap files get lost in
-- 	the crowd.  That is why a "tmp" directory in your home directory is
-- 	tried first.
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	directories from the list.  This avoids problems when a future version
-- 	uses another default.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.directory: vim.Option,string[]
--- @operator add: vim.opt.directory
--- @operator sub: vim.opt.directory
--- @operator pow: vim.opt.directory
vim.opt.directory = "/home/runner/.local/state/nvim/swap//"
vim.opt.dir = vim.opt.directory
--- @return string[]
function vim.opt.directory:get()end

