# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Install git and build dependencies
RUN apk add --no-cache git

# Copy go mod files first to leverage Docker cache
COPY . .

RUN go mod init odoo-pipline

# Fetch dependencies
RUN go get -d -v ./...


# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server main.go

# Final stage
FROM alpine:latest

WORKDIR /app

# Add CA certificates for HTTPS
RUN apk --no-cache add ca-certificates

# Copy the binary from builder
COPY --from=builder /app/server .

# Command to run the application
CMD ["./server"]