# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod files first to leverage Docker cache
COPY . .

# Download dependencies
RUN go mod download

# Copy the source code


# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server main.go

# Final stage
FROM alpine:latest

WORKDIR /app

# Add CA certificates for HTTPS
RUN apk --no-cache add ca-certificates

# Copy the binary from builder
COPY --from=builder /app/server .

# Expose the port the app runs on
EXPOSE 1323

# Command to run the application
CMD ["./server"]