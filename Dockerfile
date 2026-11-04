FROM golang:1.27.1-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o notely main.go handler_notes.go handler_ready.go handler_user.go middleware_auth.go models.go json.go

FROM alpine:3.20

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/notely /usr/bin/notely
COPY --from=builder /app/static ./static

CMD ["notely"]
