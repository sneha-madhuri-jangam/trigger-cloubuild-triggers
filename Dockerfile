# Stage 1: Build the React application
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the React application with Nginx
FROM nginx:alpine 
# <-- This is the key!

# Copy the built React app from the build stage to Nginx's HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for the Nginx server
EXPOSE 80

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]