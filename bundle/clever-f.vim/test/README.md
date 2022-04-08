## How to execute tests

[vim-themis](https://github.com/thinca/vim-themis) is required.

For example, the following clones it locally in clever-f.vim repository.

```console
$ cd /path/to/clever-f.vim/test
$ git clone https://github.com/thinca/vim-themis
$ ./vim-themis/bin/themis .
```

## How to measure code coverage

[covimerage](https://github.com/Vimjas/covimerage) is required. I recommend to use
[venv](https://docs.python.org/3/library/venv.html) for installing it locally.

```console
$ python -m venv venv
$ source ./venv/bin/activate

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

CI runs on Linux, macOS and Windows using GitHub Actions: https://github.com/rhysd/clever-f.vim/actions?query=workflow%3ACI

Coverage is tracked with codecov.io: https://codecov.io/gh/rhysd/clever-f.vim
