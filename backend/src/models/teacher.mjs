import mongoose from "mongoose";

const teacherSchema = new mongoose.Schema({
  // Reference to the User model
  userID: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User', // Reference to the User schema
    required: true
  },

  profileImage: { type: String }, // URL for profile image

  gender: { 
    type: String, 
    enum: ["Male", "Female", "Other"] 
  },

  age: { 
    type: Number 
  },

  qualifications: {
    type: String
  },

  subjects: [{
    type: String
  }],

  gradesTaught: [{
    type: String,
    enum: [
      "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5",
      "Grade 6", "Grade 7", "Grade 8", "Grade 9", "O/L",
      "A/L - Physical Science", "A/L - Biological Science",
      "A/L - Commerce", "A/L - Arts", "A/L - Technology", "A/L - Other"
    ]
  }],

  bio: {
    type: String
  }
}, {
  timestamps: true
});

// Create the model
const TeacherDetails = mongoose.models.TeacherDetails || mongoose.model("TeacherDetails", teacherSchema);

export default TeacherDetails;
