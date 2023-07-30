# spectado/pocketbase is only used to get notified for new Pocketbase releases via Dependabot
FROM spectado/pocketbase:0.17.0 as update-notification

FROM alpine:3.18.2 as builder

ARG POCKETBASE_VERSION=0.17.0
ADD https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip /pocketbase.zip
RUN unzip /pocketbase.zip
RUN chmod +x /pocketbase

# For more info about "distroless" containers, see https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/static-debian11:latest-amd64

COPY --from=builder /pocketbase /usr/local/bin/pocketbase
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb_data"]
