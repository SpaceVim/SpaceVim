# for *BSD platform.

SUFFIX!=uname -sm | tr '[:upper:]' '[:lower:]' | sed -e 's/ /_/'

TARGET=lib/vimproc_$(SUFFIX).so

SRC=src/proc.c
CFLAGS+=-W -O2 -Wall -Wno-unused -Wno-unused-parameter -std=gnu99 -pedantic -shared -fPIC
LDFLAGS+=-lutil

all: $(TARGET)

$(TARGET): $(SRC) src/vimstack.c
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
