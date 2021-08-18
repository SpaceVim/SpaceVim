# Contributing

If you'd like to contribute to the project, you can use the usual github pull-request flow:

1. Fork the project
2. Make your change/addition, preferably in a separate branch
3. Test the new behaviour and make sure all existing tests pass
4. Issue a pull request with a description of your feature/bugfix

## Github Issues

When reporting a bug make sure you search the existing github issues for the same/similar issues. If you find one, feel free to add a `+1` comment with any additional information that may help us solve the issue.

When creating a new issue be sure to state the following:

* Steps to reproduce the bug
* The version of vim you are using
* The version of vim-bookmarks you are using

## Coding Conventions

* Use 2 space indents
* Don't use abbreviated keywords - e.g. use `endfunction`, not `endfun` (there's always room for more fun!)
* Don't use `l:` prefixes for variables unless actually required (i.e. almost never)
* Code for maintainability

## Testing

This project uses [vim-flavor](https://github.com/kana/vim-flavor) and [vim-vspec](https://github.com/kana/vim-vspec) to test its behaviour. All logic is extracted into autoload files which are fully tested. The tests can be found in the `t` folder. The tests are written in vim script as well. Tests are also executed on Travis-CI to make sure there are no regressions.

Install bundler first:

```
$ gem install bundler
```

If you already have the `bundle` command (check it out with `which bundle`), you don't need this step. Afterwards, it should be as simple as:

```
$ bundle install
$ bundle exec vim-flavor test
```
