# docker build examples

## multi stage build for smaller docker final image

```Dockerfile
# Dockerfile.multi-stage | builds smaller images

# Stage 1: Build
FROM python:3.9-alpine AS builder

# Install necessary build dependencies
RUN apk add --no-cache build-base \
    && apk add --no-cache gfortran musl-dev lapack-dev

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the working directory
COPY . .

# Uninstall unnecessary dependencies
RUN pip uninstall -y pandas && apk del build-base gfortran musl-dev lapack-dev

# Stage 2: Production
FROM python:3.9-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app /app

# Expose the port the app will run on
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
```

## build go project

```Dockerfile
#
# Build go project
#
FROM golang:1.18-alpine as go-builder

WORKDIR /app

COPY . .

RUN apk add -u -t build-tools curl git && \
    go build -o server *.go && \
    apk del build-tools && \
    rm -rf /var/cache/apk/*

#
# Runtime container
#
FROM alpine:latest

WORKDIR /app

RUN apk --no-cache add ca-certificates

COPY --from=go-builder /app/server /app/server

EXPOSE 8080

ENTRYPOINT ["/app/server"]
```
