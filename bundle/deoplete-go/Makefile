CURRENT := $(shell pwd)
RPLUGIN_HOME := $(CURRENT)/rplugin/python3
RPLUGIN_PATH := $(RPLUGIN_HOME)/deoplete/sources
MODULE_NAME := deoplete_go.py deoplete_go/cgo.py deoplete_go/stdlib.py

TARGET = $(RPLUGIN_HOME)/deoplete/ujson.so

GOCODE := $(shell which gocode)
GO_VERSION = $(shell go version | awk '{print $$3}' | sed -e 's/go//')
GO_STABLE_VERSION = 1.10.1
GOOS := $(shell go env GOOS)
GOARCH := $(shell go env GOARCH)

GIT := $(shell which git)
PYTHON3 := $(shell which python3)
DOCKER := $(shell which docker)
DOCKER_IMAGE := zchee/deoplete-go:${GO_STABLE_VERSION}-linux_amd64

PACKAGE ?= unsafe

ifneq ($(PACKAGE),unsafe)
	PACKAGE += unsafe
endif

PIP_FLAGS ?=


all: $(TARGET)


rplugin/python3/deoplete/ujson/.git:
	$(GIT) submodule update --init


$(TARGET): rplugin/python3/deoplete/ujson/.git
	cd ./rplugin/python3/deoplete/ujson; $(PYTHON3) setup.py build --build-base="$(CURRENT)/build" --build-lib="$(CURRENT)/build"
	mv "$(CURRENT)/build/ujson."*".so" "$(TARGET)"


data/stdlib-$(GO_VERSION)_$(GOOS)_$(GOARCH).txt:
	go tool api -contexts $(GOOS)-$(GOARCH)-cgo | sed -e s/,//g | awk '{print $$2}' | uniq > ./data/stdlib-$(GO_VERSION)_$(GOOS)_$(GOARCH).txt
	@for pkg in $(PACKAGE) ; do \
		echo $$pkg >> ./data/stdlib-$(GO_VERSION)_$(GOOS)_$(GOARCH).txt; \
	done

gen_json: data/stdlib-$(GO_VERSION)_$(GOOS)_$(GOARCH).txt
	$(GOCODE) close
	$(GOCODE) set package-lookup-mode go
	cd ./data && ./gen_json.py $(GOOS) $(GOARCH)


docker/build:
	$(DOCKER) build -t $(DOCKER_IMAGE) .

docker/gen_stdlib: docker/build
	$(DOCKER) run --rm $(DOCKER_IMAGE) cat /deoplete-go/data/stdlib-${GO_STABLE_VERSION}_linux_amd64.txt > ./data/stdlib-${GO_STABLE_VERSION}_linux_amd64.txt

docker/gen_json: docker/gen_stdlib
	$(DOCKER) run --rm $(DOCKER_IMAGE) > ./json_${GO_STABLE_VERSION}_linux_amd64.tar.gz
	tar xf ./json_${GO_STABLE_VERSION}_linux_amd64.tar.gz
	mv ./json_${GO_STABLE_VERSION}_linux_amd64.tar.gz ./data/json_${GO_STABLE_VERSION}_linux_amd64.tar.gz


test: lint

lint: lint/flake8

lint/flake8:
	flake8 --config=$(PWD)/.flake8 $(foreach file,$(MODULE_NAME),$(RPLUGIN_PATH)/$(file)) || true

lint/install_modules:
	pip3 install -U $(PIP_FLAGS) -r ./tests/requirements.txt

clean:
	$(RM) -r "$(CURRENT)/build" "$(TARGET)" rplugin/python3/deoplete/ujson/build data/stdlib-$(GO_VERSION)_$(GOOS)_$(GOARCH).txt

.PHONY: test lint clean gen_json build
