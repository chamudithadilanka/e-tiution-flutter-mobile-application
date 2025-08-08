import mongoose from "mongoose";

const attendanceRecordSchema = new mongoose.Schema({
  studentId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  classId: { type: mongoose.Schema.Types.ObjectId, ref: 'Class', required: true },
  sessionId: { type: mongoose.Schema.Types.ObjectId, ref: 'AttendanceSession', required: true },
  markedAt: { type: Date, default: Date.now }
});

export default mongoose.model("AttendanceRecord", attendanceRecordSchema);