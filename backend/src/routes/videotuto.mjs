import express from 'express';
import Video from '../models/videotuto.mjs';

const videoRouter = express.Router();

// POST: Add multiple YouTube videos
videoRouter.post("/add-multiple", async (req, res) => {
  try {
    const videos = req.body.videos;

    if (!Array.isArray(videos) || videos.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid video data (empty or not an array)"
      });
    }

    const newVideos = await Video.insertMany(videos);
    res.status(201).json({
      success: true,
      count: newVideos.length,
      videos: newVideos
    });

  } catch (err) {
    console.error("Error adding videos:", err);
    res.status(500).json({
      success: false,
      message: "Server error while adding videos",
      error: err.message
    });
  }
});

videoRouter.get("/:classId", async (req, res) => {
  try {
    const { classId } = req.params;

    const videos = await Video.find({ classId }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: videos.length,
      videos
    });
  } catch (err) {
    console.error("Error fetching videos by classId:", err);
    res.status(500).json({
      success: false,
      message: "Server error while fetching videos",
      error: err.message
    });
  }



} );


export default videoRouter;
