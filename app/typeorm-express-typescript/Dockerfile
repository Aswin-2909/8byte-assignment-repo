# Use a full Node 18 image
FROM node:18

# Create app directory
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install ALL dependencies
RUN npm install

# Copy the rest of your source code
COPY . .

# Build the TypeScript code
RUN npm run build

# THE BULLETPROOF FIX: Absolute path so Node never gets lost
ENV NODE_PATH=/app/dist

# Expose the port
EXPOSE 4000

# Start the application
CMD ["npm", "start"]