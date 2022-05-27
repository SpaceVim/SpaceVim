FROM debian:stable

MAINTAINER Shidong Wang <wsdjeg@outlook.com>

RUN apt-get update && \
    apt-get install -y \
    neovim \
    curl \
    python3 \
    python3-pip \
    lua5.3 \
    git \
    exuberant-ctags \
    silversearcher-ag && \
    apt-get clean

ENV HOME /home/spacevim

RUN groupdel users                                              \
  && groupadd -r spacevim                                       \
  && useradd --create-home --home-dir $HOME                     \
             -r -g spacevim                                     \
             spacevim

USER spacevim

WORKDIR $HOME

ENV PYTHON3_HOST_PROG "/usr/bin/python3"

RUN mkdir -p $HOME/.config $HOME/.SpaceVim.d

RUN pip install --user pynvim

RUN curl https://raw.githubusercontent.com/SpaceVim/SpaceVim/master/docker/init.toml > $HOME/.SpaceVim.d/init.toml

RUN curl -sLf https://spacevim.org/install.sh | bash

RUN nvim --headless +'call dein#install#_update([], "install", v:false)' +qall

RUN rm $HOME/.SpaceVim.d/init.toml

ENTRYPOINT nvim
