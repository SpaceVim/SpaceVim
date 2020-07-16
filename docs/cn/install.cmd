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
echo "                    版本: 1.5.0-dev    中文官网: https://spacevim.org/cn/     "

Push-Location ~

$app_name    = "SpaceVim"
$repo_url    = "https://github.com/SpaceVim/SpaceVim.git"
$repo_name   = "SpaceVim"
$repo_path   = "$HOME\.SpaceVim"

Function Pause ($Message = "请按任意按键继续 . . . ") {
  if ((Test-Path variable:psISE) -and $psISE) {
    $Shell = New-Object -ComObject "WScript.Shell"
      $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
  } else {     
    Write-Host -NoNewline $Message
      [void][System.Console]::ReadKey($true)
      Write-Host
  }
}

echo "==> 开始检测环境依赖..."
echo ""
sleep 1


echo "==> 测试 git 命令"
if (Get-Command "git" -ErrorAction SilentlyContinue) {
  git version
  echo "[OK] 测试成功. 开始下一个测试..."
  sleep 1
} else {
  echo ""
  echo "[ERROR] 无法在你的 PATH 中发现 'git.exe' 命令"
  echo ">>> 准备退出......"
  Pause
  exit
}

echo ""

echo "==> 测试 gvim 命令"
if (Get-Command "gvim" -ErrorAction SilentlyContinue) {
  echo ($(vim --version) -split '\n')[0]
  echo "[OK] 测试成功. 开始下一个测试..."
  sleep 1
} else {
  echo "[WARNING] 无法在你的 PATH 中发现 'gvim.exe' 命令. 但仍可继续安装..."
  echo ""
  echo "[WARNING] 请后续安装 gvim 或者正确设置你的 PATH! "
  Pause
}

echo "<== 环境依赖检测已完成. 继续下一步..."
sleep 1
echo ""
echo ""

if (!(Test-Path "$HOME\.SpaceVim")) {
  echo "==> 正在安装 $app_name"
  git clone $repo_url $repo_path
} else {
  echo "==> 正在更新 $app_name"
  Push-Location $repo_path
  git pull origin master
}

echo ""
if (!(Test-Path "$HOME\vimfiles")) {
  cmd /c mklink $HOME\vimfiles $repo_path
  echo "[OK] 已为 vim 安装 SpaceVim"
  sleep 1
} else {
  echo "[OK] $HOME\vimfiles 已存在"
  sleep 1
}

echo ""
if (!(Test-Path "$HOME\AppData\Local\nvim")) {
  cmd /c mklink "$HOME\AppData\Local\nvim" $repo_path
  echo "[OK] 已为 neovim 安装 SpaceVim"
  sleep 1
} else {
  echo "[OK] $HOME\AppData\Local\nvim 已存在"
  sleep 1
}

echo ""
echo "安装已完成!"
echo "=============================================================================="
echo "==               打开 Vim 或 Neovim，所有插件将会自动安装                   =="
echo "=============================================================================="
echo ""
echo "感谢支持 SpaceVim，欢迎反馈！"
echo ""

Pause

# vim:set ft=powershell nowrap: 
