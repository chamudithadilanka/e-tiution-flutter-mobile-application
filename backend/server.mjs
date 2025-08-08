// import express from "express";
// import cors from "cors";
// import "dotenv/config";
// import dbconnect from "./src/db/config.mjs";
// import rootRouter from "./src/routes/index.mjs";  // Make sure this path is correct!

// const server = express();

// server.use(express.json());
// server.use(cors());

// // Use root router under /api
// server.use("/api", rootRouter);

// const PORT = process.env.PORT || 4001; // ✅ Added default port
// const HOST = "192.168.50.176";


// dbconnect.then(() => {
//     console.log("✅ Database Connected!");
//     server.listen(PORT,HOST, () => console.log(`🚀 Server running on port ${PORT}`));

// }).catch(error => console.error("❌ Database Connection Failed:", error));


import express from "express";
import cors from "cors";
import "dotenv/config";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs/promises";


import dbconnect from "./src/db/config.mjs";
import rootRouter from "./src/routes/index.mjs";

const server = express();

// Get directory path for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Create uploads directory if it doesn't exist
const initUploadsDir = async () => {
  const uploadsDir = path.join(__dirname, "uploads");
  try {
    await fs.access(uploadsDir);
  } catch {
    await fs.mkdir(uploadsDir, { recursive: true });
    console.log("✅ Created uploads directory");
  }
};

// Middlewares
server.use(express.json({ limit: "50mb" })); // Increased payload limit
server.use(express.urlencoded({ extended: true, limit: "50mb" }));
server.use(cors());

// Serve uploaded images statically
server.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Use your API routes
server.use("/api", rootRouter);

// Error handling middleware
server.use((err, req, res, next) => {
  console.error("❌ Server error:", err);
  res.status(500).json({ 
    success: false,
    error: "Internal Server Error",
    details: process.env.NODE_ENV === "development" ? err.message : undefined
  });
});

// Server config
const PORT = process.env.PORT || 4001;
<<<<<<< HEAD
const HOST = process.env.HOST || "192.168.255.176"; // Using environment variable
=======
const HOST = process.env.HOST || "192.168.14.176"; // Using environment variable
>>>>>>> 5993507b22ce399dc36b9435b5811f83789575de

// Initialize and start server
const startServer = async () => {
  try {
    await initUploadsDir(); // Ensure uploads directory exists
    await dbconnect;
    console.log("✅ Database Connected!");
    
    server.listen(PORT, HOST, () => {
      console.log(`🚀 Server running at http://${HOST}:${PORT}`);
      console.log(`📁 Serving uploads from: ${path.join(__dirname, "uploads")}`);
    });
  } catch (error) {
    console.error("❌ Server startup failed:", error);
    process.exit(1);
  }
};

startServer();