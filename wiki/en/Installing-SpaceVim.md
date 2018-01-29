### 1. Requirements

**1) Powerline font:**

By defalut SpaceVim use  [DejaVu Sans Mono for Powerline](https://github.com/powerline/fonts/tree/master/DejaVuSansMono), to make statusline render correctly, you need to install the font. [powerline extra symbols](https://github.com/ryanoasis/powerline-extra-symbols) also should be installed. To show the filetype icon in the tabline, you need to install [nerd-fonts](https://github.com/ryanoasis/nerd-fonts).

**2) Vim 7.4 above or neovim:**

- [neovim installation](https://github.com/neovim/neovim/wiki/Installing-Neovim)

- [install vim with python, python3 and lua support](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)

**3) git:**

SpaceVim will download all plugins via git.

### 2. Install SpaceVim in Linux/Mac

Install SpaceVim with the command below:

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After SpaceVim is installed, launch `vim` and SpaceVim will **automatically** install plugins.

for more info about the install script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

### 3. Install SpaceVim in windows

- For vim in windows, please just clone this repo as vimfiles in you Home directory.
by default, when open a cmd, the current dir is your Home directory, run this command in cmd.
make sure you have a backup of your own vimfiles. also you need remove `~/_vimrc` in your home directory.

```sh
git clone https://github.com/SpaceVim/SpaceVim.git vimfiles
```

- For neovim in windows, please clone this repo as `AppData\Local\nvim` in your home directory.
for more info, please check out [neovim's wiki](https://github.com/neovim/neovim/wiki/Installing-Neovim).
by default, when open a cmd, the current dir is your Home directory, run this command in cmd.

```bash
git clone https://github.com/SpaceVim/SpaceVim.git AppData\Local\nvim
```