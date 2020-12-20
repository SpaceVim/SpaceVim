# for MinGW.

TARGET=lib/vimproc_win32.dll
SRC=src/proc_w32.c
CC=gcc
CFLAGS+=-O2 -Wall -shared -m32
LDFLAGS+=-lwsock32

all: $(TARGET)

$(TARGET): $(SRC) src/vimstack.c
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
