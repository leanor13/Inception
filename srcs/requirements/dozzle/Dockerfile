FROM alpine:3.19

RUN apk add --no-cache curl

WORKDIR /opt/dozzle
COPY tools/dozzle.tar.gz .
RUN tar -xzf dozzle.tar.gz && rm dozzle.tar.gz

EXPOSE 8080
ENTRYPOINT ["./dozzle"]