#!/usr/bin/env bash

set -ex
export PATH="${DEPS}/_neovim/bin:${PATH}"
echo "\$PATH: \"${PATH}\""

export VIM="${DEPS}/_neovim/share/nvim/runtime"
nvim --version
make test_coverage
covimerage -vv xml --omit 'build/*'
pip install codecov
codecov -X search gcov pycov -f coverage.xml
set +x
