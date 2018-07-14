#!/usr/bin/env bash

set -ex
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
elif [ "$LINT" = "vint" ]; then
    vint .
elif [ "$LINT" = "vint-errors" ]; then
    vint --error .
elif [ "$LINT" = "vader" ]; then
    TESTVIM = "docker run -it --rm -v $PWD/.ci:/.ci -v $PWD/autoload/SpaceVim/api:/API/autoload/SpaceVim/api -v $PWD/autoload/SpaceVim/api.vim:/API/autoload/SpaceVim/api.vim -v $PWD/build:/build spacevim/vims neovim-stable "
    cat ~/.SpaceVim.d/init.toml
    pip install covimerage
    make test_coverage
    covimerage -vv xml --omit 'build/*'
    pip install codecov
    codecov -X search gcov pycov -f coverage.xml
elif [ "$LINT" = "jekyll" ]; then
    .ci/build-production
fi
set +x
