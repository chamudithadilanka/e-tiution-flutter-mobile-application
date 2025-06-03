import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import crypto from "crypto";
import User from "../models/user.mjs";
import { sendVerificationEmail } from "../utils/emailservice.mjs";
import StudentUser from "../models/student.mjs";
import TeacherUser from "../models/teacher.mjs";
const router = express.Router();

// Helper to generate JWT token
const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, { expiresIn: "1d" });
};

// Helper to send error responses
const errorResponse = (res, status, message, error = null) => {
  return res.status(status).json({
    success: false,
    message,
    error: process.env.NODE_ENV === "development" ? error?.message : undefined,
  });
};

// Register
router.post("/register", async (req, res) => {
  const { firstName, lastName, email, password, role = "user" } = req.body;

  try {
    if (!firstName || !lastName || !email || !password) {
      return errorResponse(res, 400, "All fields are required.");
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return errorResponse(res, 409, "User already exists.");
    }

    const newUser = new User({ firstName, lastName, email, password, role });

    const rawToken = crypto.randomBytes(32).toString("hex");
    const hashedToken = crypto
      .createHash("sha256")
      .update(rawToken)
      .digest("hex");

    newUser.verificationToken = hashedToken;
    newUser.verificationExpires = Date.now() + 24 * 60 * 60 * 1000;
    await newUser.save();

    await sendVerificationEmail(
      email,
      rawToken,
      newUser._id,
      newUser.firstName
    );

    res.status(201).json({
      success: true,
      message:
        "Registration successful. Check your email to verify your account.",
      data: {
        id: newUser._id,
        firstName: newUser.firstName,
        lastName: newUser.lastName,
        email: newUser.email,
        role: newUser.role,
      },
    });
  } catch (error) {
    return errorResponse(res, 500, "Registration failed", error);
  }
});

// Email verification
router.get("/verify-email", async (req, res) => {
  let { token, userId } = req.query;

  console.log("Token: adasd", token);
  try {
    if (!token || !userId) {
      return errorResponse(res, 400, "Invalid or missing token or userId.");
    }

    // Fix if malformed
    if (token.includes("token="))
      token = token.split("token=")[1].split("&")[0];
    if (userId.includes("userId="))
      userId = userId.split("userId=")[1].split("&")[0];

    const hashedToken = crypto.createHash("sha256").update(token).digest("hex");

    const user = await User.findOne({
      _id: userId,
      verificationToken: hashedToken,
    });

    if (!user) {
      return errorResponse(res, 400, "Invalid or expired verification link.");
    }

    user.isVerified = true;
    user.verifiedAt = new Date();
    user.verificationToken = undefined;
    user.verificationTokenExpires = undefined;
    await user.save();

    if (req.accepts("json")) {
      return res.json({
        success: true,
        message: "Email verified successfully.",
        data: {
          email: user.email,
          verifiedAt: user.verifiedAt,
        },
      });
    }

    return res.redirect(`${process.env.BASE_URL}/login?verified=true`);
  } catch (error) {
    console.error("Verification error:", error);
    return errorResponse(res, 500, "Email verification failed", error);
  }
});

// // // Login
// router.post("/login", async (req, res) => {
//   const { email, password } = req.body;

//   try {
//     if (!email || !password) {
//       return errorResponse(res, 400, "Email and password are required.");
//     }

//     const user = await User.findOne({ email }).select("+password");

//     if (!user || !(await bcrypt.compare(password, user.password))) {
//       return errorResponse(res, 401, "Invalid credentials.");
//     }

//     if (!user.isVerified) {
//       return errorResponse(
//         res,
//         403,
//         "Please verify your email before logging in."
//       );
//     }

//     const token = generateToken(user._id);

//     const existingStudent = await StudentUser.findOne({ userID: user._id });

//     res.json({
//       success: true,
//       message: "Login successful.",
//       data: {
//         user: {
//           id: user._id,
//           firstName: user.firstName,
//           lastName: user.lastName,
//           email: user.email,
//           role: user.role,
//           isVerified: user.isVerified,
//           profileImage: existingStudent.profileImage,
//           gender: existingStudent.gender,
//           age: existingStudent.age,
//           grade: existingStudent.grade,
//           stream: existingStudent.stream,
//         },
//         token,
//         expiresIn: "24h",
//       },
//     });
//   } catch (error) {
//     return errorResponse(res, 500, "Login failed", error);
//   }
// });

// router.post("/login", async (req, res) => {
//   const { email, password } = req.body;

//   try {
//     // 1. Validate input
//     if (!email || !password) {
//       return errorResponse(res, 400, "Email and password are required.");
//     }

//     // 2. Find user with password
//     const user = await User.findOne({ email }).select("+password");
//     if (!user) {
//       return errorResponse(res, 401, "Invalid credentials.");
//     }

//     // 3. Verify password
//     const isPasswordValid = await bcrypt.compare(password, user.password);
//     if (!isPasswordValid) {
//       return errorResponse(res, 401, "Invalid credentials.");
//     }

//     // 4. Check verification status
//     if (!user.isVerified) {
//       return errorResponse(res, 403, "Please verify your email before logging in.");
//     }

//     // 5. Generate token
//     const token = generateToken(user._id);

//     // 6. Prepare base response
//     const response = {
//       success: true,
//       message: "Login successful.",
//       data: {
//         user: {
//           id: user._id,
//           firstName: user.firstName,
//           lastName: user.lastName,
//           email: user.email,
//           role: user.role,
//           isVerified: user.isVerified
//         },
//         token,
//         expiresIn: "24h"
//       }
//     };

//     // 7. Add student-specific fields only if role is student
//     if (user.role === "student") {
//       const studentProfile = await StudentUser.findOne({ userID: user._id });
//       if (studentProfile) {
//         response.data.user.profileImage = studentProfile.profileImage;
//         response.data.user.gender = studentProfile.gender;
//         response.data.user.age = studentProfile.age;
//         response.data.user.grade = studentProfile.grade;
//         response.data.user.stream = studentProfile.stream;
//       }
//     }

//     // 8. Send successful response
//     res.json(response);

//   } catch (error) {
//     console.error("Login error:", {
//       email: email,
//       error: error.message,
//       stack: error.stack
//     });
//     return errorResponse(res, 500, "Login failed. Please try again later.");
//   }
// });
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    if (!email || !password) {
      return errorResponse(res, 400, "Email and password are required.");
    }

    const user = await User.findOne({ email }).select("+password");

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return errorResponse(res, 401, "Invalid credentials.");
    }

    if (!user.isVerified) {
      return errorResponse(
        res,
        403,
        "Please verify your email before logging in."
      );
    }

    const token = generateToken(user._id);

    let extraData = {};

    if (user.role === "student") {
      const existingStudent = await StudentUser.findOne({ userID: user._id });

      if (existingStudent) {
        extraData = {
          profileImage: existingStudent.profileImage,
          gender: existingStudent.gender,
          age: existingStudent.age,
          grade: existingStudent.grade,
          stream: existingStudent.stream,
        };
      }
    }else if(user.role === "teacher"){
      const existingTeacher = await TeacherUser.findOne({ userID: user._id });
      if (existingTeacher) {
        extraData = {
          profileImage: existingTeacher.profileImage.startsWith('http') 
        ? existingTeacher.profileImage 
        : `${process.env.BASE_URL}/uploads/${existingTeacher.profileImage}`,
          gender:existingTeacher.gender,
          age:existingTeacher.age,
          qualifications:existingTeacher.qualifications,
          subjects:existingTeacher.subjects,
          gradesTaught:existingTeacher.gradesTaught,
          bio:existingTeacher.bio,
        };
    }
  }

    res.json({
      success: true,
      message: "Login successful.",
      data: {
        user: {
          id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          role: user.role,
          isVerified: user.isVerified,
          ...extraData, // only includes student fields if student
        },
        token,
        expiresIn: "24h",
      },
    });
  } catch (error) {
    console.error("Login error:", error);
    return errorResponse(res, 500, "Login failed");
  }
});


// Resend verification
router.post("/resend-verification", async (req, res) => {
  const { email } = req.body;

  try {
    if (!email) return errorResponse(res, 400, "Email is required.");

    const user = await User.findOne({ email });
    if (!user) return errorResponse(res, 404, "User not found.");
    if (user.isVerified)
      return errorResponse(res, 400, "Email already verified.");

    const newToken = crypto.randomBytes(32).toString("hex");
    const newTokenHash = crypto
      .createHash("sha256")
      .update(newToken)
      .digest("hex");

    user.verificationToken = newTokenHash;
    user.verificationExpires = Date.now() + 24 * 60 * 60 * 1000;
    await user.save();

    await sendVerificationEmail(email, newToken, user._id, user.firstName);

    res.json({
      success: true,
      message: "Verification email resent successfully.",
    });
  } catch (error) {
    return errorResponse(
      res,
      500,
      "Failed to resend verification email",
      error
    );
  }
});

export default router;

// import express from "express";
// import bcrypt from "bcryptjs";
// import jwt from "jsonwebtoken";
// import crypto from "crypto";
// import User from "../models/user.mjs";
// import { sendVerificationEmail } from "../utils/emailservice.mjs";

// const router = express.Router();

// // Helper function for generating tokens
// const generateToken = (userId) => {
//   return jwt.sign(
//     { userId },
//     process.env.JWT_SECRET,
//     { expiresIn: "1d" }
//   );
// };

// // Enhanced error response
// const errorResponse = (res, status, message, error = null) => {
//   return res.status(status).json({
//     success: false,
//     message,
//     error: process.env.NODE_ENV === "development" ? error?.message : undefined
//   });
// };

// // Register with Email Verification
// router.post("/register", async (req, res) => {
//   const { firstName, lastName, email, password, role = "user" } = req.body;

//   try {
//     // Validate input
//     if (!firstName || !lastName || !email || !password) {
//       return errorResponse(res, 400, "All fields are required");
//     }

//     // Check if user exists
//     const existingUser = await User.findOne({ email });
//     if (existingUser) {
//       return errorResponse(res, 409, "User already exists");
//     }

//     // Create user
//     const newUser = new User({
//       firstName,
//       lastName,
//       email,
//       password,
//       role
//     });

//     // Generate verification token
//     const verificationToken = crypto.randomBytes(32).toString("hex");
//     const verificationTokenHash = crypto
//       .createHash("sha256")
//       .update(verificationToken)
//       .digest("hex");

//     newUser.verificationToken = verificationTokenHash;
//     newUser.verificationExpires = Date.now() + 24 * 60 * 60 * 1000; // 24h expiry
//     await newUser.save();

//     // Send verification email
//     const verificationUrl = `${req.protocol}://${req.get("host")}/api/auth/verify-email?token=${verificationToken}&userId=${newUser._id}`;
//     await sendVerificationEmail(email, verificationUrl, newUser.firstName);

//     // Omit sensitive data in response
//     const userResponse = {
//       id: newUser._id,
//       firstName: newUser.firstName,
//       lastName: newUser.lastName,
//       email: newUser.email,
//       role: newUser.role
//     };

//     res.status(201).json({
//       success: true,
//       message: "Registration successful! Please check your email for verification.",
//       data: userResponse
//     });

//   } catch (error) {
//     errorResponse(res, 500, "Registration failed", error);
//   }
// });

// // Verify Email Endpoint
// router.get("/verify-email", async (req, res) => {
//   const { token, userId } = req.query;

//   try {
//     if (!token || !userId) {
//       return errorResponse(res, 400, "Invalid verification link");
//     }

//     // Hash the token to compare with stored token
//     const verificationTokenHash = crypto
//       .createHash("sha256")
//       .update(token)
//       .digest("hex");

//     // Find user and validate token
//     const user = await User.findOne({
//       _id: userId,
//       verificationToken: verificationTokenHash,
//       verificationExpires: { $gt: Date.now() }
//     });

//     if (!user) {
//       return errorResponse(res, 400, "Invalid or expired verification link");
//     }

//     // Mark as verified
//     user.isVerified = true;
//     user.verifiedAt = new Date();
//     user.verificationToken = undefined;
//     user.verificationExpires = undefined;
//     await user.save();

//     // For API response
//     if (req.accepts("json")) {
//       return res.json({
//         success: true,
//         message: "Email verified successfully!",
//         data: {
//           email: user.email,
//           verifiedAt: user.verifiedAt
//         }
//       });
//     }

//     // For browser redirect
//     return res.redirect(`${process.env.FRONTEND_URL}/login?verified=true`);

//   } catch (error) {
//     errorResponse(res, 500, "Verification failed", error);
//   }
// });

// // Login (only allowed for verified users)
// router.post("/login", async (req, res) => {
//   const { email, password } = req.body;

//   try {
//     // Validate input
//     if (!email || !password) {
//       return errorResponse(res, 400, "Email and password are required");
//     }

//     const user = await User.findOne({ email }).select("+password");
//     if (!user) {
//       return errorResponse(res, 401, "Invalid credentials");
//     }

//     // Check if email is verified
//     if (!user.isVerified) {
//       return errorResponse(res, 403,
//         "Please verify your email first. Check your inbox or request a new verification email."
//       );
//     }

//     // Check password
//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) {
//       return errorResponse(res, 401, "Invalid credentials");
//     }

//     // Generate JWT token
//     const authToken = generateToken(user._id);

//     // Omit sensitive data in response
//     const userResponse = {
//       id: user._id,
//       firstName: user.firstName,
//       lastName: user.lastName,
//       email: user.email,
//       role: user.role,
//       isVerified: user.isVerified
//     };

//     res.json({
//       success: true,
//       message: "Login successful",
//       data: {
//         user: userResponse,
//         token: authToken,
//         expiresIn: "24h"
//       }
//     });

//   } catch (error) {
//     errorResponse(res, 500, "Login failed", error);
//   }
// });

// // Resend Verification Email
// router.post("/resend-verification", async (req, res) => {
//   const { email } = req.body;

//   try {
//     if (!email) {
//       return errorResponse(res, 400, "Email is required");
//     }

//     const user = await User.findOne({ email });
//     if (!user) {
//       return errorResponse(res, 404, "User not found");
//     }

//     if (user.isVerified) {
//       return errorResponse(res, 400, "Email is already verified");
//     }

//     // Generate new verification token
//     const verificationToken = crypto.randomBytes(32).toString("hex");
//     const verificationTokenHash = crypto
//       .createHash("sha256")
//       .update(verificationToken)
//       .digest("hex");

//     user.verificationToken = verificationTokenHash;
//     user.verificationExpires = Date.now() + 24 * 60 * 60 * 1000;
//     await user.save();

//     // Send verification email
//     const verificationUrl = `${req.protocol}://${req.get("host")}/api/auth/verify-email?token=${verificationToken}&userId=${user._id}`;
//     await sendVerificationEmail(email, verificationUrl, user.firstName);

//     res.json({
//       success: true,
//       message: "Verification email resent successfully"
//     });

//   } catch (error) {
//     errorResponse(res, 500, "Failed to resend verification email", error);
//   }
// });

// export default router;

// import express from "express";
// import bcrypt from "bcryptjs";
// import jwt from "jsonwebtoken";
// import User from "../models/user.mjs";
// import { sendVerificationEmail } from "../utils/emailservice.mjs";

// const router = express.Router();

// // Register with Email Verification
// router.post("/register", async (req, res) => {
//   const { firstName, lastName, email, password, role } = req.body;

//   try {
//     // Check if user exists
//     const existingUser = await User.findOne({ email });
//     if (existingUser) {
//       return res.status(400).json({ message: "User already exists" });
//     }

//     // Create user (not verified yet)
//     const newUser = new User({ firstName, lastName, email, password, role });

//     // Generate verification token (expires in 24h)
//     const token = jwt.sign(
//       { userId: newUser._id },
//       process.env.JWT_SECRET,
//       { expiresIn: "1d" }
//     );

//     newUser.verificationToken = token;
//     newUser.verificationExpires = Date.now() + 24 * 60 * 60 * 1000; // 24h expiry
//     await newUser.save();

//     // Send verification email
//     await sendVerificationEmail(email, token, newUser._id);

//     res.status(201).json({
//       message: "✅ Registration successful! Check your email for verification.",
//       user: {
//         id: newUser._id,
//         firstName,
//         lastName,
//         email,
//         role
//       }
//     });

//   } catch (error) {
//     res.status(500).json({ message: "❌ Registration failed", error: error.message });
//   }
// });

// // Verify Email Endpoint
// router.get("/verify-email", async (req, res) => {
//   const { token, userId } = req.query;

//   try {
//     // Verify JWT token
//     const decoded = jwt.verify(token, process.env.JWT_SECRET);
//     if (decoded.userId !== userId) throw new Error("Invalid token");

//     // Find user and check token expiry
//     const user = await User.findById(userId);
//     if (!user || user.verificationToken !== token) {
//       return res.status(400).json({ message: "Invalid verification link" });
//     }

//     if (user.verificationExpires < Date.now()) {
//       return res.status(400).json({ message: "Verification link expired" });
//     }

//     // Mark as verified
//     user.isVerified = true;
//     user.verificationToken = undefined;
//     user.verificationExpires = undefined;
//     await user.save();

//     res.json({ message: "🎉 Email verified successfully!" });

//   } catch (error) {
//     res.status(400).json({ message: "Verification failed", error: error.message });
//   }
// });

// // Login (only allowed for verified users)
// router.post("/login", async (req, res) => {
//   const { email, password } = req.body;

//   try {
//     const user = await User.findOne({ email });
//     if (!user) return res.status(400).json({ message: "Invalid credentials" });

//     // Check if email is verified
//     if (!user.isVerified) {
//       return res.status(403).json({
//         message: "Email not verified. Check your inbox."
//       });
//     }

//     // Check password
//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) return res.status(400).json({ message: "Invalid credentials" });

//     // Successful login
//     res.json({
//       message: "✅ Login successful",
//       user: {
//         id: user._id,
//         firstName: user.firstName,
//         lastName: user.lastName,
//         email: user.email,
//         role: user.role
//       }
//     });

//   } catch (error) {
//     res.status(500).json({ message: "Login failed", error: error.message });
//   }
// });

// export default router;

// import express from "express";
// import bcrypt from "bcryptjs";
// import User from "../models/user.mjs";

// const router = express.Router();

// // Register User

// router.post("/register", async (req, res) => {
//     const { firstName, lastName, email, password, role } = req.body;

//     try {
//         // Check if user already exists
//         const existingUser = await User.findOne({ email });
//         if (existingUser) {
//             return res.status(400).json({ message: "User already exists" });
//         }

//         // Hash the password
//         const hashedPassword = await bcrypt.hash(password, 10);

//         // Create new user
//         const newUser = new User({
//             firstName,
//             lastName,
//             email,
//             password: hashedPassword,
//             role
//         });

//         // Save the user
//         await newUser.save();

//         // Respond with user details including MongoDB ObjectId
//         res.status(201).json({
//             message: "✅ User registered successfully",
//             role: newUser.role,
//             firstName: newUser.firstName,
//             lastName: newUser.lastName,
//             email: newUser.email,
//             id: newUser._id  // Correct way to include the ObjectId
//         });
//     } catch (error) {
//         console.error("Registration error:", error);
//         res.status(500).json({
//             message: "❌ Error registering user",
//             error: error.message
//         });
//     }
// });

// // router.post("/register", async (req, res) => {
// //     const { firstName, lastName, email, password,profileImage,gender ,role } = req.body;

// //     try {
// //         const existingUser = await User.findOne({ email });
// //         if (existingUser) return res.status(400).json({ message: "User already exists" });

// //         const hashedPassword = await bcrypt.hash(password, 10);
// //         const newUser = new User({ firstName, lastName, email, password: hashedPassword, role });

// //         await newUser.save();
// //         res.status(201).json({ message: "✅ User registered successfully", role ,firstName,lastName,email});
// //     } catch (error) {
// //         res.status(500).json({ message: "❌ Error registering user", error });
// //     }
// // });

// // Login User
// // router.post("/login", async (req, res) => {
// //     const { email, password } = req.body;

// //     try {
// //       // Check if user exists
// //       const user = await User.findOne({ email });
// //       if (!user) return res.status(400).json({ message: "Invalid credentials" });

// //       // Verify password
// //       const isPasswordCorrect = await bcrypt.compare(password, user.password);
// //       if (!isPasswordCorrect) return res.status(400).json({ message: "Invalid credentials" });

// //       // Return user information (excluding password)
// //       const userToReturn = {
// //         id: user._id,
// //         firstName: user.firstName,
// //         lastName: user.lastName,
// //         email: user.email,
// //         role: user.role
// //       };

// //       res.status(200).json({ message: "✅ Login successful", user: userToReturn });
// //     } catch (error) {
// //       res.status(500).json({ message: "❌ Error logging in", error });
// //     }
// //   });

// router.post("/login",async (req,res)=>{
//     const {email,password} = req.body;

//     try {
//         const user = await User.findOne({email});
//         if(!user) return res.status(400).json({message:"Invalid Credentials Email is Incorrect"});

//         const isPasswordCorrect = await bcrypt.compare(password,user.password);
//         if(!isPasswordCorrect) return res.status(400).json({message:"Invalid Credentials Password is Incorrect "});

//         const userToReturn = {
//             id:user._id,
//             firstName:user.firstName,
//             lastName:user.lastName,
//             email:user.email,
//             role:user.role
//         };

//         res.status(200).json({message:"Login Succesfull ",user:userToReturn});

//     } catch (error) {
//         res.status(500).json({ message: "❌ Error logging in", error });
//     }
// });

// export default router;
