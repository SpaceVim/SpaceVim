@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %*);'+[String]::Join(';',(Get-Content '%~f0') -notmatch '^^@PowerShell.*EOF$')) & goto :EOF

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
echo "                      version : 1.5.0-dev       by : spacevim.org             "

Push-Location ~

$app_name    = "SpaceVim"
$repo_url    = "https://github.com/SpaceVim/SpaceVim.git"
$repo_name   = "SpaceVim"
$repo_path   = "$HOME\.SpaceVim"

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

echo "==> Testing vim"
if (Get-Command "gvim" -ErrorAction SilentlyContinue) {
    echo ($(vim --version) -split '\n')[0]
    echo "[OK] Test successfully. Moving to next..."
    sleep 1
} else {
    echo "[WARNING] Unable to find 'gvim.exe' in your PATH. But intallation still can continue..."
    echo ""
    echo "[WARNING] Please install gvim later or  make your PATH correctly set! "
    Pause
}

echo "<== Testing Procedure Completed. Moving to next..."
sleep 1
echo ""
echo ""

if (!(Test-Path "$HOME\.SpaceVim")) {
    echo "==> Trying to clone $app_name"
    git clone $repo_url $repo_path
} else {
    echo "==> Trying to update $app_name"
    Push-Location $repo_path
    git pull origin master
}

echo ""

if (!(Test-Path "$HOME\vimfiles")) {
    cmd /c mklink /D $HOME\vimfiles $repo_path
} else {
    echo "[OK] vimfiles already exists"
	sleep 1
}
echo ""

if (!(Test-Path "$HOME\AppData\Local\nvim")) {
  cmd /c mklink /D "$HOME\AppData\Local\nvim" $repo_path
} else {
    echo "[OK] $HOME\AppData\Local\nvim already exists"
	sleep 1
}

echo ""
echo "Almost done!"
echo "=============================================================================="
echo "==        Open GVim and it will install the plugins automatically           =="
echo "=============================================================================="
echo ""
echo "That's it. Thanks for installing $app_name. Enjoy!"
echo ""

Pause

# vim:set ft=powershell nowrap: 
