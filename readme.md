# E-COMMERCE PERSONAL WEB APP

This document outlines the installation, running instructions, and folder structure for the **E-COMMERCE PERSONAL WEB APP** project. This project is divided into three main components: **client** (frontend), **server** (backend), and **mysql** (database).

## 📁 Folder Structure

```bash
e-commerce-personal-web-app/
├── client/                     # Frontend Application (ON PROGRESS)
│   └── ...
├── server/                     # Backend Application
│   ├── src/                    # Backend source code
│   │   ├── controllers/        # Route handlers/controllers
│   │   ├── middleware/         # Middleware (authorization, logging)
│   │   ├── models/            # Data models and database interactions
│   │   ├── routes/            # API route definitions
│   │   ├── utils/             # Utility functions
│   │   ├── app.ts             # Application initialization
│   │   ├── config/            # Application configuration
│   │   └── index.ts           # Main entry point
│   ├── .env                   # Environment variables
│   ├── package.json           # Backend dependencies and scripts
│   ├── bun.lockb              # Bun lock file
│   ├── Dockerfile             # Backend Dockerfile
│   └── tsconfig.json          # TypeScript configuration
├── mysql/                     # MySQL database configuration
│   ├── init.sql               # Database initialization script
├── docker-compose.yml         # Docker Compose configuration
├── .gitignore                 # Git ignored files
└── README.md                  # Project documentation
```

## 🚀 Running with Docker

### 📌 Prerequisites

- **Docker & Docker Compose** - [Download & Install](https://www.docker.com/get-started)

### 🔧 1. Clone the Repository

```bash
git clone https://github.com/your-repo/e-commerce-personal-web-app.git
cd e-commerce-personal-web-app
```

### 🛠 2. Configure Environment Variables

Before running the project, create a `.env` file inside `server/` and configure it based on your settings:

```env
DB_HOST=mysql
DB_USER=root
DB_PASSWORD=root
DB_NAME=ecommerce_db
JWT_ACCESS_SECRET_KEY=your_access_secret
JWT_REFRESH_SECRET_KEY=your_refresh_secret
```

### 📦 3. Build and Run Containers

```bash
docker-compose up -d --build
```

This will:

- Start a MySQL database container (`mysql-db`)
- Build and run the backend (`backend-app`)
- Build and run the frontend (`frontend-app`)

### 🔍 4. Verify Running Containers

```bash
docker ps
```

Expected output:

```bash
CONTAINER ID   IMAGE            STATUS          PORTS                   NAMES
abc12345       backend-app      Up 2 minutes    0.0.0.0:3000->3000/tcp  backend-app
def67890       mysql:8          Up 2 minutes    0.0.0.0:3306->3306/tcp  mysql-db
xyz98765       frontend-app     Up 2 minutes    0.0.0.0:8080->80/tcp    frontend-app
```

### 🏃‍♂️ 5. Testing the Setup

#### 🔹 Backend API

Check if the backend is running:

```bash
curl http://localhost:3000/api/health
```

Expected response:

```json
{ "status": "ok" }
```

#### 🔹 Database Connection

To verify MySQL connectivity:

```bash
docker exec -it mysql-db mysql -u root -p
```

#### 🔹 Frontend

Visit [http://localhost:8080](http://localhost:8080) to access the frontend.

---

## 🛑 Stopping and Removing Containers

```bash
docker-compose down
```

This will stop and remove all running containers but keep the database volume.

To remove all volumes and start fresh:

```bash
docker-compose down -v
```

## 🎯 Additional Commands

### 🔄 Restart Containers

```bash
docker-compose restart
```

### 🗑 Remove Unused Images & Containers

```bash
docker system prune -af
```

---

## ❓ Troubleshooting

### 🚨 Backend Fails to Connect to Database (`ECONNREFUSED`)

- Ensure MySQL container is running: `docker ps`
- Check logs: `docker logs mysql-db`
- Verify database credentials in `.env`
- Ensure backend is using `mysql` as the hostname instead of `localhost`

### 🚨 Frontend Not Loading

- Ensure frontend container is running: `docker ps`
- Try rebuilding the frontend: `docker-compose up -d --build frontend`

### 🚨 Clearing Docker Cache

```bash
docker-compose down -v && docker system prune -af
```

---

## 📌 Notes

- The backend uses **Bun** instead of Node.js for faster performance.
- The database schema is initialized using `mysql/init.sql`.
- Environment variables should be kept **private** and not committed to Git.

---

🚀 **Now you are ready to run the E-COMMERCE PERSONAL WEB APP using Docker!** 🎉
