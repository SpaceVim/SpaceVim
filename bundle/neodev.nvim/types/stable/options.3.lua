---@meta

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
--- @class vim.opt.showbreak: vim.Option,string
--- @operator add: vim.opt.showbreak
--- @operator sub: vim.opt.showbreak
--- @operator pow: vim.opt.showbreak
vim.opt.showbreak = ""
vim.opt.sbr = vim.opt.showbreak
--- @return string
function vim.opt.showbreak:get()end

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
--- @class vim.opt.showcmd: vim.Option,boolean
--- @operator add: vim.opt.showcmd
--- @operator sub: vim.opt.showcmd
--- @operator pow: vim.opt.showcmd
vim.opt.showcmd = true
vim.opt.sc = vim.opt.showcmd
--- @return boolean
function vim.opt.showcmd:get()end

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
--- @class vim.opt.showcmdloc: vim.Option,string
--- @operator add: vim.opt.showcmdloc
--- @operator sub: vim.opt.showcmdloc
--- @operator pow: vim.opt.showcmdloc
vim.opt.showcmdloc = "last"
vim.opt.sloc = vim.opt.showcmdloc
--- @return string
function vim.opt.showcmdloc:get()end

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
--- @class vim.opt.showfulltag: vim.Option,boolean
--- @operator add: vim.opt.showfulltag
--- @operator sub: vim.opt.showfulltag
--- @operator pow: vim.opt.showfulltag
vim.opt.showfulltag = false
vim.opt.sft = vim.opt.showfulltag
--- @return boolean
function vim.opt.showfulltag:get()end

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
--- @class vim.opt.showmatch: vim.Option,boolean
--- @operator add: vim.opt.showmatch
--- @operator sub: vim.opt.showmatch
--- @operator pow: vim.opt.showmatch
vim.opt.showmatch = false
vim.opt.sm = vim.opt.showmatch
--- @return boolean
function vim.opt.showmatch:get()end

-- `'showmode'`  `'smd'` 	boolean	(default: on)
-- 			global
-- 	If in Insert, Replace or Visual mode put a message on the last line.
-- 	The |hl-ModeMsg| highlight group determines the highlighting.
-- 	The option has no effect when `'cmdheight'`  is zero.
--- @class vim.opt.showmode: vim.Option,boolean
--- @operator add: vim.opt.showmode
--- @operator sub: vim.opt.showmode
--- @operator pow: vim.opt.showmode
vim.opt.showmode = true
vim.opt.smd = vim.opt.showmode
--- @return boolean
function vim.opt.showmode:get()end

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
--- @class vim.opt.showtabline: vim.Option,number
--- @operator add: vim.opt.showtabline
--- @operator sub: vim.opt.showtabline
--- @operator pow: vim.opt.showtabline
vim.opt.showtabline = 1
vim.opt.stal = vim.opt.showtabline
--- @return number
function vim.opt.showtabline:get()end

-- `'sidescroll'`  `'ss'` 	number	(default 1)
-- 			global
-- 	The minimal number of columns to scroll horizontally.  Used only when
-- 	the `'wrap'`  option is off and the cursor is moved off of the screen.
-- 	When it is zero the cursor will be put in the middle of the screen.
-- 	When using a slow terminal set it to a large number or 0.  Not used
-- 	for "zh" and "zl" commands.
--- @class vim.opt.sidescroll: vim.Option,number
--- @operator add: vim.opt.sidescroll
--- @operator sub: vim.opt.sidescroll
--- @operator pow: vim.opt.sidescroll
vim.opt.sidescroll = 1
vim.opt.ss = vim.opt.sidescroll
--- @return number
function vim.opt.sidescroll:get()end

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
--- @class vim.opt.sidescrolloff: vim.Option,number
--- @operator add: vim.opt.sidescrolloff
--- @operator sub: vim.opt.sidescrolloff
--- @operator pow: vim.opt.sidescrolloff
vim.opt.sidescrolloff = 0
vim.opt.siso = vim.opt.sidescrolloff
--- @return number
function vim.opt.sidescrolloff:get()end

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
--- @class vim.opt.signcolumn: vim.Option,string
--- @operator add: vim.opt.signcolumn
--- @operator sub: vim.opt.signcolumn
--- @operator pow: vim.opt.signcolumn
vim.opt.signcolumn = "auto"
vim.opt.scl = vim.opt.signcolumn
--- @return string
function vim.opt.signcolumn:get()end

-- `'smartcase'`  `'scs'` 	boolean	(default off)
-- 			global
-- 	Override the `'ignorecase'`  option if the search pattern contains upper
-- 	case characters.  Only used when the search pattern is typed and
-- 	`'ignorecase'`  option is on.  Used for the commands "/", "?", "n", "N",
-- 	":g" and ":s".  Not used for "*", "#", "gd", tag search, etc.  After
-- 	"*" and "#" you can make `'smartcase'`  used by doing a "/" command,
-- 	recalling the search pattern from history and hitting <Enter>.
--- @class vim.opt.smartcase: vim.Option,boolean
--- @operator add: vim.opt.smartcase
--- @operator sub: vim.opt.smartcase
--- @operator pow: vim.opt.smartcase
vim.opt.smartcase = false
vim.opt.scs = vim.opt.smartcase
--- @return boolean
function vim.opt.smartcase:get()end

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
--- @class vim.opt.smartindent: vim.Option,boolean
--- @operator add: vim.opt.smartindent
--- @operator sub: vim.opt.smartindent
--- @operator pow: vim.opt.smartindent
vim.opt.smartindent = false
vim.opt.si = vim.opt.smartindent
--- @return boolean
function vim.opt.smartindent:get()end

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
--- @class vim.opt.smarttab: vim.Option,boolean
--- @operator add: vim.opt.smarttab
--- @operator sub: vim.opt.smarttab
--- @operator pow: vim.opt.smarttab
vim.opt.smarttab = true
vim.opt.sta = vim.opt.smarttab
--- @return boolean
function vim.opt.smarttab:get()end

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
--- @class vim.opt.softtabstop: vim.Option,number
--- @operator add: vim.opt.softtabstop
--- @operator sub: vim.opt.softtabstop
--- @operator pow: vim.opt.softtabstop
vim.opt.softtabstop = 0
vim.opt.sts = vim.opt.softtabstop
--- @return number
function vim.opt.softtabstop:get()end

-- `'spell'` 			boolean	(default off)
-- 			local to window
-- 	When on spell checking will be done.  See |spell|.
-- 	The languages are specified with `'spelllang'` .
--- @class vim.opt.spell: vim.Option,boolean
--- @operator add: vim.opt.spell
--- @operator sub: vim.opt.spell
--- @operator pow: vim.opt.spell
vim.opt.spell = false
--- @return boolean
function vim.opt.spell:get()end

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
--- @class vim.opt.spellcapcheck: vim.Option,string
--- @operator add: vim.opt.spellcapcheck
--- @operator sub: vim.opt.spellcapcheck
--- @operator pow: vim.opt.spellcapcheck
vim.opt.spellcapcheck = "[.?!]\\_[\\])'\"\t ]\\+"
vim.opt.spc = vim.opt.spellcapcheck
--- @return string
function vim.opt.spellcapcheck:get()end

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
--- @class vim.opt.spellfile: vim.Option,string[]
--- @operator add: vim.opt.spellfile
--- @operator sub: vim.opt.spellfile
--- @operator pow: vim.opt.spellfile
vim.opt.spellfile = ""
vim.opt.spf = vim.opt.spellfile
--- @return string[]
function vim.opt.spellfile:get()end

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
--- @class vim.opt.spelllang: vim.Option,string[]
--- @operator add: vim.opt.spelllang
--- @operator sub: vim.opt.spelllang
--- @operator pow: vim.opt.spelllang
vim.opt.spelllang = "en"
vim.opt.spl = vim.opt.spelllang
--- @return string[]
function vim.opt.spelllang:get()end

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
--- @class vim.opt.spelloptions: vim.Option,string[]
--- @operator add: vim.opt.spelloptions
--- @operator sub: vim.opt.spelloptions
--- @operator pow: vim.opt.spelloptions
vim.opt.spelloptions = ""
vim.opt.spo = vim.opt.spelloptions
--- @return string[]
function vim.opt.spelloptions:get()end

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
--- @class vim.opt.spellsuggest: vim.Option,string[]
--- @operator add: vim.opt.spellsuggest
--- @operator sub: vim.opt.spellsuggest
--- @operator pow: vim.opt.spellsuggest
vim.opt.spellsuggest = "best"
vim.opt.sps = vim.opt.spellsuggest
--- @return string[]
function vim.opt.spellsuggest:get()end

-- `'splitbelow'`  `'sb'` 	boolean	(default off)
-- 			global
-- 	When on, splitting a window will put the new window below the current
-- 	one. |:split|
--- @class vim.opt.splitbelow: vim.Option,boolean
--- @operator add: vim.opt.splitbelow
--- @operator sub: vim.opt.splitbelow
--- @operator pow: vim.opt.splitbelow
vim.opt.splitbelow = false
vim.opt.sb = vim.opt.splitbelow
--- @return boolean
function vim.opt.splitbelow:get()end

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
--- @class vim.opt.splitkeep: vim.Option,string
--- @operator add: vim.opt.splitkeep
--- @operator sub: vim.opt.splitkeep
--- @operator pow: vim.opt.splitkeep
vim.opt.splitkeep = "cursor"
vim.opt.spk = vim.opt.splitkeep
--- @return string
function vim.opt.splitkeep:get()end

-- `'splitright'`  `'spr'` 	boolean	(default off)
-- 			global
-- 	When on, splitting a window will put the new window right of the
-- 	current one. |:vsplit|
--- @class vim.opt.splitright: vim.Option,boolean
--- @operator add: vim.opt.splitright
--- @operator sub: vim.opt.splitright
--- @operator pow: vim.opt.splitright
vim.opt.splitright = false
vim.opt.spr = vim.opt.splitright
--- @return boolean
function vim.opt.splitright:get()end

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
--- @class vim.opt.startofline: vim.Option,boolean
--- @operator add: vim.opt.startofline
--- @operator sub: vim.opt.startofline
--- @operator pow: vim.opt.startofline
vim.opt.startofline = false
vim.opt.sol = vim.opt.startofline
--- @return boolean
function vim.opt.startofline:get()end

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
--- @class vim.opt.statuscolumn: vim.Option,string
--- @operator add: vim.opt.statuscolumn
--- @operator sub: vim.opt.statuscolumn
--- @operator pow: vim.opt.statuscolumn
vim.opt.statuscolumn = ""
vim.opt.stc = vim.opt.statuscolumn
--- @return string
function vim.opt.statuscolumn:get()end

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
--- @class vim.opt.statusline: vim.Option,string
--- @operator add: vim.opt.statusline
--- @operator sub: vim.opt.statusline
--- @operator pow: vim.opt.statusline
vim.opt.statusline = ""
vim.opt.stl = vim.opt.statusline
--- @return string
function vim.opt.statusline:get()end

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
--- @class vim.opt.suffixes: vim.Option,string[]
--- @operator add: vim.opt.suffixes
--- @operator sub: vim.opt.suffixes
--- @operator pow: vim.opt.suffixes
vim.opt.suffixes = ".bak,~,.o,.h,.info,.swp,.obj"
vim.opt.su = vim.opt.suffixes
--- @return string[]
function vim.opt.suffixes:get()end

-- `'suffixesadd'`  `'sua'` 	string	(default "")
-- 			local to buffer
-- 	Comma-separated list of suffixes, which are used when searching for a
-- 	file for the "gf", "[I", etc. commands.  Example: >
-- 		:set suffixesadd=.java
-- <
--- @class vim.opt.suffixesadd: vim.Option,string[]
--- @operator add: vim.opt.suffixesadd
--- @operator sub: vim.opt.suffixesadd
--- @operator pow: vim.opt.suffixesadd
vim.opt.suffixesadd = ""
vim.opt.sua = vim.opt.suffixesadd
--- @return string[]
function vim.opt.suffixesadd:get()end

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
--- @class vim.opt.swapfile: vim.Option,boolean
--- @operator add: vim.opt.swapfile
--- @operator sub: vim.opt.swapfile
--- @operator pow: vim.opt.swapfile
vim.opt.swapfile = true
vim.opt.swf = vim.opt.swapfile
--- @return boolean
function vim.opt.swapfile:get()end

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
--- @class vim.opt.switchbuf: vim.Option,string[]
--- @operator add: vim.opt.switchbuf
--- @operator sub: vim.opt.switchbuf
--- @operator pow: vim.opt.switchbuf
vim.opt.switchbuf = "uselast"
vim.opt.swb = vim.opt.switchbuf
--- @return string[]
function vim.opt.switchbuf:get()end

-- `'synmaxcol'`  `'smc'` 	number	(default 3000)
-- 			local to buffer
-- 	Maximum column in which to search for syntax items.  In long lines the
-- 	text after this column is not highlighted and following lines may not
-- 	be highlighted correctly, because the syntax state is cleared.
-- 	This helps to avoid very slow redrawing for an XML file that is one
-- 	long line.
-- 	Set to zero to remove the limit.
--- @class vim.opt.synmaxcol: vim.Option,number
--- @operator add: vim.opt.synmaxcol
--- @operator sub: vim.opt.synmaxcol
--- @operator pow: vim.opt.synmaxcol
vim.opt.synmaxcol = 3000
vim.opt.smc = vim.opt.synmaxcol
--- @return number
function vim.opt.synmaxcol:get()end

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
--- @class vim.opt.syntax: vim.Option,string
--- @operator add: vim.opt.syntax
--- @operator sub: vim.opt.syntax
--- @operator pow: vim.opt.syntax
vim.opt.syntax = ""
vim.opt.syn = vim.opt.syntax
--- @return string
function vim.opt.syntax:get()end

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
--- @class vim.opt.tabline: vim.Option,string
--- @operator add: vim.opt.tabline
--- @operator sub: vim.opt.tabline
--- @operator pow: vim.opt.tabline
vim.opt.tabline = ""
vim.opt.tal = vim.opt.tabline
--- @return string
function vim.opt.tabline:get()end

-- `'tabpagemax'`  `'tpm'` 	number	(default 50)
-- 			global
-- 	Maximum number of tab pages to be opened by the |-p| command line
-- 	argument or the ":tab all" command. |tabpage|
--- @class vim.opt.tabpagemax: vim.Option,number
--- @operator add: vim.opt.tabpagemax
--- @operator sub: vim.opt.tabpagemax
--- @operator pow: vim.opt.tabpagemax
vim.opt.tabpagemax = 50
vim.opt.tpm = vim.opt.tabpagemax
--- @return number
function vim.opt.tabpagemax:get()end

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
--- @class vim.opt.tabstop: vim.Option,number
--- @operator add: vim.opt.tabstop
--- @operator sub: vim.opt.tabstop
--- @operator pow: vim.opt.tabstop
vim.opt.tabstop = 8
vim.opt.ts = vim.opt.tabstop
--- @return number
function vim.opt.tabstop:get()end

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
--- @class vim.opt.tagbsearch: vim.Option,boolean
--- @operator add: vim.opt.tagbsearch
--- @operator sub: vim.opt.tagbsearch
--- @operator pow: vim.opt.tagbsearch
vim.opt.tagbsearch = true
vim.opt.tbs = vim.opt.tagbsearch
--- @return boolean
function vim.opt.tagbsearch:get()end

-- `'tagcase'`  `'tc'` 		string	(default "followic")
-- 			global or local to buffer |global-local|
-- 	This option specifies how case is handled when searching the tags
-- 	file:
-- 	   followic	Follow the `'ignorecase'`  option
-- 	   followscs    Follow the `'smartcase'`  and `'ignorecase'`  options
-- 	   ignore	Ignore case
-- 	   match	Match case
-- 	   smart	Ignore case unless an upper case letter is used
--- @class vim.opt.tagcase: vim.Option,string
--- @operator add: vim.opt.tagcase
--- @operator sub: vim.opt.tagcase
--- @operator pow: vim.opt.tagcase
vim.opt.tagcase = "followic"
vim.opt.tc = vim.opt.tagcase
--- @return string
function vim.opt.tagcase:get()end

-- `'tagfunc'`  `'tfu'` 		string	(default: empty)
-- 			local to buffer
-- 	This option specifies a function to be used to perform tag searches.
-- 	The function gets the tag pattern and should return a List of matching
-- 	tags.  See |tag-function| for an explanation of how to write the
-- 	function and an example.  The value can be the name of a function, a
-- 	|lambda| or a |Funcref|. See |option-value-function| for more
-- 	information.
--- @class vim.opt.tagfunc: vim.Option,string
--- @operator add: vim.opt.tagfunc
--- @operator sub: vim.opt.tagfunc
--- @operator pow: vim.opt.tagfunc
vim.opt.tagfunc = ""
vim.opt.tfu = vim.opt.tagfunc
--- @return string
function vim.opt.tagfunc:get()end

-- `'taglength'`  `'tl'` 	number	(default 0)
-- 			global
-- 	If non-zero, tags are significant up to this number of characters.
--- @class vim.opt.taglength: vim.Option,number
--- @operator add: vim.opt.taglength
--- @operator sub: vim.opt.taglength
--- @operator pow: vim.opt.taglength
vim.opt.taglength = 0
vim.opt.tl = vim.opt.taglength
--- @return number
function vim.opt.taglength:get()end

-- `'tagrelative'`  `'tr'` 	boolean	(default: on)
-- 			global
-- 	If on and using a tags file in another directory, file names in that
-- 	tags file are relative to the directory where the tags file is.
--- @class vim.opt.tagrelative: vim.Option,boolean
--- @operator add: vim.opt.tagrelative
--- @operator sub: vim.opt.tagrelative
--- @operator pow: vim.opt.tagrelative
vim.opt.tagrelative = true
vim.opt.tr = vim.opt.tagrelative
--- @return boolean
function vim.opt.tagrelative:get()end

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
--- @class vim.opt.tags: vim.Option,string[]
--- @operator add: vim.opt.tags
--- @operator sub: vim.opt.tags
--- @operator pow: vim.opt.tags
vim.opt.tags = "./tags;,tags"
vim.opt.tag = vim.opt.tags
--- @return string[]
function vim.opt.tags:get()end

-- `'tagstack'`  `'tgst'` 	boolean	(default on)
-- 			global
-- 	When on, the |tagstack| is used normally.  When off, a ":tag" or
-- 	":tselect" command with an argument will not push the tag onto the
-- 	tagstack.  A following ":tag" without an argument, a ":pop" command or
-- 	any other command that uses the tagstack will use the unmodified
-- 	tagstack, but does change the pointer to the active entry.
-- 	Resetting this option is useful when using a ":tag" command in a
-- 	mapping which should not change the tagstack.
--- @class vim.opt.tagstack: vim.Option,boolean
--- @operator add: vim.opt.tagstack
--- @operator sub: vim.opt.tagstack
--- @operator pow: vim.opt.tagstack
vim.opt.tagstack = true
vim.opt.tgst = vim.opt.tagstack
--- @return boolean
function vim.opt.tagstack:get()end

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
--- @class vim.opt.termbidi: vim.Option,boolean
--- @operator add: vim.opt.termbidi
--- @operator sub: vim.opt.termbidi
--- @operator pow: vim.opt.termbidi
vim.opt.termbidi = false
vim.opt.tbidi = vim.opt.termbidi
--- @return boolean
function vim.opt.termbidi:get()end

--- @class vim.opt.termencoding: vim.Option,string
--- @operator add: vim.opt.termencoding
--- @operator sub: vim.opt.termencoding
--- @operator pow: vim.opt.termencoding
vim.opt.termencoding = ""
vim.opt.tenc = vim.opt.termencoding
--- @return string
function vim.opt.termencoding:get()end

-- `'termguicolors'`  `'tgc'` 	boolean (default off)
-- 			global
-- 	Enables 24-bit RGB color in the |TUI|.  Uses "gui" |:highlight|
-- 	attributes instead of "cterm" attributes. |guifg|
-- 	Requires an ISO-8613-3 compatible terminal.
--- @class vim.opt.termguicolors: vim.Option,boolean
--- @operator add: vim.opt.termguicolors
--- @operator sub: vim.opt.termguicolors
--- @operator pow: vim.opt.termguicolors
vim.opt.termguicolors = false
vim.opt.tgc = vim.opt.termguicolors
--- @return boolean
function vim.opt.termguicolors:get()end

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
--- @class vim.opt.termpastefilter: vim.Option,string[]
--- @operator add: vim.opt.termpastefilter
--- @operator sub: vim.opt.termpastefilter
--- @operator pow: vim.opt.termpastefilter
vim.opt.termpastefilter = "BS,HT,ESC,DEL"
vim.opt.tpf = vim.opt.termpastefilter
--- @return string[]
function vim.opt.termpastefilter:get()end

--- @class vim.opt.terse: vim.Option,boolean
--- @operator add: vim.opt.terse
--- @operator sub: vim.opt.terse
--- @operator pow: vim.opt.terse
vim.opt.terse = false
--- @return boolean
function vim.opt.terse:get()end

-- `'textwidth'`  `'tw'` 	number	(default 0)
-- 			local to buffer
-- 	Maximum width of text that is being inserted.  A longer line will be
-- 	broken after white space to get this width.  A zero value disables
-- 	this.
-- 	When `'textwidth'`  is zero, `'wrapmargin'`  may be used.  See also
-- 	`'formatoptions'`  and |ins-textwidth|.
-- 	When `'formatexpr'`  is set it will be used to break the line.
--- @class vim.opt.textwidth: vim.Option,number
--- @operator add: vim.opt.textwidth
--- @operator sub: vim.opt.textwidth
--- @operator pow: vim.opt.textwidth
vim.opt.textwidth = 0
vim.opt.tw = vim.opt.textwidth
--- @return number
function vim.opt.textwidth:get()end

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
--- @class vim.opt.thesaurus: vim.Option,string[]
--- @operator add: vim.opt.thesaurus
--- @operator sub: vim.opt.thesaurus
--- @operator pow: vim.opt.thesaurus
vim.opt.thesaurus = ""
vim.opt.tsr = vim.opt.thesaurus
--- @return string[]
function vim.opt.thesaurus:get()end

-- `'thesaurusfunc'`  `'tsrfu'` 	string	(default: empty)
-- 			global or local to buffer |global-local|
-- 	This option specifies a function to be used for thesaurus completion
-- 	with CTRL-X CTRL-T. |i_CTRL-X_CTRL-T| See |compl-thesaurusfunc|.
-- 	The value can be the name of a function, a |lambda| or a |Funcref|.
-- 	See |option-value-function| for more information.
-- 
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.thesaurusfunc: vim.Option,string
--- @operator add: vim.opt.thesaurusfunc
--- @operator sub: vim.opt.thesaurusfunc
--- @operator pow: vim.opt.thesaurusfunc
vim.opt.thesaurusfunc = ""
vim.opt.tsrfu = vim.opt.thesaurusfunc
--- @return string
function vim.opt.thesaurusfunc:get()end

-- `'tildeop'`  `'top'` 		boolean	(default off)
-- 			global
-- 	When on: The tilde command "~" behaves like an operator.
--- @class vim.opt.tildeop: vim.Option,boolean
--- @operator add: vim.opt.tildeop
--- @operator sub: vim.opt.tildeop
--- @operator pow: vim.opt.tildeop
vim.opt.tildeop = false
vim.opt.top = vim.opt.tildeop
--- @return boolean
function vim.opt.tildeop:get()end

-- `'timeout'`  `'to'` 		boolean (default on)
-- 			global
-- 	This option and `'timeoutlen'`  determine the behavior when part of a
-- 	mapped key sequence has been received. For example, if <c-f> is
-- 	pressed and `'timeout'`  is set, Nvim will wait `'timeoutlen'`  milliseconds
-- 	for any key that can follow <c-f> in a mapping.
--- @class vim.opt.timeout: vim.Option,boolean
--- @operator add: vim.opt.timeout
--- @operator sub: vim.opt.timeout
--- @operator pow: vim.opt.timeout
vim.opt.timeout = true
vim.opt.to = vim.opt.timeout
--- @return boolean
function vim.opt.timeout:get()end

-- `'timeoutlen'`  `'tm'` 	number	(default 1000)
-- 			global
-- 	Time in milliseconds to wait for a mapped sequence to complete.
--- @class vim.opt.timeoutlen: vim.Option,number
--- @operator add: vim.opt.timeoutlen
--- @operator sub: vim.opt.timeoutlen
--- @operator pow: vim.opt.timeoutlen
vim.opt.timeoutlen = 1000
vim.opt.tm = vim.opt.timeoutlen
--- @return number
function vim.opt.timeoutlen:get()end

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
--- @class vim.opt.title: vim.Option,boolean
--- @operator add: vim.opt.title
--- @operator sub: vim.opt.title
--- @operator pow: vim.opt.title
vim.opt.title = false
--- @return boolean
function vim.opt.title:get()end

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
--- @class vim.opt.titlelen: vim.Option,number
--- @operator add: vim.opt.titlelen
--- @operator sub: vim.opt.titlelen
--- @operator pow: vim.opt.titlelen
vim.opt.titlelen = 85
--- @return number
function vim.opt.titlelen:get()end

-- `'titleold'` 		string	(default "")
-- 			global
-- 	If not empty, this option will be used to set the window title when
-- 	exiting.  Only if `'title'`  is enabled.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.titleold: vim.Option,string
--- @operator add: vim.opt.titleold
--- @operator sub: vim.opt.titleold
--- @operator pow: vim.opt.titleold
vim.opt.titleold = ""
--- @return string
function vim.opt.titleold:get()end

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
--- @class vim.opt.titlestring: vim.Option,string
--- @operator add: vim.opt.titlestring
--- @operator sub: vim.opt.titlestring
--- @operator pow: vim.opt.titlestring
vim.opt.titlestring = ""
--- @return string
function vim.opt.titlestring:get()end

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
--- @class vim.opt.ttimeout: vim.Option,boolean
--- @operator add: vim.opt.ttimeout
--- @operator sub: vim.opt.ttimeout
--- @operator pow: vim.opt.ttimeout
vim.opt.ttimeout = true
--- @return boolean
function vim.opt.ttimeout:get()end

-- `'ttimeoutlen'`  `'ttm'` 	number	(default 50)
-- 			global
-- 	Time in milliseconds to wait for a key code sequence to complete. Also
-- 	used for CTRL-\ CTRL-N and CTRL-\ CTRL-G when part of a command has
-- 	been typed.
--- @class vim.opt.ttimeoutlen: vim.Option,number
--- @operator add: vim.opt.ttimeoutlen
--- @operator sub: vim.opt.ttimeoutlen
--- @operator pow: vim.opt.ttimeoutlen
vim.opt.ttimeoutlen = 50
vim.opt.ttm = vim.opt.ttimeoutlen
--- @return number
function vim.opt.ttimeoutlen:get()end

--- @class vim.opt.ttyfast: vim.Option,boolean
--- @operator add: vim.opt.ttyfast
--- @operator sub: vim.opt.ttyfast
--- @operator pow: vim.opt.ttyfast
vim.opt.ttyfast = true
vim.opt.tf = vim.opt.ttyfast
--- @return boolean
function vim.opt.ttyfast:get()end

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
--- @class vim.opt.undodir: vim.Option,string[]
--- @operator add: vim.opt.undodir
--- @operator sub: vim.opt.undodir
--- @operator pow: vim.opt.undodir
vim.opt.undodir = "/home/runner/.local/state/nvim/undo//"
vim.opt.udir = vim.opt.undodir
--- @return string[]
function vim.opt.undodir:get()end

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
--- @class vim.opt.undofile: vim.Option,boolean
--- @operator add: vim.opt.undofile
--- @operator sub: vim.opt.undofile
--- @operator pow: vim.opt.undofile
vim.opt.undofile = false
vim.opt.udf = vim.opt.undofile
--- @return boolean
function vim.opt.undofile:get()end

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
--- @class vim.opt.undolevels: vim.Option,number
--- @operator add: vim.opt.undolevels
--- @operator sub: vim.opt.undolevels
--- @operator pow: vim.opt.undolevels
vim.opt.undolevels = 1000
vim.opt.ul = vim.opt.undolevels
--- @return number
function vim.opt.undolevels:get()end

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
--- @class vim.opt.undoreload: vim.Option,number
--- @operator add: vim.opt.undoreload
--- @operator sub: vim.opt.undoreload
--- @operator pow: vim.opt.undoreload
vim.opt.undoreload = 10000
vim.opt.ur = vim.opt.undoreload
--- @return number
function vim.opt.undoreload:get()end

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
--- @class vim.opt.updatecount: vim.Option,number
--- @operator add: vim.opt.updatecount
--- @operator sub: vim.opt.updatecount
--- @operator pow: vim.opt.updatecount
vim.opt.updatecount = 200
vim.opt.uc = vim.opt.updatecount
--- @return number
function vim.opt.updatecount:get()end

-- `'updatetime'`  `'ut'` 	number	(default 4000)
-- 			global
-- 	If this many milliseconds nothing is typed the swap file will be
-- 	written to disk (see |crash-recovery|).  Also used for the
-- 	|CursorHold| autocommand event.
--- @class vim.opt.updatetime: vim.Option,number
--- @operator add: vim.opt.updatetime
--- @operator sub: vim.opt.updatetime
--- @operator pow: vim.opt.updatetime
vim.opt.updatetime = 4000
vim.opt.ut = vim.opt.updatetime
--- @return number
function vim.opt.updatetime:get()end

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
--- @class vim.opt.varsofttabstop: vim.Option,string[]
--- @operator add: vim.opt.varsofttabstop
--- @operator sub: vim.opt.varsofttabstop
--- @operator pow: vim.opt.varsofttabstop
vim.opt.varsofttabstop = ""
vim.opt.vsts = vim.opt.varsofttabstop
--- @return string[]
function vim.opt.varsofttabstop:get()end

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
--- @class vim.opt.vartabstop: vim.Option,string[]
--- @operator add: vim.opt.vartabstop
--- @operator sub: vim.opt.vartabstop
--- @operator pow: vim.opt.vartabstop
vim.opt.vartabstop = ""
vim.opt.vts = vim.opt.vartabstop
--- @return string[]
function vim.opt.vartabstop:get()end

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
--- @class vim.opt.verbose: vim.Option,number
--- @operator add: vim.opt.verbose
--- @operator sub: vim.opt.verbose
--- @operator pow: vim.opt.verbose
vim.opt.verbose = 0
vim.opt.vbs = vim.opt.verbose
--- @return number
function vim.opt.verbose:get()end

-- `'verbosefile'`  `'vfile'` 	string	(default empty)
-- 			global
-- 	When not empty all messages are written in a file with this name.
-- 	When the file exists messages are appended.
-- 	Writing to the file ends when Vim exits or when `'verbosefile'`  is made
-- 	empty.  Writes are buffered, thus may not show up for some time.
-- 	Setting `'verbosefile'`  to a new value is like making it empty first.
-- 	The difference with |:redir| is that verbose messages are not
-- 	displayed when `'verbosefile'`  is set.
--- @class vim.opt.verbosefile: vim.Option,string
--- @operator add: vim.opt.verbosefile
--- @operator sub: vim.opt.verbosefile
--- @operator pow: vim.opt.verbosefile
vim.opt.verbosefile = ""
vim.opt.vfile = vim.opt.verbosefile
--- @return string
function vim.opt.verbosefile:get()end

-- `'viewdir'`  `'vdir'` 	string	(default: "$XDG_STATE_HOME/nvim/view//")
-- 			global
-- 	Name of the directory where to store files for |:mkview|.
-- 	This option cannot be set from a |modeline| or in the |sandbox|, for
-- 	security reasons.
--- @class vim.opt.viewdir: vim.Option,string
--- @operator add: vim.opt.viewdir
--- @operator sub: vim.opt.viewdir
--- @operator pow: vim.opt.viewdir
vim.opt.viewdir = "/home/runner/.local/state/nvim/view//"
vim.opt.vdir = vim.opt.viewdir
--- @return string
function vim.opt.viewdir:get()end

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
--- @class vim.opt.viewoptions: vim.Option,string[]
--- @operator add: vim.opt.viewoptions
--- @operator sub: vim.opt.viewoptions
--- @operator pow: vim.opt.viewoptions
vim.opt.viewoptions = "folds,cursor,curdir"
vim.opt.vop = vim.opt.viewoptions
--- @return string[]
function vim.opt.viewoptions:get()end

--- @class vim.opt.viminfo: vim.Option,string[]
--- @operator add: vim.opt.viminfo
--- @operator sub: vim.opt.viminfo
--- @operator pow: vim.opt.viminfo
vim.opt.viminfo = ""
vim.opt.vi = vim.opt.viminfo
--- @return string[]
function vim.opt.viminfo:get()end

--- @class vim.opt.viminfofile: vim.Option,string[]
--- @operator add: vim.opt.viminfofile
--- @operator sub: vim.opt.viminfofile
--- @operator pow: vim.opt.viminfofile
vim.opt.viminfofile = ""
vim.opt.vif = vim.opt.viminfofile
--- @return string[]
function vim.opt.viminfofile:get()end

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
--- @class vim.opt.virtualedit: vim.Option,string[]
--- @operator add: vim.opt.virtualedit
--- @operator sub: vim.opt.virtualedit
--- @operator pow: vim.opt.virtualedit
vim.opt.virtualedit = ""
vim.opt.ve = vim.opt.virtualedit
--- @return string[]
function vim.opt.virtualedit:get()end

-- `'visualbell'`  `'vb'` 	boolean	(default off)
-- 			global
-- 	Use visual bell instead of beeping.  Also see `'errorbells'` .
--- @class vim.opt.visualbell: vim.Option,boolean
--- @operator add: vim.opt.visualbell
--- @operator sub: vim.opt.visualbell
--- @operator pow: vim.opt.visualbell
vim.opt.visualbell = false
vim.opt.vb = vim.opt.visualbell
--- @return boolean
function vim.opt.visualbell:get()end

-- `'warn'` 			boolean	(default on)
-- 			global
-- 	Give a warning message when a shell command is used while the buffer
-- 	has been changed.
--- @class vim.opt.warn: vim.Option,boolean
--- @operator add: vim.opt.warn
--- @operator sub: vim.opt.warn
--- @operator pow: vim.opt.warn
vim.opt.warn = true
--- @return boolean
function vim.opt.warn:get()end

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
--- @class vim.opt.whichwrap: vim.Option,string[]
--- @operator add: vim.opt.whichwrap
--- @operator sub: vim.opt.whichwrap
--- @operator pow: vim.opt.whichwrap
vim.opt.whichwrap = "b,s"
vim.opt.ww = vim.opt.whichwrap
--- @return string[]
function vim.opt.whichwrap:get()end

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
--- @class vim.opt.wildchar: vim.Option,number
--- @operator add: vim.opt.wildchar
--- @operator sub: vim.opt.wildchar
--- @operator pow: vim.opt.wildchar
vim.opt.wildchar = 9
vim.opt.wc = vim.opt.wildchar
--- @return number
function vim.opt.wildchar:get()end

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
--- @class vim.opt.wildcharm: vim.Option,number
--- @operator add: vim.opt.wildcharm
--- @operator sub: vim.opt.wildcharm
--- @operator pow: vim.opt.wildcharm
vim.opt.wildcharm = 0
vim.opt.wcm = vim.opt.wildcharm
--- @return number
function vim.opt.wildcharm:get()end

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
--- @class vim.opt.wildignore: vim.Option,string[]
--- @operator add: vim.opt.wildignore
--- @operator sub: vim.opt.wildignore
--- @operator pow: vim.opt.wildignore
vim.opt.wildignore = ""
vim.opt.wig = vim.opt.wildignore
--- @return string[]
function vim.opt.wildignore:get()end

-- `'wildignorecase'`  `'wic'` 	boolean	(default off)
-- 			global
-- 	When set case is ignored when completing file names and directories.
-- 	Has no effect when `'fileignorecase'`  is set.
-- 	Does not apply when the shell is used to expand wildcards, which
-- 	happens when there are special characters.
--- @class vim.opt.wildignorecase: vim.Option,boolean
--- @operator add: vim.opt.wildignorecase
--- @operator sub: vim.opt.wildignorecase
--- @operator pow: vim.opt.wildignorecase
vim.opt.wildignorecase = false
vim.opt.wic = vim.opt.wildignorecase
--- @return boolean
function vim.opt.wildignorecase:get()end

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
--- @class vim.opt.wildmenu: vim.Option,boolean
--- @operator add: vim.opt.wildmenu
--- @operator sub: vim.opt.wildmenu
--- @operator pow: vim.opt.wildmenu
vim.opt.wildmenu = true
vim.opt.wmnu = vim.opt.wildmenu
--- @return boolean
function vim.opt.wildmenu:get()end

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
--- @class vim.opt.wildmode: vim.Option,string[]
--- @operator add: vim.opt.wildmode
--- @operator sub: vim.opt.wildmode
--- @operator pow: vim.opt.wildmode
vim.opt.wildmode = "full"
vim.opt.wim = vim.opt.wildmode
--- @return string[]
function vim.opt.wildmode:get()end

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
--- @class vim.opt.wildoptions: vim.Option,string[]
--- @operator add: vim.opt.wildoptions
--- @operator sub: vim.opt.wildoptions
--- @operator pow: vim.opt.wildoptions
vim.opt.wildoptions = "pum,tagfile"
vim.opt.wop = vim.opt.wildoptions
--- @return string[]
function vim.opt.wildoptions:get()end

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
--- @class vim.opt.winaltkeys: vim.Option,string
--- @operator add: vim.opt.winaltkeys
--- @operator sub: vim.opt.winaltkeys
--- @operator pow: vim.opt.winaltkeys
vim.opt.winaltkeys = "menu"
vim.opt.wak = vim.opt.winaltkeys
--- @return string
function vim.opt.winaltkeys:get()end

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
--- @class vim.opt.winbar: vim.Option,string
--- @operator add: vim.opt.winbar
--- @operator sub: vim.opt.winbar
--- @operator pow: vim.opt.winbar
vim.opt.winbar = ""
vim.opt.wbr = vim.opt.winbar
--- @return string
function vim.opt.winbar:get()end

-- `'winblend'`  `'winbl'` 		number	(default 0)
-- 			local to window
-- 	Enables pseudo-transparency for a floating window. Valid values are in
-- 	the range of 0 for fully opaque window (disabled) to 100 for fully
-- 	transparent background. Values between 0-30 are typically most useful.
-- 
-- 	UI-dependent. Works best with RGB colors. `'termguicolors'` 
--- @class vim.opt.winblend: vim.Option,number
--- @operator add: vim.opt.winblend
--- @operator sub: vim.opt.winblend
--- @operator pow: vim.opt.winblend
vim.opt.winblend = 0
vim.opt.winbl = vim.opt.winblend
--- @return number
function vim.opt.winblend:get()end

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
--- @class vim.opt.window: vim.Option,number
--- @operator add: vim.opt.window
--- @operator sub: vim.opt.window
--- @operator pow: vim.opt.window
vim.opt.window = 23
vim.opt.wi = vim.opt.window
--- @return number
function vim.opt.window:get()end

-- `'winfixheight'`  `'wfh'` 	boolean	(default off)
-- 			local to window
-- 	Keep the window height when windows are opened or closed and
-- 	`'equalalways'`  is set.  Also for |CTRL-W_=|.  Set by default for the
-- 	|preview-window| and |quickfix-window|.
-- 	The height may be changed anyway when running out of room.
--- @class vim.opt.winfixheight: vim.Option,boolean
--- @operator add: vim.opt.winfixheight
--- @operator sub: vim.opt.winfixheight
--- @operator pow: vim.opt.winfixheight
vim.opt.winfixheight = false
vim.opt.wfh = vim.opt.winfixheight
--- @return boolean
function vim.opt.winfixheight:get()end

-- `'winfixwidth'`  `'wfw'` 	boolean	(default off)
-- 			local to window
-- 	Keep the window width when windows are opened or closed and
-- 	`'equalalways'`  is set.  Also for |CTRL-W_=|.
-- 	The width may be changed anyway when running out of room.
--- @class vim.opt.winfixwidth: vim.Option,boolean
--- @operator add: vim.opt.winfixwidth
--- @operator sub: vim.opt.winfixwidth
--- @operator pow: vim.opt.winfixwidth
vim.opt.winfixwidth = false
vim.opt.wfw = vim.opt.winfixwidth
--- @return boolean
function vim.opt.winfixwidth:get()end

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
--- @class vim.opt.winheight: vim.Option,number
--- @operator add: vim.opt.winheight
--- @operator sub: vim.opt.winheight
--- @operator pow: vim.opt.winheight
vim.opt.winheight = 1
vim.opt.wh = vim.opt.winheight
--- @return number
function vim.opt.winheight:get()end

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
--- @class vim.opt.winhighlight: vim.Option,table<string, string>
--- @operator add: vim.opt.winhighlight
--- @operator sub: vim.opt.winhighlight
--- @operator pow: vim.opt.winhighlight
vim.opt.winhighlight = ""
vim.opt.winhl = vim.opt.winhighlight
--- @return table<string, string>
function vim.opt.winhighlight:get()end

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
--- @class vim.opt.winminheight: vim.Option,number
--- @operator add: vim.opt.winminheight
--- @operator sub: vim.opt.winminheight
--- @operator pow: vim.opt.winminheight
vim.opt.winminheight = 1
vim.opt.wmh = vim.opt.winminheight
--- @return number
function vim.opt.winminheight:get()end

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
--- @class vim.opt.winminwidth: vim.Option,number
--- @operator add: vim.opt.winminwidth
--- @operator sub: vim.opt.winminwidth
--- @operator pow: vim.opt.winminwidth
vim.opt.winminwidth = 1
vim.opt.wmw = vim.opt.winminwidth
--- @return number
function vim.opt.winminwidth:get()end

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
--- @class vim.opt.winwidth: vim.Option,number
--- @operator add: vim.opt.winwidth
--- @operator sub: vim.opt.winwidth
--- @operator pow: vim.opt.winwidth
vim.opt.winwidth = 20
vim.opt.wiw = vim.opt.winwidth
--- @return number
function vim.opt.winwidth:get()end

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
--- @class vim.opt.wrap: vim.Option,boolean
--- @operator add: vim.opt.wrap
--- @operator sub: vim.opt.wrap
--- @operator pow: vim.opt.wrap
vim.opt.wrap = true
--- @return boolean
function vim.opt.wrap:get()end

-- `'wrapmargin'`  `'wm'` 	number	(default 0)
-- 			local to buffer
-- 	Number of characters from the right window border where wrapping
-- 	starts.  When typing text beyond this limit, an <EOL> will be inserted
-- 	and inserting continues on the next line.
-- 	Options that add a margin, such as `'number'`  and `'foldcolumn'` , cause
-- 	the text width to be further reduced.
-- 	When `'textwidth'`  is non-zero, this option is not used.
-- 	See also `'formatoptions'`  and |ins-textwidth|.
--- @class vim.opt.wrapmargin: vim.Option,number
--- @operator add: vim.opt.wrapmargin
--- @operator sub: vim.opt.wrapmargin
--- @operator pow: vim.opt.wrapmargin
vim.opt.wrapmargin = 0
vim.opt.wm = vim.opt.wrapmargin
--- @return number
function vim.opt.wrapmargin:get()end

-- `'wrapscan'`  `'ws'` 		boolean	(default on)
-- 			global
-- 	Searches wrap around the end of the file.  Also applies to |]s| and
-- 	|[s|, searching for spelling mistakes.
--- @class vim.opt.wrapscan: vim.Option,boolean
--- @operator add: vim.opt.wrapscan
--- @operator sub: vim.opt.wrapscan
--- @operator pow: vim.opt.wrapscan
vim.opt.wrapscan = true
vim.opt.ws = vim.opt.wrapscan
--- @return boolean
function vim.opt.wrapscan:get()end

-- `'write'` 			boolean	(default on)
-- 			global
-- 	Allows writing files.  When not set, writing a file is not allowed.
-- 	Can be used for a view-only mode, where modifications to the text are
-- 	still allowed.  Can be reset with the |-m| or |-M| command line
-- 	argument.  Filtering text is still possible, even though this requires
-- 	writing a temporary file.
--- @class vim.opt.write: vim.Option,boolean
--- @operator add: vim.opt.write
--- @operator sub: vim.opt.write
--- @operator pow: vim.opt.write
vim.opt.write = true
--- @return boolean
function vim.opt.write:get()end

-- `'writeany'`  `'wa'` 		boolean	(default off)
-- 			global
-- 	Allows writing to any file with no need for "!" override.
--- @class vim.opt.writeany: vim.Option,boolean
--- @operator add: vim.opt.writeany
--- @operator sub: vim.opt.writeany
--- @operator pow: vim.opt.writeany
vim.opt.writeany = false
vim.opt.wa = vim.opt.writeany
--- @return boolean
function vim.opt.writeany:get()end

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
--- @class vim.opt.writebackup: vim.Option,boolean
--- @operator add: vim.opt.writebackup
--- @operator sub: vim.opt.writebackup
--- @operator pow: vim.opt.writebackup
vim.opt.writebackup = true
vim.opt.wb = vim.opt.writebackup
--- @return boolean
function vim.opt.writebackup:get()end

--- @class vim.opt.writedelay: vim.Option,number
--- @operator add: vim.opt.writedelay
--- @operator sub: vim.opt.writedelay
--- @operator pow: vim.opt.writedelay
vim.opt.writedelay = 0
vim.opt.wd = vim.opt.writedelay
--- @return number
function vim.opt.writedelay:get()end

---@type table<number, vim.go>
vim.go = {}

---@type table<number, vim.bo>
vim.bo = {}

---@type table<number, vim.wo>
vim.wo = {}

---@type vim.go | vim.wo | vim.bo
vim.o = {}

---@class vim.opt
vim.opt = {}

---@type vim.opt
vim.opt_global = {}

---@type vim.opt
vim.opt_local = {}

---@class vim.Option
local Option = {}

function Option:append(right) end
function Option:prepend(right) end
function Option:remove(right) end

