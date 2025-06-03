// import mongoose from "mongoose";

// const classSchema = new mongoose.Schema({
//   profileImage: { type: String },
//   className: { type: String, required: true },
//   subject: { type: String, required: true }, // fixed typo here
//   description:{type: String, required: true},
//   grade: { type: String, required: true },
//   teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
//   students: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
// }, { timestamps: true });

// export default mongoose.model("Class", classSchema);
import mongoose from "mongoose";

const classSchema = new mongoose.Schema({
  profileImage: { type: String },
  className: { type: String, required: true },
  subject: { type: String, required: true },
  description: { type: String, required: true },
  grade: { type: String, required: true },
  teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  students: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
}, { timestamps: true });

export default mongoose.model("Class", classSchema);
