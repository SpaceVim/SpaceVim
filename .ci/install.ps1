function install_vim($name)
{
  $ver = $name -replace "^Official\s*", ""
  if ($ver -eq "latest-32")
  {
    $url1 = 'ftp://ftp.vim.org/pub/vim/pc/vim80w32.zip'
  }
  elseif ($ver -eq "8.0.0069-32")
  {
    $url1 = 'ftp://ftp.vim.org/pub/vim/pc/vim80-069w32.zip'
  }
  $url2 = 'ftp://ftp.vim.org/pub/vim/pc/vim80rt.zip'
  $zip1 = $Env:APPVEYOR_BUILD_FOLDER + '\vim.zip'
  $zip2 = $Env:APPVEYOR_BUILD_FOLDER + '\vim-rt.zip'
  (New-Object Net.WebClient).DownloadFile($url1, $zip1)
  (New-Object Net.WebClient).DownloadFile($url2, $zip2)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip1, $Env:APPVEYOR_BUILD_FOLDER)
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip2, $Env:APPVEYOR_BUILD_FOLDER)
  $Env:THEMIS_VIM = $Env:APPVEYOR_BUILD_FOLDER + '\vim\vim80\vim.exe'
}

function install_kaoriya_vim($name)
{
  $ver = $name -replace "^Kaoriya\s*", ""
  if ($ver -eq "latest-32")
  {
    $url = 'http://vim-jp.org/redirects/koron/vim-kaoriya/latest/win32/'
  }
  elseif ($ver -eq "latest-64")
  {
    $url = 'http://vim-jp.org/redirects/koron/vim-kaoriya/latest/win64/'
  }
  elseif ($ver -eq "8.0.0082-32")
  {
    $url = 'https://github.com/koron/vim-kaoriya/releases/download/v8.0.0082-20161113/vim80-kaoriya-win32-8.0.0082-20161113.zip'
  }
  elseif ($ver -eq "8.0.0082-64")
  {
    $url = 'https://github.com/koron/vim-kaoriya/releases/download/v8.0.0082-20161113/vim80-kaoriya-win64-8.0.0082-20161113.zip'
  }
  $zip = $Env:APPVEYOR_BUILD_FOLDER + '\kaoriya-vim.zip'
  $out = $Env:APPVEYOR_BUILD_FOLDER + '\kaoriya-vim\'
  if ($url.StartsWith('http://vim-jp.org/redirects/')) 
  {
    $redirect = Invoke-WebRequest -URI $url
    (New-Object Net.WebClient).DownloadFile($redirect.Links[0].href, $zip)
  }
  else
  {
    (New-Object Net.WebClient).DownloadFile($url, $zip)
  }
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $out)
  $Env:THEMIS_VIM = $out + (Get-ChildItem $out).Name + '\vim.exe'
}

function install_nvim($name)
{
  $ver = $name -replace "^Neovim\s*", ""
  if ($ver -eq "latest-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/nightly/nvim-win32.zip'
  }
  elseif ($ver -eq "latest-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.8-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.8/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.8-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.8/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.7-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.7/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.7-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.7/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.5-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.5/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.5-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.5/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.4-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.4-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.3-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.3/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.3-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.3/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.2-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.2/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.2-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.2/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.1-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.1/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.1-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.1/nvim-win64.zip'
  }
  elseif ($ver -eq "0.3.0-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.0/nvim-win32.zip'
  }
  elseif ($ver -eq "0.3.0-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.3.0/nvim-win64.zip'
  }
  elseif ($ver -eq "0.2.2-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.2.2/nvim-win32.zip'
  }
  elseif ($ver -eq "0.2.2-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.2.2/nvim-win64.zip'
  }
  elseif ($ver -eq "0.2.0-32")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.2.0/nvim-win32.zip'
  }
  elseif ($ver -eq "0.2.0-64")
  {
    $url = 'https://github.com/neovim/neovim/releases/download/v0.2.0/nvim-win64.zip'
  }
  $zip = $Env:APPVEYOR_BUILD_FOLDER + '\nvim.zip'
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $Env:APPVEYOR_BUILD_FOLDER)
  $Env:THEMIS_VIM = $Env:APPVEYOR_BUILD_FOLDER + '\Neovim\bin\nvim.exe'
  $Env:THEMIS_ARGS = '-e -s --headless'
}

if ($Env:CONDITION.StartsWith("Neovim"))
{
  install_nvim $Env:CONDITION
}
elseif ($Env:CONDITION.StartsWith("Official"))
{
  install_vim $Env:CONDITION
}
else
{
  install_kaoriya_vim $Env:CONDITION
}
