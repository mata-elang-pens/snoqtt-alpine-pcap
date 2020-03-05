FROM alpine:3.11

COPY require /root

RUN sh /root/build.sh && rm -f /root/build.sh

EXPOSE 5000
ENTRYPOINT ["sh", "/root/startup.sh"]