@echo off
rem Update the DLL using MinGW.
rem If the old DLL is in use, rename it to avoid compilation error.
rem
rem usage: update-dll-mingw [arch] [makeopts]
rem
rem   [arch] is 32 or 64. If omitted, it is automatically detected from the
rem   %PROCESSOR_ARCHITECTURE% environment.
rem   [makeopts] is option(s) for mingw32-make.
rem
rem
rem Sample .vimrc:
rem
rem NeoBundle 'Shougo/vimproc.vim', {
rem \ 'build' : {
rem \     'windows' : 'tools\\update-dll-mingw',
rem \     'cygwin' : 'make -f make_cygwin.mak',
rem \     'mac' : 'make -f make_mac.mak',
rem \     'linux' : 'make',
rem \     'unix' : 'gmake',
rem \    },
rem \ }

if "%1"=="32" (
  set vimproc_arch=%1
  shift
) else if "%1"=="64" (
  set vimproc_arch=%1
  shift
) else (
  if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set vimproc_arch=64
  ) else (
    set vimproc_arch=32
  )
)
set vimproc_dllname=vimproc_win%vimproc_arch%.dll

where mingw32-make >nul 2>&1
if ERRORLEVEL 1 (
  echo mingw32-make not found.
  goto :EOF
)

rem Try to delete old DLLs.
if exist lib\%vimproc_dllname%.old del lib\%vimproc_dllname%.old
if exist lib\%vimproc_dllname%     del lib\%vimproc_dllname%
rem If the DLL couldn't delete (may be it is in use), rename it.
if exist lib\%vimproc_dllname%     ren lib\%vimproc_dllname% %vimproc_dllname%.old

mingw32-make -f make_mingw%vimproc_arch%.mak %1 %2 %3 %4 %5 %6 %7 %8 %9
