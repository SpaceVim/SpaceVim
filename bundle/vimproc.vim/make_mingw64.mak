# for MinGW.

TARGET=lib/vimproc_win64.dll
SRC=src/proc_w32.c
CC=x86_64-w64-mingw32-gcc
CFLAGS+=-O2 -Wall -shared -m64
LDFLAGS+=-lwsock32

all: $(TARGET)

$(TARGET): $(SRC) src/vimstack.c
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
