FROM golang:latest AS build-stage
WORKDIR /go/src/app
COPY . .
RUN apt update && \
    apt install -y upx
RUN make build

FROM gcr.io/distroless/base-debian11 AS production-stage
WORKDIR /
COPY --from=build-stage /go/src/app/bin/server /
COPY --from=build-stage /go/src/app/config/config.yml /
USER nonroot:nonroot
EXPOSE 9090
CMD ["/server", "--config-file=/config.yml", "--listen-url=:9090"]
