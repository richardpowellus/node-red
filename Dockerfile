# Use the official Node-RED Docker image as base with specific version
FROM nodered/node-red:3.1.0-18

# Switch to root user to perform system updates
USER root

# Update the package lists and upgrade all packages (Alpine Linux uses apk)
RUN apk update && \
    apk upgrade && \
    apk cache clean

# Install dos2unix to handle line ending conversion more reliably
RUN apk add --no-cache dos2unix

# Fix multiple potential issues with entrypoint scripts
RUN find /usr/src/node-red -name "*.sh" -type f -exec dos2unix {} \; && \
    find /usr/src/node-red -name "*.sh" -type f -exec chmod +x {} \; && \
    find /data -name "*.sh" -type f -exec dos2unix {} \; 2>/dev/null || true && \
    find /data -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

# Alternative: Create our own entrypoint to bypass potential issues
RUN echo '#!/bin/sh' > /usr/src/node-red/custom-entrypoint.sh && \
    echo 'exec node $@' >> /usr/src/node-red/custom-entrypoint.sh && \
    chmod +x /usr/src/node-red/custom-entrypoint.sh

# Switch back to the node-red user for security
USER node-red

# Set the working directory to the Node-RED user directory
WORKDIR /usr/src/node-red

# Install the latest @azure/service-bus package
RUN npm install @azure/service-bus@latest

# Copy any additional configuration files if needed
# COPY settings.js /data/settings.js
# COPY flows.json /data/flows.json

# Use a reliable startup command that bypasses potential entrypoint issues
CMD ["node", "/usr/src/node-red/node_modules/node-red/red.js", "--userDir", "/data"]
