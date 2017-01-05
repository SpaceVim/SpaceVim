#!/usr/bin/env bash
# 

# Reset
Color_off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Blue='\033[0;34m'         # Blue

need_cmd () {
    if ! hash "$1" &>/dev/null; then
        echo -e "${Red}need '$1' (command not found)${Color_off}"
        exit 1
    fi
}

fetch_repo () {
    if [[ -d "$HOME/.SpaceVim" ]]; then
        git -C "$HOME/.SpaceVim" pull
        ret=$?
        echo -e "${Blue}Successfully update SpaceVim${Color_off}"
    else
        git clone https://github.com/SpaceVim/SpaceVim.git "$HOME/.SpaceVim"
        ret=$?
        echo -e "${Blue}Successfully clone SpaceVim${Color_off}"
    fi
}

install_vim () {
    if [[ -f "$HOME/.vimrc" ]]; then
        mv "$HOME/.vimrc" "$HOME/.vimrc_back"
        ret=$?
        echo -e "${Blue}BackUp $HOME/.vimrc${Color_off}"
    fi

    if [[ -d "$HOME/.vim" ]]; then
        if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
            echo -e "${Blue}Installed SpaceVim for vim${Color_off}"
        else
            mv "$HOME/.vim" "$HOME/.vim_back"
            ret=$?
            echo -e "${Blue}BackUp $HOME/.vim${Color_off}"
            ln -s "$HOME/.SpaceVim" "$HOME/.vim"
            echo -e "${Blue}Installed SpaceVim for vim${Color_off}"
        fi
    else
        ln -s "$HOME/.SpaceVim" "$HOME/.vim"
        echo -e "${Blue}Installed SpaceVim for vim${Color_off}"
    fi
}

install_neovim () {
    if [[ -d "$HOME/.config/nvim" ]]; then
        if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
            echo -e "${Blue}Installed SpaceVim for neovim${Color_off}"
        else
            mv "$HOME/.config/nvim" "$HOME/.config/nvim_back"
            ret=$?
            echo -e "${Blue}BackUp $HOME/.config/nvim${Color_off}"
            ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
            echo -e "${Blue}Installed SpaceVim for neovim${Color_off}"
        fi
    else
        ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
        echo -e "${Blue}Installed SpaceVim for neovim${Color_off}"
    fi
}

need_cmd 'git'

fetch_repo

install_vim

install_neovim


