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
Version='0.6.0'

# Regular Colors
Red='\033[0;31m'
Blue='\033[0;34m'
Green='\033[0;32m'

#System name
System="$(uname -s)"

need_cmd () {
  if ! hash "$1" &>/dev/null; then
    error "需要安装 '$1' (缺少相关命令)"
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
    info "正在更新 SpaceVim ..."
    git --git-dir "$HOME/.SpaceVim/.git" pull
    success "SpaceVim 更新成功！"
  else
    info "正在安装 SpaceVim ..."
    git clone https://github.com/SpaceVim/SpaceVim.git "$HOME/.SpaceVim"
    success "SpaceVim 安装成功！"
  fi
}

install_vim () {
  if [[ -f "$HOME/.vimrc" ]]; then
    mv "$HOME/.vimrc" "$HOME/.vimrc_back"
    success "备份 $HOME/.vimrc 至 $HOME/.vimrc_back"
  fi

  if [[ -d "$HOME/.vim" ]]; then
    if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
      success "已为 vim 安装 SpaceVim"
    else
      mv "$HOME/.vim" "$HOME/.vim_back"
      success "备份 $HOME/.vim 至 $HOME/.vim_back"
      ln -s "$HOME/.SpaceVim" "$HOME/.vim"
      success "已为 vim 安装 SpaceVim"
    fi
  else
    ln -s "$HOME/.SpaceVim" "$HOME/.vim"
    success "已为 vim 安装 SpaceVim"
  fi
}

install_package_manager () {
  if [[ ! -d "$HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim" ]]; then
    info "正在安装 dein.vim"
    git clone https://github.com/Shougo/dein.vim.git $HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim
    success "dein.vim 安装成功"
  fi
}

install_neovim () {
  if [[ -d "$HOME/.config/nvim" ]]; then
    if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
      success "已为 neovim 安装 SpaceVim"
    else
      mv "$HOME/.config/nvim" "$HOME/.config/nvim_back"
      success "备份 $HOME/.config/nvim 至 $HOME/.config/nvim_back"
      ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
      success "已为 neovim 安装 SpaceVim"
    fi
  else
    ln -s "$HOME/.SpaceVim" "$HOME/.config/nvim"
    success "已为 neovim 安装 SpaceVim"
  fi
}

uninstall_vim () {
  if [[ -d "$HOME/.vim" ]]; then
    if [[ "$(readlink $HOME/.vim)" =~ \.SpaceVim$ ]]; then
      rm "$HOME/.vim"
      success "已为 vim 卸载 SpaceVim"
      if [[ -d "$HOME/.vim_back" ]]; then
        mv "$HOME/.vim_back" "$HOME/.vim"
        success "从 $HOME/.vim_back 恢复原始文件"
      fi
    fi
  fi
  if [[ -f "$HOME/.vimrc_back" ]]; then
    mv "$HOME/.vimrc_back" "$HOME/.vimrc"
    success "从 $HOME/.vimrc_back 恢复原始文件"
  fi
}

uninstall_neovim () {
  if [[ -d "$HOME/.config/nvim" ]]; then
    if [[ "$(readlink $HOME/.config/nvim)" =~ \.SpaceVim$ ]]; then
      rm "$HOME/.config/nvim"
      success "已为 neovim 卸载 SpaceVim"
      if [[ -d "$HOME/.config/nvim_back" ]]; then
        mv "$HOME/.config/nvim_back" "$HOME/.config/nvim"
        success "从 $HOME/.config/nvim_back 恢复原始文件"
      fi
    fi
  fi
}

check_requirements () {
  info "SpaceVim 环境依赖检查："
  if hash "git" &>/dev/null; then
    git_version=$(git --version)
    success "检测依赖: ${git_version}"
  else
    warn "检测依赖 : git"
  fi
  if hash "vim" &>/dev/null; then
    is_vim8=$(vim --version | grep "Vi IMproved 8.0")
    is_vim74=$(vim --version | grep "Vi IMproved 7.4")
    if [ -n "$is_vim8" ]; then
      success "检测依赖: vim 8.0"
    elif [ -n "$is_vim74" ]; then
      success "检测依赖: vim 7.4"
    else
      if hash "nvim" &>/dev/null; then
        success "检测依赖: nvim"
      else
        warn "SpaceVim 需要 vim 7.4 或更高版本"
      fi
    fi
    if hash "nvim" &>/dev/null; then
      success "检测依赖: nvim"
    fi
  else
    if hash "nvim" &>/dev/null; then
      success "检测依赖: nvim"
    else
      warn "检测依赖 : vim or nvim"
    fi
  fi
  info "检测终端真色支持:"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh)"
}

usage () {
  echo "SpaceVim 安装脚本 : V ${Version}"
  echo ""
  echo "使用 : curl -sLf https://spacevim.org/cn/install.sh | bash -s -- [选项] [对象]"
  echo ""
  echo "  这是一个 SpaceVim 初始化脚本。"
  echo ""
  echo "所有选项："
  echo ""
  echo " -i, --install            为 Vim 和 neovim 安装 SpaceVim"
  echo " -v, --version            显示当前版本"
  echo " -u, --uninstall          卸载 SpaceVim"
  echo " -c, --checkRequirements  检查环境依赖"
  echo ""
  echo "使用示例："
  echo ""
  echo "    同时为 vim 和 neovim 安装 SpaceVim"
  echo ""
  echo "        curl -sLf https://spacevim.org/install.sh | bash"
  echo ""
  echo "    仅为 Vim 或 neovim 安装 SpaceVim"
  echo ""
  echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --install vim"
  echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim"
  echo ""
  echo "    卸载 SpaceVim"
  echo ""
  echo "        curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall"
}



download_font () {
  url="https://raw.githubusercontent.com/wsdjeg/DotFiles/master/local/share/fonts/$1"
  path="$HOME/.local/share/fonts/$1"
  if [[ -f "$path" ]]
  then
    success "已下载 $1"
  else
    info "正在下载 $1"
    wget -q -O "$path" "$url"
    success "已下载 $1"
  fi
}

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
  echo -n "更新字体缓存 ..."
  if [ $System == "Darwin" ];then
    if [ ! -e "$HOME/Library/Fonts" ];then
      mkdir "$HOME/Library/Fonts"
    fi 
    cp $HOME/.local/share/fonts/* $HOME/Library/Fonts/
  else
    fc-cache -fv
    mkfontdir "$HOME/.local/share/fonts"
    mkfontscale "$HOME/.local/share/fonts"
  fi

  echo "安装完毕"
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
install_fonts
