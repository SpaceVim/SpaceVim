install_vim() {
  local URL=https://github.com/vim/vim
  local tag=$1
  local ext=$([[ $tag == "HEAD" ]] && echo "" || echo "-b $tag")
  local tmp="$(mktemp -d)"
  local out="$HOME/cache/vim-$tag"
  local ncpu=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)
  git clone --depth 1 --single-branch $ext $URL $tmp
  cd $tmp
  ./configure --prefix=$out \
      --enable-fail-if-missing \
      --with-features=huge \
      --enable-pythoninterp \
      --enable-python3interp \
      --enable-luainterp
  make -j$ncpu
  make install
  ln -s $out $HOME/vim
}

install_nvim() {
  local URL=https://github.com/neovim/neovim
  local tag=$1
  local ext=$([[ $tag == "HEAD" ]] && echo "" || echo "-b $tag")
  local tmp="$(mktemp -d)"
  local out="$HOME/cache/nvim-$tag"
  local ncpu=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)
  git clone --depth 1 --single-branch $ext $URL $tmp
  cd $tmp
  make deps
  make -j$ncpu \
    CMAKE_BUILD_TYPE=Release \
    CMAKE_EXTRA_FLAGS="-DTRAVIS_CI_BUILD=ON -DCMAKE_INSTALL_PREFIX:PATH=$out"
  make install
  pip install --user neovim
  easy_install3 --user neovim
  ln -sf $out $HOME/vim
}

install() {
  local vim=$1
  local tag=$2

  [[ -d $HOME/vim ]] && rm -f $HOME/vim
  if [[ $tag != "HEAD" ]] && [[ -d "$HOME/cache/$vim-$tag" ]]; then
    echo "Use a cached version '$HOME/cache/$vim-$tag'."
    ln -sf $HOME/cache/$vim-$tag $HOME/vim
    return
  fi
  if [[ $vim == "nvim" ]]; then
    install_nvim $tag
  else
    install_vim $tag
  fi
}
