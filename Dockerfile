FROM golang:1.7-alpine as build

WORKDIR /go


COPY ngrok.zip /go
ADD build.sh /go

#RUN  mv /etc/apt/sources.list /etc/apt/sources.list.bak
#COPY ${PWD}/ngrok/sources.list /etc/apt/
	
RUN unzip ngrok.zip \
    && apk --no-cache add make \
        ca-certificates \
        openssl \
    && sh /go/build.sh \
    && rm -rf ngrok.zip

#EXPOSE 8081

#VOLUME ["/go/ngrok/bin"]

#CMD ["/go/ngrok/bin/ngrokd"]

#FROM scratch
FROM alpine:latest as prod
RUN apk --no-cache add ca-certificates
COPY --from=build /go/ngrok/bin /ngrok/bin
WORKDIR /ngrok/bin
EXPOSE 8081
VOLUME ["/ngrok/bin"]
CMD ["./ngrokd"]