#!/usr/bin/env bash

#=============================================================================
# install.sh --- bootstrap script for SpaceVim
# Copyright (c) 2016-2017 Shidong Wang & Contributors
# Author: Shidong Wang < wsdjeg at 163.com >
# URL: https://spacevim.org
# License: GPLv3
#=============================================================================

# Init option {{{
Color_off='\033[0m'       # Text Reset

# terminal color template {{{
# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
# }}}

# version
Version='1.5.0-dev'
#System name
System="$(uname -s)"

# }}}

# need_cmd {{{
need_cmd () {
    if ! hash "$1" &>/dev/null; then
        error "Need '$1' (command not found)"
        exit 1
    fi
}
# }}}

# success/info/error/warn {{{
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    msg "${Green}[✔]${Color_off} ${1}${2}"
}

info() {
    msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error() {
    msg "${Red}[✘]${Color_off} ${1}${2}"
    exit 1
}

warn () {
    msg "${Yellow}[⚠]${Color_off} ${1}${2}"
}
# }}}

# echo_with_color {{{
echo_with_color () {
    printf '%b\n' "$1$2$Color_off" >&2
}
# }}}

# fetch_repo {{{
fetch_repo () {
    if [[ -d "$HOME/.SpaceVim" ]]; then
        info "Trying to update SpaceVim"
        cd "$HOME/.SpaceVim"
        git pull
        cd - > /dev/null 2>&1
        success "Successfully update SpaceVim"
    else
        info "Trying to clone SpaceVim"
        git clone https://github.com/SpaceVim/SpaceVim.git "$HOME/.SpaceVim"
        if [ $? -eq 0 ]; then
            success "Successfully clone SpaceVim"
        else
            error "Failed to clone SpaceVim"
            exit 0
        fi
    fi
}
# }}}

# install_vim {{{
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
# }}}

# install_package_manager {{{
install_package_manager () {
    if [[ ! -d "$HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim" ]]; then
        info "Install dein.vim"
        git clone https://github.com/Shougo/dein.vim.git $HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim
        success "dein.vim installation done"
    fi
}
# }}}

# install_neovim {{{
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
        mkdir -p "$HOME/.config"
        ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
        success "Installed SpaceVim for neovim"
    fi
}
# }}}

# uninstall_vim {{{
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
# }}}

# uninstall_neovim {{{
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
# }}}

# check_requirements {{{
check_requirements () {
    info "Checking Requirements for SpaceVim"
    if hash "git" &>/dev/null; then
        git_version=$(git --version)
        success "Check Requirements: ${git_version}"
    else
        warn "Check Requirements : git"
    fi
    if hash "vim" &>/dev/null; then
        is_vim8=$(vim --version | grep "Vi IMproved 8")
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
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh)"
}
# }}}

# usage {{{
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
# }}}

# install_done {{{

install_done () {
    echo_with_color ${Yellow} ""
    echo_with_color ${Yellow} "Almost done!"
    echo_with_color ${Yellow} "=============================================================================="
    echo_with_color ${Yellow} "==    Open Vim or Neovim and it will install the plugins automatically      =="
    echo_with_color ${Yellow} "=============================================================================="
    echo_with_color ${Yellow} ""
    echo_with_color ${Yellow} "That's it. Thanks for installing SpaceVim. Enjoy!"
    echo_with_color ${Yellow} ""
}

# }}}

# welcome {{{


welcome () {
    echo_with_color ${Yellow} "        /######                                     /##    /##/##             "
    echo_with_color ${Yellow} "       /##__  ##                                   | ##   | #|__/             "
        echo_with_color ${Yellow} "      | ##  \__/ /######  /######  /####### /######| ##   | ##/##/######/#### "
        echo_with_color ${Yellow} "      |  ###### /##__  ##|____  ##/##_____//##__  #|  ## / ##| #| ##_  ##_  ##"
        echo_with_color ${Yellow} "       \____  #| ##  \ ## /######| ##     | ########\  ## ##/| #| ## \ ## \ ##"
        echo_with_color ${Yellow} "       /##  \ #| ##  | ##/##__  #| ##     | ##_____/ \  ###/ | #| ## | ## | ##"
        echo_with_color ${Yellow} "      |  ######| #######|  ######|  ######|  #######  \  #/  | #| ## | ## | ##"
        echo_with_color ${Yellow} "       \______/| ##____/ \_______/\_______/\_______/   \_/   |__|__/ |__/ |__/"
        echo_with_color ${Yellow} "               | ##                                                           "
        echo_with_color ${Yellow} "               | ##                                                           "
        echo_with_color ${Yellow} "               |__/                                                           "
            echo_with_color ${Yellow} "                      version : ${Version}      by : spacevim.org             "
        }

# }}}

# download_font {{{
download_font () {
    url="https://raw.githubusercontent.com/wsdjeg/DotFiles/master/local/share/fonts/${1// /%20}"
    path="$HOME/.local/share/fonts/$1"
    # Clean up after https://github.com/SpaceVim/SpaceVim/issues/2532
    if [[ -f "$path" && ! -s "$path" ]]
    then
        rm "$path"
    fi
    if [[ -f "$path" ]]
    then
        success "Downloaded $1"
    else
        info "Downloading $1"
        curl -s -o "$path" "$url"
        success "Downloaded $1"
    fi
}

# }}}

# install_fonts {{{
install_fonts () {
    if [[ ! -d "$HOME/.local/share/fonts" ]]; then
        mkdir -p $HOME/.local/share/fonts
    fi
    download_font "DejaVu Sans Mono Bold Oblique for Powerline.ttf"
    download_font "DejaVu Sans Mono Bold for Powerline.ttf"
    download_font "DejaVu Sans Mono Oblique for Powerline.ttf"
    download_font "DejaVu Sans Mono for Powerline.ttf"
    download_font "DroidSansMonoForPowerlinePlusNerdFileTypesMono.otf"
    download_font "Ubuntu Mono derivative Powerline Nerd Font Complete.ttf"
    download_font "WEBDINGS.TTF"
    download_font "WINGDNG2.ttf"
    download_font "WINGDNG3.ttf"
    download_font "devicons.ttf"
    download_font "mtextra.ttf"
    download_font "symbol.ttf"
    download_font "wingding.ttf"
    info "Updating font cache, please wait ..."
    if [ $System == "Darwin" ];then
        if [ ! -e "$HOME/Library/Fonts" ];then
            mkdir "$HOME/Library/Fonts"
        fi
        cp $HOME/.local/share/fonts/* $HOME/Library/Fonts/
    else
        fc-cache -fv > /dev/null
        mkfontdir "$HOME/.local/share/fonts" > /dev/null
        mkfontscale "$HOME/.local/share/fonts" > /dev/null
    fi
    success "font cache done!"
}

# }}}

### main {{{
main () {
    if [ $# -gt 0 ]
    then
        case $1 in
            --uninstall|-u)
                info "Trying to uninstall SpaceVim"
                uninstall_vim
                uninstall_neovim
                echo_with_color ${BWhite} "Thanks!"
                exit 0
                ;;
            --checkRequirements|-c)
                check_requirements
                exit 0
                ;;
            --install|-i)
                welcome
                need_cmd 'git'
                fetch_repo
                if [ $# -eq 2 ]
                then
                    case $2 in
                        neovim)
                            install_neovim
                            install_done
                            exit 0
                            ;;
                        vim)
                            install_vim
                            install_done
                            exit 0
                    esac
                fi
                install_vim
                install_neovim
                install_done
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
    else
        welcome
        need_cmd 'git'
        fetch_repo
        install_vim
        install_neovim
        install_package_manager
        install_fonts
        install_done
    fi
}

# }}}

main $@

# vim:set nofoldenable foldmethod=marker:
