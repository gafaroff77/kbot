APP=$(shell basename -s .git $(shell git remote get-url origin))
REGISTRY=gafaroff77
VERSION=$(shell git describe --tags --abbrev=0 HEAD)-$(shell git rev-parse --short HEAD)
BINARY=kbot
#TARGETARCH=$(shell uname -p)
#TARGETARCH=$(shell dpkg --print-architecture)
TARGETARCH=arm64

lint:
	golint

format: lint
	gofmt -s -w ./

test:
	go test -v

get:
	go get

dimage:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

dpush:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

build: clean format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o ${BINARY} -ldflags "-X="github.com/gafaroff77/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf ${BINARY}

gitconn:
	eval ${shell ssh-agent -s}
	ssh-add ~/.ssh/gafdell2github
	ssh -T git@github.com
