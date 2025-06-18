import express from 'express';
import AttendanceRecord from '../models/attendanceRecord.mjs';
import attendanceSession from '../models/attendanceSession.mjs';

const attendanceRecordRouter = express.Router();


attendanceRecordRouter.use(express.json());

attendanceRecordRouter.post('/mark-attendance', async (req, res) => {
  const { studentId, qrToken } = req.body;

  try {
    const session = await attendanceSession.findOne({ sessionToken: qrToken });

    if (!session || session.expiresAt < new Date()) {
      return res.status(400).json({ success: false, message: 'Invalid or expired QR token' });
    }

    const alreadyMarked = await AttendanceRecord.findOne({
      studentId,
      sessionId: session._id
    });

    if (alreadyMarked) {
      return res.status(400).json({ success: false, message: 'Attendance already marked' });
    }

    const record = new AttendanceRecord({
      studentId,
      classId: session.classId,
      sessionId: session._id
    });

    await record.save();

    res.json({ success: true, message: 'Attendance marked successfully' });
  } catch (error) {
    console.error('Error marking attendance:', error.message);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});

export default attendanceRecordRouter;
