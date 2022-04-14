CFLAGS       ?= -Os -std=c99 -fPIC
CXX_STANDARD ?= c++14
CXXFLAGS     ?= -Os -std=$(CXX_STANDARD) -fPIC
LDFLAGS      ?= 
SRC_DIR      ?= ./src
DEST_DIR     ?= ./dest

ifeq ($(OS),Windows_NT)
   SHELL       := powershell.exe
   .SHELLFLAGS := -NoProfile -command
   CP          := Copy-Item -Recurse -ErrorAction SilentlyContinue
   MKDIR       := New-Item -ItemType directory -ErrorAction SilentlyContinue
   TARGET      := parser.dll
   rmf         = Write-Output $(1) | foreach { if (Test-Path $$_) { Remove-Item -Force } }
else
   CP          := cp
   MKDIR       := mkdir -p
   TARGET      := parser.so
   rmf         = rm -rf $(1)
endif

ifneq ($(wildcard $(SRC_DIR)/*.cc),)
   LDFLAGS += -lstdc++
endif

OBJECTS := parser.o

ifneq ($(wildcard $(SRC_DIR)/scanner.*),)
   OBJECTS += scanner.o
endif

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET) -shared $(LDFLAGS)

%.o: $(SRC_DIR)/%.c
	$(CC) -c $(CFLAGS) -I$(SRC_DIR) -o $@ $<

%.o: $(SRC_DIR)/%.cc
	$(CC) -c $(CXXFLAGS) -I$(SRC_DIR) -o $@ $<

clean:
	$(call rmf,$(TARGET) $(OBJECTS))

$(DEST_DIR):
	@$(MKDIR) $(DEST_DIR)

install: $(TARGET) $(DEST_DIR)
	$(CP) $(TARGET) $(DEST_DIR)/

.PHONY: clean
