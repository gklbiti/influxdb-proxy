GOPATH := $(PWD):$(PWD)/vendor
export GOPATH

PATH := /usr/local/go/bin:$(PATH)
export PATH

all: build

clean:
	rm -rf bin

install-deps:
	rm -rf vendor
	git clone https://github.com/influxdb/influxdb-go vendor/src/github.com/influxdb/influxdb-go
	cd vendor/src/github.com/influxdb/influxdb-go && git checkout 23dc106e2636171db26f6a9296e8a52769726b65

build: clean
	go build -o bin/influxdb-proxy influxdb_proxy.go

install: install-deps build
	mkdir -p /opt/influxdb-proxy
	cp -a bin /opt/influxdb-proxy/
	[ -f /etc/init/influxdb-proxy.conf ] && service influxdb-proxy restart

fmt:
	go fmt influx_proxy.go
