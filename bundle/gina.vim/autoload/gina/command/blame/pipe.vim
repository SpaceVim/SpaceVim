let s:KEYWORDS = [
      \ 'author-mail',
      \ 'author-time',
      \ 'author-tz',
      \ 'author',
      \ 'committer-mail',
      \ 'committer-time',
      \ 'committer-tz',
      \ 'committer',
      \ 'summary',
      \ 'previous',
      \ 'filename',
      \ 'boundary',
      \]
call map(
      \ s:KEYWORDS,
      \ '[v:val, len(v:val), substitute(v:val, ''-'', ''_'', ''g'')]',
      \)

function! gina#command#blame#pipe#incremental() abort
  let parser_pipe = deepcopy(s:parser_pipe)
  let parser_pipe.revisions = {}
  let parser_pipe.chunks = []
  let parser_pipe._stdout = ['']
  let parser_pipe._stderr = ['']
  let parser_pipe._chunk = {}
  return parser_pipe
endfunction


" Parser pipe ----------------------------------------------------------------
function! s:_parser_pipe_on_stdout(data) abort dict
  let self._stdout[-1] .= a:data[0]
  call extend(self._stdout, a:data[1:])
endfunction

function! s:_parser_pipe_on_stderr(data) abort dict
  let self._stderr[-1] .= a:data[0]
  call extend(self._stderr, a:data[1:])
endfunction

function! s:_parser_pipe_on_exit(exitval) abort dict
  call call(s:original_pipe.on_exit, [a:exitval], self)
  if a:exitval
    throw gina#process#errormsg({
          \ 'args': self.args,
          \ 'content': self._stderr,
          \})
  endif
  " Parse records to create chunks
  call map(filter(self._stdout, '!empty(v:val)'), 's:parse(self, v:val)')
  " Sort chunks and assign indices
  call sort(self.chunks, { a, b -> a.lnum - b.lnum })
  call map(self.chunks, 'extend(v:val, {''index'': v:key})')
endfunction

let s:original_pipe = gina#process#pipe#default()
let s:parser_pipe = extend(deepcopy(s:original_pipe), {
      \ 'on_stdout': function('s:_parser_pipe_on_stdout'),
      \ 'on_stderr': function('s:_parser_pipe_on_stderr'),
      \ 'on_exit': function('s:_parser_pipe_on_exit'),
      \})


" Private --------------------------------------------------------
function! s:parse(pipe, record) abort
  let chunk = a:pipe._chunk
  let revisions = a:pipe.revisions
  call extend(chunk, s:parse_record(a:record))
  if !has_key(chunk, 'filename')
    return
  endif
  if !has_key(revisions, chunk.revision)
    let revisions[chunk.revision] = chunk
    let chunk = {
          \ 'filename': chunk.filename,
          \ 'revision': chunk.revision,
          \ 'lnum_from': chunk.lnum_from,
          \ 'lnum': chunk.lnum,
          \ 'nlines': chunk.nlines,
          \}
  endif
  call add(a:pipe.chunks, chunk)
  let a:pipe._chunk = {}
endfunction

function! s:parse_record(record) abort
  for [prefix, length, vname] in s:KEYWORDS
    if a:record[:length-1] ==# prefix
      return {vname : a:record[length+1:]}
    endif
  endfor
  let terms = split(a:record)
  let nterms = len(terms)
  if nterms >= 3
    return {
          \ 'revision': terms[0],
          \ 'lnum_from': terms[1] + 0,
          \ 'lnum': terms[2] + 0,
          \ 'nlines': nterms == 3 ? 1 : (terms[3] + 0),
          \}
  endif
  throw gina#core#revelator#critical(printf(
        \ 'Failed to parse a record "%s"',
        \ a:record,
        \))
endfunction
