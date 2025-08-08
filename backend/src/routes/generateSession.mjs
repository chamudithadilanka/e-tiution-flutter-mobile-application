import express from "express";
import AttendanceSession from "../models/attendanceSession.mjs";
import { v4 as uuidv4 } from "uuid";

const generateSessionRouter = express.Router();

generateSessionRouter.post("/create-session", async (req, res) => {
  try {
    const { classId, teacherId } = req.body;

    if (!classId || !teacherId) {
      return res.status(400).json({
        success: false,
        message: "classId and teacherId are required",
      });
    }

    const token = uuidv4();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 mins

    const session = new AttendanceSession({
      classId,
      teacherId,
      sessionToken: token,
      expiresAt,
    });

    await session.save();

    return res.status(200).json({
      success: true,
      sessionId: session._id,
      qrData: token,
    });
  } catch (error) {
    console.error("Error creating session:", error.message);
    return res.status(500).json({
      success: false,
      message: "Failed to create session",
      error: error.message,
    });
  }
});

export default generateSessionRouter;
