#!/usr/bin/env bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
    echo "This is after failure script"
    echo "The repo name is "${TRAVIS_REPO_SLUG}
    echo "The pr number is "${TRAVIS_PULL_REQUEST}
    echo $TRAVIS_TEST_RESULT
fi
