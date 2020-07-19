# WINDOWS BUILD SETTINGS.

WINVER = 0x0500
APPVER = 5.0
TARGET = WINNT
_WIN32_IE = 0x0500

!ifdef CPU
! if "$(CPU)" == "I386"
CPU = i386
! endif
!else  # !CPU
CPU = i386
! if !defined(PLATFORM) && defined(TARGET_CPU)
PLATFORM = $(TARGET_CPU)
! endif
! ifdef PLATFORM
!  if ("$(PLATFORM)" == "x64") || ("$(PLATFORM)" == "X64")
CPU = AMD64
!  elseif ("$(PLATFORM)" != "x86") && ("$(PLATFORM)" != "X86")
!   error *** ERROR Unknown target platform "$(PLATFORM)". Make aborted.
!  endif
! endif
!endif

# CONTROL BUILD MODE

!IFDEF DEBUG
CFLAGS = $(CFLAGS) -D_DEBUG
!ELSE
CFLAGS = $(CFLAGS) -D_NDEBUG
!ENDIF

# VIMPROC SPECIFICS

!if "$(CPU)" == "AMD64"
VIMPROC=vimproc_win64
!else
VIMPROC=vimproc_win32
!endif

SRCDIR = src
LIBDIR = lib
OUTDIR = $(SRCDIR)\obj$(CPU)

OBJS = $(OUTDIR)/proc_w32.obj

LINK = link
LFLAGS = /nologo /dll
DEFINES = -D_CRT_SECURE_NO_WARNINGS=1 -D_BIND_TO_CURRENT_VCLIBS_VERSION=1
CFLAGS = /nologo $(CFLAGS) $(DEFINES) /wd4100 /wd4127 /O2 /LD /c

# RULES

build: $(LIBDIR)\$(VIMPROC).dll

clean:
	-IF EXIST $(OUTDIR)/nul RMDIR /s /q $(OUTDIR)
	-DEL /F /Q $(LIBDIR)\$(VIMPROC).*

$(LIBDIR)\$(VIMPROC).dll: $(OBJS)
	$(LINK) $(LFLAGS) /OUT:$@ $(OBJS) shell32.lib ws2_32.lib
	IF EXIST $@.manifest \
		mt -nologo -manifest $@.manifest -outputresource:$@;2

{$(SRCDIR)}.c{$(OUTDIR)}.obj::
	$(CC) $(CFLAGS) -Fo$(OUTDIR)\ $<

$(OUTDIR):
	IF NOT EXIST $(OUTDIR)/nul  MKDIR $(OUTDIR)

$(OUTDIR)/proc_w32.obj: $(OUTDIR) $(SRCDIR)/proc_w32.c $(SRCDIR)/vimstack.c

.PHONY: build clean
