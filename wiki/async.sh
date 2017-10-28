#!/usr/bin/env bash


cd wiki/
git init 
git add .
git commit -m "Update wiki"
git remote add SpaceVimWiki https://github.com/SpaceVim/SpaceVim.wiki.git
git push -f -u SpaceVimWiki master 
cd ..
rm -rf ./wiki/.git/
