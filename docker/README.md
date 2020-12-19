## SpaceVim and Neovim in Docker

![Docker Build Status](https://img.shields.io/docker/build/spacevim/spacevim.svg)

This Dockerfile builds neovim `HEAD` and installs the latest available version of SpaceVim. You might want to use this for several reasons:

- Have a consistent version of Neovim and SpaceVim as long as the machine supports Docker.
- Try SpaceVim without modifying your current Vim/Neovim configuration.
- Try the latest Neovim with SpaceVim.
- Try SpaceVim with a newer version of Python.
- Debug SpaceVim configurations. e.g. when posting a bug report if you can reproduce it in this container then there's a higher chance that it is a true bug and not just an issue with your machine.

### FAQ

Isn't Docker stateless? Won't I have to reinstall all plugins each time I launch the container?

- During the build we call `dein#install()` so all plugins are installed and frozen. Your custom configurations can be added as an additional build step using the Docker `COPY` command.

### Build

You can build using the supplied `Makefile`:

    make build

or call the command manually using:

    docker build -t nvim -f Dockerfile.nvim-python3 .

### Run

You can run the container using:

    docker run -it nvim

but that isn't terribly useful since changes made inside the container won't be visible outside. More useful is mounting the current working directory inside the container:

    docker run -it -v $(pwd):/home/spacevim/src nvim

Even better is an alias `dnvim` which will do this automatically:

    alias dnvim='docker run -it -v $(pwd):/home/spacevim/src nvim'
