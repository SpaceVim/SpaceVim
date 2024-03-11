curl -L https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-macos.tar.gz | tar -xz
sudo ln -s $(pwd)/nvim-macos/bin/nvim /usr/local/bin
rm -rf $(pwd)/nvim-macos/lib/nvim/parser
mkdir -p ~/.local/share/nvim/site/pack/nvim-treesitter/start
ln -s $(pwd) ~/.local/share/nvim/site/pack/nvim-treesitter/start

