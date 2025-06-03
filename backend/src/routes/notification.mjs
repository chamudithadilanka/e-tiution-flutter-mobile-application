// import express from "express";
// import Notification from "../models/notificationAttendance.mjs";

// const notificationRoutes = express.Router();

// notificationRoutes.get("/:studentId", async (req, res) => {
//   try {
//     const { studentId } = req.params;

//     const student = await User.findById(studentId).populate("userID");

//     if (!student || !student.userID) {
//       return res.status(404).json({ error: "Student or user not found" });
//     }

//     const notifications = await Notification.find({ userId: student.userID._id }).sort({ createdAt: -1 });

//     res.status(200).json({ notifications });
//   } catch (error) {
//     res.status(500).json({
//       error: "Failed to fetch notifications",
//       details: error.message,
//     });
//   }
// });

// export default notificationRoutes;

