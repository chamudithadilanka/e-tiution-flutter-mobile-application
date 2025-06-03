import mongoose from "mongoose";

// const attendanceSchema = new mongoose.Schema({
//   studentId: { type: mongoose.Schema.Types.ObjectId, ref: "Student", required: true },
//   status: { type: String, enum: ["present", "absent","late"], required: true },
//   date: { type: Date, required: true },
// });

// export default mongoose.model("Attendance", attendanceSchema);

const attendanceSchema = new mongoose.Schema({
  classId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Class',
    required: true
  },
  studentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  date: {
    type: Date,
    required: true // Still stores full timestamp
  },
  status: {
    type: String,
    enum: ['Select','present', 'absent', 'late'],
    default: 'present'
  },
  time: {
    type: String, // Format: "10:30 AM", "14:15", etc.
    required: false
  }
}, {
  timestamps: true
});
export default mongoose.model("Attendance", attendanceSchema);