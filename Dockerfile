# Use the official Node-RED Docker image with Node.js 22
FROM nodered/node-red:latest-22

# Switch to root user for system and global npm updates
USER root

# Update the package lists and upgrade all packages (Alpine Linux uses apk)
RUN apk update && \
    apk upgrade && \
    apk cache clean

# Update npm globally and fix permissions
RUN npm install -g npm@latest && \
    chown -R node-red:node-red /data/.npm

# Switch back to the node-red user for security and install packages
USER node-red

# Set the working directory to the Node-RED user directory
WORKDIR /usr/src/node-red

# Install Azure Service Bus package, Git nodes, and apply security fixes
RUN npm install @azure/service-bus@latest node-red-contrib-git-nodes@latest && \
    npm audit fix || true && \
    npm cache clean --force

# Copy any additional configuration files if needed
# COPY settings.js /data/settings.js
# COPY flows.json /data/flows.json

# Use the default CMD from the base image (let Node-RED handle startup properly)
