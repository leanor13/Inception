# Build frontend assets
FROM node:23.11.1-alpine AS node
RUN corepack enable
WORKDIR /build
COPY dozzle/pnpm-*.yaml ./
RUN pnpm fetch --ignore-scripts --no-optional
COPY dozzle/package.json ./
RUN pnpm install --offline --ignore-scripts --no-optional
COPY dozzle/.* dozzle/*.config.ts dozzle/*.config.js dozzle/*.config.cjs ./
COPY dozzle/assets ./assets
COPY dozzle/locales ./locales
COPY dozzle/public ./public
RUN pnpm build

# Build Go backend
FROM golang:1.24-alpine AS builder
RUN apk add --no-cache ca-certificates protoc protobuf-dev \
  && mkdir /dozzle \
  && go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
  && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
WORKDIR /dozzle
COPY dozzle/go.* ./
RUN go mod download
COPY dozzle/internal ./internal
COPY dozzle/types ./types
COPY dozzle/main.go ./
COPY dozzle/protos ./protos
COPY dozzle/shared_key.pem dozzle/shared_cert.pem ./
COPY --from=node /build/dist ./dist
ARG TAG=dev
ARG TARGETOS TARGETARCH
RUN go generate
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go build -ldflags "-s -w -X github.com/amir20/dozzle/internal/support/cli.Version=$TAG" -o dozzle
RUN mkdir /data

# Final minimal image
FROM alpine:3.20
COPY --from=builder /data /data
COPY --from=builder /tmp /tmp
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /dozzle/dozzle /dozzle
EXPOSE 8080
ENTRYPOINT ["/dozzle"]