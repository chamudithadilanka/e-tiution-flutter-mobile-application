// import express from 'express';
// import Assignment from '../models/assingment.mjs';
// import User from '../models/user.mjs'; // Assuming you have a User model
// import Class from '../models/class.mjs'; // Assuming you have a Class model
// import fs from 'fs/promises';
// import path from 'path';

// const AssignmentRoutes = express.Router();

// // Set absolute path for document uploads
// const ASSIGNMENT_UPLOADS_DIR = path.join('C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads');

// // POST: Create a new assignment
// AssignmentRoutes.post('/create', async (req, res) => {
//   try {
//     const {
//       title,
//       description,
//       dueDate,
//       classId,
//       teacherId,
//       base64Documents // Should be an array of { name, data } objects
//     } = req.body;

//     // Basic validation
//     if (!title || !dueDate || !classId || !teacherId) {
//       return res.status(400).json({
//         success: false,
//         message: 'Required fields: title, dueDate, classId, teacherId',
//       });
//     }

//     // Validate teacher
//     const teacher = await User.findOne({ _id: teacherId, role: 'teacher' });
//     if (!teacher) {
//       return res.status(404).json({
//         success: false,
//         message: 'Teacher not found or invalid role',
//       });
//     }

//     // Validate class
//     const foundClass = await Class.findById(classId);
//     if (!foundClass) {
//       return res.status(404).json({
//         success: false,
//         message: 'Class not found',
//       });
//     }

//     // Handle base64 documents
//     let savedDocs = [];

//     if (Array.isArray(base64Documents) && base64Documents.length > 0) {
//       try {
//         await fs.mkdir(ASSIGNMENT_UPLOADS_DIR, { recursive: true });

//         for (const doc of base64Documents) {
//           const matches = doc.data.match(/^data:application\/(pdf|msword|vnd.openxmlformats-officedocument.wordprocessingml.document);base64,(.+)$/i);
//           if (!matches) {
//             return res.status(400).json({
//               success: false,
//               message: `Invalid document format for ${doc.name}`
//             });
//           }

//           const ext = matches[1] === 'pdf' ? 'pdf' : 'docx';
//           const base64Data = matches[2];
//           const buffer = Buffer.from(base64Data, 'base64');

//           if (buffer.length > 10 * 1024 * 1024) { // 10MB max
//             return res.status(413).json({
//               success: false,
//               message: `${doc.name} exceeds 10MB limit`
//             });
//           }

//           const filename = `doc_${Date.now()}_${Math.random().toString(36).substring(2)}.${ext}`;
//           const filePath = path.join(ASSIGNMENT_UPLOADS_DIR, filename);
//           await fs.writeFile(filePath, buffer);
//           savedDocs.push(`assignments/${filename}`);
//         }
//       } catch (err) {
//         console.error('Error saving documents:', err);
//         return res.status(500).json({
//           success: false,
//           message: 'Failed to save assignment documents',
//         });
//       }
//     }

//     // Save to DB
//     const newAssignment = new Assignment({
//       title,
//       description,
//       dueDate,
//       classId,
//       teacherId,
//       materials: savedDocs
//     });

//     await newAssignment.save();

//     res.status(201).json({
//       success: true,
//       message: 'Assignment created successfully',
//       assignment: {
//         ...newAssignment.toObject(),
//         materialUrls: savedDocs.map(file =>
//           `${req.protocol}://${req.get('host')}/uploads/${file}`
//         )
//       },
//     });
//   } catch (error) {
//     console.error('Error creating assignment:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Server error',
//       error: error.message,
//     });
//   }
// });

// export default AssignmentRoutes;
import express from 'express';
import Assignment from '../models/assingment.mjs';
import User from '../models/user.mjs';
import Class from '../models/class.mjs';
import fs from 'fs/promises';
import path from 'path';

const AssignmentRoutes = express.Router();

// Set absolute path for document uploads
//const ASSIGNMENT_UPLOADS_DIR = path.join('C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads\\assignments');
const ASSIGNMENT_UPLOADS_DIR = path.join('C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads');
// POST: Create a new assignment
AssignmentRoutes.post('/create', async (req, res) => {
  try {
    const {
      title,
      description,
      dueDate,
      classId,
      teacherId,
      materials // This should be the array from frontend
    } = req.body;

    console.log('Received materials:', materials); // Debug log

    // Basic validation
    if (!title || !dueDate || !classId || !teacherId) {
      return res.status(400).json({
        success: false,
        message: 'Required fields: title, dueDate, classId, teacherId',
      });
    }

    // Validate teacher
    const teacher = await User.findOne({ _id: teacherId, role: 'teacher' });
    if (!teacher) {
      return res.status(404).json({
        success: false,
        message: 'Teacher not found or invalid role',
      });
    }

    // Validate class
    const foundClass = await Class.findById(classId);
    if (!foundClass) {
      return res.status(404).json({
        success: false,
        message: 'Class not found',
      });
    }

    // Handle materials (documents)
    let savedDocs = [];
    let materialUrls = [];

    if (Array.isArray(materials) && materials.length > 0) {
      try {
        // Create directory if it doesn't exist
        await fs.mkdir(ASSIGNMENT_UPLOADS_DIR, { recursive: true });

        for (const material of materials) {
          console.log('Processing material:', material.name); // Debug log
          
          // Check if material has data property
          if (!material.data) {
            console.log('No data found for material:', material.name);
            continue;
          }

          // Match base64 data pattern
          const matches = material.data.match(/^data:application\/(pdf|msword|vnd\.openxmlformats-officedocument\.wordprocessingml\.document);base64,(.+)$/i);
          
          if (!matches) {
            console.log('Invalid format for:', material.name);
            return res.status(400).json({
              success: false,
              message: `Invalid document format for ${material.name}`
            });
          }

          const mimeType = matches[1];
          const base64Data = matches[2];
          
          // Determine file extension
          let ext;
          if (mimeType === 'pdf') {
            ext = 'pdf';
          } else if (mimeType === 'msword') {
            ext = 'doc';
          } else if (mimeType === 'vnd.openxmlformats-officedocument.wordprocessingml.document') {
            ext = 'docx';
          } else {
            ext = 'pdf'; // default
          }

          const buffer = Buffer.from(base64Data, 'base64');

          // Check file size (10MB max)
          if (buffer.length > 10 * 1024 * 1024) {
            return res.status(413).json({
              success: false,
              message: `${material.name} exceeds 10MB limit`
            });
          }

          // Generate unique filename
          const timestamp = Date.now();
          const randomStr = Math.random().toString(36).substring(2);
          const sanitizedName = material.name.replace(/[^a-zA-Z0-9.-]/g, '_');
          const filename = `${timestamp}_${randomStr}_${sanitizedName}`;
          
          const filePath = path.join(ASSIGNMENT_UPLOADS_DIR, filename);
          
          // Save file
          await fs.writeFile(filePath, buffer);
          
          // Store relative path for database
          savedDocs.push(filename);
          
          // Store full URL for response
          const fileUrl = `${req.protocol}://${req.get('host')}/uploads/${filename}`;
          materialUrls.push(fileUrl);
          
          console.log('Saved file:', filename); // Debug log
        }
      } catch (err) {
        console.error('Error saving documents:', err);
        return res.status(500).json({
          success: false,
          message: 'Failed to save assignment documents',
          error: err.message
        });
      }
    }

    console.log('Saved docs:', savedDocs); // Debug log

    // Save to DB
    const newAssignment = new Assignment({
      title,
      description,
      dueDate,
      classId,
      teacherId,
      materials: savedDocs // Store filenames in database
    });

    await newAssignment.save();

    console.log('Assignment saved with materials:', newAssignment.materials); // Debug log

    res.status(201).json({
      success: true,
      message: 'Assignment created successfully',
      assignment: {
        ...newAssignment.toObject(),
        materialUrls: materialUrls // Include full URLs in response
      },
    });
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
});

// GET: Fetch assignment with material URLs
AssignmentRoutes.get('/:id', async (req, res) => {
  try {
    const assignment = await Assignment.findById(req.params.id);
    
    if (!assignment) {
      return res.status(404).json({
        success: false,
        message: 'Assignment not found'
      });
    }

    // Generate URLs for materials
    const materialUrls = assignment.materials.map(filename => 
      `${req.protocol}://${req.get('host')}/uploads/${filename}`
      
    );
    console.log(materialUrls);
    res.json({
      success: true,
      assignment: {
        ...assignment.toObject(),
        materialUrls
      }
    });
  } catch (error) {
    console.error('Error fetching assignment:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});



// GET: Fetch assignments by class ID
AssignmentRoutes.get('/class/:classId', async (req, res) => {
  try {
    const { classId } = req.params;

    // Validate class exists
    const foundClass = await Class.findById(classId);
    if (!foundClass) {
      return res.status(404).json({
        success: false,
        message: 'Class not found'
      });
    }

    // Fetch assignments for specific class
    const assignments = await Assignment.find({ classId })
      .populate('teacherId', 'name email')
      .populate('classId', 'name description')
      .sort({ createdAt: -1 });

    if (!assignments || assignments.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'No assignments found for this class'
      });
    }

    // Add material URLs to each assignment
    const assignmentsWithUrls = assignments.map(assignment => {
      const materialUrls = assignment.materials.map(filename => 
        `${req.protocol}://${req.get('host')}/uploads/${filename}`
      );

      return {
        ...assignment.toObject(),
        materialUrls,
        teacher: assignment.teacherId,
        class: assignment.classId
      };
    });

    res.json({
      success: true,
      count: assignmentsWithUrls.length,
      assignments: assignmentsWithUrls
    });
  } catch (error) {
    console.error('Error fetching assignments by class:', error);
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
});

export default AssignmentRoutes;