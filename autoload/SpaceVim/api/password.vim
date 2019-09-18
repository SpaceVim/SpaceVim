"=============================================================================
" password.vim --- SpaceVim password API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section password, api-password
" @parentsection api
" provides some functions to generate password
"
" generate_simple({len})
"
"   generate simple password
"    
" generate_strong({len})
"
"   generate strong password
"
" generate_paranoid({len})
"
"   generate paranoid password
"
" generate_numeric({len})
" 
"   generate numeric password
"
" generate_phonetic({len})
"
"   generate phonetic password



let s:self = {}

let s:NUMBER = SpaceVim#api#import('data#number')
let s:STRING = SpaceVim#api#import('data#string')

function! s:self.generate_simple(len) abort
    let temp = s:STRING.string2chars('abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ')
    let ps = []
    " random(0,len_temp)
    let i = 0
    while i < str2nr(a:len)
        call add(ps, temp[s:NUMBER.random(0, len(temp))])
        let i += 1
    endwhile
    return join(ps, '')
endfunction

function! s:self.generate_strong(len) abort
    let temp = s:STRING.string2chars('abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_@!.^%,&-')
    let ps = []
    " random(0,len_temp)
    let i = 0
    while i < str2nr(a:len)
        call add(ps, temp[s:NUMBER.random(0, len(temp))])
        let i += 1
    endwhile
    return join(ps, '')
endfunction

function! s:self.generate_paranoid(len) abort
    let temp = s:STRING.string2chars('abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_-+=/?,.><[]{}~')
    let ps = []
    " random(0,len_temp)
    let i = 0
    while i < str2nr(a:len)
        call add(ps, temp[s:NUMBER.random(0, len(temp))])
        let i += 1
    endwhile
    return join(ps, '')
endfunction

function! s:self.generate_numeric(len) abort
    let temp = s:STRING.string2chars('0123456789')
    let ps = []
    " random(0,len_temp)
    let i = 0
    while i < str2nr(a:len)
        call add(ps, temp[s:NUMBER.random(0, len(temp))])
        let i += 1
    endwhile
    return join(ps, '')
endfunction

function! s:self.generate_phonetic(len) abort
    let temp_A = s:STRING.string2chars('eyuioa')
    let temp_B = s:STRING.string2chars('wrtpsdfghjkzxcvbnm')
    let temp_N = s:STRING.string2chars('123456789')
    let type = 1

    let ps = []
    " random(0,len_temp)
    let i = 0
    while i < str2nr(a:len)
        if type == 1
            call add(ps, temp_A[s:NUMBER.random(0, len(temp_A))])
            let type = 2
        elseif type == 2
            call add(ps, temp_B[s:NUMBER.random(0, len(temp_B))])
            let type = 3
        elseif type == 3
            call add(ps, temp_N[s:NUMBER.random(0, len(temp_N))])
            let type = 1
        endif
        let i += 1
    endwhile
    return join(ps, '')
endfunction

function! SpaceVim#api#password#get() abort
    return deepcopy(s:self)
endfunction
