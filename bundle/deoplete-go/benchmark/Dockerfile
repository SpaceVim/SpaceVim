FROM ubuntu:xenial
MAINTAINER zchee <k@zchee.io>

COPY ./requirements.txt /python_jsonbench/requirements.txt

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		gcc \
		g++ \
		git \
		python3-dev \
		python3-pip \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& pip3 install -U pip setuptools \
	&& pip3 install -r /python_jsonbench/requirements.txt

COPY . /python_jsonbench
WORKDIR /python_jsonbench

CMD ["python3", "benchmark.py"]
