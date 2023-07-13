---@meta

---@class vim.go
vim.go = {}

vim.go.aleph = 224
vim.go.al = vim.go.aleph
-- `'allowrevins'`  `'ari'` 	boolean	(default off)
-- 			global
-- 	Allow CTRL-_ in Insert and Command-line mode.  This is default off, to
-- 	avoid that users that accidentally type CTRL-_ instead of SHIFT-_ get
-- 	into reverse Insert mode, and don't know how to get out.  See
-- 	`'revins'` .
vim.go.allowrevins = false
vim.go.ari = vim.go.allowrevins
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
vim.go.ambiwidth = "single"
vim.go.ambw = vim.go.ambiwidth
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
vim.go.arabicshape = true
vim.go.arshape = vim.go.arabicshape
-- `'autochdir'`  `'acd'` 	boolean (default off)
-- 			global
-- 	When on, Vim will change the current working directory whenever you
-- 	open a file, switch buffers, delete a buffer or open/close a window.
-- 	It will change to the directory containing the file which was opened
-- 	or selected.  When a buffer has no name it also has no directory, thus
-- 	the current directory won't change when navigating to it.
-- 	Note: When this option is on some plugins may not work.
vim.go.autochdir = false
vim.go.acd = vim.go.autochdir
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
vim.go.autowrite = false
vim.go.aw = vim.go.autowrite
-- `'autowriteall'`  `'awa'` 	boolean	(default off)
-- 			global
-- 	Like `'autowrite'` , but also used for commands ":edit", ":enew", ":quit",
-- 	":qall", ":exit", ":xit", ":recover" and closing the Vim window.
-- 	Setting this option also implies that Vim behaves like `'autowrite'`  has
-- 	been set.
vim.go.autowriteall = false
vim.go.awa = vim.go.autowriteall
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
vim.go.background = "dark"
vim.go.bg = vim.go.background
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
vim.go.backspace = "indent,eol,start"
vim.go.bs = vim.go.backspace
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
vim.go.backup = false
vim.go.bk = vim.go.backup
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
vim.go.backupdir = ".,/home/runner/.local/state/nvim/backup//"
vim.go.bdir = vim.go.backupdir
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
vim.go.backupext = "~"
vim.go.bex = vim.go.backupext
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
vim.go.backupskip = "/tmp/*"
vim.go.bsk = vim.go.backupskip
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
vim.go.belloff = "all"
vim.go.bo = vim.go.belloff
-- `'breakat'`  `'brk'` 		string	(default " ^I!@*-+;:,./?")
-- 			global
-- 	This option lets you choose which characters might cause a line
-- 	break if `'linebreak'`  is on.  Only works for ASCII characters.
vim.go.breakat = " \t!@*-+;:,./?"
vim.go.brk = vim.go.breakat
-- `'browsedir'`  `'bsdir'` 	string	(default: "last")
-- 			global
-- 	Which directory to use for the file browser:
-- 	   last		Use same directory as with last file browser, where a
-- 			file was opened or saved.
-- 	   buffer	Use the directory of the related buffer.
-- 	   current	Use the current directory.
-- 	   {path}	Use the specified directory
vim.go.browsedir = ""
vim.go.bsdir = vim.go.browsedir
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
vim.go.casemap = "internal,keepascii"
vim.go.cmp = vim.go.casemap
-- `'cdhome'`  `'cdh'` 		boolean	(default: off)
-- 			global
-- 	When on, |:cd|, |:tcd| and |:lcd| without an argument changes the
-- 	current working directory to the |$HOME| directory like in Unix.
-- 	When off, those commands just print the current directory name.
-- 	On Unix this option has no effect.
vim.go.cdhome = false
vim.go.cdh = vim.go.cdhome
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
vim.go.cdpath = ",,"
vim.go.cd = vim.go.cdpath
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
vim.go.cedit = "\6"
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
vim.go.charconvert = ""
vim.go.ccv = vim.go.charconvert
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
vim.go.clipboard = ""
vim.go.cb = vim.go.clipboard
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
vim.go.cmdheight = 1
vim.go.ch = vim.go.cmdheight
-- `'cmdwinheight'`  `'cwh'` 	number	(default 7)
-- 			global
-- 	Number of screen lines to use for the command-line window. |cmdwin|
vim.go.cmdwinheight = 7
vim.go.cwh = vim.go.cmdwinheight
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
vim.go.columns = 80
vim.go.co = vim.go.columns
vim.go.compatible = false
vim.go.cp = vim.go.compatible
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
vim.go.completeopt = "menu,preview"
vim.go.cot = vim.go.completeopt
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
vim.go.completeslash = ""
vim.go.csl = vim.go.completeslash
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
vim.go.confirm = false
vim.go.cf = vim.go.confirm
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
vim.go.cpoptions = "aABceFs_"
vim.go.cpo = vim.go.cpoptions
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
vim.go.debug = ""
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
vim.go.delcombine = false
vim.go.deco = vim.go.delcombine
-- `'diffexpr'`  `'dex'` 	string	(default "")
-- 			global
-- 	Expression which is evaluated to obtain a diff file (either ed-style
-- 	or unified-style) from two versions of a file.  See |diff-diffexpr|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.diffexpr = ""
vim.go.dex = vim.go.diffexpr
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
vim.go.diffopt = "internal,filler,closeoff"
vim.go.dip = vim.go.diffopt
-- `'digraph'`  `'dg'` 		boolean	(default off)
-- 			global
-- 	Enable the entering of digraphs in Insert mode with {char1} <BS>
-- 	{char2}.  See |digraphs|.
vim.go.digraph = false
vim.go.dg = vim.go.digraph
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
vim.go.directory = "/home/runner/.local/state/nvim/swap//"
vim.go.dir = vim.go.directory
-- `'display'`  `'dy'` 		string	(default "lastline")
-- 			global
-- 	Change the way text is displayed.  This is a comma-separated list of
-- 	flags:
-- 	lastline	When included, as much as possible of the last line
-- 			in a window will be displayed.  "@@@" is put in the
-- 			last columns of the last screen line to indicate the
-- 			rest of the line is not displayed.
-- 	truncate	Like "lastline", but "@@@" is displayed in the first
-- 			column of the last screen line.  Overrules "lastline".
-- 	uhex		Show unprintable characters hexadecimal as <xx>
-- 			instead of using ^C and ~C.
-- 	msgsep		Obsolete flag. Allowed but takes no effect. |msgsep|
-- 
-- 	When neither "lastline" nor "truncate" is included, a last line that
-- 	doesn't fit is replaced with "@" lines.
-- 
-- 	The "@" character can be changed by setting the "lastline" item in
-- 	`'fillchars'` .  The character is highlighted with |hl-NonText|.
vim.go.display = "lastline"
vim.go.dy = vim.go.display
-- `'eadirection'`  `'ead'` 	string	(default "both")
-- 			global
-- 	Tells when the `'equalalways'`  option applies:
-- 		ver	vertically, width of windows is not affected
-- 		hor	horizontally, height of windows is not affected
-- 		both	width and height of windows is affected
vim.go.eadirection = "both"
vim.go.ead = vim.go.eadirection
vim.go.edcompatible = false
vim.go.ed = vim.go.edcompatible
-- `'emoji'`  `'emo'` 	boolean (default: on)
-- 			global
-- 	When on all Unicode emoji characters are considered to be full width.
-- 	This excludes "text emoji" characters, which are normally displayed as
-- 	single width.  Unfortunately there is no good specification for this
-- 	and it has been determined on trial-and-error basis.  Use the
-- 	|setcellwidths()| function to change the behavior.
vim.go.emoji = true
vim.go.emo = vim.go.emoji
-- `'encoding'`  `'enc'` 
-- 	String-encoding used internally and for |RPC| communication.
-- 	Always UTF-8.
-- 
-- 	See `'fileencoding'`  to control file-content encoding.
vim.go.encoding = "utf-8"
vim.go.enc = vim.go.encoding
-- `'equalalways'`  `'ea'` 	boolean	(default on)
-- 			global
-- 	When on, all the windows are automatically made the same size after
-- 	splitting or closing a window.  This also happens the moment the
-- 	option is switched on.  When off, splitting a window will reduce the
-- 	size of the current window and leave the other windows the same.  When
-- 	closing a window the extra lines are given to the window next to it
-- 	(depending on `'splitbelow'`  and `'splitright'` ).
-- 	When mixing vertically and horizontally split windows, a minimal size
-- 	is computed and some windows may be larger if there is room.  The
-- 	`'eadirection'`  option tells in which direction the size is affected.
-- 	Changing the height and width of a window can be avoided by setting
-- 	`'winfixheight'`  and `'winfixwidth'` , respectively.
-- 	If a window size is specified when creating a new window sizes are
-- 	currently not equalized (it's complicated, but may be implemented in
-- 	the future).
vim.go.equalalways = true
vim.go.ea = vim.go.equalalways
-- `'errorbells'`  `'eb'` 	boolean	(default off)
-- 			global
-- 	Ring the bell (beep or screen flash) for error messages.  This only
-- 	makes a difference for error messages, the bell will be used always
-- 	for a lot of errors without a message (e.g., hitting <Esc> in Normal
-- 	mode).  See `'visualbell'`  to make the bell behave like a screen flash
-- 	or do nothing. See `'belloff'`  to finetune when to ring the bell.
vim.go.errorbells = false
vim.go.eb = vim.go.errorbells
-- `'errorfile'`  `'ef'` 	string	(default: "errors.err")
-- 			global
-- 	Name of the errorfile for the QuickFix mode (see |:cf|).
-- 	When the "-q" command-line argument is used, `'errorfile'`  is set to the
-- 	following argument.  See |-q|.
-- 	NOT used for the ":make" command.  See `'makeef'`  for that.
-- 	Environment variables are expanded |:set_env|.
-- 	See |option-backslash| about including spaces and backslashes.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.errorfile = "errors.err"
vim.go.ef = vim.go.errorfile
-- `'eventignore'`  `'ei'` 	string	(default "")
-- 			global
-- 	A list of autocommand event names, which are to be ignored.
-- 	When set to "all" or when "all" is one of the items, all autocommand
-- 	events are ignored, autocommands will not be executed.
-- 	Otherwise this is a comma-separated list of event names.  Example: >
-- 	    :set ei=WinEnter,WinLeave
-- <
vim.go.eventignore = ""
vim.go.ei = vim.go.eventignore
-- `'exrc'`  `'ex'` 		boolean (default off)
-- 			global
-- 	Automatically execute .nvim.lua, .nvimrc, and .exrc files in the
-- 	current directory, if the file is in the |trust| list. Use |:trust| to
-- 	manage trusted files. See also |vim.secure.read()|.
-- 
-- 	Compare `'exrc'`  to |editorconfig|:
-- 	- `'exrc'`  can execute any code; editorconfig only specifies settings.
-- 	- `'exrc'`  is Nvim-specific; editorconfig works in other editors.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.exrc = false
vim.go.ex = vim.go.exrc
-- `'fileencodings'`  `'fencs'` 	string (default: "ucs-bom,utf-8,default,latin1")
-- 			global
-- 	This is a list of character encodings considered when starting to edit
-- 	an existing file.  When a file is read, Vim tries to use the first
-- 	mentioned character encoding.  If an error is detected, the next one
-- 	in the list is tried.  When an encoding is found that works,
-- 	`'fileencoding'`  is set to it.  If all fail, `'fileencoding'`  is set to
-- 	an empty string, which means that UTF-8 is used.
-- 		WARNING: Conversion can cause loss of information! You can use
-- 		the |++bad| argument to specify what is done with characters
-- 		that can't be converted.
-- 	For an empty file or a file with only ASCII characters most encodings
-- 	will work and the first entry of `'fileencodings'`  will be used (except
-- 	"ucs-bom", which requires the BOM to be present).  If you prefer
-- 	another encoding use an BufReadPost autocommand event to test if your
-- 	preferred encoding is to be used.  Example: >
-- 		au BufReadPost * if search(`'\S'` , `'w'` ) == 0 |
-- 			\ set fenc=iso-2022-jp | endif
-- <	This sets `'fileencoding'`  to "iso-2022-jp" if the file does not contain
-- 	non-blank characters.
-- 	When the |++enc| argument is used then the value of `'fileencodings'`  is
-- 	not used.
-- 	Note that `'fileencodings'`  is not used for a new file, the global value
-- 	of `'fileencoding'`  is used instead.  You can set it with: >
-- 		:setglobal fenc=iso-8859-2
-- <	This means that a non-existing file may get a different encoding than
-- 	an empty file.
-- 	The special value "ucs-bom" can be used to check for a Unicode BOM
-- 	(Byte Order Mark) at the start of the file.  It must not be preceded
-- 	by "utf-8" or another Unicode encoding for this to work properly.
-- 	An entry for an 8-bit encoding (e.g., "latin1") should be the last,
-- 	because Vim cannot detect an error, thus the encoding is always
-- 	accepted.
-- 	The special value "default" can be used for the encoding from the
-- 	environment.  It is useful when your environment uses a non-latin1
-- 	encoding, such as Russian.
-- 	When a file contains an illegal UTF-8 byte sequence it won't be
-- 	recognized as "utf-8".  You can use the |8g8| command to find the
-- 	illegal byte sequence.
-- 	WRONG VALUES:			WHAT'S WRONG:
-- 		latin1,utf-8		"latin1" will always be used
-- 		utf-8,ucs-bom,latin1	BOM won't be recognized in an utf-8
-- 					file
-- 		cp1250,latin1		"cp1250" will always be used
-- 	If `'fileencodings'`  is empty, `'fileencoding'`  is not modified.
-- 	See `'fileencoding'`  for the possible values.
-- 	Setting this option does not have an effect until the next time a file
-- 	is read.
vim.go.fileencodings = "ucs-bom,utf-8,default,latin1"
vim.go.fencs = vim.go.fileencodings
-- `'fileformats'`  `'ffs'` 	string (default:
-- 				Win32: "dos,unix",
-- 				Unix: "unix,dos")
-- 			global
-- 	This gives the end-of-line (<EOL>) formats that will be tried when
-- 	starting to edit a new buffer and when reading a file into an existing
-- 	buffer:
-- 	- When empty, the format defined with `'fileformat'`  will be used
-- 	  always.  It is not set automatically.
-- 	- When set to one name, that format will be used whenever a new buffer
-- 	  is opened.  `'fileformat'`  is set accordingly for that buffer.  The
-- 	  `'fileformats'`  name will be used when a file is read into an existing
-- 	  buffer, no matter what `'fileformat'`  for that buffer is set to.
-- 	- When more than one name is present, separated by commas, automatic
-- 	  <EOL> detection will be done when reading a file.  When starting to
-- 	  edit a file, a check is done for the <EOL>:
-- 	  1. If all lines end in <CR><NL>, and `'fileformats'`  includes "dos",
-- 	     `'fileformat'`  is set to "dos".
-- 	  2. If a <NL> is found and `'fileformats'`  includes "unix", `'fileformat'` 
-- 	     is set to "unix".  Note that when a <NL> is found without a
-- 	     preceding <CR>, "unix" is preferred over "dos".
-- 	  3. If `'fileformat'`  has not yet been set, and if a <CR> is found, and
-- 	     if `'fileformats'`  includes "mac", `'fileformat'`  is set to "mac".
-- 	     This means that "mac" is only chosen when:
-- 	      "unix" is not present or no <NL> is found in the file, and
-- 	      "dos" is not present or no <CR><NL> is found in the file.
-- 	     Except: if "unix" was chosen, but there is a <CR> before
-- 	     the first <NL>, and there appear to be more <CR>s than <NL>s in
-- 	     the first few lines, "mac" is used.
-- 	  4. If `'fileformat'`  is still not set, the first name from
-- 	     `'fileformats'`  is used.
-- 	  When reading a file into an existing buffer, the same is done, but
-- 	  this happens like `'fileformat'`  has been set appropriately for that
-- 	  file only, the option is not changed.
-- 	When `'binary'`  is set, the value of `'fileformats'`  is not used.
-- 
-- 	When Vim starts up with an empty buffer the first item is used.  You
-- 	can overrule this by setting `'fileformat'`  in your .vimrc.
-- 
-- 	For systems with a Dos-like <EOL> (<CR><NL>), when reading files that
-- 	are ":source"ed and for vimrc files, automatic <EOL> detection may be
-- 	done:
-- 	- When `'fileformats'`  is empty, there is no automatic detection.  Dos
-- 	  format will be used.
-- 	- When `'fileformats'`  is set to one or more names, automatic detection
-- 	  is done.  This is based on the first <NL> in the file: If there is a
-- 	  <CR> in front of it, Dos format is used, otherwise Unix format is
-- 	  used.
-- 	Also see |file-formats|.
vim.go.fileformats = "unix,dos"
vim.go.ffs = vim.go.fileformats
-- `'fileignorecase'`  `'fic'` 	boolean	(default on for systems where case in file
-- 				 names is normally ignored)
-- 			global
-- 	When set case is ignored when using file names and directories.
-- 	See `'wildignorecase'`  for only ignoring case when doing completion.
vim.go.fileignorecase = false
vim.go.fic = vim.go.fileignorecase
-- `'foldclose'`  `'fcl'` 	string (default "")
-- 			global
-- 	When set to "all", a fold is closed when the cursor isn't in it and
-- 	its level is higher than `'foldlevel'` .  Useful if you want folds to
-- 	automatically close when moving out of them.
vim.go.foldclose = ""
vim.go.fcl = vim.go.foldclose
-- `'foldlevelstart'`  `'fdls'` 	number (default: -1)
-- 			global
-- 	Sets `'foldlevel'`  when starting to edit another buffer in a window.
-- 	Useful to always start editing with all folds closed (value zero),
-- 	some folds closed (one) or no folds closed (99).
-- 	This is done before reading any modeline, thus a setting in a modeline
-- 	overrules this option.  Starting to edit a file for |diff-mode| also
-- 	ignores this option and closes all folds.
-- 	It is also done before BufReadPre autocommands, to allow an autocmd to
-- 	overrule the `'foldlevel'`  value for specific files.
-- 	When the value is negative, it is not used.
vim.go.foldlevelstart = -1
vim.go.fdls = vim.go.foldlevelstart
-- `'foldopen'`  `'fdo'` 	string (default: "block,hor,mark,percent,quickfix,
-- 							     search,tag,undo")
-- 			global
-- 	Specifies for which type of commands folds will be opened, if the
-- 	command moves the cursor into a closed fold.  It is a comma-separated
-- 	list of items.
-- 	NOTE: When the command is part of a mapping this option is not used.
-- 	Add the |zv| command to the mapping to get the same effect.
-- 	(rationale: the mapping may want to control opening folds itself)
-- 
-- 		item		commands ~
-- 		all		any
-- 		block		"(", "{", "[[", "[{", etc.
-- 		hor		horizontal movements: "l", "w", "fx", etc.
-- 		insert		any command in Insert mode
-- 		jump		far jumps: "G", "gg", etc.
-- 		mark		jumping to a mark: "'m", CTRL-O, etc.
-- 		percent		"%"
-- 		quickfix	":cn", ":crew", ":make", etc.
-- 		search		search for a pattern: "/", "n", "*", "gd", etc.
-- 				(not for a search pattern in a ":" command)
-- 				Also for |[s| and |]s|.
-- 		tag		jumping to a tag: ":ta", CTRL-T, etc.
-- 		undo		undo or redo: "u" and CTRL-R
-- 	When a movement command is used for an operator (e.g., "dl" or "y%")
-- 	this option is not used.  This means the operator will include the
-- 	whole closed fold.
-- 	Note that vertical movements are not here, because it would make it
-- 	very difficult to move onto a closed fold.
-- 	In insert mode the folds containing the cursor will always be open
-- 	when text is inserted.
-- 	To close folds you can re-apply `'foldlevel'`  with the |zx| command or
-- 	set the `'foldclose'`  option to "all".
vim.go.foldopen = "block,hor,mark,percent,quickfix,search,tag,undo"
vim.go.fdo = vim.go.foldopen
-- `'fsync'`  `'fs'` 		boolean	(default off)
-- 			global
-- 	When on, the OS function fsync() will be called after saving a file
-- 	(|:write|, |writefile()|, …), |swap-file|, |undo-persistence| and |shada-file|.
-- 	This flushes the file to disk, ensuring that it is safely written.
-- 	Slow on some systems: writing buffers, quitting Nvim, and other
-- 	operations may sometimes take a few seconds.
-- 
-- 	Files are ALWAYS flushed (`'fsync'`  is ignored) when:
-- 	- |CursorHold| event is triggered
-- 	- |:preserve| is called
-- 	- system signals low battery life
-- 	- Nvim exits abnormally
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.fsync = false
vim.go.fs = vim.go.fsync
-- `'gdefault'`  `'gd'` 		boolean	(default off)
-- 			global
-- 	When on, the ":substitute" flag `'g'`  is default on.  This means that
-- 	all matches in a line are substituted instead of one.  When a `'g'`  flag
-- 	is given to a ":substitute" command, this will toggle the substitution
-- 	of all or one match.  See |complex-change|.
-- 
-- 		command		`'gdefault'`  on	`'gdefault'`  off	~
-- 		:s///		  subst. all	  subst. one
-- 		:s///g		  subst. one	  subst. all
-- 		:s///gg		  subst. all	  subst. one
-- 
-- 	DEPRECATED: Setting this option may break plugins that are not aware
-- 	of this option.  Also, many users get confused that adding the /g flag
-- 	has the opposite effect of that it normally does.
vim.go.gdefault = false
vim.go.gd = vim.go.gdefault
-- `'grepformat'`  `'gfm'` 	string	(default "%f:%l:%m,%f:%l%m,%f  %l%m")
-- 			global
-- 	Format to recognize for the ":grep" command output.
-- 	This is a scanf-like string that uses the same format as the
-- 	`'errorformat'`  option: see |errorformat|.
vim.go.grepformat = "%f:%l:%m,%f:%l%m,%f  %l%m"
vim.go.gfm = vim.go.grepformat
-- `'guicursor'`  `'gcr'` 	string	(default "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20")
-- 			global
-- 	Configures the cursor style for each mode. Works in the GUI and many
-- 	terminals.  See |tui-cursor-shape|.
-- 
-- 	To disable cursor-styling, reset the option: >
-- 		:set guicursor=
-- 
-- <	To enable mode shapes, "Cursor" highlight, and blinking: >
-- 		:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
-- 		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
-- 		  \,sm:block-blinkwait175-blinkoff150-blinkon175
-- 
-- <	The option is a comma-separated list of parts.  Each part consists of a
-- 	mode-list and an argument-list:
-- 		mode-list:argument-list,mode-list:argument-list,..
-- 	The mode-list is a dash separated list of these modes:
-- 		n	Normal mode
-- 		v	Visual mode
-- 		ve	Visual mode with `'selection'`  "exclusive" (same as `'v'` ,
-- 			if not specified)
-- 		o	Operator-pending mode
-- 		i	Insert mode
-- 		r	Replace mode
-- 		c	Command-line Normal (append) mode
-- 		ci	Command-line Insert mode
-- 		cr	Command-line Replace mode
-- 		sm	showmatch in Insert mode
-- 		a	all modes
-- 	The argument-list is a dash separated list of these arguments:
-- 		hor{N}	horizontal bar, {N} percent of the character height
-- 		ver{N}	vertical bar, {N} percent of the character width
-- 		block	block cursor, fills the whole character
-- 			- Only one of the above three should be present.
-- 			- Default is "block" for each mode.
-- 		blinkwait{N}
-- 		blinkon{N}
-- 		blinkoff{N}
-- 			blink times for cursor: blinkwait is the delay before
-- 			the cursor starts blinking, blinkon is the time that
-- 			the cursor is shown and blinkoff is the time that the
-- 			cursor is not shown.  Times are in msec.  When one of
-- 			the numbers is zero, there is no blinking. E.g.: >
-- 				:set guicursor=n:blinkon0
-- <			- Default is "blinkon0" for each mode.
-- 		{group-name}
-- 			Highlight group that decides the color and font of the
-- 			cursor.
-- 			In the |TUI|:
-- 			- |inverse|/reverse and no group-name are interpreted
-- 			  as "host-terminal default cursor colors" which
-- 			  typically means "inverted bg and fg colors".
-- 			- |ctermfg| and |guifg| are ignored.
-- 		{group-name}/{group-name}
-- 			Two highlight group names, the first is used when
-- 			no language mappings are used, the other when they
-- 			are. |language-mapping|
-- 
-- 	Examples of parts:
-- 	   n-c-v:block-nCursor	In Normal, Command-line and Visual mode, use a
-- 				block cursor with colors from the "nCursor"
-- 				highlight group
-- 	   n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20
-- 				In Normal et al. modes, use a block cursor
-- 				with the default colors defined by the host
-- 				terminal.  In Insert-likes modes, use
-- 				a vertical bar cursor with colors from
-- 				"Cursor" highlight group.  In Replace-likes
-- 				modes, use a underline cursor with
-- 				default colors.
-- 	   i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150
-- 				In Insert and Command-line Insert mode, use a
-- 				30% vertical bar cursor with colors from the
-- 				"iCursor" highlight group.  Blink a bit
-- 				faster.
-- 
-- 	The `'a'`  mode is different.  It will set the given argument-list for
-- 	all modes.  It does not reset anything to defaults.  This can be used
-- 	to do a common setting for all modes.  For example, to switch off
-- 	blinking: "a:blinkon0"
-- 
-- 	Examples of cursor highlighting: >
-- 	    :highlight Cursor gui=reverse guifg=NONE guibg=NONE
-- 	    :highlight Cursor gui=NONE guifg=bg guibg=fg
-- <
vim.go.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.go.gcr = vim.go.guicursor
-- `'guifont'`  `'gfn'` 		string	(default "")
-- 			global
-- 	This is a list of fonts which will be used for the GUI version of Vim.
-- 	In its simplest form the value is just one font name.  When
-- 	the font cannot be found you will get an error message.  To try other
-- 	font names a list can be specified, font names separated with commas.
-- 	The first valid font is used.
-- 
-- 	Spaces after a comma are ignored.  To include a comma in a font name
-- 	precede it with a backslash.  Setting an option requires an extra
-- 	backslash before a space and a backslash.  See also
-- 	|option-backslash|.  For example: >
-- 	    :set guifont=Screen15,\ 7x13,font\\,with\\,commas
-- <	will make Vim try to use the font "Screen15" first, and if it fails it
-- 	will try to use "7x13" and then "font,with,commas" instead.
-- 
-- 	If none of the fonts can be loaded, Vim will keep the current setting.
-- 	If an empty font list is given, Vim will try using other resource
-- 	settings (for X, it will use the Vim.font resource), and finally it
-- 	will try some builtin default which should always be there ("7x13" in
-- 	the case of X).  The font names given should be "normal" fonts.  Vim
-- 	will try to find the related bold and italic fonts.
-- 
-- 	For Win32 and Mac OS: >
-- 	    :set guifont=*
-- <	will bring up a font requester, where you can pick the font you want.
-- 
-- 	The font name depends on the GUI used.
-- 
-- 	For Mac OSX you can use something like this: >
-- 	    :set guifont=Monaco:h10
-- <
-- 	Note that the fonts must be mono-spaced (all characters have the same
-- 	width).
-- 
-- 	To preview a font on X11, you might be able to use the "xfontsel"
-- 	program.  The "xlsfonts" program gives a list of all available fonts.
-- 
-- 	For the Win32 GUI
-- 	- takes these options in the font name:
-- 		hXX - height is XX (points, can be floating-point)
-- 		wXX - width is XX (points, can be floating-point)
-- 		b   - bold
-- 		i   - italic
-- 		u   - underline
-- 		s   - strikeout
-- 		cXX - character set XX.  Valid charsets are: ANSI, ARABIC,
-- 		      BALTIC, CHINESEBIG5, DEFAULT, EASTEUROPE, GB2312, GREEK,
-- 		      HANGEUL, HEBREW, JOHAB, MAC, OEM, RUSSIAN, SHIFTJIS,
-- 		      SYMBOL, THAI, TURKISH, VIETNAMESE ANSI and BALTIC.
-- 		      Normally you would use "cDEFAULT".
-- 
-- 	  Use a `':'`  to separate the options.
-- 	- A `'_'`  can be used in the place of a space, so you don't need to use
-- 	  backslashes to escape the spaces.
-- 	- Examples: >
-- 	    :set guifont=courier_new:h12:w5:b:cRUSSIAN
-- 	    :set guifont=Andale_Mono:h7.5:w4.5
-- <
vim.go.guifont = ""
vim.go.gfn = vim.go.guifont
-- `'guifontwide'`  `'gfw'` 	string	(default "")
-- 			global
-- 	Comma-separated list of fonts to be used for double-width characters.
-- 	The first font that can be loaded is used.
-- 	Note: The size of these fonts must be exactly twice as wide as the one
-- 	specified with `'guifont'`  and the same height.
-- 
-- 	When `'guifont'`  has a valid font and `'guifontwide'`  is empty Vim will
-- 	attempt to set `'guifontwide'`  to a matching double-width font.
vim.go.guifontwide = ""
vim.go.gfw = vim.go.guifontwide
-- `'guioptions'`  `'go'` 	string	(default "egmrLT"   (MS-Windows))
-- 			global
-- 	This option only has an effect in the GUI version of Vim.  It is a
-- 	sequence of letters which describes what components and options of the
-- 	GUI should be used.
-- 	To avoid problems with flags that are added in the future, use the
-- 	"+=" and "-=" feature of ":set" |add-option-flags|.
-- 
-- 	Valid letters are as follows:
-- 
-- 	  `'a'` 	Autoselect:  If present, then whenever VISUAL mode is started,
-- 		or the Visual area extended, Vim tries to become the owner of
-- 		the windowing system's global selection.  This means that the
-- 		Visually highlighted text is available for pasting into other
-- 		applications as well as into Vim itself.  When the Visual mode
-- 		ends, possibly due to an operation on the text, or when an
-- 		application wants to paste the selection, the highlighted text
-- 		is automatically yanked into the "* selection register.
-- 		Thus the selection is still available for pasting into other
-- 		applications after the VISUAL mode has ended.
-- 		    If not present, then Vim won't become the owner of the
-- 		windowing system's global selection unless explicitly told to
-- 		by a yank or delete operation for the "* register.
-- 		The same applies to the modeless selection.
-- 
-- 	  `'P'` 	Like autoselect but using the "+ register instead of the "*
-- 		register.
-- 
-- 	  `'A'` 	Autoselect for the modeless selection.  Like `'a'` , but only
-- 		applies to the modeless selection.
-- 
-- 		    `'guioptions'`    autoselect Visual  autoselect modeless ~
-- 			 ""		 -			 -
-- 			 "a"		yes			yes
-- 			 "A"		 -			yes
-- 			 "aA"		yes			yes
-- 
-- 
-- 	  `'c'` 	Use console dialogs instead of popup dialogs for simple
-- 		choices.
-- 
-- 	  `'d'` 	Use dark theme variant if available.
-- 
-- 	  `'e'` 	Add tab pages when indicated with `'showtabline'` .
-- 		`'guitablabel'`  can be used to change the text in the labels.
-- 		When `'e'`  is missing a non-GUI tab pages line may be used.
-- 		The GUI tabs are only supported on some systems, currently
-- 		Mac OS/X and MS-Windows.
-- 
-- 	  `'i'` 	Use a Vim icon.
-- 
-- 	  `'m'` 	Menu bar is present.
-- 
-- 	  `'M'` 	The system menu "$VIMRUNTIME/menu.vim" is not sourced.  Note
-- 		that this flag must be added in the vimrc file, before
-- 		switching on syntax or filetype recognition (when the |gvimrc|
-- 		file is sourced the system menu has already been loaded; the
-- 		`:syntax on` and `:filetype on` commands load the menu too).
-- 
-- 	  `'g'` 	Grey menu items: Make menu items that are not active grey.  If
-- 		`'g'`  is not included inactive menu items are not shown at all.
-- 
-- 	  `'T'` 	Include Toolbar.  Currently only in Win32 GUI.
-- 
-- 	  `'r'` 	Right-hand scrollbar is always present.
-- 
-- 	  `'R'` 	Right-hand scrollbar is present when there is a vertically
-- 		split window.
-- 
-- 	  `'l'` 	Left-hand scrollbar is always present.
-- 
-- 	  `'L'` 	Left-hand scrollbar is present when there is a vertically
-- 		split window.
-- 
-- 	  `'b'` 	Bottom (horizontal) scrollbar is present.  Its size depends on
-- 		the longest visible line, or on the cursor line if the `'h'` 
-- 		flag is included. |gui-horiz-scroll|
-- 
-- 	  `'h'` 	Limit horizontal scrollbar size to the length of the cursor
-- 		line.  Reduces computations. |gui-horiz-scroll|
-- 
-- 	And yes, you may even have scrollbars on the left AND the right if
-- 	you really want to :-).  See |gui-scrollbars| for more information.
-- 
-- 
-- 	  `'v'` 	Use a vertical button layout for dialogs.  When not included,
-- 		a horizontal layout is preferred, but when it doesn't fit a
-- 		vertical layout is used anyway.  Not supported in GTK 3.
-- 
-- 	  `'p'` 	Use Pointer callbacks for X11 GUI.  This is required for some
-- 		window managers.  If the cursor is not blinking or hollow at
-- 		the right moment, try adding this flag.  This must be done
-- 		before starting the GUI.  Set it in your |gvimrc|.  Adding or
-- 		removing it after the GUI has started has no effect.
-- 
-- 	  `'k'` 	Keep the GUI window size when adding/removing a scrollbar, or
-- 		toolbar, tabline, etc.  Instead, the behavior is similar to
-- 		when the window is maximized and will adjust `'lines'`  and
-- 		`'columns'`  to fit to the window.  Without the `'k'`  flag Vim will
-- 		try to keep `'lines'`  and `'columns'`  the same when adding and
-- 		removing GUI components.
vim.go.guioptions = ""
vim.go.go = vim.go.guioptions
-- `'guitablabel'`  `'gtl'` 	string	(default empty)
-- 			global
-- 	When non-empty describes the text to use in a label of the GUI tab
-- 	pages line.  When empty and when the result is empty Vim will use a
-- 	default label.  See |setting-guitablabel| for more info.
-- 
-- 	The format of this option is like that of `'statusline'` .
-- 	`'guitabtooltip'`  is used for the tooltip, see below.
-- 	The expression will be evaluated in the |sandbox| when set from a
-- 	modeline, see |sandbox-option|.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	Only used when the GUI tab pages line is displayed.  `'e'`  must be
-- 	present in `'guioptions'` .  For the non-GUI tab pages line `'tabline'`  is
-- 	used.
vim.go.guitablabel = ""
vim.go.gtl = vim.go.guitablabel
-- `'guitabtooltip'`  `'gtt'` 	string	(default empty)
-- 			global
-- 	When non-empty describes the text to use in a tooltip for the GUI tab
-- 	pages line.  When empty Vim will use a default tooltip.
-- 	This option is otherwise just like `'guitablabel'`  above.
-- 	You can include a line break.  Simplest method is to use |:let|: >
-- 		:let &guitabtooltip = "line one\nline two"
-- <
vim.go.guitabtooltip = ""
vim.go.gtt = vim.go.guitabtooltip
-- `'helpfile'`  `'hf'` 		string	(default (MS-Windows) "$VIMRUNTIME\doc\help.txt"
-- 					 (others) "$VIMRUNTIME/doc/help.txt")
-- 			global
-- 	Name of the main help file.  All distributed help files should be
-- 	placed together in one directory.  Additionally, all "doc" directories
-- 	in `'runtimepath'`  will be used.
-- 	Environment variables are expanded |:set_env|.  For example:
-- 	"$VIMRUNTIME/doc/help.txt".  If $VIMRUNTIME is not set, $VIM is also
-- 	tried.  Also see |$VIMRUNTIME| and |option-backslash| about including
-- 	spaces and backslashes.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.helpfile = "/tmp/nvim/squashfs-root/usr/share/nvim/runtime/doc/help.txt"
vim.go.hf = vim.go.helpfile
-- `'helpheight'`  `'hh'` 	number	(default 20)
-- 			global
-- 	Minimal initial height of the help window when it is opened with the
-- 	":help" command.  The initial height of the help window is half of the
-- 	current window, or (when the `'ea'`  option is on) the same as other
-- 	windows.  When the height is less than `'helpheight'` , the height is
-- 	set to `'helpheight'` .  Set to zero to disable.
vim.go.helpheight = 20
vim.go.hh = vim.go.helpheight
-- `'helplang'`  `'hlg'` 	string	(default: messages language or empty)
-- 			global
-- 	Comma-separated list of languages.  Vim will use the first language
-- 	for which the desired help can be found.  The English help will always
-- 	be used as a last resort.  You can add "en" to prefer English over
-- 	another language, but that will only find tags that exist in that
-- 	language and not in the English help.
-- 	Example: >
-- 		:set helplang=de,it
-- <	This will first search German, then Italian and finally English help
-- 	files.
-- 	When using |CTRL-]| and ":help!" in a non-English help file Vim will
-- 	try to find the tag in the current language before using this option.
-- 	See |help-translated|.
vim.go.helplang = ""
vim.go.hlg = vim.go.helplang
-- `'hidden'`  `'hid'` 		boolean	(default on)
-- 			global
-- 	When off a buffer is unloaded (including loss of undo information)
-- 	when it is |abandon|ed.  When on a buffer becomes hidden when it is
-- 	|abandon|ed.  A buffer displayed in another window does not become
-- 	hidden, of course.
-- 
-- 	Commands that move through the buffer list sometimes hide a buffer
-- 	although the `'hidden'`  option is off when these three are true:
-- 	- the buffer is modified
-- 	- `'autowrite'`  is off or writing is not possible
-- 	- the `'!'`  flag was used
-- 	Also see |windows|.
-- 
-- 	To hide a specific buffer use the `'bufhidden'`  option.
-- 	`'hidden'`  is set for one command with ":hide {command}" |:hide|.
vim.go.hidden = true
vim.go.hid = vim.go.hidden
vim.go.highlight = "8:SpecialKey,~:EndOfBuffer,z:TermCursor,Z:TermCursorNC,@:NonText,d:Directory,e:ErrorMsg,i:IncSearch,l:Search,y:CurSearch,m:MoreMsg,M:ModeMsg,n:LineNr,a:LineNrAbove,b:LineNrBelow,N:CursorLineNr,G:CursorLineSign,O:CursorLineFoldr:Question,s:StatusLine,S:StatusLineNC,c:VertSplit,t:Title,v:Visual,V:VisualNOS,w:WarningMsg,W:WildMenu,f:Folded,F:FoldColumn,A:DiffAdd,C:DiffChange,D:DiffDelete,T:DiffText,>:SignColumn,-:Conceal,B:SpellBad,P:SpellCap,R:SpellRare,L:SpellLocal,+:Pmenu,=:PmenuSel,[:PmenuKind,]:PmenuKindSel,{:PmenuExtra,}:PmenuExtraSel,x:PmenuSbar,X:PmenuThumb,*:TabLine,#:TabLineSel,_:TabLineFill,!:CursorColumn,.:CursorLine,o:ColorColumn,q:QuickFixLine,0:Whitespace,I:NormalNC"
vim.go.hl = vim.go.highlight
-- `'history'`  `'hi'` 		number	(default: 10000)
-- 			global
-- 	A history of ":" commands, and a history of previous search patterns
-- 	is remembered.  This option decides how many entries may be stored in
-- 	each of these histories (see |cmdline-editing|).
-- 	The maximum value is 10000.
vim.go.history = 10000
vim.go.hi = vim.go.history
vim.go.hkmap = false
vim.go.hk = vim.go.hkmap
vim.go.hkmapp = false
vim.go.hkp = vim.go.hkmapp
-- `'hlsearch'`  `'hls'` 	boolean	(default on)
-- 			global
-- 	When there is a previous search pattern, highlight all its matches.
-- 	The |hl-Search| highlight group determines the highlighting for all
-- 	matches not under the cursor while the |hl-CurSearch| highlight group
-- 	(if defined) determines the highlighting for the match under the
-- 	cursor. If |hl-CurSearch| is not defined, then |hl-Search| is used for
-- 	both. Note that only the matching text is highlighted, any offsets
-- 	are not applied.
-- 	See also: `'incsearch'`  and |:match|.
-- 	When you get bored looking at the highlighted matches, you can turn it
-- 	off with |:nohlsearch|.  This does not change the option value, as
-- 	soon as you use a search command, the highlighting comes back.
-- 	`'redrawtime'`  specifies the maximum time spent on finding matches.
-- 	When the search pattern can match an end-of-line, Vim will try to
-- 	highlight all of the matched text.  However, this depends on where the
-- 	search starts.  This will be the first line in the window or the first
-- 	line below a closed fold.  A match in a previous line which is not
-- 	drawn may not continue in a newly drawn line.
-- 	You can specify whether the highlight status is restored on startup
-- 	with the `'h'`  flag in `'shada'`  |shada-h|.
vim.go.hlsearch = true
vim.go.hls = vim.go.hlsearch
-- `'icon'` 			boolean	(default off, on when title can be restored)
-- 			global
-- 	When on, the icon text of the window will be set to the value of
-- 	`'iconstring'`  (if it is not empty), or to the name of the file
-- 	currently being edited.  Only the last part of the name is used.
-- 	Overridden by the `'iconstring'`  option.
-- 	Only works if the terminal supports setting window icons.
vim.go.icon = false
-- `'iconstring'` 		string	(default "")
-- 			global
-- 	When this option is not empty, it will be used for the icon text of
-- 	the window.  This happens only when the `'icon'`  option is on.
-- 	Only works if the terminal supports setting window icon text
-- 	When this option contains printf-style `'%'`  items, they will be
-- 	expanded according to the rules used for `'statusline'` .  See
-- 	`'titlestring'`  for example settings.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
vim.go.iconstring = ""
-- `'ignorecase'`  `'ic'` 	boolean	(default off)
-- 			global
-- 	Ignore case in search patterns.  Also used when searching in the tags
-- 	file.
-- 	Also see `'smartcase'`  and `'tagcase'` .
-- 	Can be overruled by using "\c" or "\C" in the pattern, see
-- 	|/ignorecase|.
vim.go.ignorecase = false
vim.go.ic = vim.go.ignorecase
-- `'imcmdline'`  `'imc'` 	boolean (default off)
-- 			global
-- 	When set the Input Method is always on when starting to edit a command
-- 	line, unless entering a search pattern (see `'imsearch'`  for that).
-- 	Setting this option is useful when your input method allows entering
-- 	English characters directly, e.g., when it's used to type accented
-- 	characters with dead keys.
vim.go.imcmdline = false
vim.go.imc = vim.go.imcmdline
-- `'imdisable'`  `'imd'` 	boolean (default off, on for some systems (SGI))
-- 			global
-- 	When set the Input Method is never used.  This is useful to disable
-- 	the IM when it doesn't work properly.
-- 	Currently this option is on by default for SGI/IRIX machines.  This
-- 	may change in later releases.
vim.go.imdisable = false
vim.go.imd = vim.go.imdisable
-- `'inccommand'`  `'icm'` 	string	(default "nosplit")
-- 			global
-- 
-- 	When nonempty, shows the effects of |:substitute|, |:smagic|,
-- 	|:snomagic| and user commands with the |:command-preview| flag as you
-- 	type.
-- 
-- 	Possible values:
-- 		nosplit	Shows the effects of a command incrementally in the
-- 			buffer.
-- 		split	Like "nosplit", but also shows partial off-screen
-- 			results in a preview window.
-- 
-- 	If the preview for built-in commands is too slow (exceeds
-- 	`'redrawtime'` ) then `'inccommand'`  is automatically disabled until
-- 	|Command-line-mode| is done.
vim.go.inccommand = "nosplit"
vim.go.icm = vim.go.inccommand
-- `'incsearch'`  `'is'` 	boolean	(default on)
-- 			global
-- 	While typing a search command, show where the pattern, as it was typed
-- 	so far, matches.  The matched string is highlighted.  If the pattern
-- 	is invalid or not found, nothing is shown.  The screen will be updated
-- 	often, this is only useful on fast terminals.
-- 	Note that the match will be shown, but the cursor will return to its
-- 	original position when no match is found and when pressing <Esc>.  You
-- 	still need to finish the search command with <Enter> to move the
-- 	cursor to the match.
-- 	You can use the CTRL-G and CTRL-T keys to move to the next and
-- 	previous match. |c_CTRL-G| |c_CTRL-T|
-- 	Vim only searches for about half a second.  With a complicated
-- 	pattern and/or a lot of text the match may not be found.  This is to
-- 	avoid that Vim hangs while you are typing the pattern.
-- 	The |hl-IncSearch| highlight group determines the highlighting.
-- 	When `'hlsearch'`  is on, all matched strings are highlighted too while
-- 	typing a search command. See also: `'hlsearch'` .
-- 	If you don't want to turn `'hlsearch'`  on, but want to highlight all
-- 	matches while searching, you can turn on and off `'hlsearch'`  with
-- 	autocmd.  Example: >
-- 		augroup vimrc-incsearch-highlight
-- 		  autocmd!
-- 		  autocmd CmdlineEnter /,\? :set hlsearch
-- 		  autocmd CmdlineLeave /,\? :set nohlsearch
-- 		augroup END
-- <
-- 	CTRL-L can be used to add one character from after the current match
-- 	to the command line.  If `'ignorecase'`  and `'smartcase'`  are set and the
-- 	command line has no uppercase characters, the added character is
-- 	converted to lowercase.
-- 	CTRL-R CTRL-W can be used to add the word at the end of the current
-- 	match, excluding the characters that were already typed.
vim.go.incsearch = true
vim.go.is = vim.go.incsearch
vim.go.insertmode = false
vim.go.im = vim.go.insertmode
-- `'isfname'`  `'isf'` 		string	(default for Windows:
-- 			     "@,48-57,/,\,.,-,_,+,,,#,$,%,{,},[,],:,@-@,!,~,="
-- 			    otherwise: "@,48-57,/,.,-,_,+,,,#,$,%,~,=")
-- 			global
-- 	The characters specified by this option are included in file names and
-- 	path names.  Filenames are used for commands like "gf", "[i" and in
-- 	the tags file.  It is also used for "\f" in a |pattern|.
-- 	Multi-byte characters 256 and above are always included, only the
-- 	characters up to 255 are specified with this option.
-- 	For UTF-8 the characters 0xa0 to 0xff are included as well.
-- 	Think twice before adding white space to this option.  Although a
-- 	space may appear inside a file name, the effect will be that Vim
-- 	doesn't know where a file name starts or ends when doing completion.
-- 	It most likely works better without a space in `'isfname'` .
-- 
-- 	Note that on systems using a backslash as path separator, Vim tries to
-- 	do its best to make it work as you would expect.  That is a bit
-- 	tricky, since Vi originally used the backslash to escape special
-- 	characters.  Vim will not remove a backslash in front of a normal file
-- 	name character on these systems, but it will on Unix and alikes.  The
-- 	`'&'`  and `'^'`  are not included by default, because these are special for
-- 	cmd.exe.
-- 
-- 	The format of this option is a list of parts, separated with commas.
-- 	Each part can be a single character number or a range.  A range is two
-- 	character numbers with `'-'`  in between.  A character number can be a
-- 	decimal number between 0 and 255 or the ASCII character itself (does
-- 	not work for digits).  Example:
-- 		"_,-,128-140,#-43"	(include `'_'`  and `'-'`  and the range
-- 					128 to 140 and `'#'`  to 43)
-- 	If a part starts with `'^'` , the following character number or range
-- 	will be excluded from the option.  The option is interpreted from left
-- 	to right.  Put the excluded character after the range where it is
-- 	included.  To include `'^'`  itself use it as the last character of the
-- 	option or the end of a range.  Example:
-- 		"^a-z,#,^"	(exclude `'a'`  to `'z'` , include `'#'`  and `'^'` )
-- 	If the character is `'@'` , all characters where isalpha() returns TRUE
-- 	are included.  Normally these are the characters a to z and A to Z,
-- 	plus accented characters.  To include `'@'`  itself use "@-@".  Examples:
-- 		"@,^a-z"	All alphabetic characters, excluding lower
-- 				case ASCII letters.
-- 		"a-z,A-Z,@-@"	All letters plus the `'@'`  character.
-- 	A comma can be included by using it where a character number is
-- 	expected.  Example:
-- 		"48-57,,,_"	Digits, comma and underscore.
-- 	A comma can be excluded by prepending a `'^'` .  Example:
-- 		" -~,^,,9"	All characters from space to `'~'` , excluding
-- 				comma, plus <Tab>.
-- 	See |option-backslash| about including spaces and backslashes.
vim.go.isfname = "@,48-57,/,.,-,_,+,,,#,$,%,~,="
vim.go.isf = vim.go.isfname
-- `'isident'`  `'isi'` 		string	(default for Windows:
-- 					   "@,48-57,_,128-167,224-235"
-- 				otherwise: "@,48-57,_,192-255")
-- 			global
-- 	The characters given by this option are included in identifiers.
-- 	Identifiers are used in recognizing environment variables and after a
-- 	match of the `'define'`  option.  It is also used for "\i" in a
-- 	|pattern|.  See `'isfname'`  for a description of the format of this
-- 	option.  For `'@'`  only characters up to 255 are used.
-- 	Careful: If you change this option, it might break expanding
-- 	environment variables.  E.g., when `'/'`  is included and Vim tries to
-- 	expand "$HOME/.local/state/nvim/shada/main.shada".  Maybe you should
-- 	change `'iskeyword'`  instead.
vim.go.isident = "@,48-57,_,192-255"
vim.go.isi = vim.go.isident
-- `'isprint'`  `'isp'` 	string	(default: "@,161-255")
-- 			global
-- 	The characters given by this option are displayed directly on the
-- 	screen.  It is also used for "\p" in a |pattern|.  The characters from
-- 	space (ASCII 32) to `'~'`  (ASCII 126) are always displayed directly,
-- 	even when they are not included in `'isprint'`  or excluded.  See
-- 	`'isfname'`  for a description of the format of this option.
-- 
-- 	Non-printable characters are displayed with two characters:
-- 		  0 -  31	"^@" - "^_"
-- 		 32 - 126	always single characters
-- 		   127		"^?"
-- 		128 - 159	"~@" - "~_"
-- 		160 - 254	"| " - "|~"
-- 		   255		"~?"
-- 	Illegal bytes from 128 to 255 (invalid UTF-8) are
-- 	displayed as <xx>, with the hexadecimal value of the byte.
-- 	When `'display'`  contains "uhex" all unprintable characters are
-- 	displayed as <xx>.
-- 	The SpecialKey highlighting will be used for unprintable characters.
-- 	|hl-SpecialKey|
-- 
-- 	Multi-byte characters 256 and above are always included, only the
-- 	characters up to 255 are specified with this option.  When a character
-- 	is printable but it is not available in the current font, a
-- 	replacement character will be shown.
-- 	Unprintable and zero-width Unicode characters are displayed as <xxxx>.
-- 	There is no option to specify these characters.
vim.go.isprint = "@,161-255"
vim.go.isp = vim.go.isprint
-- `'joinspaces'`  `'js'` 	boolean	(default off)
-- 			global
-- 	Insert two spaces after a `'.'` , `'?'`  and `'!'`  with a join command.
-- 	Otherwise only one space is inserted.
vim.go.joinspaces = false
vim.go.js = vim.go.joinspaces
-- `'jumpoptions'`  `'jop'` 	string	(default "")
-- 			global
-- 	List of words that change the behavior of the |jumplist|.
-- 	  stack         Make the jumplist behave like the tagstack or like a
-- 	                web browser.  Relative location of entries in the
-- 			jumplist is preserved at the cost of discarding
-- 			subsequent entries when navigating backwards in the
-- 			jumplist and then jumping to a location.
-- 			|jumplist-stack|
-- 
-- 	  view          When moving through the jumplist, |changelist|,
-- 			|alternate-file| or using |mark-motions| try to
-- 			restore the |mark-view| in which the action occurred.
vim.go.jumpoptions = ""
vim.go.jop = vim.go.jumpoptions
-- `'keymodel'`  `'km'` 		string	(default "")
-- 			global
-- 	List of comma-separated words, which enable special things that keys
-- 	can do.  These values can be used:
-- 	   startsel	Using a shifted special key starts selection (either
-- 			Select mode or Visual mode, depending on "key" being
-- 			present in `'selectmode'` ).
-- 	   stopsel	Using a not-shifted special key stops selection.
-- 	Special keys in this context are the cursor keys, <End>, <Home>,
-- 	<PageUp> and <PageDown>.
-- 	The `'keymodel'`  option is set by the |:behave| command.
vim.go.keymodel = ""
vim.go.km = vim.go.keymodel
-- `'langmap'`  `'lmap'` 	string	(default "")
-- 			global
-- 	This option allows switching your keyboard into a special language
-- 	mode.  When you are typing text in Insert mode the characters are
-- 	inserted directly.  When in Normal mode the `'langmap'`  option takes
-- 	care of translating these special characters to the original meaning
-- 	of the key.  This means you don't have to change the keyboard mode to
-- 	be able to execute Normal mode commands.
-- 	This is the opposite of the `'keymap'`  option, where characters are
-- 	mapped in Insert mode.
-- 	Also consider setting `'langremap'`  to off, to prevent `'langmap'`  from
-- 	applying to characters resulting from a mapping.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
-- 
-- 	Example (for Greek, in UTF-8):				  >
-- 	    :set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz
-- <	Example (exchanges meaning of z and y for commands): >
-- 	    :set langmap=zy,yz,ZY,YZ
-- <
-- 	The `'langmap'`  option is a list of parts, separated with commas.  Each
-- 	part can be in one of two forms:
-- 	1.  A list of pairs.  Each pair is a "from" character immediately
-- 	    followed by the "to" character.  Examples: "aA", "aAbBcC".
-- 	2.  A list of "from" characters, a semi-colon and a list of "to"
-- 	    characters.  Example: "abc;ABC"
-- 	Example: "aA,fgh;FGH,cCdDeE"
-- 	Special characters need to be preceded with a backslash.  These are
-- 	";", `','` , `'"'` , `'|'`  and backslash itself.
-- 
-- 	This will allow you to activate vim actions without having to switch
-- 	back and forth between the languages.  Your language characters will
-- 	be understood as normal vim English characters (according to the
-- 	langmap mappings) in the following cases:
-- 	 o Normal/Visual mode (commands, buffer/register names, user mappings)
-- 	 o Insert/Replace Mode: Register names after CTRL-R
-- 	 o Insert/Replace Mode: Mappings
-- 	Characters entered in Command-line mode will NOT be affected by
-- 	this option.   Note that this option can be changed at any time
-- 	allowing to switch between mappings for different languages/encodings.
-- 	Use a mapping to avoid having to type it each time!
vim.go.langmap = ""
vim.go.lmap = vim.go.langmap
-- `'langmenu'`  `'lm'` 		string	(default "")
-- 			global
-- 	Language to use for menu translation.  Tells which file is loaded
-- 	from the "lang" directory in `'runtimepath'` : >
-- 		"lang/menu_" .. &langmenu .. ".vim"
-- <	(without the spaces).  For example, to always use the Dutch menus, no
-- 	matter what $LANG is set to: >
-- 		:set langmenu=nl_NL.ISO_8859-1
-- <	When `'langmenu'`  is empty, |v:lang| is used.
-- 	Only normal file name characters can be used, "/\*?[|<>" are illegal.
-- 	If your $LANG is set to a non-English language but you do want to use
-- 	the English menus: >
-- 		:set langmenu=none
-- <	This option must be set before loading menus, switching on filetype
-- 	detection or syntax highlighting.  Once the menus are defined setting
-- 	this option has no effect.  But you could do this: >
-- 		:source $VIMRUNTIME/delmenu.vim
-- 		:set langmenu=de_DE.ISO_8859-1
-- 		:source $VIMRUNTIME/menu.vim
-- <	Warning: This deletes all menus that you defined yourself!
vim.go.langmenu = ""
vim.go.lm = vim.go.langmenu
vim.go.langnoremap = true
vim.go.lnr = vim.go.langnoremap
-- `'langremap'`  `'lrm'` 	boolean (default off)
-- 			global
-- 	When off, setting `'langmap'`  does not apply to characters resulting from
-- 	a mapping.  If setting `'langmap'`  disables some of your mappings, make
-- 	sure this option is off.
vim.go.langremap = false
vim.go.lrm = vim.go.langremap
-- `'laststatus'`  `'ls'` 	number	(default 2)
-- 			global
-- 	The value of this option influences when the last window will have a
-- 	status line:
-- 		0: never
-- 		1: only if there are at least two windows
-- 		2: always
-- 		3: always and ONLY the last window
-- 	The screen looks nicer with a status line if you have several
-- 	windows, but it takes another screen line. |status-line|
vim.go.laststatus = 2
vim.go.ls = vim.go.laststatus
-- `'lazyredraw'`  `'lz'` 	boolean	(default off)
-- 			global
-- 	When this option is set, the screen will not be redrawn while
-- 	executing macros, registers and other commands that have not been
-- 	typed.  Also, updating the window title is postponed.  To force an
-- 	update use |:redraw|.
-- 	This may occasionally cause display errors.  It is only meant to be set
-- 	temporarily when performing an operation where redrawing may cause
-- 	flickering or cause a slow down.
vim.go.lazyredraw = false
vim.go.lz = vim.go.lazyredraw
-- `'lines'` 			number	(default 24 or terminal height)
-- 			global
-- 	Number of lines of the Vim window.
-- 	Normally you don't need to set this.  It is done automatically by the
-- 	terminal initialization code.
-- 	When Vim is running in the GUI or in a resizable window, setting this
-- 	option will cause the window size to be changed.  When you only want
-- 	to use the size for the GUI, put the command in your |gvimrc| file.
-- 	Vim limits the number of lines to what fits on the screen.  You can
-- 	use this command to get the tallest window possible: >
-- 		:set lines=999
-- <	Minimum value is 2, maximum value is 1000.
vim.go.lines = 24
-- `'linespace'`  `'lsp'` 	number	(default 0)
-- 			global
-- 			{only in the GUI}
-- 	Number of pixel lines inserted between characters.  Useful if the font
-- 	uses the full character cell height, making lines touch each other.
-- 	When non-zero there is room for underlining.
-- 	With some fonts there can be too much room between lines (to have
-- 	space for ascents and descents).  Then it makes sense to set
-- 	`'linespace'`  to a negative value.  This may cause display problems
-- 	though!
vim.go.linespace = 0
vim.go.lsp = vim.go.linespace
-- `'loadplugins'`  `'lpl'` 	boolean	(default on)
-- 			global
-- 	When on the plugin scripts are loaded when starting up |load-plugins|.
-- 	This option can be reset in your |vimrc| file to disable the loading
-- 	of plugins.
-- 	Note that using the "-u NONE" and "--noplugin" command line arguments
-- 	reset this option. |-u| |--noplugin|
vim.go.loadplugins = true
vim.go.lpl = vim.go.loadplugins
-- `'magic'` 			boolean	(default on)
-- 			global
-- 	Changes the special characters that can be used in search patterns.
-- 	See |pattern|.
-- 	WARNING: Switching this option off most likely breaks plugins!  That
-- 	is because many patterns assume it's on and will fail when it's off.
-- 	Only switch it off when working with old Vi scripts.  In any other
-- 	situation write patterns that work when `'magic'`  is on.  Include "\M"
-- 	when you want to |/\M|.
vim.go.magic = true
-- `'makeef'`  `'mef'` 		string	(default: "")
-- 			global
-- 	Name of the errorfile for the |:make| command (see |:make_makeprg|)
-- 	and the |:grep| command.
-- 	When it is empty, an internally generated temp file will be used.
-- 	When "##" is included, it is replaced by a number to make the name
-- 	unique.  This makes sure that the ":make" command doesn't overwrite an
-- 	existing file.
-- 	NOT used for the ":cf" command.  See `'errorfile'`  for that.
-- 	Environment variables are expanded |:set_env|.
-- 	See |option-backslash| about including spaces and backslashes.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.makeef = ""
vim.go.mef = vim.go.makeef
-- `'matchtime'`  `'mat'` 	number	(default 5)
-- 			global
-- 	Tenths of a second to show the matching paren, when `'showmatch'`  is
-- 	set.  Note that this is not in milliseconds, like other options that
-- 	set a time.  This is to be compatible with Nvi.
vim.go.matchtime = 5
vim.go.mat = vim.go.matchtime
vim.go.maxcombine = 6
vim.go.mco = vim.go.maxcombine
-- `'maxfuncdepth'`  `'mfd'` 	number	(default 100)
-- 			global
-- 	Maximum depth of function calls for user functions.  This normally
-- 	catches endless recursion.  When using a recursive function with
-- 	more depth, set `'maxfuncdepth'`  to a bigger number.  But this will use
-- 	more memory, there is the danger of failing when memory is exhausted.
-- 	Increasing this limit above 200 also changes the maximum for Ex
-- 	command recursion, see |E169|.
-- 	See also |:function|.
vim.go.maxfuncdepth = 100
vim.go.mfd = vim.go.maxfuncdepth
-- `'maxmapdepth'`  `'mmd'` 	number	(default 1000)
-- 			global
-- 	Maximum number of times a mapping is done without resulting in a
-- 	character to be used.  This normally catches endless mappings, like
-- 	":map x y" with ":map y x".  It still does not catch ":map g wg",
-- 	because the `'w'`  is used before the next mapping is done.  See also
-- 	|key-mapping|.
vim.go.maxmapdepth = 1000
vim.go.mmd = vim.go.maxmapdepth
-- `'maxmempattern'`  `'mmp'` 	number	(default 1000)
-- 			global
-- 	Maximum amount of memory (in Kbyte) to use for pattern matching.
-- 	The maximum value is about 2000000.  Use this to work without a limit.
-- 
-- 	When Vim runs into the limit it gives an error message and mostly
-- 	behaves like CTRL-C was typed.
-- 	Running into the limit often means that the pattern is very
-- 	inefficient or too complex.  This may already happen with the pattern
-- 	"\(.\)*" on a very long line.  ".*" works much better.
-- 	Might also happen on redraw, when syntax rules try to match a complex
-- 	text structure.
-- 	Vim may run out of memory before hitting the `'maxmempattern'`  limit, in
-- 	which case you get an "Out of memory" error instead.
vim.go.maxmempattern = 1000
vim.go.mmp = vim.go.maxmempattern
-- `'menuitems'`  `'mis'` 	number	(default 25)
-- 			global
-- 	Maximum number of items to use in a menu.  Used for menus that are
-- 	generated from a list of items, e.g., the Buffers menu.  Changing this
-- 	option has no direct effect, the menu must be refreshed first.
vim.go.menuitems = 25
vim.go.mis = vim.go.menuitems
-- `'mkspellmem'`  `'msm'` 	string	(default "460000,2000,500")
-- 			global
-- 	Parameters for |:mkspell|.  This tunes when to start compressing the
-- 	word tree.  Compression can be slow when there are many words, but
-- 	it's needed to avoid running out of memory.  The amount of memory used
-- 	per word depends very much on how similar the words are, that's why
-- 	this tuning is complicated.
-- 
-- 	There are three numbers, separated by commas:
-- 		{start},{inc},{added}
-- 
-- 	For most languages the uncompressed word tree fits in memory.  {start}
-- 	gives the amount of memory in Kbyte that can be used before any
-- 	compression is done.  It should be a bit smaller than the amount of
-- 	memory that is available to Vim.
-- 
-- 	When going over the {start} limit the {inc} number specifies the
-- 	amount of memory in Kbyte that can be allocated before another
-- 	compression is done.  A low number means compression is done after
-- 	less words are added, which is slow.  A high number means more memory
-- 	will be allocated.
-- 
-- 	After doing compression, {added} times 1024 words can be added before
-- 	the {inc} limit is ignored and compression is done when any extra
-- 	amount of memory is needed.  A low number means there is a smaller
-- 	chance of hitting the {inc} limit, less memory is used but it's
-- 	slower.
-- 
-- 	The languages for which these numbers are important are Italian and
-- 	Hungarian.  The default works for when you have about 512 Mbyte.  If
-- 	you have 1 Gbyte you could use: >
-- 		:set mkspellmem=900000,3000,800
-- <	If you have less than 512 Mbyte |:mkspell| may fail for some
-- 	languages, no matter what you set `'mkspellmem'`  to.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|.
vim.go.mkspellmem = "460000,2000,500"
vim.go.msm = vim.go.mkspellmem
-- `'modelineexpr'`  `'mle'` 	boolean (default: off)
-- 			global
-- 	When on allow some options that are an expression to be set in the
-- 	modeline.  Check the option for whether it is affected by
-- 	`'modelineexpr'` .  Also see |modeline|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.modelineexpr = false
vim.go.mle = vim.go.modelineexpr
-- `'modelines'`  `'mls'` 	number	(default 5)
-- 			global
-- 	If `'modeline'`  is on `'modelines'`  gives the number of lines that is
-- 	checked for set commands.  If `'modeline'`  is off or `'modelines'`  is zero
-- 	no lines are checked.  See |modeline|.
vim.go.modelines = 5
vim.go.mls = vim.go.modelines
-- `'more'` 			boolean	(default: on)
-- 			global
-- 	When on, listings pause when the whole screen is filled.  You will get
-- 	the |more-prompt|.  When this option is off there are no pauses, the
-- 	listing continues until finished.
vim.go.more = true
-- `'mouse'` 			string	(default "nvi")
-- 			global
-- 
-- 	Enables mouse support. For example, to enable the mouse in Normal mode
-- 	and Visual mode: >
-- 		:set mouse=nv
-- <
-- 	To temporarily disable mouse support, hold the shift key while using
-- 	the mouse.
-- 
-- 	Mouse support can be enabled for different modes:
-- 		n	Normal mode
-- 		v	Visual mode
-- 		i	Insert mode
-- 		c	Command-line mode
-- 		h	all previous modes when editing a help file
-- 		a	all previous modes
-- 		r	for |hit-enter| and |more-prompt| prompt
-- 
-- 	Left-click anywhere in a text buffer to place the cursor there.  This
-- 	works with operators too, e.g. type |d| then left-click to delete text
-- 	from the current cursor position to the position where you clicked.
-- 
-- 	Drag the |status-line| or vertical separator of a window to resize it.
-- 
-- 	If enabled for "v" (Visual mode) then double-click selects word-wise,
-- 	triple-click makes it line-wise, and quadruple-click makes it
-- 	rectangular block-wise.
-- 
-- 	For scrolling with a mouse wheel see |scroll-mouse-wheel|.
-- 
-- 	Note: When enabling the mouse in a terminal, copy/paste will use the
-- 	"* register if possible. See also `'clipboard'` .
-- 
-- 	Related options:
-- 	`'mousefocus'` 	window focus follows mouse pointer
-- 	`'mousemodel'` 	what mouse button does which action
-- 	`'mousehide'` 	hide mouse pointer while typing text
-- 	`'selectmode'` 	whether to start Select mode or Visual mode
-- 
-- 	The :behave command provides some "profiles" for mouse behavior.
-- 
-- 	:be[have] {model}	Set behavior for mouse and selection.  Valid
-- 				arguments are:
-- 				   mswin	MS-Windows behavior
-- 				   xterm	Xterm behavior
-- 
-- 				Using ":behave" changes these options:
-- 				option		mswin			xterm	~
-- 				`'selectmode'` 	"mouse,key"		""
-- 				`'mousemodel'` 	"popup"			"extend"
-- 				`'keymodel'` 	"startsel,stopsel"	""
-- 				`'selection'` 	"exclusive"		"inclusive"
vim.go.mouse = "nvi"
-- `'mousefocus'`  `'mousef'` 	boolean	(default off)
-- 			global
-- 	The window that the mouse pointer is on is automatically activated.
-- 	When changing the window layout or window focus in another way, the
-- 	mouse pointer is moved to the window with keyboard focus.  Off is the
-- 	default because it makes using the pull down menus a little goofy, as
-- 	a pointer transit may activate a window unintentionally.
vim.go.mousefocus = false
vim.go.mousef = vim.go.mousefocus
-- `'mousehide'`  `'mh'` 	boolean	(default on)
-- 			global
-- 			{only works in the GUI}
-- 	When on, the mouse pointer is hidden when characters are typed.
-- 	The mouse pointer is restored when the mouse is moved.
vim.go.mousehide = true
vim.go.mh = vim.go.mousehide
-- `'mousemodel'`  `'mousem'` 	string	(default "popup_setpos")
-- 			global
-- 	Sets the model to use for the mouse.  The name mostly specifies what
-- 	the right mouse button is used for:
-- 	   extend	Right mouse button extends a selection.  This works
-- 			like in an xterm.
-- 	   popup	Right mouse button pops up a menu.  The shifted left
-- 			mouse button extends a selection.  This works like
-- 			with Microsoft Windows.
-- 	   popup_setpos Like "popup", but the cursor will be moved to the
-- 			position where the mouse was clicked, and thus the
-- 			selected operation will act upon the clicked object.
-- 			If clicking inside a selection, that selection will
-- 			be acted upon, i.e. no cursor move.  This implies of
-- 			course, that right clicking outside a selection will
-- 			end Visual mode.
-- 	Overview of what button does what for each model:
-- 	mouse		    extend		popup(_setpos) ~
-- 	left click	    place cursor	place cursor
-- 	left drag	    start selection	start selection
-- 	shift-left	    search word		extend selection
-- 	right click	    extend selection	popup menu (place cursor)
-- 	right drag	    extend selection	-
-- 	middle click	    paste		paste
-- 
-- 	In the "popup" model the right mouse button produces a pop-up menu.
-- 	Nvim creates a default |popup-menu| but you can redefine it.
-- 
-- 	Note that you can further refine the meaning of buttons with mappings.
-- 	See |mouse-overview|.  But mappings are NOT used for modeless selection.
-- 
-- 	Example: >
-- 	   :map <S-LeftMouse>     <RightMouse>
-- 	   :map <S-LeftDrag>      <RightDrag>
-- 	   :map <S-LeftRelease>   <RightRelease>
-- 	   :map <2-S-LeftMouse>   <2-RightMouse>
-- 	   :map <2-S-LeftDrag>    <2-RightDrag>
-- 	   :map <2-S-LeftRelease> <2-RightRelease>
-- 	   :map <3-S-LeftMouse>   <3-RightMouse>
-- 	   :map <3-S-LeftDrag>    <3-RightDrag>
-- 	   :map <3-S-LeftRelease> <3-RightRelease>
-- 	   :map <4-S-LeftMouse>   <4-RightMouse>
-- 	   :map <4-S-LeftDrag>    <4-RightDrag>
-- 	   :map <4-S-LeftRelease> <4-RightRelease>
-- <
-- 	Mouse commands requiring the CTRL modifier can be simulated by typing
-- 	the "g" key before using the mouse:
-- 	    "g<LeftMouse>"  is "<C-LeftMouse>	(jump to tag under mouse click)
-- 	    "g<RightMouse>" is "<C-RightMouse>	("CTRL-T")
-- 
-- 	The `'mousemodel'`  option is set by the |:behave| command.
vim.go.mousemodel = "popup_setpos"
vim.go.mousem = vim.go.mousemodel
-- `'mousemoveevent'`  `'mousemev'`   boolean	(default off)
-- 			global
-- 	When on, mouse move events are delivered to the input queue and are
-- 	available for mapping. The default, off, avoids the mouse movement
-- 	overhead except when needed.
-- 	Warning: Setting this option can make pending mappings to be aborted
-- 	when the mouse is moved.
vim.go.mousemoveevent = false
vim.go.mousemev = vim.go.mousemoveevent
-- `'mousescroll'` 		string	(default "ver:3,hor:6")
-- 			global
-- 	This option controls the number of lines / columns to scroll by when
-- 	scrolling with a mouse. The option is a comma separated list of parts.
-- 	Each part consists of a direction and a count as follows:
-- 		direction:count,direction:count
-- 	Direction is one of either "hor" or "ver". "hor" controls horizontal
-- 	scrolling and "ver" controls vertical scrolling. Count sets the amount
-- 	to scroll by for the given direction, it should be a non negative
-- 	integer. Each direction should be set at most once. If a direction
-- 	is omitted, a default value is used (6 for horizontal scrolling and 3
-- 	for vertical scrolling). You can disable mouse scrolling by using
-- 	a count of 0.
-- 
-- 	Example: >
-- 		:set mousescroll=ver:5,hor:2
-- <	Will make Nvim scroll 5 lines at a time when scrolling vertically, and
-- 	scroll 2 columns at a time when scrolling horizontally.
vim.go.mousescroll = "ver:3,hor:6"
-- `'mouseshape'`  `'mouses'` 	string	(default "i:beam,r:beam,s:updown,sd:cross,
-- 					m:no,ml:up-arrow,v:rightup-arrow")
-- 			global
-- 	This option tells Vim what the mouse pointer should look like in
-- 	different modes.  The option is a comma-separated list of parts, much
-- 	like used for `'guicursor'` .  Each part consist of a mode/location-list
-- 	and an argument-list:
-- 		mode-list:shape,mode-list:shape,..
-- 	The mode-list is a dash separated list of these modes/locations:
-- 			In a normal window: ~
-- 		n	Normal mode
-- 		v	Visual mode
-- 		ve	Visual mode with `'selection'`  "exclusive" (same as `'v'` ,
-- 			if not specified)
-- 		o	Operator-pending mode
-- 		i	Insert mode
-- 		r	Replace mode
-- 
-- 			Others: ~
-- 		c	appending to the command-line
-- 		ci	inserting in the command-line
-- 		cr	replacing in the command-line
-- 		m	at the 'Hit ENTER' or `'More'`  prompts
-- 		ml	idem, but cursor in the last line
-- 		e	any mode, pointer below last window
-- 		s	any mode, pointer on a status line
-- 		sd	any mode, while dragging a status line
-- 		vs	any mode, pointer on a vertical separator line
-- 		vd	any mode, while dragging a vertical separator line
-- 		a	everywhere
-- 
-- 	The shape is one of the following:
-- 	avail	name		looks like ~
-- 	w x	arrow		Normal mouse pointer
-- 	w x	blank		no pointer at all (use with care!)
-- 	w x	beam		I-beam
-- 	w x	updown		up-down sizing arrows
-- 	w x	leftright	left-right sizing arrows
-- 	w x	busy		The system's usual busy pointer
-- 	w x	no		The system's usual "no input" pointer
-- 	  x	udsizing	indicates up-down resizing
-- 	  x	lrsizing	indicates left-right resizing
-- 	  x	crosshair	like a big thin +
-- 	  x	hand1		black hand
-- 	  x	hand2		white hand
-- 	  x	pencil		what you write with
-- 	  x	question	big ?
-- 	  x	rightup-arrow	arrow pointing right-up
-- 	w x	up-arrow	arrow pointing up
-- 	  x	<number>	any X11 pointer number (see X11/cursorfont.h)
-- 
-- 	The "avail" column contains a `'w'`  if the shape is available for Win32,
-- 	x for X11.
-- 	Any modes not specified or shapes not available use the normal mouse
-- 	pointer.
-- 
-- 	Example: >
-- 		:set mouseshape=s:udsizing,m:no
-- <	will make the mouse turn to a sizing arrow over the status lines and
-- 	indicate no input when the hit-enter prompt is displayed (since
-- 	clicking the mouse has no effect in this state.)
vim.go.mouseshape = ""
vim.go.mouses = vim.go.mouseshape
-- `'mousetime'`  `'mouset'` 	number	(default 500)
-- 			global
-- 	Defines the maximum time in msec between two mouse clicks for the
-- 	second click to be recognized as a multi click.
vim.go.mousetime = 500
vim.go.mouset = vim.go.mousetime
-- `'opendevice'`  `'odev'` 	boolean	(default off)
-- 			global
-- 			{only for Windows}
-- 	Enable reading and writing from devices.  This may get Vim stuck on a
-- 	device that can be opened but doesn't actually do the I/O.  Therefore
-- 	it is off by default.
-- 	Note that on Windows editing "aux.h", "lpt1.txt" and the like also
-- 	result in editing a device.
vim.go.opendevice = false
vim.go.odev = vim.go.opendevice
-- `'operatorfunc'`  `'opfunc'` 	string	(default: empty)
-- 			global
-- 	This option specifies a function to be called by the |g@| operator.
-- 	See |:map-operator| for more info and an example.  The value can be
-- 	the name of a function, a |lambda| or a |Funcref|. See
-- 	|option-value-function| for more information.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.operatorfunc = ""
vim.go.opfunc = vim.go.operatorfunc
-- `'packpath'`  `'pp'` 		string	(default: see `'runtimepath'` )
-- 	Directories used to find packages.  See |packages| and |rtp-packages|.
vim.go.packpath = "/home/runner/.config/nvim,/etc/xdg/nvim,/home/runner/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/tmp/nvim/squashfs-root/usr/share/nvim/runtime,/tmp/nvim/squashfs-root/usr/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/runner/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/runner/.config/nvim/after"
vim.go.pp = vim.go.packpath
-- `'paragraphs'`  `'para'` 	string	(default "IPLPPPQPP TPHPLIPpLpItpplpipbp")
-- 			global
-- 	Specifies the nroff macros that separate paragraphs.  These are pairs
-- 	of two letters (see |object-motions|).
vim.go.paragraphs = "IPLPPPQPP TPHPLIPpLpItpplpipbp"
vim.go.para = vim.go.paragraphs
vim.go.paste = false
vim.go.pastetoggle = ""
vim.go.pt = vim.go.pastetoggle
-- `'patchexpr'`  `'pex'` 	string	(default "")
-- 			global
-- 	Expression which is evaluated to apply a patch to a file and generate
-- 	the resulting new version of the file.  See |diff-patchexpr|.
vim.go.patchexpr = ""
vim.go.pex = vim.go.patchexpr
-- `'patchmode'`  `'pm'` 	string	(default "")
-- 			global
-- 	When non-empty the oldest version of a file is kept.  This can be used
-- 	to keep the original version of a file if you are changing files in a
-- 	source distribution.  Only the first time that a file is written a
-- 	copy of the original file will be kept.  The name of the copy is the
-- 	name of the original file with the string in the `'patchmode'`  option
-- 	appended.  This option should start with a dot.  Use a string like
-- 	".orig" or ".org".  `'backupdir'`  must not be empty for this to work
-- 	(Detail: The backup file is renamed to the patchmode file after the
-- 	new file has been successfully written, that's why it must be possible
-- 	to write a backup file).  If there was no file to be backed up, an
-- 	empty file is created.
-- 	When the `'backupskip'`  pattern matches, a patchmode file is not made.
-- 	Using `'patchmode'`  for compressed files appends the extension at the
-- 	end (e.g., "file.gz.orig"), thus the resulting name isn't always
-- 	recognized as a compressed file.
-- 	Only normal file name characters can be used, "/\*?[|<>" are illegal.
vim.go.patchmode = ""
vim.go.pm = vim.go.patchmode
-- `'previewheight'`  `'pvh'` 	number (default 12)
-- 			global
-- 	Default height for a preview window.  Used for |:ptag| and associated
-- 	commands.  Used for |CTRL-W_}| when no count is given.
vim.go.previewheight = 12
vim.go.pvh = vim.go.previewheight
vim.go.prompt = true
-- `'pumblend'`  `'pb'` 		number	(default 0)
-- 			global
-- 	Enables pseudo-transparency for the |popup-menu|. Valid values are in
-- 	the range of 0 for fully opaque popupmenu (disabled) to 100 for fully
-- 	transparent background. Values between 0-30 are typically most useful.
-- 
-- 	It is possible to override the level for individual highlights within
-- 	the popupmenu using |highlight-blend|. For instance, to enable
-- 	transparency but force the current selected element to be fully opaque: >
-- 
-- 		:set pumblend=15
-- 		:hi PmenuSel blend=0
-- <
-- 	UI-dependent. Works best with RGB colors. `'termguicolors'` 
vim.go.pumblend = 0
vim.go.pb = vim.go.pumblend
-- `'pumheight'`  `'ph'` 	number	(default 0)
-- 			global
-- 	Maximum number of items to show in the popup menu
-- 	(|ins-completion-menu|). Zero means "use available screen space".
vim.go.pumheight = 0
vim.go.ph = vim.go.pumheight
-- `'pumwidth'`  `'pw'` 		number	(default 15)
-- 			global
-- 	Minimum width for the popup menu (|ins-completion-menu|).  If the
-- 	cursor column + `'pumwidth'`  exceeds screen width, the popup menu is
-- 	nudged to fit on the screen.
vim.go.pumwidth = 15
vim.go.pw = vim.go.pumwidth
-- `'pyxversion'`  `'pyx'` 	number	(default 3)
-- 			global
-- 	Specifies the python version used for pyx* functions and commands
-- 	|python_x|.  As only Python 3 is supported, this always has the value
-- 	`3`. Setting any other value is an error.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.pyxversion = 3
vim.go.pyx = vim.go.pyxversion
-- `'quickfixtextfunc'`  `'qftf'` 	string (default "")
-- 			global
-- 	This option specifies a function to be used to get the text to display
-- 	in the quickfix and location list windows.  This can be used to
-- 	customize the information displayed in the quickfix or location window
-- 	for each entry in the corresponding quickfix or location list.  See
-- 	|quickfix-window-function| for an explanation of how to write the
-- 	function and an example.  The value can be the name of a function, a
-- 	|lambda| or a |Funcref|. See |option-value-function| for more
-- 	information.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.quickfixtextfunc = ""
vim.go.qftf = vim.go.quickfixtextfunc
-- `'redrawdebug'`  `'rdb'` 	string	(default `''` )
-- 			global
-- 	Flags to change the way redrawing works, for debugging purposes.
-- 	Most useful with `'writedelay'`  set to some reasonable value.
-- 	Supports the following flags:
-- 	    compositor	Indicate each redraw event handled by the compositor
-- 			by briefly flashing the redrawn regions in colors
-- 			indicating the redraw type. These are the highlight
-- 			groups used (and their default colors):
-- 		RedrawDebugNormal   gui=reverse   normal redraw passed through
-- 		RedrawDebugClear    guibg=Yellow  clear event passed through
-- 		RedrawDebugComposed guibg=Green   redraw event modified by the
-- 						  compositor (due to
-- 						  overlapping grids, etc)
-- 		RedrawDebugRecompose guibg=Red    redraw generated by the
-- 						  compositor itself, due to a
-- 						  grid being moved or deleted.
-- 	    line	introduce a delay after each line drawn on the screen.
-- 			When using the TUI or another single-grid UI, "compositor"
-- 			gives more information and should be preferred (every
-- 			line is processed as a separate event by the compositor)
-- 	    flush	introduce a delay after each "flush" event.
-- 	    nothrottle	Turn off throttling of the message grid. This is an
-- 			optimization that joins many small scrolls to one
-- 			larger scroll when drawing the message area (with
-- 			`'display'`  msgsep flag active).
-- 	    invalid	Enable stricter checking (abort) of inconsistencies
-- 			of the internal screen state. This is mostly
-- 			useful when running nvim inside a debugger (and
-- 			the test suite).
-- 	    nodelta	Send all internally redrawn cells to the UI, even if
-- 			they are unchanged from the already displayed state.
vim.go.redrawdebug = ""
vim.go.rdb = vim.go.redrawdebug
-- `'redrawtime'`  `'rdt'` 	number	(default 2000)
-- 			global
-- 	Time in milliseconds for redrawing the display.  Applies to
-- 	`'hlsearch'` , `'inccommand'` , |:match| highlighting and syntax
-- 	highlighting.
-- 	When redrawing takes more than this many milliseconds no further
-- 	matches will be highlighted.
-- 	For syntax highlighting the time applies per window.  When over the
-- 	limit syntax highlighting is disabled until |CTRL-L| is used.
-- 	This is used to avoid that Vim hangs when using a very complicated
-- 	pattern.
vim.go.redrawtime = 2000
vim.go.rdt = vim.go.redrawtime
-- `'regexpengine'`  `'re'` 	number	(default 0)
-- 			global
-- 	This selects the default regexp engine. |two-engines|
-- 	The possible values are:
-- 		0	automatic selection
-- 		1	old engine
-- 		2	NFA engine
-- 	Note that when using the NFA engine and the pattern contains something
-- 	that is not supported the pattern will not match.  This is only useful
-- 	for debugging the regexp engine.
-- 	Using automatic selection enables Vim to switch the engine, if the
-- 	default engine becomes too costly.  E.g., when the NFA engine uses too
-- 	many states.  This should prevent Vim from hanging on a combination of
-- 	a complex pattern with long text.
vim.go.regexpengine = 0
vim.go.re = vim.go.regexpengine
vim.go.remap = true
-- `'report'` 		number	(default 2)
-- 			global
-- 	Threshold for reporting number of lines changed.  When the number of
-- 	changed lines is more than `'report'`  a message will be given for most
-- 	":" commands.  If you want it always, set `'report'`  to 0.
-- 	For the ":substitute" command the number of substitutions is used
-- 	instead of the number of lines.
vim.go.report = 2
-- `'revins'`  `'ri'` 		boolean	(default off)
-- 			global
-- 	Inserting characters in Insert mode will work backwards.  See "typing
-- 	backwards" |ins-reverse|.  This option can be toggled with the CTRL-_
-- 	command in Insert mode, when `'allowrevins'`  is set.
vim.go.revins = false
vim.go.ri = vim.go.revins
-- `'ruler'`  `'ru'` 		boolean	(default on)
-- 			global
-- 	Show the line and column number of the cursor position, separated by a
-- 	comma.  When there is room, the relative position of the displayed
-- 	text in the file is shown on the far right:
-- 		Top	first line is visible
-- 		Bot	last line is visible
-- 		All	first and last line are visible
-- 		45%	relative position in the file
-- 	If `'rulerformat'`  is set, it will determine the contents of the ruler.
-- 	Each window has its own ruler.  If a window has a status line, the
-- 	ruler is shown there.  If a window doesn't have a status line and
-- 	`'cmdheight'`  is zero, the ruler is not shown.  Otherwise it is shown in
-- 	the last line of the screen.  If the statusline is given by
-- 	`'statusline'`  (i.e. not empty), this option takes precedence over
-- 	`'ruler'`  and `'rulerformat'` .
-- 	If the number of characters displayed is different from the number of
-- 	bytes in the text (e.g., for a TAB or a multibyte character), both
-- 	the text column (byte number) and the screen column are shown,
-- 	separated with a dash.
-- 	For an empty line "0-1" is shown.
-- 	For an empty buffer the line number will also be zero: "0,0-1".
-- 	If you don't want to see the ruler all the time but want to know where
-- 	you are, use "g CTRL-G" |g_CTRL-G|.
vim.go.ruler = true
vim.go.ru = vim.go.ruler
-- `'rulerformat'`  `'ruf'` 	string	(default empty)
-- 			global
-- 	When this option is not empty, it determines the content of the ruler
-- 	string, as displayed for the `'ruler'`  option.
-- 	The format of this option is like that of `'statusline'` .
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	The default ruler width is 17 characters.  To make the ruler 15
-- 	characters wide, put "%15(" at the start and "%)" at the end.
-- 	Example: >
-- 		:set rulerformat=%15(%c%V\ %p%%%)
-- <
vim.go.rulerformat = ""
vim.go.ruf = vim.go.rulerformat
-- `'runtimepath'`  `'rtp'` 	string	(default:     "$XDG_CONFIG_HOME/nvim,
-- 					       $XDG_CONFIG_DIRS[1]/nvim,
-- 					       $XDG_CONFIG_DIRS[2]/nvim,
-- 					       …
-- 					       $XDG_DATA_HOME/nvim[-data]/site,
-- 					       $XDG_DATA_DIRS[1]/nvim/site,
-- 					       $XDG_DATA_DIRS[2]/nvim/site,
-- 					       …
-- 					       $VIMRUNTIME,
-- 					       …
-- 					       $XDG_DATA_DIRS[2]/nvim/site/after,
-- 					       $XDG_DATA_DIRS[1]/nvim/site/after,
-- 					       $XDG_DATA_HOME/nvim[-data]/site/after,
-- 					       …
-- 					       $XDG_CONFIG_DIRS[2]/nvim/after,
-- 					       $XDG_CONFIG_DIRS[1]/nvim/after,
-- 					       $XDG_CONFIG_HOME/nvim/after")
-- 			global
-- 	List of directories to be searched for these runtime files:
-- 	  filetype.lua	filetypes |new-filetype|
-- 	  autoload/	automatically loaded scripts |autoload-functions|
-- 	  colors/	color scheme files |:colorscheme|
-- 	  compiler/	compiler files |:compiler|
-- 	  doc/		documentation |write-local-help|
-- 	  ftplugin/	filetype plugins |write-filetype-plugin|
-- 	  indent/	indent scripts |indent-expression|
-- 	  keymap/	key mapping files |mbyte-keymap|
-- 	  lang/		menu translations |:menutrans|
-- 	  lua/		|Lua| plugins
-- 	  menu.vim	GUI menus |menu.vim|
-- 	  pack/		packages |:packadd|
-- 	  parser/	|treesitter| syntax parsers
-- 	  plugin/	plugin scripts |write-plugin|
-- 	  queries/	|treesitter| queries
-- 	  rplugin/	|remote-plugin| scripts
-- 	  spell/	spell checking files |spell|
-- 	  syntax/	syntax files |mysyntaxfile|
-- 	  tutor/	tutorial files |:Tutor|
-- 
-- 	And any other file searched for with the |:runtime| command.
-- 
-- 	Defaults are setup to search these locations:
-- 	1. Your home directory, for personal preferences.
-- 	   Given by `stdpath("config")`.  |$XDG_CONFIG_HOME|
-- 	2. Directories which must contain configuration files according to
-- 	   |xdg| ($XDG_CONFIG_DIRS, defaults to /etc/xdg).  This also contains
-- 	   preferences from system administrator.
-- 	3. Data home directory, for plugins installed by user.
-- 	   Given by `stdpath("data")/site`.  |$XDG_DATA_HOME|
-- 	4. nvim/site subdirectories for each directory in $XDG_DATA_DIRS.
-- 	   This is for plugins which were installed by system administrator,
-- 	   but are not part of the Nvim distribution. XDG_DATA_DIRS defaults
-- 	   to /usr/local/share/:/usr/share/, so system administrators are
-- 	   expected to install site plugins to /usr/share/nvim/site.
-- 	5. Session state directory, for state data such as swap, backupdir,
-- 	   viewdir, undodir, etc.
-- 	   Given by `stdpath("state")`.  |$XDG_STATE_HOME|
-- 	6. $VIMRUNTIME, for files distributed with Nvim.
-- 
-- 	7, 8, 9, 10. In after/ subdirectories of 1, 2, 3 and 4, with reverse
-- 	   ordering.  This is for preferences to overrule or add to the
-- 	   distributed defaults or system-wide settings (rarely needed).
-- 
-- 
-- 	"start" packages will also be searched (|runtime-search-path|) for
-- 	runtime files after these, though such packages are not explicitly
-- 	reported in &runtimepath. But "opt" packages are explicitly added to
-- 	&runtimepath by |:packadd|.
-- 
-- 	Note that, unlike `'path'` , no wildcards like "" are allowed.  Normal
-- 	wildcards are allowed, but can significantly slow down searching for
-- 	runtime files.  For speed, use as few items as possible and avoid
-- 	wildcards.
-- 	See |:runtime|.
-- 	Example: >
-- 		:set runtimepath=~/vimruntime,/mygroup/vim,$VIMRUNTIME
-- <	This will use the directory "~/vimruntime" first (containing your
-- 	personal Nvim runtime files), then "/mygroup/vim", and finally
-- 	"$VIMRUNTIME" (the default runtime files).
-- 	You can put a directory before $VIMRUNTIME to find files which replace
-- 	distributed runtime files.  You can put a directory after $VIMRUNTIME
-- 	to find files which add to distributed runtime files.
-- 
-- 	With |--clean| the home directory entries are not included.
vim.go.runtimepath = "/home/runner/.config/nvim,/etc/xdg/nvim,/home/runner/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/tmp/nvim/squashfs-root/usr/share/nvim/runtime,/tmp/nvim/squashfs-root/usr/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/runner/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/runner/.config/nvim/after"
vim.go.rtp = vim.go.runtimepath
-- `'scrolljump'`  `'sj'` 	number	(default 1)
-- 			global
-- 	Minimal number of lines to scroll when the cursor gets off the
-- 	screen (e.g., with "j").  Not used for scroll commands (e.g., CTRL-E,
-- 	CTRL-D).  Useful if your terminal scrolls very slowly.
-- 	When set to a negative number from -1 to -100 this is used as the
-- 	percentage of the window height.  Thus -50 scrolls half the window
-- 	height.
vim.go.scrolljump = 1
vim.go.sj = vim.go.scrolljump
-- `'scrollopt'`  `'sbo'` 	string	(default "ver,jump")
-- 			global
-- 	This is a comma-separated list of words that specifies how
-- 	`'scrollbind'`  windows should behave.  `'sbo'`  stands for ScrollBind
-- 	Options.
-- 	The following words are available:
-- 	    ver		Bind vertical scrolling for `'scrollbind'`  windows
-- 	    hor		Bind horizontal scrolling for `'scrollbind'`  windows
-- 	    jump	Applies to the offset between two windows for vertical
-- 			scrolling.  This offset is the difference in the first
-- 			displayed line of the bound windows.  When moving
-- 			around in a window, another `'scrollbind'`  window may
-- 			reach a position before the start or after the end of
-- 			the buffer.  The offset is not changed though, when
-- 			moving back the `'scrollbind'`  window will try to scroll
-- 			to the desired position when possible.
-- 			When now making that window the current one, two
-- 			things can be done with the relative offset:
-- 			1. When "jump" is not included, the relative offset is
-- 			   adjusted for the scroll position in the new current
-- 			   window.  When going back to the other window, the
-- 			   new relative offset will be used.
-- 			2. When "jump" is included, the other windows are
-- 			   scrolled to keep the same relative offset.  When
-- 			   going back to the other window, it still uses the
-- 			   same relative offset.
-- 	Also see |scroll-binding|.
-- 	When `'diff'`  mode is active there always is vertical scroll binding,
-- 	even when "ver" isn't there.
vim.go.scrollopt = "ver,jump"
vim.go.sbo = vim.go.scrollopt
-- `'sections'`  `'sect'` 	string	(default "SHNHH HUnhsh")
-- 			global
-- 	Specifies the nroff macros that separate sections.  These are pairs of
-- 	two letters (See |object-motions|).  The default makes a section start
-- 	at the nroff macros ".SH", ".NH", ".H", ".HU", ".nh" and ".sh".
vim.go.sections = "SHNHH HUnhsh"
vim.go.sect = vim.go.sections
vim.go.secure = false
-- `'selection'`  `'sel'` 	string	(default "inclusive")
-- 			global
-- 	This option defines the behavior of the selection.  It is only used
-- 	in Visual and Select mode.
-- 	Possible values:
-- 	   value	past line     inclusive ~
-- 	   old		   no		yes
-- 	   inclusive	   yes		yes
-- 	   exclusive	   yes		no
-- 	"past line" means that the cursor is allowed to be positioned one
-- 	character past the line.
-- 	"inclusive" means that the last character of the selection is included
-- 	in an operation.  For example, when "x" is used to delete the
-- 	selection.
-- 	When "old" is used and `'virtualedit'`  allows the cursor to move past
-- 	the end of line the line break still isn't included.
-- 	Note that when "exclusive" is used and selecting from the end
-- 	backwards, you cannot include the last character of a line, when
-- 	starting in Normal mode and `'virtualedit'`  empty.
-- 
-- 	The `'selection'`  option is set by the |:behave| command.
vim.go.selection = "inclusive"
vim.go.sel = vim.go.selection
-- `'selectmode'`  `'slm'` 	string	(default "")
-- 			global
-- 	This is a comma-separated list of words, which specifies when to start
-- 	Select mode instead of Visual mode, when a selection is started.
-- 	Possible values:
-- 	   mouse	when using the mouse
-- 	   key		when using shifted special keys
-- 	   cmd		when using "v", "V" or CTRL-V
-- 	See |Select-mode|.
-- 	The `'selectmode'`  option is set by the |:behave| command.
vim.go.selectmode = ""
vim.go.slm = vim.go.selectmode
-- `'sessionoptions'`  `'ssop'` 	string	(default: "blank,buffers,curdir,folds,
-- 					       help,tabpages,winsize,terminal")
-- 			global
-- 	Changes the effect of the |:mksession| command.  It is a comma-
-- 	separated list of words.  Each word enables saving and restoring
-- 	something:
-- 	   word		save and restore ~
-- 	   blank	empty windows
-- 	   buffers	hidden and unloaded buffers, not just those in windows
-- 	   curdir	the current directory
-- 	   folds	manually created folds, opened/closed folds and local
-- 			fold options
-- 	   globals	global variables that start with an uppercase letter
-- 			and contain at least one lowercase letter.  Only
-- 			String and Number types are stored.
-- 	   help		the help window
-- 	   localoptions	options and mappings local to a window or buffer (not
-- 			global values for local options)
-- 	   options	all options and mappings (also global values for local
-- 			options)
-- 	   skiprtp	exclude `'runtimepath'`  and `'packpath'`  from the options
-- 	   resize	size of the Vim window: `'lines'`  and `'columns'` 
-- 	   sesdir	the directory in which the session file is located
-- 			will become the current directory (useful with
-- 			projects accessed over a network from different
-- 			systems)
-- 	   tabpages	all tab pages; without this only the current tab page
-- 			is restored, so that you can make a session for each
-- 			tab page separately
-- 	   terminal	include terminal windows where the command can be
-- 			restored
-- 	   winpos	position of the whole Vim window
-- 	   winsize	window sizes
-- 	   slash	|deprecated| Always enabled. Uses "/" in filenames.
-- 	   unix		|deprecated| Always enabled. Uses "\n" line endings.
-- 
-- 	Don't include both "curdir" and "sesdir". When neither is included
-- 	filenames are stored as absolute paths.
-- 	If you leave out "options" many things won't work well after restoring
-- 	the session.
vim.go.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
vim.go.ssop = vim.go.sessionoptions
-- `'shada'`  `'sd'` 		string	(default for
-- 				   Win32:  !,'100,<50,s10,h,rA:,rB:
-- 				   others: !,'100,<50,s10,h)
-- 			global
-- 	When non-empty, the shada file is read upon startup and written
-- 	when exiting Vim (see |shada-file|).  The string should be a comma-
-- 	separated list of parameters, each consisting of a single character
-- 	identifying the particular parameter, followed by a number or string
-- 	which specifies the value of that parameter.  If a particular
-- 	character is left out, then the default value is used for that
-- 	parameter.  The following is a list of the identifying characters and
-- 	the effect of their value.
-- 	CHAR	VALUE	~
-- 
-- 	!	When included, save and restore global variables that start
-- 		with an uppercase letter, and don't contain a lowercase
-- 		letter.  Thus "KEEPTHIS and "K_L_M" are stored, but "KeepThis"
-- 		and "_K_L_M" are not.  Nested List and Dict items may not be
-- 		read back correctly, you end up with an empty item.
-- 
-- 	"	Maximum number of lines saved for each register.  Old name of
-- 		the `'<'`  item, with the disadvantage that you need to put a
-- 		backslash before the ", otherwise it will be recognized as the
-- 		start of a comment!
-- 
-- 	%	When included, save and restore the buffer list.  If Vim is
-- 		started with a file name argument, the buffer list is not
-- 		restored.  If Vim is started without a file name argument, the
-- 		buffer list is restored from the shada file.  Quickfix
-- 		(`'buftype'` ), unlisted (`'buflisted'` ), unnamed and buffers on
-- 		removable media (|shada-r|) are not saved.
-- 		When followed by a number, the number specifies the maximum
-- 		number of buffers that are stored.  Without a number all
-- 		buffers are stored.
-- 
-- 	'	Maximum number of previously edited files for which the marks
-- 		are remembered.  This parameter must always be included when
-- 		`'shada'`  is non-empty.
-- 		Including this item also means that the |jumplist| and the
-- 		|changelist| are stored in the shada file.
-- 
-- 	/	Maximum number of items in the search pattern history to be
-- 		saved.  If non-zero, then the previous search and substitute
-- 		patterns are also saved.  When not included, the value of
-- 		`'history'`  is used.
-- 
-- 	:	Maximum number of items in the command-line history to be
-- 		saved.  When not included, the value of `'history'`  is used.
-- 
-- 	<	Maximum number of lines saved for each register.  If zero then
-- 		registers are not saved.  When not included, all lines are
-- 		saved.  `'"'`  is the old name for this item.
-- 		Also see the `'s'`  item below: limit specified in KiB.
-- 
-- 	@	Maximum number of items in the input-line history to be
-- 		saved.  When not included, the value of `'history'`  is used.
-- 
-- 	c	Dummy option, kept for compatibility reasons.  Has no actual
-- 		effect: ShaDa always uses UTF-8 and `'encoding'`  value is fixed
-- 		to UTF-8 as well.
-- 
-- 	f	Whether file marks need to be stored.  If zero, file marks ('0
-- 		to '9, 'A to 'Z) are not stored.  When not present or when
-- 		non-zero, they are all stored.  '0 is used for the current
-- 		cursor position (when exiting or when doing |:wshada|).
-- 
-- 	h	Disable the effect of `'hlsearch'`  when loading the shada
-- 		file.  When not included, it depends on whether ":nohlsearch"
-- 		has been used since the last search command.
-- 
-- 	n	Name of the shada file.  The name must immediately follow
-- 		the `'n'` .  Must be at the end of the option!  If the
-- 		`'shadafile'`  option is set, that file name overrides the one
-- 		given here with `'shada'` .  Environment variables are
-- 		expanded when opening the file, not when setting the option.
-- 
-- 	r	Removable media.  The argument is a string (up to the next
-- 		`','` ).  This parameter can be given several times.  Each
-- 		specifies the start of a path for which no marks will be
-- 		stored.  This is to avoid removable media.  For Windows you
-- 		could use "ra:,rb:".  You can also use it for temp files,
-- 		e.g., for Unix: "r/tmp".  Case is ignored.
-- 
-- 	s	Maximum size of an item contents in KiB.  If zero then nothing
-- 		is saved.  Unlike Vim this applies to all items, except for
-- 		the buffer list and header.  Full item size is off by three
-- 		unsigned integers: with `s10` maximum item size may be 1 byte
-- 		(type: 7-bit integer) + 9 bytes (timestamp: up to 64-bit
-- 		integer) + 3 bytes (item size: up to 16-bit integer because
-- 		2^8 < 10240 < 2^16) + 10240 bytes (requested maximum item
-- 		contents size) = 10253 bytes.
-- 
-- 	Example: >
-- 	    :set shada='50,<1000,s100,:0,n~/nvim/shada
-- <
-- 	'50		Marks will be remembered for the last 50 files you
-- 			edited.
-- 	<1000		Contents of registers (up to 1000 lines each) will be
-- 			remembered.
-- 	s100		Items with contents occupying more then 100 KiB are
-- 			skipped.
-- 	:0		Command-line history will not be saved.
-- 	n~/nvim/shada	The name of the file to use is "~/nvim/shada".
-- 	no /		Since `'/'`  is not specified, the default will be used,
-- 			that is, save all of the search history, and also the
-- 			previous search and substitute patterns.
-- 	no %		The buffer list will not be saved nor read back.
-- 	no h		`'hlsearch'`  highlighting will be restored.
-- 
-- 	When setting `'shada'`  from an empty value you can use |:rshada| to
-- 	load the contents of the file, this is not done automatically.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shada = "!,'100,<50,s10,h"
vim.go.sd = vim.go.shada
-- `'shadafile'`  `'sdf'` 	string	(default: "")
-- 			global
-- 	When non-empty, overrides the file name used for |shada| (viminfo).
-- 	When equal to "NONE" no shada file will be read or written.
-- 	This option can be set with the |-i| command line flag.  The |--clean|
-- 	command line flag sets it to "NONE".
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shadafile = ""
vim.go.sdf = vim.go.shadafile
-- `'shell'`  `'sh'` 		string	(default $SHELL or "sh", Win32: "cmd.exe")
-- 			global
-- 	Name of the shell to use for ! and :! commands.  When changing the
-- 	value also check these options: `'shellpipe'` , `'shellslash'` 
-- 	`'shellredir'` , `'shellquote'` , `'shellxquote'`  and `'shellcmdflag'` .
-- 	It is allowed to give an argument to the command, e.g.  "csh -f".
-- 	See |option-backslash| about including spaces and backslashes.
-- 	Environment variables are expanded |:set_env|.
-- 
-- 	If the name of the shell contains a space, you need to enclose it in
-- 	quotes.  Example with quotes: >
-- 		:set shell=\"c:\program\ files\unix\sh.exe\"\ -f
-- <	Note the backslash before each quote (to avoid starting a comment) and
-- 	each space (to avoid ending the option value), so better use |:let-&|
-- 	like this: >
-- 		:let &shell='"C:\Program Files\unix\sh.exe" -f'
-- <	Also note that the "-f" is not inside the quotes, because it is not
-- 	part of the command name.
-- 
-- 	Rules regarding quotes:
-- 	1. Option is split on space and tab characters that are not inside
-- 	   quotes: "abc def" runs shell named "abc" with additional argument
-- 	   "def", '"abc def"' runs shell named "abc def" with no additional
-- 	   arguments (here and below: additional means “additional to
-- 	   `'shellcmdflag'` ”).
-- 	2. Quotes in option may be present in any position and any number:
-- 	   `'"abc"'` , `'"a"bc'` , `'a"b"c'` , `'ab"c"'`  and `'"a"b"c"'`  are all equivalent
-- 	   to just "abc".
-- 	3. Inside quotes backslash preceding backslash means one backslash.
-- 	   Backslash preceding quote means one quote. Backslash preceding
-- 	   anything else means backslash and next character literally:
-- 	   `'"a\\b"'`  is the same as "a\b", `'"a\\"b"'`  runs shell named literally
-- 	   `'a"b'` , `'"a\b"'`  is the same as "a\b" again.
-- 	4. Outside of quotes backslash always means itself, it cannot be used
-- 	   to escape quote: `'a\"b"'`  is the same as "a\b".
-- 	Note that such processing is done after |:set| did its own round of
-- 	unescaping, so to keep yourself sane use |:let-&| like shown above.
-- 
-- 	To use PowerShell: >
-- 		let &shell = executable(`'pwsh'` ) ? `'pwsh'`  : `'powershell'` 
-- 		let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[`''` Out-File:Encoding`''` ]=`''` utf8`''` ;'
-- 		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
-- 		let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
-- 		set shellquote= shellxquote=
-- 
-- <	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shell = "sh"
vim.go.sh = vim.go.shell
-- `'shellcmdflag'`  `'shcf'` 	string	(default: "-c"; Windows: "/s /c")
-- 			global
-- 	Flag passed to the shell to execute "!" and ":!" commands; e.g.,
-- 	`bash.exe -c ls` or `cmd.exe /s /c "dir"`.  For MS-Windows, the
-- 	default is set according to the value of `'shell'` , to reduce the need
-- 	to set this option by the user.
-- 	On Unix it can have more than one flag.  Each white space separated
-- 	part is passed as an argument to the shell command.
-- 	See |option-backslash| about including spaces and backslashes.
-- 	See |shell-unquoting| which talks about separating this option into
-- 	multiple arguments.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shellcmdflag = "-c"
vim.go.shcf = vim.go.shellcmdflag
-- `'shellpipe'`  `'sp'` 	string	(default ">", "| tee", "|& tee" or "2>&1| tee")
-- 			global
-- 	String to be used to put the output of the ":make" command in the
-- 	error file.  See also |:make_makeprg|.  See |option-backslash| about
-- 	including spaces and backslashes.
-- 	The name of the temporary file can be represented by "%s" if necessary
-- 	(the file name is appended automatically if no %s appears in the value
-- 	of this option).
-- 	For MS-Windows the default is "2>&1| tee".  The stdout and stderr are
-- 	saved in a file and echoed to the screen.
-- 	For Unix the default is "| tee".  The stdout of the compiler is saved
-- 	in a file and echoed to the screen.  If the `'shell'`  option is "csh" or
-- 	"tcsh" after initializations, the default becomes "|& tee".  If the
-- 	`'shell'`  option is "sh", "ksh", "mksh", "pdksh", "zsh", "zsh-beta",
-- 	"bash", "fish", "ash" or "dash" the default becomes "2>&1| tee".  This
-- 	means that stderr is also included.  Before using the `'shell'`  option a
-- 	path is removed, thus "/bin/sh" uses "sh".
-- 	The initialization of this option is done after reading the vimrc
-- 	and the other initializations, so that when the `'shell'`  option is set
-- 	there, the `'shellpipe'`  option changes automatically, unless it was
-- 	explicitly set before.
-- 	When `'shellpipe'`  is set to an empty string, no redirection of the
-- 	":make" output will be done.  This is useful if you use a `'makeprg'` 
-- 	that writes to `'makeef'`  by itself.  If you want no piping, but do
-- 	want to include the `'makeef'` , set `'shellpipe'`  to a single space.
-- 	Don't forget to precede the space with a backslash: ":set sp=\ ".
-- 	In the future pipes may be used for filtering and this option will
-- 	become obsolete (at least for Unix).
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shellpipe = "| tee"
vim.go.sp = vim.go.shellpipe
-- `'shellquote'`  `'shq'` 	string	(default: ""; Windows, when `'shell'` 
-- 					contains "sh" somewhere: "\"")
-- 			global
-- 	Quoting character(s), put around the command passed to the shell, for
-- 	the "!" and ":!" commands.  The redirection is kept outside of the
-- 	quoting.  See `'shellxquote'`  to include the redirection.  It's
-- 	probably not useful to set both options.
-- 	This is an empty string by default.  Only known to be useful for
-- 	third-party shells on Windows systems, such as the MKS Korn Shell
-- 	or bash, where it should be "\"".  The default is adjusted according
-- 	the value of `'shell'` , to reduce the need to set this option by the
-- 	user.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shellquote = ""
vim.go.shq = vim.go.shellquote
-- `'shellredir'`  `'srr'` 	string	(default ">", ">&" or ">%s 2>&1")
-- 			global
-- 	String to be used to put the output of a filter command in a temporary
-- 	file.  See also |:!|.  See |option-backslash| about including spaces
-- 	and backslashes.
-- 	The name of the temporary file can be represented by "%s" if necessary
-- 	(the file name is appended automatically if no %s appears in the value
-- 	of this option).
-- 	The default is ">".  For Unix, if the `'shell'`  option is "csh" or
-- 	"tcsh" during initializations, the default becomes ">&".  If the
-- 	`'shell'`  option is "sh", "ksh", "mksh", "pdksh", "zsh", "zsh-beta",
-- 	"bash" or "fish", the default becomes ">%s 2>&1".  This means that
-- 	stderr is also included.  For Win32, the Unix checks are done and
-- 	additionally "cmd" is checked for, which makes the default ">%s 2>&1".
-- 	Also, the same names with ".exe" appended are checked for.
-- 	The initialization of this option is done after reading the vimrc
-- 	and the other initializations, so that when the `'shell'`  option is set
-- 	there, the `'shellredir'`  option changes automatically unless it was
-- 	explicitly set before.
-- 	In the future pipes may be used for filtering and this option will
-- 	become obsolete (at least for Unix).
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shellredir = ">"
vim.go.srr = vim.go.shellredir
-- `'shellslash'`  `'ssl'` 	boolean	(default off)
-- 			global
-- 			{only for MS-Windows}
-- 	When set, a forward slash is used when expanding file names.  This is
-- 	useful when a Unix-like shell is used instead of cmd.exe.  Backward
-- 	slashes can still be typed, but they are changed to forward slashes by
-- 	Vim.
-- 	Note that setting or resetting this option has no effect for some
-- 	existing file names, thus this option needs to be set before opening
-- 	any file for best results.  This might change in the future.
-- 	`'shellslash'`  only works when a backslash can be used as a path
-- 	separator.  To test if this is so use: >
-- 		if exists(`'+shellslash'` )
-- <	Also see `'completeslash'` .
vim.go.shellslash = false
vim.go.ssl = vim.go.shellslash
-- `'shelltemp'`  `'stmp'` 	boolean	(default on)
-- 			global
-- 	When on, use temp files for shell commands.  When off use a pipe.
-- 	When using a pipe is not possible temp files are used anyway.
-- 	The advantage of using a pipe is that nobody can read the temp file
-- 	and the `'shell'`  command does not need to support redirection.
-- 	The advantage of using a temp file is that the file type and encoding
-- 	can be detected.
-- 	The |FilterReadPre|, |FilterReadPost| and |FilterWritePre|,
-- 	|FilterWritePost| autocommands event are not triggered when
-- 	`'shelltemp'`  is off.
-- 	|system()| does not respect this option, it always uses pipes.
vim.go.shelltemp = true
vim.go.stmp = vim.go.shelltemp
-- `'shellxescape'`  `'sxe'` 	string	(default: "")
-- 			global
-- 	When `'shellxquote'`  is set to "(" then the characters listed in this
-- 	option will be escaped with a `'^'`  character.  This makes it possible
-- 	to execute most external commands with cmd.exe.
vim.go.shellxescape = ""
vim.go.sxe = vim.go.shellxescape
-- `'shellxquote'`  `'sxq'` 	string	(default: "", Windows: "\"")
-- 			global
-- 	Quoting character(s), put around the command passed to the shell, for
-- 	the "!" and ":!" commands.  Includes the redirection.  See
-- 	`'shellquote'`  to exclude the redirection.  It's probably not useful
-- 	to set both options.
-- 	When the value is `'('`  then `')'`  is appended. When the value is `'"('` 
-- 	then `')"'`  is appended.
-- 	When the value is `'('`  then also see `'shellxescape'` .
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.shellxquote = ""
vim.go.sxq = vim.go.shellxquote
-- `'shiftround'`  `'sr'` 	boolean	(default off)
-- 			global
-- 	Round indent to multiple of `'shiftwidth'` .  Applies to > and <
-- 	commands.  CTRL-T and CTRL-D in Insert mode always round the indent to
-- 	a multiple of `'shiftwidth'`  (this is Vi compatible).
vim.go.shiftround = false
vim.go.sr = vim.go.shiftround
-- `'shortmess'`  `'shm'` 	string	(default "filnxtToOF")
-- 			global
-- 	This option helps to avoid all the |hit-enter| prompts caused by file
-- 	messages, for example  with CTRL-G, and to avoid some other messages.
-- 	It is a list of flags:
-- 	 flag	meaning when present	~
-- 	  f	use "(3 of 5)" instead of "(file 3 of 5)"
-- 	  i	use "[noeol]" instead of "[Incomplete last line]"
-- 	  l	use "999L, 888B" instead of "999 lines, 888 bytes"
-- 	  m	use "[+]" instead of "[Modified]"
-- 	  n	use "[New]" instead of "[New File]"
-- 	  r	use "[RO]" instead of "[readonly]"
-- 	  w	use "[w]" instead of "written" for file write message
-- 		and "[a]" instead of "appended" for ':w >> file' command
-- 	  x	use "[dos]" instead of "[dos format]", "[unix]"
-- 		instead of "[unix format]" and "[mac]" instead of "[mac
-- 		format]"
-- 	  a	all of the above abbreviations
-- 
-- 	  o	overwrite message for writing a file with subsequent
-- 		message for reading a file (useful for ":wn" or when
-- 		`'autowrite'`  on)
-- 	  O	message for reading a file overwrites any previous
-- 		message;  also for quickfix message (e.g., ":cn")
-- 	  s	don't give "search hit BOTTOM, continuing at TOP" or
-- 		"search hit TOP, continuing at BOTTOM" messages; when using
-- 		the search count do not show "W" after the count message (see
-- 		S below)
-- 	  t	truncate file message at the start if it is too long
-- 		to fit on the command-line, "<" will appear in the left most
-- 		column; ignored in Ex mode
-- 	  T	truncate other messages in the middle if they are too
-- 		long to fit on the command line; "..." will appear in the
-- 		middle; ignored in Ex mode
-- 	  W	don't give "written" or "[w]" when writing a file
-- 	  A	don't give the "ATTENTION" message when an existing
-- 		swap file is found
-- 	  I	don't give the intro message when starting Vim,
-- 		see |:intro|
-- 	  c	don't give |ins-completion-menu| messages; for
-- 		example, "-- XXX completion (YYY)", "match 1 of 2", "The only
-- 		match", "Pattern not found", "Back at original", etc.
-- 	  C	don't give messages while scanning for ins-completion
-- 		items, for instance "scanning tags"
-- 	  q	use "recording" instead of "recording @a"
-- 	  F	don't give the file info when editing a file, like
-- 		`:silent` was used for the command
-- 	  S	do not show search count message when searching, e.g.
-- 		"[1/5]"
-- 
-- 	This gives you the opportunity to avoid that a change between buffers
-- 	requires you to hit <Enter>, but still gives as useful a message as
-- 	possible for the space available.  To get the whole message that you
-- 	would have got with `'shm'`  empty, use ":file!"
-- 	Useful values:
-- 	    shm=	No abbreviation of message.
-- 	    shm=a	Abbreviation, but no loss of information.
-- 	    shm=at	Abbreviation, and truncate message when necessary.
vim.go.shortmess = "filnxtToOF"
vim.go.shm = vim.go.shortmess
-- `'showcmd'`  `'sc'` 		boolean	(default: on)
-- 			global
-- 	Show (partial) command in the last line of the screen.  Set this
-- 	option off if your terminal is slow.
-- 	In Visual mode the size of the selected area is shown:
-- 	- When selecting characters within a line, the number of characters.
-- 	  If the number of bytes is different it is also displayed: "2-6"
-- 	  means two characters and six bytes.
-- 	- When selecting more than one line, the number of lines.
-- 	- When selecting a block, the size in screen characters:
-- 	  {lines}x{columns}.
-- 	This information can be displayed in an alternative location using the
-- 	`'showcmdloc'`  option, useful when `'cmdheight'`  is 0.
vim.go.showcmd = true
vim.go.sc = vim.go.showcmd
-- `'showcmdloc'`  `'sloc'` 	string	(default "last")
-- 			global
-- 	This option can be used to display the (partially) entered command in
-- 	another location.  Possible values are:
-- 	  last		Last line of the screen (default).
-- 	  statusline	Status line of the current window.
-- 	  tabline	First line of the screen if `'showtabline'`  is enabled.
-- 	Setting this option to "statusline" or "tabline" means that these will
-- 	be redrawn whenever the command changes, which can be on every key
-- 	pressed.
-- 	The %S `'statusline'`  item can be used in `'statusline'`  or `'tabline'`  to
-- 	place the text.  Without a custom `'statusline'`  or `'tabline'`  it will be
-- 	displayed in a convenient location.
vim.go.showcmdloc = "last"
vim.go.sloc = vim.go.showcmdloc
-- `'showfulltag'`  `'sft'` 	boolean (default off)
-- 			global
-- 	When completing a word in insert mode (see |ins-completion|) from the
-- 	tags file, show both the tag name and a tidied-up form of the search
-- 	pattern (if there is one) as possible matches.  Thus, if you have
-- 	matched a C function, you can see a template for what arguments are
-- 	required (coding style permitting).
-- 	Note that this doesn't work well together with having "longest" in
-- 	`'completeopt'` , because the completion from the search pattern may not
-- 	match the typed text.
vim.go.showfulltag = false
vim.go.sft = vim.go.showfulltag
-- `'showmatch'`  `'sm'` 	boolean	(default off)
-- 			global
-- 	When a bracket is inserted, briefly jump to the matching one.  The
-- 	jump is only done if the match can be seen on the screen.  The time to
-- 	show the match can be set with `'matchtime'` .
-- 	A Beep is given if there is no match (no matter if the match can be
-- 	seen or not).
-- 	When the `'m'`  flag is not included in `'cpoptions'` , typing a character
-- 	will immediately move the cursor back to where it belongs.
-- 	See the "sm" field in `'guicursor'`  for setting the cursor shape and
-- 	blinking when showing the match.
-- 	The `'matchpairs'`  option can be used to specify the characters to show
-- 	matches for.  `'rightleft'`  and `'revins'`  are used to look for opposite
-- 	matches.
-- 	Also see the matchparen plugin for highlighting the match when moving
-- 	around |pi_paren.txt|.
-- 	Note: Use of the short form is rated PG.
vim.go.showmatch = false
vim.go.sm = vim.go.showmatch
-- `'showmode'`  `'smd'` 	boolean	(default: on)
-- 			global
-- 	If in Insert, Replace or Visual mode put a message on the last line.
-- 	The |hl-ModeMsg| highlight group determines the highlighting.
-- 	The option has no effect when `'cmdheight'`  is zero.
vim.go.showmode = true
vim.go.smd = vim.go.showmode
-- `'showtabline'`  `'stal'` 	number	(default 1)
-- 			global
-- 	The value of this option specifies when the line with tab page labels
-- 	will be displayed:
-- 		0: never
-- 		1: only if there are at least two tab pages
-- 		2: always
-- 	This is both for the GUI and non-GUI implementation of the tab pages
-- 	line.
-- 	See |tab-page| for more information about tab pages.
vim.go.showtabline = 1
vim.go.stal = vim.go.showtabline
-- `'sidescroll'`  `'ss'` 	number	(default 1)
-- 			global
-- 	The minimal number of columns to scroll horizontally.  Used only when
-- 	the `'wrap'`  option is off and the cursor is moved off of the screen.
-- 	When it is zero the cursor will be put in the middle of the screen.
-- 	When using a slow terminal set it to a large number or 0.  Not used
-- 	for "zh" and "zl" commands.
vim.go.sidescroll = 1
vim.go.ss = vim.go.sidescroll
-- `'smartcase'`  `'scs'` 	boolean	(default off)
-- 			global
-- 	Override the `'ignorecase'`  option if the search pattern contains upper
-- 	case characters.  Only used when the search pattern is typed and
-- 	`'ignorecase'`  option is on.  Used for the commands "/", "?", "n", "N",
-- 	":g" and ":s".  Not used for "*", "#", "gd", tag search, etc.  After
-- 	"*" and "#" you can make `'smartcase'`  used by doing a "/" command,
-- 	recalling the search pattern from history and hitting <Enter>.
vim.go.smartcase = false
vim.go.scs = vim.go.smartcase
-- `'smarttab'`  `'sta'` 	boolean	(default on)
-- 			global
-- 	When on, a <Tab> in front of a line inserts blanks according to
-- 	`'shiftwidth'` .  `'tabstop'`  or `'softtabstop'`  is used in other places.  A
-- 	<BS> will delete a `'shiftwidth'`  worth of space at the start of the
-- 	line.
-- 	When off, a <Tab> always inserts blanks according to `'tabstop'`  or
-- 	`'softtabstop'` .  `'shiftwidth'`  is only used for shifting text left or
-- 	right |shift-left-right|.
-- 	What gets inserted (a <Tab> or spaces) depends on the `'expandtab'` 
-- 	option.  Also see |ins-expandtab|.  When `'expandtab'`  is not set, the
-- 	number of spaces is minimized by using <Tab>s.
vim.go.smarttab = true
vim.go.sta = vim.go.smarttab
-- `'spellsuggest'`  `'sps'` 	string	(default "best")
-- 			global
-- 	Methods used for spelling suggestions.  Both for the |z=| command and
-- 	the |spellsuggest()| function.  This is a comma-separated list of
-- 	items:
-- 
-- 	best		Internal method that works best for English.  Finds
-- 			changes like "fast" and uses a bit of sound-a-like
-- 			scoring to improve the ordering.
-- 
-- 	double		Internal method that uses two methods and mixes the
-- 			results.  The first method is "fast", the other method
-- 			computes how much the suggestion sounds like the bad
-- 			word.  That only works when the language specifies
-- 			sound folding.  Can be slow and doesn't always give
-- 			better results.
-- 
-- 	fast		Internal method that only checks for simple changes:
-- 			character inserts/deletes/swaps.  Works well for
-- 			simple typing mistakes.
-- 
-- 	{number}	The maximum number of suggestions listed for |z=|.
-- 			Not used for |spellsuggest()|.  The number of
-- 			suggestions is never more than the value of `'lines'` 
-- 			minus two.
-- 
-- 	timeout:{millisec}   Limit the time searching for suggestions to
-- 			{millisec} milli seconds.  Applies to the following
-- 			methods.  When omitted the limit is 5000. When
-- 			negative there is no limit.
-- 
-- 	file:{filename} Read file {filename}, which must have two columns,
-- 			separated by a slash.  The first column contains the
-- 			bad word, the second column the suggested good word.
-- 			Example:
-- 				theribal/terrible ~
-- 			Use this for common mistakes that do not appear at the
-- 			top of the suggestion list with the internal methods.
-- 			Lines without a slash are ignored, use this for
-- 			comments.
-- 			The word in the second column must be correct,
-- 			otherwise it will not be used.  Add the word to an
-- 			".add" file if it is currently flagged as a spelling
-- 			mistake.
-- 			The file is used for all languages.
-- 
-- 	expr:{expr}	Evaluate expression {expr}.  Use a function to avoid
-- 			trouble with spaces.  |v:val| holds the badly spelled
-- 			word.  The expression must evaluate to a List of
-- 			Lists, each with a suggestion and a score.
-- 			Example:
-- 				[[`'the'` , 33], [`'that'` , 44]] ~
-- 			Set `'verbose'`  and use |z=| to see the scores that the
-- 			internal methods use.  A lower score is better.
-- 			This may invoke |spellsuggest()| if you temporarily
-- 			set `'spellsuggest'`  to exclude the "expr:" part.
-- 			Errors are silently ignored, unless you set the
-- 			`'verbose'`  option to a non-zero value.
-- 
-- 	Only one of "best", "double" or "fast" may be used.  The others may
-- 	appear several times in any order.  Example: >
-- 		:set sps=file:~/.config/nvim/sugg,best,expr:MySuggest()
-- <
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.spellsuggest = "best"
vim.go.sps = vim.go.spellsuggest
-- `'splitbelow'`  `'sb'` 	boolean	(default off)
-- 			global
-- 	When on, splitting a window will put the new window below the current
-- 	one. |:split|
vim.go.splitbelow = false
vim.go.sb = vim.go.splitbelow
-- `'splitkeep'`  `'spk'` 	string	(default "cursor")
-- 			global
-- 	The value of this option determines the scroll behavior when opening,
-- 	closing or resizing horizontal splits.
-- 
-- 	Possible values are:
-- 	  cursor	Keep the same relative cursor position.
-- 	  screen	Keep the text on the same screen line.
-- 	  topline	Keep the topline the same.
-- 
-- 	For the "screen" and "topline" values, the cursor position will be
-- 	changed when necessary. In this case, the jumplist will be populated
-- 	with the previous cursor position. For "screen", the text cannot always
-- 	be kept on the same screen line when `'wrap'`  is enabled.
vim.go.splitkeep = "cursor"
vim.go.spk = vim.go.splitkeep
-- `'splitright'`  `'spr'` 	boolean	(default off)
-- 			global
-- 	When on, splitting a window will put the new window right of the
-- 	current one. |:vsplit|
vim.go.splitright = false
vim.go.spr = vim.go.splitright
-- `'startofline'`  `'sol'` 	boolean	(default off)
-- 			global
-- 	When "on" the commands listed below move the cursor to the first
-- 	non-blank of the line.  When off the cursor is kept in the same column
-- 	(if possible).  This applies to the commands: CTRL-D, CTRL-U, CTRL-B,
-- 	CTRL-F, "G", "H", "M", "L", gg, and to the commands "d", "<<" and ">>"
-- 	with a linewise operator, with "%" with a count and to buffer changing
-- 	commands (CTRL-^, :bnext, :bNext, etc.).  Also for an Ex command that
-- 	only has a line number, e.g., ":25" or ":+".
-- 	In case of buffer changing commands the cursor is placed at the column
-- 	where it was the last time the buffer was edited.
vim.go.startofline = false
vim.go.sol = vim.go.startofline
-- `'suffixes'`  `'su'` 		string	(default ".bak,~,.o,.h,.info,.swp,.obj")
-- 			global
-- 	Files with these suffixes get a lower priority when multiple files
-- 	match a wildcard.  See |suffixes|.  Commas can be used to separate the
-- 	suffixes.  Spaces after the comma are ignored.  A dot is also seen as
-- 	the start of a suffix.  To avoid a dot or comma being recognized as a
-- 	separator, precede it with a backslash (see |option-backslash| about
-- 	including spaces and backslashes).
-- 	See `'wildignore'`  for completely ignoring files.
-- 	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	suffixes from the list.  This avoids problems when a future version
-- 	uses another default.
vim.go.suffixes = ".bak,~,.o,.h,.info,.swp,.obj"
vim.go.su = vim.go.suffixes
-- `'switchbuf'`  `'swb'` 	string	(default "uselast")
-- 			global
-- 	This option controls the behavior when switching between buffers.
-- 	Mostly for |quickfix| commands some values are also used for other
-- 	commands, as mentioned below.
-- 	Possible values (comma-separated list):
-- 	   useopen	If included, jump to the first open window that
-- 			contains the specified buffer (if there is one).
-- 			Otherwise: Do not examine other windows.
-- 			This setting is checked with |quickfix| commands, when
-- 			jumping to errors (":cc", ":cn", "cp", etc.).  It is
-- 			also used in all buffer related split commands, for
-- 			example ":sbuffer", ":sbnext", or ":sbrewind".
-- 	   usetab	Like "useopen", but also consider windows in other tab
-- 			pages.
-- 	   split	If included, split the current window before loading
-- 			a buffer for a |quickfix| command that display errors.
-- 			Otherwise: do not split, use current window (when used
-- 			in the quickfix window: the previously used window or
-- 			split if there is no other window).
-- 	   vsplit	Just like "split" but split vertically.
-- 	   newtab	Like "split", but open a new tab page.  Overrules
-- 			"split" when both are present.
-- 	   uselast	If included, jump to the previously used window when
-- 			jumping to errors with |quickfix| commands.
vim.go.switchbuf = "uselast"
vim.go.swb = vim.go.switchbuf
-- `'tabline'`  `'tal'` 		string	(default empty)
-- 			global
-- 	When non-empty, this option determines the content of the tab pages
-- 	line at the top of the Vim window.  When empty Vim will use a default
-- 	tab pages line.  See |setting-tabline| for more info.
-- 
-- 	The tab pages line only appears as specified with the `'showtabline'` 
-- 	option and only when there is no GUI tab line.  When `'e'`  is in
-- 	`'guioptions'`  and the GUI supports a tab line `'guitablabel'`  is used
-- 	instead.  Note that the two tab pages lines are very different.
-- 
-- 	The value is evaluated like with `'statusline'` .  You can use
-- 	|tabpagenr()|, |tabpagewinnr()| and |tabpagebuflist()| to figure out
-- 	the text to be displayed.  Use "%1T" for the first label, "%2T" for
-- 	the second one, etc.  Use "%X" items for closing labels.
-- 
-- 	When changing something that is used in `'tabline'`  that does not
-- 	trigger it to be updated, use |:redrawtabline|.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	Keep in mind that only one of the tab pages is the current one, others
-- 	are invisible and you can't jump to their windows.
vim.go.tabline = ""
vim.go.tal = vim.go.tabline
-- `'tabpagemax'`  `'tpm'` 	number	(default 50)
-- 			global
-- 	Maximum number of tab pages to be opened by the |-p| command line
-- 	argument or the ":tab all" command. |tabpage|
vim.go.tabpagemax = 50
vim.go.tpm = vim.go.tabpagemax
-- `'tagbsearch'`  `'tbs'` 	boolean	(default on)
-- 			global
-- 	When searching for a tag (e.g., for the |:ta| command), Vim can either
-- 	use a binary search or a linear search in a tags file.  Binary
-- 	searching makes searching for a tag a LOT faster, but a linear search
-- 	will find more tags if the tags file wasn't properly sorted.
-- 	Vim normally assumes that your tags files are sorted, or indicate that
-- 	they are not sorted.  Only when this is not the case does the
-- 	`'tagbsearch'`  option need to be switched off.
-- 
-- 	When `'tagbsearch'`  is on, binary searching is first used in the tags
-- 	files.  In certain situations, Vim will do a linear search instead for
-- 	certain files, or retry all files with a linear search.  When
-- 	`'tagbsearch'`  is off, only a linear search is done.
-- 
-- 	Linear searching is done anyway, for one file, when Vim finds a line
-- 	at the start of the file indicating that it's not sorted: >
--    !_TAG_FILE_SORTED	0	/some comment/
-- <	[The whitespace before and after the `'0'`  must be a single <Tab>]
-- 
-- 	When a binary search was done and no match was found in any of the
-- 	files listed in `'tags'` , and case is ignored or a pattern is used
-- 	instead of a normal tag name, a retry is done with a linear search.
-- 	Tags in unsorted tags files, and matches with different case will only
-- 	be found in the retry.
-- 
-- 	If a tag file indicates that it is case-fold sorted, the second,
-- 	linear search can be avoided when case is ignored.  Use a value of `'2'` 
-- 	in the "!_TAG_FILE_SORTED" line for this.  A tag file can be case-fold
-- 	sorted with the -f switch to "sort" in most unices, as in the command:
-- 	"sort -f -o tags tags".  For Universal ctags and Exuberant ctags
-- 	version 5.x or higher (at least 5.5) the --sort=foldcase switch can be
-- 	used for this as well.  Note that case must be folded to uppercase for
-- 	this to work.
-- 
-- 	By default, tag searches are case-sensitive.  Case is ignored when
-- 	`'ignorecase'`  is set and `'tagcase'`  is "followic", or when `'tagcase'`  is
-- 	"ignore".
-- 	Also when `'tagcase'`  is "followscs" and `'smartcase'`  is set, or
-- 	`'tagcase'`  is "smart", and the pattern contains only lowercase
-- 	characters.
-- 
-- 	When `'tagbsearch'`  is off, tags searching is slower when a full match
-- 	exists, but faster when no full match exists.  Tags in unsorted tags
-- 	files may only be found with `'tagbsearch'`  off.
-- 	When the tags file is not sorted, or sorted in a wrong way (not on
-- 	ASCII byte value), `'tagbsearch'`  should be off, or the line given above
-- 	must be included in the tags file.
-- 	This option doesn't affect commands that find all matching tags (e.g.,
-- 	command-line completion and ":help").
vim.go.tagbsearch = true
vim.go.tbs = vim.go.tagbsearch
-- `'taglength'`  `'tl'` 	number	(default 0)
-- 			global
-- 	If non-zero, tags are significant up to this number of characters.
vim.go.taglength = 0
vim.go.tl = vim.go.taglength
-- `'tagrelative'`  `'tr'` 	boolean	(default: on)
-- 			global
-- 	If on and using a tags file in another directory, file names in that
-- 	tags file are relative to the directory where the tags file is.
vim.go.tagrelative = true
vim.go.tr = vim.go.tagrelative
-- `'tagstack'`  `'tgst'` 	boolean	(default on)
-- 			global
-- 	When on, the |tagstack| is used normally.  When off, a ":tag" or
-- 	":tselect" command with an argument will not push the tag onto the
-- 	tagstack.  A following ":tag" without an argument, a ":pop" command or
-- 	any other command that uses the tagstack will use the unmodified
-- 	tagstack, but does change the pointer to the active entry.
-- 	Resetting this option is useful when using a ":tag" command in a
-- 	mapping which should not change the tagstack.
vim.go.tagstack = true
vim.go.tgst = vim.go.tagstack
-- `'termbidi'`  `'tbidi'` 	boolean (default off)
-- 			global
-- 	The terminal is in charge of Bi-directionality of text (as specified
-- 	by Unicode).  The terminal is also expected to do the required shaping
-- 	that some languages (such as Arabic) require.
-- 	Setting this option implies that `'rightleft'`  will not be set when
-- 	`'arabic'`  is set and the value of `'arabicshape'`  will be ignored.
-- 	Note that setting `'termbidi'`  has the immediate effect that
-- 	`'arabicshape'`  is ignored, but `'rightleft'`  isn't changed automatically.
-- 	For further details see |arabic.txt|.
vim.go.termbidi = false
vim.go.tbidi = vim.go.termbidi
vim.go.termencoding = ""
vim.go.tenc = vim.go.termencoding
-- `'termguicolors'`  `'tgc'` 	boolean (default off)
-- 			global
-- 	Enables 24-bit RGB color in the |TUI|.  Uses "gui" |:highlight|
-- 	attributes instead of "cterm" attributes. |guifg|
-- 	Requires an ISO-8613-3 compatible terminal.
vim.go.termguicolors = false
vim.go.tgc = vim.go.termguicolors
-- `'termpastefilter'`  `'tpf'` 	string	(default: "BS,HT,ESC,DEL")
-- 			global
-- 	A comma-separated list of options for specifying control characters
-- 	to be removed from the text pasted into the terminal window. The
-- 	supported values are:
-- 
-- 	   BS	    Backspace
-- 
-- 	   HT	    TAB
-- 
-- 	   FF	    Form feed
-- 
-- 	   ESC	    Escape
-- 
-- 	   DEL	    DEL
-- 
-- 	   C0	    Other control characters, excluding Line feed and
-- 		    Carriage return < ' '
-- 
-- 	   C1	    Control characters 0x80...0x9F
vim.go.termpastefilter = "BS,HT,ESC,DEL"
vim.go.tpf = vim.go.termpastefilter
vim.go.terse = false
-- `'tildeop'`  `'top'` 		boolean	(default off)
-- 			global
-- 	When on: The tilde command "~" behaves like an operator.
vim.go.tildeop = false
vim.go.top = vim.go.tildeop
-- `'timeout'`  `'to'` 		boolean (default on)
-- 			global
-- 	This option and `'timeoutlen'`  determine the behavior when part of a
-- 	mapped key sequence has been received. For example, if <c-f> is
-- 	pressed and `'timeout'`  is set, Nvim will wait `'timeoutlen'`  milliseconds
-- 	for any key that can follow <c-f> in a mapping.
vim.go.timeout = true
vim.go.to = vim.go.timeout
-- `'timeoutlen'`  `'tm'` 	number	(default 1000)
-- 			global
-- 	Time in milliseconds to wait for a mapped sequence to complete.
vim.go.timeoutlen = 1000
vim.go.tm = vim.go.timeoutlen
-- `'title'` 			boolean	(default off)
-- 			global
-- 	When on, the title of the window will be set to the value of
-- 	`'titlestring'`  (if it is not empty), or to:
-- 		filename [+=-] (path) - NVIM
-- 	Where:
-- 		filename	the name of the file being edited
-- 		-		indicates the file cannot be modified, `'ma'`  off
-- 		+		indicates the file was modified
-- 		=		indicates the file is read-only
-- 		=+		indicates the file is read-only and modified
-- 		(path)		is the path of the file being edited
-- 		- NVIM		the server name |v:servername| or "NVIM"
vim.go.title = false
-- `'titlelen'` 		number	(default 85)
-- 			global
-- 	Gives the percentage of `'columns'`  to use for the length of the window
-- 	title.  When the title is longer, only the end of the path name is
-- 	shown.  A `'<'`  character before the path name is used to indicate this.
-- 	Using a percentage makes this adapt to the width of the window.  But
-- 	it won't work perfectly, because the actual number of characters
-- 	available also depends on the font used and other things in the title
-- 	bar.  When `'titlelen'`  is zero the full path is used.  Otherwise,
-- 	values from 1 to 30000 percent can be used.
-- 	`'titlelen'`  is also used for the `'titlestring'`  option.
vim.go.titlelen = 85
-- `'titleold'` 		string	(default "")
-- 			global
-- 	If not empty, this option will be used to set the window title when
-- 	exiting.  Only if `'title'`  is enabled.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.titleold = ""
-- `'titlestring'` 		string	(default "")
-- 			global
-- 	When this option is not empty, it will be used for the title of the
-- 	window.  This happens only when the `'title'`  option is on.
-- 
-- 	When this option contains printf-style `'%'`  items, they will be
-- 	expanded according to the rules used for `'statusline'` .
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
-- 
-- 	Example: >
-- 	    :auto BufEnter * let &titlestring = hostname() .. "/" .. expand("%:p")
-- 	    :set title titlestring=%<%F%=%l/%L-%P titlelen=70
-- <	The value of `'titlelen'`  is used to align items in the middle or right
-- 	of the available space.
-- 	Some people prefer to have the file name first: >
-- 	    :set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
-- <	Note the use of "%{ }" and an expression to get the path of the file,
-- 	without the file name.  The "%( %)" constructs are used to add a
-- 	separating space only when needed.
-- 	NOTE: Use of special characters in `'titlestring'`  may cause the display
-- 	to be garbled (e.g., when it contains a CR or NL character).
vim.go.titlestring = ""
-- `'ttimeout'` 		boolean (default on)
-- 			global
-- 	This option and `'ttimeoutlen'`  determine the behavior when part of a
-- 	key code sequence has been received by the |TUI|.
-- 
-- 	For example if <Esc> (the \x1b byte) is received and `'ttimeout'`  is
-- 	set, Nvim waits `'ttimeoutlen'`  milliseconds for the terminal to
-- 	complete a key code sequence. If no input arrives before the timeout,
-- 	a single <Esc> is assumed. Many TUI cursor key codes start with <Esc>.
-- 
-- 	On very slow systems this may fail, causing cursor keys not to work
-- 	sometimes.  If you discover this problem you can ":set ttimeoutlen=9999".
-- 	Nvim will wait for the next character to arrive after an <Esc>.
vim.go.ttimeout = true
-- `'ttimeoutlen'`  `'ttm'` 	number	(default 50)
-- 			global
-- 	Time in milliseconds to wait for a key code sequence to complete. Also
-- 	used for CTRL-\ CTRL-N and CTRL-\ CTRL-G when part of a command has
-- 	been typed.
vim.go.ttimeoutlen = 50
vim.go.ttm = vim.go.ttimeoutlen
vim.go.ttyfast = true
vim.go.tf = vim.go.ttyfast
-- `'undodir'`  `'udir'` 	string	(default "$XDG_STATE_HOME/nvim/undo//")
-- 			global
-- 	List of directory names for undo files, separated with commas.
-- 	See `'backupdir'`  for details of the format.
-- 	"." means using the directory of the file.  The undo file name for
-- 	"file.txt" is ".file.txt.un~".
-- 	For other directories the file name is the full path of the edited
-- 	file, with path separators replaced with "%".
-- 	When writing: The first directory that exists is used.  "." always
-- 	works, no directories after "." will be used for writing.  If none of
-- 	the directories exist Nvim will attempt to create the last directory in
-- 	the list.
-- 	When reading all entries are tried to find an undo file.  The first
-- 	undo file that exists is used.  When it cannot be read an error is
-- 	given, no further entry is used.
-- 	See |undo-persistence|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
-- 
-- 	Note that unlike `'directory'`  and `'backupdir'` , `'undodir'`  always acts as
-- 	though the trailing slashes are present (see `'backupdir'`  for what this
-- 	means).
vim.go.undodir = "/home/runner/.local/state/nvim/undo//"
vim.go.udir = vim.go.undodir
-- `'undoreload'`  `'ur'` 	number	(default 10000)
-- 			global
-- 	Save the whole buffer for undo when reloading it.  This applies to the
-- 	":e!" command and reloading for when the buffer changed outside of
-- 	Vim. |FileChangedShell|
-- 	The save only happens when this option is negative or when the number
-- 	of lines is smaller than the value of this option.
-- 	Set this option to zero to disable undo for a reload.
-- 
-- 	When saving undo for a reload, any undo file is not read.
-- 
-- 	Note that this causes the whole buffer to be stored in memory.  Set
-- 	this option to a lower value if you run out of memory.
vim.go.undoreload = 10000
vim.go.ur = vim.go.undoreload
-- `'updatecount'`  `'uc'` 	number	(default: 200)
-- 			global
-- 	After typing this many characters the swap file will be written to
-- 	disk.  When zero, no swap file will be created at all (see chapter on
-- 	recovery |crash-recovery|).  `'updatecount'`  is set to zero by starting
-- 	Vim with the "-n" option, see |startup|.  When editing in readonly
-- 	mode this option will be initialized to 10000.
-- 	The swapfile can be disabled per buffer with |`'swapfile'` |.
-- 	When `'updatecount'`  is set from zero to non-zero, swap files are
-- 	created for all buffers that have `'swapfile'`  set.  When `'updatecount'` 
-- 	is set to zero, existing swap files are not deleted.
-- 	This option has no meaning in buffers where |`'buftype'` | is "nofile"
-- 	or "nowrite".
vim.go.updatecount = 200
vim.go.uc = vim.go.updatecount
-- `'updatetime'`  `'ut'` 	number	(default 4000)
-- 			global
-- 	If this many milliseconds nothing is typed the swap file will be
-- 	written to disk (see |crash-recovery|).  Also used for the
-- 	|CursorHold| autocommand event.
vim.go.updatetime = 4000
vim.go.ut = vim.go.updatetime
-- `'verbose'`  `'vbs'` 		number	(default 0)
-- 			global
-- 	Sets the verbosity level.  Also set by |-V| and |:verbose|.
-- 
-- 	Tracing of options in Lua scripts is activated at level 1; Lua scripts
-- 	are not traced with verbose=0, for performance.
-- 
-- 	If greater than or equal to a given level, Nvim produces the following
-- 	messages:
-- 
-- 	Level   Messages ~
-- 	----------------------------------------------------------------------
-- 	1	Lua assignments to options, mappings, etc.
-- 	2	When a file is ":source"'ed, or |shada| file is read or written.
-- 	3	UI info, terminal capabilities.
-- 	4	Shell commands.
-- 	5	Every searched tags file and include file.
-- 	8	Files for which a group of autocommands is executed.
-- 	9	Executed autocommands.
-- 	11	Finding items in a path.
-- 	12	Vimscript function calls.
-- 	13	When an exception is thrown, caught, finished, or discarded.
-- 	14	Anything pending in a ":finally" clause.
-- 	15	Ex commands from a script (truncated at 200 characters).
-- 	16	Ex commands.
-- 
-- 	If `'verbosefile'`  is set then the verbose messages are not displayed.
vim.go.verbose = 0
vim.go.vbs = vim.go.verbose
-- `'verbosefile'`  `'vfile'` 	string	(default empty)
-- 			global
-- 	When not empty all messages are written in a file with this name.
-- 	When the file exists messages are appended.
-- 	Writing to the file ends when Vim exits or when `'verbosefile'`  is made
-- 	empty.  Writes are buffered, thus may not show up for some time.
-- 	Setting `'verbosefile'`  to a new value is like making it empty first.
-- 	The difference with |:redir| is that verbose messages are not
-- 	displayed when `'verbosefile'`  is set.
vim.go.verbosefile = ""
vim.go.vfile = vim.go.verbosefile
-- `'viewdir'`  `'vdir'` 	string	(default: "$XDG_STATE_HOME/nvim/view//")
-- 			global
-- 	Name of the directory where to store files for |:mkview|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
vim.go.viewdir = "/home/runner/.local/state/nvim/view//"
vim.go.vdir = vim.go.viewdir
-- `'viewoptions'`  `'vop'` 	string	(default: "folds,cursor,curdir")
-- 			global
-- 	Changes the effect of the |:mkview| command.  It is a comma-separated
-- 	list of words.  Each word enables saving and restoring something:
-- 	   word		save and restore ~
-- 	   cursor	cursor position in file and in window
-- 	   curdir	local current directory, if set with |:lcd|
-- 	   folds	manually created folds, opened/closed folds and local
-- 			fold options
-- 	   options	options and mappings local to a window or buffer (not
-- 			global values for local options)
-- 	   localoptions same as "options"
-- 	   slash	|deprecated| Always enabled. Uses "/" in filenames.
-- 	   unix		|deprecated| Always enabled. Uses "\n" line endings.
vim.go.viewoptions = "folds,cursor,curdir"
vim.go.vop = vim.go.viewoptions
vim.go.viminfo = ""
vim.go.vi = vim.go.viminfo
vim.go.viminfofile = ""
vim.go.vif = vim.go.viminfofile
-- `'visualbell'`  `'vb'` 	boolean	(default off)
-- 			global
-- 	Use visual bell instead of beeping.  Also see `'errorbells'` .
vim.go.visualbell = false
vim.go.vb = vim.go.visualbell
-- `'warn'` 			boolean	(default on)
-- 			global
-- 	Give a warning message when a shell command is used while the buffer
-- 	has been changed.
vim.go.warn = true
-- `'whichwrap'`  `'ww'` 	string	(default: "b,s")
-- 			global
-- 	Allow specified keys that move the cursor left/right to move to the
-- 	previous/next line when the cursor is on the first/last character in
-- 	the line.  Concatenate characters to allow this for these keys:
-- 		char   key	  mode	~
-- 		 b    <BS>	 Normal and Visual
-- 		 s    <Space>	 Normal and Visual
-- 		 h    "h"	 Normal and Visual (not recommended)
-- 		 l    "l"	 Normal and Visual (not recommended)
-- 		 <    <Left>	 Normal and Visual
-- 		 >    <Right>	 Normal and Visual
-- 		 ~    "~"	 Normal
-- 		 [    <Left>	 Insert and Replace
-- 		 ]    <Right>	 Insert and Replace
-- 	For example: >
-- 		:set ww=<,>,[,]
-- <	allows wrap only when cursor keys are used.
-- 	When the movement keys are used in combination with a delete or change
-- 	operator, the <EOL> also counts for a character.  This makes "3h"
-- 	different from "3dh" when the cursor crosses the end of a line.  This
-- 	is also true for "x" and "X", because they do the same as "dl" and
-- 	"dh".  If you use this, you may also want to use the mapping
-- 	":map <BS> X" to make backspace delete the character in front of the
-- 	cursor.
-- 	When `'l'`  is included and it is used after an operator at the end of a
-- 	line (not an empty line) then it will not move to the next line.  This
-- 	makes "dl", "cl", "yl" etc. work normally.
vim.go.whichwrap = "b,s"
vim.go.ww = vim.go.whichwrap
-- `'wildchar'`  `'wc'` 		number	(default: <Tab>)
-- 			global
-- 	Character you have to type to start wildcard expansion in the
-- 	command-line, as specified with `'wildmode'` .
-- 	More info here: |cmdline-completion|.
-- 	The character is not recognized when used inside a macro.  See
-- 	`'wildcharm'`  for that.
-- 	Some keys will not work, such as CTRL-C, <CR> and Enter.
-- 	Although `'wc'`  is a number option, you can set it to a special key: >
-- 		:set wc=<Tab>
-- <
vim.go.wildchar = 9
vim.go.wc = vim.go.wildchar
-- `'wildcharm'`  `'wcm'` 	number	(default: none (0))
-- 			global
-- 	`'wildcharm'`  works exactly like `'wildchar'` , except that it is
-- 	recognized when used inside a macro.  You can find "spare" command-line
-- 	keys suitable for this option by looking at |ex-edit-index|.  Normally
-- 	you'll never actually type `'wildcharm'` , just use it in mappings that
-- 	automatically invoke completion mode, e.g.: >
-- 		:set wcm=<C-Z>
-- 		:cnoremap ss so $vim/sessions/*.vim<C-Z>
-- <	Then after typing :ss you can use CTRL-P & CTRL-N.
vim.go.wildcharm = 0
vim.go.wcm = vim.go.wildcharm
-- `'wildignore'`  `'wig'` 	string	(default "")
-- 			global
-- 	A list of file patterns.  A file that matches with one of these
-- 	patterns is ignored when expanding |wildcards|, completing file or
-- 	directory names, and influences the result of |expand()|, |glob()| and
-- 	|globpath()| unless a flag is passed to disable this.
-- 	The pattern is used like with |:autocmd|, see |autocmd-pattern|.
-- 	Also see `'suffixes'` .
-- 	Example: >
-- 		:set wildignore=.obj
-- <	The use of |:set+=| and |:set-=| is preferred when adding or removing
-- 	a pattern from the list.  This avoids problems when a future version
-- 	uses another default.
vim.go.wildignore = ""
vim.go.wig = vim.go.wildignore
-- `'wildignorecase'`  `'wic'` 	boolean	(default off)
-- 			global
-- 	When set case is ignored when completing file names and directories.
-- 	Has no effect when `'fileignorecase'`  is set.
-- 	Does not apply when the shell is used to expand wildcards, which
-- 	happens when there are special characters.
vim.go.wildignorecase = false
vim.go.wic = vim.go.wildignorecase
-- `'wildmenu'`  `'wmnu'` 	boolean	(default on)
-- 			global
-- 	When `'wildmenu'`  is on, command-line completion operates in an enhanced
-- 	mode.  On pressing `'wildchar'`  (usually <Tab>) to invoke completion,
-- 	the possible matches are shown.
-- 	When `'wildoptions'`  contains "pum", then the completion matches are
-- 	shown in a popup menu.  Otherwise they are displayed just above the
-- 	command line, with the first match highlighted (overwriting the status
-- 	line, if there is one).
-- 	Keys that show the previous/next match, such as <Tab> or
-- 	CTRL-P/CTRL-N, cause the highlight to move to the appropriate match.
-- 	`'wildmode'`  must specify "full": "longest" and "list" do not start
-- 	`'wildmenu'`  mode. You can check the current mode with |wildmenumode()|.
-- 	The menu is cancelled when a key is hit that is not used for selecting
-- 	a completion.
-- 
-- 	While the menu is active these keys have special meanings:
-- 
-- 	CTRL-Y		- accept the currently selected match and stop
-- 			  completion.
-- 	CTRL-E		- end completion, go back to what was there before
-- 			  selecting a match.
-- 	<Left> <Right>	- select previous/next match (like CTRL-P/CTRL-N)
-- 	<Down>		- in filename/menu name completion: move into a
-- 			  subdirectory or submenu.
-- 	<CR>		- in menu completion, when the cursor is just after a
-- 			  dot: move into a submenu.
-- 	<Up>		- in filename/menu name completion: move up into
-- 			  parent directory or parent menu.
-- 
-- 	If you want <Left> and <Right> to move the cursor instead of selecting
-- 	a different match, use this: >
-- 		:cnoremap <Left> <Space><BS><Left>
-- 		:cnoremap <Right> <Space><BS><Right>
-- <
-- 	|hl-WildMenu| highlights the current match.
vim.go.wildmenu = true
vim.go.wmnu = vim.go.wildmenu
-- `'wildmode'`  `'wim'` 	string	(default: "full")
-- 			global
-- 	Completion mode that is used for the character specified with
-- 	`'wildchar'` .  It is a comma-separated list of up to four parts.  Each
-- 	part specifies what to do for each consecutive use of `'wildchar'` .  The
-- 	first part specifies the behavior for the first use of `'wildchar'` ,
-- 	The second part for the second use, etc.
-- 
-- 	Each part consists of a colon separated list consisting of the
-- 	following possible values:
-- 	""		Complete only the first match.
-- 	"full"		Complete the next full match.  After the last match,
-- 			the original string is used and then the first match
-- 			again.  Will also start `'wildmenu'`  if it is enabled.
-- 	"longest"	Complete till longest common string.  If this doesn't
-- 			result in a longer string, use the next part.
-- 	"list"		When more than one match, list all matches.
-- 	"lastused"	When completing buffer names and more than one buffer
-- 			matches, sort buffers by time last used (other than
-- 			the current buffer).
-- 	When there is only a single match, it is fully completed in all cases.
-- 
-- 	Examples of useful colon-separated values:
-- 	"longest:full"	Like "longest", but also start `'wildmenu'`  if it is
-- 			enabled.  Will not complete to the next full match.
-- 	"list:full"	When more than one match, list all matches and
-- 			complete first match.
-- 	"list:longest"	When more than one match, list all matches and
-- 			complete till longest common string.
-- 	"list:lastused" When more than one buffer matches, list all matches
-- 			and sort buffers by time last used (other than the
-- 			current buffer).
-- 
-- 	Examples: >
-- 		:set wildmode=full
-- <	Complete first full match, next match, etc.  (the default) >
-- 		:set wildmode=longest,full
-- <	Complete longest common string, then each full match >
-- 		:set wildmode=list:full
-- <	List all matches and complete each full match >
-- 		:set wildmode=list,full
-- <	List all matches without completing, then each full match >
-- 		:set wildmode=longest,list
-- <	Complete longest common string, then list alternatives.
-- 	More info here: |cmdline-completion|.
vim.go.wildmode = "full"
vim.go.wim = vim.go.wildmode
-- `'wildoptions'`  `'wop'` 	string	(default "pum,tagfile")
-- 			global
-- 	A list of words that change how |cmdline-completion| is done.
-- 	The following values are supported:
-- 	  fuzzy		Use |fuzzy-matching| to find completion matches. When
-- 			this value is specified, wildcard expansion will not
-- 			be used for completion.  The matches will be sorted by
-- 			the "best match" rather than alphabetically sorted.
-- 			This will find more matches than the wildcard
-- 			expansion. Currently fuzzy matching based completion
-- 			is not supported for file and directory names and
-- 			instead wildcard expansion is used.
-- 	  pum		Display the completion matches using the popup menu
-- 			in the same style as the |ins-completion-menu|.
-- 	  tagfile	When using CTRL-D to list matching tags, the kind of
-- 			tag and the file of the tag is listed.	Only one match
-- 			is displayed per line.  Often used tag kinds are:
-- 				d	#define
-- 				f	function
vim.go.wildoptions = "pum,tagfile"
vim.go.wop = vim.go.wildoptions
-- `'winaltkeys'`  `'wak'` 	string	(default "menu")
-- 			global
-- 			{only used in Win32}
-- 	Some GUI versions allow the access to menu entries by using the ALT
-- 	key in combination with a character that appears underlined in the
-- 	menu.  This conflicts with the use of the ALT key for mappings and
-- 	entering special characters.  This option tells what to do:
-- 	  no	Don't use ALT keys for menus.  ALT key combinations can be
-- 		mapped, but there is no automatic handling.
-- 	  yes	ALT key handling is done by the windowing system.  ALT key
-- 		combinations cannot be mapped.
-- 	  menu	Using ALT in combination with a character that is a menu
-- 		shortcut key, will be handled by the windowing system.  Other
-- 		keys can be mapped.
-- 	If the menu is disabled by excluding `'m'`  from `'guioptions'` , the ALT
-- 	key is never used for the menu.
-- 	This option is not used for <F10>; on Win32.
vim.go.winaltkeys = "menu"
vim.go.wak = vim.go.winaltkeys
-- `'window'`  `'wi'` 		number  (default screen height - 1)
-- 			global
-- 	Window height used for |CTRL-F| and |CTRL-B| when there is only one
-- 	window and the value is smaller than `'lines'`  minus one.  The screen
-- 	will scroll `'window'`  minus two lines, with a minimum of one.
-- 	When `'window'`  is equal to `'lines'`  minus one CTRL-F and CTRL-B scroll
-- 	in a much smarter way, taking care of wrapping lines.
-- 	When resizing the Vim window, the value is smaller than 1 or more than
-- 	or equal to `'lines'`  it will be set to `'lines'`  minus 1.
-- 	Note: Do not confuse this with the height of the Vim window, use
-- 	`'lines'`  for that.
vim.go.window = 23
vim.go.wi = vim.go.window
-- `'winheight'`  `'wh'` 	number	(default 1)
-- 			global
-- 	Minimal number of lines for the current window.  This is not a hard
-- 	minimum, Vim will use fewer lines if there is not enough room.  If the
-- 	focus goes to a window that is smaller, its size is increased, at the
-- 	cost of the height of other windows.
-- 	Set `'winheight'`  to a small number for normal editing.
-- 	Set it to 999 to make the current window fill most of the screen.
-- 	Other windows will be only `'winminheight'`  high.  This has the drawback
-- 	that ":all" will create only two windows.  To avoid "vim -o 1 2 3 4"
-- 	to create only two windows, set the option after startup is done,
-- 	using the |VimEnter| event: >
-- 		au VimEnter * set winheight=999
-- <	Minimum value is 1.
-- 	The height is not adjusted after one of the commands that change the
-- 	height of the current window.
-- 	`'winheight'`  applies to the current window.  Use `'winminheight'`  to set
-- 	the minimal height for other windows.
vim.go.winheight = 1
vim.go.wh = vim.go.winheight
-- `'winminheight'`  `'wmh'` 	number	(default 1)
-- 			global
-- 	The minimal height of a window, when it's not the current window.
-- 	This is a hard minimum, windows will never become smaller.
-- 	When set to zero, windows may be "squashed" to zero lines (i.e. just a
-- 	status bar) if necessary.  They will return to at least one line when
-- 	they become active (since the cursor has to have somewhere to go.)
-- 	Use `'winheight'`  to set the minimal height of the current window.
-- 	This option is only checked when making a window smaller.  Don't use a
-- 	large number, it will cause errors when opening more than a few
-- 	windows.  A value of 0 to 3 is reasonable.
vim.go.winminheight = 1
vim.go.wmh = vim.go.winminheight
-- `'winminwidth'`  `'wmw'` 	number	(default 1)
-- 			global
-- 	The minimal width of a window, when it's not the current window.
-- 	This is a hard minimum, windows will never become smaller.
-- 	When set to zero, windows may be "squashed" to zero columns (i.e. just
-- 	a vertical separator) if necessary.  They will return to at least one
-- 	line when they become active (since the cursor has to have somewhere
-- 	to go.)
-- 	Use `'winwidth'`  to set the minimal width of the current window.
-- 	This option is only checked when making a window smaller.  Don't use a
-- 	large number, it will cause errors when opening more than a few
-- 	windows.  A value of 0 to 12 is reasonable.
vim.go.winminwidth = 1
vim.go.wmw = vim.go.winminwidth
-- `'winwidth'`  `'wiw'` 	number	(default 20)
-- 			global
-- 	Minimal number of columns for the current window.  This is not a hard
-- 	minimum, Vim will use fewer columns if there is not enough room.  If
-- 	the current window is smaller, its size is increased, at the cost of
-- 	the width of other windows.  Set it to 999 to make the current window
-- 	always fill the screen.  Set it to a small number for normal editing.
-- 	The width is not adjusted after one of the commands to change the
-- 	width of the current window.
-- 	`'winwidth'`  applies to the current window.  Use `'winminwidth'`  to set
-- 	the minimal width for other windows.
vim.go.winwidth = 20
vim.go.wiw = vim.go.winwidth
-- `'wrapscan'`  `'ws'` 		boolean	(default on)
-- 			global
-- 	Searches wrap around the end of the file.  Also applies to |]s| and
-- 	|[s|, searching for spelling mistakes.
vim.go.wrapscan = true
vim.go.ws = vim.go.wrapscan
-- `'write'` 			boolean	(default on)
-- 			global
-- 	Allows writing files.  When not set, writing a file is not allowed.
-- 	Can be used for a view-only mode, where modifications to the text are
-- 	still allowed.  Can be reset with the |-m| or |-M| command line
-- 	argument.  Filtering text is still possible, even though this requires
-- 	writing a temporary file.
vim.go.write = true
-- `'writeany'`  `'wa'` 		boolean	(default off)
-- 			global
-- 	Allows writing to any file with no need for "!" override.
vim.go.writeany = false
vim.go.wa = vim.go.writeany
-- `'writebackup'`  `'wb'` 	boolean	(default on)
-- 			global
-- 	Make a backup before overwriting a file.  The backup is removed after
-- 	the file was successfully written, unless the `'backup'`  option is
-- 	also on.
-- 	WARNING: Switching this option off means that when Vim fails to write
-- 	your buffer correctly and then, for whatever reason, Vim exits, you
-- 	lose both the original file and what you were writing.  Only reset
-- 	this option if your file system is almost full and it makes the write
-- 	fail (and make sure not to exit Vim until the write was successful).
-- 	See |backup-table| for another explanation.
-- 	When the `'backupskip'`  pattern matches, a backup is not made anyway.
-- 	Depending on `'backupcopy'`  the backup is a new file or the original
-- 	file renamed (and a new file is written).
vim.go.writebackup = true
vim.go.wb = vim.go.writebackup
vim.go.writedelay = 0
vim.go.wd = vim.go.writedelay


---@class vim.wo
vim.wo = {}

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
vim.wo.arabic = false
vim.wo.arab = vim.wo.arabic
-- `'breakindent'`  `'bri'` 	boolean (default off)
-- 			local to window
-- 	Every wrapped line will continue visually indented (same amount of
-- 	space as the beginning of that line), thus preserving horizontal blocks
-- 	of text.
vim.wo.breakindent = false
vim.wo.bri = vim.wo.breakindent
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
vim.wo.breakindentopt = ""
vim.wo.briopt = vim.wo.breakindentopt
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
vim.wo.colorcolumn = ""
vim.wo.cc = vim.wo.colorcolumn
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
vim.wo.concealcursor = ""
vim.wo.cocu = vim.wo.concealcursor
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
vim.wo.conceallevel = 0
vim.wo.cole = vim.wo.conceallevel
-- `'cursorbind'`  `'crb'` 	boolean  (default off)
-- 			local to window
-- 	When this option is set, as the cursor in the current
-- 	window moves other cursorbound windows (windows that also have
-- 	this option set) move their cursors to the corresponding line and
-- 	column.  This option is useful for viewing the
-- 	differences between two versions of a file (see `'diff'` ); in diff mode,
-- 	inserted and deleted lines (though not characters within a line) are
-- 	taken into account.
vim.wo.cursorbind = false
vim.wo.crb = vim.wo.cursorbind
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
vim.wo.cursorcolumn = false
vim.wo.cuc = vim.wo.cursorcolumn
