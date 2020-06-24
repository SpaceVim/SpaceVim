@echo off
:: Batch file for building/testing vimproc on AppVeyor

cd %APPVEYOR_BUILD_FOLDER%
if /I "%1"=="test" (
  set _target=_test
) else (
  set _target=
)

for %%i in (msvc mingw msys2 cygwin) do if "%compiler%"=="%%i" goto %compiler%%_target%

echo Unknown build target.
exit 1

:msvc
:: ----------------------------------------------------------------------
:: Using VC10 with nmake
::call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" %ARCH%
call :install_vim
call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" %ENV%

@echo on
nmake -f make_msvc.mak CPU=%CPU% cflags=/MD

@echo off
goto :eof

:msvc_test
set THEMIS_VIM=%APPVEYOR_BUILD_FOLDER%\vim-kaoriya\vim.exe
@echo on
themis\bin\themis

@echo off
goto :eof


:mingw
:: ----------------------------------------------------------------------
:: Using MinGW
call :install_vim
@echo on
path C:\MinGW\bin;C:\MinGW\msys\1.0\bin;%path%
make -f make_mingw32.mak

@echo off
goto :eof

:mingw_test
set THEMIS_VIM=%APPVEYOR_BUILD_FOLDER%\vim-kaoriya\vim.exe
@echo on
themis\bin\themis

@echo off
goto :eof


:msys2
:: ----------------------------------------------------------------------
:: Using MSYS2
call :install_vim
@echo on
PATH C:\%MSYS2_DIR%\%MSYSTEM%\bin;C:\%MSYS2_DIR%\usr\bin;%PATH%
set CHERE_INVOKING=yes
:: Install and update necessary packages
rem bash -lc "for i in {1..3}; do update-core && break || sleep 15; done"
rem bash -lc "for i in {1..3}; do pacman --noconfirm -Su mingw-w64-%MSYS2_ARCH%-{gcc,make} make && break || sleep 15; done"

bash -lc "make"

@echo off
goto :eof

:msys2_test
set THEMIS_VIM=%APPVEYOR_BUILD_FOLDER%\vim-kaoriya\vim.exe
@echo on
themis\bin\themis

@echo off
goto :eof


:cygwin
:: ----------------------------------------------------------------------
:: Using Cygwin
@echo on
goto cygwin%BIT%

:cygwin32
@echo on
c:\cygwin\setup-x86.exe -qnNdO -R C:/cygwin -s http://cygwin.mirror.constant.com -l C:/cygwin/var/cache/setup -P vim
PATH c:\cygwin\bin;%PATH%
set CHERE_INVOKING=yes
bash -lc ""
bash -lc "make"

@echo off
goto :eof

:cygwin64
@echo on
c:\cygwin64\setup-x86_64.exe -qnNdO -R C:/cygwin64 -s http://cygwin.mirror.constant.com -l C:/cygwin/var/cache/setup -P vim
PATH c:\cygwin64\bin;%PATH%
set CHERE_INVOKING=yes
bash -lc ""
bash -lc "make"

@echo off
goto :eof


:cygwin_test
@echo on
rem bash -lc "git clone -q https://github.com/thinca/vim-themis.git themis --depth=1"
rem bash -lc "themis/bin/themis"

@echo off
goto :eof


:install_vim
:: ----------------------------------------------------------------------
:: Install Vim and themis
echo Downloading Vim
py tools\dl-kaoriya-vim.py --arch win%BIT% --filename vim.zip
echo Installing Vim
7z x vim.zip > nul
move vim??-kaoriya-win%BIT% vim-kaoriya
git clone -q https://github.com/thinca/vim-themis.git themis --depth=1
exit /b
