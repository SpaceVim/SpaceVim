---@meta

-- append text
function vim.cmd.a(...)end

-- enter abbreviation
function vim.cmd.ab(...)end

-- enter abbreviation
function vim.cmd.abbreviate(...)end

-- remove all abbreviations
function vim.cmd.abc(...)end

-- remove all abbreviations
function vim.cmd.abclear(...)end

-- make split window appear left or above
function vim.cmd.abo(...)end

-- make split window appear left or above
function vim.cmd.aboveleft(...)end

-- open a window for each file in the argument
function vim.cmd.al(...)end

-- open a window for each file in the argument
function vim.cmd.all(...)end

-- enter new menu item for all modes
function vim.cmd.am(...)end

-- enter new menu item for all modes
function vim.cmd.amenu(...)end

-- enter a new menu for all modes that will not
function vim.cmd.an(...)end

-- enter a new menu for all modes that will not
function vim.cmd.anoremenu(...)end

-- append text
function vim.cmd.append(...)end

-- print the argument list
function vim.cmd.ar(...)end

-- add items to the argument list
function vim.cmd.arga(...)end

-- add items to the argument list
function vim.cmd.argadd(...)end

-- delete items from the argument list
function vim.cmd.argd(...)end

-- remove duplicates from the argument list
function vim.cmd.argded(...)end

-- remove duplicates from the argument list
function vim.cmd.argdedupe(...)end

-- delete items from the argument list
function vim.cmd.argdelete(...)end

-- do a command on all items in the argument list
function vim.cmd.argdo(...)end

-- add item to the argument list and edit it
function vim.cmd.arge(...)end

-- add item to the argument list and edit it
function vim.cmd.argedit(...)end

-- define the global argument list
function vim.cmd.argg(...)end

-- define the global argument list
function vim.cmd.argglobal(...)end

-- define a local argument list
function vim.cmd.argl(...)end

-- define a local argument list
function vim.cmd.arglocal(...)end

-- print the argument list
function vim.cmd.args(...)end

-- go to specific file in the argument list
function vim.cmd.argu(...)end

-- go to specific file in the argument list
function vim.cmd.argument(...)end

-- print ascii value of character under the cursor
function vim.cmd.as(...)end

-- print ascii value of character under the cursor
function vim.cmd.ascii(...)end

-- enter or show autocommands
function vim.cmd.au(...)end

-- select the autocommand group to use
function vim.cmd.aug(...)end

-- select the autocommand group to use
function vim.cmd.augroup(...)end

-- remove menu for all modes
function vim.cmd.aun(...)end

-- remove menu for all modes
function vim.cmd.aunmenu(...)end

-- enter or show autocommands
function vim.cmd.autocmd(...)end

-- go to specific buffer in the buffer list
function vim.cmd.b(...)end

-- go to previous buffer in the buffer list
function vim.cmd.bN(...)end

-- go to previous buffer in the buffer list
function vim.cmd.bNext(...)end

-- open a window for each buffer in the buffer list
function vim.cmd.ba(...)end

-- add buffer to the buffer list
function vim.cmd.bad(...)end

-- add buffer to the buffer list
function vim.cmd.badd(...)end

-- open a window for each buffer in the buffer list
function vim.cmd.ball(...)end

-- like ":badd" but also set the alternate file
function vim.cmd.balt(...)end

-- remove a buffer from the buffer list
function vim.cmd.bd(...)end

-- remove a buffer from the buffer list
function vim.cmd.bdelete(...)end

-- set mouse and selection behavior
function vim.cmd.be(...)end

-- set mouse and selection behavior
function vim.cmd.behave(...)end

-- make split window appear right or below
function vim.cmd.bel(...)end

-- make split window appear right or below
function vim.cmd.belowright(...)end

-- go to first buffer in the buffer list
function vim.cmd.bf(...)end

-- go to first buffer in the buffer list
function vim.cmd.bfirst(...)end

-- go to last buffer in the buffer list
function vim.cmd.bl(...)end

-- go to last buffer in the buffer list
function vim.cmd.blast(...)end

-- go to next buffer in the buffer list that has
function vim.cmd.bm(...)end

-- go to next buffer in the buffer list that has
function vim.cmd.bmodified(...)end

-- go to next buffer in the buffer list
function vim.cmd.bn(...)end

-- go to next buffer in the buffer list
function vim.cmd.bnext(...)end

-- make split window appear at bottom or far right
function vim.cmd.bo(...)end

-- make split window appear at bottom or far right
function vim.cmd.botright(...)end

-- go to previous buffer in the buffer list
function vim.cmd.bp(...)end

-- go to previous buffer in the buffer list
function vim.cmd.bprevious(...)end

-- go to first buffer in the buffer list
function vim.cmd.br(...)end

-- break out of while loop
function vim.cmd.brea(...)end

-- break out of while loop
vim.cmd["break"] = function(...)end

-- add a debugger breakpoint
function vim.cmd.breaka(...)end

-- add a debugger breakpoint
function vim.cmd.breakadd(...)end

-- delete a debugger breakpoint
function vim.cmd.breakd(...)end

-- delete a debugger breakpoint
function vim.cmd.breakdel(...)end

-- list debugger breakpoints
function vim.cmd.breakl(...)end

-- list debugger breakpoints
function vim.cmd.breaklist(...)end

-- go to first buffer in the buffer list
function vim.cmd.brewind(...)end

-- use file selection dialog
function vim.cmd.bro(...)end

-- use file selection dialog
function vim.cmd.browse(...)end

-- execute command in each listed buffer
function vim.cmd.bufdo(...)end

-- go to specific buffer in the buffer list
function vim.cmd.buffer(...)end

-- list all files in the buffer list
function vim.cmd.buffers(...)end

-- unload a specific buffer
function vim.cmd.bun(...)end

-- unload a specific buffer
function vim.cmd.bunload(...)end

-- really delete a buffer
function vim.cmd.bw(...)end

-- really delete a buffer
function vim.cmd.bwipeout(...)end

-- replace a line or series of lines
function vim.cmd.c(...)end

-- go to previous error
function vim.cmd.cN(...)end

-- go to previous error
function vim.cmd.cNext(...)end

-- go to last error in previous file
function vim.cmd.cNf(...)end

-- go to last error in previous file
function vim.cmd.cNfile(...)end

-- like ":abbreviate" but for Command-line mode
function vim.cmd.ca(...)end

-- like ":abbreviate" but for Command-line mode
function vim.cmd.cabbrev(...)end

-- clear all abbreviations for Command-line mode
function vim.cmd.cabc(...)end

-- clear all abbreviations for Command-line mode
function vim.cmd.cabclear(...)end

-- go to error above current line
function vim.cmd.cabo(...)end

-- go to error above current line
function vim.cmd.cabove(...)end

-- add errors from buffer
function vim.cmd.cad(...)end

-- add errors from buffer
function vim.cmd.caddbuffer(...)end

-- add errors from expr
function vim.cmd.cadde(...)end

-- add errors from expr
function vim.cmd.caddexpr(...)end

-- add error message to current quickfix list
function vim.cmd.caddf(...)end

-- add error message to current quickfix list
function vim.cmd.caddfile(...)end

-- go to error after current cursor
function vim.cmd.caf(...)end

-- go to error after current cursor
function vim.cmd.cafter(...)end

-- call a function
function vim.cmd.cal(...)end

-- call a function
function vim.cmd.call(...)end

-- part of a :try command
function vim.cmd.cat(...)end

-- part of a :try command
function vim.cmd.catch(...)end

-- parse error messages and jump to first error
function vim.cmd.cb(...)end

-- go to error before current cursor
function vim.cmd.cbef(...)end

-- go to error before current cursor
function vim.cmd.cbefore(...)end

-- go to error below current line
function vim.cmd.cbel(...)end

-- go to error below current line
function vim.cmd.cbelow(...)end

-- scroll to the bottom of the quickfix window
function vim.cmd.cbo(...)end

-- scroll to the bottom of the quickfix window
function vim.cmd.cbottom(...)end

-- parse error messages and jump to first error
function vim.cmd.cbuffer(...)end

-- go to specific error
function vim.cmd.cc(...)end

-- close quickfix window
function vim.cmd.ccl(...)end

-- close quickfix window
function vim.cmd.cclose(...)end

-- change directory
function vim.cmd.cd(...)end

-- execute command in each valid error list entry
function vim.cmd.cdo(...)end

-- format lines at the center
function vim.cmd.ce(...)end

-- format lines at the center
function vim.cmd.center(...)end

-- read errors from expr and jump to first
function vim.cmd.cex(...)end

-- read errors from expr and jump to first
function vim.cmd.cexpr(...)end

-- read file with error messages and jump to first
function vim.cmd.cf(...)end

-- execute command in each file in error list
function vim.cmd.cfd(...)end

-- execute command in each file in error list
function vim.cmd.cfdo(...)end

-- read file with error messages and jump to first
function vim.cmd.cfile(...)end

-- go to the specified error, default first one
function vim.cmd.cfir(...)end

-- go to the specified error, default first one
function vim.cmd.cfirst(...)end

-- read file with error messages
function vim.cmd.cg(...)end

-- get errors from buffer
function vim.cmd.cgetb(...)end

-- get errors from buffer
function vim.cmd.cgetbuffer(...)end

-- get errors from expr
function vim.cmd.cgete(...)end

-- get errors from expr
function vim.cmd.cgetexpr(...)end

-- read file with error messages
function vim.cmd.cgetfile(...)end

-- replace a line or series of lines
function vim.cmd.change(...)end

-- print the change list
function vim.cmd.changes(...)end

-- change directory
function vim.cmd.chd(...)end

-- change directory
function vim.cmd.chdir(...)end

-- run healthchecks
function vim.cmd.che(...)end

-- run healthchecks
function vim.cmd.checkhealth(...)end

-- list included files
function vim.cmd.checkp(...)end

-- list included files
function vim.cmd.checkpath(...)end

-- check timestamp of loaded buffers
function vim.cmd.checkt(...)end

-- check timestamp of loaded buffers
function vim.cmd.checktime(...)end

-- list the error lists
function vim.cmd.chi(...)end

-- list the error lists
function vim.cmd.chistory(...)end

-- list all errors
function vim.cmd.cl(...)end

-- go to the specified error, default last one
function vim.cmd.cla(...)end

-- go to the specified error, default last one
function vim.cmd.clast(...)end

-- clear the jump list
function vim.cmd.cle(...)end

-- clear the jump list
function vim.cmd.clearjumps(...)end

-- list all errors
function vim.cmd.clist(...)end

-- close current window
function vim.cmd.clo(...)end

-- close current window
function vim.cmd.close(...)end

-- like ":map" but for Command-line mode
function vim.cmd.cm(...)end

-- like ":map" but for Command-line mode
function vim.cmd.cmap(...)end

-- clear all mappings for Command-line mode
function vim.cmd.cmapc(...)end

-- clear all mappings for Command-line mode
function vim.cmd.cmapclear(...)end

-- add menu for Command-line mode
function vim.cmd.cme(...)end

-- add menu for Command-line mode
function vim.cmd.cmenu(...)end

-- go to next error
function vim.cmd.cn(...)end

-- go to newer error list
function vim.cmd.cnew(...)end

-- go to newer error list
function vim.cmd.cnewer(...)end

-- go to next error
function vim.cmd.cnext(...)end

-- go to first error in next file
function vim.cmd.cnf(...)end

-- go to first error in next file
function vim.cmd.cnfile(...)end

-- like ":noremap" but for Command-line mode
function vim.cmd.cno(...)end

-- like ":noreabbrev" but for Command-line mode
function vim.cmd.cnorea(...)end

-- like ":noreabbrev" but for Command-line mode
function vim.cmd.cnoreabbrev(...)end

-- like ":noremap" but for Command-line mode
function vim.cmd.cnoremap(...)end

-- like ":noremenu" but for Command-line mode
function vim.cmd.cnoreme(...)end

-- like ":noremenu" but for Command-line mode
function vim.cmd.cnoremenu(...)end

-- copy lines
function vim.cmd.co(...)end

-- go to older error list
function vim.cmd.col(...)end

-- go to older error list
function vim.cmd.colder(...)end

-- load a specific color scheme
function vim.cmd.colo(...)end

-- load a specific color scheme
function vim.cmd.colorscheme(...)end

-- create user-defined command
function vim.cmd.com(...)end

-- clear all user-defined commands
function vim.cmd.comc(...)end

-- clear all user-defined commands
function vim.cmd.comclear(...)end

-- create user-defined command
function vim.cmd.command(...)end

-- do settings for a specific compiler
function vim.cmd.comp(...)end

-- do settings for a specific compiler
function vim.cmd.compiler(...)end

-- go back to :while
function vim.cmd.con(...)end

-- prompt user when confirmation required
function vim.cmd.conf(...)end

-- prompt user when confirmation required
function vim.cmd.confirm(...)end

-- create a variable as a constant
function vim.cmd.cons(...)end

-- create a variable as a constant
function vim.cmd.const(...)end

-- go back to :while
function vim.cmd.continue(...)end

-- open quickfix window
function vim.cmd.cope(...)end

-- open quickfix window
function vim.cmd.copen(...)end

-- copy lines
function vim.cmd.copy(...)end

-- go to previous error
function vim.cmd.cp(...)end

-- go to last error in previous file
function vim.cmd.cpf(...)end

-- go to last error in previous file
function vim.cmd.cpfile(...)end

-- go to previous error
function vim.cmd.cprevious(...)end

-- quit Vim with an error code
function vim.cmd.cq(...)end

-- quit Vim with an error code
function vim.cmd.cquit(...)end

-- go to the specified error, default first one
function vim.cmd.cr(...)end

-- go to the specified error, default first one
function vim.cmd.crewind(...)end

-- like ":unmap" but for Command-line mode
function vim.cmd.cu(...)end

-- like ":unabbrev" but for Command-line mode
function vim.cmd.cuna(...)end

-- like ":unabbrev" but for Command-line mode
function vim.cmd.cunabbrev(...)end

-- like ":unmap" but for Command-line mode
function vim.cmd.cunmap(...)end

-- remove menu for Command-line mode
function vim.cmd.cunme(...)end

-- remove menu for Command-line mode
function vim.cmd.cunmenu(...)end

-- open or close quickfix window
function vim.cmd.cw(...)end

-- open or close quickfix window
function vim.cmd.cwindow(...)end

-- short for |:delete| with the 'p' flag
function vim.cmd.d(...)end

-- run a command in debugging mode
function vim.cmd.deb(...)end

-- run a command in debugging mode
function vim.cmd.debug(...)end

-- read debug mode commands from normal input
function vim.cmd.debugg(...)end

-- read debug mode commands from normal input
function vim.cmd.debuggreedy(...)end

-- delete user-defined command
function vim.cmd.delc(...)end

-- delete user-defined command
function vim.cmd.delcommand(...)end

-- delete lines
function vim.cmd.delete(...)end

-- short for |:delete| with the 'p' flag
function vim.cmd.deletep(...)end

-- delete a user function
function vim.cmd.delf(...)end

-- delete a user function
function vim.cmd.delfunction(...)end

-- delete marks
function vim.cmd.delm(...)end

-- delete marks
function vim.cmd.delmarks(...)end

-- display registers
function vim.cmd.di(...)end

-- update 'diff' buffers
function vim.cmd.dif(...)end

-- remove differences in current buffer
function vim.cmd.diffg(...)end

-- remove differences in current buffer
function vim.cmd.diffget(...)end

-- switch off diff mode
function vim.cmd.diffo(...)end

-- switch off diff mode
function vim.cmd.diffoff(...)end

-- apply a patch and show differences
function vim.cmd.diffp(...)end

-- apply a patch and show differences
function vim.cmd.diffpatch(...)end

-- remove differences in other buffer
function vim.cmd.diffpu(...)end

-- remove differences in other buffer
function vim.cmd.diffput(...)end

-- show differences with another file
function vim.cmd.diffs(...)end

-- show differences with another file
function vim.cmd.diffsplit(...)end

-- make current window a diff window
function vim.cmd.diffthis(...)end

-- update 'diff' buffers
function vim.cmd.diffupdate(...)end

-- show or enter digraphs
function vim.cmd.dig(...)end

-- show or enter digraphs
function vim.cmd.digraphs(...)end

-- display registers
function vim.cmd.display(...)end

-- jump to #define
function vim.cmd.dj(...)end

-- jump to #define
function vim.cmd.djump(...)end

-- short for |:delete| with the 'l' flag
function vim.cmd.dl(...)end

-- list #defines
function vim.cmd.dli(...)end

-- list #defines
function vim.cmd.dlist(...)end

-- apply autocommands to current buffer
vim.cmd["do"] = function(...)end

-- apply autocommands for all loaded buffers
function vim.cmd.doautoa(...)end

-- apply autocommands for all loaded buffers
function vim.cmd.doautoall(...)end

-- apply autocommands to current buffer
function vim.cmd.doautocmd(...)end

-- jump to window editing file or edit file in
function vim.cmd.dr(...)end

-- jump to window editing file or edit file in
function vim.cmd.drop(...)end

-- list one #define
function vim.cmd.ds(...)end

-- list one #define
function vim.cmd.dsearch(...)end

-- split window and jump to #define
function vim.cmd.dsp(...)end

-- split window and jump to #define
function vim.cmd.dsplit(...)end

-- edit a file
function vim.cmd.e(...)end

-- go to older change, undo
function vim.cmd.ea(...)end

-- go to older change, undo
function vim.cmd.earlier(...)end

-- echoes the result of expressions
function vim.cmd.ec(...)end

-- echoes the result of expressions
function vim.cmd.echo(...)end

-- like :echo, show like an error and use history
function vim.cmd.echoe(...)end

-- like :echo, show like an error and use history
function vim.cmd.echoerr(...)end

-- set highlighting for echo commands
function vim.cmd.echoh(...)end

-- set highlighting for echo commands
function vim.cmd.echohl(...)end

-- same as :echo, put message in history
function vim.cmd.echom(...)end

-- same as :echo, put message in history
function vim.cmd.echomsg(...)end

-- same as :echo, but without <EOL>
function vim.cmd.echon(...)end

-- edit a file
function vim.cmd.edit(...)end

-- part of an :if command
function vim.cmd.el(...)end

-- part of an :if command
vim.cmd["else"] = function(...)end

-- part of an :if command
function vim.cmd.elsei(...)end

-- part of an :if command
vim.cmd["elseif"] = function(...)end

-- execute a menu by name
function vim.cmd.em(...)end

-- execute a menu by name
function vim.cmd.emenu(...)end

-- end previous :if
function vim.cmd.en(...)end

-- end of a user function started with :function
function vim.cmd.endf(...)end

-- end previous :for
function vim.cmd.endfo(...)end

-- end previous :for
function vim.cmd.endfor(...)end

-- end of a user function started with :function
function vim.cmd.endfunction(...)end

-- end previous :if
function vim.cmd.endif(...)end

-- end previous :try
function vim.cmd.endt(...)end

-- end previous :try
function vim.cmd.endtry(...)end

-- end previous :while
function vim.cmd.endw(...)end

-- end previous :while
function vim.cmd.endwhile(...)end

-- edit a new, unnamed buffer
function vim.cmd.ene(...)end

-- edit a new, unnamed buffer
function vim.cmd.enew(...)end

-- evaluate an expression and discard the result
function vim.cmd.ev(...)end

-- evaluate an expression and discard the result
function vim.cmd.eval(...)end

-- same as ":edit"
function vim.cmd.ex(...)end

-- execute result of expressions
function vim.cmd.exe(...)end

-- execute result of expressions
function vim.cmd.execute(...)end

-- same as ":xit"
function vim.cmd.exi(...)end

-- same as ":xit"
function vim.cmd.exit(...)end

-- overview of Ex commands
function vim.cmd.exu(...)end

-- overview of Ex commands
function vim.cmd.exusage(...)end

-- show or set the current file name
function vim.cmd.f(...)end

-- show or set the current file name
function vim.cmd.file(...)end

-- list all files in the buffer list
function vim.cmd.files(...)end

-- switch file type detection on/off
function vim.cmd.filet(...)end

-- switch file type detection on/off
function vim.cmd.filetype(...)end

-- filter output of following command
function vim.cmd.filt(...)end

-- filter output of following command
function vim.cmd.filter(...)end

-- find file in 'path' and edit it
function vim.cmd.fin(...)end

-- part of a :try command
function vim.cmd.fina(...)end

-- part of a :try command
function vim.cmd.finally(...)end

-- find file in 'path' and edit it
function vim.cmd.find(...)end

-- quit sourcing a Vim script
function vim.cmd.fini(...)end

-- quit sourcing a Vim script
function vim.cmd.finish(...)end

-- go to the first file in the argument list
function vim.cmd.fir(...)end

-- go to the first file in the argument list
function vim.cmd.first(...)end

-- create a fold
function vim.cmd.fo(...)end

-- create a fold
function vim.cmd.fold(...)end

-- close folds
function vim.cmd.foldc(...)end

-- close folds
function vim.cmd.foldclose(...)end

-- execute command on lines not in a closed fold
function vim.cmd.foldd(...)end

-- execute command on lines in a closed fold
function vim.cmd.folddoc(...)end

-- execute command on lines in a closed fold
function vim.cmd.folddoclosed(...)end

-- execute command on lines not in a closed fold
function vim.cmd.folddoopen(...)end

-- open folds
function vim.cmd.foldo(...)end

-- open folds
function vim.cmd.foldopen(...)end

-- for loop
vim.cmd["for"] = function(...)end

-- define a user function
function vim.cmd.fu(...)end

-- define a user function
vim.cmd["function"] = function(...)end

-- execute commands for matching lines
function vim.cmd.g(...)end

-- execute commands for matching lines
function vim.cmd.global(...)end

-- go to byte in the buffer
function vim.cmd.go(...)end

-- go to byte in the buffer
vim.cmd["goto"] = function(...)end

-- run 'grepprg' and jump to first match
function vim.cmd.gr(...)end

-- run 'grepprg' and jump to first match
function vim.cmd.grep(...)end

-- like :grep, but append to current list
function vim.cmd.grepa(...)end

-- like :grep, but append to current list
function vim.cmd.grepadd(...)end

-- start the GUI
function vim.cmd.gu(...)end

-- start the GUI
function vim.cmd.gui(...)end

-- start the GUI
function vim.cmd.gv(...)end

-- start the GUI
function vim.cmd.gvim(...)end

-- open a help window
function vim.cmd.h(...)end

-- open a help window
function vim.cmd.help(...)end

-- close one help window
function vim.cmd.helpc(...)end

-- close one help window
function vim.cmd.helpclose(...)end

-- like ":grep" but searches help files
function vim.cmd.helpg(...)end

-- like ":grep" but searches help files
function vim.cmd.helpgrep(...)end

-- generate help tags for a directory
function vim.cmd.helpt(...)end

-- generate help tags for a directory
function vim.cmd.helptags(...)end

-- specify highlighting methods
function vim.cmd.hi(...)end

-- hide current buffer for a command
function vim.cmd.hid(...)end

-- hide current buffer for a command
function vim.cmd.hide(...)end

-- specify highlighting methods
function vim.cmd.highlight(...)end

-- print a history list
function vim.cmd.his(...)end

-- print a history list
function vim.cmd.history(...)end

-- following window command work horizontally
function vim.cmd.hor(...)end

-- following window command work horizontally
function vim.cmd.horizontal(...)end

-- insert text
function vim.cmd.i(...)end

-- like ":abbrev" but for Insert mode
function vim.cmd.ia(...)end

-- like ":abbrev" but for Insert mode
function vim.cmd.iabbrev(...)end

-- like ":abclear" but for Insert mode
function vim.cmd.iabc(...)end

-- like ":abclear" but for Insert mode
function vim.cmd.iabclear(...)end

-- execute commands when condition met
vim.cmd["if"] = function(...)end

-- jump to definition of identifier
function vim.cmd.ij(...)end

-- jump to definition of identifier
function vim.cmd.ijump(...)end

-- list lines where identifier matches
function vim.cmd.il(...)end

-- list lines where identifier matches
function vim.cmd.ilist(...)end

-- like ":map" but for Insert mode
function vim.cmd.im(...)end

-- like ":map" but for Insert mode
function vim.cmd.imap(...)end

-- like ":mapclear" but for Insert mode
function vim.cmd.imapc(...)end

-- like ":mapclear" but for Insert mode
function vim.cmd.imapclear(...)end

-- add menu for Insert mode
function vim.cmd.ime(...)end

-- add menu for Insert mode
function vim.cmd.imenu(...)end

-- like ":noremap" but for Insert mode
function vim.cmd.ino(...)end

-- like ":noreabbrev" but for Insert mode
function vim.cmd.inorea(...)end

-- like ":noreabbrev" but for Insert mode
function vim.cmd.inoreabbrev(...)end

-- like ":noremap" but for Insert mode
function vim.cmd.inoremap(...)end

-- like ":noremenu" but for Insert mode
function vim.cmd.inoreme(...)end

-- like ":noremenu" but for Insert mode
function vim.cmd.inoremenu(...)end

-- insert text
function vim.cmd.insert(...)end

-- print the introductory message
function vim.cmd.int(...)end

-- print the introductory message
function vim.cmd.intro(...)end

-- list one line where identifier matches
function vim.cmd.is(...)end

-- list one line where identifier matches
function vim.cmd.isearch(...)end

-- split window and jump to definition of
function vim.cmd.isp(...)end

-- split window and jump to definition of
function vim.cmd.isplit(...)end

-- like ":unmap" but for Insert mode
function vim.cmd.iu(...)end

-- like ":unabbrev" but for Insert mode
function vim.cmd.iuna(...)end

-- like ":unabbrev" but for Insert mode
function vim.cmd.iunabbrev(...)end

-- like ":unmap" but for Insert mode
function vim.cmd.iunmap(...)end

-- remove menu for Insert mode
function vim.cmd.iunme(...)end

-- remove menu for Insert mode
function vim.cmd.iunmenu(...)end

-- join lines
function vim.cmd.j(...)end

-- join lines
function vim.cmd.join(...)end

-- print the jump list
function vim.cmd.ju(...)end

-- print the jump list
function vim.cmd.jumps(...)end

-- set a mark
function vim.cmd.k(...)end

-- following command keeps marks where they are
function vim.cmd.kee(...)end

-- following command keeps the alternate file
function vim.cmd.keepa(...)end

-- following command keeps the alternate file
function vim.cmd.keepalt(...)end

-- following command keeps jumplist and marks
function vim.cmd.keepj(...)end

-- following command keeps jumplist and marks
function vim.cmd.keepjumps(...)end

-- following command keeps marks where they are
function vim.cmd.keepmarks(...)end

-- following command keeps search pattern history
function vim.cmd.keepp(...)end

-- following command keeps search pattern history
function vim.cmd.keeppatterns(...)end

-- print lines
function vim.cmd.l(...)end

-- go to previous entry in location list
function vim.cmd.lN(...)end

-- go to previous entry in location list
function vim.cmd.lNext(...)end

-- go to last entry in previous file
function vim.cmd.lNf(...)end

-- go to last entry in previous file
function vim.cmd.lNfile(...)end

-- go to the last file in the argument list
function vim.cmd.la(...)end

-- go to location above current line
function vim.cmd.lab(...)end

-- go to location above current line
function vim.cmd.labove(...)end

-- add locations from expr
function vim.cmd.lad(...)end

-- add locations from buffer
function vim.cmd.laddb(...)end

-- add locations from buffer
function vim.cmd.laddbuffer(...)end

-- add locations from expr
function vim.cmd.laddexpr(...)end

-- add locations to current location list
function vim.cmd.laddf(...)end

-- add locations to current location list
function vim.cmd.laddfile(...)end

-- go to location after current cursor
function vim.cmd.laf(...)end

-- go to location after current cursor
function vim.cmd.lafter(...)end

-- set the language (locale)
function vim.cmd.lan(...)end

-- set the language (locale)
function vim.cmd.language(...)end

-- go to the last file in the argument list
function vim.cmd.last(...)end

-- go to newer change, redo
function vim.cmd.lat(...)end

-- go to newer change, redo
function vim.cmd.later(...)end

-- parse locations and jump to first location
function vim.cmd.lb(...)end

-- go to location before current cursor
function vim.cmd.lbef(...)end

-- go to location before current cursor
function vim.cmd.lbefore(...)end

-- go to location below current line
function vim.cmd.lbel(...)end

-- go to location below current line
function vim.cmd.lbelow(...)end

-- scroll to the bottom of the location window
function vim.cmd.lbo(...)end

-- scroll to the bottom of the location window
function vim.cmd.lbottom(...)end

-- parse locations and jump to first location
function vim.cmd.lbuffer(...)end

-- change directory locally
function vim.cmd.lc(...)end

-- change directory locally
function vim.cmd.lcd(...)end

-- change directory locally
function vim.cmd.lch(...)end

-- change directory locally
function vim.cmd.lchdir(...)end

-- close location window
function vim.cmd.lcl(...)end

-- close location window
function vim.cmd.lclose(...)end

-- execute command in valid location list entries
function vim.cmd.ld(...)end

-- execute command in valid location list entries
function vim.cmd.ldo(...)end

-- left align lines
function vim.cmd.le(...)end

-- left align lines
function vim.cmd.left(...)end

-- make split window appear left or above
function vim.cmd.lefta(...)end

-- make split window appear left or above
function vim.cmd.leftabove(...)end

-- assign a value to a variable or option
function vim.cmd.let(...)end

-- read locations from expr and jump to first
function vim.cmd.lex(...)end

-- read locations from expr and jump to first
function vim.cmd.lexpr(...)end

-- read file with locations and jump to first
function vim.cmd.lf(...)end

-- execute command in each file in location list
function vim.cmd.lfd(...)end

-- execute command in each file in location list
function vim.cmd.lfdo(...)end

-- read file with locations and jump to first
function vim.cmd.lfile(...)end

-- go to the specified location, default first one
function vim.cmd.lfir(...)end

-- go to the specified location, default first one
function vim.cmd.lfirst(...)end

-- read file with locations
function vim.cmd.lg(...)end

-- get locations from buffer
function vim.cmd.lgetb(...)end

-- get locations from buffer
function vim.cmd.lgetbuffer(...)end

-- get locations from expr
function vim.cmd.lgete(...)end

-- get locations from expr
function vim.cmd.lgetexpr(...)end

-- read file with locations
function vim.cmd.lgetfile(...)end

-- run 'grepprg' and jump to first match
function vim.cmd.lgr(...)end

-- run 'grepprg' and jump to first match
function vim.cmd.lgrep(...)end

-- like :grep, but append to current list
function vim.cmd.lgrepa(...)end

-- like :grep, but append to current list
function vim.cmd.lgrepadd(...)end

-- like ":helpgrep" but uses location list
function vim.cmd.lh(...)end

-- like ":helpgrep" but uses location list
function vim.cmd.lhelpgrep(...)end

-- list the location lists
function vim.cmd.lhi(...)end

-- list the location lists
function vim.cmd.lhistory(...)end

-- print lines
function vim.cmd.list(...)end

-- go to specific location
function vim.cmd.ll(...)end

-- go to the specified location, default last one
function vim.cmd.lla(...)end

-- go to the specified location, default last one
function vim.cmd.llast(...)end

-- list all locations
function vim.cmd.lli(...)end

-- list all locations
function vim.cmd.llist(...)end

-- like ":map!" but includes Lang-Arg mode
function vim.cmd.lm(...)end

-- execute external command 'makeprg' and parse
function vim.cmd.lmak(...)end

-- execute external command 'makeprg' and parse
function vim.cmd.lmake(...)end

-- like ":map!" but includes Lang-Arg mode
function vim.cmd.lmap(...)end

-- like ":mapclear!" but includes Lang-Arg mode
function vim.cmd.lmapc(...)end

-- like ":mapclear!" but includes Lang-Arg mode
function vim.cmd.lmapclear(...)end

-- like ":noremap!" but includes Lang-Arg mode
function vim.cmd.ln(...)end

-- go to next location
function vim.cmd.lne(...)end

-- go to newer location list
function vim.cmd.lnew(...)end

-- go to newer location list
function vim.cmd.lnewer(...)end

-- go to next location
function vim.cmd.lnext(...)end

-- go to first location in next file
function vim.cmd.lnf(...)end

-- go to first location in next file
function vim.cmd.lnfile(...)end

-- like ":noremap!" but includes Lang-Arg mode
function vim.cmd.lnoremap(...)end

-- load view for current window from a file
function vim.cmd.lo(...)end

-- load the following keymaps until EOF
function vim.cmd.loadk(...)end

-- load the following keymaps until EOF
function vim.cmd.loadkeymap(...)end

-- load view for current window from a file
function vim.cmd.loadview(...)end

-- following command keeps marks where they are
function vim.cmd.loc(...)end

-- following command keeps marks where they are
function vim.cmd.lockmarks(...)end

-- lock variables
function vim.cmd.lockv(...)end

-- lock variables
function vim.cmd.lockvar(...)end

-- go to older location list
function vim.cmd.lol(...)end

-- go to older location list
function vim.cmd.lolder(...)end

-- open location window
function vim.cmd.lope(...)end

-- open location window
function vim.cmd.lopen(...)end

-- go to previous location
function vim.cmd.lp(...)end

-- go to last location in previous file
function vim.cmd.lpf(...)end

-- go to last location in previous file
function vim.cmd.lpfile(...)end

-- go to previous location
function vim.cmd.lprevious(...)end

-- go to the specified location, default first one
function vim.cmd.lr(...)end

-- go to the specified location, default first one
function vim.cmd.lrewind(...)end

-- list all buffers
function vim.cmd.ls(...)end

-- jump to tag and add matching tags to the
function vim.cmd.lt(...)end

-- jump to tag and add matching tags to the
function vim.cmd.ltag(...)end

-- like ":unmap!" but includes Lang-Arg mode
function vim.cmd.lu(...)end

-- execute |Lua| command
function vim.cmd.lua(...)end

-- execute Lua command for each line
function vim.cmd.luad(...)end

-- execute Lua command for each line
function vim.cmd.luado(...)end

-- execute |Lua| script file
function vim.cmd.luaf(...)end

-- execute |Lua| script file
function vim.cmd.luafile(...)end

-- like ":unmap!" but includes Lang-Arg mode
function vim.cmd.lunmap(...)end

-- search for pattern in files
function vim.cmd.lv(...)end

-- search for pattern in files
function vim.cmd.lvimgrep(...)end

-- like :vimgrep, but append to current list
function vim.cmd.lvimgrepa(...)end

-- like :vimgrep, but append to current list
function vim.cmd.lvimgrepadd(...)end

-- open or close location window
function vim.cmd.lw(...)end

-- open or close location window
function vim.cmd.lwindow(...)end

-- move lines
function vim.cmd.m(...)end

-- set a mark
function vim.cmd.ma(...)end

-- execute external command 'makeprg' and parse
function vim.cmd.mak(...)end

-- execute external command 'makeprg' and parse
function vim.cmd.make(...)end

-- show or enter a mapping
function vim.cmd.map(...)end

-- clear all mappings for Normal and Visual mode
function vim.cmd.mapc(...)end

-- clear all mappings for Normal and Visual mode
function vim.cmd.mapclear(...)end

-- set a mark
function vim.cmd.mark(...)end

-- list all marks
function vim.cmd.marks(...)end

-- define a match to highlight
function vim.cmd.mat(...)end

-- define a match to highlight
function vim.cmd.match(...)end

-- enter a new menu item
function vim.cmd.me(...)end

-- enter a new menu item
function vim.cmd.menu(...)end

-- add a menu translation item
function vim.cmd.menut(...)end

-- add a menu translation item
function vim.cmd.menutranslate(...)end

-- view previously displayed messages
function vim.cmd.mes(...)end

-- view previously displayed messages
function vim.cmd.messages(...)end

-- write current mappings and settings to a file
function vim.cmd.mk(...)end

-- write current mappings and settings to a file
function vim.cmd.mkexrc(...)end

-- write session info to a file
function vim.cmd.mks(...)end

-- write session info to a file
function vim.cmd.mksession(...)end

-- produce .spl spell file
function vim.cmd.mksp(...)end

-- produce .spl spell file
function vim.cmd.mkspell(...)end

-- write current mappings and settings to a file
function vim.cmd.mkv(...)end

-- write view of current window to a file
function vim.cmd.mkvie(...)end

-- write view of current window to a file
function vim.cmd.mkview(...)end

-- write current mappings and settings to a file
function vim.cmd.mkvimrc(...)end

-- show or change the screen mode
function vim.cmd.mod(...)end

-- show or change the screen mode
function vim.cmd.mode(...)end

-- move lines
function vim.cmd.move(...)end

-- go to next file in the argument list
function vim.cmd.n(...)end

-- create a new empty window
function vim.cmd.new(...)end

-- go to next file in the argument list
function vim.cmd.next(...)end

-- like ":map" but for Normal mode
function vim.cmd.nm(...)end

-- like ":map" but for Normal mode
function vim.cmd.nmap(...)end

-- clear all mappings for Normal mode
function vim.cmd.nmapc(...)end

-- clear all mappings for Normal mode
function vim.cmd.nmapclear(...)end

-- add menu for Normal mode
function vim.cmd.nme(...)end

-- add menu for Normal mode
function vim.cmd.nmenu(...)end

-- like ":noremap" but for Normal mode
function vim.cmd.nn(...)end

-- like ":noremap" but for Normal mode
function vim.cmd.nnoremap(...)end

-- like ":noremenu" but for Normal mode
function vim.cmd.nnoreme(...)end

-- like ":noremenu" but for Normal mode
function vim.cmd.nnoremenu(...)end

-- enter a mapping that will not be remapped
function vim.cmd.no(...)end

-- following commands don't trigger autocommands
function vim.cmd.noa(...)end

-- following commands don't trigger autocommands
function vim.cmd.noautocmd(...)end

-- suspend 'hlsearch' highlighting
function vim.cmd.noh(...)end

-- suspend 'hlsearch' highlighting
function vim.cmd.nohlsearch(...)end

-- enter an abbreviation that will not be
function vim.cmd.norea(...)end

-- enter an abbreviation that will not be
function vim.cmd.noreabbrev(...)end

-- enter a mapping that will not be remapped
function vim.cmd.noremap(...)end

-- enter a menu that will not be remapped
function vim.cmd.noreme(...)end

-- enter a menu that will not be remapped
function vim.cmd.noremenu(...)end

-- execute Normal mode commands
function vim.cmd.norm(...)end

-- execute Normal mode commands
function vim.cmd.normal(...)end

-- following commands don't create a swap file
function vim.cmd.nos(...)end

-- following commands don't create a swap file
function vim.cmd.noswapfile(...)end

-- print lines with line number
function vim.cmd.nu(...)end

-- print lines with line number
function vim.cmd.number(...)end

-- like ":unmap" but for Normal mode
function vim.cmd.nun(...)end

-- like ":unmap" but for Normal mode
function vim.cmd.nunmap(...)end

-- remove menu for Normal mode
function vim.cmd.nunme(...)end

-- remove menu for Normal mode
function vim.cmd.nunmenu(...)end

-- list files that have marks in the |shada| file
function vim.cmd.ol(...)end

-- list files that have marks in the |shada| file
function vim.cmd.oldfiles(...)end

-- like ":map" but for Operator-pending mode
function vim.cmd.om(...)end

-- like ":map" but for Operator-pending mode
function vim.cmd.omap(...)end

-- remove all mappings for Operator-pending mode
function vim.cmd.omapc(...)end

-- remove all mappings for Operator-pending mode
function vim.cmd.omapclear(...)end

-- add menu for Operator-pending mode
function vim.cmd.ome(...)end

-- add menu for Operator-pending mode
function vim.cmd.omenu(...)end

-- close all windows except the current one
function vim.cmd.on(...)end

-- close all windows except the current one
function vim.cmd.only(...)end

-- like ":noremap" but for Operator-pending mode
function vim.cmd.ono(...)end

-- like ":noremap" but for Operator-pending mode
function vim.cmd.onoremap(...)end

-- like ":noremenu" but for Operator-pending mode
function vim.cmd.onoreme(...)end

-- like ":noremenu" but for Operator-pending mode
function vim.cmd.onoremenu(...)end

-- open the options-window
function vim.cmd.opt(...)end

-- open the options-window
function vim.cmd.options(...)end

-- like ":unmap" but for Operator-pending mode
function vim.cmd.ou(...)end

-- like ":unmap" but for Operator-pending mode
function vim.cmd.ounmap(...)end

-- remove menu for Operator-pending mode
function vim.cmd.ounme(...)end

-- remove menu for Operator-pending mode
function vim.cmd.ounmenu(...)end

-- set new local syntax highlight for this window
function vim.cmd.ow(...)end

-- set new local syntax highlight for this window
function vim.cmd.ownsyntax(...)end

-- print lines
function vim.cmd.p(...)end

-- add a plugin from 'packpath'
function vim.cmd.pa(...)end

-- add a plugin from 'packpath'
function vim.cmd.packadd(...)end

-- load all packages under 'packpath'
function vim.cmd.packl(...)end

-- load all packages under 'packpath'
function vim.cmd.packloadall(...)end

-- close preview window
function vim.cmd.pc(...)end

-- close preview window
function vim.cmd.pclose(...)end

-- execute perl command
function vim.cmd.pe(...)end

-- edit file in the preview window
function vim.cmd.ped(...)end

-- edit file in the preview window
function vim.cmd.pedit(...)end

-- execute perl command
function vim.cmd.perl(...)end

-- execute perl command for each line
function vim.cmd.perld(...)end

-- execute perl command for each line
function vim.cmd.perldo(...)end

-- execute perl script file
function vim.cmd.perlf(...)end

-- execute perl script file
function vim.cmd.perlfile(...)end

-- jump to older entry in tag stack
function vim.cmd.po(...)end

-- jump to older entry in tag stack
function vim.cmd.pop(...)end

-- popup a menu by name
function vim.cmd.popu(...)end

-- popup a menu by name
function vim.cmd.popup(...)end

-- ":pop" in preview window
function vim.cmd.pp(...)end

-- ":pop" in preview window
function vim.cmd.ppop(...)end

-- write all text to swap file
function vim.cmd.pre(...)end

-- write all text to swap file
function vim.cmd.preserve(...)end

-- go to previous file in argument list
function vim.cmd.prev(...)end

-- go to previous file in argument list
function vim.cmd.previous(...)end

-- print lines
function vim.cmd.print(...)end

-- profiling functions and scripts
function vim.cmd.prof(...)end

-- stop profiling a function or script
function vim.cmd.profd(...)end

-- stop profiling a function or script
function vim.cmd.profdel(...)end

-- profiling functions and scripts
function vim.cmd.profile(...)end

-- like ":ijump" but shows match in preview window
function vim.cmd.ps(...)end

-- like ":ijump" but shows match in preview window
function vim.cmd.psearch(...)end

-- show tag in preview window
function vim.cmd.pt(...)end

-- |:tNext| in preview window
function vim.cmd.ptN(...)end

-- |:tNext| in preview window
function vim.cmd.ptNext(...)end

-- show tag in preview window
function vim.cmd.ptag(...)end

-- |:trewind| in preview window
function vim.cmd.ptf(...)end

-- |:trewind| in preview window
function vim.cmd.ptfirst(...)end

-- |:tjump| and show tag in preview window
function vim.cmd.ptj(...)end

-- |:tjump| and show tag in preview window
function vim.cmd.ptjump(...)end

-- |:tlast| in preview window
function vim.cmd.ptl(...)end

-- |:tlast| in preview window
function vim.cmd.ptlast(...)end

-- |:tnext| in preview window
function vim.cmd.ptn(...)end

-- |:tnext| in preview window
function vim.cmd.ptnext(...)end

-- |:tprevious| in preview window
function vim.cmd.ptp(...)end

-- |:tprevious| in preview window
function vim.cmd.ptprevious(...)end

-- |:trewind| in preview window
function vim.cmd.ptr(...)end

-- |:trewind| in preview window
function vim.cmd.ptrewind(...)end

-- |:tselect| and show tag in preview window
function vim.cmd.pts(...)end

-- |:tselect| and show tag in preview window
function vim.cmd.ptselect(...)end

-- insert contents of register in the text
function vim.cmd.pu(...)end

-- insert contents of register in the text
function vim.cmd.put(...)end

-- print current directory
function vim.cmd.pw(...)end

-- print current directory
function vim.cmd.pwd(...)end

-- execute Python command
function vim.cmd.py(...)end

-- execute Python 3 command
function vim.cmd.py3(...)end

-- execute Python 3 command for each line
function vim.cmd.py3d(...)end

-- execute Python 3 command for each line
function vim.cmd.py3do(...)end

-- execute Python 3 script file
function vim.cmd.py3f(...)end

-- execute Python 3 script file
function vim.cmd.py3file(...)end

-- execute Python command for each line
function vim.cmd.pyd(...)end

-- execute Python command for each line
function vim.cmd.pydo(...)end

-- execute Python script file
function vim.cmd.pyf(...)end

-- execute Python script file
function vim.cmd.pyfile(...)end

-- execute Python command
function vim.cmd.python(...)end

-- same as :py3
function vim.cmd.python3(...)end

-- same as :pyx
function vim.cmd.pythonx(...)end

-- execute |python_x| command
function vim.cmd.pyx(...)end

-- execute |python_x| command for each line
function vim.cmd.pyxd(...)end

-- execute |python_x| command for each line
function vim.cmd.pyxdo(...)end

-- execute |python_x| script file
function vim.cmd.pyxf(...)end

-- execute |python_x| script file
function vim.cmd.pyxfile(...)end

-- quit current window (when one window quit Vim)
function vim.cmd.q(...)end

-- quit Vim
function vim.cmd.qa(...)end

-- quit Vim
function vim.cmd.qall(...)end

-- quit current window (when one window quit Vim)
function vim.cmd.quit(...)end

-- quit Vim
function vim.cmd.quita(...)end

-- quit Vim
function vim.cmd.quitall(...)end

-- read file into the text
function vim.cmd.r(...)end

-- read file into the text
function vim.cmd.read(...)end

-- recover a file from a swap file
function vim.cmd.rec(...)end

-- recover a file from a swap file
function vim.cmd.recover(...)end

-- redo one undone change
function vim.cmd.red(...)end

-- redirect messages to a file or register
function vim.cmd.redi(...)end

-- redirect messages to a file or register
function vim.cmd.redir(...)end

-- redo one undone change
function vim.cmd.redo(...)end

-- force a redraw of the display
function vim.cmd.redr(...)end

-- force a redraw of the display
function vim.cmd.redraw(...)end

-- force a redraw of the status line(s) and
function vim.cmd.redraws(...)end

-- force a redraw of the status line(s) and
function vim.cmd.redrawstatus(...)end

-- force a redraw of the tabline
function vim.cmd.redrawt(...)end

-- force a redraw of the tabline
function vim.cmd.redrawtabline(...)end

-- display the contents of registers
function vim.cmd.reg(...)end

-- display the contents of registers
function vim.cmd.registers(...)end

-- change current window height
function vim.cmd.res(...)end

-- change current window height
function vim.cmd.resize(...)end

-- change tab size
function vim.cmd.ret(...)end

-- change tab size
function vim.cmd.retab(...)end

-- return from a user function
function vim.cmd.retu(...)end

-- return from a user function
vim.cmd["return"] = function(...)end

-- go to the first file in the argument list
function vim.cmd.rew(...)end

-- go to the first file in the argument list
function vim.cmd.rewind(...)end

-- right align text
function vim.cmd.ri(...)end

-- right align text
function vim.cmd.right(...)end

-- make split window appear right or below
function vim.cmd.rightb(...)end

-- make split window appear right or below
function vim.cmd.rightbelow(...)end

-- read from |shada| file
function vim.cmd.rsh(...)end

-- read from |shada| file
function vim.cmd.rshada(...)end

-- source vim scripts in 'runtimepath'
function vim.cmd.ru(...)end

-- execute Ruby command
function vim.cmd.rub(...)end

-- execute Ruby command
function vim.cmd.ruby(...)end

-- execute Ruby command for each line
function vim.cmd.rubyd(...)end

-- execute Ruby command for each line
function vim.cmd.rubydo(...)end

-- execute Ruby script file
function vim.cmd.rubyf(...)end

-- execute Ruby script file
function vim.cmd.rubyfile(...)end

-- read undo information from a file
function vim.cmd.rund(...)end

-- read undo information from a file
function vim.cmd.rundo(...)end

-- source vim scripts in 'runtimepath'
function vim.cmd.runtime(...)end

-- find and replace text
function vim.cmd.s(...)end

-- split window and go to previous file in
function vim.cmd.sN(...)end

-- split window and go to previous file in
function vim.cmd.sNext(...)end

-- split window and go to specific file in
function vim.cmd.sa(...)end

-- open a window for each file in argument list
function vim.cmd.sal(...)end

-- open a window for each file in argument list
function vim.cmd.sall(...)end

-- execute a command in the sandbox
function vim.cmd.san(...)end

-- execute a command in the sandbox
function vim.cmd.sandbox(...)end

-- split window and go to specific file in
function vim.cmd.sargument(...)end

-- save file under another name.
function vim.cmd.sav(...)end

-- save file under another name.
function vim.cmd.saveas(...)end

-- split window and go to specific file in the
function vim.cmd.sb(...)end

-- split window and go to previous file in the
function vim.cmd.sbN(...)end

-- split window and go to previous file in the
function vim.cmd.sbNext(...)end

-- open a window for each file in the buffer list
function vim.cmd.sba(...)end

-- open a window for each file in the buffer list
function vim.cmd.sball(...)end

-- split window and go to first file in the
function vim.cmd.sbf(...)end

-- split window and go to first file in the
function vim.cmd.sbfirst(...)end

-- split window and go to last file in buffer
function vim.cmd.sbl(...)end

-- split window and go to last file in buffer
function vim.cmd.sblast(...)end

-- split window and go to modified file in the
function vim.cmd.sbm(...)end

-- split window and go to modified file in the
function vim.cmd.sbmodified(...)end

-- split window and go to next file in the buffer
function vim.cmd.sbn(...)end

-- split window and go to next file in the buffer
function vim.cmd.sbnext(...)end

-- split window and go to previous file in the
function vim.cmd.sbp(...)end

-- split window and go to previous file in the
function vim.cmd.sbprevious(...)end

-- split window and go to first file in the
function vim.cmd.sbr(...)end

-- split window and go to first file in the
function vim.cmd.sbrewind(...)end

-- split window and go to specific file in the
function vim.cmd.sbuffer(...)end

-- list names of all sourced Vim scripts
function vim.cmd.scr(...)end

-- encoding used in sourced Vim script
function vim.cmd.scripte(...)end

-- encoding used in sourced Vim script
function vim.cmd.scriptencoding(...)end

-- list names of all sourced Vim scripts
function vim.cmd.scriptnames(...)end

-- show or set options
function vim.cmd.se(...)end

-- show or set options
function vim.cmd.set(...)end

-- set 'filetype', unless it was set already
function vim.cmd.setf(...)end

-- set 'filetype', unless it was set already
function vim.cmd.setfiletype(...)end

-- show global values of options
function vim.cmd.setg(...)end

-- show global values of options
function vim.cmd.setglobal(...)end

-- show or set options locally
function vim.cmd.setl(...)end

-- show or set options locally
function vim.cmd.setlocal(...)end

-- split current window and edit file in 'path'
function vim.cmd.sf(...)end

-- split current window and edit file in 'path'
function vim.cmd.sfind(...)end

-- split window and go to first file in the
function vim.cmd.sfir(...)end

-- split window and go to first file in the
function vim.cmd.sfirst(...)end

-- manipulate signs
function vim.cmd.sig(...)end

-- manipulate signs
function vim.cmd.sign(...)end

-- run a command silently
function vim.cmd.sil(...)end

-- run a command silently
function vim.cmd.silent(...)end

-- do nothing for a few seconds
function vim.cmd.sl(...)end

-- split window and go to last file in the
function vim.cmd.sla(...)end

-- split window and go to last file in the
function vim.cmd.slast(...)end

-- do nothing for a few seconds
function vim.cmd.sleep(...)end

-- :substitute with 'magic'
function vim.cmd.sm(...)end

-- :substitute with 'magic'
function vim.cmd.smagic(...)end

-- like ":map" but for Select mode
function vim.cmd.smap(...)end

-- remove all mappings for Select mode
function vim.cmd.smapc(...)end

-- remove all mappings for Select mode
function vim.cmd.smapclear(...)end

-- add menu for Select mode
function vim.cmd.sme(...)end

-- add menu for Select mode
function vim.cmd.smenu(...)end

-- split window and go to next file in the
function vim.cmd.sn(...)end

-- split window and go to next file in the
function vim.cmd.snext(...)end

-- :substitute with 'nomagic'
function vim.cmd.sno(...)end

-- :substitute with 'nomagic'
function vim.cmd.snomagic(...)end

-- like ":noremap" but for Select mode
function vim.cmd.snor(...)end

-- like ":noremap" but for Select mode
function vim.cmd.snoremap(...)end

-- like ":noremenu" but for Select mode
function vim.cmd.snoreme(...)end

-- like ":noremenu" but for Select mode
function vim.cmd.snoremenu(...)end

-- read Vim or Ex commands from a file
function vim.cmd.so(...)end

-- sort lines
function vim.cmd.sor(...)end

-- sort lines
function vim.cmd.sort(...)end

-- read Vim or Ex commands from a file
function vim.cmd.source(...)end

-- split current window
function vim.cmd.sp(...)end

-- add good word for spelling
function vim.cmd.spe(...)end

-- split window and fill with all correct words
function vim.cmd.spelld(...)end

-- split window and fill with all correct words
function vim.cmd.spelldump(...)end

-- add good word for spelling
function vim.cmd.spellgood(...)end

-- show info about loaded spell files
function vim.cmd.spelli(...)end

-- show info about loaded spell files
function vim.cmd.spellinfo(...)end

-- replace all bad words like last |z=|
function vim.cmd.spellr(...)end

-- add rare word for spelling
function vim.cmd.spellra(...)end

-- add rare word for spelling
function vim.cmd.spellrare(...)end

-- replace all bad words like last |z=|
function vim.cmd.spellrepall(...)end

-- remove good or bad word
function vim.cmd.spellu(...)end

-- remove good or bad word
function vim.cmd.spellundo(...)end

-- add spelling mistake
function vim.cmd.spellw(...)end

-- add spelling mistake
function vim.cmd.spellwrong(...)end

-- split current window
function vim.cmd.split(...)end

-- split window and go to previous file in the
function vim.cmd.spr(...)end

-- split window and go to previous file in the
function vim.cmd.sprevious(...)end

-- split window and go to first file in the
function vim.cmd.sre(...)end

-- split window and go to first file in the
function vim.cmd.srewind(...)end

-- suspend the editor or escape to a shell
function vim.cmd.st(...)end

-- split window and jump to a tag
function vim.cmd.sta(...)end

-- split window and jump to a tag
function vim.cmd.stag(...)end

-- start Insert mode
function vim.cmd.star(...)end

-- start Virtual Replace mode
function vim.cmd.startg(...)end

-- start Virtual Replace mode
function vim.cmd.startgreplace(...)end

-- start Insert mode
function vim.cmd.startinsert(...)end

-- start Replace mode
function vim.cmd.startr(...)end

-- start Replace mode
function vim.cmd.startreplace(...)end

-- do ":tjump" and split window
function vim.cmd.stj(...)end

-- do ":tjump" and split window
function vim.cmd.stjump(...)end

-- suspend the editor or escape to a shell
function vim.cmd.stop(...)end

-- stop Insert mode
function vim.cmd.stopi(...)end

-- stop Insert mode
function vim.cmd.stopinsert(...)end

-- do ":tselect" and split window
function vim.cmd.sts(...)end

-- do ":tselect" and split window
function vim.cmd.stselect(...)end

-- find and replace text
function vim.cmd.substitute(...)end

-- same as ":unhide"
function vim.cmd.sun(...)end

-- same as ":unhide"
function vim.cmd.sunhide(...)end

-- like ":unmap" but for Select mode
function vim.cmd.sunm(...)end

-- like ":unmap" but for Select mode
function vim.cmd.sunmap(...)end

-- remove menu for Select mode
function vim.cmd.sunme(...)end

-- remove menu for Select mode
function vim.cmd.sunmenu(...)end

-- same as ":stop"
function vim.cmd.sus(...)end

-- same as ":stop"
function vim.cmd.suspend(...)end

-- split window and edit file read-only
function vim.cmd.sv(...)end

-- split window and edit file read-only
function vim.cmd.sview(...)end

-- show the name of the current swap file
function vim.cmd.sw(...)end

-- show the name of the current swap file
function vim.cmd.swapname(...)end

-- syntax highlighting
function vim.cmd.sy(...)end

-- sync scroll binding
function vim.cmd.sync(...)end

-- sync scroll binding
function vim.cmd.syncbind(...)end

-- syntax highlighting
function vim.cmd.syntax(...)end

-- measure syntax highlighting speed
function vim.cmd.synti(...)end

-- measure syntax highlighting speed
function vim.cmd.syntime(...)end

-- same as ":copy"
function vim.cmd.t(...)end

-- jump to previous matching tag
function vim.cmd.tN(...)end

-- jump to previous matching tag
function vim.cmd.tNext(...)end

-- jump to tag
function vim.cmd.ta(...)end

-- create new tab when opening new window
function vim.cmd.tab(...)end

-- go to previous tab page
function vim.cmd.tabN(...)end

-- go to previous tab page
function vim.cmd.tabNext(...)end

-- close current tab page
function vim.cmd.tabc(...)end

-- close current tab page
function vim.cmd.tabclose(...)end

-- execute command in each tab page
function vim.cmd.tabdo(...)end

-- edit a file in a new tab page
function vim.cmd.tabe(...)end

-- edit a file in a new tab page
function vim.cmd.tabedit(...)end

-- find file in 'path', edit it in a new tab page
function vim.cmd.tabf(...)end

-- find file in 'path', edit it in a new tab page
function vim.cmd.tabfind(...)end

-- go to first tab page
function vim.cmd.tabfir(...)end

-- go to first tab page
function vim.cmd.tabfirst(...)end

-- go to last tab page
function vim.cmd.tabl(...)end

-- go to last tab page
function vim.cmd.tablast(...)end

-- move tab page to other position
function vim.cmd.tabm(...)end

-- move tab page to other position
function vim.cmd.tabmove(...)end

-- go to next tab page
function vim.cmd.tabn(...)end

-- edit a file in a new tab page
function vim.cmd.tabnew(...)end

-- go to next tab page
function vim.cmd.tabnext(...)end

-- close all tab pages except the current one
function vim.cmd.tabo(...)end

-- close all tab pages except the current one
function vim.cmd.tabonly(...)end

-- go to previous tab page
function vim.cmd.tabp(...)end

-- go to previous tab page
function vim.cmd.tabprevious(...)end

-- go to first tab page
function vim.cmd.tabr(...)end

-- go to first tab page
function vim.cmd.tabrewind(...)end

-- list the tab pages and what they contain
function vim.cmd.tabs(...)end

-- jump to tag
function vim.cmd.tag(...)end

-- show the contents of the tag stack
function vim.cmd.tags(...)end

-- change directory for tab page
function vim.cmd.tc(...)end

-- change directory for tab page
function vim.cmd.tcd(...)end

-- change directory for tab page
function vim.cmd.tch(...)end

-- change directory for tab page
function vim.cmd.tchdir(...)end

-- open a terminal buffer
function vim.cmd.te(...)end

-- open a terminal buffer
function vim.cmd.terminal(...)end

-- jump to first matching tag
function vim.cmd.tf(...)end

-- jump to first matching tag
function vim.cmd.tfirst(...)end

-- throw an exception
function vim.cmd.th(...)end

-- throw an exception
function vim.cmd.throw(...)end

-- like ":tselect", but jump directly when there
function vim.cmd.tj(...)end

-- like ":tselect", but jump directly when there
function vim.cmd.tjump(...)end

-- jump to last matching tag
function vim.cmd.tl(...)end

-- jump to last matching tag
function vim.cmd.tlast(...)end

-- add menu for |Terminal-mode|
function vim.cmd.tlm(...)end

-- add menu for |Terminal-mode|
function vim.cmd.tlmenu(...)end

-- like ":noremenu" but for |Terminal-mode|
function vim.cmd.tln(...)end

-- like ":noremenu" but for |Terminal-mode|
function vim.cmd.tlnoremenu(...)end

-- remove menu for |Terminal-mode|
function vim.cmd.tlu(...)end

-- remove menu for |Terminal-mode|
function vim.cmd.tlunmenu(...)end

-- define menu tooltip
function vim.cmd.tm(...)end

-- like ":map" but for |Terminal-mode|
function vim.cmd.tma(...)end

-- like ":map" but for |Terminal-mode|
function vim.cmd.tmap(...)end

-- remove all mappings for |Terminal-mode|
function vim.cmd.tmapc(...)end

-- remove all mappings for |Terminal-mode|
function vim.cmd.tmapclear(...)end

-- define menu tooltip
function vim.cmd.tmenu(...)end

-- jump to next matching tag
function vim.cmd.tn(...)end

-- jump to next matching tag
function vim.cmd.tnext(...)end

-- like ":noremap" but for |Terminal-mode|
function vim.cmd.tno(...)end

-- like ":noremap" but for |Terminal-mode|
function vim.cmd.tnoremap(...)end

-- make split window appear at top or far left
function vim.cmd.to(...)end

-- make split window appear at top or far left
function vim.cmd.topleft(...)end

-- jump to previous matching tag
function vim.cmd.tp(...)end

-- jump to previous matching tag
function vim.cmd.tprevious(...)end

-- jump to first matching tag
function vim.cmd.tr(...)end

-- jump to first matching tag
function vim.cmd.trewind(...)end

-- add or remove file from trust database
function vim.cmd.trust(...)end

-- execute commands, abort on error or exception
function vim.cmd.try(...)end

-- list matching tags and select one
function vim.cmd.ts(...)end

-- list matching tags and select one
function vim.cmd.tselect(...)end

-- remove menu tooltip
function vim.cmd.tu(...)end

-- like ":unmap" but for |Terminal-mode|
function vim.cmd.tunma(...)end

-- like ":unmap" but for |Terminal-mode|
function vim.cmd.tunmap(...)end

-- remove menu tooltip
function vim.cmd.tunmenu(...)end

-- undo last change(s)
function vim.cmd.u(...)end

-- remove abbreviation
function vim.cmd.una(...)end

-- remove abbreviation
function vim.cmd.unabbreviate(...)end

-- undo last change(s)
function vim.cmd.undo(...)end

-- join next change with previous undo block
function vim.cmd.undoj(...)end

-- join next change with previous undo block
function vim.cmd.undojoin(...)end

-- list leafs of the undo tree
function vim.cmd.undol(...)end

-- list leafs of the undo tree
function vim.cmd.undolist(...)end

-- open a window for each loaded file in the
function vim.cmd.unh(...)end

-- open a window for each loaded file in the
function vim.cmd.unhide(...)end

-- delete variable
function vim.cmd.unl(...)end

-- delete variable
function vim.cmd.unlet(...)end

-- unlock variables
function vim.cmd.unlo(...)end

-- unlock variables
function vim.cmd.unlockvar(...)end

-- remove mapping
function vim.cmd.unm(...)end

-- remove mapping
function vim.cmd.unmap(...)end

-- remove menu
function vim.cmd.unme(...)end

-- remove menu
function vim.cmd.unmenu(...)end

-- run a command not silently
function vim.cmd.uns(...)end

-- run a command not silently
function vim.cmd.unsilent(...)end

-- write buffer if modified
function vim.cmd.up(...)end

-- write buffer if modified
function vim.cmd.update(...)end

-- execute commands for not matching lines
function vim.cmd.v(...)end

-- print version number and other info
function vim.cmd.ve(...)end

-- execute command with 'verbose' set
function vim.cmd.verb(...)end

-- execute command with 'verbose' set
function vim.cmd.verbose(...)end

-- print version number and other info
function vim.cmd.version(...)end

-- make following command split vertically
function vim.cmd.vert(...)end

-- make following command split vertically
function vim.cmd.vertical(...)end

-- execute commands for not matching lines
function vim.cmd.vglobal(...)end

-- same as ":edit", but turns off "Ex" mode
function vim.cmd.vi(...)end

-- edit a file read-only
function vim.cmd.vie(...)end

-- edit a file read-only
function vim.cmd.view(...)end

-- search for pattern in files
function vim.cmd.vim(...)end

-- search for pattern in files
function vim.cmd.vimgrep(...)end

-- like :vimgrep, but append to current list
function vim.cmd.vimgrepa(...)end

-- like :vimgrep, but append to current list
function vim.cmd.vimgrepadd(...)end

-- same as ":edit", but turns off "Ex" mode
function vim.cmd.visual(...)end

-- overview of Normal mode commands
function vim.cmd.viu(...)end

-- overview of Normal mode commands
function vim.cmd.viusage(...)end

-- like ":map" but for Visual+Select mode
function vim.cmd.vm(...)end

-- like ":map" but for Visual+Select mode
function vim.cmd.vmap(...)end

-- remove all mappings for Visual+Select mode
function vim.cmd.vmapc(...)end

-- remove all mappings for Visual+Select mode
function vim.cmd.vmapclear(...)end

-- add menu for Visual+Select mode
function vim.cmd.vme(...)end

-- add menu for Visual+Select mode
function vim.cmd.vmenu(...)end

-- like ":noremap" but for Visual+Select mode
function vim.cmd.vn(...)end

-- create a new empty window, vertically split
function vim.cmd.vne(...)end

-- create a new empty window, vertically split
function vim.cmd.vnew(...)end

-- like ":noremap" but for Visual+Select mode
function vim.cmd.vnoremap(...)end

-- like ":noremenu" but for Visual+Select mode
function vim.cmd.vnoreme(...)end

-- like ":noremenu" but for Visual+Select mode
function vim.cmd.vnoremenu(...)end

-- split current window vertically
function vim.cmd.vs(...)end

-- split current window vertically
function vim.cmd.vsplit(...)end

-- like ":unmap" but for Visual+Select mode
function vim.cmd.vu(...)end

-- like ":unmap" but for Visual+Select mode
function vim.cmd.vunmap(...)end

-- remove menu for Visual+Select mode
function vim.cmd.vunme(...)end

-- remove menu for Visual+Select mode
function vim.cmd.vunmenu(...)end

-- write to a file
function vim.cmd.w(...)end

-- write to a file and go to previous file in
function vim.cmd.wN(...)end

-- write to a file and go to previous file in
function vim.cmd.wNext(...)end

-- write all (changed) buffers
function vim.cmd.wa(...)end

-- write all (changed) buffers
function vim.cmd.wall(...)end

-- execute loop for as long as condition met
function vim.cmd.wh(...)end

-- execute loop for as long as condition met
vim.cmd["while"] = function(...)end

-- get or set window size (obsolete)
function vim.cmd.wi(...)end

-- execute a Window (CTRL-W) command
function vim.cmd.winc(...)end

-- execute a Window (CTRL-W) command
function vim.cmd.wincmd(...)end

-- execute command in each window
function vim.cmd.windo(...)end

-- get or set window position
function vim.cmd.winp(...)end

-- get or set window position
function vim.cmd.winpos(...)end

-- get or set window size (obsolete)
function vim.cmd.winsize(...)end

-- write to a file and go to next file in
function vim.cmd.wn(...)end

-- write to a file and go to next file in
function vim.cmd.wnext(...)end

-- write to a file and go to previous file in
function vim.cmd.wp(...)end

-- write to a file and go to previous file in
function vim.cmd.wprevious(...)end

-- write to a file and quit window or Vim
function vim.cmd.wq(...)end

-- write all changed buffers and quit Vim
function vim.cmd.wqa(...)end

-- write all changed buffers and quit Vim
function vim.cmd.wqall(...)end

-- write to a file
function vim.cmd.write(...)end

-- write to ShaDa file
function vim.cmd.wsh(...)end

-- write to ShaDa file
function vim.cmd.wshada(...)end

-- write undo information to a file
function vim.cmd.wu(...)end

-- write undo information to a file
function vim.cmd.wundo(...)end

-- write if buffer changed and close window
function vim.cmd.x(...)end

-- same as ":wqall"
function vim.cmd.xa(...)end

-- same as ":wqall"
function vim.cmd.xall(...)end

-- write if buffer changed and close window
function vim.cmd.xit(...)end

-- like ":map" but for Visual mode
function vim.cmd.xm(...)end

-- like ":map" but for Visual mode
function vim.cmd.xmap(...)end

-- remove all mappings for Visual mode
function vim.cmd.xmapc(...)end

-- remove all mappings for Visual mode
function vim.cmd.xmapclear(...)end

-- add menu for Visual mode
function vim.cmd.xme(...)end

-- add menu for Visual mode
function vim.cmd.xmenu(...)end

-- like ":noremap" but for Visual mode
function vim.cmd.xn(...)end

-- like ":noremap" but for Visual mode
function vim.cmd.xnoremap(...)end

-- like ":noremenu" but for Visual mode
function vim.cmd.xnoreme(...)end

-- like ":noremenu" but for Visual mode
function vim.cmd.xnoremenu(...)end

-- like ":unmap" but for Visual mode
function vim.cmd.xu(...)end

-- like ":unmap" but for Visual mode
function vim.cmd.xunmap(...)end

-- remove menu for Visual mode
function vim.cmd.xunme(...)end

-- remove menu for Visual mode
function vim.cmd.xunmenu(...)end

-- yank lines into a register
function vim.cmd.y(...)end

-- yank lines into a register
function vim.cmd.yank(...)end

-- print some lines
function vim.cmd.z(...)end

