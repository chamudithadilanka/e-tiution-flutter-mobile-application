import mongoose from "mongoose";

const submissionSchema = new mongoose.Schema({
  assignmentId: { type: mongoose.Schema.Types.ObjectId, ref: 'Assignment', required: true },
  studentId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  classId: { type: mongoose.Schema.Types.ObjectId, ref: 'Class', required: true },
  submittedAt: { type: Date, default: Date.now },
  file: { type: String, required: true }, // uploaded file name
  comments: { type: String } // optional
});

export default mongoose.model("Submission", submissionSchema);