import mysql from "mysql2";

const HOST_DB = process.env.DB_HOST;
const DATABASE_PORT = process.env.DB_PORT;
const USER_DB = process.env.DB_USER;
const PASSWORD_DB = process.env.DB_PASSWORD;
const DATABASE_DB = process.env.DB_NAME;

// Membuat koneksi ke database
const db = mysql
  .createConnection({
    host: HOST_DB || "localhost", // Gunakan localhost jika aplikasi Node.js berjalan di mesin yang sama
    port: parseInt(DATABASE_PORT || "3306", 10), // Pastikan port yang digunakan adalah 3306
    user: USER_DB, // Ganti dengan username MySQL Anda
    password: PASSWORD_DB, // Ganti dengan password MySQL Anda
    database: DATABASE_DB, // Ganti dengan nama database Anda
  })
  .promise(); // Mengubah koneksi ke mode promise

export default db;
