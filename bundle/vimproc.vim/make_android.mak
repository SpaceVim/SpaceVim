# You must set environment variables to suit your environment, in this Makefile or your shell.
# For example, using Android NDK on Mac OSX:
#   NDK_TOP=/path/to/your/ndk/android-ndk-r8d
#   SYSROOT=$(NDK_TOP)/platforms/android-8/arch-arm
#   CFLAGS=-march=armv5te -msoft-float
#   CC=$(NDK_TOP)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/darwin-x86/bin/arm-linux-androideabi-gcc -mandroid --sysroot=$(SYSROOT)

CFLAGS+=-W -Wall -Wno-unused -Wno-unused-parameter -std=c99 -O2 -fPIC -pedantic
LDFLAGS+=-shared

TARGET=lib/vimproc_unix.so
SRC=src/proc.c src/ptytty.c
INC=src/vimstack.c src/ptytty.h

all: $(TARGET)

$(TARGET): $(SRC) $(INC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
