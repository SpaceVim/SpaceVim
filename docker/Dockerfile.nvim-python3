FROM python:3.6.5-stretch

ENV DEBIAN_URL "http://ftp.us.debian.org/debian"

RUN echo "deb $DEBIAN_URL testing main contrib non-free" >> /etc/apt/sources.list \
  && apt-get update                                             \
  && apt-get install -y                                         \
    autoconf                                                    \
    automake                                                    \
    cmake                                                       \
    fish                                                        \
    g++                                                         \
    gettext                                                     \
    git                                                         \
    libtool                                                     \
    libtool-bin                                                 \
    lua5.3                                                      \
    ninja-build                                                 \
    pkg-config                                                  \
    unzip                                                       \
    xclip                                                       \
    xfonts-utils                                                \
  && apt-get clean all

RUN cd /usr/src                                                 \
  && git clone https://github.com/neovim/neovim.git             \
  && cd neovim                                                  \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo                       \
          CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr/local" \
  && make install                                               \
  && rm -r /usr/src/neovim

ENV HOME /home/spacevim

RUN groupdel users                                              \
  && groupadd -r spacevim                                       \
  && useradd --create-home --home-dir $HOME                     \
             -r -g spacevim                                     \
             spacevim

USER spacevim

WORKDIR $HOME
ENV PATH "$HOME/.local/bin:${PATH}"

RUN mkdir -p $HOME/.config $HOME/.SpaceVim.d

RUN pip install --user neovim pipenv

RUN curl https://raw.githubusercontent.com/SpaceVim/SpaceVim/master/docker/init.toml > $HOME/.SpaceVim.d/init.toml

RUN curl -sLf https://spacevim.org/install.sh | bash

RUN nvim --headless +'call dein#install()' +qall

RUN rm $HOME/.SpaceVim.d/init.toml

ENTRYPOINT /usr/local/bin/nvim
