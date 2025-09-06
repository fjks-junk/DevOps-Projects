# Use Alpine as base image
FROM alpine:latest

# Build-time argument with default value
ARG NAME=Captain

# Set default environment variable to the ARG
ENV NAME=${NAME}

# ENTRYPOINT prints Hello, [NAME]!
ENTRYPOINT ["sh", "-c", "echo Hello, ${NAME}!"]
