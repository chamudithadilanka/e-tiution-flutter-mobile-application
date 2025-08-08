// import multer from 'multer';
// import path from 'path';
// import { fileURLToPath } from 'url';
// import fs from 'fs/promises';


// // Get directory path for ES modules
// const __filename = fileURLToPath(import.meta.url);
// const __dirname = path.dirname(__filename);
// console.log(`sssssssssss Serving uploads from: ${path.join(__dirname, "uploads")}`);

// // Configure storage
// const storage = multer.diskStorage({
//   destination: async function (req, file, cb) {
//     const uploadDir = path.join(__dirname, '../../uploads');
//     try {
//       await fs.mkdir(uploadDir, { recursive: true });
//       cb(null, uploadDir);
//     } catch (err) {
//       cb(err);
//     }
//   },
//   filename: function (req, file, cb) {
//     const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
//     const ext = path.extname(file.originalname);
//     cb(null, file.fieldname + '-' + uniqueSuffix + ext);
//   }
// });

// // File filter for image only
// const fileFilter = (req, file, cb) => {
//   if (file.mimetype.startsWith('image/')) {
//     cb(null, true);
//   } else {
//     cb(new Error('Only image files are allowed!'), false);
//   }
// };

// // Initialize multer
// const upload = multer({ 
//   storage,
//   fileFilter,
//   limits: {
//     fileSize: 5 * 1024 * 1024 // 5MB limit
//   }
// });

// export default upload;

import multer from 'multer';
import path from 'path';
import fs from 'fs/promises';

// Set ABSOLUTE path to the desired upload directory
const UPLOADS_DIR = 'C:\\Users\\msi\\Desktop\\project_final\\backend\\uploads';

const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    try {
      await fs.mkdir(UPLOADS_DIR, { recursive: true });
      cb(null, UPLOADS_DIR); // Force files to this directory
    } catch (err) {
      cb(err);
    }
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `img-${Date.now()}${ext}`); // Example: img-1234567890.png
  }
});

export default multer({ 
  storage,
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB limit
});