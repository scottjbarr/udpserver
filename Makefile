GO ?= go

# command to build and run on the local OS.
GO_BUILD = go build

# command to compiling the distributable. Specify GOOS and GOARCH for
# the target OS.
GO_DIST = GOOS=linux GOARCH=amd64 $(GO_BUILD) -a -tags netgo

.PHONY: docker

docker: dist
	docker build -t udpserver .

all: clean build

deps:
	go get -t ./...

prepare:
	mkdir -p build dist

dist: prepare
	$(GO_DIST) -o dist/udpserver *.go

build: prepare
	$(GO_BUILD) -o build/udpserver *.go

test:
	$(GO) test

docker-run:
	docker run -p9999:9999/udp udpserver

clean:
	rm -rf build dist

send:
	echo -n "hey yeah" | nc -4u -w1 localhost 9999
