function! python_imports#filename2module(filename)
  " Figure out the dotted module name of the given filename

  " Look at the file name of the module that contains this tag.  Find the
  " nearest parent directory that does not have __init__.py.  Assume it is
  " directly included in PYTHONPATH.
  let pkg = fnamemodify(a:filename, ":p")
  let root = fnamemodify(pkg, ":h")

  " normalize paths
  let pythonPathsNorm = []
  for path in g:pythonPaths
    let path_without_slash = substitute(expand(path), "/$", "", "")
    call add(pythonPathsNorm, path_without_slash)
  endfor

  let found_dir = ""
  let found_path = ""
  while 1
    if index(pythonPathsNorm, root) != -1
      let found_path = root
      break
    endif
    if found_dir == "" && !filereadable(root . "/__init__.py")
      let found_dir = root
      " note: can't break here!  PEP 420 implicit namespace packages don't have __init__.py,
      " so we might find the actual package root in a parent directory beyond this one, via pythonPathsNorm
    endif
    let newroot = fnamemodify(root, ":h")
    if newroot == root
      break
    endif
    let root = newroot
  endwhile
  if found_path != ""
    let root = found_path
  else
    let root = found_dir
  endif

  let pkg = strpart(pkg, strlen(root))
  " Convert the relative path into a Python dotted module name
  let pkg = substitute(pkg, "\\", "/", "g") " Handle Windows paths
  let pkg = substitute(pkg, "[.]py$", "", "")
  let pkg = substitute(pkg, ".__init__$", "", "")
  let pkg = substitute(pkg, "^/", "", "")
  let pkg = substitute(pkg, "^site-packages/", "", "")
  let pkg = substitute(pkg, "/", ".", "g")
  " Get rid of the last module name if it starts with an underscore, e.g.
  " zope.schema._builtinfields -> zope.schema
  let pkg = substitute(pkg, "[.]_[a-zA-Z0-9_]*$", "", "")
  return pkg
endfunction

function! python_imports#filename2package(filename)
  let module = python_imports#filename2module(a:filename)
  let pkg = python_imports#package_of(module)
  return pkg
endfunction

function! python_imports#package_of(module)
  let pkg = substitute(a:module, '[.]\=[^.]\+$', '', '')
  return pkg
endfunction

function! python_imports#is_stdlib_module(name)
  " Does a:name refer to a standard library module?

  if has_key(g:pythonBuiltinModules, a:name)
    return 1
  elseif g:pythonStdlibPath == ""
    return 0
  elseif filereadable(g:pythonStdlibPath . "/" . a:name . ".py")
    return 1
  elseif filereadable(g:pythonStdlibPath . "/" . a:name . "/__init__.py")
    return 1
  elseif filereadable(g:pythonStdlibPath . "/lib-dynload/" . a:name . ".so")
    return 1
  elseif filereadable(g:pythonStdlibPath . "/lib-dynload/" . a:name . g:pythonExtModuleSuffix)
    return 1
  else
    return 0
  endif
endfunction

function! python_imports#maybe_reload_config()
  if has('python') || has('python3')
    " XXX: wasteful -- I should check if the file's timestamp has changed
    " instead of parsing it every time
    pyx import python_imports
    pyx python_imports.parse_python_imports_cfg()
  endif
endfunction

function! python_imports#find_place_for_import(pkg, name)
  " Find the appropriate place to insert a "from pkg import name" line.
  " Moves the actual cursor in the actual Vim buffer.

  " Go to the top (use 'normal gg' because I want to set the ' mark)
  normal gg
  if getline(line(".")) =~ '^"""'
    keepjumps silent! /^"""/                 " Skip docstring, if it exists
  else
    keepjumps silent! /^"""/;/^"""/          " Skip docstring, if it exists
  endif
  keepjumps silent! /^import\|^from.*import/ " Find the first import statement
  nohlsearch
  if a:pkg == '__future__'
    return
  endif
  " Find the first empty line after that.  NOTE: DO NOT put any comments
  " on the line that says `normal`, or you'll get 24 extra spaces here
  if getline(line(".")) =~ 'import\|"""\|^#'
    keepjumps normal }
  endif
  " Try to find an existing import from the same module, and move to
  " the last one of these
  let pkg = a:pkg
  while pkg != ""
    let stmt = "from ".pkg." "      " look for an exact match first
    if search('^' . stmt, 'cnw')
        exec "keepjumps silent! /^".stmt."/;/^\\(".stmt."\\)\\@!/"
        nohlsearch
        break
    endif
    let stmt = "from ".pkg."."      " try siblings or subpackages
    if search('^' . stmt, 'cnw')
        exec "keepjumps silent! /^".stmt."/;/^\\(".stmt."\\)\\@!/"
        nohlsearch
        break
    endif
    " If not found, look for imports coming from containing packages
    if pkg =~ '[.]'
      let pkg = substitute(pkg, '[.][^.]*$', '', '')
    else
      break
    endif
  endwhile
endf

if v:version >= 801 || v:version == 800 && has("patch-499")
  function! s:taglist(tag, filename)
    return taglist(a:tag, a:filename)
  endf
else
  function! s:taglist(tag, filename)
    return taglist(a:tag)
  endf
endif

function! python_imports#import_name(name, here, stay)
  " Add an import statement for 'name'.  If 'here' is true, adds the statement
  " on the line above the cursor, if 'here' is false, adds the line to the top
  " of the current file.  If 'stay' is true, keeps cursor position, otherwise
  " jumps to the line containing the newly added import statement.

  call python_imports#maybe_reload_config()

  " If name is empty, pick up the word under cursor
  if a:name == ""
    let name = expand("<cword>")
  else
    let name = a:name
  endif

  let alias = l:name
  let l:name = get(g:pythonImportAliases, alias, alias)

  " Look for hardcoded names
  if has_key(g:pythonImports, l:name)
    let pkg = g:pythonImports[l:name]
  elseif python_imports#is_stdlib_module(l:name)
    let pkg = ''
  else
    " Let's see if we have one tag, or multiple tags (in which case we'll
    " let the user decide)
    let tag_rx = "^\\C" . l:name . "\\([.]py\\)\\=$"
    let found = s:taglist(tag_rx, expand("%"))
    if found == []
      " Give up and bail out
      echohl Error | echomsg "Tag not found:" l:name | echohl None
      return
    elseif len(found) == 1
      " Only one name found, we can skip the selection menu and the
      " whole costly procedure of opening split windows.
      let pkg = python_imports#filename2module(found[0].filename)
      if found[0].kind == 'F'
        " importing an entire module
        let pkg = python_imports#package_of(pkg)
      endif
    else
      " Try to jump to the tag in a new window
      let v:errmsg = ""
      let l:errmsg = ""
      let l:oldfile = expand('%')
      let l:oldswb = &switchbuf
      set switchbuf=split
      let l:oldwinnr = winnr()
      try
        exec "stjump /" . tag_rx
      catch
        let l:errmsg = v:errmsg
      finally
        let &switchbuf = l:oldswb
      endtry
      if l:errmsg != ""
        " Something bad happened (maybe the other file is opened in a
        " different vim instance and there's a swap file)
        if l:oldfile != expand('%')
          close
          exec l:oldwinnr "wincmd w"
        endif
        return
      endif
      if l:oldfile == expand('%')
        " Either the user aborted the tag jump, or the tag exists in
        " the same file, and therefore import is pointless
        return
      endif
      " Look at the file name of the module that contains this tag.  Find the
      " nearest parent directory that does not have __init__.py.  Assume it is
      " directly included in PYTHONPATH.
      let pkg = python_imports#filename2module(expand("%"))
      let nonfile_tags = found->filter({idx, val -> val.kind != 'F'})
      if expand("%:t") == l:name . ".py" && nonfile_tags == []
        let pkg = python_imports#package_of(pkg)
      endif
      " Close the window containing the tag
      close
      " Return to the right window
      exec l:oldwinnr "wincmd w"
    endif
  endif

  if pkg == ""
    let line_to_insert = 'import ' . l:name
  elseif pkg == "__future__" && l:name == "print"
    let line_to_insert = 'from __future__ import print_function'
  else
    let line_to_insert = 'from ' . pkg . ' import ' . l:name
  endif
  if l:alias != l:name
    let line_to_insert .= ' as ' . l:alias
  endif

  " Find the place for adding the import statement
  if !a:here
    if search('^' . line_to_insert . '$', 'bcnw')
      " import already exists
      redraw
      echomsg l:name . " is already imported"
      return
    endif
    call python_imports#find_place_for_import(pkg, l:name)
  endif
  " Find out the indentation of the current line
  let indent = matchstr(getline("."), "^[ \t]*\\%(>>> \\)\\=")
  " Check if we're using parenthesized imports already
  let prev_line = getline(line(".")-1)
  let stopline = 0
  if indent != "" && prev_line  == 'from ' . pkg . ' import ('
    if l:alias != l:name
      let line_to_insert = l:name . ' as ' . l:alias . ','
    else
      let line_to_insert = l:name . ','
    endif
    let stopline = search(")", "nW")
  elseif indent != "" && prev_line =~ '^from .* import ('
    silent! /)/+1
    nohlsearch
    if line(".") == line("$") && getline(line(".")-1) !~ ')'
      put =''
    endif
    let indent = ""
  endif
  let line_to_insert = indent . line_to_insert
  " Double check with indent / parenthesized form
  if !a:here && search('^' . line_to_insert . '$', 'cnw', stopline)
    " import already exists
    redraw
    echomsg l:name . " is already imported"
    return
  endif
  " Add the import statement
  put! =line_to_insert
  " Adjust import location with isort if possible
  if !a:here && g:pythonImportsUseAleFix && exists(":ALEFix") == 2
    ALEFix isort
  endif
  " Jump back if possible
  if a:stay
    normal ``
  endif
  " Refresh ALE because otherwise it gets all confused for a bit
  if exists(":ALELint") == 2
    if exists(":ALEResetBuffer") == 2
      ALEResetBuffer
    endif
    ALELint
  endif
endf
