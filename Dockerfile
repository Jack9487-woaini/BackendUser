# build stage
FROM golang:1.15 AS build-env
COPY . /src
RUN cd /src && go build -o app

# final stage
FROM alpine:3
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY --from=build-env /src/app /app/app
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk && \
    apk add glibc-2.33-r0.apk

ENTRYPOINT ./app
HEALTHCHECK --timeout=5s CMD ./app ping