VERSION=$(shell git describe --tags --abbrev=0 HEAD)-$(shell git rev-parse --short HEAD)
BINARY=kbot

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

docker:
	docker build . -t kbot_${VERSION}

build: clean format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o ${BINARY} -ldflags "-X="github.com/gafaroff77/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf ${BINARY}

gitconn:
	eval ${shell ssh-agent -s}
	ssh-add ~/.ssh/gafdell2github
	ssh -T git@github.com

commentary:
	docker build . -t kbot_$(git describe --tags --abbrev=0 HEAD)-$(git rev-parse --short HEAD)
