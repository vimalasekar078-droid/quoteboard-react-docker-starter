# Stage 1: Build the React application
FROM node:20-alpine AS build

WORKDIR /app

# Copy package manifests before source to leverage Docker layer caching
COPY package*.json ./

# Install clean dependencies
RUN npm ci

# Copy remaining source code and build
COPY . .
RUN npm run build

# Stage 2: Serve the production static build with Nginx
FROM nginx:alpine

# Copy custom Nginx configuration with SPA try_files routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy only the compiled static build from Stage 1
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
