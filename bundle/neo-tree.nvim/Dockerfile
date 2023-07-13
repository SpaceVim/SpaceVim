FROM ubuntu:22.04

RUN apt update
# install neovim dependencies
RUN apt install -y git ninja-build gettext libtool libtool-bin autoconf \
                   automake cmake g++ pkg-config unzip curl doxygen

# install neovim
RUN git clone https://github.com/neovim/neovim
RUN cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

# install required plugins
ARG PLUG_DIR="root/.local/share/nvim/site/pack/packer/start"
RUN git clone https://github.com/nvim-lua/plenary.nvim $PLUG_DIR/plenary.nvim
RUN git clone https://github.com/MunifTanjim/nui.nvim $PLUG_DIR/nui.nvim
COPY . $PLUG_DIR/neo-tree.nvim

WORKDIR $PLUG_DIR/neo-tree.nvim
