CFLAGS+=-O2 -W -Wall -Wno-unused -Wno-unused-parameter -use=gnu99 -shared
TARGET=lib/vimproc_cygwin64.dll
SRC=src/proc.c
LDFLAGS+=-lutil

all: $(TARGET)

$(TARGET): $(SRC) src/vimstack.c
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
