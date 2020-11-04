"=============================================================================
" $Id: topological-sort.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:         tests/lh/topological-sort.vim                            {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://code.google.com/p/lh-vim/>
" Version:      2.2.1
" Created:      17th Apr 2008
" Last Update:  $Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:  «description»
"
"------------------------------------------------------------------------
" Installation: «install details»
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
UTSuite [lh-vim-lib] topological sort

" Fully defineds DAGs {{{1

" A Direct Acyclic Graph {{{2
let s:dag1 = {}
let s:dag1[7] = [11, 8]
let s:dag1[5] = [11]
let s:dag1[3] = [8, 10]
let s:dag1[11] = [2, 9, 10]
let s:dag1[8] = [9]

" A Direct Cyclic Graph {{{2
let s:dcg1 = deepcopy(s:dag1)
let s:dcg1[9] = [11]

" Check routine: are the elements correctly sorted? {{{2
function! s:DoTestOrder(elements)
  Assert! len(a:elements) == 8
  Assert index(a:elements, 7) < index(a:elements, 11)
  Assert index(a:elements, 7) < index(a:elements, 8)
  Assert index(a:elements, 5) < index(a:elements, 11)
  Assert index(a:elements, 3) < index(a:elements, 8)
  Assert index(a:elements, 3) < index(a:elements, 10)
  Assert index(a:elements, 11) < index(a:elements, 2)
  Assert index(a:elements, 11) < index(a:elements, 9)
  Assert index(a:elements, 11) < index(a:elements, 10)
  Assert index(a:elements, 8) < index(a:elements, 9)
endfunction

" Test DAG1 {{{2
function! s:TestDAG_depth()
  let res = lh#graph#tsort#depth(s:dag1, [3, 5,7])
  call s:DoTestOrder(res)
  echo "D(s:dag1)=".string(res)
endfunction

function! s:TestDAG_breadth()
  let res = lh#graph#tsort#breadth(s:dag1, [3, 5,7])
  call s:DoTestOrder(res)
  echo "B(s:dag1)=".string(res)
endfunction

" Test DCG1 {{{2
function! s:TestDCG_depth()
  let expr = 'lh#graph#tsort#depth('.string(s:dcg1).', [3, 5,7])'
  Assert should#throw(expr, 'Tsort: cyclic graph detected')
endfunction

function! s:TestDCG_breadth()
  let expr = 'lh#graph#tsort#breadth('.string(s:dcg1).', [3, 5,7])'
  Assert should#throw(expr, 'Tsort: cyclic graph detected')
endfunction

" Lazzy Evaluated DAGs {{{1

" Emulated lazzyness {{{2
" The time-consumings evaluation function
let s:called = 0
function! Fetch(node)
  let s:called += 1
  return has_key(s:dag1, a:node) ? (s:dag1[a:node]) : []
endfunction

" Test Fetch on a DAG {{{2
function! s:TestDAG_fetch()
  let s:called = 0
  let res = lh#graph#tsort#depth(function('Fetch'), [3,5,7])
  call s:DoTestOrder(res)
  echo "D(fetch)=".string(res)
  echo "Fetch has been evaluated ".s:called." times / ".len(res)
  Assert s:called == len(res)
endfunction


" Setup/Teardown functions {{{1
" display the test name before each assertion
function! s:Setup()
  if exists('g:UT_print_test')
    let s:old_print_test = g:UT_print_test
  endif
  let g:UT_print_test = 1
endfunction

function! s:Teardown()
  if exists('s:old_print_test')
    let g:UT_print_test = s:old_print_test 
    unlet s:old_print_test
  else
    unlet g:UT_print_test
  endif
endfunction


" }}}1
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:

