#!/usr/bin/env bash

usage () {
    echo ".ci/update_remote.sh [option] [target]"
}

push_gitee()
{
    git remote add gitee https://SpaceVimBot:${BOTSECRET}@gitee.com/spacevim/SpaceVim.git
    git push gitee master -f
}

push_gitlab()
{
    git remote add gitlab https://SpaceVimBot:${BOTSECRET}@gitlab.com/SpaceVim/SpaceVim.git
    git push gitlab master -f
}

push_coding()
{
    git remote add coding https://spacevim%40outlook.com:${CODINGBOTSECRET}@e.coding.net/spacevim/SpaceVim.git
    git push coding master -f
}

main () {
    case $1 in
        --help|-h)
            usage
            exit 0
            ;;
        gitee)
            push_gitee
            exit 0
            ;;
        gitlab)
            push_gitlab
            exit 0
            ;;
        coding)
            push_coding
            exit 0
            ;;
    esac
}

main $@
