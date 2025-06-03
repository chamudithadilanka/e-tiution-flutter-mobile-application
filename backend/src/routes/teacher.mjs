
// import express from "express";
// import User from "../models/user.mjs";
// import TeacherDetails from "../models/teacher.mjs";


// const teacherRouter = express.Router();

// teacherRouter.get('/',async (req,res)=>{
//     try{
//         const teacher = await User.find({role:"teacher"});
//         res.json(teacher);

//     }catch(error){
//         res.status(500).json({ error: err.message });
//     }
// });

// export default teacherRouter;

import express from "express";
import User from "../models/user.mjs";
import Teacher from "../models/teacher.mjs";
import fs from "fs/promises";
import path from "path";

const teacherRouter = express.Router();

const UPLOADS_DIR = path.join('C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads');

// // POST: Create Teacher Profile
// teacherRouter.post("/details", async (req, res) => {
//   const { userID, gender, age, qualifications, subjects, gradesTaught, bio, profileImageBase64 } = req.body;

//   if (!userID) {
//     return res.status(400).json({ success: false, error: "User ID is required" });
//   }

//   try {
//     const userExists = await User.exists({ _id: userID });
//     if (!userExists) {
//       return res.status(404).json({ success: false, error: "User not found" });
//     }

//     const teacherExists = await Teacher.exists({ userID });
//     if (teacherExists) {
//       return res.status(409).json({ success: false, error: "Teacher profile already exists" });
//     }

//     let profileImage = null;

//     if (profileImageBase64) {
//       const matches = profileImageBase64.match(/^data:image\/(jpeg|jpg|png);base64,(.+)$/i);
//       if (!matches) {
//         return res.status(400).json({
//           success: false,
//           error: "Invalid image format. Only JPEG/JPG/PNG allowed"
//         });
//       }

//       const ext = matches[1];
//       const base64Data = matches[2];
//       const buffer = Buffer.from(base64Data, "base64");

//       if (buffer.length > 5 * 1024 * 1024) {
//         return res.status(413).json({
//           success: false,
//           error: "Image too large. Maximum size is 5MB"
//         });
//       }

//       try {
//         await fs.access(UPLOADS_DIR);
//       } catch {
//         await fs.mkdir(UPLOADS_DIR, { recursive: true });
//       }

//       profileImage = `teacher_${Date.now()}.${ext}`;
//       await fs.writeFile(path.join(UPLOADS_DIR, profileImage), buffer);
//     }

//     const teacher = await Teacher.create({
//       userID,
//       profileImage,
//       gender,
//       age: parseInt(age),
//       qualifications,
//       subjects,
//       gradesTaught,
//       bio
//     });

//     return res.status(201).json({
//       success: true,
//       message: "Teacher profile created successfully",
//       data: {
//         ...teacher.toObject(),
//         profileImageUrl: profileImage
//           ? `${req.protocol}://${req.get('host')}/uploads/${profileImage}`
//           : null
//       }
//     });

//   } catch (err) {
//     console.error("Teacher creation error:", err);
//     res.status(500).json({
//       success: false,
//       error: "Internal server error",
//       details: err.message
//     });
//   }
// });






// POST: Create Teacher Profile
teacherRouter.post("/details", async (req, res) => {
  const { userID, gender, age, qualifications, subjects, gradesTaught, bio, profileImageBase64 } = req.body;

  if (!userID) {
    return res.status(400).json({ success: false, error: "User ID is required" });
  }

  try {
    const userExists = await User.exists({ _id: userID });
    if (!userExists) {
      return res.status(404).json({ success: false, error: "User not found" });
    }

    const teacherExists = await Teacher.exists({ userID });
    if (teacherExists) {
      return res.status(409).json({ success: false, error: "Teacher profile already exists" });
    }

    let profileImage = null;

    // If profile image is provided, handle base64 upload
    if (profileImageBase64) {
      const matches = profileImageBase64.match(/^data:image\/(jpeg|jpg|png);base64,(.+)$/i);
      if (!matches) {
        return res.status(400).json({
          success: false,
          error: "Invalid image format. Only JPEG/JPG/PNG allowed"
        });
      }

      const ext = matches[1]; // Get the image extension (jpeg, jpg, or png)
      const base64Data = matches[2]; // Base64 encoded image data
      const buffer = Buffer.from(base64Data, "base64");

      if (buffer.length > 5 * 1024 * 1024) {
        return res.status(413).json({
          success: false,
          error: "Image too large. Maximum size is 5MB"
        });
      }

      // Ensure the uploads directory exists
      try {
        await fs.access(UPLOADS_DIR);
      } catch {
        await fs.mkdir(UPLOADS_DIR, { recursive: true });
      }

      profileImage = `teacher_${Date.now()}.${ext}`;
      // Save the image to the uploads directory
      await fs.writeFile(path.join(UPLOADS_DIR, profileImage), buffer);
    }

    // Create the teacher profile in the database
    const teacher = await Teacher.create({
      userID,
      profileImage,
      gender,
      age: parseInt(age),
      qualifications,
      subjects,
      gradesTaught,
      bio
    });

    // Return the response with the full image URL
    return res.status(201).json({
      success: true,
      message: "Teacher profile created successfully",
      data: {
        ...teacher.toObject(),
        profileImageUrl: profileImage
          ? `${req.protocol}://${req.get('host')}/uploads/${profileImage}`
          : null // If no profile image, return null
      }
    });

  } catch (err) {
    console.error("Teacher creation error:", err);
    return res.status(500).json({
      success: false,
      error: "Internal server error",
      details: err.message
    });
  }
});






teacherRouter.get("/details/:userID", async (req, res) => {
  const { userID } = req.params;

  try {
    // Check if user exists and is a teacher
    const user = await User.findOne({ _id: userID, role: 'teacher' }).select('-password -__v');
    if (!user) {
      return res.status(404).json({ success: false, error: "Teacher user not found" });
    }

    // Get teacher details
    const teacherDetails = await Teacher.findOne({ userID }).select('-__v');
    if (!teacherDetails) {
      return res.status(404).json({ success: false, error: "Teacher profile not found" });
    }

    const teacher = teacherDetails.toObject();

    // Build profileImageUrl if exists
    if (teacher.profileImage) {
      teacher.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${teacher.profileImage}`;
    }

    res.status(200).json({
      success: true,
      data: {
        user,
        profile: teacher
      }
    });

  } catch (error) {
    console.error("Error fetching teacher details:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
      error: error.message
    });
  }
});



export default teacherRouter;

