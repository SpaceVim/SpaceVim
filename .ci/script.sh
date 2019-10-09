#!/usr/bin/env bash

set -ex
export TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}
if [ "$LINT" = "vimlint" ]; then
    for file in $(git diff --name-only HEAD dev | grep .vim$);
    do
        sh /tmp/vimlint/bin/vimlint.sh -l /tmp/vimlint -p /tmp/vimlparser $file;
    done
elif [ "$LINT" = "vimlint-errors" ]; then
    if [[ -f build_log ]]; then
        rm build_log
    fi
    for file in $(git diff --name-only HEAD master | grep .vim$);
    do
        /tmp/vimlint/bin/vimlint.sh -E -l /tmp/vimlint -p /tmp/vimlparser $file >> build_log 2>&1;
    done
    if [[ -s build_log ]]; then
        cat build_log
        exit 2
    fi
elif [ "$LINT" = "file-encoding" ]; then
    if [[ -f encoding_log ]]; then
        rm encoding_log
    fi
    for file in $(git diff --name-only HEAD master | grep .);
    do
        encoding=`file -bi $file | cut -f 2 -d";" | cut -f 2 -d=`
        case $encoding in
            utf-8)
                exit 0
                ;;
            us-ascii)
                exit 0
                ;;
            cp936)
                echo $file >> encoding_log
                exit 2
                ;;
            cp835)
                echo $file >> encoding_log
                exit 2
        esac
        echo $file >> encoding_log
        exit 2
    done
    if [[ -s encoding_log ]]; then
        cat encoding_log
        exit 2
    fi
elif [ "$LINT" = "vint" ]; then
    vint .
elif [ "$LINT" = "vint-errors" ]; then
    vint --error .
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
    make test_coverage
    covimerage -vv xml --omit 'build/*'
    pip install codecov
    codecov -X search gcov pycov -f coverage.xml
elif [ "$LINT" = "jekyll" ]; then
    .ci/build-production
fi
set +x
