# Use a slim Node 18 image for a smaller, faster container
FROM node:18-slim

# Create app directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install only production dependencies (saves space)
RUN npm install

# Copy the rest of your source code
COPY . .

# Build the TypeScript code (creates the /dist folder)
RUN npm run build

# --- THE CRITICAL PRODUCTION CONFIG ---
# This tells your ormconfig.ts to use .js files in /dist
ENV NODE_ENV=production
# Absolute path help
ENV NODE_PATH=/app/dist

# Expose the port your app runs on
EXPOSE 4000

# Start the application using node directly (bypass npm start for speed/stability)
CMD ["node", "dist/index.js"]