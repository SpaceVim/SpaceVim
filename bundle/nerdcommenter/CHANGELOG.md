# Changelog

### 2.5.2

* Minor update to include new file types contributed by the community over the last few months.
* Also adds a customization option to the sexy comment style.

### 2.5.1

* Minor update release that adds a few new contributed filetypes and normalizes the code format a little bit.

### 2.5.0

* Add lots of new contributed file types, cleanup some odds and ends.
* Bump "release" for the sake of plugin managers still not tracking master.

### 2.4.0

* Bump release number for the benefit of plugin managers that update to tags

### 2.3.0

*  remove all filetypes which have a &commentstring in the standard vim runtime
for vim > 7.0 unless the script stores an alternate set of delimiters
*  make the script complain if the user doesn't have filetype plugins enabled
*  use |<Leader>| instead of comma to start the default mappings
*  fix a couple of bugs with sexy comments - thanks to Tim Smart
*  lots of refactoring

### 2.2.2

*  remove the NERDShutup option and the message is suppresses, this makes the plugin silently rely on &commentstring for unknown filetypes.
*  add support for dhcpd, limits, ntp, resolv, rgb, sysctl, udevconf and udevrules. Thanks to Thilo Six.
*  match filetypes case insensitively
*  add support for mp (metapost), thanks to Andrey Skvortsov.
*  add support for htmlcheetah, thanks to Simon Hengel.
*  add support for javacc, thanks to Matt Tolton.
*  make <%# %> the default delims for eruby, thanks to tpope.
*  add support for javascript.jquery, thanks to Ivan Devat.
*  add support for cucumber and pdf. Fix sass and railslog delims, thanks to tpope

### 2.2.1

*  add support for newlisp and clojure, thanks to Matthew Lee Hinman.
*  fix automake comments, thanks to Elias Pipping
*  make haml comments default to -# with / as the alternative delimiter, thanks to tpope
*  add support for actionscript and processing thanks to Edwin Benavides
*  add support for ps1 (powershell), thanks to Jason Mills
*  add support for hostsaccess, thanks to Thomas Rowe
*  add support for CVScommit
*  add support for asciidoc, git and gitrebase. Thanks to Simon Ruderich.
*  use # for gitcommit comments, thanks to Simon Ruderich.
*  add support for mako and genshi, thanks to Keitheis.
*  add support for conkyrc, thanks to David
*  add support for SVNannotate, thanks to Miguel Jaque Barbero.
*  add support for sieve, thanks to Stefan Walk
*  add support for objj, thanks to Adam Thorsen.

### 2.2.0

*  rewrote the mappings system to be more "standard".
*  removed all the mapping options. Now, mappings to <plug> mappings are used
*  see :help NERDComMappings, and :help NERDCreateDefaultMappings for more info
*  remove "prepend comments" and "right aligned comments".
*  add support for applescript, calbire, man, SVNcommit, potwiki, txt2tags and SVNinfo. Thanks to nicothakis, timberke, sgronblo, mntnoe, Bernhard Grotz, John O'Shea, François and Giacomo Mariani respectively.
*  bugfix for haskell delimiters. Thanks to mntnoe.

### 2.1.18

*  add support for llvm. Thanks to nicothakis.
*  add support for xquery. Thanks to Phillip Kovalev.

### 2.1.17

*  fixed haskell delimiters (hackily). Thanks to Elias Pipping.
*  add support for mailcap. Thanks to Pascal Brueckner.
*  add support for stata. Thanks to Jerónimo Carballo.
*  applied a patch from ewfalor to fix an error in the help file with the NERDMapleader doc
*  disable the insert mode ctrl-c mapping by default, see :help NERDCommenterInsert if you wish to restore it
