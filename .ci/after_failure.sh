#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
    if [ "$LINT" = "vimlint-errors" ] ; then
        VIMLINT_LOG=`cat build_log`
        if [[ -f build_log ]]; then
            if [[ -d build/GitHub.vim ]]; then
                rm -rf build/GitHub.vim
            fi
            git clone https://github.com/wsdjeg/GitHub.vim.git build/GitHub.vim
            docker run -it --rm
            \ -v $(PWD):/testplugin
            \ -v $(PWD)/test/vim:/home
            \ spacevim/vims neovim-stable
            \ -u .ci/common/github_commenter.vim
            rm build_log
        fi
    elif [ "$LINT" = "vint-errors" ] ; then
        echo ""
    elif [ "$LINT" = "vader" ] ; then
        echo ""
    fi
fi
