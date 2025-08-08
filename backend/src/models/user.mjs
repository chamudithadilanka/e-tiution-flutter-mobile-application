import mongoose from "mongoose";
import bcrypt from "bcryptjs";
import crypto from "crypto";

const userSchema = new mongoose.Schema({
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  email: { 
    type: String, 
    required: true, 
    unique: true,
    lowercase: true,
    trim: true
  },
  joinedClasses: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Class',
    default: [] // ✅ Add default value
  }],
  password: { type: String, required: true },
  role: { type: String, required: true, default: "user" },
  isVerified: { type: Boolean, default: false },
  verificationToken: String,
  verificationTokenExpires: Date,
  verifiedAt: Date
}, { timestamps: true });

// Hash password before saving
userSchema.pre("save", async function(next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

// Generate verification token
userSchema.methods.createVerificationToken = function() {
  const token = crypto.randomBytes(32).toString("hex");
  this.verificationToken = crypto
    .createHash("sha256")
    .update(token)
    .digest("hex");
  this.verificationTokenExpires = Date.now() + 24 * 60 * 60 * 1000; // 24 hours
  return token;
};

export default mongoose.model("User", userSchema);















// // // import mongoose from "mongoose";
// // // import bcrypt from "bcryptjs";

// // const userSchema = new mongoose.Schema({
// //   firstName: { type: String, required: true },
// //   lastName: { type: String, required: true },
// //   email: { type: String, required: true, unique: true },
// //   password: { type: String, required: true },
// //   role: { type: String, required: true },
// //   isVerified: { type: Boolean, default: false },
// //   verificationToken: { type: String },
// //   verificationExpires: { type: Date }
// // });

// // // Hash password before saving
// // userSchema.pre("save", async function(next) {
// //   if (!this.isModified("password")) return next();
// //   this.password = await bcrypt.hash(this.password, 12);
// //   next();
// // });

// // export default mongoose.model("User", userSchema);










// import mongoose from "mongoose";

// const userSchema = new mongoose.Schema({
//   firstName: String,
//   lastName: String,
//   email: { type: String, unique: true },
//   password: String,
//   role: String,
//   isVerified: { type: Boolean, default: false },
//   emailVerificationToken: String,
//   emailVerificationExpires: Date
// });

// const User = mongoose.model("User", userSchema);

// export default User;