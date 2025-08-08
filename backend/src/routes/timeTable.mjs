import express from 'express';
import Timetable from '../models/timeTable.mjs';

const timetableRouter = express.Router();

<<<<<<< HEAD


timetableRouter.post('/create',async (req,res)=>{
  try {
      const {classId,teacherId,day,subject,startTime,endTime,endDate} = req.body;

      if(!classId || !teacherId || !day || !subject || !startTime || !endTime || !endDate){
        return res.status(400).json({error:"All fields are required"});
      }

      const newSchedule = new Timetable({
        classId,
        teacherId,
        day,
        subject,
        startTime,
        endTime,
        endDate,
      });

      await newSchedule.save();
      res.status(201).json({message:"Timetable created successfully",data:newSchedule});
  
    } catch (error) {

    res.status(500).json({ error: error.message }); 
  
  }
});

timetableRouter.get('/:classId', async (req, res) => {
  try {
    const { classId } = req.params;
    const now = new Date();

    // Find all schedules for this class
    let timetables = await Timetable.find({ classId });

    // Delete expired ones
    for (let schedule of timetables) {
      if (schedule.endDate) {
        const scheduleEnd = new Date(schedule.endDate);
        
        // Combine endDate + endTime
        if (schedule.endTime) {
          const [hours, minutes] = schedule.endTime.split(":").map(Number);
          scheduleEnd.setHours(hours, minutes, 0, 0);
        }

        if (scheduleEnd < now) {
          await Timetable.deleteOne({ _id: schedule._id });
        }
      }
    }

    // Return only non-expired schedules
    timetables = await Timetable.find({ classId });
    res.json(timetables);

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

timetableRouter.put('/update', async (req, res) => {
=======
// Add or update timetable for a class
timetableRouter.post('/add', async (req, res) => {
>>>>>>> 5993507b22ce399dc36b9435b5811f83789575de
  try {
    const { classId, slots } = req.body;

    if (!classId || !Array.isArray(slots)) {
      return res.status(400).json({ error: 'classId and slots are required' });
    }

<<<<<<< HEAD
    // Find and update timetable
    const updatedTimetable = await Timetable.findOneAndUpdate(
      { classId },
      { slots },
      { new: true }
    );

    if (!updatedTimetable) {
      return res.status(404).json({ error: 'Timetable not found for this class' });
    }

    res.status(200).json(updatedTimetable);
=======
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
>>>>>>> 5993507b22ce399dc36b9435b5811f83789575de
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

<<<<<<< HEAD
=======
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


>>>>>>> 5993507b22ce399dc36b9435b5811f83789575de
export default timetableRouter;