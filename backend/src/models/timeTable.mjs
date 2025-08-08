import mongoose from 'mongoose';

const TimeSchedual = new mongoose.Schema({
  classId:{type:mongoose.Schema.Types.ObjectId,ref:"Class",required:true},
  teacherId:{type:mongoose.Schema.Types.ObjectId,ref:"User",required:true},
  day:{type:String,required:true},
  subject:{type:String,required:true},
  startTime: { type: String, required: true }, // e.g., "08:00"
  endTime: { type: String, required: true },
  endDate:{type:String,required:true},   // e.g., "12:00"
  createAt:{type:Date,default:Date.now},
});

const Timetable = mongoose.model('Timetable', TimeSchedual);

export default Timetable;
