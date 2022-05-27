@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %*);'+[String]::Join(';',(Get-Content '%~f0') -notmatch '^^@PowerShell.*EOF$')) & goto :EOF

Push-Location ~

$app_name = "SpaceVim"
$repo_url = "https://github.com/SpaceVim/SpaceVim.git"
$repo_name = "SpaceVim"
$repo_path = "$HOME\.SpaceVim"
$version= "2.0.0-dev"

echo ""
echo "        /######                                     /##    /##/##             "
echo "       /##__  ##                                   | ##   | #|__/             "
echo "      | ##  \__/ /######  /######  /####### /######| ##   | ##/##/######/#### "
echo "      |  ###### /##__  ##|____  ##/##_____//##__  #|  ## / ##| #| ##_  ##_  ##"
echo "       \____  #| ##  \ ## /######| ##     | ########\  ## ##/| #| ## \ ## \ ##"
echo "       /##  \ #| ##  | ##/##__  #| ##     | ##_____/ \  ###/ | #| ## | ## | ##"
echo "      |  ######| #######|  ######|  ######|  #######  \  #/  | #| ## | ## | ##"
echo "       \______/| ##____/ \_______/\_______/\_______/   \_/   |__|__/ |__/ |__/"
echo "               | ##                                                           "
echo "               | ##                                                           "
echo "               |__/                                                           "
echo "                      version : $version        by : spacevim.org             "

Function Pause ($Message = "Press any key to continue . . . ") {
    if ((Test-Path variable:psISE) -and $psISE) {
        $Shell = New-Object -ComObject "WScript.Shell"
        $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
    } else {
        Write-Host -NoNewline $Message
        [void][System.Console]::ReadKey($true)
        Write-Host
    }
}

echo ""
echo "==> Starting Testing Procedure..."
echo ""
sleep 1


echo "==> Testing git"
if (Get-Command "git" -ErrorAction SilentlyContinue) {
    git version
    echo "[OK] Test successfully. Moving to next..."
    sleep 1
} else {
    echo ""
    echo "[ERROR] Unable to find 'git.exe' in your PATH"
    echo ">>> Ready to Exit......"
    Pause
    exit
}

echo ""

echo "==> Testing Vim/Neovim"
if (Get-Command "vim" -ErrorAction SilentlyContinue) {
    echo ($(vim --version) -split '\n')[0]
    echo "[OK] Test successfully. Moving to next..."
    sleep 1
} elseif (Get-Command "nvim" -ErrorAction SilentlyContinue) {
    echo ($(nvim --version) -split '\n')[0]
    echo "[OK] Test successfully. Moving to next..."
    sleep 1
} else {
    echo ""
    echo "[ERROR] Unable to find 'vim.exe' or 'nvim.exe' in your PATH"
    echo "Please install neovim/vim later or make your PATH correctly set!"
    echo ">>> Ready to Exit......"
    Pause
    exit
}

echo ""
echo "<== Testing Procedure Completed. Moving to next..."
echo ""
sleep 1

if (!(Test-Path $HOME\.SpaceVim)) {
    echo "==> Trying to clone $app_name"
    git clone $repo_url $repo_path
    echo "<== $app_name cloned"
} else {
    echo "==> Trying to update $app_name"
    Push-Location $repo_path
    git pull origin master
    Pop-Location
    echo "<== $app_name updated"
}

if (Test-Path $HOME/_vimrc) {
    mv $HOME/_vimrc $HOME\vimfiles_back
    echo "Backing up _vimrc"
}

echo ""
echo "==> Trying to install $app_name for Vim"
if (!(Test-Path $HOME\vimfiles)) {
  cmd /c mklink /J $HOME\vimfiles $repo_path
  echo "[OK] vimfiles created"
} else {
    echo "Backing up vimfiles"
    if (Test-Path $HOME\vimfiles_back) {
        cmd /c rmdir /s /q $HOME\vimfiles_back
    }
    mv $HOME\vimfiles $HOME\vimfiles_back
    cmd /c mklink /J $HOME\vimfiles $repo_path
    echo "[OK] vimfiles updated"
    sleep 1
}
echo "<== $app_name for Vim installed"
echo ""

if (Get-Command "nvim" -ErrorAction SilentlyContinue) {
  echo "==> Trying to install $app_name for Neovim"
  if (!(Test-Path $HOME\AppData\Local\nvim)) {
    cmd /c mklink /J "$HOME\AppData\Local\nvim" $repo_path
    echo "[OK] nvim created"
} else {
    if (Test-Path $HOME\AppData\Local\nvim_back) {
      cmd /c rmdir /s /q $HOME\AppData\Local\nvim_back
    }
    cmd /c rmdir /s /q  $HOME\vimfiles_back
    mv $HOME\AppData\Local\nvim $HOME\AppData\Local\nvim_back
    cmd /c mklink /J $HOME\AppData\Local\nvim $repo_path
    echo "[OK] nvim updated"
    sleep 1
}
  echo "<== $app_name for Neovim installed"
}

Pop-Location

echo ""
echo "Almost done!"
echo "=============================================================================="
echo "==    Open Vim or Neovim and it will install the plugins automatically      =="
echo "=============================================================================="
echo ""
echo "That's it. Thanks for installing $app_name. Enjoy!"
echo ""
Pause

