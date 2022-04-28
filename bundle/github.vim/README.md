# GitHub.vim

> Another github v3 api implemented in viml

[![Build Status](https://travis-ci.org/wsdjeg/GitHub.vim.svg?branch=master)](https://travis-ci.org/wsdjeg/GitHub.vim)
[![codecov](https://codecov.io/gh/wsdjeg/GitHub.vim/branch/master/graph/badge.svg)](https://codecov.io/gh/wsdjeg/GitHub.vim)
[![Gitter](https://badges.gitter.im/wsdjeg/GitHub.vim.svg)](https://gitter.im/wsdjeg/GitHub.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Version 0.1.2](https://img.shields.io/badge/version-0.1.1-yellow.svg?style=flat-square)](https://github.com/wsdjeg/GitHub.vim/releases)
[![Support Vim 7.4 or above](https://img.shields.io/badge/support-%20Vim%207.4%20or%20above-yellowgreen.svg?style=flat-square)](https://github.com/vim/vim-win32-installer)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20github-orange.svg?style=flat-square)](doc/github.txt)

## Intro

This is a viml library to access the Github API v3. With it, you can manage
Github resources (repositories, user profiles, organizations, etc.) from viml
scripts.

## Install

It is easy to install the lib via [dein](https://github.com/Shougo/dein.vim):

```vim
call dein#add('wsdjeg/GitHub.vim')
```

**NOTE:** For unauthenticated requests, the rate limit allows for up to 60 requests per hour. Unauthenticated requests are associated with the originating IP address, and not the user making requests.Increasing the unauthenticated rate limit, you need [Create OAuth app](https://github.com/settings/applications/new), and set EVN: `CLIENTID` and `CLIENTSECRET`.

## Usage

create issue:

```viml
function! CreateIssue(owner, repo) abort
    let username = input('your github username:')
    let password = input('your github password:')
    let title = input('Issue title: ')
    let issue = {
                \ 'title': title,
                \ 'body': s:body(),
                \ }
    let response = github#api#issues#Create(a:owner, a:repo,
                \ username, password, issue)
    if !empty(response)
        echomsg 'Create successed! ' . response.url
    else
        echom 'Create failed!'
    endif
endfunction

func! s:body()
    return 'Testting Github.vim...'
endf
```
