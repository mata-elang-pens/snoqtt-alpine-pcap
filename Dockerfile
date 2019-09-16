FROM alpine:latest

# Install required packages
RUN apk update 
RUN apk add --no-cache build-base alpine-sdk linux-headers libpcap-dev libdnet-dev musl-dev pcre-dev bison flex daq-dev\
	net-tools wget zlib-dev supervisor python3-dev sed tar libtirpc-dev libressl-dev cmake make g++ busybox shadow \
	perl-net-ssleay perl-lwp-useragent-determined perl-lwp-protocol-https perl-libwww perl-crypt-ssleay

# Copy required files
COPY require /root

# Run build script
RUN sh /root/build.sh

# Cleanup
RUN rm -f /root/build.sh && apk del net-tools wget

EXPOSE 5000
ENTRYPOINT ["sh", "/root/startup.sh"]
