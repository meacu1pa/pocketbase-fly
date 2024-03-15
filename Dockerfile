# spectado/pocketbase is only used to get notified for new Pocketbase releases via Dependabot.
FROM spectado/pocketbase:0.22.4 as update-notification

FROM alpine:3.19.1 as builder

# Update this argument as soon as there is a new Pocketbase release available.
ARG POCKETBASE_VERSION=0.22.4

ADD https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip /pocketbase.zip
RUN unzip /pocketbase.zip
RUN chmod +x /pocketbase

# Please be aware that due to the usage of a "distroless" image here, you can't connect to your container via `fly ssh console`, because there is no console available.
# If you want to use the console to run commands inside the container, please use `alpine:latest` as your base image.
# For more info about "distroless" containers, see https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/static-debian12:latest-amd64
COPY --from=builder /pocketbase /usr/local/bin/pocketbase
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb_data"]
