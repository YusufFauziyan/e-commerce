# Gunakan base image untuk Node.js
FROM node:18 AS build-stage

# Set working directory
WORKDIR /app

# Copy file package.json dan install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy semua file Vue.js ke dalam container dan build aplikasi
COPY . .
RUN npm run build

# Gunakan Nginx sebagai server web untuk menyajikan frontend
FROM nginx:alpine

# Copy file hasil build ke dalam Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port untuk frontend
EXPOSE 80

# Jalankan Nginx
CMD ["nginx", "-g", "daemon off;"]
