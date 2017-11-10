#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
    source .ci/common/github_commenter
    if [ "$LINT" = "vimlint-errors" ] ; then
        VIMLINT_LOG=`cat build/log`
        if [ -n "$VIMLINT_LOG" ]; then
            add_comment_to_pr $VIMLINT_LOG
        fi
        rm build/log
    elif [ "$LINT" = "vint-errors" ] ; then
        add_comment_to_pr $TRAVIS_TEST_RESULT
    elif [ "$LINT" = "vader" ] ; then
        add_comment_to_pr $TRAVIS_TEST_RESULT
    fi
fi
