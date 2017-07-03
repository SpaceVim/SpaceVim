#!/usr/bin/env bash

#=============================================================================
# install.sh --- bootstrap script for SpaceVim
# Copyright (c) 2016-2017 Shidong Wang & Contributors
# Author: Shidong Wang < wsdjeg at 163.com >
# URL: https://spacevim.org
# License: MIT license
#=============================================================================


# Reset
Color_off='\033[0m'       # Text Reset
Version='0.4.0-dev'

# Regular Colors
Red='\033[0;31m'
Blue='\033[0;34m'
Green='\033[0;32m'

need_cmd () {
    if ! hash "$1" &>/dev/null; then
        error "Need '$1' (command not fount)"
        exit 1
    fi
}

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    msg "${Green}[✔]${Color_off} ${1}${2}"
}

info() {
    msg "${Blue}==>${Color_off} ${1}${2}"
}

error() {
    msg "${Red}[✘]${Color_off} ${1}${2}"
    exit 1
}

fetch_repo () {
    if [[ -d "$HOME/.SpaceVim" ]]; then
        info "Trying to update SpaceVim"
        git --git-dir "$HOME/.SpaceVim/.git" pull
        success "Successfully update SpaceVim"
    else
        info "Trying to clone SpaceVim"
        git clone https://github.com/SpaceVim/SpaceVim.git "$HOME/.SpaceVim"
        success "Successfully clone SpaceVim"
    fi
}

install_vim () {
    if [[ -f "$HOME/.vimrc" ]]; then
        mv "$HOME/.vimrc" "$HOME/.vimrc_back"
        echo -e "${Blue}BackUp $HOME/.vimrc${Color_off}"
    fi

    if [[ -d "$HOME/.vim" ]]; then
        if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
            echo -e "${Blue}Installed SpaceVim for vim${Color_off}"
        else
            mv "$HOME/.vim" "$HOME/.vim_back"
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
            echo -e "${Blue}BackUp $HOME/.config/nvim${Color_off}"
            ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
            echo -e "${Blue}Installed SpaceVim for neovim${Color_off}"
        fi
    else
        ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
        echo -e "${Blue}Installed SpaceVim for neovim${Color_off}"
    fi
}

uninstall_vim () {
    if [[ -d "$HOME/.vim" ]]; then
        if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
            rm "$HOME/.vim"
            echo -e "${Blue}Uninstall SpaceVim for vim${Color_off}"
            if [[ -d "$HOME/.vim_back" ]]; then
                mv "$HOME/.vim_back" "$HOME/.vim"
                echo -e "${Blue}Recover $HOME/.vim${Color_off}"
            fi
        fi
    fi
    if [[ -f "$HOME/.vimrc_back" ]]; then
        mv "$HOME/.vimrc_back" "$HOME/.vimrc"
        echo -e "${Blue}Recover $HOME/.vimrc${Color_off}"
    fi
}

uninstall_neovim () {
    if [[ -d "$HOME/.config/nvim" ]]; then
        if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
            rm "$HOME/.config/nvim"
            echo -e "${Blue}Uninstall SpaceVim for neovim${Color_off}"
            if [[ -d "$HOME/.config/nvim_back" ]]; then
                mv "$HOME/.config/nvim_back" "$HOME/.config/nvim"
                echo -e "${Blue}Recover $HOME/.config/nvim${Color_off}"
            fi
        fi
    fi
}

usage () {
    echo "SpaceVim install script : V ${Version}"
    echo ""
    echo "Usage : curl -sLf https://spacevim.org/install.sh [option] [target]"
    echo ""
    echo "  This is bootstrap script for SpaceVim."
    echo ""
    echo "OPTIONS"
    echo ""
    echo " -i, --install            install spacevim for vim or neovim"
    echo " -v, --version            Show version information and exit"
    echo " -u, --uninstall          Uninstall SpaceVim"
    echo ""
    echo "EXAMPLE"
    echo ""
    echo "    Install SpaceVim for vim and neovim"
    echo ""
    echo "        curl -sLf https://spacevim.org/install.sh | bash"
    echo ""
    echo "    Install SpaceVim for vim only or neovim only"
    echo ""
    echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --install vim"
    echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim"
    echo ""
    echo "    Uninstall SpaceVim"
    echo ""
    echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall"
}


if [ $# -gt 0 ]
then
    case $1 in
        --uninstall)
            uninstall_vim
            uninstall_neovim
            exit 0
            ;;
        --install)
            need_cmd 'git'
            fetch_repo
            if [ $# -eq 2 ]
            then
                case $2 in
                    neovim)
                        install_neovim
                        exit 0
                        ;;
                    vim)
                        install_vim
                        exit 0
                esac
            fi
            install_vim
            install_neovim
            exit 0
            ;;
        -h)
            usage
            exit 0
            ;;
        --help)
            usage
            exit 0
            ;;
        -v)
            msg "${Version}"
            exit 0
            ;;
        --version)
            msg "${Version}"
            exit 0
    esac
fi
# if no argv, installer will install SpaceVim
need_cmd 'git'
fetch_repo
install_vim
install_neovim
