function install_vim($ver)
{
  if ($ver -eq "nightly")
  {
    $url = 'https://github.com/vim/vim-win32-installer/releases/download/v8.2.3361/gvim_8.2.3361_x86.zip'
  }
  else
  {
    $ver = $ver -replace "^v", ""
    $url = 'https://github.com/vim/vim-win32-installer/releases/download/v' + $ver + '/gvim_' + $ver + '_x86.zip'
  }
  $Env:VIM_BIN = $Env:DEPS + '\vim\vim82\vim.exe'
  $zip = $Env:DEPS + '\vim.zip'
  echo "download: $url"
  echo "path: $zip"
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $Env:DEPS)
}

function install_nvim($ver)
{
  if ($ver -eq "nightly")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip'
  }
  else
  {
    $url = 'https://github.com/neovim/neovim/releases/download/' + $ver + '/nvim-win64.zip'
  }
  $Env:VIM_BIN = $Env:DEPS + '\Neovim\bin\nvim.exe'
  $zip = $Env:DEPS + '\nvim.zip'
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $Env:DEPS)
}

function download_lua()
{
  $url = 'https://github.com/wsdjeg/vim-galore-zh_cn/releases/download/downdows/lua53.zip'
  $zip = $Env:DEPS + '\lua53.zip'
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $Env:DEPS + '\vim\vim82')
}

if ($Env:VIM_BIN.StartsWith("nvim"))
{
  mkdir $Env:DEPS
  install_nvim $Env:VIM_TAG
}
elseif ($Env:VIM_BIN.StartsWith("vim"))
{
  mkdir $Env:DEPS
  install_vim $Env:VIM_TAG
  download_lua
}
