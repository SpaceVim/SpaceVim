#!/usr/bin/env bash

usage () {
    echo ".ci/update_remote.sh [option] [target]"
}

check_remote () {
    if [ -z "$(git remote -v | grep git@gitee.com:spacevim/SpaceVim.git)" ];then
        git remote add gitee git@gitee.com:spacevim/SpaceVim.git
    fi
}

main () {
    if [ $# -gt 0 ]
        check_remote
    then
        case $1 in
            --help|-h)
                usage
                exit 0
                ;;
        esac
    fi
}

main $@
