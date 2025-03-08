# Gunakan base image Bun
FROM oven/bun:latest

# Set working directory
WORKDIR /app

# Copy file package.json dan bun.lockb
COPY package.json bun.lockb ./

# Hapus node_modules dan install ulang untuk menghindari binary tidak kompatibel
RUN rm -rf node_modules package-lock.json bun.lockb && bun install

# Copy semua file backend ke dalam container
COPY . .

# Expose port aplikasi backend
EXPOSE 3000

# Jalankan aplikasi menggunakan Bun
CMD ["bun", "run", "src/app.ts"]
