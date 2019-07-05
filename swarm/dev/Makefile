.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/abassian/go-abassian/cmd/swarm
	go build -o bin/gbas     github.com/abassian/go-abassian/cmd/gbas
	go build -o bin/bootnode github.com/abassian/go-abassian/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/abassian/go-abassian/swarm/...
