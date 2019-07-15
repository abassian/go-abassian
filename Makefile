# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gbas android ios gbas-cross swarm evm all test clean
.PHONY: gbas-linux gbas-linux-386 gbas-linux-amd64 gbas-linux-mips64 gbas-linux-mips64le
.PHONY: gbas-linux-arm gbas-linux-arm-5 gbas-linux-arm-6 gbas-linux-arm-7 gbas-linux-arm64
.PHONY: gbas-darwin gbas-darwin-386 gbas-darwin-amd64
.PHONY: gbas-windows gbas-windows-386 gbas-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest
VERSION ?= 1.0.0

gbas:
	build/env.sh go run build/ci.go install ./cmd/gbas
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gbas\" to launch gbas."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gbas.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gbas.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

swarm-devtools:
	env GOBIN= go install ./cmd/swarm/mimegen

# Cross Compilation Targets (xgo)

gbas-cross: gbas-linux gbas-darwin gbas-windows gbas-android gbas-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gbas-*

# gbas-linux: gbas-linux-386 gbas-linux-amd64 gbas-linux-arm gbas-linux-mips64 gbas-linux-mips64le
gbas-linux: gbas-linux-386 gbas-linux-amd64 gbas-linux-mips64 gbas-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-*

gbas-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gbas
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep 386

gbas-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gbas
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep amd64

gbas-linux-arm: gbas-linux-arm-5 gbas-linux-arm-6 gbas-linux-arm-7 gbas-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep arm

gbas-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gbas
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep arm-5

gbas-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gbas
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep arm-6

gbas-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gbas
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep arm-7

gbas-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gbas
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep arm64

gbas-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gbas
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep mips

gbas-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gbas
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep mipsle

gbas-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gbas
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep mips64

gbas-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gbas
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gbas-linux-* | grep mips64le

gbas-darwin: gbas-darwin-386 gbas-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gbas-darwin-*

gbas-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gbas
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-darwin-* | grep 386

gbas-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gbas
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-darwin-* | grep amd64

gbas-windows: gbas-windows-386 gbas-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gbas-windows-*

gbas-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gbas
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-windows-* | grep 386

gbas-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gbas
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gbas-windows-* | grep amd64

pack-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gbas
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/bootnode
	cd build/bin && tar -cvzf all-darwin-amd64-$(VERSION).tar.gz gbas-darwin-*-amd64 bootnode-darwin-*-amd64 && cd -
	@echo "Darwin amd64 cross compilation and packaging done"

pack-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gbas
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/bootnode
	cd build/bin && tar -cvzf all-linux-amd64-$(VERSION).tar.gz gbas-linux-amd64 bootnode-linux-amd64 && cd -
	@echo "Linux amd64 cross compilation and packaging done"
