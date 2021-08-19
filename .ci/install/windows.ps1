function install_vim($ver)
{
  if ($ver -eq "nightly")
  {
    $url1 = 'https://github.com/vim/vim-win32-installer/releases/download/v8.2.0129/gvim_8.2.0129_x86.zip'
  }
  else
  {
    $ver = $ver -replace "^v", ""
    $url1 = 'https://github.com/vim/vim-win32-installer/releases/download/v' + $ver + '/gvim_' + $ver + '_x86.zip'
  }
  $Env:VIM_BIN = $Env:DEPS + '\vim\vim82\vim.exe'
  $zip1 = $Env:DEPS + '\vim.zip'
  curl  -o $zip1 -L $url1
  tar -xzvf $zip1 -C $Env:DEPS
}

function install_nvim($ver)
{
  if ($ver -eq "nightly")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/nightly/nvim-win32.zip'
  }
  else
  {
    $url = 'https://github.com/neovim/neovim/releases/download/' + $ver + '/nvim-win64.zip'
  }
  $Env:VIM_BIN = $Env:DEPS + '\Neovim\bin\nvim.exe'
  $zip = $Env:DEPS + '\nvim.zip'
  curl  -o $zip1 -L $url1
  tar -xzvf $zip1 -C $Env:DEPS
}

if ($Env:VIM_BIN.StartsWith("nvim"))
{
  install_nvim $Env:VIM_TAG
}
elseif ($Env:VIM_BIN.StartsWith("vim"))
{
  install_vim $Env:VIM_TAG
}
