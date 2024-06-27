# Contributing

If you'd like to contribute to the project, you can use the usual github pull-request flow:

1. Fork the project
2. Make your change/addition, preferably in a separate branch.
3. Test the new behaviour and make sure all existing tests pass (optional, see below for more information).
4. Issue a pull request with a description of your feature/bugfix.

## Testing

This project uses [rspec](http://rspec.info/) and [vimrunner](https://github.com/AndrewRadev/vimrunner) to test its behaviour. Testing vimscript this way does a great job of catching regressions, since it launches a real Vim instance and drives it (almost) as if it's a real user. Tests are written in the ruby programming language, so if you're familiar with it, you should (I hope) find the tests fairly understandable and easy to get into.

If you're not familiar with ruby, it's okay to skip them. I'd definitely appreciate it if you could take a look at the tests and attempt to write something that describes your change. Even if you don't, TravisCI should run the tests on every pull request, so we'll know right away if there's a regression. In that case, I'll work on the tests myself and see what I can do.

To run the test suite, you need to first make sure you've got git submodules checked out:

```
$ git submodule init
$ git submodule update
```

Then, provided you have ruby installed, you need bundler:

```
$ gem install bundler
```

If you already have the `bundle` command (check it out with `which bundle`), you don't need this step. Afterwards, it should be as simple as:

```
$ bundle install
$ bundle exec rspec spec
```

Instead of running `rspec` by hand you can also use:

```
$ bundle exec guard
```

This will trigger `rspec` automatically every time you make a change either to a spec file like `spec/plugin/coffee_spec.rb` or one of sj's autoload files like `autoload/sj/coffee.vim`. This has the additional benefit of only running the specs for the file you are currently working one, which shortens your feedback loop considerably. E.g. when you work on `autoload/sj/sh.vim` only shell specs will be run.

Depending on what kind of Vim you have installed, this may spawn a GUI Vim instance, or even several. You can read up on [vimrunner's README](https://github.com/AndrewRadev/vimrunner/blob/master/README.md) to understand how that works.
