# syntax=docker/dockerfile:1.7
FROM golang:1.26-alpine AS build
ENV GOPROXY=https://goproxy.cn,direct
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/any2utf8 .

FROM alpine:3.24
RUN apk add --no-cache ca-certificates && adduser -D -H -u 1000 app
WORKDIR /work
COPY --from=build /out/any2utf8 /usr/local/bin/any2utf8
USER app
ENTRYPOINT ["any2utf8"]
