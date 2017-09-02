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
Version='0.5.0-dev'

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

warn () {
    msg "${Red}[✘]${Color_off} ${1}${2}"
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
        success "Backup $HOME/.vimrc to $HOME/.vimrc_back"
    fi

    if [[ -d "$HOME/.vim" ]]; then
        if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
            success "Installed SpaceVim for vim"
        else
            mv "$HOME/.vim" "$HOME/.vim_back"
            success "BackUp $HOME/.vim to $HOME/.vim_back"
            ln -s "$HOME/.SpaceVim" "$HOME/.vim"
            success "Installed SpaceVim for vim"
        fi
    else
        ln -s "$HOME/.SpaceVim" "$HOME/.vim"
        success "Installed SpaceVim for vim"
    fi
}

install_package_manager () {
    if [[ ! -d "$HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim" ]]; then
        info "Install dein.vim"
        git clone https://github.com/Shougo/dein.vim.git $HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim
        success "dein.vim installation done"
    fi
}

install_neovim () {
    if [[ -d "$HOME/.config/nvim" ]]; then
        if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
            success "Installed SpaceVim for neovim"
        else
            mv "$HOME/.config/nvim" "$HOME/.config/nvim_back"
            success "BackUp $HOME/.config/nvim to $HOME/.config/nvim_back"
            ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
            success "Installed SpaceVim for neovim"
        fi
    else
        ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
        success "Installed SpaceVim for neovim"
    fi
}

uninstall_vim () {
    if [[ -d "$HOME/.vim" ]]; then
        if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
            rm "$HOME/.vim"
            success "Uninstall SpaceVim for vim"
            if [[ -d "$HOME/.vim_back" ]]; then
                mv "$HOME/.vim_back" "$HOME/.vim"
                success "Recover from $HOME/.vim_back"
            fi
        fi
    fi
    if [[ -f "$HOME/.vimrc_back" ]]; then
        mv "$HOME/.vimrc_back" "$HOME/.vimrc"
        success "Recover from $HOME/.vimrc_back"
    fi
}

uninstall_neovim () {
    if [[ -d "$HOME/.config/nvim" ]]; then
        if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
            rm "$HOME/.config/nvim"
            success "Uninstall SpaceVim for neovim"
            if [[ -d "$HOME/.config/nvim_back" ]]; then
                mv "$HOME/.config/nvim_back" "$HOME/.config/nvim"
                success "Recover from $HOME/.config/nvim_back"
            fi
        fi
    fi
}

check_requirements () {
    info "Checking Requirements for SpaceVim"
    if hash "git" &>/dev/null; then
        git_version=$(git --version)
        success "Check Requirements: ${git_version}"
    else
        warn "Check Requirements : git"
    fi
    if hash "vim" &>/dev/null; then
        is_vim8=$(vim --version | grep "Vi IMproved 8.0")
        is_vim74=$(vim --version | grep "Vi IMproved 7.4")
        if [ -n "$is_vim8" ]; then
            success "Check Requirements: vim 8.0"
        elif [ -n "$is_vim74" ]; then
            success "Check Requirements: vim 7.4"
        else
            if hash "nvim" &>/dev/null; then
                success "Check Requirements: nvim"
            else
                warn "SpaceVim need vim 7.4 or above"
            fi
        fi
        if hash "nvim" &>/dev/null; then
            success "Check Requirements: nvim"
        fi
    else
        if hash "nvim" &>/dev/null; then
            success "Check Requirements: nvim"
        else
            warn "Check Requirements : vim or nvim"
        fi
    fi
    info "Checking true colors support in terminal:"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh)"
}

usage () {
    echo "SpaceVim install script : V ${Version}"
    echo ""
    echo "Usage : curl -sLf https://spacevim.org/install.sh | bash -s -- [option] [target]"
    echo ""
    echo "  This is bootstrap script for SpaceVim."
    echo ""
    echo "OPTIONS"
    echo ""
    echo " -i, --install            install spacevim for vim or neovim"
    echo " -v, --version            Show version information and exit"
    echo " -u, --uninstall          Uninstall SpaceVim"
    echo " -c, --checkRequirements  checkRequirements for SpaceVim"
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
        --uninstall|-u)
            info "Trying to uninstall SpaceVim"
            uninstall_vim
            uninstall_neovim
            exit 0
            ;;
        --checkRequirements|-c)
            check_requirements
            exit 0
            ;;
        --install|-i)
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
        --help|-h)
            usage
            exit 0
            ;;
        --version|-v)
            msg "${Version}"
            exit 0
    esac
fi
# if no argv, installer will install SpaceVim
need_cmd 'git'
fetch_repo
install_vim
install_neovim
install_package_manager
