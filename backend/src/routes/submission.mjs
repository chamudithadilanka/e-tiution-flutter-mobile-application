// routes/SubmissionRoutes.js

import express from 'express';
import multer from 'multer';
import path from 'path';
import Submission from '../models/submission.mjs';

const submissionRouter = express.Router();

// ─── Multer Setup ───────────────────────────────────────────────────────────────
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}_${file.originalname}`;
    cb(null, uniqueName);
  }
});
const upload = multer({ storage });

// ─── POST /submissions ───────────────────────────────────────────────────────────
// Body: { assignmentId, studentId, classId, comments }
// File: field name "file"
submissionRouter.post('/upload', upload.single('file'), async (req, res) => {
  try {
    const { assignmentId, studentId, classId, comments } = req.body;
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'No file uploaded' });
    }

    const submission = await Submission.create({
      assignmentId,
      studentId,
      classId,
      file: req.file.filename,
      comments
    });

    res.status(201).json({
      success: true,
      message: 'Submission created',
      submission
    });
  } catch (err) {
    console.error('Error creating submission:', err);
    res.status(500).json({ success: false, message: 'Server error', error: err.message });
  }
});

// ─── GET /submissions/assignment/:assignmentId ─────────────────────────────────
// List all submissions for one assignment
submissionRouter.get('/assignment/:assignmentId', async (req, res) => {
  try {
    const { assignmentId } = req.params;
    const submissions = await Submission
      .find({ assignmentId })
      .populate('studentId', 'name email')
      .populate('classId', 'name')
      .sort({ submittedAt: -1 });

    res.json({ success: true, count: submissions.length, submissions });
  } catch (err) {
    console.error('Error fetching by assignment:', err);
    res.status(500).json({ success: false, message: 'Server error', error: err.message });
  }
});

// ─── GET /submissions/student/:studentId ────────────────────────────────────────
// List all submissions by one student
submissionRouter.get('/student/:studentId', async (req, res) => {
  try {
    const { studentId } = req.params;
    const submissions = await Submission
      .find({ studentId })
      .populate('assignmentId', 'title description')
      .populate('classId', 'name')
      .sort({ submittedAt: -1 });

    res.json({ success: true, count: submissions.length, submissions });
  } catch (err) {
    console.error('Error fetching by student:', err);
    res.status(500).json({ success: false, message: 'Server error', error: err.message });
  }
});

export default submissionRouter;
