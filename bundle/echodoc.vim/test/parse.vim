" set verbose=1
scriptencoding utf8

let s:assert = themis#helper('assert')
let s:suite = themis#suite('parse')

function! s:suite.parse_funcs() abort
  let comp = echodoc#util#parse_funcs('void main(int argc)', '')[0]
  call s:assert.equals(comp['name'], 'main')
  call s:assert.equals(comp['args'], ['int argc'])
  let comp = echodoc#util#parse_funcs(
        \ 'int32_t get (*)(void *const, const size_t)', '')[0]
  call s:assert.equals(comp['name'], 'get')
  call s:assert.equals(comp['args'], ['void *const', ' const size_t'])
  let comp = echodoc#util#parse_funcs(
        \ 'void process(std::array<T,size> array){...}', '')[0]
  call s:assert.equals(comp['name'], 'process')
  call s:assert.equals(comp['args'], ['std::array<...> array'])

  let &filetype = 'rust'
  let comp = echodoc#util#parse_funcs(
        \ "fn from(s: &'s str) -> String", 'rust')[0]
  call s:assert.equals(comp['name'], "from")
  call s:assert.equals(comp['args'], ["s: &'s str"])
  let comp = echodoc#util#parse_funcs(
        \ 'remove_child<T: INode>(&self, child: &T) -> Result', '')[0]
  call s:assert.equals(comp['name'], "remove_child")
  call s:assert.equals(comp['args'], ['&self', ' child: &T'])
  let comp = echodoc#util#parse_funcs(
        \ 'fn create<P: hoge>(path: P) -> io::Result<File>', 'rust')[0]
  call s:assert.equals(comp['name'], "create")
  call s:assert.equals(comp['args'], ['path: P'])
  let comp = echodoc#util#parse_funcs(
        \ 'fn create<P: AsRef<Path>>(path: P) -> io::Result<File>', 'rust')[0]
  call s:assert.equals(comp['name'], "create")
  call s:assert.equals(comp['args'], ['path: P'])

  let comp = echodoc#util#parse_funcs('a(n, m)', '')[0]
  call s:assert.equals(comp['name'], "a")
  call s:assert.equals(comp['args'], ['n', ' m'])

  let comp = echodoc#util#parse_funcs(
        \ 'send(&self, T:t)', 'rust')[0]
  call s:assert.equals(comp['name'], "send")
  call s:assert.equals(comp['args'], ['T:t'])
endfunction
