import Submission from "../models/submission.mjs";
import Assignment from "../models/assignment.mjs";

export const getSubmissions = async (req, res) => {
  try {
    const { assignmentId } = req.params;
    
    const submissions = await Submission.find({ assignmentId })
      .populate('studentId', 'name email avatar')
      .sort({ submittedAt: -1 });

    res.status(200).json({
      success: true,
      submissions
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch submissions',
      error: err.message
    });
  }
};

export const getAssignmentWithSubmissions = async (req, res) => {
  try {
    const { assignmentId } = req.params;
    
    const assignment = await Assignment.findById(assignmentId)
      .populate({
        path: 'submissions',
        populate: {
          path: 'studentId',
          select: 'name email avatar'
        }
      });

    if (!assignment) {
      return res.status(404).json({
        success: false,
        message: 'Assignment not found'
      });
    }

    res.status(200).json({
      success: true,
      assignment
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch assignment',
      error: err.message
    });
  }
};