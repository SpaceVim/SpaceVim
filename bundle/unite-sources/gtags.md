# unite-gtags

## Introduction

`unite-gtags` is a [unite.vim](https://github.com/Shougo/unite.vim)'s source.
Execute `global` command and display the result in Unite interface.

## Install

Install the distributed files into your Vim script directory which is usually
`$HOME/.vim`,  or `$HOME/vimfiles` on Windows.

## Prerequisite

GNU GLOBAL (6.0 or later) must be installed your system and the executable binary `global` on your PATH.

## Usage

This source provides following sub commands for `Unite`

- `Unite gtags/context`
- `Unite gtags/ref`
- `Unite gtags/def`
- `Unite gtags/grep`
- `Unite gtags/completion`
- `Unite gtags/file`
- `Unite gtags/path`

### Unite gtags/context

`Unite gtags/context` lists *the references or definitions* of a word.
It executes `global --from-here=<location of cursor> -qe <word on cursor>`

When your cursor is on a definition Unite lists references of it,
otherwise list definitions.

### Unite gtags/ref

`Unite gtags/ref` lists *references* of a word.
(It executes `global -qrs -e <pattern>` in internal.)

You can specify `<pattern>` as an argument `:Unite gtags/ref:<pattern>`.
When exeucte this command with no arguments `:Unite gtags/ref`, unite-gtags uses `expand('<cword>')`  as pattern.

### Unite gtags/def

`Unite gtags/def` lists *definitions* of a word.
(It executes `global -qd -e <pattern>` in internal.)

You can specify `<pattern>` as an argument `:Unite gtags/def:<pattern>`.
When exeucte this command with no arguments `:Unite gtags/def`, unite-gtags uses `expand('\<cword\>')`  as pattern.

### Unite gtags/grep

`Unite gtags/grep` lists *grep result* of a word.
(It executes `global -qg -e <pattern>` in internal.)

You can specify `<pattern>` as an argument `:Unite gtags/grep:<pattern>`.
When exeucte Unite with no arguments `:Unite gtags/grep`, input prompt is shown.
unite-gtags uses the input as `<pattern>`.

### Unite gtags/completion

`Unite gtags/completion` lists all tokens in GTAGS.
It executes `global -c` and show results.

Default action on the Unite item is `list_references`.
`list_definitions` is also available.

### Unite gtags/file

`Unite gtags/file` lists current file's tokens in GTAGS.
It executes `global -f` and show results.

You can specify `<pattern>` as an argument `:Unite gtags/file:<pathname>`.
When exeucte this command with no arguments `:Unite gtags/file`, unite-gtags uses `buffer_name("%")` as filepath.

### Unite gtags/path

`Unite gtags/path` lists all paths in GTAGS.
It executes `global -P` and show results.

You can specify `<pattern>` as an argument `:Unite gtags/path:<pattern>`.
When exeucte Unite with no arguments `:Unite gtags/path`, all paths is shown.

## Configuration

### Project Configuration

Set project specific configuration. Project is specified with `$GTAGSROOT` if configured,
otherwise with result of fnamemodify('.', ':p'), usually current dir described as absolute path '/' added.

Following items are configured for each project:

- `treelize (0 or 1)`: show Unite's items in tree format or not
- `absolute_path (0 or 1)`: add `-a` option to global command or not
- `gtags_libpath (list of string)`: join with ':' and use it as `GTAGSLIBPATH`
- `through_all_tags (0 or 1)`: add `--through` option to global command or not

You can set default configuration with specifying `_` as project name.

Configuration Example:

    g:unite_source_gtags_project_config = {
      \ '/home/foo/project1/': { 'treelize': 0 },
      \ '_':                   { 'treelize': 1 }
      \ }
    " specify your project path as key.
    " '_' in key means default configuration.

#### treelize

When `treelize = 1`, unite result is grouped by filepath and enable you to select a candidate with tree like interface.
This format is effective when filepath is too long string.

Default format:

    sample1/foo.rb  |2|  def hoge
    sample1/foo.rb  |6|    hoge
    sample2/bar.rb  |4|    hoge

Tree format:

    [path] sample1/foo.rb
    |2|  def hoge
    |6|    hoge
    [path] sample2/bar.rb
    |4|    hoge

#### absolute\_path

When `absolute_path = 1`, `unite-gtags` add `-a` option to `global` command.
Path in unite's items changes to absolute path format.

Relative path (default):

    sample1/foo.rb |2|   def hoge
    sample1/foo.rb |6|     hoge
    sample2/bar.rb |4|     hoge

Absolute path:

    /home/foo/sample1/foo.rb |2|   def hoge
    /home/foo/sample1/foo.rb |6|     hoge
    /home/foo/sample2/bar.rb |4|     hoge

#### gtags\_libpath

When `gtags_libpath` is specified with list of string,
unite-gtags joins them with ':' and use the joined string as `GTAGSLIBPATH`.
(This feature is only available in \*nix system.)

Example:

When configure gtags\_libpath with following

    let g:unite_source_gtags_project_config[<cur_dir>] = {
    \ 'gtags_libpath': ['/usr/include/', '/home/foo/include/']
    \ }

`unite-gtags` executes `global` with temporary environment variable `GTAGSLIBPATH` like below

    GTAGSLIBPATH=$GTAGSLIBPATH:/usr/include/:/home/foo/include/ global ...

#### through\_all\_tags

By default, a search is ended without go through all the tag files listed in GTAGSLIBPATH when tags are found in a project's tag file. This behavior may be unintended if there are definitions with the same name as the one defined in a project.

When `through_all_tags = 1`, `unite-gtags` adds `--through` option to `global` command and it makes a search go through all the tag files listed in GTAGSLIBPATH. This option is ignored when either `-s`, `-r` or `-l` option is specified.

### Syntax Highlight

* `uniteSource__Gtags_LineNr`

    Highlight for Line number (default linked to `LineNr`).

* `uniteSource__Gtags_Path`

    Highlight for filepath (default linked to `File`).

