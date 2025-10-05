# Use the official Node-RED Docker image with Node.js 22
FROM nodered/node-red:latest-22

# Switch to root user to install packages
USER root

# Update the package lists and upgrade all packages (Alpine Linux uses apk)
RUN apk update && \
    apk upgrade && \
    apk cache clean

# Switch back to the node-red user for security
USER node-red

# Set the working directory to the Node-RED user directory
WORKDIR /usr/src/node-red

# Install the latest @azure/service-bus package
RUN npm install @azure/service-bus@latest

# Copy any additional configuration files if needed
# COPY settings.js /data/settings.js
# COPY flows.json /data/flows.json

# Use the default CMD from the base image (let Node-RED handle startup properly)
