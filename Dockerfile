# Step 1: Use a lightweight Nginx image as the base
FROM nginx:alpine

# Step 2: Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Step 3: Copy your static files (HTML/CSS/JS) to the Nginx server directory
# If your files are in a folder called 'public', use: COPY ./public /usr/share/nginx/html
COPY . /usr/share/nginx/html

# Step 4: Expose port 80 for web traffic
EXPOSE 80

# Step 5: Start Nginx
CMD ["nginx", "-g", "daemon off;"]
