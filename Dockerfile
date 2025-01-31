FROM golang:alpine AS builder

WORKDIR /app

COPY main.go .

RUN apk add --no-cache upx \
    && CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o fullcycle main.go \
    && upx --best --lzma fullcycle

FROM scratch

COPY --from=builder /app/fullcycle /fullcycle

ENTRYPOINT ["/fullcycle"]
