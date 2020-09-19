# VIM Table Mode v4.7.1.1 [![Build Status](https://travis-ci.org/dhruvasagar/vim-table-mode.png?branch=master)](https://travis-ci.org/dhruvasagar/vim-table-mode)

An awesome automatic table creator & formatter allowing one to create neat
tables as you type.

## Getting Started 

### Installation

There are several ways to do this

1. I recommend installing <a
   href="https://github.com/Shougo/neobundle.vim">NeoBundle</a> and then just
   add `NeoBundle 'dhruvasagar/vim-table-mode'` to your ~/.vimrc

2. If you are using <a
   href="https://github.com/tpope/vim-pathogen">pathogen.vim</a>, then
   add a git submodule for your plugin:

```sh
$ cd ~/.vim
$ git submodule add git@github.com:dhruvasagar/vim-table-mode.git bundle/table-mode
```

3. Copy all files under autoload/, plugin/, doc/ to respective
   ~/.vim/autoload/, ~/.vim/plugin and ~/.vim/doc under UNIX or
   vimfiles/autoload/, vimfiles/plugin/ and vimfiles/doc under WINDOWS and
   restart VIM

### Creating table on-the-fly

To start using the plugin in the on-the-fly mode use `:TableModeToggle` mapped to <kbd>\<Leader\>tm</kbd> by default (which means <kbd>\\</kbd> <kbd>t</kbd> <kbd>m</kbd> if you didn't override the <Leader> by `:let mapleader = ','` to have <kbd>,</kbd> <kbd>t</kbd> <kbd>m</kbd>).

> Tip :
> You can use the following to quickly enable / disable table mode in insert
> mode by using `||` or `__` :
> ```vim
> function! s:isAtStartOfLine(mapping)
>   let text_before_cursor = getline('.')[0 : col('.')-1]
>   let mapping_pattern = '\V' . escape(a:mapping, '\')
>   let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
>   return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
> endfunction
> 
> inoreabbrev <expr> <bar><bar>
>           \ <SID>isAtStartOfLine('\|\|') ?
>           \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
> inoreabbrev <expr> __
>           \ <SID>isAtStartOfLine('__') ?
>           \ '<c-o>:silent! TableModeDisable<cr>' : '__'
> ```

Enter the first line, delimiting columns by the `|` symbol. The plugin reacts by inserting spaces between the text and the separator if you omit them:

    | name | address | phone |

In the second line (without leaving Insert mode), enter `|` twice. The plugin will write a properly formatted horizontal line:

    | name | address | phone |
    |------+---------+-------|

When you enter the subsequent lines, the plugin will automatically adjust the formatting to match the text you’re entering every time you press `|`:

    | name       | address | phone |
    |------------+---------+-------|
    | John Adams |

Go on until the table is ready:

    | name            | address                  | phone      |
    |-----------------+--------------------------+------------|
    | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
    |-----------------+--------------------------+------------|
    | Sherlock Holmes | 221B Baker Street        | 0987654321 |
    |-----------------+--------------------------+------------|

Then you can return to the first line and above it enter `||`:

    |-----------------+--------------------------+------------|
    | name            | address                  | phone      |
    |-----------------+--------------------------+------------|
    | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
    |-----------------+--------------------------+------------|
    | Sherlock Holmes | 221B Baker Street        | 0987654321 |
    |-----------------+--------------------------+------------|

Corner separators are adjustable:

For Markdown-compatible tables use

    let g:table_mode_corner='|'


    |-----------------|--------------------------|------------|
    | name            | address                  | phone      |
    |-----------------|--------------------------|------------|
    | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
    |-----------------|--------------------------|------------|
    | Sherlock Holmes | 221B Baker Street        | 0987654321 |
    |-----------------|--------------------------|------------|

To get ReST-compatible tables use

    let g:table_mode_corner_corner='+'
    let g:table_mode_header_fillchar='='


    +-----------------+--------------------------+------------+
    | name            | address                  | phone      |
    +=================+==========================+============+
    | John Adams      | 1600 Pennsylvania Avenue | 0123456789 |
    +-----------------+--------------------------+------------+
    | Sherlock Holmes | 221B Baker Street        | 0987654321 |
    +-----------------+--------------------------+------------+

Markdown and ReST filetypes have automatically configured corners.

   You can also define in a table header border how it's content should be
   aligned, whether center, right or left by using a `:` character defined by
   `g:table_mode_align_char` option.

If you manipulate the table when table mode is disabled or copy paste a table
from clipboard from outside and it ends up being misaligned, you can realign
it using `:TableModeRealign` or using the default mapping
<kbd>\<Leader\>tr</kbd> defined by `g:table_mode_relign_map` option.

### Formatting existing content into a table

   Table Mode wouldn't justify it's name if it didn't allow formatting
   existing content into a table. And it does as promised. Like table creation
   on the fly as you type, formatting existing content into a table is equally
   simple. You can visually select multiple lines and call `:Tableize` on it,
   or alternatively use the mapping <kbd>\<Leader\>tt</kbd> defined by the
   `g:table_mode_tableize_map` option which would convert CSV (Comma Separated
   Value) data into a table and use `,` defined by `g:table_mode_delimiter`
   option as the delimiter.

   If however you wish to use a different delimiter, you can use the command
   `:Tableize/{pattern}` in a similar fashion as you use tabular (eg.
   `:Tableize/;` uses ';' as the delimiter) or use the mapping <kbd>\<Leader\>T</kbd>
   defined by `g:table_mode_tableize_op_map` option which takes input in the
   cmd-line and uses the `{pattern}` input as the delimiter.

   `:Tableize` also accepts a range and so you can also call it by giving
   lines manually like `:line1,line2Tableize`, but this is not very intuitive.
   You can use the mapping <kbd>\<Leader\>T</kbd> with a `[count]` to apply it to the
   next `[count]` lines in standard vim style.

### Moving around 

   Now you can move between cells using table mode motions <kbd>[|</kbd>,
   <kbd>]|</kbd>, <kbd>{|</kbd> & <kbd>}|</kbd> to move left | right | up |
   down cells respectively. The left | right motions wrap around the table
   and move to the next | previous row after the last | first cell in the
   current row if one exists. 

### Manipulating Table

  - **Cell Text Object** :

      Tableize provides a text object for manipulating table cells. Following
      the vim philosophy the you have <kbd>i|</kbd> & <kbd>a|</kbd> for the
      inner and around (including the immidiate right table separator) the
      table cell.

  - **Delete Row** :

      You can use the <kbd>\<Leader\>tdd</kbd> mapping defined by the option
      `g:table_mode_delete_row_map` to delete the current table row (provided
      you are within a table row), this can be preceeded with a [count] to
      delete multiple rows just like you would with 'dd'.

  - **Delete Column** :

      You can use the <kbd>\<Leader\>tdc</kbd> mapping defined by the option
      `g:table_mode_delete_column_map` to delete the entire current column
      (provided you are within a table row), this can also be preceeded with a
      [count] to delete multiple columns.

  - **Insert Column** :

      You can use the <kbd>\<Leader\>tic</kbd> mapping defined by the option
      `g:table_mode_insert_column_after_map` to insert a column after the
      cursor (provided you are within a table row). Of course you can use the
      <kbd>\<Leader\>tiC</kbd> mapping defined by
      `g:table_mode_insert_column_before_map` to insert a column before the
      cursor. Both can also be preceeded with a [count] to insert multiple
      columns.

## Advanced Usage: Spreadsheet Capabilities

### Table Formulas

  Table Mode now has support for formulas like a spreadsheet. There are 2 ways
  of defining formulas :

  - You can add formulas using `:TableAddFormula` or the mapping <kbd>\<Leader\>tfa</kbd>
    defined by the option `g:table_mode_add_formula_map` from within a table
    cell, which will ask for input on the cmd-line with a `f=` prompt. The
    input formula will be appended to the formula line if one exists or a new
    one will be created with the input formula taking the current cell as the
    target cell. The formula line is evaluated immidiately to reflect the
    results.

  - You can directly add / manipulate formula expressions in the formula line.
    The formula line is a commented line right after the table, beginning with
    'tmf:' (table mode formula). eg) `# tmf: $3=$2*$1`.  You can add multiple
    formulas on the line separated with a ';' eg) `# tmf: $3=$2*$1;$4=$3/3.14`

  You can evaluate the formula line using `:TableEvalFormulaLine` or the
  mapping <kbd>\<Leader\>tfe</kbd> defined by the option `g:table_mode_eval_expr_map`
  from anywhere inside the table or while on the formula line.

  NOTE: You can now use the mapping <kbd>\<Leader\>t?</kbd>

### Formula Expressions

  Expressions are of the format `$target = formula`.

  - The `target` can be of 2 forms :

      - `$n`: This matches the table column number `n`. So the `formula` would
        be evaluated for each cell in that column and the result would be placed
        in it. You can use negative indice to represent column relative to the
        last, -1 being the last.

      - `$n,m`: This matches the table cell n,m (row, column). So in this case
        the formula would be evaluated and the result will be placed in this
        cell. You can also use negative values to refer to cells relative to
        the size, -1 being the last (row or column).

  - The `formula` can be a simple mathematical expression involving cells
    which are also defined by the same format as that of the target cell.  You
    can use all native vim functions within the formula. Apart from that table
    mode also provides 2 special functions `Sum` and `Average`. Both these
    functions take a range as input. A range can be of two forms :

      - `r1:r2`: This represents cells in the current column from row `r1`
        through `r2`. If `r2` is negative it represents `r2` rows above the
        current row (of the target cell).

      - `r1,c1:r2,c2`: This represents cells in the table from cell r1,c1
        through cell r2,c2 (row, column).

  - Examples :
      - `$2 = $1 * $1`
      - `$2 = pow($1, 5)` NOTE: Remember to put space between the $1, and 5
        here otherwise it will be treated like a table cell.
      - `$2 = $1 / $1,3`
      - `$1,2 = $1,1 * $1,1`
      - `$5,1 = Sum(1:-1)`
      - `$5,1 = float2nr(Sum(1:-1))`
      - `$5,3 = Sum(1,2:5,2)`
      - `$5,3 = Sum(1,2:5,2)/$5,1`
      - `$5,3 = Average(1,2:5,2)/$5,1`

## Demo

<a href="http://www.youtube.com/watch?v=9lVQ0VJY3ps"><img
src="https://raw.github.com/axil/vim-table-mode/master/youtube.png"/></a>

## Change Log
See <a
href="https://github.com/dhruvasagar/vim-table-mode/blob/master/CHANGELOG.md">
CHANGELOG.md </a>

## Contributing

### Reporting an Issue :
- Use <a href="https://github.com/dhruvasagar/vim-table-mode/issues">Github
  Issue Tracker</a>

### Contributing to code :
- Fork it.
- Commit your changes and give your commit message some love.
- Push to your fork on github.
- Open a Pull Request.

## Credit
I must thank Tim Pope for inspiration. The initial concept was created by him
named <a href="https://gist.github.com/tpope/287147">cucumbertables.vim</a>.

Also a shout out to godlygeek who developed the incredible <a
href="http://github.com/godlygeek/tabular">Tabular</a> plugin.

## Contributors

### Code Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/dhruvasagar/vim-table-mode/graphs/contributors"><img src="https://opencollective.com/vim-table-mode/contributors.svg?width=890&button=false" /></a>

### Financial Contributors

Become a financial contributor and help us sustain our community. [[Contribute](https://opencollective.com/vim-table-mode/contribute)]

#### Individuals

<a href="https://opencollective.com/vim-table-mode"><img src="https://opencollective.com/vim-table-mode/individuals.svg?width=890"></a>

#### Organizations

Support this project with your organization. Your logo will show up here with a link to your website. [[Contribute](https://opencollective.com/vim-table-mode/contribute)]

<a href="https://opencollective.com/vim-table-mode/organization/0/website"><img src="https://opencollective.com/vim-table-mode/organization/0/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/1/website"><img src="https://opencollective.com/vim-table-mode/organization/1/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/2/website"><img src="https://opencollective.com/vim-table-mode/organization/2/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/3/website"><img src="https://opencollective.com/vim-table-mode/organization/3/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/4/website"><img src="https://opencollective.com/vim-table-mode/organization/4/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/5/website"><img src="https://opencollective.com/vim-table-mode/organization/5/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/6/website"><img src="https://opencollective.com/vim-table-mode/organization/6/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/7/website"><img src="https://opencollective.com/vim-table-mode/organization/7/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/8/website"><img src="https://opencollective.com/vim-table-mode/organization/8/avatar.svg"></a>
<a href="https://opencollective.com/vim-table-mode/organization/9/website"><img src="https://opencollective.com/vim-table-mode/organization/9/avatar.svg"></a>
