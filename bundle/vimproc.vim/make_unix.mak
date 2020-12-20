# for *nix platform.

ifneq (,$(wildcard /lib*/ld-linux*.so.2))
	SUFFIX=linux$(if $(wildcard /lib*/ld-linux*64.so.2),64,32)
else
	SUFFIX=unix
endif
TARGET=lib/vimproc_$(SUFFIX).so

SRC=src/proc.c
CFLAGS+=-W -O2 -Wall -Wno-unused -Wno-unused-parameter -std=gnu99 -pedantic -shared -fPIC
LIBS=-lutil

all: $(TARGET)

$(TARGET): $(SRC) src/vimstack.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(TARGET) $(SRC) $(LIBS)

clean:
	rm -f $(TARGET)
