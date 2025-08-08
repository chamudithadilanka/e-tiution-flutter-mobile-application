import { Router } from "express";
import userRoutes from "./auth.mjs";      // Ensure this file exists
import studentRoutes from "./student.mjs";
import teacherRoutes from "./teacher.mjs";
import attendanceRoutes from "./attendance.mjs";
import classRoutes from "./class.mjs";
import Assignmentroutes from "./assingment.mjs";
import submissionRouter from "./submission.mjs";
import generateSessionRouter from "./generateSession.mjs";
import attendanceRecordRouter from "./attendanceRecord.mjs";
import videoRouter from "./videotuto.mjs";
<<<<<<< HEAD
import timetableRouter from "./timeTable.mjs"; 
=======
>>>>>>> 5993507b22ce399dc36b9435b5811f83789575de

const rootRouter = Router();

// Register routes correctly
rootRouter.use("/v1", userRoutes);  // Change "/v1/register" to "/v1/login"
rootRouter.use("/teachers", teacherRoutes);
rootRouter.use("/students", studentRoutes);
rootRouter.use("/attendance", attendanceRoutes);
//rootRouter.use("/notifications", notificationRoutes);
rootRouter.use("/class",classRoutes);
rootRouter.use("/assignment",Assignmentroutes);
rootRouter.use("/submission",submissionRouter);
rootRouter.use("/session",generateSessionRouter);
rootRouter.use("/qrattendance",attendanceRecordRouter);
rootRouter.use("/video", videoRouter);
<<<<<<< HEAD
rootRouter.use("/timetable", timetableRouter); // Ensure timetableRouter is imported
=======
>>>>>>> 5993507b22ce399dc36b9435b5811f83789575de
export default rootRouter;
