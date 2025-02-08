FROM alpine:3.21.2 as builder

# Update this argument as soon as there is a new Pocketbase release available over at https://github.com/pocketbase/pocketbase
ARG POCKETBASE_VERSION=0.25.1

ADD https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip /pocketbase.zip
RUN unzip /pocketbase.zip
RUN chmod +x /pocketbase

# Please be aware that due to the usage of a "distroless" image here, you can't connect to your container via `fly ssh console`, because there is no console available in the container.
# If you want to use the console to run commands inside the container, please use `alpine:latest` as your production image.
# For more info about "distroless" containers, see https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/static-debian12:latest-amd64 as production
COPY --from=builder /pocketbase /usr/local/bin/pocketbase
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb_data"]
