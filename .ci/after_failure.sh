#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
    export TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}
    if [ "$LINT" = "vimlint-errors" ] ; then
        if [[ -f build_log ]]; then
            if [[ -d build/GitHub.vim ]]; then
                rm -rf build/GitHub.vim
            fi
            VIMLINT_LOG=`cat build_log`
            echo $VIMLINT_LOG
            git clone https://github.com/wsdjeg/GitHub.vim.git build/GitHub.vim
            docker run \
                -it --rm \
                -e TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST} \
                -v $PWD/.ci:/.ci \
                -v $PWD/autoload/SpaceVim/api:/API/autoload/SpaceVim/api \
                -v $PWD/autoload/SpaceVim/api.vim:/API/autoload/SpaceVim/api.vim \
                -v $PWD/build:/build \
                spacevim/vims vim8 -u /.ci/common/github_commenter.vim
            rm build_log
        fi
    elif [ "$LINT" = "vimlint" ] ; then
        if [[ -f build_log ]]; then
            VIMLINT_LOG=`cat build_log`
            echo $VIMLINT_LOG
            rm build_log
        fi
    elif [ "$LINT" = "vint" ] ; then
        if [[ -f build_log ]]; then
            VIMLINT_LOG=`cat build_log`
            echo $VIMLINT_LOG
            rm build_log
        fi
    elif [ "$LINT" = "vint-errors" ] ; then
        if [[ -f build_log ]]; then
            if [[ -d build/GitHub.vim ]]; then
                rm -rf build/GitHub.vim
            fi
            VIMLINT_LOG=`cat build_log`
            echo $VIMLINT_LOG
            git clone https://github.com/wsdjeg/GitHub.vim.git build/GitHub.vim
            docker run -it --rm \
                -e TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST} \
                -v $PWD/.ci:/.ci \
                -v $PWD/autoload/SpaceVim/api:/API/autoload/SpaceVim/api \
                -v $PWD/autoload/SpaceVim/api.vim:/API/autoload/SpaceVim/api.vim \
                -v $PWD/build:/build \
                spacevim/vims vim8 -u /.ci/common/github_commenter.vim
            rm build_log
        fi
    elif [ "$LINT" = "vader" ] ; then
        echo ""
    fi
fi
