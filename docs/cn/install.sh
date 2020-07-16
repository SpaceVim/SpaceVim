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
    error "需要 '$1' （找不到命令）"
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
    info "正在更新 SpaceVim..."
    cd "$HOME/.SpaceVim"
    git pull
    cd - > /dev/null 2>&1
    success "SpaceVim 更新已完成"
  else
    info "正在安装 SpaceVim..."
    git clone https://github.com/SpaceVim/SpaceVim.git "$HOME/.SpaceVim"
    success "SpaceVim 安装已完成"
  fi
}
# }}}

# install_vim {{{
install_vim () {
  if [[ -f "$HOME/.vimrc" ]]; then
    mv "$HOME/.vimrc" "$HOME/.vimrc_back"
    success "备份 $HOME/.vimrc 至 $HOME/.vimrc_back"
  fi

  if [[ -d "$HOME/.vim" ]]; then
    if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
      success "已为 vim 安装了 SpaceVim"
    else
      mv "$HOME/.vim" "$HOME/.vim_back"
      success "备份 $HOME/.vim 至 $HOME/.vim_back"
      ln -s "$HOME/.SpaceVim" "$HOME/.vim"
      success "已为 vim 安装了 SpaceVim"
    fi
  else
    ln -s "$HOME/.SpaceVim" "$HOME/.vim"
    success "已为 vim 安装了 SpaceVim"
  fi
}
# }}}

# install_package_manager {{{
install_package_manager () {
  if [[ ! -d "$HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim" ]]; then
    info "正在安装 dein.vim"
    git clone https://github.com/Shougo/dein.vim.git $HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim
    success "dein.vim 安装已完成"
  fi
}
# }}}

# install_neovim {{{
install_neovim () {
  if [[ ! -d "$HOME/.config/" ]];then
    mkdir "$HOME/.config/"
  fi
  if [[ -d "$HOME/.config/nvim" ]]; then
    if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
      success "已为 neovim 安装了 SpaceVim"
    else
      mv "$HOME/.config/nvim" "$HOME/.config/nvim_back"
      success "备份 $HOME/.config/nvim 至 $HOME/.config/nvim_back"
      ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
      success "已为 neovim 安装了 SpaceVim"
    fi
  else
    ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
    success "已为 neovim 安装了 SpaceVim"
  fi
}
# }}}

# uninstall_vim {{{
uninstall_vim () {
  if [[ -d "$HOME/.vim" ]]; then
    if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
      rm "$HOME/.vim"
      success "已为 vim 卸载了 SpaceVim"
      if [[ -d "$HOME/.vim_back" ]]; then
        mv "$HOME/.vim_back" "$HOME/.vim"
        success "从 $HOME/.vim_back 恢复了原始配置"
      fi
    fi
  fi
  if [[ -f "$HOME/.vimrc_back" ]]; then
    mv "$HOME/.vimrc_back" "$HOME/.vimrc"
    success "从 $HOME/.vimrc_back 恢复了原始配置"
  fi
}
# }}}

# uninstall_neovim {{{
uninstall_neovim () {
  if [[ -d "$HOME/.config/nvim" ]]; then
    if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
      rm "$HOME/.config/nvim"
      success "已为 neovim 卸载了 SpaceVim"
      if [[ -d "$HOME/.config/nvim_back" ]]; then
        mv "$HOME/.config/nvim_back" "$HOME/.config/nvim"
        success "从 $HOME/.config/nvim_back 恢复了原始配置"
      fi
    fi
  fi
}
# }}}

# check_requirements {{{
check_requirements () {
  info "正在检测 SpaceVim 依赖环境..."
  if hash "git" &>/dev/null; then
    git_version=$(git --version)
    success "检测 git 版本：${git_version}"
  else
    warn "缺少依赖：git"
  fi
  if hash "vim" &>/dev/null; then
    is_vim8=$(vim --version | grep "Vi IMproved 8")
    is_vim74=$(vim --version | grep "Vi IMproved 7.4")
    if [ -n "$is_vim8" ]; then
      success "检测到 Vim 版本: vim 8.0"
    elif [ -n "$is_vim74" ]; then
      success "检测到 Vim 版本: vim 7.4"
    else
      if hash "nvim" &>/dev/null; then
        success "检测到 Neovim 已安装成功"
      else
        warn "SpaceVim 需要 Neovim 或者 vim 7.4 及更高版本"
      fi
    fi
    if hash "nvim" &>/dev/null; then
      success "Check Requirements: nvim"
      success "检测到 Neovim 已安装成功"
    fi
  else
    if hash "nvim" &>/dev/null; then
      success "检测到 Neovim 已安装成功"
    else
      warn "SpaceVim 需要 Neovim 或者 vim 7.4 及更高版本"
    fi
  fi
  info "正在检测终端真色支持..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh)"
}
# }}}

# usage {{{
usage () {
  echo_with_color ${BWhite} "SpaceVim 安装脚本 : V ${Version}"
  echo_with_color ""
  echo_with_color ${Color_off} "  这是 SpaceVim 初始化脚本，可用于定制安装、更新及卸载 SpaceVim。"
  echo_with_color ""
  echo_with_color "使用"
  echo_with_color ""
  echo_with_color "  curl -sLf https://spacevim.org/cn/install.sh | bash -s -- [选项] [对象]"
  echo_with_color ""
  echo_with_color "所有选项"
  echo_with_color ""
  echo_with_color " -i, --install            为 vim 和 neovim 安装 SpaceVim"
  echo_with_color " -v, --version            显示当前安装脚本的版本"
  echo_with_color " -u, --uninstall          卸载 SpaceVim"
  echo_with_color " -c, --checkRequirements  检测环境依赖"
  echo_with_color ""
  echo_with_color "使用示例"
  echo_with_color ""
  echo_with_color "    默认同时为 vim 和 neovim 安装 SpaceVim"
  echo_with_color ""
  echo_with_color "        curl -sLf https://spacevim.org/cn/install.sh | bash"
  echo_with_color ""
  echo_with_color "    只为 vim 或者 neovim 单独安装 SpaceVim"
  echo_with_color ""
  echo_with_color "        curl -sLf https://spacevim.org/cn/install.sh | bash -s -- --install vim"
  echo_with_color "        curl -sLf https://spacevim.org/cn/install.sh | bash -s -- --install neovim"
  echo_with_color ""
  echo_with_color "    卸载 SpaceVim"
  echo_with_color ""
  echo_with_color "        curl -sLf https://spacevim.org/cn/install.sh | bash -s -- --uninstall"
}
# }}}

# install_done {{{

install_done () {
  echo_with_color ${Yellow} ""
  echo_with_color ${Yellow} "安装已完成!"
  echo_with_color ${Yellow} "=============================================================================="
  echo_with_color ${Yellow} "==               打开 Vim 或 Neovim，所有插件将会自动安装                   =="
  echo_with_color ${Yellow} "=============================================================================="
  echo_with_color ${Yellow} ""
  echo_with_color ${Yellow} "感谢支持 SpaceVim，欢迎反馈！"
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
    echo_with_color ${Yellow} "                    版本 : ${Version}  中文官网 : https://spacevim.org/cn/    "
}

# }}}

# download_font {{{
download_font () {
  url="https://raw.githubusercontent.com/wsdjeg/DotFiles/master/local/share/fonts/$1"
  path="$HOME/.local/share/fonts/$1"
  if [[ -f "$path" ]]
  then
    success "已下载 $1"
  else
    info "正在下载 $1"
    curl -s -o "$path" "$url"
    success "已下载 $1"
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
  info "正在构建字体缓存，请稍等..."
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
  success "字体安装已完成!"
}

# }}}

### main {{{
main () {
  if [ $# -gt 0 ]
  then
    case $1 in
      --uninstall|-u)
        info "正在卸载 SpaceVim..."
        uninstall_vim
        uninstall_neovim
        echo_with_color ${BWhite} "感谢体验 SpaceVim，期待再次回来..."
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
