# Issue descriptions

Please see the [issue template](ISSUE_TEMPLATE.md) for how to write a good
issue description. In short, it should contain the following:

1. Describe the issue in detail, include steps to reproduce the issue
2. Include a minimal working example
3. Include a minimal vimrc file

# Guide for code contributions

## Branch model

match-up is developed mainly through the master branch, and pull requests should
be [fork based](https://help.github.com/articles/using-pull-requests/).

## Documentation style

Vim help files have their own specific syntax. There is a Vim help section on
how to write them, see [`:h
help-writing`](http://vimdoc.sourceforge.net/htmldoc/helphelp.html#help-writing).

The match-up documentation style should be relatively clear, and it should be
easy to see from the existing documentation how to write it. Still, here are
some pointers:

- Max 80 columns per line
- Use the help tag system for pointers to other parts of the Vim documentation
- Use line of `=`s to separate sections
- Use line of `-`s to separate subsections
- The section tags should be right aligned at the 79th column
- Sections should be included and linked to from the table of contents

## Code style

When submitting code for match-up, please adhere to the following standards:

- Use `shiftwidth=2` - no tabs!
- Write readable code
  - Break lines for readability
    - Line should not be longer than 74 columns
  - Use comments:
    - For complex code that is difficult to understand
    - Simple code does not need comments
  - Use (single) empty lines to separate logical blocks of code
  - Use good variable names
    - The name should indicate what the variable is/does
    - Variable names should be lower case
    - Local function variables should be preceded with `l:`
  - Prefer single quoted strings
  - See also the [Google vimscript style
    guide](https://google.github.io/styleguide/vimscriptguide.xml)
- Use markers for folding
  - I generally only fold functions, and I tend to group similar functions so
    that when folded, I get a nice structural overview of a file
  - See some of the files for examples of how I do this

