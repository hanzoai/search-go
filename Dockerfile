FROM golang:1.26.5-bookworm
# go.mod pins the toolchain. The golang base image sets GOTOOLCHAIN=local,
# which turns a `go` directive newer than the image into a hard build
# failure instead of a download.
ENV GOTOOLCHAIN=auto

WORKDIR /home/package

RUN git config --global --add safe.directory /home/package

COPY go.mod .
COPY go.sum .

COPY --from=golangci/golangci-lint:v2.3.0 /usr/bin/golangci-lint /usr/local/bin/golangci-lint

RUN go mod download
RUN go mod verify
