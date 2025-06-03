import express from 'express';
import Class from '../models/class.mjs'; // Correct relative path
import User from '../models/user.mjs';    // Needed for teacher reference
import Student from '../models/student.mjs'; // Needed for student reference
import Teacher from '../models/teacher.mjs';
import fs from "fs/promises";
import path from "path";
import mongoose from 'mongoose';



const classRoutes = express.Router();

// POST /api/classes - Create new class
// classRoutes.post('/classes', async (req, res) => {
//   try {
//     const { className, stream, teacherId, studentIds } = req.body;

//     // Validate required fields
//     if (!className || !stream || !teacherId) {
//       return res.status(400).json({
//         success: false,
//         message: 'Class name, stream, and teacher ID are required'
//       });
//     }

//     // Verify teacher exists
//     const teacherExists = await User.findById(teacherId);
//     if (!teacherExists) {
//       return res.status(404).json({
//         success: false,
//         message: 'Teacher not found'
//       });
//     }

//     // Verify students exist if provided
//     if (studentIds && studentIds.length > 0) {
//       const studentsExist = await Student.countDocuments({ _id: { $in: studentIds } });
//       if (studentsExist !== studentIds.length) {
//         return res.status(404).json({
//           success: false,
//           message: 'One or more students not found'
//         });
//       }
//     }

//     const newClass = new Class({
//       className,
//       stream,
//       teacher: teacherId,
//       students: studentIds || []
//     });

//     const savedClass = await newClass.save();
    
//     res.status(201).json({
//       success: true,
//       message: 'Class created successfully',
//       data: savedClass
//     });

//   } catch (error) {
//     console.error('Error creating class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Internal server error',
//       error: error.message
//     });
//   }
// });




// classRoutes.post('/classes', async (req, res) => {
//   try {
//     const { className, subject, grade, teacherId, studentUserIds } = req.body;

//     // Validate required fields
//     if (!className || !subject || !grade || !teacherId) {
//       return res.status(400).json({
//         success: false,
//         message: 'Class name, subject, grade, and teacher ID are required'
//       });
//     }

//     // Verify teacher exists and is a teacher
//     const teacherExists = await User.findOne({
//       _id: teacherId,
//       role: 'teacher'
//     });

//     if (!teacherExists) {
//       return res.status(404).json({
//         success: false,
//         message: 'Teacher not found or user is not a teacher'
//       });
//     }

//     // Validate student users
//     let studentIds = [];
//     if (studentUserIds && studentUserIds.length > 0) {
//       const students = await User.find({
//         _id: { $in: studentUserIds },
//         role: 'student'
//       }).select('_id');

//       if (students.length !== studentUserIds.length) {
//         return res.status(404).json({
//           success: false,
//           message: 'One or more student users not found or are not students'
//         });
//       }

//       studentIds = students.map(student => student._id);
//     }

//     // Create and save the new class
//     const newClass = new Class({
//       className,
//       subject,
//       grade,
//       teacher: teacherId,
//       students: studentIds
//     });

//     const savedClass = await newClass.save();

//     // Populate references
//     const populatedClass = await Class.findById(savedClass._id)
//       .populate('teacher', 'name email role')
//       .populate('students', 'name email role');

//     res.status(201).json({
//       success: true,
//       message: 'Class created successfully',
//       data: populatedClass
//     });

//   } catch (error) {
//     console.error('Error creating class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Internal server error',
//       error: error.message
//     });
//   }
// });



//=====================fullu student details================================

// classRoutes.post('/classes', async (req, res) => {
//   try {
//     const { className, stream, teacherId, studentUserIds } = req.body;

//     if (!className || !stream || !teacherId) {
//       return res.status(400).json({
//         success: false,
//         message: 'Class name, stream, and teacher ID are required'
//       });
//     }

//     const teacherExists = await User.findOne({ _id: teacherId, role: 'teacher' });
//     if (!teacherExists) {
//       return res.status(404).json({
//         success: false,
//         message: 'Teacher not found or user is not a teacher'
//       });
//     }

//     // Validate and extract student IDs
//     let studentIds = [];
//     if (studentUserIds && studentUserIds.length > 0) {
//       const students = await User.find({
//         _id: { $in: studentUserIds },
//         role: 'student'
//       }).select('_id');

//       if (students.length !== studentUserIds.length) {
//         return res.status(404).json({
//           success: false,
//           message: 'One or more student users not found or are not students'
//         });
//       }

//       studentIds = students.map(student => student._id);
//     }

//     const newClass = new Class({
//       className,
//       stream,
//       teacher: teacherId,
//       students: studentIds
//     });

//     const savedClass = await newClass.save();

//     // ✅ Fetch full student details (like your /details/:userID route)
//     const fullStudents = await Student.find({ userID: { $in: studentIds } })
//       .populate({
//         path: 'userID',
//         select: '-password -__v'
//       })
//       .select('-__v');

//     const detailedStudents = fullStudents.map(student => {
//       const s = student.toObject();
//       if (s.profileImage) {
//         s.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${s.profileImage}`;
//       }
//       return s;
//     });

//     // Fetch teacher info
//     const teacher = {
//       _id: teacherExists._id,
//       name: teacherExists.name,
//       email: teacherExists.email,
//       role: teacherExists.role
//     };

//     res.status(201).json({
//       success: true,
//       message: 'Class created successfully',
//       data: {
//         _id: savedClass._id,
//         className,
//         stream,
//         teacher,
//         students: detailedStudents,
//         createdAt: savedClass.createdAt,
//         updatedAt: savedClass.updatedAt
//       }
//     });

//   } catch (error) {
//     console.error('Error creating class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Internal server error',
//       error: error.message
//     });
//   }
// });










// classRoutes.post('/classes', async (req, res) => {
//   try {
//     const { className, subject, grade, teacherId, studentUserIds } = req.body;

//     // Validate required fields
//     if (!className || !subject || !grade || !teacherId) {
//       return res.status(400).json({
//         success: false,
//         message: 'Class name, subject, grade, and teacher ID are required'
//       });
//     }

//     // Check if teacher exists
//     const teacherExists = await User.findOne({ _id: teacherId, role: 'teacher' });
//     if (!teacherExists) {
//       return res.status(404).json({
//         success: false,
//         message: 'Teacher not found or user is not a teacher'
//       });
//     }

//     // Validate students
//     let studentIds = [];
//     if (studentUserIds && studentUserIds.length > 0) {
//       const students = await User.find({
//         _id: { $in: studentUserIds },
//         role: 'student'
//       }).select('_id');

//       if (students.length !== studentUserIds.length) {
//         return res.status(404).json({
//           success: false,
//           message: 'One or more student users not found or are not students'
//         });
//       }

//       studentIds = students.map(student => student._id);
//     }

//     // Save the class
//     const newClass = new Class({
//       className,
//       subject,
//       grade,
//       teacher: teacherId,
//       students: studentIds
//     });

//     const savedClass = await newClass.save();

//     // Get minimal student details: id, email, role
//     const studentDetails = await User.find({ _id: { $in: studentIds } })
//       .select('_id email role');

//     // Get full teacher details
//     const teacherDetails = await Teacher.findOne({ userID: teacherId })
//       .populate({
//         path: 'userID',
//         select: '-password -__v'
//       })
//       .select('-__v');

//     let detailedTeacher = {};
//     if (teacherDetails) {
//       detailedTeacher = teacherDetails.toObject();
//       if (detailedTeacher.profileImage) {
//         detailedTeacher.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${detailedTeacher.profileImage}`;
//       }
//     }

//     // Response
//     res.status(201).json({
//       success: true,
//       message: 'Class created successfully',
//       data: {
//         _id: savedClass._id,
//         className,
//         subject,
//         grade,
//         teacher: detailedTeacher,
//         students: studentDetails,
//         createdAt: savedClass.createdAt,
//         updatedAt: savedClass.updatedAt
//       }
//     });

//     // const updatedTeacher = await Teacher.findOneAndUpdate(
//     //   { userID },
//     //   { $set: updatedFields },
//     //   { new: true }
//     // ).populate({
//     //   path: "userID",
//     //   select: "-password -__v"
//     // });






//   } catch (error) {
//     console.error('Error creating class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Internal server error',
//       error: error.message
//     });
//   }
// });



//======================================================second change class code






const UPLOADS_DIR = path.join("C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads\\");

classRoutes.post('/classes', async (req, res) => {
  try {
    const {
      className,
      subject,
      grade,
      teacherId,
      studentUserIds,
      description,
      profileImageBase64
    } = req.body;

    // Validate required fields
    if (!className || !subject || !grade || !teacherId || !description) {
      return res.status(400).json({
        success: false,
        message: 'Class name, subject, grade, teacher ID, and description are required'
      });
    }

    // Check teacher
    const teacherExists = await User.findOne({ _id: teacherId, role: 'teacher' });
    if (!teacherExists) {
      return res.status(404).json({
        success: false,
        message: 'Teacher not found or user is not a teacher'
      });
    }

    // Validate students
    let studentIds = [];
    if (studentUserIds && studentUserIds.length > 0) {
      const students = await User.find({
        _id: { $in: studentUserIds },
        role: 'student'
      }).select('_id');

      if (students.length !== studentUserIds.length) {
        return res.status(404).json({
          success: false,
          message: 'One or more student users not found or are not students'
        });
      }

      studentIds = students.map(s => s._id);
    }

    // Handle Base64 Image
    let profileImage = null;

    if (profileImageBase64) {
      const matches = profileImageBase64.match(/^data:image\/(jpeg|jpg|png);base64,(.+)$/i);
      if (!matches) {
        return res.status(400).json({
          success: false,
          error: "Invalid image format. Only JPEG/JPG/PNG allowed"
        });
      }

      const ext = matches[1];
      const base64Data = matches[2];
      const buffer = Buffer.from(base64Data, "base64");

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

      profileImage = `class_${Date.now()}.${ext}`;
      await fs.writeFile(path.join(UPLOADS_DIR, profileImage), buffer);
    }

    // Save class
    const newClass = new Class({
      className,
      subject,
      grade,
      description,
      teacher: teacherId,
      students: studentIds,
      profileImage
    });

    const savedClass = await newClass.save();

    const studentDetails = await User.find({ _id: { $in: studentIds } })
      .select('_id email role');

    const teacherDetails = await Teacher.findOne({ userID: teacherId }).populate({
      path: 'userID',
      select: '-password -__v'
    }).select('-__v');

    let detailedTeacher = {};
    if (teacherDetails) {
      detailedTeacher = teacherDetails.toObject();
      if (detailedTeacher.profileImage) {
        detailedTeacher.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${detailedTeacher.profileImage}`;
      }
    }

    res.status(201).json({
      success: true,
      message: 'Class created successfully',
      data: {
        _id: savedClass._id,
        className,
        subject,
        grade,
        description,
        teacher: detailedTeacher,
        students: studentDetails,
        profileImageUrl: profileImage
          ? `${req.protocol}://${req.get('host')}/uploads/classes/${profileImage}`
          : null,
        createdAt: savedClass.createdAt,
        updatedAt: savedClass.updatedAt
      }
    });

  } catch (error) {
    console.error('Error creating class:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});














// // GET: Get all classes by teacher ID
// classRoutes.get('/classes/teacher/:teacherId', async (req, res) => {
//   const { teacherId } = req.params;

//   try {
//     const classes = await Class.find({ teacher: teacherId })
//       .populate('students', '_id email role')
//       .populate('teacher', '_id email role');

//     res.status(200).json({
//       success: true,
//       data: classes
//     });
//   } catch (error) {
//     console.error('Error fetching teacher classes:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Failed to fetch classes for the teacher',
//       error: error.message
//     });
//   }
// });

// // GET: Get all classes by userID if the user is a teacher
// classRoutes.get('/classes/user/:userId', async (req, res) => {
//   const { userId } = req.params;

//   try {
//     // Check if the user is a teacher
//     const teacherUser = await User.findOne({ _id: userId, role: 'teacher' });
//     if (!teacherUser) {
//       return res.status(404).json({
//         success: false,
//         message: 'User not found or is not a teacher'
//       });
//     }

//     // Find all classes taught by this teacher
//     const classes = await Class.find({ teacher: userId })
//       .populate('students', '_id email role')
//       .populate('teacher', '_id email role');

//     res.status(200).json({
//       success: true,
//       data: classes
//     });

//   } catch (error) {
//     console.error('Error fetching teacher classes:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Failed to fetch classes for the teacher',
//       error: error.message
//     });
//   }
// });

// GET: Get all classes by userID if the user is a teacher
classRoutes.get('/classes/user/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    // Check if the user is a teacher
    const teacherUser = await User.findOne({ _id: userId, role: 'teacher' });
    if (!teacherUser) {
      return res.status(404).json({
        success: false,
        message: 'User not found or is not a teacher'
      });
    }

    // Fetch the teacher profile details from Teacher collection
    const teacherProfile = await Teacher.findOne({ userID: userId })
      .populate({
        path: 'userID',
        select: '-password -__v' // Exclude sensitive data
      });

    if (!teacherProfile) {
      return res.status(404).json({
        success: false,
        message: 'Teacher profile not found'
      });
    }

    // Get the teacher's classes
    const classes = await Class.find({ teacher: userId })
      .populate('students', '_id email role');

    // Append full teacher profile (with image URL if present)
    const teacherData = teacherProfile.toObject();
    if (teacherData.profileImage) {
      teacherData.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${teacherData.profileImage}`;
    }

    // Add teacher details to each class
    const enrichedClasses = classes.map(cls => {
      return {
        ...cls.toObject(),
        teacher: teacherData
      };
    });

    res.status(200).json({
      success: true,
      data: enrichedClasses
    });

  } catch (error) {
    console.error('Error fetching teacher classes:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch classes for the teacher',
      error: error.message
    });
  }
});



// Example: GET /classes/grade/A%2FL%20-%20Arts==================================
// classRoutes.get('/classes/grade/:grade', async (req, res) => {
//   try {
//     const grade = decodeURIComponent(req.params.grade);

//     const classes = await Class.find({ grade })
//       .populate({
//         path: 'teacher',
//         select: '-password -__v'
//       })
//       .populate({
//         path: 'students',
//         select: 'name email'
//       });

//     res.status(200).json({
//       success: true,
//       message: `Classes for grade ${grade}`,
//       data: classes,
//     });
//   } catch (error) {
//     console.error('Error fetching classes by grade:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Server error while fetching classes',
//       error: error.message,
//     });
//   }
// });




classRoutes.get('/classes/grade/:grade', async (req, res) => {
  try {
    const grade = decodeURIComponent(req.params.grade);

    // Step 1: Get classes with populated student and teacher references
    const classes = await Class.find({ grade })
      .populate('students', 'name email')
      .populate('teacher'); // Populate teacher userID only (we'll manually enrich next)

    // Step 2: Enrich each class with full teacher profile
    const enrichedClasses = await Promise.all(
      classes.map(async (cls) => {
        const teacherUserID = cls.teacher?._id;
        const teacherProfile = await Teacher.findOne({ userID: teacherUserID })
          .populate('userID', 'name email'); // adjust fields as needed

        if (!teacherProfile) {
          return {
            ...cls.toObject(),
            teacher: null,
          };
        }

        const teacherData = teacherProfile.toObject();

        // Add full image URL if profileImage is present
        if (teacherData.profileImage) {
          teacherData.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${teacherData.profileImage}`;
        }

        return {
          ...cls.toObject(),
          teacher: teacherData,
        };
      })
    );

    res.status(200).json({
      success: true,
      message: `Classes for grade ${grade}`,
      data: enrichedClasses,
    });
  } catch (error) {
    console.error('Error fetching classes by grade:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching classes',
      error: error.message,
    });
  }
});







classRoutes.get('/classes/student/:grade', async (req, res) => {
  try {
    const grade = decodeURIComponent(req.params.grade);

    const classes = await Class.find({ grade })
      .populate({
        path: 'teacher',
        select: 'firstName lastName email profileImage role' // Include relevant teacher fields
      })
      .populate({
        path: 'students',
        select: 'firstName lastName email profileImage role', // Include student details
        populate: { // Nested population if students reference other collections
          path: 'additionalStudentInfo', // Example: if students have additional info
          select: 'grade level' // Select specific fields
        }
      });

    // Transform the data to include proper image URLs
    const classesWithUrls = classes.map(classItem => ({
      ...classItem.toObject(),
      teacher: {
        ...classItem.teacher.toObject(),
        profileImageUrl: classItem.teacher.profileImage 
          ? `${req.protocol}://${req.get('host')}/uploads/${classItem.teacher.profileImage}`
          : null
      },
      students: classItem.students.map(student => ({
        ...student.toObject(),
        profileImageUrl: student.profileImage
          ? `${req.protocol}://${req.get('host')}/uploads/${student.profileImage}`
          : null
      }))
    }));

    res.status(200).json({
      success: true,
      message: `Classes for grade ${grade}`,
      data: classesWithUrls,
    });
  } catch (error) {
    console.error('Error fetching classes by grade:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching classes',
      error: error.message,
    });
  }
});





// GET /api/classes - Get all classes
classRoutes.get('/', async (req, res) => {
  try {
    const classes = await Class.find()
      .populate('teacher', 'name email role')
      .populate('students', 'name rollNumber');

    res.status(200).json({
      success: true,
      count: classes.length,
      data: classes
    });
  } catch (error) {
    console.error('Error fetching classes:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch classes',
      error: error.message
    });
  }
});

// GET /api/classes/:id - Get single class
// classRoutes.get('/:id', async (req, res) => {
//   try {
//     const classData = await Class.findById(req.params.id)
//       .populate('teacher')
//       .populate('students');

//     if (!classData) {
//       return res.status(404).json({
//         success: false,
//         message: 'Class not found'
//       });
//     }

//     res.status(200).json({
//       success: true,
//       data: classData
//     });
//   } catch (error) {
//     console.error('Error fetching class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Failed to fetch class',
//       error: error.message
//     });
//   }
// });


// classRoutes.get('/:id', async (req, res) => {
//   try {
//     const classData = await Class.findById(req.params.id)
//       .populate({
//         path: 'teacher',
//         select: 'firstName lastName email profileImage',
//         transform: (doc) => {
//           if (!doc) return null;
//           return {
//             _id: doc._id,
//             firstName: doc.firstName,
//             lastName: doc.lastName,
//             email: doc.email,
//             profileImageUrl: doc.profileImage 
//               ? `${req.protocol}://${req.get('host')}/uploads/${doc.profileImage}`
//               : null
//           };
//         }
//       })
//       .populate({
//         path: 'students',
//         select: 'name email',
//         transform: (doc) => ({
//           _id: doc._id,
//           name: doc.name,
//           email: doc.email
//         })
//       })
//       .lean(); // Convert to plain JavaScript object

//     if (!classData) {
//       return res.status(404).json({
//         success: false,
//         message: 'Class not found'
//       });
//     }

//     // Transform the response to exactly match your Dart model
//     const responseData = {
//       _id: classData._id,
//       className: classData.className,
//       subject: classData.subject,
//       grade: classData.grade,
//       description: classData.description,
//       teacher: classData.teacher || null, // Handles case when teacher is not populated
//       students: classData.students || [], // Ensures students is always an array
//       profileImageUrl: classData.profileImage 
//         ? `${req.protocol}://${req.get('host')}/uploads/${classData.profileImage}`
//         : null,
//       createdAt: classData.createdAt.toISOString(),
//       updatedAt: classData.updatedAt.toISOString()
//     };

//     res.status(200).json({
//       success: true,
//       data: responseData
//     });
//   } catch (error) {
//     console.error('Error fetching class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Failed to fetch class',
//       error: error.message
//     });
//   }
// });










// classRoutes.get('/:id', async (req, res) => {
//   try {
//     const classId = req.params.id;

//     // Step 1: Find the class and populate student and teacher references
//     const classDoc = await Class.findById(classId)
//       .populate('students', 'name email')
//       .populate('teacher'); // teacher is a User reference

//     if (!classDoc) {
//       return res.status(404).json({
//         success: false,
//         message: 'Class not found'
//       });
//     }

//     const classData = classDoc.toObject();

//     // Step 2: Get Teacher profile using teacher user ID from Class
//     const teacherUserID = classDoc.teacher?._id;

//     let teacherFull = null;

//     if (teacherUserID) {
//       // Fetch teacher by userID
//       const teacherProfile = await Teacher.findOne({ userID: teacherUserID })
//         .populate('userID', 'firstName lastName email role'); // Pull details from User model

//       if (teacherProfile && teacherProfile.userID) {
//         const teacherData = teacherProfile.toObject();

//         // Construct profileImage URL if exists
//         const profileImageUrl = teacherData.profileImage
//           ? `${req.protocol}://${req.get('host')}/uploads/${teacherData.profileImage}`
//           : null;

//         // Combine userID (user info) + teacher info
//         teacherFull = {
//           _id: teacherData._id,
//           firstName: teacherData.userID.firstName,
//           lastName: teacherData.userID.lastName,
//           email: teacherData.userID.email,
//           role: teacherData.userID.role,
//           profileImageUrl: profileImageUrl,
//           createdAt: teacherData.createdAt?.toISOString(),
//           updatedAt: teacherData.updatedAt?.toISOString()
//         };
//       }
//     }

//     // Add class profile image URL if applicable
//     const classProfileImageUrl = classData.profileImage
//       ? `${req.protocol}://${req.get('host')}/uploads/${classData.profileImage}`
//       : null;

//     const responseData = {
//       ...classData,
//       teacher: teacherFull,
//       profileImageUrl: classProfileImageUrl,
//       createdAt: classData.createdAt?.toISOString(),
//       updatedAt: classData.updatedAt?.toISOString()
//     };

//     res.status(200).json({
//       success: true,
//       data: responseData
//     });
//   } catch (error) {
//     console.error('Error fetching class:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Failed to fetch class',
//       error: error.message
//     });
//   }
// });





classRoutes.get('/:id', async (req, res) => {
  try {
    const classId = req.params.id;

    // Step 1: Find the class and populate teacher + student User references
    const classDoc = await Class.findById(classId)
      .populate('students') // First populate students (User references)
      .populate('teacher');

    if (!classDoc) {
      return res.status(404).json({
        success: false,
        message: 'Class not found'
      });
    }

    const classData = classDoc.toObject();

    // Step 2: Populate full student profiles for users with role 'student'
    const studentProfiles = await Promise.all(
      classDoc.students.map(async (studentUser) => {
        if (studentUser.role === 'student') {
          const studentProfile = await Student.findOne({ userID: studentUser._id });

          if (studentProfile) {
            const profileImageUrl = studentProfile.profileImage
              ? `${req.protocol}://${req.get('host')}/uploads/${studentProfile.profileImage}`
              : null;

            return {
              _id: studentProfile._id,
              firstName: studentUser.firstName,
              lastName: studentUser.lastName,
              email: studentUser.email,
              gender: studentProfile.gender,
              age: studentProfile.age,
              stream: studentProfile.stream,
              profileImageUrl,
              createdAt: studentProfile.createdAt,
              updatedAt: studentProfile.updatedAt
            };
          }
        }
        return null;
      })
    );

    const filteredStudents = studentProfiles.filter(profile => profile !== null);

    // Step 3: Get Teacher profile using teacher user ID from Class
    const teacherUserID = classDoc.teacher?._id;
    let teacherFull = null;

    if (teacherUserID) {
      const teacherProfile = await Teacher.findOne({ userID: teacherUserID })
        .populate('userID', 'firstName lastName email role');

      if (teacherProfile && teacherProfile.userID) {
        const teacherData = teacherProfile.toObject();
        const profileImageUrl = teacherData.profileImage
          ? `${req.protocol}://${req.get('host')}/uploads/${teacherData.profileImage}`
          : null;

        teacherFull = {
          _id: teacherData._id,
          firstName: teacherData.userID.firstName,
          lastName: teacherData.userID.lastName,
          email: teacherData.userID.email,
          role: teacherData.userID.role,
          profileImageUrl,
          createdAt: teacherData.createdAt,
          updatedAt: teacherData.updatedAt
        };
      }
    }

    // Step 4: Add class profile image URL if exists
    const classProfileImageUrl = classData.profileImage
      ? `${req.protocol}://${req.get('host')}/uploads/${classData.profileImage}`
      : null;

    const responseData = {
      ...classData,
      students: filteredStudents,
      teacher: teacherFull,
      profileImageUrl: classProfileImageUrl,
      createdAt: classData.createdAt,
      updatedAt: classData.updatedAt
    };

    res.status(200).json({
      success: true,
      data: responseData
    });

  } catch (error) {
    console.error('Error fetching class:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch class',
      error: error.message
    });
  }
});


















// PUT /api/classes/:id - Update class
classRoutes.put('/:id', async (req, res) => {
  try {
    const { className, stream, teacherId, studentIds } = req.body;
    
    // Verify class exists
    const existingClass = await Class.findById(req.params.id);
    if (!existingClass) {
      return res.status(404).json({
        success: false,
        message: 'Class not found'
      });
    }

    // Verify teacher exists if being updated
    if (teacherId) {
      const teacherExists = await User.findById(teacherId);
      if (!teacherExists) {
        return res.status(404).json({
          success: false,
          message: 'Teacher not found'
        });
      }
    }

    // Verify students exist if being updated
    if (studentIds && studentIds.length > 0) {
      const studentsExist = await Student.countDocuments({ _id: { $in: studentIds } });
      if (studentsExist !== studentIds.length) {
        return res.status(404).json({
          success: false,
          message: 'One or more students not found'
        });
      }
    }

    const updatedClass = await Class.findByIdAndUpdate(
      req.params.id,
      {
        className: className || existingClass.className,
        stream: stream || existingClass.stream,
        teacher: teacherId || existingClass.teacher,
        students: studentIds || existingClass.students
      },
      { new: true, runValidators: true }
    );

    res.status(200).json({
      success: true,
      message: 'Class updated successfully',
      data: updatedClass
    });
  } catch (error) {
    console.error('Error updating class:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update class',
      error: error.message
    });
  }
});

// DELETE /api/classes/:id - Delete class
classRoutes.delete('/:id', async (req, res) => {
  try {
    const deletedClass = await Class.findByIdAndDelete(req.params.id);

    if (!deletedClass) {
      return res.status(404).json({
        success: false,
        message: 'Class not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Class deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting class:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to delete class',
      error: error.message
    });
  }
});


// ===============---------------------================-----------join class------------------========================
// classRoutes.post('/:id/join', async (req, res) => {
//   try {
//     const classId = req.params.id;
//     const { studentId } = req.body;

//     if (!studentId || !mongoose.Types.ObjectId.isValid(studentId)) {
//       return res.status(400).json({ success: false, message: 'Invalid or missing studentId' });
//     }

//     const classDoc = await Class.findById(classId);
//     if (!classDoc) {
//       return res.status(404).json({ success: false, message: 'Class not found' });
//     }

//     const alreadyJoined = classDoc.students.some(id => id.equals(studentId));
//     if (alreadyJoined) {
//       return res.status(400).json({ success: false, message: 'Student already joined' });
//     }

//     classDoc.students.push(new mongoose.Types.ObjectId(studentId));
//     await classDoc.save();

//     res.status(200).json({ success: true, message: 'Successfully joined class' });
//   } catch (error) {
//     console.error('Join class error:', error);
//     res.status(500).json({ success: false, message: 'Server error', error: error.message });
//   }
// });





// classRoutes.post('/:id/join', async (req, res) => {
//   try {
//     const classId = req.params.id;
//     const { studentId } = req.body;

//     if (!studentId || !mongoose.Types.ObjectId.isValid(studentId)) {
//       return res.status(400).json({ success: false, message: 'Invalid or missing studentId' });
//     }

//     const classDoc = await Class.findById(classId);
//     if (!classDoc) {
//       return res.status(404).json({ success: false, message: 'Class not found' });
//     }

//     const user = await User.findById(studentId);
//     if (!user || user.role !== 'student') {
//       return res.status(404).json({ success: false, message: 'Student user not found or invalid role' });
//     }

//     // Add student to class if not already added
//     if (!classDoc.students.some(id => id.equals(studentId))) {
//       classDoc.students.push(studentId);
//       await classDoc.save();
//     }

//     // Add class to user's joinedClasses if not already added
//     if (!user.joinedClasses.some(id => id.equals(classId))) {
//       user.joinedClasses.push(classId);
//       await user.save();
//     }

//     res.status(200).json({ success: true, message: 'Successfully joined class' });
//   } catch (error) {
//     console.error('Join class error:', error);
//     res.status(500).json({ success: false, message: 'Server error', error: error.message });
//   }
// });




// classRoutes.post('/:id/join', async (req, res) => {
//   try {
//     const classId = req.params.id;
//     const { studentId } = req.body;

//     if (!studentId || !mongoose.Types.ObjectId.isValid(studentId)) {
//       return res.status(400).json({ success: false, message: 'Invalid or missing studentId' });
//     }

//     const classDoc = await Class.findById(classId);
//     if (!classDoc) {
//       return res.status(404).json({ success: false, message: 'Class not found' });
//     }

//     const user = await User.findById(studentId);
//     if (!user || user.role !== 'student') {
//       return res.status(404).json({ success: false, message: 'Student user not found or invalid role' });
//     }

//     // Add student to class if not already added
//     if (!classDoc.students.some(id => id.equals(studentId))) {
//       classDoc.students.push(studentId);
//       await classDoc.save();
//     }

//     // Add class to user's joinedClasses if not already added
//     if (!Array.isArray(user.joinedClasses)) user.joinedClasses = [];
    
//     if (!user.joinedClasses.some(id => id.equals(classId))) {
//       user.joinedClasses.push(classId);
//       await user.save();
//     }

//     // Populate joined classes
//     const updatedUser = await User.findById(studentId).populate('joinedClasses');

//     res.status(200).json({
//       success: true,
//       message: 'Successfully joined class',
//       joinedClasses: updatedUser.joinedClasses // ✅ return full class data
//     });
//   } catch (error) {
//     console.error('Join class error:', error);
//     res.status(500).json({ success: false, message: 'Server error', error: error.message });
//   }
// });

// classRoutes.post('/:id/join', async (req, res) => {
//   try {
//     const classId = req.params.id;
//     const { studentId } = req.body;

//     if (!studentId || !mongoose.Types.ObjectId.isValid(studentId)) {
//       return res.status(400).json({ success: false, message: 'Invalid or missing studentId' });
//     }

//     const classDoc = await Class.findById(classId);
//     if (!classDoc) {
//       return res.status(404).json({ success: false, message: 'Class not found' });
//     }

//     const user = await User.findById(studentId);
//     if (!user || user.role !== 'student') {
//       return res.status(404).json({ success: false, message: 'Student user not found or invalid role' });
//     }

//     // Add student to class if not already added
//     if (!classDoc.students.some(id => id.equals(studentId))) {
//       classDoc.students.push(studentId);
//       await classDoc.save();
//     }

//     // Add class to user's joinedClasses if not already added
//     if (!Array.isArray(user.joinedClasses)) user.joinedClasses = [];
    
//     if (!user.joinedClasses.some(id => id.equals(classId))) {
//       user.joinedClasses.push(classId);
//       await user.save();
//     }

//     // Populate joined classes
//     const updatedUser = await User.findById(studentId).populate('joinedClasses');

//     res.status(200).json({
//       success: true,
//       message: 'Successfully joined class',
//       joinedClasses: updatedUser.joinedClasses // ✅ return full class data
//     });
//   } catch (error) {
//     console.error('Join class error:', error);
//     res.status(500).json({ success: false, message: 'Server error', error: error.message });
//   }
// });


classRoutes.post('/:id/join', async (req, res) => {
  try {
    const classId = req.params.id;
    const { studentId } = req.body;

    if (!studentId || !mongoose.Types.ObjectId.isValid(studentId)) {
      return res.status(400).json({ success: false, message: 'Invalid or missing studentId' });
    }

    const classDoc = await Class.findById(classId);
    if (!classDoc) {
      return res.status(404).json({ success: false, message: 'Class not found' });
    }

    const user = await User.findById(studentId);
    if (!user || user.role !== 'student') {
      return res.status(404).json({ success: false, message: 'Student user not found or invalid role' });
    }

    // Add student to class if not already added
    if (!classDoc.students.some(id => id.equals(studentId))) {
      classDoc.students.push(studentId);
      await classDoc.save();
    }

    // Add class to user's joinedClasses if not already added
    if (!user.joinedClasses.some(id => id.equals(classId))) {
      user.joinedClasses.push(classId);
      await user.save();
    }

    // ✅ Populate joined classes (with class details and students inside each class)
    const updatedUser = await User.findById(studentId)
      .populate({
        path: 'joinedClasses',
        populate: { path: 'students', select: 'firstName lastName email profileImage' } // you can add more fields
      });

    res.status(200).json({
      success: true,
      message: 'Successfully joined class',
      joinedClasses: updatedUser.joinedClasses
    });
  } catch (error) {
    console.error('Join class error:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});



classRoutes.get('/by-name/:name', async (req, res) => {
  try {
    const className = req.params.name;

    // Step 1: Find class by className and populate student User references with role 'student'
    const classDoc = await Class.findOne({ className })
      .populate({
        path: 'students',
        model: 'User',
        match: { role: 'student' },
        select: 'firstName lastName email role createdAt updatedAt'
      });

    if (!classDoc) {
      return res.status(404).json({ success: false, message: 'Class not found' });
    }

    // Step 2: For each student user, get their detailed student profile from Student collection
    const studentProfiles = await Promise.all(
      classDoc.students.map(async (studentUser) => {
        if (studentUser.role === 'student') {
          const studentProfile = await Student.findOne({ userID: studentUser._id });

          if (studentProfile) {
            // Build full URL for profile image if exists
            const profileImageUrl = studentProfile.profileImage
              ? `${req.protocol}://${req.get('host')}/uploads/${studentProfile.profileImage}`
              : null;

            return {
              _id: studentUser._id,
              firstName: studentUser.firstName,
              lastName: studentUser.lastName,
              email: studentUser.email,
              gender: studentProfile.gender || null,
              age: studentProfile.age || null,
              stream: studentProfile.stream || null,
              profileImageUrl,
              createdAt: studentUser.createdAt,
              updatedAt: studentUser.updatedAt
            };
          } else {
            // If no Student profile, return minimal user info with nulls
            return {
              _id: studentUser._id,
              firstName: studentUser.firstName,
              lastName: studentUser.lastName,
              email: studentUser.email,
              gender: null,
              age: null,
              stream: null,
              profileImageUrl: null,
              createdAt: studentUser.createdAt,
              updatedAt: studentUser.updatedAt
            };
          }
        }
      })
    );

    // Filter out undefined/null (in case of non-students)
    const filteredStudents = studentProfiles.filter(Boolean);

    // Step 3: Return class details with enriched student profiles
    res.status(200).json({
      success: true,
      data: {
        className: classDoc.className,
        subject: classDoc.subject,
        grade: classDoc.grade,
        students: filteredStudents
      }
    });

  } catch (error) {
    console.error('Error fetching students by class name:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});




// classes name using teacher id

classRoutes.get('/by-teacher/:teacherId', async (req, res) => {
  try {
    const teacherId = req.params.teacherId;

    // Find all classes where teacherId matches
    const classes = await Class.find({ teacherId }).select('className');

    if (!classes || classes.length === 0) {
      return res.status(404).json({ success: false, message: 'No classes found for this teacher' });
    }

    // Send list of class names
    res.status(200).json({
      success: true,
      data: classes,  // [{_id:..., className:...}, ...]
    });
  } catch (error) {
    console.error('Error fetching classes by teacher ID:', error);
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});






// classRoutes.get('/classes/:id', async (req, res) => {
//   const { id } = req.params;

//   try {
//     // Find the class and populate teacher (User) and students (User)
//     const classData = await Class.findById(id)
//       .populate('teacher', '-password -__v') // Populate teacher (User)
//       .populate('students', '-password -__v') // Populate all students (User)
//       .lean(); // Convert to plain JS object

//     if (!classData) {
//       return res.status(404).json({
//         success: false,
//         message: 'Class not found'
//       });
//     }

//     // Add full image URL for teacher if exists
//     if (classData.teacher?.profileImage) {
//       classData.teacher.profileImageUrl = `${req.protocol}://${req.get('host')}/uploads/${classData.teacher.profileImage}`;
//     }

//     // Also add full image URLs for each student if needed
//     classData.students = classData.students.map(student => {
//       if (student.profileImage) {
//         return {
//           ...student,
//           profileImageUrl: `${req.protocol}://${req.get('host')}/uploads/${student.profileImage}`
//         };
//       }
//       return student;
//     });

//     res.status(200).json({
//       success: true,
//       data: classData
//     });

//   } catch (error) {
//     console.error('Error fetching class by ID:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Failed to fetch class details',
//       error: error.message
//     });
//   }
// });




classRoutes.get('/classes/:id', async (req, res) => {
  const classId = req.params.id;

  // ✅ Validate classId format
  if (!mongoose.Types.ObjectId.isValid(classId)) {
    return res.status(400).json({
      success: false,
      message: 'Invalid class ID format',
    });
  }

  try {
    // Step 1: Find class and populate student users
    const classDoc = await Class.findById(classId).populate({
      path: 'students',
      model: 'User',
      match: { role: 'student' },
      select: 'firstName lastName email role createdAt updatedAt',
    });

    if (!classDoc) {
      return res.status(404).json({
        success: false,
        message: 'Class not found',
      });
    }

    // Step 2: Fetch student profiles
    const students = await Promise.all(
      classDoc.students.map(async (studentUser) => {
        const studentProfile = await Student.findOne({ userID: studentUser._id });

        const profileImageUrl = studentProfile?.profileImage
          ? `${req.protocol}://${req.get('host')}/uploads/${studentProfile.profileImage}`
          : null;

        return {
          _id: studentUser._id,
          firstName: studentUser.firstName,
          lastName: studentUser.lastName,
          email: studentUser.email,
          gender: studentProfile?.gender || null,
          age: studentProfile?.age || null,
          stream: studentProfile?.stream || null,
          profileImageUrl,
          createdAt: studentUser.createdAt,
          updatedAt: studentUser.updatedAt,
        };
      })
    );

    return res.status(200).json({
      success: true,
      students,
    });

  } catch (error) {
    console.error('Error fetching class by ID:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
});






export default classRoutes;