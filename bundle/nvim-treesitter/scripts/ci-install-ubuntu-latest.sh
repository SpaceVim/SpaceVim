wget -O - https://github.com/tree-sitter/tree-sitter/releases/download/${TREE_SITTER_CLI_TAG}/tree-sitter-linux-x64.gz | gunzip -c > tree-sitter
sudo cp ./tree-sitter /usr/bin/tree-sitter
sudo chmod uog+rwx /usr/bin/tree-sitter
wget https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim.appimage
chmod u+x nvim.appimage
mkdir -p ~/.local/share/nvim/site/pack/nvim-treesitter/start
ln -s $(pwd) ~/.local/share/nvim/site/pack/nvim-treesitter/start
sudo cp ./nvim.appimage /usr/bin/nvim
sudo chmod uog+rwx /usr/bin/nvim

