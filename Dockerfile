FROM alpine:latest

# Copy required files
COPY require /root

# Install required packages
RUN apk update && apk add --no-cache \
	perl-net-ssleay \
	perl-crypt-ssleay \
	perl-libwww \
	perl-lwp-useragent-determined \
	perl-lwp-protocol-https \
	pcre \
	libpcap \
	libdnet \
	libtirpc \
	libressl \
	zlib \
	perl \
	supervisor

RUN	apk add --no-cache \
	build-base \
	alpine-sdk \
	linux-headers \
	libpcap-dev \
	libdnet-dev \
	musl-dev \
	pcre-dev \
	bison \
	flex \
	net-tools \
	wget \
	zlib-dev \
	python3-dev \
	sed \
	tar \
	libtirpc-dev \
	libressl-dev \
	cmake \
	make g++ && \
	sh /root/build.sh && \
	rm -f /root/build.sh && \
	apk del build-base \
	alpine-sdk \
	linux-headers \
	libpcap-dev \
	libdnet-dev \
	musl-dev \
	pcre-dev \
	bison \
	flex \
	net-tools \
	wget \
	zlib-dev \
	python3-dev \
	sed \
	tar \
	libtirpc-dev \
	libressl-dev \
	cmake \
	make g++

EXPOSE 5000
ENTRYPOINT ["sh", "/root/startup.sh"]