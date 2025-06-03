import mongoose from "mongoose";

const studentSchema = new mongoose.Schema({
  // Reference to the User model
  userID: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User', // This should match the model name in the User schema
    required: true // Make the user reference mandatory
  },

  profileImage: { type: String }, // User profile image URL

  gender: { 
    type: String, 
    enum: ["Male", "Female", "Other"] 
  }, // Gender field

  age: { 
    type: Number 
  }, // Age field

  // Optional additional student-specific fields
 
  stream: {
    type: String,
    enum: [
      // Primary Levels
      "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5",
      
      // Upper Primary/Lower Secondary
      "Grade 6", "Grade 7", "Grade 8", "Grade 9",
      
      // Ordinary Level (O/L)
      "O/L",
      
      // Advanced Level (A/L) Streams
      "A/L - Physical Science",
      "A/L - Biological Science",
      "A/L - Commerce",
      "A/L - Arts",
      "A/L - Technology",
      "A/L - Other"
    ]
  },
  
}, {
  timestamps: true // Adds createdAt and updatedAt fields
});

// Create the model, avoiding re-compilation if it already exists
const StudentDetails = mongoose.models.StudentDetails || mongoose.model("StudentDetails", studentSchema);

export default StudentDetails;