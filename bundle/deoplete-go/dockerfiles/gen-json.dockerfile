FROM golang:1.7.3-alpine
MAINTAINER zchee <k@zchee.io>

ENV GOLANG_VERSION 1.7.3

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		make \
		git \
		tar \
		python3 \
	\
	&& go get -u -v github.com/nsf/gocode

COPY . /deoplete-go

RUN cd /deoplete-go \
	&& make gen_json \
	\
	&& tar cf "json_linux_amd64.tar.gz" "./data/json/$GOLANG_VERSION/linux_amd64"

CMD ["cat", "/deoplete-go/json_linux_amd64.tar.gz"]
