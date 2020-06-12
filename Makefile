GO_CMD=go
MINDOC_BIN=mindoc
MINDOC_BIN_PATH=./output
MINDOC_CONF_PATH=./output/conf
MINDOC_STATIC_PATH=./output/static
MINDOC_VIEWS_PATH=./output/views
APP_NAME=mindoc
APP_VER=1.0.2
APP_CONF="github.com/lifei6671/mindoc/conf"

.PHONY: all
all: clean build install

.PHONY: build
build:
	@echo "build start >>>"
	go env -w GOPROXY=https://goproxy.io
	go env -w GOSUMDB=off
	go env -w CGO_ENABLED=1
	go env -w GOOS=linux
	go env -w GOARCH=amd64
	$(GO_CMD) build -o $(APP_NAME) -ldflags="-w -s -X '$(APP_CONF).VERSION=$(APP_VER)' -X '$(APP_CONF).BUILD_TIME=$(shell date -Iseconds)' -X '$(APP_CONF).GO_VERSION=$(shell go version)'"
	@echo ">>> build complete"

.PHONY: install
install:
	@echo "install start >>>"
	mkdir -p $(MINDOC_BIN_PATH)
	mv $(MINDOC_BIN) $(MINDOC_BIN_PATH)/mindoc
	mkdir -p $(MINDOC_CONF_PATH)
	cp ./conf/app.conf $(MINDOC_CONF_PATH)
	cp -r ./static $(MINDOC_STATIC_PATH)
	cp -r ./views $(MINDOC_VIEWS_PATH)
	tar c -z -f $(APP_NAME).tar.gz -C output $(APP_NAME) conf static views
	@echo ">>> install complete"

.PHONY: clean
clean:
	@echo "clean start >>>"
	rm -fr ./output
	rm -f $(MINDOC_BIN)
	@echo ">>> clean complete"