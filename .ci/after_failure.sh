#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
    source .ci/common/github_commenter
    if [ "$LINT" = "vimlint-errors" ] ; then
        VIMLINT_LOG=`cat build_log`
        if [ -n "$VIMLINT_LOG" ]; then
            rm -rf build/GitHub.vim
            git clone https://github.com/wsdjeg/GitHub.vim.git build/GitHub.vim
            vim -u .ci/common/github_commenter.vim
        fi
        rm build_log
    elif [ "$LINT" = "vint-errors" ] ; then
        add_comment_to_pr $TRAVIS_TEST_RESULT
    elif [ "$LINT" = "vader" ] ; then
        add_comment_to_pr $TRAVIS_TEST_RESULT
    fi
fi
