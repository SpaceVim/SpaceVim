---@meta

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
--- @class vim.opt.display: vim.Option,string[]
--- @operator add: vim.opt.display
--- @operator sub: vim.opt.display
--- @operator pow: vim.opt.display
vim.opt.display = "lastline"
vim.opt.dy = vim.opt.display
--- @return string[]
function vim.opt.display:get()end

-- `'eadirection'`  `'ead'` 	string	(default "both")
-- 			global
-- 	Tells when the `'equalalways'`  option applies:
-- 		ver	vertically, width of windows is not affected
-- 		hor	horizontally, height of windows is not affected
-- 		both	width and height of windows is affected
--- @class vim.opt.eadirection: vim.Option,string
--- @operator add: vim.opt.eadirection
--- @operator sub: vim.opt.eadirection
--- @operator pow: vim.opt.eadirection
vim.opt.eadirection = "both"
vim.opt.ead = vim.opt.eadirection
--- @return string
function vim.opt.eadirection:get()end

--- @class vim.opt.edcompatible: vim.Option,boolean
--- @operator add: vim.opt.edcompatible
--- @operator sub: vim.opt.edcompatible
--- @operator pow: vim.opt.edcompatible
vim.opt.edcompatible = false
vim.opt.ed = vim.opt.edcompatible
--- @return boolean
function vim.opt.edcompatible:get()end

-- `'emoji'`  `'emo'` 	boolean (default: on)
-- 			global
-- 	When on all Unicode emoji characters are considered to be full width.
-- 	This excludes "text emoji" characters, which are normally displayed as
-- 	single width.  Unfortunately there is no good specification for this
-- 	and it has been determined on trial-and-error basis.  Use the
-- 	|setcellwidths()| function to change the behavior.
--- @class vim.opt.emoji: vim.Option,boolean
--- @operator add: vim.opt.emoji
--- @operator sub: vim.opt.emoji
--- @operator pow: vim.opt.emoji
vim.opt.emoji = true
vim.opt.emo = vim.opt.emoji
--- @return boolean
function vim.opt.emoji:get()end

-- `'encoding'`  `'enc'` 
-- 	String-encoding used internally and for |RPC| communication.
-- 	Always UTF-8.
-- 
-- 	See `'fileencoding'`  to control file-content encoding.
--- @class vim.opt.encoding: vim.Option,string
--- @operator add: vim.opt.encoding
--- @operator sub: vim.opt.encoding
--- @operator pow: vim.opt.encoding
vim.opt.encoding = "utf-8"
vim.opt.enc = vim.opt.encoding
--- @return string
function vim.opt.encoding:get()end

-- `'endoffile'`  `'eof'` 	boolean	(default off)
-- 			local to buffer
-- 	Indicates that a CTRL-Z character was found at the end of the file
-- 	when reading it.  Normally only happens when `'fileformat'`  is "dos".
-- 	When writing a file and this option is off and the `'binary'`  option
-- 	is on, or `'fixeol'`  option is off, no CTRL-Z will be written at the
-- 	end of the file.
-- 	See |eol-and-eof| for example settings.
--- @class vim.opt.endoffile: vim.Option,boolean
--- @operator add: vim.opt.endoffile
--- @operator sub: vim.opt.endoffile
--- @operator pow: vim.opt.endoffile
vim.opt.endoffile = false
vim.opt.eof = vim.opt.endoffile
--- @return boolean
function vim.opt.endoffile:get()end

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
--- @class vim.opt.endofline: vim.Option,boolean
--- @operator add: vim.opt.endofline
--- @operator sub: vim.opt.endofline
--- @operator pow: vim.opt.endofline
vim.opt.endofline = true
vim.opt.eol = vim.opt.endofline
--- @return boolean
function vim.opt.endofline:get()end

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
--- @class vim.opt.equalalways: vim.Option,boolean
--- @operator add: vim.opt.equalalways
--- @operator sub: vim.opt.equalalways
--- @operator pow: vim.opt.equalalways
vim.opt.equalalways = true
vim.opt.ea = vim.opt.equalalways
--- @return boolean
function vim.opt.equalalways:get()end

-- `'equalprg'`  `'ep'` 		string	(default "")
-- 			global or local to buffer |global-local|
-- 	External program to use for "=" command.  When this option is empty
-- 	the internal formatting functions are used; either `'lisp'` , `'cindent'` 
-- 	or `'indentexpr'` .
-- 	Environment variables are expanded |:set_env|.  See |option-backslash|
-- 	about including spaces and backslashes.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.equalprg: vim.Option,string
--- @operator add: vim.opt.equalprg
--- @operator sub: vim.opt.equalprg
--- @operator pow: vim.opt.equalprg
vim.opt.equalprg = ""
vim.opt.ep = vim.opt.equalprg
--- @return string
function vim.opt.equalprg:get()end

-- `'errorbells'`  `'eb'` 	boolean	(default off)
-- 			global
-- 	Ring the bell (beep or screen flash) for error messages.  This only
-- 	makes a difference for error messages, the bell will be used always
-- 	for a lot of errors without a message (e.g., hitting <Esc> in Normal
-- 	mode).  See `'visualbell'`  to make the bell behave like a screen flash
-- 	or do nothing. See `'belloff'`  to finetune when to ring the bell.
--- @class vim.opt.errorbells: vim.Option,boolean
--- @operator add: vim.opt.errorbells
--- @operator sub: vim.opt.errorbells
--- @operator pow: vim.opt.errorbells
vim.opt.errorbells = false
vim.opt.eb = vim.opt.errorbells
--- @return boolean
function vim.opt.errorbells:get()end

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
--- @class vim.opt.errorfile: vim.Option,string
--- @operator add: vim.opt.errorfile
--- @operator sub: vim.opt.errorfile
--- @operator pow: vim.opt.errorfile
vim.opt.errorfile = "errors.err"
vim.opt.ef = vim.opt.errorfile
--- @return string
function vim.opt.errorfile:get()end

-- `'errorformat'`  `'efm'` 	string	(default is very long)
-- 			global or local to buffer |global-local|
-- 	Scanf-like description of the format for the lines in the error file
-- 	(see |errorformat|).
--- @class vim.opt.errorformat: vim.Option,string[]
--- @operator add: vim.opt.errorformat
--- @operator sub: vim.opt.errorformat
--- @operator pow: vim.opt.errorformat
vim.opt.errorformat = "%*[^\"]\"%f\"%*\\D%l: %m,\"%f\"%*\\D%l: %m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,\"%f\"\\, line %l%*\\D%c%*[^ ] %m,%D%*\\a[%*\\d]: Entering directory %*[`']%f',%X%*\\a[%*\\d]: Leaving directory %*[`']%f',%D%*\\a: Entering directory %*[`']%f',%X%*\\a: Leaving directory %*[`']%f',%DMaking %*\\a in %f,%f|%l| %m"
vim.opt.efm = vim.opt.errorformat
--- @return string[]
function vim.opt.errorformat:get()end

-- `'eventignore'`  `'ei'` 	string	(default "")
-- 			global
-- 	A list of autocommand event names, which are to be ignored.
-- 	When set to "all" or when "all" is one of the items, all autocommand
-- 	events are ignored, autocommands will not be executed.
-- 	Otherwise this is a comma-separated list of event names.  Example: >
-- 	    :set ei=WinEnter,WinLeave
-- <
--- @class vim.opt.eventignore: vim.Option,string[]
--- @operator add: vim.opt.eventignore
--- @operator sub: vim.opt.eventignore
--- @operator pow: vim.opt.eventignore
vim.opt.eventignore = ""
vim.opt.ei = vim.opt.eventignore
--- @return string[]
function vim.opt.eventignore:get()end

-- `'expandtab'`  `'et'` 	boolean	(default off)
-- 			local to buffer
-- 	In Insert mode: Use the appropriate number of spaces to insert a
-- 	<Tab>.  Spaces are used in indents with the `'>'`  and `'<'`  commands and
-- 	when `'autoindent'`  is on.  To insert a real tab when `'expandtab'`  is
-- 	on, use CTRL-V<Tab>.  See also |:retab| and |ins-expandtab|.
--- @class vim.opt.expandtab: vim.Option,boolean
--- @operator add: vim.opt.expandtab
--- @operator sub: vim.opt.expandtab
--- @operator pow: vim.opt.expandtab
vim.opt.expandtab = false
vim.opt.et = vim.opt.expandtab
--- @return boolean
function vim.opt.expandtab:get()end

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
--- @class vim.opt.exrc: vim.Option,boolean
--- @operator add: vim.opt.exrc
--- @operator sub: vim.opt.exrc
--- @operator pow: vim.opt.exrc
vim.opt.exrc = false
vim.opt.ex = vim.opt.exrc
--- @return boolean
function vim.opt.exrc:get()end

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
--- @class vim.opt.fileencoding: vim.Option,string
--- @operator add: vim.opt.fileencoding
--- @operator sub: vim.opt.fileencoding
--- @operator pow: vim.opt.fileencoding
vim.opt.fileencoding = ""
vim.opt.fenc = vim.opt.fileencoding
--- @return string
function vim.opt.fileencoding:get()end

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
--- @class vim.opt.fileencodings: vim.Option,string[]
--- @operator add: vim.opt.fileencodings
--- @operator sub: vim.opt.fileencodings
--- @operator pow: vim.opt.fileencodings
vim.opt.fileencodings = "ucs-bom,utf-8,default,latin1"
vim.opt.fencs = vim.opt.fileencodings
--- @return string[]
function vim.opt.fileencodings:get()end

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
--- @class vim.opt.fileformat: vim.Option,string
--- @operator add: vim.opt.fileformat
--- @operator sub: vim.opt.fileformat
--- @operator pow: vim.opt.fileformat
vim.opt.fileformat = "unix"
vim.opt.ff = vim.opt.fileformat
--- @return string
function vim.opt.fileformat:get()end

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
--- @class vim.opt.fileformats: vim.Option,string[]
--- @operator add: vim.opt.fileformats
--- @operator sub: vim.opt.fileformats
--- @operator pow: vim.opt.fileformats
vim.opt.fileformats = "unix,dos"
vim.opt.ffs = vim.opt.fileformats
--- @return string[]
function vim.opt.fileformats:get()end

-- `'fileignorecase'`  `'fic'` 	boolean	(default on for systems where case in file
-- 				 names is normally ignored)
-- 			global
-- 	When set case is ignored when using file names and directories.
-- 	See `'wildignorecase'`  for only ignoring case when doing completion.
--- @class vim.opt.fileignorecase: vim.Option,boolean
--- @operator add: vim.opt.fileignorecase
--- @operator sub: vim.opt.fileignorecase
--- @operator pow: vim.opt.fileignorecase
vim.opt.fileignorecase = false
vim.opt.fic = vim.opt.fileignorecase
--- @return boolean
function vim.opt.fileignorecase:get()end

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
--- @class vim.opt.filetype: vim.Option,string
--- @operator add: vim.opt.filetype
--- @operator sub: vim.opt.filetype
--- @operator pow: vim.opt.filetype
vim.opt.filetype = ""
vim.opt.ft = vim.opt.filetype
--- @return string
function vim.opt.filetype:get()end

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
--- @class vim.opt.fillchars: vim.Option,table<string, string>
--- @operator add: vim.opt.fillchars
--- @operator sub: vim.opt.fillchars
--- @operator pow: vim.opt.fillchars
vim.opt.fillchars = ""
vim.opt.fcs = vim.opt.fillchars
--- @return table<string, string>
function vim.opt.fillchars:get()end

-- `'fixendofline'`  `'fixeol'` 	boolean	(default on)
-- 			local to buffer
-- 	When writing a file and this option is on, <EOL> at the end of file
-- 	will be restored if missing.  Turn this option off if you want to
-- 	preserve the situation from the original file.
-- 	When the `'binary'`  option is set the value of this option doesn't
-- 	matter.
-- 	See the `'endofline'`  option.
-- 	See |eol-and-eof| for example settings.
--- @class vim.opt.fixendofline: vim.Option,boolean
--- @operator add: vim.opt.fixendofline
--- @operator sub: vim.opt.fixendofline
--- @operator pow: vim.opt.fixendofline
vim.opt.fixendofline = true
vim.opt.fixeol = vim.opt.fixendofline
--- @return boolean
function vim.opt.fixendofline:get()end

-- `'foldclose'`  `'fcl'` 	string (default "")
-- 			global
-- 	When set to "all", a fold is closed when the cursor isn't in it and
-- 	its level is higher than `'foldlevel'` .  Useful if you want folds to
-- 	automatically close when moving out of them.
--- @class vim.opt.foldclose: vim.Option,string[]
--- @operator add: vim.opt.foldclose
--- @operator sub: vim.opt.foldclose
--- @operator pow: vim.opt.foldclose
vim.opt.foldclose = ""
vim.opt.fcl = vim.opt.foldclose
--- @return string[]
function vim.opt.foldclose:get()end

-- `'foldcolumn'`  `'fdc'` 	string (default "0")
-- 			local to window
-- 	When and how to draw the foldcolumn. Valid values are:
-- 	    "auto":       resize to the minimum amount of folds to display.
-- 	    "auto:[1-9]": resize to accommodate multiple folds up to the
-- 			  selected level
--             0:            to disable foldcolumn
-- 	    "[1-9]":      to display a fixed number of columns
-- 	See |folding|.
--- @class vim.opt.foldcolumn: vim.Option,string
--- @operator add: vim.opt.foldcolumn
--- @operator sub: vim.opt.foldcolumn
--- @operator pow: vim.opt.foldcolumn
vim.opt.foldcolumn = "0"
vim.opt.fdc = vim.opt.foldcolumn
--- @return string
function vim.opt.foldcolumn:get()end

-- `'foldenable'`  `'fen'` 	boolean (default on)
-- 			local to window
-- 	When off, all folds are open.  This option can be used to quickly
-- 	switch between showing all text unfolded and viewing the text with
-- 	folds (including manually opened or closed folds).  It can be toggled
-- 	with the |zi| command.  The `'foldcolumn'`  will remain blank when
-- 	`'foldenable'`  is off.
-- 	This option is set by commands that create a new fold or close a fold.
-- 	See |folding|.
--- @class vim.opt.foldenable: vim.Option,boolean
--- @operator add: vim.opt.foldenable
--- @operator sub: vim.opt.foldenable
--- @operator pow: vim.opt.foldenable
vim.opt.foldenable = true
vim.opt.fen = vim.opt.foldenable
--- @return boolean
function vim.opt.foldenable:get()end

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
--- @class vim.opt.foldexpr: vim.Option,string
--- @operator add: vim.opt.foldexpr
--- @operator sub: vim.opt.foldexpr
--- @operator pow: vim.opt.foldexpr
vim.opt.foldexpr = "0"
vim.opt.fde = vim.opt.foldexpr
--- @return string
function vim.opt.foldexpr:get()end

-- `'foldignore'`  `'fdi'` 	string (default: "#")
-- 			local to window
-- 	Used only when `'foldmethod'`  is "indent".  Lines starting with
-- 	characters in `'foldignore'`  will get their fold level from surrounding
-- 	lines.  White space is skipped before checking for this character.
-- 	The default "#" works well for C programs.  See |fold-indent|.
--- @class vim.opt.foldignore: vim.Option,string
--- @operator add: vim.opt.foldignore
--- @operator sub: vim.opt.foldignore
--- @operator pow: vim.opt.foldignore
vim.opt.foldignore = "#"
vim.opt.fdi = vim.opt.foldignore
--- @return string
function vim.opt.foldignore:get()end

-- `'foldlevel'`  `'fdl'` 	number (default: 0)
-- 			local to window
-- 	Sets the fold level: Folds with a higher level will be closed.
-- 	Setting this option to zero will close all folds.  Higher numbers will
-- 	close fewer folds.
-- 	This option is set by commands like |zm|, |zM| and |zR|.
-- 	See |fold-foldlevel|.
--- @class vim.opt.foldlevel: vim.Option,number
--- @operator add: vim.opt.foldlevel
--- @operator sub: vim.opt.foldlevel
--- @operator pow: vim.opt.foldlevel
vim.opt.foldlevel = 0
vim.opt.fdl = vim.opt.foldlevel
--- @return number
function vim.opt.foldlevel:get()end

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
--- @class vim.opt.foldlevelstart: vim.Option,number
--- @operator add: vim.opt.foldlevelstart
--- @operator sub: vim.opt.foldlevelstart
--- @operator pow: vim.opt.foldlevelstart
vim.opt.foldlevelstart = -1
vim.opt.fdls = vim.opt.foldlevelstart
--- @return number
function vim.opt.foldlevelstart:get()end

-- `'foldmarker'`  `'fmr'` 	string (default: "{{{,}}}")
-- 			local to window
-- 	The start and end marker used when `'foldmethod'`  is "marker".  There
-- 	must be one comma, which separates the start and end marker.  The
-- 	marker is a literal string (a regular expression would be too slow).
-- 	See |fold-marker|.
--- @class vim.opt.foldmarker: vim.Option,string[]
--- @operator add: vim.opt.foldmarker
--- @operator sub: vim.opt.foldmarker
--- @operator pow: vim.opt.foldmarker
vim.opt.foldmarker = "{{{,}}}"
vim.opt.fmr = vim.opt.foldmarker
--- @return string[]
function vim.opt.foldmarker:get()end

-- `'foldmethod'`  `'fdm'` 	string (default: "manual")
-- 			local to window
-- 	The kind of folding used for the current window.  Possible values:
-- 	|fold-manual|	manual	    Folds are created manually.
-- 	|fold-indent|	indent	    Lines with equal indent form a fold.
-- 	|fold-expr|	expr	    `'foldexpr'`  gives the fold level of a line.
-- 	|fold-marker|	marker	    Markers are used to specify folds.
-- 	|fold-syntax|	syntax	    Syntax highlighting items specify folds.
-- 	|fold-diff|	diff	    Fold text that is not changed.
--- @class vim.opt.foldmethod: vim.Option,string
--- @operator add: vim.opt.foldmethod
--- @operator sub: vim.opt.foldmethod
--- @operator pow: vim.opt.foldmethod
vim.opt.foldmethod = "manual"
vim.opt.fdm = vim.opt.foldmethod
--- @return string
function vim.opt.foldmethod:get()end

-- `'foldminlines'`  `'fml'` 	number (default: 1)
-- 			local to window
-- 	Sets the number of screen lines above which a fold can be displayed
-- 	closed.  Also for manually closed folds.  With the default value of
-- 	one a fold can only be closed if it takes up two or more screen lines.
-- 	Set to zero to be able to close folds of just one screen line.
-- 	Note that this only has an effect on what is displayed.  After using
-- 	"zc" to close a fold, which is displayed open because it's smaller
-- 	than `'foldminlines'` , a following "zc" may close a containing fold.
--- @class vim.opt.foldminlines: vim.Option,number
--- @operator add: vim.opt.foldminlines
--- @operator sub: vim.opt.foldminlines
--- @operator pow: vim.opt.foldminlines
vim.opt.foldminlines = 1
vim.opt.fml = vim.opt.foldminlines
--- @return number
function vim.opt.foldminlines:get()end

-- `'foldnestmax'`  `'fdn'` 	number (default: 20)
-- 			local to window
-- 	Sets the maximum nesting of folds for the "indent" and "syntax"
-- 	methods.  This avoids that too many folds will be created.  Using more
-- 	than 20 doesn't work, because the internal limit is 20.
--- @class vim.opt.foldnestmax: vim.Option,number
--- @operator add: vim.opt.foldnestmax
--- @operator sub: vim.opt.foldnestmax
--- @operator pow: vim.opt.foldnestmax
vim.opt.foldnestmax = 20
vim.opt.fdn = vim.opt.foldnestmax
--- @return number
function vim.opt.foldnestmax:get()end

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
--- @class vim.opt.foldopen: vim.Option,string[]
--- @operator add: vim.opt.foldopen
--- @operator sub: vim.opt.foldopen
--- @operator pow: vim.opt.foldopen
vim.opt.foldopen = "block,hor,mark,percent,quickfix,search,tag,undo"
vim.opt.fdo = vim.opt.foldopen
--- @return string[]
function vim.opt.foldopen:get()end

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
--- @class vim.opt.foldtext: vim.Option,string
--- @operator add: vim.opt.foldtext
--- @operator sub: vim.opt.foldtext
--- @operator pow: vim.opt.foldtext
vim.opt.foldtext = "foldtext()"
vim.opt.fdt = vim.opt.foldtext
--- @return string
function vim.opt.foldtext:get()end

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
--- @class vim.opt.formatexpr: vim.Option,string
--- @operator add: vim.opt.formatexpr
--- @operator sub: vim.opt.formatexpr
--- @operator pow: vim.opt.formatexpr
vim.opt.formatexpr = ""
vim.opt.fex = vim.opt.formatexpr
--- @return string
function vim.opt.formatexpr:get()end

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
--- @class vim.opt.formatlistpat: vim.Option,string
--- @operator add: vim.opt.formatlistpat
--- @operator sub: vim.opt.formatlistpat
--- @operator pow: vim.opt.formatlistpat
vim.opt.formatlistpat = "^\\s*\\d\\+[\\]:.)}\\t ]\\s*"
vim.opt.flp = vim.opt.formatlistpat
--- @return string
function vim.opt.formatlistpat:get()end

-- `'formatoptions'`  `'fo'` 	string (default: "tcqj")
-- 			local to buffer
-- 	This is a sequence of letters which describes how automatic
-- 	formatting is to be done.  See |fo-table|.  Commas can be inserted for
-- 	readability.
-- 	To avoid problems with flags that are added in the future, use the
-- 	"+=" and "-=" feature of ":set" |add-option-flags|.
--- @class vim.opt.formatoptions: vim.Option,string[]
--- @operator add: vim.opt.formatoptions
--- @operator sub: vim.opt.formatoptions
--- @operator pow: vim.opt.formatoptions
vim.opt.formatoptions = "tcqj"
vim.opt.fo = vim.opt.formatoptions
--- @return string[]
function vim.opt.formatoptions:get()end

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
--- @class vim.opt.formatprg: vim.Option,string
--- @operator add: vim.opt.formatprg
--- @operator sub: vim.opt.formatprg
--- @operator pow: vim.opt.formatprg
vim.opt.formatprg = ""
vim.opt.fp = vim.opt.formatprg
--- @return string
function vim.opt.formatprg:get()end

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
--- @class vim.opt.fsync: vim.Option,boolean
--- @operator add: vim.opt.fsync
--- @operator sub: vim.opt.fsync
--- @operator pow: vim.opt.fsync
vim.opt.fsync = false
vim.opt.fs = vim.opt.fsync
--- @return boolean
function vim.opt.fsync:get()end

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
--- @class vim.opt.gdefault: vim.Option,boolean
--- @operator add: vim.opt.gdefault
--- @operator sub: vim.opt.gdefault
--- @operator pow: vim.opt.gdefault
vim.opt.gdefault = false
vim.opt.gd = vim.opt.gdefault
--- @return boolean
function vim.opt.gdefault:get()end

-- `'grepformat'`  `'gfm'` 	string	(default "%f:%l:%m,%f:%l%m,%f  %l%m")
-- 			global
-- 	Format to recognize for the ":grep" command output.
-- 	This is a scanf-like string that uses the same format as the
-- 	`'errorformat'`  option: see |errorformat|.
--- @class vim.opt.grepformat: vim.Option,string[]
--- @operator add: vim.opt.grepformat
--- @operator sub: vim.opt.grepformat
--- @operator pow: vim.opt.grepformat
vim.opt.grepformat = "%f:%l:%m,%f:%l%m,%f  %l%m"
vim.opt.gfm = vim.opt.grepformat
--- @return string[]
function vim.opt.grepformat:get()end

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
--- @class vim.opt.grepprg: vim.Option,string
--- @operator add: vim.opt.grepprg
--- @operator sub: vim.opt.grepprg
--- @operator pow: vim.opt.grepprg
vim.opt.grepprg = "grep -n $* /dev/null"
vim.opt.gp = vim.opt.grepprg
--- @return string
function vim.opt.grepprg:get()end

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
--- @class vim.opt.guicursor: vim.Option,string[]
--- @operator add: vim.opt.guicursor
--- @operator sub: vim.opt.guicursor
--- @operator pow: vim.opt.guicursor
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.gcr = vim.opt.guicursor
--- @return string[]
function vim.opt.guicursor:get()end

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
--- @class vim.opt.guifont: vim.Option,string[]
--- @operator add: vim.opt.guifont
--- @operator sub: vim.opt.guifont
--- @operator pow: vim.opt.guifont
vim.opt.guifont = ""
vim.opt.gfn = vim.opt.guifont
--- @return string[]
function vim.opt.guifont:get()end

-- `'guifontwide'`  `'gfw'` 	string	(default "")
-- 			global
-- 	Comma-separated list of fonts to be used for double-width characters.
-- 	The first font that can be loaded is used.
-- 	Note: The size of these fonts must be exactly twice as wide as the one
-- 	specified with `'guifont'`  and the same height.
-- 
-- 	When `'guifont'`  has a valid font and `'guifontwide'`  is empty Vim will
-- 	attempt to set `'guifontwide'`  to a matching double-width font.
--- @class vim.opt.guifontwide: vim.Option,string[]
--- @operator add: vim.opt.guifontwide
--- @operator sub: vim.opt.guifontwide
--- @operator pow: vim.opt.guifontwide
vim.opt.guifontwide = ""
vim.opt.gfw = vim.opt.guifontwide
--- @return string[]
function vim.opt.guifontwide:get()end

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
--- @class vim.opt.guioptions: vim.Option,string
--- @operator add: vim.opt.guioptions
--- @operator sub: vim.opt.guioptions
--- @operator pow: vim.opt.guioptions
vim.opt.guioptions = ""
vim.opt.go = vim.opt.guioptions
--- @return string
function vim.opt.guioptions:get()end

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
--- @class vim.opt.guitablabel: vim.Option,string
--- @operator add: vim.opt.guitablabel
--- @operator sub: vim.opt.guitablabel
--- @operator pow: vim.opt.guitablabel
vim.opt.guitablabel = ""
vim.opt.gtl = vim.opt.guitablabel
--- @return string
function vim.opt.guitablabel:get()end

-- `'guitabtooltip'`  `'gtt'` 	string	(default empty)
-- 			global
-- 	When non-empty describes the text to use in a tooltip for the GUI tab
-- 	pages line.  When empty Vim will use a default tooltip.
-- 	This option is otherwise just like `'guitablabel'`  above.
-- 	You can include a line break.  Simplest method is to use |:let|: >
-- 		:let &guitabtooltip = "line one\nline two"
-- <
--- @class vim.opt.guitabtooltip: vim.Option,string
--- @operator add: vim.opt.guitabtooltip
--- @operator sub: vim.opt.guitabtooltip
--- @operator pow: vim.opt.guitabtooltip
vim.opt.guitabtooltip = ""
vim.opt.gtt = vim.opt.guitabtooltip
--- @return string
function vim.opt.guitabtooltip:get()end

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
--- @class vim.opt.helpfile: vim.Option,string
--- @operator add: vim.opt.helpfile
--- @operator sub: vim.opt.helpfile
--- @operator pow: vim.opt.helpfile
vim.opt.helpfile = "/tmp/nvim/squashfs-root/usr/share/nvim/runtime/doc/help.txt"
vim.opt.hf = vim.opt.helpfile
--- @return string
function vim.opt.helpfile:get()end

-- `'helpheight'`  `'hh'` 	number	(default 20)
-- 			global
-- 	Minimal initial height of the help window when it is opened with the
-- 	":help" command.  The initial height of the help window is half of the
-- 	current window, or (when the `'ea'`  option is on) the same as other
-- 	windows.  When the height is less than `'helpheight'` , the height is
-- 	set to `'helpheight'` .  Set to zero to disable.
--- @class vim.opt.helpheight: vim.Option,number
--- @operator add: vim.opt.helpheight
--- @operator sub: vim.opt.helpheight
--- @operator pow: vim.opt.helpheight
vim.opt.helpheight = 20
vim.opt.hh = vim.opt.helpheight
--- @return number
function vim.opt.helpheight:get()end

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
--- @class vim.opt.helplang: vim.Option,string[]
--- @operator add: vim.opt.helplang
--- @operator sub: vim.opt.helplang
--- @operator pow: vim.opt.helplang
vim.opt.helplang = ""
vim.opt.hlg = vim.opt.helplang
--- @return string[]
function vim.opt.helplang:get()end

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
--- @class vim.opt.hidden: vim.Option,boolean
--- @operator add: vim.opt.hidden
--- @operator sub: vim.opt.hidden
--- @operator pow: vim.opt.hidden
vim.opt.hidden = true
vim.opt.hid = vim.opt.hidden
--- @return boolean
function vim.opt.hidden:get()end

--- @class vim.opt.highlight: vim.Option,string[]
--- @operator add: vim.opt.highlight
--- @operator sub: vim.opt.highlight
--- @operator pow: vim.opt.highlight
vim.opt.highlight = "8:SpecialKey,~:EndOfBuffer,z:TermCursor,Z:TermCursorNC,@:NonText,d:Directory,e:ErrorMsg,i:IncSearch,l:Search,y:CurSearch,m:MoreMsg,M:ModeMsg,n:LineNr,a:LineNrAbove,b:LineNrBelow,N:CursorLineNr,G:CursorLineSign,O:CursorLineFoldr:Question,s:StatusLine,S:StatusLineNC,c:VertSplit,t:Title,v:Visual,V:VisualNOS,w:WarningMsg,W:WildMenu,f:Folded,F:FoldColumn,A:DiffAdd,C:DiffChange,D:DiffDelete,T:DiffText,>:SignColumn,-:Conceal,B:SpellBad,P:SpellCap,R:SpellRare,L:SpellLocal,+:Pmenu,=:PmenuSel,[:PmenuKind,]:PmenuKindSel,{:PmenuExtra,}:PmenuExtraSel,x:PmenuSbar,X:PmenuThumb,*:TabLine,#:TabLineSel,_:TabLineFill,!:CursorColumn,.:CursorLine,o:ColorColumn,q:QuickFixLine,0:Whitespace,I:NormalNC"
vim.opt.hl = vim.opt.highlight
--- @return string[]
function vim.opt.highlight:get()end

-- `'history'`  `'hi'` 		number	(default: 10000)
-- 			global
-- 	A history of ":" commands, and a history of previous search patterns
-- 	is remembered.  This option decides how many entries may be stored in
-- 	each of these histories (see |cmdline-editing|).
-- 	The maximum value is 10000.
--- @class vim.opt.history: vim.Option,number
--- @operator add: vim.opt.history
--- @operator sub: vim.opt.history
--- @operator pow: vim.opt.history
vim.opt.history = 10000
vim.opt.hi = vim.opt.history
--- @return number
function vim.opt.history:get()end

--- @class vim.opt.hkmap: vim.Option,boolean
--- @operator add: vim.opt.hkmap
--- @operator sub: vim.opt.hkmap
--- @operator pow: vim.opt.hkmap
vim.opt.hkmap = false
vim.opt.hk = vim.opt.hkmap
--- @return boolean
function vim.opt.hkmap:get()end

--- @class vim.opt.hkmapp: vim.Option,boolean
--- @operator add: vim.opt.hkmapp
--- @operator sub: vim.opt.hkmapp
--- @operator pow: vim.opt.hkmapp
vim.opt.hkmapp = false
vim.opt.hkp = vim.opt.hkmapp
--- @return boolean
function vim.opt.hkmapp:get()end

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
--- @class vim.opt.hlsearch: vim.Option,boolean
--- @operator add: vim.opt.hlsearch
--- @operator sub: vim.opt.hlsearch
--- @operator pow: vim.opt.hlsearch
vim.opt.hlsearch = true
vim.opt.hls = vim.opt.hlsearch
--- @return boolean
function vim.opt.hlsearch:get()end

-- `'icon'` 			boolean	(default off, on when title can be restored)
-- 			global
-- 	When on, the icon text of the window will be set to the value of
-- 	`'iconstring'`  (if it is not empty), or to the name of the file
-- 	currently being edited.  Only the last part of the name is used.
-- 	Overridden by the `'iconstring'`  option.
-- 	Only works if the terminal supports setting window icons.
--- @class vim.opt.icon: vim.Option,boolean
--- @operator add: vim.opt.icon
--- @operator sub: vim.opt.icon
--- @operator pow: vim.opt.icon
vim.opt.icon = false
--- @return boolean
function vim.opt.icon:get()end

-- `'iconstring'` 		string	(default "")
-- 			global
-- 	When this option is not empty, it will be used for the icon text of
-- 	the window.  This happens only when the `'icon'`  option is on.
-- 	Only works if the terminal supports setting window icon text
-- 	When this option contains printf-style `'%'`  items, they will be
-- 	expanded according to the rules used for `'statusline'` .  See
-- 	`'titlestring'`  for example settings.
-- 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
--- @class vim.opt.iconstring: vim.Option,string
--- @operator add: vim.opt.iconstring
--- @operator sub: vim.opt.iconstring
--- @operator pow: vim.opt.iconstring
vim.opt.iconstring = ""
--- @return string
function vim.opt.iconstring:get()end

-- `'ignorecase'`  `'ic'` 	boolean	(default off)
-- 			global
-- 	Ignore case in search patterns.  Also used when searching in the tags
-- 	file.
-- 	Also see `'smartcase'`  and `'tagcase'` .
-- 	Can be overruled by using "\c" or "\C" in the pattern, see
-- 	|/ignorecase|.
--- @class vim.opt.ignorecase: vim.Option,boolean
--- @operator add: vim.opt.ignorecase
--- @operator sub: vim.opt.ignorecase
--- @operator pow: vim.opt.ignorecase
vim.opt.ignorecase = false
vim.opt.ic = vim.opt.ignorecase
--- @return boolean
function vim.opt.ignorecase:get()end

-- `'imcmdline'`  `'imc'` 	boolean (default off)
-- 			global
-- 	When set the Input Method is always on when starting to edit a command
-- 	line, unless entering a search pattern (see `'imsearch'`  for that).
-- 	Setting this option is useful when your input method allows entering
-- 	English characters directly, e.g., when it's used to type accented
-- 	characters with dead keys.
--- @class vim.opt.imcmdline: vim.Option,boolean
--- @operator add: vim.opt.imcmdline
--- @operator sub: vim.opt.imcmdline
--- @operator pow: vim.opt.imcmdline
vim.opt.imcmdline = false
vim.opt.imc = vim.opt.imcmdline
--- @return boolean
function vim.opt.imcmdline:get()end

-- `'imdisable'`  `'imd'` 	boolean (default off, on for some systems (SGI))
-- 			global
-- 	When set the Input Method is never used.  This is useful to disable
-- 	the IM when it doesn't work properly.
-- 	Currently this option is on by default for SGI/IRIX machines.  This
-- 	may change in later releases.
--- @class vim.opt.imdisable: vim.Option,boolean
--- @operator add: vim.opt.imdisable
--- @operator sub: vim.opt.imdisable
--- @operator pow: vim.opt.imdisable
vim.opt.imdisable = false
vim.opt.imd = vim.opt.imdisable
--- @return boolean
function vim.opt.imdisable:get()end

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
--- @class vim.opt.iminsert: vim.Option,number
--- @operator add: vim.opt.iminsert
--- @operator sub: vim.opt.iminsert
--- @operator pow: vim.opt.iminsert
vim.opt.iminsert = 0
vim.opt.imi = vim.opt.iminsert
--- @return number
function vim.opt.iminsert:get()end

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
--- @class vim.opt.imsearch: vim.Option,number
--- @operator add: vim.opt.imsearch
--- @operator sub: vim.opt.imsearch
--- @operator pow: vim.opt.imsearch
vim.opt.imsearch = -1
vim.opt.ims = vim.opt.imsearch
--- @return number
function vim.opt.imsearch:get()end

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
--- @class vim.opt.inccommand: vim.Option,string
--- @operator add: vim.opt.inccommand
--- @operator sub: vim.opt.inccommand
--- @operator pow: vim.opt.inccommand
vim.opt.inccommand = "nosplit"
vim.opt.icm = vim.opt.inccommand
--- @return string
function vim.opt.inccommand:get()end

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
--- @class vim.opt.include: vim.Option,string
--- @operator add: vim.opt.include
--- @operator sub: vim.opt.include
--- @operator pow: vim.opt.include
vim.opt.include = "^\\s*#\\s*include"
vim.opt.inc = vim.opt.include
--- @return string
function vim.opt.include:get()end

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
--- @class vim.opt.includeexpr: vim.Option,string
--- @operator add: vim.opt.includeexpr
--- @operator sub: vim.opt.includeexpr
--- @operator pow: vim.opt.includeexpr
vim.opt.includeexpr = ""
vim.opt.inex = vim.opt.includeexpr
--- @return string
function vim.opt.includeexpr:get()end

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
--- @class vim.opt.incsearch: vim.Option,boolean
--- @operator add: vim.opt.incsearch
--- @operator sub: vim.opt.incsearch
--- @operator pow: vim.opt.incsearch
vim.opt.incsearch = true
vim.opt.is = vim.opt.incsearch
--- @return boolean
function vim.opt.incsearch:get()end

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
--- @class vim.opt.indentexpr: vim.Option,string
--- @operator add: vim.opt.indentexpr
--- @operator sub: vim.opt.indentexpr
--- @operator pow: vim.opt.indentexpr
vim.opt.indentexpr = ""
vim.opt.inde = vim.opt.indentexpr
--- @return string
function vim.opt.indentexpr:get()end

-- `'indentkeys'`  `'indk'` 	string	(default "0{,0},0),0],:,0#,!^F,o,O,e")
-- 			local to buffer
-- 	A list of keys that, when typed in Insert mode, cause reindenting of
-- 	the current line.  Only happens if `'indentexpr'`  isn't empty.
-- 	The format is identical to `'cinkeys'` , see |indentkeys-format|.
-- 	See |C-indenting| and |indent-expression|.
--- @class vim.opt.indentkeys: vim.Option,string[]
--- @operator add: vim.opt.indentkeys
--- @operator sub: vim.opt.indentkeys
--- @operator pow: vim.opt.indentkeys
vim.opt.indentkeys = "0{,0},0),0],:,0#,!^F,o,O,e"
vim.opt.indk = vim.opt.indentkeys
--- @return string[]
function vim.opt.indentkeys:get()end

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
--- @class vim.opt.infercase: vim.Option,boolean
--- @operator add: vim.opt.infercase
--- @operator sub: vim.opt.infercase
--- @operator pow: vim.opt.infercase
vim.opt.infercase = false
vim.opt.inf = vim.opt.infercase
--- @return boolean
function vim.opt.infercase:get()end

--- @class vim.opt.insertmode: vim.Option,boolean
--- @operator add: vim.opt.insertmode
--- @operator sub: vim.opt.insertmode
--- @operator pow: vim.opt.insertmode
vim.opt.insertmode = false
vim.opt.im = vim.opt.insertmode
--- @return boolean
function vim.opt.insertmode:get()end

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
--- @class vim.opt.isfname: vim.Option,string[]
--- @operator add: vim.opt.isfname
--- @operator sub: vim.opt.isfname
--- @operator pow: vim.opt.isfname
vim.opt.isfname = "@,48-57,/,.,-,_,+,,,#,$,%,~,="
vim.opt.isf = vim.opt.isfname
--- @return string[]
function vim.opt.isfname:get()end

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
--- @class vim.opt.isident: vim.Option,string[]
--- @operator add: vim.opt.isident
--- @operator sub: vim.opt.isident
--- @operator pow: vim.opt.isident
vim.opt.isident = "@,48-57,_,192-255"
vim.opt.isi = vim.opt.isident
--- @return string[]
function vim.opt.isident:get()end

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
--- @class vim.opt.iskeyword: vim.Option,string[]
--- @operator add: vim.opt.iskeyword
--- @operator sub: vim.opt.iskeyword
--- @operator pow: vim.opt.iskeyword
vim.opt.iskeyword = "@,48-57,_,192-255"
vim.opt.isk = vim.opt.iskeyword
--- @return string[]
function vim.opt.iskeyword:get()end

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
--- @class vim.opt.isprint: vim.Option,string[]
--- @operator add: vim.opt.isprint
--- @operator sub: vim.opt.isprint
--- @operator pow: vim.opt.isprint
vim.opt.isprint = "@,161-255"
vim.opt.isp = vim.opt.isprint
--- @return string[]
function vim.opt.isprint:get()end

-- `'joinspaces'`  `'js'` 	boolean	(default off)
-- 			global
-- 	Insert two spaces after a `'.'` , `'?'`  and `'!'`  with a join command.
-- 	Otherwise only one space is inserted.
--- @class vim.opt.joinspaces: vim.Option,boolean
--- @operator add: vim.opt.joinspaces
--- @operator sub: vim.opt.joinspaces
--- @operator pow: vim.opt.joinspaces
vim.opt.joinspaces = false
vim.opt.js = vim.opt.joinspaces
--- @return boolean
function vim.opt.joinspaces:get()end

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
--- @class vim.opt.jumpoptions: vim.Option,string[]
--- @operator add: vim.opt.jumpoptions
--- @operator sub: vim.opt.jumpoptions
--- @operator pow: vim.opt.jumpoptions
vim.opt.jumpoptions = ""
vim.opt.jop = vim.opt.jumpoptions
--- @return string[]
function vim.opt.jumpoptions:get()end

-- `'keymap'`  `'kmp'` 		string	(default "")
-- 			local to buffer
-- 	Name of a keyboard mapping.  See |mbyte-keymap|.
-- 	Setting this option to a valid keymap name has the side effect of
-- 	setting `'iminsert'`  to one, so that the keymap becomes effective.
-- 	`'imsearch'`  is also set to one, unless it was -1
-- 	Only normal file name characters can be used, "/\*?[|<>" are illegal.
--- @class vim.opt.keymap: vim.Option,string
--- @operator add: vim.opt.keymap
--- @operator sub: vim.opt.keymap
--- @operator pow: vim.opt.keymap
vim.opt.keymap = ""
vim.opt.kmp = vim.opt.keymap
--- @return string
function vim.opt.keymap:get()end

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
--- @class vim.opt.keymodel: vim.Option,string[]
--- @operator add: vim.opt.keymodel
--- @operator sub: vim.opt.keymodel
--- @operator pow: vim.opt.keymodel
vim.opt.keymodel = ""
vim.opt.km = vim.opt.keymodel
--- @return string[]
function vim.opt.keymodel:get()end

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
--- @class vim.opt.keywordprg: vim.Option,string
--- @operator add: vim.opt.keywordprg
--- @operator sub: vim.opt.keywordprg
--- @operator pow: vim.opt.keywordprg
vim.opt.keywordprg = ":Man"
vim.opt.kp = vim.opt.keywordprg
--- @return string
function vim.opt.keywordprg:get()end

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
--- @class vim.opt.langmap: vim.Option,string[]
--- @operator add: vim.opt.langmap
--- @operator sub: vim.opt.langmap
--- @operator pow: vim.opt.langmap
vim.opt.langmap = ""
vim.opt.lmap = vim.opt.langmap
--- @return string[]
function vim.opt.langmap:get()end

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
--- @class vim.opt.langmenu: vim.Option,string
--- @operator add: vim.opt.langmenu
--- @operator sub: vim.opt.langmenu
--- @operator pow: vim.opt.langmenu
vim.opt.langmenu = ""
vim.opt.lm = vim.opt.langmenu
--- @return string
function vim.opt.langmenu:get()end

--- @class vim.opt.langnoremap: vim.Option,boolean
--- @operator add: vim.opt.langnoremap
--- @operator sub: vim.opt.langnoremap
--- @operator pow: vim.opt.langnoremap
vim.opt.langnoremap = true
vim.opt.lnr = vim.opt.langnoremap
--- @return boolean
function vim.opt.langnoremap:get()end

-- `'langremap'`  `'lrm'` 	boolean (default off)
-- 			global
-- 	When off, setting `'langmap'`  does not apply to characters resulting from
-- 	a mapping.  If setting `'langmap'`  disables some of your mappings, make
-- 	sure this option is off.
--- @class vim.opt.langremap: vim.Option,boolean
--- @operator add: vim.opt.langremap
--- @operator sub: vim.opt.langremap
--- @operator pow: vim.opt.langremap
vim.opt.langremap = false
vim.opt.lrm = vim.opt.langremap
--- @return boolean
function vim.opt.langremap:get()end

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
--- @class vim.opt.laststatus: vim.Option,number
--- @operator add: vim.opt.laststatus
--- @operator sub: vim.opt.laststatus
--- @operator pow: vim.opt.laststatus
vim.opt.laststatus = 2
vim.opt.ls = vim.opt.laststatus
--- @return number
function vim.opt.laststatus:get()end

-- `'lazyredraw'`  `'lz'` 	boolean	(default off)
-- 			global
-- 	When this option is set, the screen will not be redrawn while
-- 	executing macros, registers and other commands that have not been
-- 	typed.  Also, updating the window title is postponed.  To force an
-- 	update use |:redraw|.
-- 	This may occasionally cause display errors.  It is only meant to be set
-- 	temporarily when performing an operation where redrawing may cause
-- 	flickering or cause a slow down.
--- @class vim.opt.lazyredraw: vim.Option,boolean
--- @operator add: vim.opt.lazyredraw
--- @operator sub: vim.opt.lazyredraw
--- @operator pow: vim.opt.lazyredraw
vim.opt.lazyredraw = false
vim.opt.lz = vim.opt.lazyredraw
--- @return boolean
function vim.opt.lazyredraw:get()end

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
--- @class vim.opt.linebreak: vim.Option,boolean
--- @operator add: vim.opt.linebreak
--- @operator sub: vim.opt.linebreak
--- @operator pow: vim.opt.linebreak
vim.opt.linebreak = false
vim.opt.lbr = vim.opt.linebreak
--- @return boolean
function vim.opt.linebreak:get()end

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
--- @class vim.opt.lines: vim.Option,number
--- @operator add: vim.opt.lines
--- @operator sub: vim.opt.lines
--- @operator pow: vim.opt.lines
vim.opt.lines = 24
--- @return number
function vim.opt.lines:get()end

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
--- @class vim.opt.linespace: vim.Option,number
--- @operator add: vim.opt.linespace
--- @operator sub: vim.opt.linespace
--- @operator pow: vim.opt.linespace
vim.opt.linespace = 0
vim.opt.lsp = vim.opt.linespace
--- @return number
function vim.opt.linespace:get()end

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
--- @class vim.opt.lisp: vim.Option,boolean
--- @operator add: vim.opt.lisp
--- @operator sub: vim.opt.lisp
--- @operator pow: vim.opt.lisp
vim.opt.lisp = false
--- @return boolean
function vim.opt.lisp:get()end

-- `'lispoptions'`  `'lop'` 	string	(default "")
-- 			local to buffer
-- 	Comma-separated list of items that influence the Lisp indenting when
-- 	enabled with the |`'lisp'` | option.  Currently only one item is
-- 	supported:
-- 		expr:1	use `'indentexpr'`  for Lisp indenting when it is set
-- 		expr:0	do not use `'indentexpr'`  for Lisp indenting (default)
-- 	Note that when using `'indentexpr'`  the `=` operator indents all the
-- 	lines, otherwise the first line is not indented (Vi-compatible).
--- @class vim.opt.lispoptions: vim.Option,string[]
--- @operator add: vim.opt.lispoptions
--- @operator sub: vim.opt.lispoptions
--- @operator pow: vim.opt.lispoptions
vim.opt.lispoptions = ""
vim.opt.lop = vim.opt.lispoptions
--- @return string[]
function vim.opt.lispoptions:get()end

-- `'lispwords'`  `'lw'` 	string	(default is very long)
-- 			global or local to buffer |global-local|
-- 	Comma-separated list of words that influence the Lisp indenting when
-- 	enabled with the |`'lisp'` | option.
--- @class vim.opt.lispwords: vim.Option,string[]
--- @operator add: vim.opt.lispwords
--- @operator sub: vim.opt.lispwords
--- @operator pow: vim.opt.lispwords
vim.opt.lispwords = "defun,define,defmacro,set!,lambda,if,case,let,flet,let*,letrec,do,do*,define-syntax,let-syntax,letrec-syntax,destructuring-bind,defpackage,defparameter,defstruct,deftype,defvar,do-all-symbols,do-external-symbols,do-symbols,dolist,dotimes,ecase,etypecase,eval-when,labels,macrolet,multiple-value-bind,multiple-value-call,multiple-value-prog1,multiple-value-setq,prog1,progv,typecase,unless,unwind-protect,when,with-input-from-string,with-open-file,with-open-stream,with-output-to-string,with-package-iterator,define-condition,handler-bind,handler-case,restart-bind,restart-case,with-simple-restart,store-value,use-value,muffle-warning,abort,continue,with-slots,with-slots*,with-accessors,with-accessors*,defclass,defmethod,print-unreadable-object"
vim.opt.lw = vim.opt.lispwords
--- @return string[]
function vim.opt.lispwords:get()end

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
--- @class vim.opt.list: vim.Option,boolean
--- @operator add: vim.opt.list
--- @operator sub: vim.opt.list
--- @operator pow: vim.opt.list
vim.opt.list = false
--- @return boolean
function vim.opt.list:get()end

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
--- @class vim.opt.listchars: vim.Option,table<string, string>
--- @operator add: vim.opt.listchars
--- @operator sub: vim.opt.listchars
--- @operator pow: vim.opt.listchars
vim.opt.listchars = "tab:> ,trail:-,nbsp:+"
vim.opt.lcs = vim.opt.listchars
--- @return table<string, string>
function vim.opt.listchars:get()end

-- `'loadplugins'`  `'lpl'` 	boolean	(default on)
-- 			global
-- 	When on the plugin scripts are loaded when starting up |load-plugins|.
-- 	This option can be reset in your |vimrc| file to disable the loading
-- 	of plugins.
-- 	Note that using the "-u NONE" and "--noplugin" command line arguments
-- 	reset this option. |-u| |--noplugin|
--- @class vim.opt.loadplugins: vim.Option,boolean
--- @operator add: vim.opt.loadplugins
--- @operator sub: vim.opt.loadplugins
--- @operator pow: vim.opt.loadplugins
vim.opt.loadplugins = true
vim.opt.lpl = vim.opt.loadplugins
--- @return boolean
function vim.opt.loadplugins:get()end

-- `'magic'` 			boolean	(default on)
-- 			global
-- 	Changes the special characters that can be used in search patterns.
-- 	See |pattern|.
-- 	WARNING: Switching this option off most likely breaks plugins!  That
-- 	is because many patterns assume it's on and will fail when it's off.
-- 	Only switch it off when working with old Vi scripts.  In any other
-- 	situation write patterns that work when `'magic'`  is on.  Include "\M"
-- 	when you want to |/\M|.
--- @class vim.opt.magic: vim.Option,boolean
--- @operator add: vim.opt.magic
--- @operator sub: vim.opt.magic
--- @operator pow: vim.opt.magic
vim.opt.magic = true
--- @return boolean
function vim.opt.magic:get()end

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
--- @class vim.opt.makeef: vim.Option,string
--- @operator add: vim.opt.makeef
--- @operator sub: vim.opt.makeef
--- @operator pow: vim.opt.makeef
vim.opt.makeef = ""
vim.opt.mef = vim.opt.makeef
--- @return string
function vim.opt.makeef:get()end

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
--- @class vim.opt.makeencoding: vim.Option,string
--- @operator add: vim.opt.makeencoding
--- @operator sub: vim.opt.makeencoding
--- @operator pow: vim.opt.makeencoding
vim.opt.makeencoding = ""
vim.opt.menc = vim.opt.makeencoding
--- @return string
function vim.opt.makeencoding:get()end

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
--- @class vim.opt.makeprg: vim.Option,string
--- @operator add: vim.opt.makeprg
--- @operator sub: vim.opt.makeprg
--- @operator pow: vim.opt.makeprg
vim.opt.makeprg = "make"
vim.opt.mp = vim.opt.makeprg
--- @return string
function vim.opt.makeprg:get()end

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
--- @class vim.opt.matchpairs: vim.Option,string[]
--- @operator add: vim.opt.matchpairs
--- @operator sub: vim.opt.matchpairs
--- @operator pow: vim.opt.matchpairs
vim.opt.matchpairs = "(:),{:},[:]"
vim.opt.mps = vim.opt.matchpairs
--- @return string[]
function vim.opt.matchpairs:get()end

-- `'matchtime'`  `'mat'` 	number	(default 5)
-- 			global
-- 	Tenths of a second to show the matching paren, when `'showmatch'`  is
-- 	set.  Note that this is not in milliseconds, like other options that
-- 	set a time.  This is to be compatible with Nvi.
--- @class vim.opt.matchtime: vim.Option,number
--- @operator add: vim.opt.matchtime
--- @operator sub: vim.opt.matchtime
--- @operator pow: vim.opt.matchtime
vim.opt.matchtime = 5
vim.opt.mat = vim.opt.matchtime
--- @return number
function vim.opt.matchtime:get()end

--- @class vim.opt.maxcombine: vim.Option,number
--- @operator add: vim.opt.maxcombine
--- @operator sub: vim.opt.maxcombine
--- @operator pow: vim.opt.maxcombine
vim.opt.maxcombine = 6
vim.opt.mco = vim.opt.maxcombine
--- @return number
function vim.opt.maxcombine:get()end

-- `'maxfuncdepth'`  `'mfd'` 	number	(default 100)
-- 			global
-- 	Maximum depth of function calls for user functions.  This normally
-- 	catches endless recursion.  When using a recursive function with
-- 	more depth, set `'maxfuncdepth'`  to a bigger number.  But this will use
-- 	more memory, there is the danger of failing when memory is exhausted.
-- 	Increasing this limit above 200 also changes the maximum for Ex
-- 	command recursion, see |E169|.
-- 	See also |:function|.
--- @class vim.opt.maxfuncdepth: vim.Option,number
--- @operator add: vim.opt.maxfuncdepth
--- @operator sub: vim.opt.maxfuncdepth
--- @operator pow: vim.opt.maxfuncdepth
vim.opt.maxfuncdepth = 100
vim.opt.mfd = vim.opt.maxfuncdepth
--- @return number
function vim.opt.maxfuncdepth:get()end

-- `'maxmapdepth'`  `'mmd'` 	number	(default 1000)
-- 			global
-- 	Maximum number of times a mapping is done without resulting in a
-- 	character to be used.  This normally catches endless mappings, like
-- 	":map x y" with ":map y x".  It still does not catch ":map g wg",
-- 	because the `'w'`  is used before the next mapping is done.  See also
-- 	|key-mapping|.
--- @class vim.opt.maxmapdepth: vim.Option,number
--- @operator add: vim.opt.maxmapdepth
--- @operator sub: vim.opt.maxmapdepth
--- @operator pow: vim.opt.maxmapdepth
vim.opt.maxmapdepth = 1000
vim.opt.mmd = vim.opt.maxmapdepth
--- @return number
function vim.opt.maxmapdepth:get()end

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
--- @class vim.opt.maxmempattern: vim.Option,number
--- @operator add: vim.opt.maxmempattern
--- @operator sub: vim.opt.maxmempattern
--- @operator pow: vim.opt.maxmempattern
vim.opt.maxmempattern = 1000
vim.opt.mmp = vim.opt.maxmempattern
--- @return number
function vim.opt.maxmempattern:get()end

-- `'menuitems'`  `'mis'` 	number	(default 25)
-- 			global
-- 	Maximum number of items to use in a menu.  Used for menus that are
-- 	generated from a list of items, e.g., the Buffers menu.  Changing this
-- 	option has no direct effect, the menu must be refreshed first.
--- @class vim.opt.menuitems: vim.Option,number
--- @operator add: vim.opt.menuitems
--- @operator sub: vim.opt.menuitems
--- @operator pow: vim.opt.menuitems
vim.opt.menuitems = 25
vim.opt.mis = vim.opt.menuitems
--- @return number
function vim.opt.menuitems:get()end

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
--- @class vim.opt.mkspellmem: vim.Option,string
--- @operator add: vim.opt.mkspellmem
--- @operator sub: vim.opt.mkspellmem
--- @operator pow: vim.opt.mkspellmem
vim.opt.mkspellmem = "460000,2000,500"
vim.opt.msm = vim.opt.mkspellmem
--- @return string
function vim.opt.mkspellmem:get()end

-- `'modeline'`  `'ml'` 		boolean	(default: on (off for root))
-- 			local to buffer
-- 	If `'modeline'`  is on `'modelines'`  gives the number of lines that is
-- 	checked for set commands.  If `'modeline'`  is off or `'modelines'`  is zero
-- 	no lines are checked.  See |modeline|.
--- @class vim.opt.modeline: vim.Option,boolean
--- @operator add: vim.opt.modeline
--- @operator sub: vim.opt.modeline
--- @operator pow: vim.opt.modeline
vim.opt.modeline = true
vim.opt.ml = vim.opt.modeline
--- @return boolean
function vim.opt.modeline:get()end

-- `'modelineexpr'`  `'mle'` 	boolean (default: off)
-- 			global
-- 	When on allow some options that are an expression to be set in the
-- 	modeline.  Check the option for whether it is affected by
-- 	`'modelineexpr'` .  Also see |modeline|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.modelineexpr: vim.Option,boolean
--- @operator add: vim.opt.modelineexpr
--- @operator sub: vim.opt.modelineexpr
--- @operator pow: vim.opt.modelineexpr
vim.opt.modelineexpr = false
vim.opt.mle = vim.opt.modelineexpr
--- @return boolean
function vim.opt.modelineexpr:get()end

-- `'modelines'`  `'mls'` 	number	(default 5)
-- 			global
-- 	If `'modeline'`  is on `'modelines'`  gives the number of lines that is
-- 	checked for set commands.  If `'modeline'`  is off or `'modelines'`  is zero
-- 	no lines are checked.  See |modeline|.
--- @class vim.opt.modelines: vim.Option,number
--- @operator add: vim.opt.modelines
--- @operator sub: vim.opt.modelines
--- @operator pow: vim.opt.modelines
vim.opt.modelines = 5
vim.opt.mls = vim.opt.modelines
--- @return number
function vim.opt.modelines:get()end

-- `'modifiable'`  `'ma'` 	boolean	(default on)
-- 			local to buffer
-- 	When off the buffer contents cannot be changed.  The `'fileformat'`  and
-- 	`'fileencoding'`  options also can't be changed.
-- 	Can be reset on startup with the |-M| command line argument.
--- @class vim.opt.modifiable: vim.Option,boolean
--- @operator add: vim.opt.modifiable
--- @operator sub: vim.opt.modifiable
--- @operator pow: vim.opt.modifiable
vim.opt.modifiable = true
vim.opt.ma = vim.opt.modifiable
--- @return boolean
function vim.opt.modifiable:get()end

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
--- @class vim.opt.modified: vim.Option,boolean
--- @operator add: vim.opt.modified
--- @operator sub: vim.opt.modified
--- @operator pow: vim.opt.modified
vim.opt.modified = false
vim.opt.mod = vim.opt.modified
--- @return boolean
function vim.opt.modified:get()end

-- `'more'` 			boolean	(default: on)
-- 			global
-- 	When on, listings pause when the whole screen is filled.  You will get
-- 	the |more-prompt|.  When this option is off there are no pauses, the
-- 	listing continues until finished.
--- @class vim.opt.more: vim.Option,boolean
--- @operator add: vim.opt.more
--- @operator sub: vim.opt.more
--- @operator pow: vim.opt.more
vim.opt.more = true
--- @return boolean
function vim.opt.more:get()end

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
--- @class vim.opt.mouse: vim.Option,string[]
--- @operator add: vim.opt.mouse
--- @operator sub: vim.opt.mouse
--- @operator pow: vim.opt.mouse
vim.opt.mouse = "nvi"
--- @return string[]
function vim.opt.mouse:get()end

-- `'mousefocus'`  `'mousef'` 	boolean	(default off)
-- 			global
-- 	The window that the mouse pointer is on is automatically activated.
-- 	When changing the window layout or window focus in another way, the
-- 	mouse pointer is moved to the window with keyboard focus.  Off is the
-- 	default because it makes using the pull down menus a little goofy, as
-- 	a pointer transit may activate a window unintentionally.
--- @class vim.opt.mousefocus: vim.Option,boolean
--- @operator add: vim.opt.mousefocus
--- @operator sub: vim.opt.mousefocus
--- @operator pow: vim.opt.mousefocus
vim.opt.mousefocus = false
vim.opt.mousef = vim.opt.mousefocus
--- @return boolean
function vim.opt.mousefocus:get()end

-- `'mousehide'`  `'mh'` 	boolean	(default on)
-- 			global
-- 			{only works in the GUI}
-- 	When on, the mouse pointer is hidden when characters are typed.
-- 	The mouse pointer is restored when the mouse is moved.
--- @class vim.opt.mousehide: vim.Option,boolean
--- @operator add: vim.opt.mousehide
--- @operator sub: vim.opt.mousehide
--- @operator pow: vim.opt.mousehide
vim.opt.mousehide = true
vim.opt.mh = vim.opt.mousehide
--- @return boolean
function vim.opt.mousehide:get()end

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
--- @class vim.opt.mousemodel: vim.Option,string
--- @operator add: vim.opt.mousemodel
--- @operator sub: vim.opt.mousemodel
--- @operator pow: vim.opt.mousemodel
vim.opt.mousemodel = "popup_setpos"
vim.opt.mousem = vim.opt.mousemodel
--- @return string
function vim.opt.mousemodel:get()end

-- `'mousemoveevent'`  `'mousemev'`   boolean	(default off)
-- 			global
-- 	When on, mouse move events are delivered to the input queue and are
-- 	available for mapping. The default, off, avoids the mouse movement
-- 	overhead except when needed.
-- 	Warning: Setting this option can make pending mappings to be aborted
-- 	when the mouse is moved.
--- @class vim.opt.mousemoveevent: vim.Option,boolean
--- @operator add: vim.opt.mousemoveevent
--- @operator sub: vim.opt.mousemoveevent
--- @operator pow: vim.opt.mousemoveevent
vim.opt.mousemoveevent = false
vim.opt.mousemev = vim.opt.mousemoveevent
--- @return boolean
function vim.opt.mousemoveevent:get()end

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
--- @class vim.opt.mousescroll: vim.Option,string[]
--- @operator add: vim.opt.mousescroll
--- @operator sub: vim.opt.mousescroll
--- @operator pow: vim.opt.mousescroll
vim.opt.mousescroll = "ver:3,hor:6"
--- @return string[]
function vim.opt.mousescroll:get()end

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
--- @class vim.opt.mouseshape: vim.Option,string
--- @operator add: vim.opt.mouseshape
--- @operator sub: vim.opt.mouseshape
--- @operator pow: vim.opt.mouseshape
vim.opt.mouseshape = ""
vim.opt.mouses = vim.opt.mouseshape
--- @return string
function vim.opt.mouseshape:get()end

-- `'mousetime'`  `'mouset'` 	number	(default 500)
-- 			global
-- 	Defines the maximum time in msec between two mouse clicks for the
-- 	second click to be recognized as a multi click.
--- @class vim.opt.mousetime: vim.Option,number
--- @operator add: vim.opt.mousetime
--- @operator sub: vim.opt.mousetime
--- @operator pow: vim.opt.mousetime
vim.opt.mousetime = 500
vim.opt.mouset = vim.opt.mousetime
--- @return number
function vim.opt.mousetime:get()end

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
--- @class vim.opt.nrformats: vim.Option,string[]
--- @operator add: vim.opt.nrformats
--- @operator sub: vim.opt.nrformats
--- @operator pow: vim.opt.nrformats
vim.opt.nrformats = "bin,hex"
vim.opt.nf = vim.opt.nrformats
--- @return string[]
function vim.opt.nrformats:get()end

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
--- @class vim.opt.number: vim.Option,boolean
--- @operator add: vim.opt.number
--- @operator sub: vim.opt.number
--- @operator pow: vim.opt.number
vim.opt.number = false
vim.opt.nu = vim.opt.number
--- @return boolean
function vim.opt.number:get()end

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
--- @class vim.opt.numberwidth: vim.Option,number
--- @operator add: vim.opt.numberwidth
--- @operator sub: vim.opt.numberwidth
--- @operator pow: vim.opt.numberwidth
vim.opt.numberwidth = 4
vim.opt.nuw = vim.opt.numberwidth
--- @return number
function vim.opt.numberwidth:get()end

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
--- @class vim.opt.omnifunc: vim.Option,string
--- @operator add: vim.opt.omnifunc
--- @operator sub: vim.opt.omnifunc
--- @operator pow: vim.opt.omnifunc
vim.opt.omnifunc = ""
vim.opt.ofu = vim.opt.omnifunc
--- @return string
function vim.opt.omnifunc:get()end

-- `'opendevice'`  `'odev'` 	boolean	(default off)
-- 			global
-- 			{only for Windows}
-- 	Enable reading and writing from devices.  This may get Vim stuck on a
-- 	device that can be opened but doesn't actually do the I/O.  Therefore
-- 	it is off by default.
-- 	Note that on Windows editing "aux.h", "lpt1.txt" and the like also
-- 	result in editing a device.
--- @class vim.opt.opendevice: vim.Option,boolean
--- @operator add: vim.opt.opendevice
--- @operator sub: vim.opt.opendevice
--- @operator pow: vim.opt.opendevice
vim.opt.opendevice = false
vim.opt.odev = vim.opt.opendevice
--- @return boolean
function vim.opt.opendevice:get()end

-- `'operatorfunc'`  `'opfunc'` 	string	(default: empty)
-- 			global
-- 	This option specifies a function to be called by the |g@| operator.
-- 	See |:map-operator| for more info and an example.  The value can be
-- 	the name of a function, a |lambda| or a |Funcref|. See
-- 	|option-value-function| for more information.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.operatorfunc: vim.Option,string
--- @operator add: vim.opt.operatorfunc
--- @operator sub: vim.opt.operatorfunc
--- @operator pow: vim.opt.operatorfunc
vim.opt.operatorfunc = ""
vim.opt.opfunc = vim.opt.operatorfunc
--- @return string
function vim.opt.operatorfunc:get()end

-- `'packpath'`  `'pp'` 		string	(default: see `'runtimepath'` )
-- 	Directories used to find packages.  See |packages| and |rtp-packages|.
--- @class vim.opt.packpath: vim.Option,string[]
--- @operator add: vim.opt.packpath
--- @operator sub: vim.opt.packpath
--- @operator pow: vim.opt.packpath
vim.opt.packpath = "/home/runner/.config/nvim,/etc/xdg/nvim,/home/runner/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/tmp/nvim/squashfs-root/usr/share/nvim/runtime,/tmp/nvim/squashfs-root/usr/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/runner/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/runner/.config/nvim/after"
vim.opt.pp = vim.opt.packpath
--- @return string[]
function vim.opt.packpath:get()end

-- `'paragraphs'`  `'para'` 	string	(default "IPLPPPQPP TPHPLIPpLpItpplpipbp")
-- 			global
-- 	Specifies the nroff macros that separate paragraphs.  These are pairs
-- 	of two letters (see |object-motions|).
--- @class vim.opt.paragraphs: vim.Option,string
--- @operator add: vim.opt.paragraphs
--- @operator sub: vim.opt.paragraphs
--- @operator pow: vim.opt.paragraphs
vim.opt.paragraphs = "IPLPPPQPP TPHPLIPpLpItpplpipbp"
vim.opt.para = vim.opt.paragraphs
--- @return string
function vim.opt.paragraphs:get()end

--- @class vim.opt.paste: vim.Option,boolean
--- @operator add: vim.opt.paste
--- @operator sub: vim.opt.paste
--- @operator pow: vim.opt.paste
vim.opt.paste = false
--- @return boolean
function vim.opt.paste:get()end

--- @class vim.opt.pastetoggle: vim.Option,string
--- @operator add: vim.opt.pastetoggle
--- @operator sub: vim.opt.pastetoggle
--- @operator pow: vim.opt.pastetoggle
vim.opt.pastetoggle = ""
vim.opt.pt = vim.opt.pastetoggle
--- @return string
function vim.opt.pastetoggle:get()end

-- `'patchexpr'`  `'pex'` 	string	(default "")
-- 			global
-- 	Expression which is evaluated to apply a patch to a file and generate
-- 	the resulting new version of the file.  See |diff-patchexpr|.
--- @class vim.opt.patchexpr: vim.Option,string
--- @operator add: vim.opt.patchexpr
--- @operator sub: vim.opt.patchexpr
--- @operator pow: vim.opt.patchexpr
vim.opt.patchexpr = ""
vim.opt.pex = vim.opt.patchexpr
--- @return string
function vim.opt.patchexpr:get()end

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
--- @class vim.opt.patchmode: vim.Option,string
--- @operator add: vim.opt.patchmode
--- @operator sub: vim.opt.patchmode
--- @operator pow: vim.opt.patchmode
vim.opt.patchmode = ""
vim.opt.pm = vim.opt.patchmode
--- @return string
function vim.opt.patchmode:get()end

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
--- @class vim.opt.path: vim.Option,string[]
--- @operator add: vim.opt.path
--- @operator sub: vim.opt.path
--- @operator pow: vim.opt.path
vim.opt.path = ".,/usr/include,,"
vim.opt.pa = vim.opt.path
--- @return string[]
function vim.opt.path:get()end

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
--- @class vim.opt.preserveindent: vim.Option,boolean
--- @operator add: vim.opt.preserveindent
--- @operator sub: vim.opt.preserveindent
--- @operator pow: vim.opt.preserveindent
vim.opt.preserveindent = false
vim.opt.pi = vim.opt.preserveindent
--- @return boolean
function vim.opt.preserveindent:get()end

-- `'previewheight'`  `'pvh'` 	number (default 12)
-- 			global
-- 	Default height for a preview window.  Used for |:ptag| and associated
-- 	commands.  Used for |CTRL-W_}| when no count is given.
--- @class vim.opt.previewheight: vim.Option,number
--- @operator add: vim.opt.previewheight
--- @operator sub: vim.opt.previewheight
--- @operator pow: vim.opt.previewheight
vim.opt.previewheight = 12
vim.opt.pvh = vim.opt.previewheight
--- @return number
function vim.opt.previewheight:get()end

-- `'previewwindow'`  `'pvw'` 	boolean (default off)
-- 			local to window
-- 	Identifies the preview window.  Only one window can have this option
-- 	set.  It's normally not set directly, but by using one of the commands
-- 	|:ptag|, |:pedit|, etc.
--- @class vim.opt.previewwindow: vim.Option,boolean
--- @operator add: vim.opt.previewwindow
--- @operator sub: vim.opt.previewwindow
--- @operator pow: vim.opt.previewwindow
vim.opt.previewwindow = false
vim.opt.pvw = vim.opt.previewwindow
--- @return boolean
function vim.opt.previewwindow:get()end

--- @class vim.opt.prompt: vim.Option,boolean
--- @operator add: vim.opt.prompt
--- @operator sub: vim.opt.prompt
--- @operator pow: vim.opt.prompt
vim.opt.prompt = true
--- @return boolean
function vim.opt.prompt:get()end

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
--- @class vim.opt.pumblend: vim.Option,number
--- @operator add: vim.opt.pumblend
--- @operator sub: vim.opt.pumblend
--- @operator pow: vim.opt.pumblend
vim.opt.pumblend = 0
vim.opt.pb = vim.opt.pumblend
--- @return number
function vim.opt.pumblend:get()end

-- `'pumheight'`  `'ph'` 	number	(default 0)
-- 			global
-- 	Maximum number of items to show in the popup menu
-- 	(|ins-completion-menu|). Zero means "use available screen space".
--- @class vim.opt.pumheight: vim.Option,number
--- @operator add: vim.opt.pumheight
--- @operator sub: vim.opt.pumheight
--- @operator pow: vim.opt.pumheight
vim.opt.pumheight = 0
vim.opt.ph = vim.opt.pumheight
--- @return number
function vim.opt.pumheight:get()end

-- `'pumwidth'`  `'pw'` 		number	(default 15)
-- 			global
-- 	Minimum width for the popup menu (|ins-completion-menu|).  If the
-- 	cursor column + `'pumwidth'`  exceeds screen width, the popup menu is
-- 	nudged to fit on the screen.
--- @class vim.opt.pumwidth: vim.Option,number
--- @operator add: vim.opt.pumwidth
--- @operator sub: vim.opt.pumwidth
--- @operator pow: vim.opt.pumwidth
vim.opt.pumwidth = 15
vim.opt.pw = vim.opt.pumwidth
--- @return number
function vim.opt.pumwidth:get()end

-- `'pyxversion'`  `'pyx'` 	number	(default 3)
-- 			global
-- 	Specifies the python version used for pyx* functions and commands
-- 	|python_x|.  As only Python 3 is supported, this always has the value
-- 	`3`. Setting any other value is an error.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.pyxversion: vim.Option,number
--- @operator add: vim.opt.pyxversion
--- @operator sub: vim.opt.pyxversion
--- @operator pow: vim.opt.pyxversion
vim.opt.pyxversion = 3
vim.opt.pyx = vim.opt.pyxversion
--- @return number
function vim.opt.pyxversion:get()end

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
--- @class vim.opt.quickfixtextfunc: vim.Option,string
--- @operator add: vim.opt.quickfixtextfunc
--- @operator sub: vim.opt.quickfixtextfunc
--- @operator pow: vim.opt.quickfixtextfunc
vim.opt.quickfixtextfunc = ""
vim.opt.qftf = vim.opt.quickfixtextfunc
--- @return string
function vim.opt.quickfixtextfunc:get()end

-- `'quoteescape'`  `'qe'` 	string	(default "\")
-- 			local to buffer
-- 	The characters that are used to escape quotes in a string.  Used for
-- 	objects like a', a" and a` |a'|.
-- 	When one of the characters in this option is found inside a string,
-- 	the following character will be skipped.  The default value makes the
-- 	text "foo\"bar\\" considered to be one string.
--- @class vim.opt.quoteescape: vim.Option,string
--- @operator add: vim.opt.quoteescape
--- @operator sub: vim.opt.quoteescape
--- @operator pow: vim.opt.quoteescape
vim.opt.quoteescape = "\\"
vim.opt.qe = vim.opt.quoteescape
--- @return string
function vim.opt.quoteescape:get()end

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
--- @class vim.opt.readonly: vim.Option,boolean
--- @operator add: vim.opt.readonly
--- @operator sub: vim.opt.readonly
--- @operator pow: vim.opt.readonly
vim.opt.readonly = false
vim.opt.ro = vim.opt.readonly
--- @return boolean
function vim.opt.readonly:get()end

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
--- @class vim.opt.redrawdebug: vim.Option,string[]
--- @operator add: vim.opt.redrawdebug
--- @operator sub: vim.opt.redrawdebug
--- @operator pow: vim.opt.redrawdebug
vim.opt.redrawdebug = ""
vim.opt.rdb = vim.opt.redrawdebug
--- @return string[]
function vim.opt.redrawdebug:get()end

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
--- @class vim.opt.redrawtime: vim.Option,number
--- @operator add: vim.opt.redrawtime
--- @operator sub: vim.opt.redrawtime
--- @operator pow: vim.opt.redrawtime
vim.opt.redrawtime = 2000
vim.opt.rdt = vim.opt.redrawtime
--- @return number
function vim.opt.redrawtime:get()end

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
--- @class vim.opt.regexpengine: vim.Option,number
--- @operator add: vim.opt.regexpengine
--- @operator sub: vim.opt.regexpengine
--- @operator pow: vim.opt.regexpengine
vim.opt.regexpengine = 0
vim.opt.re = vim.opt.regexpengine
--- @return number
function vim.opt.regexpengine:get()end

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
--- @class vim.opt.relativenumber: vim.Option,boolean
--- @operator add: vim.opt.relativenumber
--- @operator sub: vim.opt.relativenumber
--- @operator pow: vim.opt.relativenumber
vim.opt.relativenumber = false
vim.opt.rnu = vim.opt.relativenumber
--- @return boolean
function vim.opt.relativenumber:get()end

--- @class vim.opt.remap: vim.Option,boolean
--- @operator add: vim.opt.remap
--- @operator sub: vim.opt.remap
--- @operator pow: vim.opt.remap
vim.opt.remap = true
--- @return boolean
function vim.opt.remap:get()end

-- `'report'` 		number	(default 2)
-- 			global
-- 	Threshold for reporting number of lines changed.  When the number of
-- 	changed lines is more than `'report'`  a message will be given for most
-- 	":" commands.  If you want it always, set `'report'`  to 0.
-- 	For the ":substitute" command the number of substitutions is used
-- 	instead of the number of lines.
--- @class vim.opt.report: vim.Option,number
--- @operator add: vim.opt.report
--- @operator sub: vim.opt.report
--- @operator pow: vim.opt.report
vim.opt.report = 2
--- @return number
function vim.opt.report:get()end

-- `'revins'`  `'ri'` 		boolean	(default off)
-- 			global
-- 	Inserting characters in Insert mode will work backwards.  See "typing
-- 	backwards" |ins-reverse|.  This option can be toggled with the CTRL-_
-- 	command in Insert mode, when `'allowrevins'`  is set.
--- @class vim.opt.revins: vim.Option,boolean
--- @operator add: vim.opt.revins
--- @operator sub: vim.opt.revins
--- @operator pow: vim.opt.revins
vim.opt.revins = false
vim.opt.ri = vim.opt.revins
--- @return boolean
function vim.opt.revins:get()end

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
--- @class vim.opt.rightleft: vim.Option,boolean
--- @operator add: vim.opt.rightleft
--- @operator sub: vim.opt.rightleft
--- @operator pow: vim.opt.rightleft
vim.opt.rightleft = false
vim.opt.rl = vim.opt.rightleft
--- @return boolean
function vim.opt.rightleft:get()end

-- `'rightleftcmd'`  `'rlc'` 	string	(default "search")
-- 			local to window
-- 	Each word in this option enables the command line editing to work in
-- 	right-to-left mode for a group of commands:
-- 
-- 		search		"/" and "?" commands
-- 
-- 	This is useful for languages such as Hebrew, Arabic and Farsi.
-- 	The `'rightleft'`  option must be set for `'rightleftcmd'`  to take effect.
--- @class vim.opt.rightleftcmd: vim.Option,string
--- @operator add: vim.opt.rightleftcmd
--- @operator sub: vim.opt.rightleftcmd
--- @operator pow: vim.opt.rightleftcmd
vim.opt.rightleftcmd = "search"
vim.opt.rlc = vim.opt.rightleftcmd
--- @return string
function vim.opt.rightleftcmd:get()end

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
--- @class vim.opt.ruler: vim.Option,boolean
--- @operator add: vim.opt.ruler
--- @operator sub: vim.opt.ruler
--- @operator pow: vim.opt.ruler
vim.opt.ruler = true
vim.opt.ru = vim.opt.ruler
--- @return boolean
function vim.opt.ruler:get()end

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
--- @class vim.opt.rulerformat: vim.Option,string
--- @operator add: vim.opt.rulerformat
--- @operator sub: vim.opt.rulerformat
--- @operator pow: vim.opt.rulerformat
vim.opt.rulerformat = ""
vim.opt.ruf = vim.opt.rulerformat
--- @return string
function vim.opt.rulerformat:get()end

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
--- @class vim.opt.runtimepath: vim.Option,string[]
--- @operator add: vim.opt.runtimepath
--- @operator sub: vim.opt.runtimepath
--- @operator pow: vim.opt.runtimepath
vim.opt.runtimepath = "/home/runner/.config/nvim,/etc/xdg/nvim,/home/runner/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/tmp/nvim/squashfs-root/usr/share/nvim/runtime,/tmp/nvim/squashfs-root/usr/lib/nvim,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/runner/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/runner/.config/nvim/after"
vim.opt.rtp = vim.opt.runtimepath
--- @return string[]
function vim.opt.runtimepath:get()end

-- `'scroll'`  `'scr'` 		number	(default: half the window height)
-- 			local to window
-- 	Number of lines to scroll with CTRL-U and CTRL-D commands.  Will be
-- 	set to half the number of lines in the window when the window size
-- 	changes.  This may happen when enabling the |status-line| or
-- 	`'tabline'`  option after setting the `'scroll'`  option.
-- 	If you give a count to the CTRL-U or CTRL-D command it will
-- 	be used as the new value for `'scroll'` .  Reset to half the window
-- 	height with ":set scroll=0".
--- @class vim.opt.scroll: vim.Option,number
--- @operator add: vim.opt.scroll
--- @operator sub: vim.opt.scroll
--- @operator pow: vim.opt.scroll
vim.opt.scroll = 0
vim.opt.scr = vim.opt.scroll
--- @return number
function vim.opt.scroll:get()end

-- `'scrollback'`  `'scbk'` 	number	(default: 10000)
-- 			local to buffer
-- 	Maximum number of lines kept beyond the visible screen. Lines at the
-- 	top are deleted if new lines exceed this limit.
-- 	Minimum is 1, maximum is 100000.
-- 	Only in |terminal| buffers.
--- @class vim.opt.scrollback: vim.Option,number
--- @operator add: vim.opt.scrollback
--- @operator sub: vim.opt.scrollback
--- @operator pow: vim.opt.scrollback
vim.opt.scrollback = -1
vim.opt.scbk = vim.opt.scrollback
--- @return number
function vim.opt.scrollback:get()end

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
--- @class vim.opt.scrollbind: vim.Option,boolean
--- @operator add: vim.opt.scrollbind
--- @operator sub: vim.opt.scrollbind
--- @operator pow: vim.opt.scrollbind
vim.opt.scrollbind = false
vim.opt.scb = vim.opt.scrollbind
--- @return boolean
function vim.opt.scrollbind:get()end

-- `'scrolljump'`  `'sj'` 	number	(default 1)
-- 			global
-- 	Minimal number of lines to scroll when the cursor gets off the
-- 	screen (e.g., with "j").  Not used for scroll commands (e.g., CTRL-E,
-- 	CTRL-D).  Useful if your terminal scrolls very slowly.
-- 	When set to a negative number from -1 to -100 this is used as the
-- 	percentage of the window height.  Thus -50 scrolls half the window
-- 	height.
--- @class vim.opt.scrolljump: vim.Option,number
--- @operator add: vim.opt.scrolljump
--- @operator sub: vim.opt.scrolljump
--- @operator pow: vim.opt.scrolljump
vim.opt.scrolljump = 1
vim.opt.sj = vim.opt.scrolljump
--- @return number
function vim.opt.scrolljump:get()end

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
--- @class vim.opt.scrolloff: vim.Option,number
--- @operator add: vim.opt.scrolloff
--- @operator sub: vim.opt.scrolloff
--- @operator pow: vim.opt.scrolloff
vim.opt.scrolloff = 0
vim.opt.so = vim.opt.scrolloff
--- @return number
function vim.opt.scrolloff:get()end

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
--- @class vim.opt.scrollopt: vim.Option,string[]
--- @operator add: vim.opt.scrollopt
--- @operator sub: vim.opt.scrollopt
--- @operator pow: vim.opt.scrollopt
vim.opt.scrollopt = "ver,jump"
vim.opt.sbo = vim.opt.scrollopt
--- @return string[]
function vim.opt.scrollopt:get()end

-- `'sections'`  `'sect'` 	string	(default "SHNHH HUnhsh")
-- 			global
-- 	Specifies the nroff macros that separate sections.  These are pairs of
-- 	two letters (See |object-motions|).  The default makes a section start
-- 	at the nroff macros ".SH", ".NH", ".H", ".HU", ".nh" and ".sh".
--- @class vim.opt.sections: vim.Option,string
--- @operator add: vim.opt.sections
--- @operator sub: vim.opt.sections
--- @operator pow: vim.opt.sections
vim.opt.sections = "SHNHH HUnhsh"
vim.opt.sect = vim.opt.sections
--- @return string
function vim.opt.sections:get()end

--- @class vim.opt.secure: vim.Option,boolean
--- @operator add: vim.opt.secure
--- @operator sub: vim.opt.secure
--- @operator pow: vim.opt.secure
vim.opt.secure = false
--- @return boolean
function vim.opt.secure:get()end

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
--- @class vim.opt.selection: vim.Option,string
--- @operator add: vim.opt.selection
--- @operator sub: vim.opt.selection
--- @operator pow: vim.opt.selection
vim.opt.selection = "inclusive"
vim.opt.sel = vim.opt.selection
--- @return string
function vim.opt.selection:get()end

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
--- @class vim.opt.selectmode: vim.Option,string[]
--- @operator add: vim.opt.selectmode
--- @operator sub: vim.opt.selectmode
--- @operator pow: vim.opt.selectmode
vim.opt.selectmode = ""
vim.opt.slm = vim.opt.selectmode
--- @return string[]
function vim.opt.selectmode:get()end

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
--- @class vim.opt.sessionoptions: vim.Option,string[]
--- @operator add: vim.opt.sessionoptions
--- @operator sub: vim.opt.sessionoptions
--- @operator pow: vim.opt.sessionoptions
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
vim.opt.ssop = vim.opt.sessionoptions
--- @return string[]
function vim.opt.sessionoptions:get()end

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
--- @class vim.opt.shada: vim.Option,string[]
--- @operator add: vim.opt.shada
--- @operator sub: vim.opt.shada
--- @operator pow: vim.opt.shada
vim.opt.shada = "!,'100,<50,s10,h"
vim.opt.sd = vim.opt.shada
--- @return string[]
function vim.opt.shada:get()end

-- `'shadafile'`  `'sdf'` 	string	(default: "")
-- 			global
-- 	When non-empty, overrides the file name used for |shada| (viminfo).
-- 	When equal to "NONE" no shada file will be read or written.
-- 	This option can be set with the |-i| command line flag.  The |--clean|
-- 	command line flag sets it to "NONE".
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.shadafile: vim.Option,string[]
--- @operator add: vim.opt.shadafile
--- @operator sub: vim.opt.shadafile
--- @operator pow: vim.opt.shadafile
vim.opt.shadafile = ""
vim.opt.sdf = vim.opt.shadafile
--- @return string[]
function vim.opt.shadafile:get()end

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
--- @class vim.opt.shell: vim.Option,string
--- @operator add: vim.opt.shell
--- @operator sub: vim.opt.shell
--- @operator pow: vim.opt.shell
vim.opt.shell = "sh"
vim.opt.sh = vim.opt.shell
--- @return string
function vim.opt.shell:get()end

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
--- @class vim.opt.shellcmdflag: vim.Option,string
--- @operator add: vim.opt.shellcmdflag
--- @operator sub: vim.opt.shellcmdflag
--- @operator pow: vim.opt.shellcmdflag
vim.opt.shellcmdflag = "-c"
vim.opt.shcf = vim.opt.shellcmdflag
--- @return string
function vim.opt.shellcmdflag:get()end

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
--- @class vim.opt.shellpipe: vim.Option,string
--- @operator add: vim.opt.shellpipe
--- @operator sub: vim.opt.shellpipe
--- @operator pow: vim.opt.shellpipe
vim.opt.shellpipe = "| tee"
vim.opt.sp = vim.opt.shellpipe
--- @return string
function vim.opt.shellpipe:get()end

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
--- @class vim.opt.shellquote: vim.Option,string
--- @operator add: vim.opt.shellquote
--- @operator sub: vim.opt.shellquote
--- @operator pow: vim.opt.shellquote
vim.opt.shellquote = ""
vim.opt.shq = vim.opt.shellquote
--- @return string
function vim.opt.shellquote:get()end

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
--- @class vim.opt.shellredir: vim.Option,string
--- @operator add: vim.opt.shellredir
--- @operator sub: vim.opt.shellredir
--- @operator pow: vim.opt.shellredir
vim.opt.shellredir = ">"
vim.opt.srr = vim.opt.shellredir
--- @return string
function vim.opt.shellredir:get()end

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
--- @class vim.opt.shellslash: vim.Option,boolean
--- @operator add: vim.opt.shellslash
--- @operator sub: vim.opt.shellslash
--- @operator pow: vim.opt.shellslash
vim.opt.shellslash = false
vim.opt.ssl = vim.opt.shellslash
--- @return boolean
function vim.opt.shellslash:get()end

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
--- @class vim.opt.shelltemp: vim.Option,boolean
--- @operator add: vim.opt.shelltemp
--- @operator sub: vim.opt.shelltemp
--- @operator pow: vim.opt.shelltemp
vim.opt.shelltemp = true
vim.opt.stmp = vim.opt.shelltemp
--- @return boolean
function vim.opt.shelltemp:get()end

-- `'shellxescape'`  `'sxe'` 	string	(default: "")
-- 			global
-- 	When `'shellxquote'`  is set to "(" then the characters listed in this
-- 	option will be escaped with a `'^'`  character.  This makes it possible
-- 	to execute most external commands with cmd.exe.
--- @class vim.opt.shellxescape: vim.Option,string
--- @operator add: vim.opt.shellxescape
--- @operator sub: vim.opt.shellxescape
--- @operator pow: vim.opt.shellxescape
vim.opt.shellxescape = ""
vim.opt.sxe = vim.opt.shellxescape
--- @return string
function vim.opt.shellxescape:get()end

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
--- @class vim.opt.shellxquote: vim.Option,string
--- @operator add: vim.opt.shellxquote
--- @operator sub: vim.opt.shellxquote
--- @operator pow: vim.opt.shellxquote
vim.opt.shellxquote = ""
vim.opt.sxq = vim.opt.shellxquote
--- @return string
function vim.opt.shellxquote:get()end

-- `'shiftround'`  `'sr'` 	boolean	(default off)
-- 			global
-- 	Round indent to multiple of `'shiftwidth'` .  Applies to > and <
-- 	commands.  CTRL-T and CTRL-D in Insert mode always round the indent to
-- 	a multiple of `'shiftwidth'`  (this is Vi compatible).
--- @class vim.opt.shiftround: vim.Option,boolean
--- @operator add: vim.opt.shiftround
--- @operator sub: vim.opt.shiftround
--- @operator pow: vim.opt.shiftround
vim.opt.shiftround = false
vim.opt.sr = vim.opt.shiftround
--- @return boolean
function vim.opt.shiftround:get()end

-- `'shiftwidth'`  `'sw'` 	number	(default 8)
-- 			local to buffer
-- 	Number of spaces to use for each step of (auto)indent.  Used for
-- 	|`'cindent'` |, |>>|, |<<|, etc.
-- 	When zero the `'ts'`  value will be used.  Use the |shiftwidth()|
-- 	function to get the effective shiftwidth value.
--- @class vim.opt.shiftwidth: vim.Option,number
--- @operator add: vim.opt.shiftwidth
--- @operator sub: vim.opt.shiftwidth
--- @operator pow: vim.opt.shiftwidth
vim.opt.shiftwidth = 8
vim.opt.sw = vim.opt.shiftwidth
--- @return number
function vim.opt.shiftwidth:get()end

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
--- @class vim.opt.shortmess: vim.Option,string[]
--- @operator add: vim.opt.shortmess
--- @operator sub: vim.opt.shortmess
--- @operator pow: vim.opt.shortmess
vim.opt.shortmess = "filnxtToOF"
vim.opt.shm = vim.opt.shortmess
--- @return string[]
function vim.opt.shortmess:get()end

