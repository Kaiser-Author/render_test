FROM alpine:latest

# Install required tools
RUN apk add --no-cache curl unzip

# Download and install Xray-core
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip /tmp/xray.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/xray \
    && rm /tmp/xray.zip

# Create config directory
RUN mkdir -p /etc/xray

# Copy startup script and normalize line endings (fixes "no such file or directory"
# errors caused by Windows CRLF line endings breaking the #!/bin/sh shebang)
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

# Default port (Render/Cloud Run inject PORT automatically)
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
