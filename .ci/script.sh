#!/usr/bin/env bash

set -ex
export TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}
if [ "$LINT" = "vimlint" ]; then
    if [[ -f build_log ]]; then
        rm build_log
    fi
    for file in $(git ls-files | grep SpaceVim.*.vim);
    do
        /tmp/vimlint/bin/vimlint.sh -l /tmp/vimlint -p /tmp/vimlparser $file >> build_log 2>&1;
    done
    if [[ -s build_log ]]; then
        exit 2
    fi
elif [ "$LINT" = "vimlint-errors" ]; then
    if [[ -f build_log ]]; then
        rm build_log
    fi
    for file in $(git ls-files | grep SpaceVim.*.vim);
    do
        /tmp/vimlint/bin/vimlint.sh -E -l /tmp/vimlint -p /tmp/vimlparser $file >> build_log 2>&1;
    done
    if [[ -s build_log ]]; then
        exit 2
    fi
elif [ "$LINT" = "file-encoding" ]; then
    if [[ -f build_log ]]; then
        rm build_log
    fi
    for file in $(git diff --name-only HEAD master);
    do
        # get the encoding of a file, based on:
        # https://superuser.com/a/351658/618193
        # It should be -b instead of -bi
        encoding=`file -b --mime-encoding $file`
        if [ $encoding != "utf-8" ] && [ $encoding != "us-ascii" ];
        then
            echo $file " " $encoding >> build_log
        fi
    done
    if [[ -s build_log ]]; then
        exit 2
    fi
elif [ "$LINT" = "vint" ]; then
    if [[ -f build_log ]]; then
        rm build_log
    fi
    for file in $(git ls-files | grep SpaceVim.*.vim);
    do
        vint --enable-neovim $file >> build_log 2>&1;
    done
    if [[ -s build_log ]]; then
        exit 2
    fi
elif [ "$LINT" = "vint-errors" ]; then
    if [[ -f build_log ]]; then
        rm build_log
    fi
    for file in $(git ls-files | grep SpaceVim.*.vim);
    do
        vint --enable-neovim --error $file >> build_log 2>&1;
    done
    if [[ -s build_log ]]; then
        exit 2
    fi
elif [ "$LINT" = "vader" ]; then
    if [ "$VIM_BIN" = "nvim" ]; then
        export PATH="${DEPS}/_neovim/${VIM_TAG}/bin:${PATH}"
        export VIM="${DEPS}/_neovim/${VIM_TAG}/share/nvim/runtime"
    else
        export PATH="${DEPS}/_vim/${VIM_TAG}/bin:${PATH}"
        export VIM="${DEPS}/_vim/${VIM_TAG}/share/vim"
    fi

    echo "\$PATH: \"${PATH}\""
    echo "\$VIM: \"${VIM}\""
    echo "=================  ${VIM_BIN} version ======================"
    $VIM_BIN --version
    pip install covimerage
    pip install codecov
    python -c 'import os,sys,fcntl; flags = fcntl.fcntl(sys.stdout, fcntl.F_GETFL); fcntl.fcntl(sys.stdout, fcntl.F_SETFL, flags&~os.O_NONBLOCK);'
    make test_coverage
    covimerage -vv xml --omit 'build/*'
    codecov -X search gcov pycov -f coverage.xml
elif [ "$LINT" = "jekyll" ]; then
    .ci/build-production
fi
set +x
