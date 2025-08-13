import express from 'express';
import Timetable from '../models/timeTable.mjs';

const timetableRouter = express.Router();



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
  try {
    const { classId, slots } = req.body;

    if (!classId || !Array.isArray(slots)) {
      return res.status(400).json({ error: 'classId and slots are required' });
    }

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
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default timetableRouter;