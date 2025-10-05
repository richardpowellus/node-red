# Use the official Node-RED Docker image as base with specific version
FROM nodered/node-red:3.1.0-18

# Switch to root user to perform system updates
USER root

# Update the package lists and upgrade all packages (Alpine Linux uses apk)
RUN apk update && \
    apk upgrade && \
    apk cache clean

# Fix potential line ending issues and ensure entrypoint is executable
RUN if [ -f /usr/src/node-red/entrypoint.sh ]; then \
        sed -i 's/\r$//' /usr/src/node-red/entrypoint.sh && \
        chmod +x /usr/src/node-red/entrypoint.sh; \
    fi

# Switch back to the node-red user for security
USER node-red

# Set the working directory to the Node-RED user directory
WORKDIR /usr/src/node-red

# Install the latest @azure/service-bus package
RUN npm install @azure/service-bus@latest

# Copy any additional configuration files if needed
# COPY settings.js /data/settings.js
# COPY flows.json /data/flows.json

# The default CMD from the base image will start Node-RED
# CMD ["npm", "start", "--cache", "/data/.npm", "--", "--userDir", "/data"]
