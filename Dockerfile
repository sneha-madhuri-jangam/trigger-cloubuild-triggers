# Stage 1: Build the React application
FROM node:20-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . ./

# Build the React app for production
# This creates the 'build' directory with static files
RUN npm run build

# Stage 2: Serve the static files with Nginx (or another static server)
FROM nginx:alpine

# Copy the built React app from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Add your custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the port Nginx will listen on (which Cloud Run will use)
EXPOSE 8080

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]