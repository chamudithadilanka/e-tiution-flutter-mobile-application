import _class from "../src/models/class.mjs"; 

export const createClass = async (req, res) => {
  try {
    const { className, stream, teacherId, studentIds } = req.body;

    if (!className || !stream || !teacherId) {
      return res.status(400).json({ error: "className, stream, and teacherId are required" });
    }

    const newClass = new _class({
      className,
      stream,
      teacher: teacherId,
      students: studentIds || [],
    });

    const savedClass = await newClass.save();

    res.status(201).json({ success: true, message: "Class created successfully", data: savedClass });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
