#!/usr/bin/env bash
# 

# Reset
Color_off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Blue='\033[0;34m'         # Blue

need_cmd () {
    if ! command -v "$1" > /dev/null 2>&1;then
        printf "${Red}need '$1' (command not found)${Color_off}\n"
        exit 0
    fi
}

fetch_repo () {
    if [ -d "${HOME}/.SpaceVim" ];then
        cd ${HOME}/.SpaceVim
        git pull
        ret="$?"
        printf "${Blue}Successfully update SpaceVim${Color_off}\n"
    else
        git clone https://github.com/SpaceVim/SpaceVim.git ${HOME}/.SpaceVim
        ret="$?"
        printf "${Blue}Successfully clone SpaceVim${Color_off}\n"
    fi
}

install_vim () {
    if [ -f "${HOME}/.vimrc" ];then
        mv ${HOME}/.vimrc ${HOME}/.vimrc_back
        ret="$?"
        printf "${Blue}BackUp ${HOME}/.vimrc${Color_off}\n"
    fi

    if [ -d "${HOME}/.vim" ];then
        if file ${HOME}/.vim | grep ${HOME}/.SpaceVim &> /dev/null;then
            printf "${Blue}Installed SpaceVim for vim${Color_off}\n"
        else
            mv ${HOME}/.vim ${HOME}/.vim_back
            ret="$?"
            printf "${Blue}BackUp ${HOME}/.vim${Color_off}\n"
            ln -s ${HOME}/.SpaceVim ${HOME}/.vim
            printf "${Blue}Installed SpaceVim for vim${Color_off}\n"
        fi
    else
        ln -s ${HOME}/.SpaceVim ${HOME}/.vim
        printf "${Blue}Installed SpaceVim for vim${Color_off}\n"
    fi
}

install_neovim () {
    if [ -d "${HOME}/.config/nvim" ];then
        if file ${HOME}/.config/nvim | grep ${HOME}/.SpaceVim &> /dev/null;then
            printf "${Blue}Installed SpaceVim for neovim${Color_off}\n"
        else
            mv ${HOME}/.config/nvim ${HOME}/.config/nvim_back
            ret="$?"
            printf "${Blue}BackUp ${HOME}/.config/nvim${Color_off}\n"
            ln -s ${HOME}/.SpaceVim ${HOME}/.config/nvim
            printf "${Blue}Installed SpaceVim for neovim${Color_off}\n"
        fi
    else
        ln -s ${HOME}/.SpaceVim ${HOME}/.config/nvim
        printf "${Blue}Installed SpaceVim for neovim${Color_off}\n"
    fi
}

need_cmd 'git'

fetch_repo

install_vim

install_neovim


