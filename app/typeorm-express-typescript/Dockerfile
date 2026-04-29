# Use a slim Node 18 image
FROM node:18-slim

# Create app directory
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your source code
COPY . .

# 1. Build the TypeScript code (creates the /dist folder)
RUN npm run build

# 2. THE FIX: Remove the source folder so the app MUST use /dist
RUN rm -rf src

# --- PRODUCTION CONFIG ---
ENV NODE_ENV=production
ENV NODE_PATH=/app/dist

# Expose the port
EXPOSE 4000

# Start the application using node directly
CMD ["node", "dist/index.js"]