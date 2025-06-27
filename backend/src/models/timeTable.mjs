import mongoose from 'mongoose';

const timeSlotSchema = new mongoose.Schema({
  day: { type: String, required: true }, // e.g., "Monday"
  startTime: { type: String, required: true }, // e.g., "09:00"
  endTime: { type: String, required: true },   // e.g., "10:00"
  subject: { type: String, required: true },   // e.g., "Math"
  teacherId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Optional
});

const timetableSchema = new mongoose.Schema({
  classId: { type: mongoose.Schema.Types.ObjectId, ref: 'Class', required: true },
  slots: [timeSlotSchema],
  createdAt: { type: Date, default: Date.now },
});

const Timetable = mongoose.model('Timetable', timetableSchema);

export default Timetable;
export { timeSlotSchema }; // Exporting timeSlotSchema if needed elsewhere