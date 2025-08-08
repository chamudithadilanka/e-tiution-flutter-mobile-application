// import mongoose from 'mongoose';
// const assignmentSchema = new mongoose.Schema({
//   title: String,
//   description: String,
//   dueDate: Date,
//   classId: { type: mongoose.Schema.Types.ObjectId, ref: 'Class' },
//   teacherId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
//   materials: [String], // Array of filenames
//   createdAt: { type: Date, default: Date.now }
// });

// export default mongoose.model('Assignment', assignmentSchema);



import mongoose from 'mongoose';

const assignmentSchema = new mongoose.Schema({
  title: String,
  description: String,
  dueDate: Date,
  classId: { type: mongoose.Schema.Types.ObjectId, ref: 'Class' },
  teacherId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  materials: [String], // Array of filenames
  createdAt: { type: Date, default: Date.now },
  submissions: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Submission', default: [] }]

}, {
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});




export default mongoose.model('Assignment', assignmentSchema);
