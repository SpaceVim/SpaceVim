ifeq ($(OS),Windows_NT)
    # Need to figure out if Cygwin/Mingw is installed
    SYS := $(shell gcc -dumpmachine)
    ifeq ($(findstring cygwin, $(SYS)),cygwin)
        ifeq ($(findstring x86_64, $(SYS)),x86_64)
            PLATFORM = cygwin64
        else
            PLATFORM = cygwin
        endif
    endif
    ifeq ($(findstring msys, $(SYS)),msys)
        ifeq ($(findstring x86_64, $(SYS)),x86_64)
            PLATFORM = cygwin64
        else
            PLATFORM = cygwin
        endif
    endif
    ifeq ($(findstring mingw, $(SYS)),mingw)
        ifeq ($(findstring x86_64, $(SYS)),x86_64)
            PLATFORM = mingw64
        else
            PLATFORM = mingw32
        endif
    endif
else
    # Grab the output of `uname -s` and switch to set the platform
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        PLATFORM = unix
    endif
    ifeq ($(UNAME_S),GNU)
        # GNU/Hurd
        PLATFORM = unix
    endif
    ifeq ($(UNAME_S),FreeBSD)
        MAKE = make # BSD Make
        PLATFORM = bsd
    endif
    ifeq ($(UNAME_S),DragonFly)
        MAKE = make # BSD Make
        PLATFORM = bsd
    endif
    ifeq ($(UNAME_S),NetBSD)
        MAKE = make # BSD Make
        PLATFORM = bsd
    endif
    ifeq ($(UNAME_S),OpenBSD)
        MAKE = make # BSD Make
        PLATFORM = bsd
    endif
    ifeq ($(UNAME_S),Darwin)
        PLATFORM = mac
    endif
    ifeq ($(UNAME_S),SunOS)
        PLATFORM = sunos
    endif
endif

# Verify that the PLATFORM was detected
ifndef PLATFORM
    $(error Autodetection of platform failed, please use appropriate .mak file)
endif

# Invoke the platform specific make files
all:
	$(MAKE) -f make_$(PLATFORM).mak

clean:
	$(MAKE) -f make_$(PLATFORM).mak clean

