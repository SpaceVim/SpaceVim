install_vim() {
    local URL=https://github.com/vim/vim
    local tag=$1
    local ext=$([[ $tag == "HEAD" ]] && echo "" || echo "-b $tag")
    local tmp="$(mktemp -d)"
    local out="${DEPS}/_vim/$tag"
    mkdir -p $out
    local ncpu=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)
    git clone --depth 1 --single-branch $ext $URL $tmp
    cd $tmp
    ./configure --enable-fail-if-missing \
        --with-features=huge \
        --enable-pythoninterp \
        --enable-python3interp \
        --enable-luainterp \
        --prefix=${out}
    make -j$ncpu
    make install
}

install_nvim() {
    local URL=https://github.com/neovim/neovim
    local tag=$1
    local ext=$([[ $tag == "HEAD" ]] && echo "" || echo "-b $tag")
    local tmp="$(mktemp -d)"
    local out="${DEPS}/_neovim/$tag"
    mkdir -p $out
    local ncpu=$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)
    git clone --depth 1 --single-branch $ext $URL $tmp
    cd $tmp
    make deps
    make -j$ncpu \
        CMAKE_BUILD_TYPE=Release \
        CMAKE_EXTRA_FLAGS="-DTRAVIS_CI_BUILD=ON -DCMAKE_INSTALL_PREFIX:PATH=$out"
    make install
    pip install --user pynvim
    pip3 install --user pynvim
}

install() {
    local vim=$1
    local tag=$2

    if [[ -d "${DEPS}/_$vim/$tag/bin" ]]; then
        echo "Use a cached version '$HOME/_$vim/$tag'."
        return
    fi
    if [[ $vim == "nvim" ]]; then
        install_nvim $tag
    else
        install_vim $tag
    fi
}

install $@
