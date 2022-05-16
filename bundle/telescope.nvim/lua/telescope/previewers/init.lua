---@tag telescope.previewers
---@config { ["module"] = "telescope.previewers" }

---@brief [[
--- Provides a Previewer table that has to be implemented by each previewer.
--- To achieve this, this module also provides two wrappers that abstract most
--- of the work and make it really easy create new previewers.
---   - `previewers.new_termopen_previewer`
---   - `previewers.new_buffer_previewer`
---
--- Furthermore, there are a collection of previewers already defined which
--- can be used for every picker, as long as the entries of the picker provide
--- the necessary fields. The more important ones are
---   - `previewers.cat`
---   - `previewers.vimgrep`
---   - `previewers.qflist`
---   - `previewers.vim_buffer_cat`
---   - `previewers.vim_buffer_vimgrep`
---   - `previewers.vim_buffer_qflist`
---
--- Previewers can be disabled for any builtin or custom picker by doing
---   :Telescope find_files previewer=false
---@brief ]]

local Previewer = require "telescope.previewers.previewer"
local term_previewer = require "telescope.previewers.term_previewer"
local buffer_previewer = require "telescope.previewers.buffer_previewer"

local previewers = {}

--- This is the base table all previewers have to implement. It's possible to
--- write a wrapper for this because most previewers need to have the same
--- keys set.
--- Examples of wrappers are:
---   - `new_buffer_previewer`
---   - `new_termopen_previewer`
---
--- To create a new table do following:
---   - `local new_previewer = Previewer:new(opts)`
---
--- What `:new` expects is listed below
---
--- The interface provides following set of functions. All of them, besides
--- `new`, will be handled by telescope pickers.
--- - `:new(opts)`
--- - `:preview(entry, status)`
--- - `:teardown()`
--- - `:send_input(input)`
--- - `:scroll_fn(direction)`
---
--- `Previewer:new()` expects a table as input with following keys:
---   - `setup` function(self): Will be called the first time preview will be
---                           called.
---   - `teardown` function(self): Will be called on cleanup.
---   - `preview_fn` function(self, entry, status): Will be called each time
---                                                 a new entry was selected.
---   - `title` function(self): Will return the static title of the previewer.
---   - `dynamic_title` function(self, entry): Will return the dynamic title of
---                                            the previewer. Will only be called
---                                            when config value dynamic_preview_title
---                                            is true.
---   - `send_input` function(self, input): This is meant for
---                                         `termopen_previewer` and it can be
---                                         used to send input to the terminal
---                                         application, like less.
---   - `scroll_fn` function(self, direction): Used to make scrolling work.
previewers.Previewer = Previewer

--- A shorthand for creating a new Previewer.
--- The provided table will be forwarded to `Previewer:new(...)`
previewers.new = function(...)
  return Previewer:new(...)
end

--- Is a wrapper around Previewer and helps with creating a new
--- `termopen_previewer`.
---
--- It requires you to specify one table entry `get_command(entry, status)`.
--- This `get_command` function has to return the terminal command that will be
--- executed for each entry. Example:
--- <code>
---   get_command = function(entry, status)
---     return { 'bat', entry.path }
---   end
--- </code>
---
--- Additionally you can define:
--- - `title` a static title for example "File Preview"
--- - `dyn_title(self, entry)` a dynamic title function which gets called
--- when config value `dynamic_preview_title = true`
---
--- It's an easy way to get your first previewer going and it integrates well
--- with `bat` and `less`. Providing out of the box scrolling if the command
--- uses less.
---
--- Furthermore, it will forward all `config.set_env` environment variables to
--- that terminal process.
previewers.new_termopen_previewer = term_previewer.new_termopen_previewer

--- Provides a `termopen_previewer` which has the ability to display files.
--- It will always show the top of the file and has support for
--- `bat`(prioritized) and `cat`. Each entry has to provide either the field
--- `path` or `filename` in order to make this previewer work.
---
--- The preferred way of using this previewer is like this
--- `require('telescope.config').values.cat_previewer`
--- This will respect user configuration and will use `buffer_previewers` in
--- case it's configured that way.
previewers.cat = term_previewer.cat

--- Provides a `termopen_previewer` which has the ability to display files at
--- the provided line. It has support for `bat`(prioritized) and `cat`.
--- Each entry has to provide either the field `path` or `filename` and
--- a `lnum` field in order to make this previewer work.
---
--- The preferred way of using this previewer is like this
--- `require('telescope.config').values.grep_previewer`
--- This will respect user configuration and will use `buffer_previewers` in
--- case it's configured that way.
previewers.vimgrep = term_previewer.vimgrep

--- Provides a `termopen_previewer` which has the ability to display files at
--- the provided line or range. It has support for `bat`(prioritized) and
--- `cat`. Each entry has to provide either the field `path` or `filename`,
--- `lnum` and a `start` and `finish` range in order to make this previewer
--- work.
---
--- The preferred way of using this previewer is like this
--- `require('telescope.config').values.qflist_previewer`
--- This will respect user configuration and will use buffer previewers in
--- case it's configured that way.
previewers.qflist = term_previewer.qflist

--- An interface to instantiate a new `buffer_previewer`.
--- That means that the content actually lives inside a vim buffer which
--- enables us more control over the actual content. For example, we can
--- use `vim.fn.search` to jump to a specific line or reuse buffers/already
--- opened files more easily.
--- This interface is more complex than `termopen_previewer` but offers more
--- flexibility over your content.
--- It was designed to display files but was extended to also display the
--- output of terminal commands.
---
--- In the following options, state table and general tips are mentioned to
--- make your experience with this previewer more seamless.
---
---
--- options:
---   - `define_preview = function(self, entry, status)` (required)
---     Is called for each selected entry, after each selection_move
---     (up or down) and is meant to handle things like reading file,
---     jump to line or attach a highlighter.
---   - `setup = function(self)` (optional)
---     Is called once at the beginning, before the preview for the first
---     entry is displayed. You can return a table of vars that will be
---     available in `self.state` in each `define_preview` call.
---   - `teardown = function(self)` (optional)
---     Will be called at the end, when the picker is being closed and is
---     meant to cleanup everything that was allocated by the previewer.
---     The `buffer_previewer` will automatically cleanup all created buffers.
---     So you only need to handle things that were introduced by you.
---   - `keep_last_buf = true` (optional)
---     Will not delete the last selected buffer. This would allow you to
---     reuse that buffer in the select action. For example, that buffer can
---     be opened in a new split, rather than recreating that buffer in
---     an action. To access the last buffer number:
---     `require('telescope.state').get_global_key("last_preview_bufnr")`
---   - `get_buffer_by_name = function(self, entry)`
---     Allows you to set a unique name for each buffer. This is used for
---     caching purpose. `self.state.bufname` will be nil if the entry was
---     never loaded or the unique name when it was loaded once. For example,
---     useful if you have one file but multiple entries. This happens for grep
---     and lsp builtins. So to make the cache work only load content if
---     `self.state.bufname ~= entry.your_unique_key`
---   - `title` a static title for example "File Preview"
---   - `dyn_title(self, entry)` a dynamic title function which gets called
---     when config value `dynamic_preview_title = true`
---
--- `self.state` table:
---   - `self.state.bufnr`
---     Is the current buffer number, in which you have to write the loaded
---     content.
---     Don't create a buffer yourself, otherwise it's not managed by the
---     buffer_previewer interface and you will probably be better off
---     writing your own interface.
---   - self.state.winid
---     Current window id. Useful if you want to set the cursor to a provided
---     line number.
---   - self.state.bufname
---     Will return the current buffer name, if `get_buffer_by_name` is
---     defined. nil will be returned if the entry was never loaded or when
---     `get_buffer_by_name` is not set.
---
--- Tips:
---   - If you want to display content of a terminal job, use:
---     `require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)`
---       - `cmd` table: for example { 'git', 'diff', entry.value }
---       - `bufnr` number: in which the content will be written
---       - `opts` table: with following keys
---         - `bufname` string: used for cache
---         - `value` string: used for cache
---         - `mode` string: either "insert" or "append". "insert" is default
---         - `env` table: define environment variables. Example:
---           - `{ ['PAGER'] = '', ['MANWIDTH'] = 50 }`
---         - `cwd` string: define current working directory for job
---         - `callback` function(bufnr, content): will be called when job
---           is done. Content will be nil if job is already loaded.
---           So you can do highlighting only the first time the previewer
---           is created for that entry.
---           Use the returned `bufnr` and not `self.state.bufnr` in callback,
---           because state can already be changed at this point in time.
---   - If you want to attach a highlighter use:
---     - `require('telescope.previewers.utils').highlighter(bufnr, ft)`
---       - This will prioritize tree sitter highlighting if available for
---         environment and language.
---     - `require('telescope.previewers.utils').regex_highlighter(bufnr, ft)`
---     - `require('telescope.previewers.utils').ts_highlighter(bufnr, ft)`
---   - If you want to use `vim.fn.search` or similar you need to run it in
---     that specific buffer context. Do
--- <code>
---       vim.api.nvim_buf_call(bufnr, function()
---         -- for example `search` and `matchadd`
---       end)
---     to achieve that.
--- </code>
---   - If you want to read a file into the buffer it's best to use
---     `buffer_previewer_maker`. But access this function with
---     `require('telescope.config').values.buffer_previewer_maker`
---     because it can be redefined by users.
previewers.new_buffer_previewer = buffer_previewer.new_buffer_previewer

--- A universal way of reading a file into a buffer previewer.
--- It handles async reading, cache, highlighting, displaying directories
--- and provides a callback which can be used, to jump to a line in the buffer.
---@param filepath string: String to the filepath, will be expanded
---@param bufnr number: Where the content will be written
---@param opts table: keys: `use_ft_detect`, `bufname` and `callback`
previewers.buffer_previewer_maker = buffer_previewer.file_maker

--- A previewer that is used to display a file. It uses the `buffer_previewer`
--- interface and won't jump to the line. To integrate this one into your
--- own picker make sure that the field `path` or `filename` is set for
--- each entry.
--- The preferred way of using this previewer is like this
--- `require('telescope.config').values.file_previewer`
--- This will respect user configuration and will use `termopen_previewer` in
--- case it's configured that way.
previewers.vim_buffer_cat = buffer_previewer.cat

--- A previewer that is used to display a file and jump to the provided line.
--- It uses the `buffer_previewer` interface. To integrate this one into your
--- own picker make sure that the field `path` or `filename` and `lnum` is set
--- in each entry. If the latter is not present, it will default to the first
--- line.
--- The preferred way of using this previewer is like this
--- `require('telescope.config').values.grep_previewer`
--- This will respect user configuration and will use `termopen_previewer` in
--- case it's configured that way.
previewers.vim_buffer_vimgrep = buffer_previewer.vimgrep

--- Is the same as `vim_buffer_vimgrep` and only exist for consistency with
--- `term_previewers`.
---
--- The preferred way of using this previewer is like this
--- `require('telescope.config').values.qflist_previewer`
--- This will respect user configuration and will use `termopen_previewer` in
--- case it's configured that way.
previewers.vim_buffer_qflist = buffer_previewer.qflist

--- A previewer that shows a log of a branch as graph
previewers.git_branch_log = buffer_previewer.git_branch_log

--- A previewer that shows a diff of a stash
previewers.git_stash_diff = buffer_previewer.git_stash_diff

--- A previewer that shows a diff of a commit to a parent commit.<br>
--- The run command is `git --no-pager diff SHA^! -- $CURRENT_FILE`
---
--- The current file part is optional. So is only uses it with bcommits.
previewers.git_commit_diff_to_parent = buffer_previewer.git_commit_diff_to_parent

--- A previewer that shows a diff of a commit to head.<br>
--- The run command is `git --no-pager diff --cached $SHA -- $CURRENT_FILE`
---
--- The current file part is optional. So is only uses it with bcommits.
previewers.git_commit_diff_to_head = buffer_previewer.git_commit_diff_to_head

--- A previewer that shows a diff of a commit as it was.<br>
--- The run command is `git --no-pager show $SHA:$CURRENT_FILE` or `git --no-pager show $SHA`
previewers.git_commit_diff_as_was = buffer_previewer.git_commit_diff_as_was

--- A previewer that shows the commit message of a diff.<br>
--- The run command is `git --no-pager log -n 1 $SHA`
previewers.git_commit_message = buffer_previewer.git_commit_message

--- A previewer that shows the current diff of a file. Used in git_status.<br>
--- The run command is `git --no-pager diff $FILE`
previewers.git_file_diff = buffer_previewer.git_file_diff

previewers.ctags = buffer_previewer.ctags
previewers.builtin = buffer_previewer.builtin
previewers.help = buffer_previewer.help
previewers.man = buffer_previewer.man
previewers.autocommands = buffer_previewer.autocommands
previewers.highlights = buffer_previewer.highlights
previewers.pickers = buffer_previewer.pickers

--- A deprecated way of displaying content more easily. Was written at a time,
--- where the buffer_previewer interface wasn't present. Nowadays it's easier
--- to just use this. We will keep it around for backwards compatibility
--- because some extensions use it.
--- It doesn't use cache or some other clever tricks.
previewers.display_content = buffer_previewer.display_content

return previewers
