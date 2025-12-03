# Use NGINX lightweight image
FROM --platform=linux/amd64 nginx:alpine

# Remove default NGINX HTML
RUN rm -rf /usr/share/nginx/html/*

# Copy our website files to NGINX directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
