#!/bin/bash
set -eux

export NGROK_DOMAIN="ngrok.bonza.cn"
cd /go/ngrok \
&& openssl genrsa -out rootCA.key 2048 \
&& openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_DOMAIN" -days 5000 -out rootCA.pem \
&& openssl genrsa -out server.key 2048 \
&& openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr \
&& openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000 \
&& cp rootCA.pem assets/client/tls/ngrokroot.crt \
&& cp server.crt assets/server/tls/snakeoil.crt \
&& cp server.key assets/server/tls/snakeoil.key
# 替换下载源地址
sed -i 's#code.google.com/p/log4go#github.com/keepeye/log4go#' /go/ngrok/src/ngrok/log/logger.go
#cd /go/src
#GOOS=$GOOS GOARCH=$GOARCH ./make.bash
cd /go/ngrok \
&& CGO_ENABLED=0  GOOS=$GOOS GOARCH=$GOARCH make release-server \
&& GOOS=linux GOARCH=386 make release-client \
&& GOOS=linux GOARCH=amd64 make release-client \
&& GOOS=windows GOARCH=386 make release-client \
&& GOOS=windows GOARCH=amd64 make release-client \
&& GOOS=darwin GOARCH=386 make release-client \
&& GOOS=darwin GOARCH=amd64 make release-client \
&& GOOS=linux GOARCH=arm make release-client \
&& echo "install done"

