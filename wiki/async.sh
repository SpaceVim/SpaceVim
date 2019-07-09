#!/usr/bin/env bash

main () {
    case "$1" in
        en)
            cd wiki/en/
            git init 
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Update wiki"
            git remote add SpaceVimWikiEn https://SpaceVimBot:${BOTSECRET}@github.com/SpaceVim/SpaceVim.wiki.git
            git push -f -u SpaceVimWikiEn master 
            cd -
            rm -rf ./wiki/en/.git/
            exit 0
            ;;
        cn)
            cd wiki/cn/
            git init 
            git add .
            git config user.email "wsdjeg@qq.com"
            git config user.name  "SpaceVimBot"
            git commit -m "Update wiki"
            git remote add SpaceVimWikiCn https://SpaceVimBot:${BOTSECRET}@gitee.com/spacevim/SpaceVim.wiki.git
            git push -f -u SpaceVimWikiCn master 
            cd -
            rm -rf ./wiki/cn/.git/
            exit 0
    esac
}

main $@
