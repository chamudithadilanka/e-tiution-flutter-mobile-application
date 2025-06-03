// import express from "express";
// import mongoose from "mongoose";
// import Attendance from "../models/attendance.mjs"; // Make sure this path is correct

// const attendanceRoutes = express.Router();

// attendanceRoutes.post("/mark", async (req, res) => {
//   try {
//     const { attendance } = req.body;

//     // Convert studentId strings to ObjectId
//     const records = attendance.map(item => ({
//       studentId: new mongoose.Types.ObjectId(item.studentId),
//       present: item.present,
//       date: new Date(), // Optional: Use specific date if needed
//     }));

//     await Attendance.insertMany(records);

//     res.status(200).json({ message: "Attendance marked successfully" });
//   } catch (error) {
//     res.status(500).json({
//       error: "Failed to mark attendance",
//       details: error.message,
//     });
//   }
// });





// export default attendanceRoutes;

import express from "express";
import mongoose from "mongoose";
import Attendance from "../models/attendance.mjs"; // Adjust path if needed
import Student from "../models/student.mjs";
import Notification from "../models/notificationAttendance.mjs";




const attendanceRoutes = express.Router();

attendanceRoutes.post("/mark", async (req, res) => {
  try {
    const { attendance } = req.body;

    // Validate input
    if (!Array.isArray(attendance)) {
      return res.status(400).json({ error: "Invalid attendance data format" });
    }

    // Prepare attendance records
    const records = attendance.map(item => ({
      studentId: new mongoose.Types.ObjectId(item.studentId),
      status: item.status, // "present" or "absent"
      date: item.date ? new Date(item.date) : new Date(),
    }));
//=====================================================================notify
// for (const item of attendance) {
//   // Fetch student and populate parent user
//   const student = await Student.findById(item.studentId).populate("userID");
//   if (!student) continue;

//   const user = student.userID;
//   const studentUserId = user?._id;

//   const studentName = `${user?.firstName || "Unknown"} ${user?.lastName || ""}`;

//   const message = `Student ${studentName.trim()} was marked ${item.status} on ${new Date().toLocaleDateString()}`;

//   if (studentUserId) {//user id student add
//     await Notification.create({
//       userId: parentUserId,
//       message,
//     });
//   }
// }


for (const item of attendance) {
  // Fetch student and populate user
  const student = await Student.findById(item.studentId).populate("userID");
  if (!student) continue;

  const user = student.userID;
  const studentUserId = user?._id;

  const studentName = `${user?.firstName || "Unknown"} ${user?.lastName || ""}`;

  const message = `Student ${studentName.trim()} was marked ${item.status} on ${new Date().toLocaleDateString()}`;

  if (studentUserId) {
    await Notification.create({
      userId: studentUserId, // NOT parentUserId
      message,
    });
  }
}

//=============================================================================
    // Insert into DB
    await Attendance.insertMany(records);

    res.status(200).json({ message: "Attendance marked successfully" });
  } catch (error) {
    res.status(500).json({
      error: "Failed to mark attendance",
      details: error.message,
    });
  }
});






// attendanceRoutes.post('/mark/each-classes', async (req, res) => {
//   try {
//     const { classId, studentId, status, date } = req.body;

//     console.log('➡️ Attendance received:', { classId, studentId, status, date });

//     // Validation checks
//     if (!classId || !studentId || !status) {
//       return res.status(400).json({
//         success: false,
//         message: 'Missing required fields: classId, studentId or status',
//       });
//     }

//     const attendanceDate = date ? new Date(date) : new Date();

//     const newAttendance = new Attendance({
//       classId,
//       studentId,
//       date: attendanceDate,
//       status,
//     });

//     await newAttendance.save();

//     return res.status(201).json({
//       success: true,
//       message: 'Attendance marked successfully',
//     });
//   } catch (error) {
//     console.error('🔥 Error marking attendance:', error);
//     return res.status(500).json({
//       success: false,
//       message: 'Server error',
//       error: error.message,
//     });
//   }
// });


// attendanceRoutes.post('/mark/each-classes', async (req, res) => {
//   try {
//     const { classId, studentId, status, date } = req.body;

//     console.log('➡️ Attendance received:', { classId, studentId, status, date });

//     // Validation
//     if (!classId || !studentId || !status) {
//       return res.status(400).json({
//         success: false,
//         message: 'Missing required fields: classId, studentId, or status',
//       });
//     }

//     const attendanceDate = date ? new Date(date) : new Date();

//     // Normalize the date to only compare year-month-day (ignoring time)
//     const startOfDay = new Date(attendanceDate.setHours(0, 0, 0, 0));
//     const endOfDay = new Date(attendanceDate.setHours(23, 59, 59, 999));

//     // ❌ Check for existing attendance record
//     const existingAttendance = await Attendance.findOne({
//       classId,
//       studentId,
//       date: { $gte: startOfDay, $lte: endOfDay }
//     });

//     if (existingAttendance) {
//       return res.status(409).json({
//         success: false,
//         message: 'Attendance has already been marked for this student on this date.',
//       });
//     }

//     // ✅ Save new attendance
//     const newAttendance = new Attendance({
//       classId,
//       studentId,
//       date: new Date(), // or use attendanceDate if needed
//       status,
//     });

//     await newAttendance.save();

//     return res.status(201).json({
//       success: true,
//       message: 'Attendance marked successfully',
//     });

//   } catch (error) {
//     console.error('🔥 Error marking attendance:', error);
//     return res.status(500).json({
//       success: false,
//       message: 'Server error',
//       error: error.message,
//     });
//   }
// });


attendanceRoutes.post('/mark/each-classes', async (req, res) => {
  try {
    const { classId, studentId, status, date } = req.body;

    // Validate required fields
    if (!classId || !studentId || !status) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: classId, studentId, or status',
      });
    }

    // ✅ Validate allowed status values
    const allowedStatuses = ['present', 'absent', 'late'];
    if (!allowedStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: `Invalid status value: "${status}". Must be one of ${allowedStatuses.join(', ')}`,
      });
    }

    const attendanceDate = date ? new Date(date) : new Date();

    // Normalize date to check within the day
    const startOfDay = new Date(attendanceDate.setHours(0, 0, 0, 0));
    const endOfDay = new Date(attendanceDate.setHours(23, 59, 59, 999));

    // Check for existing attendance
    const existingAttendance = await Attendance.findOne({
      classId,
      studentId,
      date: { $gte: startOfDay, $lte: endOfDay }
    });

    if (existingAttendance) {
      return res.status(409).json({
        success: false,
        message: 'Attendance already marked today for this student',
      });
    }

    // Save new attendance
    const newAttendance = new Attendance({
      classId,
      studentId,
      status,
      date: new Date()
    });

    await newAttendance.save();

    return res.status(201).json({
      success: true,
      message: 'Attendance marked successfully',
    });

  } catch (error) {
    console.error('🔥 Error marking attendance:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
});




// GET: Attendance summary by classId for today
attendanceRoutes.get('/details/:classId', async (req, res) => {
  const { classId } = req.params;

  try {
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const endOfDay = new Date();
    endOfDay.setHours(23, 59, 59, 999);

    // Get today's attendance for the class
    const attendances = await Attendance.find({
      classId,
      date: { $gte: startOfDay, $lte: endOfDay }
    });

    // Count by status
    const summary = {
      present: 0,
      absent: 0,
      late: 0,
    };

    attendances.forEach((att) => {
      if (att.status === 'present') summary.present += 1;
      else if (att.status === 'absent') summary.absent += 1;
      else if (att.status === 'late') summary.late += 1;
    });

    res.status(200).json({
      success: true,
      classId,
      date: new Date().toDateString(),
      summary,
    });
  } catch (error) {
    console.error('Error fetching attendance summary:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch attendance summary',
      error: error.message,
    });
  }
});










attendanceRoutes.get("/notifications/user/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const notifications = await Notification.find({ userId }).sort({ createdAt: -1 });

    res.status(200).json({ notifications });
  } catch (error) {
    res.status(500).json({
      error: "Failed to fetch notifications",
      details: error.message,
    });
  }
});



attendanceRoutes.get("/today-count", async (req, res) => {
  try {
    // Get today's start and end time
    const start = new Date();
    start.setHours(0, 0, 0, 0);

    const end = new Date();
    end.setHours(23, 59, 59, 999);

    // Only count records marked as "present" today
    const count = await Attendance.countDocuments({
      status: "present", // filter by present only
      date: { $gte: start, $lte: end },
    });

    res.status(200).json({ todayPresentCount: count });
  } catch (error) {
    res.status(500).json({
      error: "Failed to count today's present attendance",
      details: error.message,
    });
  }
});



//stream depen attendanlist 


export default attendanceRoutes;
