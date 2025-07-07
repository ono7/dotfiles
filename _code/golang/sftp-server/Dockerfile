FROM golang:alpine3.20 AS builder

WORKDIR /app

# build a smaller image 
# COPY . .
#
# RUN cp *.crt /usr/local/share/ca-certificates/
# RUN update-ca-certificates
# RUN ntpd -d -q -n -p pool.ntp.org
# RUN apk update
# RUN go mod tidy && GCO_ENABLED=0 go build -o server .

FROM golang:alpine3.20
USER root
WORKDIR /app

# COPY --from=builder /app/server /app/server
COPY build/server /app/.server
RUN mkdir images

# this runs on port 2022, it is mapped in docker compose
# Go will lock down the app to its images/ directory
CMD ["/app/.server"]
