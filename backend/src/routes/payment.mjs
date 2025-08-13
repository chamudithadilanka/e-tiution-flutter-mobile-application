import express from "express";
import multer from "multer";
import path from "path";
import fs from "fs";
import User from "../models/user.mjs";
import Class from "../models/class.mjs";
import PaymentSlip from "../models/payment.mjs";

const paymentRouter = express.Router();

// 1. Improved Upload Directory Path (Cross-platform)
const SLIP_UPLOADS_DIR = path.join(process.cwd(), "uploads");

// 2. Ensure directory exists with proper permissions
if (!fs.existsSync(SLIP_UPLOADS_DIR)) {
  fs.mkdirSync(SLIP_UPLOADS_DIR, { 
    recursive: true,
    mode: 0o755 // Safer permissions than 777
  });
}

// 3. Enhanced Multer Configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, SLIP_UPLOADS_DIR);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1E9)}`;
    const ext = path.extname(file.originalname).toLowerCase();
    cb(null, `slip-${uniqueSuffix}${ext}`);
  }
});

const upload = multer({
  storage,
  limits: { 
    fileSize: 5 * 1024 * 1024, // 5MB
    files: 1
  },
  fileFilter: (req, file, cb) => {
    const allowedMimes = ["image/jpeg", "image/png", "image/jpg"];
    const allowedExts = [".jpg", ".jpeg", ".png"];
    const ext = path.extname(file.originalname).toLowerCase();
    
    if (
      allowedMimes.includes(file.mimetype) && 
      allowedExts.includes(ext)
    ) {
      cb(null, true);
    } else {
      cb(new Error("Only JPG/PNG images are allowed"));
    }
  }
});

// =====================
// 1️⃣ Student Upload Slip (Improved)
// =====================
paymentRouter.post("/upload", upload.single("slipFile"), async (req, res) => {
  try {
    console.log('Upload request received:', {
      body: req.body,
      file: req.file ? {
        originalname: req.file.originalname,
        filename: req.file.filename,
        size: req.file.size,
        mimetype: req.file.mimetype
      } : null
    });

    // Validate required fields
    const { studentId, classId, amount, month } = req.body;
    if (!studentId || !classId || !amount || !month) {
      throw new Error("Missing required fields");
    }

    // Validate file was uploaded
    if (!req.file) {
      throw new Error("No file uploaded");
    }

    // Validate student exists and is a student
    const student = await User.findById(studentId);
    if (!student || student.role !== "student") {
      throw new Error("Invalid student");
    }

    // Validate class exists
    const classExists = await Class.exists({ _id: classId });
    if (!classExists) {
      throw new Error("Invalid class");
    }

    // Validate amount
    const numericAmount = parseFloat(amount);
    if (isNaN(numericAmount) || numericAmount <= 0) {
      throw new Error("Invalid amount");
    }

    // Construct public URL
    const publicUrl = `/uploads/${req.file.filename}`;

    // Save to database
    const slip = new PaymentSlip({
      studentId,
      classId,
      amount: numericAmount,
      month,
      slipFile: req.file.filename,
      filePath: path.join(SLIP_UPLOADS_DIR, req.file.filename),
      publicUrl
    });

    await slip.save();

    console.log('Payment slip saved successfully:', slip);

    return res.status(201).json({
      success: true,
      message: "Payment slip uploaded successfully",
      slip: {
        id: slip._id,
        studentId: slip.studentId,
        classId: slip.classId,
        amount: slip.amount,
        month: slip.month,
        slipFile: publicUrl, // Return public URL
        createdAt: slip.createdAt
      }
    });

  } catch (err) {
    console.error("Upload error:", err);

    // Clean up uploaded file if error occurred
    if (req.file) {
      const filePath = path.join(SLIP_UPLOADS_DIR, req.file.filename);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    const statusCode = err.message.includes("Invalid") ? 400 : 500;
    return res.status(statusCode).json({ 
      success: false, 
      message: err.message 
    });
  }
});





paymentRouter.get("/student/:studentId", async (req, res) => {
  try {
    const { studentId } = req.params;

    // Validate student exists and role is student
    const student = await User.findById(studentId);
    if (!student || student.role !== "student") {
      return res.status(400).json({
        success: false,
        message: "Invalid student"
      });
    }

    // Fetch payment slips with populated class and student info
    const slips = await PaymentSlip.find({ studentId })
      .populate("classId", "name description")  // or just .populate("classId") for all fields
      .populate("studentId", "firstName lastName email profileImageUrl") // or .populate("studentId")
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      slips: slips.map(slip => ({
        id: slip._id,
        class: slip.classId,
        student: slip.studentId,
        amount: slip.amount,
        month: slip.month,
        slipFile: `uploads/${slip.slipFile}`, // build URL here
        status: slip.status,
        teacherId: slip.teacherId,
        teacherComment: slip.teacherComment,
        submittedAt: slip.submittedAt,
        reviewedAt: slip.reviewedAt,
        createdAt: slip.createdAt,
        updatedAt: slip.updatedAt
      }))
    });

  } catch (err) {
    console.error("Fetch slips error:", err);
    return res.status(500).json({
      success: false,
      message: "Server error"
    });
  }
});











// =====================
// 2️⃣ Error Handling Middleware
// =====================
paymentRouter.use((err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "File too large (max 5MB)"
      });
    }
    return res.status(400).json({
      success: false,
      message: "File upload error: " + err.message
    });
  }

  if (err.message.includes("Only JPG/PNG")) {
    return res.status(400).json({
      success: false,
      message: err.message
    });
  }

  console.error("Server error:", err);
  res.status(500).json({ 
    success: false, 
    message: "Internal server error" 
  });
});

// =====================
// 3️⃣ Teacher Review Slip
// =====================
paymentRouter.put("/review/:id", async (req, res) => {
  try {
    const { status, teacherId, teacherComment } = req.body;

    if (!["approved", "rejected"].includes(status)) {
      throw new Error("Invalid status");
    }

    const teacher = await User.findById(teacherId);
    if (!teacher || teacher.role !== "teacher") {
      throw new Error("Invalid teacher");
    }

    const slip = await PaymentSlip.findById(req.params.id);
    if (!slip) {
      throw new Error("Slip not found");
    }

    slip.status = status;
    slip.teacherId = teacherId;
    slip.teacherComment = teacherComment;
    slip.reviewedAt = new Date();

    await slip.save();

    res.json({ 
      success: true, 
      message: `Slip ${status}`, 
      slip 
    });

  } catch (err) {
    console.error("Review error:", err);
    const statusCode = err.message.includes("Invalid") ? 400 : 
                      err.message.includes("not found") ? 404 : 500;
    res.status(statusCode).json({ 
      success: false, 
      message: err.message 
    });
  }
});

// =====================
// 4️⃣ Get Pending Slips
// =====================
paymentRouter.get("/pending/:teacherId", async (req, res) => {
  try {
    const teacher = await User.findById(req.params.teacherId);
    if (!teacher || teacher.role !== "teacher") {
      throw new Error("Invalid teacher");
    }

    const slips = await PaymentSlip.find({ status: "pending" })
      .populate("studentId", "name email")
      .populate("classId", "name");

    // Map to include full image URLs
    const slipsWithUrls = slips.map(slip => ({
      ...slip.toObject(),
      slipFile: `/uploads/${slip.slipFile}`
    }));

    res.json({ 
      success: true, 
      slips: slipsWithUrls 
    });

  } catch (err) {
    console.error("Fetch error:", err);
    res.status(500).json({ 
      success: false, 
      message: err.message 
    });
  }
});

export default paymentRouter;