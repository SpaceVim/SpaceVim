## How to execute tests

It requires [vim-themis](https://github.com/thinca/vim-themis). You need to install it in advance.

For example, following clones it locally in clever-f.vim repository.

```console
$ cd /path/to/clever-f.vim/test
$ git clone https://github.com/thinca/vim-themis
$ ./vim-themis/bin/themis .
```

## How to measure code coverage

It requires [covimerage](https://github.com/Vimjas/covimerage).

```console
$ pip install covimerage
$ cd /path/to/clever-f.vim/test

# Run tests with profiling
$ PROFILE_LOG=profile.txt ./vim-themis/bin/themis .

# Create a coverage file using profile results
$ covimerage write_coverage profile.txt

# See the coverage results in console output
$ coverage report

# See the coverage results in test/htmlcov/index.html
$ coverage html
```

## CI

CI is run in both Linux and macOS using Travis CI: https://travis-ci.org/rhysd/clever-f.vim

Coverage is tracked with codecov.io: https://codecov.io/gh/rhysd/clever-f.vim
