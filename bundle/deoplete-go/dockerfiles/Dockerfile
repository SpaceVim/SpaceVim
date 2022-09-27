FROM debian:latest
LABEL maintainer "zchee <zchee.io@gmail.com>"

ENV	PATH="/go/bin:/usr/local/go/bin:/usr/local/bin:$PATH" \
	\
	XDG_CONFIG_HOME="/root/.config" \
	XDG_CACHE_HOME="/root/.cache" \
	XDG_DATA_HOME="/root/.local/share" \
	\
	NVIM_LISTEN_ADDRESS="/tmp/nvim" \
	NVIM_TUI_ENABLE_CURSOR_SHAPE=1 \
	NVIM_PYTHON_LOG_FILE="/tmp/log/python-client.log" \
	NVIM_PYTHON_LOG_LEVEL="DEBUG" \
	\
	GOLANG_VERSION="1.8.3" \
	GOPATH="/go"

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		automake \
		g++ \
		gcc \
		git \
		libc6-dev \
		libtool \
		libtool-bin \
		make \
		pkg-config \
		python-dev \
		python-pip \
		python3-dev \
		python3-pip \
		wget \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& wget -q -O - https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar xzf - --strip-components=1 -C "/usr/local" \
	\
	&& mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME /root/.config/nvim /tmp/log \
	&& touch /root/.config/nvim/init.vim \
	\
	&& dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		ppc64el) goRelArch='linux-ppc64le'; goRelSha256='e5fb00adfc7291e657f1f3d31c09e74890b5328e6f991a3f395ca72a8c4dc0b3' ;; \
		i386) goRelArch='linux-386'; goRelSha256='ff4895eb68fb1daaec41c540602e8bb4c1e8bb2f0e7017367171913fc9995ed2' ;; \
		s390x) goRelArch='linux-s390x'; goRelSha256='e2ec3e7c293701b57ca1f32b37977ac9968f57b3df034f2cc2d531e80671e6c8' ;; \
		armhf) goRelArch='linux-armv6l'; goRelSha256='3c30a3e24736ca776fc6314e5092fb8584bd3a4a2c2fa7307ae779ba2735e668' ;; \
		amd64) goRelArch='linux-amd64'; goRelSha256='1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772' ;; \
		*) goRelArch='src'; goRelSha256='5f5dea2447e7dcfdc50fa6b94c512e58bfba5673c039259fd843f68829d99fa6'; \
			echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;; \
	esac; \
	\
	url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
	wget -O go.tgz "$url"; \
	echo "${goRelSha256} *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	if [ "$goRelArch" = 'src' ]; then \
		echo >&2; \
		echo >&2 'error: UNIMPLEMENTED'; \
		echo >&2 'TODO install golang-any from jessie-backports for GOROOT_BOOTSTRAP (and uninstall after build)'; \
		echo >&2; \
		exit 1; \
	fi \
	\
	&& pip3 install -U pip setuptools wheel \
	&& pip3 install pyuv neovim \
	\
	&& git clone https://github.com/Shougo/deoplete.nvim /src/deoplete.nvim \
	&& cd /src/deoplete.nvim; git reset --hard 90d93201044d6210091cd3786a720d06429afbe7; cd - \
	&& git clone https://github.com/zchee/deoplete-go /src/deoplete-go \
	&& cd /src/deoplete-go; git reset --hard 3c8a18663683ff97fb99b7045265b399ee86a834; cd - \
	\
	&& echo "set rtp+=/src/deoplete.nvim" >> /root/.config/nvim/init.vim \
	&& echo "set rtp+=/src/deoplete-go" >> /root/.config/nvim/init.vim \
	&& echo "let g:deoplete#enable_at_startup = 1" >> /root/.config/nvim/init.vim \
	\
	&& touch /src/init-neovim.bash \
	&& echo "#!/bin/bash" >> /src/init-neovim.bash \
	&& echo "nvim -c 'UpdateRemotePlugins' -c 'qall!' >/dev/null" > /src/init-neovim.bash \
	&& chmod +x /src/init-neovim.bash \
	\
	&& go get -u github.com/nsf/gocode \
	&& gocode set propose-builtins true \
	&& gocode set unimported-packages true

RUN /src/init-neovim.bash

RUN echo 'pa' > /test.go

CMD nvim
