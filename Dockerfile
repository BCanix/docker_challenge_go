FROM golang:1.17 AS builder

WORKDIR /go/app

COPY ./src /go/app

ENV GO111MODULE="off" \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOFLAGS="-mod=vendor"

RUN (([ ! -d "/go/app/vendor" ] && go mod download && go mod vendor) || true)
RUN go build -ldflags="-s -w" -mod vendor -o helloworld helloworld.go
RUN chmod +x helloworld


FROM scratch

WORKDIR /go/app
COPY --from=builder /go/app/helloworld .

ENTRYPOINT ["/go/app/helloworld"]