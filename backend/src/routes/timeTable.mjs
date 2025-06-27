import express from 'express';
import Timetable from '../models/timeTable.mjs';

const timetableRouter = express.Router();

// Add or update timetable for a class
timetableRouter.post('/add', async (req, res) => {
  try {
    const { classId, slots } = req.body;

    if (!classId || !Array.isArray(slots)) {
      return res.status(400).json({ error: 'classId and slots are required' });
    }

    // Check if timetable exists
    let timetable = await Timetable.findOne({ classId });

    if (timetable) {
      // Update
      timetable.slots = slots;
      await timetable.save();
    } else {
      // Create new
      timetable = new Timetable({ classId, slots });
      await timetable.save();
    }

    res.status(201).json(timetable);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

timetableRouter.get('/:classId', async (req, res) => {
  try {
    const { classId } = req.params;
    const timetable = await Timetable.findOne({ classId });

    if (!timetable) {
      return res.status(404).json({ message: 'Timetable not found' });
    }

    res.json(timetable);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


export default timetableRouter;