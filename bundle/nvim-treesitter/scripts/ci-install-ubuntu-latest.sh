wget -O - https://github.com/tree-sitter/tree-sitter/releases/download/${TREE_SITTER_CLI_TAG}/tree-sitter-linux-x64.gz | gunzip -c > tree-sitter
sudo cp ./tree-sitter /usr/bin/tree-sitter
sudo chmod uog+rwx /usr/bin/tree-sitter
wget https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux64.tar.gz
tar -zxf nvim-linux64.tar.gz
sudo ln -s $(pwd)/nvim-linux64/bin/nvim /usr/local/bin
rm -rf $(pwd)/nvim-linux64/lib/nvim/parser
mkdir -p ~/.local/share/nvim/site/pack/nvim-treesitter/start
ln -s $(pwd) ~/.local/share/nvim/site/pack/nvim-treesitter/start
