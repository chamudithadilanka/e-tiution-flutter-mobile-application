import express from "express";
import User from "../models/user.mjs";
import StudentUser from "../models/student.mjs";
import multer from 'multer';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
const studentRouter = express.Router();
import upload from "../utils/upload.mjs";
import TeacherDetails from "../models/teacher.mjs";


// const __filename = fileURLToPath(import.meta.url);
// const __dirname = path.dirname(__filename);

const pathupload = 'C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads';

const UPLOADS_DIR = path.join(pathupload, '../uploads');


// // Get All Students in a Section
// studentRouter.get("/all", async (req, res) => {
//   try {
//     const students = await User.find({ role: "student", all: req.params.all });
//     res.json(students);
//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// });


// Get all students
studentRouter.get("/all", async (req, res) => {
  try {
    const students = await StudentUser.find()
      .populate({
        path: 'userID',
        select: '-password -__v' // Exclude sensitive fields
      })
      .select('-__v'); // Exclude version key from student schema

    // Add profile image URLs
    const studentList = students.map(student => {
      const studentObj = student.toObject();
      if (studentObj.profileImage) {
        studentObj.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${studentObj.profileImage}`;
      }
      return studentObj;
    });

    res.status(200).json({
      success: true,
      data: studentList
    });
  } catch (err) {
    console.error("Error fetching students:", err);
    res.status(500).json({
      success: false,
      error: "Failed to fetch students",
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});



// studentRouter.post("/details", async (req, res) => {
//   const { userID, profileImage, gender, age, grade, stream } = req.body;

//   // Basic input validation
//   if (!userID) {
//     return res.status(400).json({ error: "User ID is required" });
//   }

//   try {
//     // Optional: Check if user exists first
//     const existingUser = await User.findById(userID);
//     if (!existingUser) {
//       return res.status(404).json({ error: "User not found" });
//     }

//     const student = await StudentUser.create({
//       userID,
//       profileImage,
//       gender,
//       age,
//       grade,
//       stream
//     });

//     res.status(201).json(student);
//   } catch (err) {
//     console.error("Error creating student details:", err);
//     res.status(500).json({
//       error: "Failed to create student details",
//       details: err.message
//     });
//   }
// });




// studentRouter.post("/details", async (req, res) => {
//   const { userID, profileImage, gender, age, grade, stream } = req.body;

//   // Basic input validation
//   if (!userID) {
//     return res.status(400).json({ error: "User ID is required" });
//   }

//   try {
//     // Check if user exists first
//     const existingUser = await User.findById(userID);
//     if (!existingUser) {
//       return res.status(404).json({ error: "User not found" });
//     }

//     // NEW: Check if student details already exist for this user
//     const existingStudent = await StudentUser.findOne({ userID });
//     if (existingStudent) {
//       return res.status(400).json({ error: "Student details already exist for this user" });
//     }

//     // Create new student record if doesn't exist
//     const student = await StudentUser.create({
//       userID,
//       profileImage,
//       gender,
//       age,
//       grade,
//       stream
//     });

//     res.status(201).json(student);
//   } catch (err) {
//     console.error("Error creating student details:", err);
//     res.status(500).json({
//       error: "Failed to create student details",
//       details: err.message
//     });
//   }
// });



// Route to upload profile image change 2

// // Route to add student with profile image (base64)
// studentRouter.post("/details", async (req, res) => {
//   const { userID, gender, age, grade, stream, profileImageBase64 } = req.body;

//   if (!userID) {
//     return res.status(400).json({ error: "User ID is required" });
//   }

//   try {
//     const existingUser = await User.findById(userID);
//     if (!existingUser) {
//       return res.status(404).json({ error: "User not found" });
//     }

//     const existingStudent = await StudentUser.findOne({ userID });
//     if (existingStudent) {
//       return res.status(400).json({ error: "Student already exists" });
//     }

//     let profileImage = "";
//     if (profileImageBase64) {
//       const matches = profileImageBase64.match(/^data:image\/([a-zA-Z]+);base64,(.+)$/);
//       if (!matches || matches.length !== 3) {
//         return res.status(400).json({ error: "Invalid image format" });
//       }

//       const ext = matches[1]; // jpg, png, etc.
//       const base64Data = matches[2];
//       profileImage = `${Date.now()}.${ext}`;
//       const filePath = path.join(__dirname, "../uploads", profileImage);
//       fs.writeFileSync(filePath, Buffer.from(base64Data, "base64"));
//     }

//     const student = await StudentUser.create({
//       userID,
//       profileImage,
//       gender,
//       age,
//       grade,
//       stream
//     });

//     res.status(201).json({
//       success: true,
//       message: "Student created",
//       data: student,
//       profileImageUrl: `${req.protocol}://${req.get("host")}/uploads/${profileImage}`
//     });
//   } catch (err) {
//     console.error("Error:", err);
//     res.status(500).json({ error: "Internal server error", details: err.message });
//   }
// });
// Constants for configuration
// Configuration constants



studentRouter.post("/details", async (req, res) => {
  const { userID, gender, age, grade, stream, profileImageBase64 } = req.body;

  if (!userID) {
    return res.status(400).json({ 
      success: false,
      error: "User ID is required" 
    });
  }

  try {
    const userExists = await User.exists({ _id: userID });
    if (!userExists) {
      return res.status(404).json({
        success: false,
        error: "User not found"
      });
    }

    const studentExists = await StudentUser.exists({ userID });
    if (studentExists) {
      return res.status(409).json({
        success: false,
        error: "Student profile already exists"
      });
    }

    let profileImage = null;

    if (profileImageBase64) {
      const matches = profileImageBase64.match(/^data:image\/(jpeg|jpg|png);base64,(.+)$/i);
      if (!matches) {
        return res.status(400).json({
          success: false,
          error: "Invalid image format. Only JPEG/JPG/PNG allowed"
        });
      }

      const imageType = matches[1];
      const base64Data = matches[2];
      const buffer = Buffer.from(base64Data, 'base64');

      if (buffer.length > 5 * 1024 * 1024) {
        return res.status(413).json({
          success: false,
          error: "Image too large. Maximum size is 5MB"
        });
      }

      try {
        await fs.access(UPLOADS_DIR);
      } catch {
        await fs.mkdir(UPLOADS_DIR, { recursive: true });
      }

      profileImage = `profile_${Date.now()}.${imageType}`;
      await fs.writeFile(path.join(UPLOADS_DIR, profileImage), buffer);
    }

    const student = await StudentUser.create({
      userID,
      profileImage,
      gender,
      age: parseInt(age),
      grade,
      stream
    });

    const response = {
      success: true,
      message: "Student created successfully",
      data: {
        ...student.toObject(),
        profileImageUrl: profileImage 
          ? `${req.protocol}://${req.get('host')}/uploads/${profileImage}`
          : null
      }
    };

    return res.status(201).json(response);

  } catch (err) {
    console.error("Student creation error:", err);

    if (err.name === 'ValidationError') {
      return res.status(400).json({
        success: false,
        error: "Validation failed",
        details: err.errors
      });
    }

    return res.status(500).json({
      success: false,
      error: "Internal server error",
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});







// Get student details
// studentRouter.get("/details/:userID", async (req, res) => {
//   try {
//     const student = await StudentUser.findOne({ userID: req.params.userID })
//       .populate({
//         path: 'userID',
//         select: '-password -__v' // Exclude sensitive fields
//       })
//       .select('-__v'); // Exclude version key

//     if (!student) {
//       return res.status(404).json({
//         success: false,
//         error: "Student not found"
//       });
//     }

//     // Add profile image URL if exists
//     const studentData = student.toObject();
//     if (studentData.profileImage) {
//       studentData.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${studentData.profileImage}`;
//     }

//     res.status(200).json({
//       success: true,
//       data: studentData
//     });

//   } catch (err) {
//     console.error("Error fetching student:", err);
//     res.status(500).json({
//       success: false,
//       error: "Failed to fetch student details",
//       details: process.env.NODE_ENV === 'development' ? err.message : undefined
//     });
//   }
// });




// // Get student details
// studentRouter.get("/details/:userID", async (req, res) => {
//   try {
//     const student = await StudentUser.findOne({ userID: req.params.userID })
//       .populate({
//         path: 'userID',
//         select: '-password -__v',
//         populate: {
//           path: 'joinedClasses',
//           model: 'Class',
//           select: '-__v',
//           populate: {
//             path: 'teacher',
//             model: 'User', // Populate from User model
//             select: '-password -__v'
//           }
//         }
//       })
//       .select('-__v');

//     if (!student) {
//       return res.status(404).json({
//         success: false,
//         error: "Student not found"
//       });
//     }

//     // Add profile image URL if exists
//     const studentData = student.toObject();
//     if (studentData.profileImage) {
//       studentData.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${studentData.profileImage}`;
//     }

//     res.status(200).json({
//       success: true,
//       data: studentData
//     });

//   } catch (err) {
//     console.error("Error fetching student:", err);
//     res.status(500).json({
//       success: false,
//       error: "Failed to fetch student details",
//       details: process.env.NODE_ENV === 'development' ? err.message : undefined
//     });
//   }
// });


// Add this new route to your studentRouter




studentRouter.get("/details/:userID", async (req, res) => {
  try {
    const student = await StudentUser.findOne({ userID: req.params.userID })
      .populate({
        path: 'userID',
        select: '-password -__v',
        populate: {
          path: 'joinedClasses',
          model: 'Class',
          select: '-__v',
          populate: {
            path: 'teacher',
            model: 'User',
            select: '-password -__v'
          }
        }
      })
      .select('-__v');

    if (!student) {
      return res.status(404).json({
        success: false,
        error: "Student not found"
      });
    }

    const studentData = student.toObject();

    // Student profile image
    if (studentData.profileImage) {
      studentData.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${studentData.profileImage}`;
    }

    // Add teacher profile image from TeacherUser model
    if (studentData.userID?.joinedClasses) {
      for (const cls of studentData.userID.joinedClasses) {
        if (cls.teacher?._id) {
          const teacherExtra = await TeacherDetails.findOne({ userID: cls.teacher._id }).select('profileImage');

          if (teacherExtra?.profileImage) {
            cls.teacher.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${teacherExtra.profileImage}`;
          }
        }
      }
    }

    res.status(200).json({
      success: true,
      data: studentData
    });

  } catch (err) {
    console.error("Error fetching student:", err);
    res.status(500).json({
      success: false,
      error: "Failed to fetch student details",
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});











// Alternative route to get multiple ways of fetching
studentRouter.get("/details/:id", async (req, res) => {
  try {
    // Check if the ID is a valid ObjectId
    const isValidObjectId = mongoose.Types.ObjectId.isValid(req.params.id);

    let student;
    if (isValidObjectId) {
      // Try finding by UserID (converted to ObjectId)
      student = await StudentUser.findOne({ 
        userID: new mongoose.Types.ObjectId(req.params.id) 
      }).populate({
        path: 'userID',
        select: '-password'
      });

      // If not found by userID, try finding by MongoDB _id
      if (!student) {
        student = await StudentUser.findById(req.params.id)
          .populate({
            path: 'userID',
            select: '-password'
          });
      }
    }

    // If still no student found
    if (!student) {
      return res.status(404).json({ 
        error: "Student details not found",
        details: `No student found with ID: ${req.params.id}`
      });
    }

    res.status(200).json(student);
  } catch (err) {
    console.error("Error fetching student details:", err);
    res.status(500).json({
      error: "Failed to fetch student details",
      details: err.message
    });
  }
});


// GET /api/user/student-count
studentRouter.get("/student-count", async (req, res) => {
  try {
    const count = await User.countDocuments({ role: "student" });
    res.status(200).json({ studentCount: count });
  } catch (error) {
    res.status(500).json({ error: "Failed to count students", details: error.message });
  }
});


studentRouter.get("/stream/:stream", async (req, res) => {
  try {
    const students = await StudentUser.find()
      .populate({
        path: 'userID',
        select: '-password -__v'
      })
      .select('-__v');

    // Group students by stream
    const groupedByStream = {};

    students.forEach(student => {
      const stream = student.stream || "Unknown";

      // Format the student object and add image URL
      const studentObj = student.toObject();
      if (studentObj.profileImage) {
        studentObj.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${studentObj.profileImage}`;
      }

      if (!groupedByStream[stream]) {
        groupedByStream[stream] = [];
      }

      groupedByStream[stream].push(studentObj);
    });

    res.status(200).json({
      success: true,
      data: groupedByStream
    });
  } catch (err) {
    console.error("Error fetching students by stream:", err);
    res.status(500).json({
      success: false,
      error: "Failed to fetch students by stream",
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});

// Example (Express.js)
studentRouter.get('/stream/:stream', async (req, res) => {
  const { stream } = req.params;

  try {
    const students = await StudentUser.find({ stream }).populate('userID');
    res.status(200).json({ students });
  } catch (error) {
    res.status(500).json({ error: 'Failed to load students by stream' });
  }
});




// student  joined classes api ------
studentRouter.get("/:userID/joined-classes", async (req, res) => {
  try {
    const student = await StudentUser.findOne({ userID: req.params.userID })
      .populate({
        path: 'userID',
        select: 'joinedClasses',
        populate: {
          path: 'joinedClasses',
          model: 'Class',
          select: '-__v',
          populate: {
            path: 'teacher',
            model: 'User',
            select: '-password -__v'
          }
        }
      });

    if (!student) {
      return res.status(404).json({
        success: false,
        error: "Student not found"
      });
    }

    const enrichedClasses = [];

    for (const cls of student.userID.joinedClasses) {
      const classObj = cls.toObject();

      // Get teacher info
      if (classObj.teacher && classObj.teacher._id) {
        const teacherDetails = await TeacherDetails.findOne({
          userID: classObj.teacher._id
        }).select('profileImage');

        if (teacherDetails?.profileImage) {
          classObj.teacher.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${teacherDetails.profileImage}`;
        }

        // Include role (if not already present)
        classObj.teacher.role = 'teacher';
      }

      enrichedClasses.push(classObj);
    }

    res.status(200).json({
      success: true,
      joinedClasses: enrichedClasses
    });

  } catch (err) {
    console.error("Error fetching joined classes:", err);
    res.status(500).json({
      success: false,
      error: "Failed to fetch joined classes",
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});






export default studentRouter;