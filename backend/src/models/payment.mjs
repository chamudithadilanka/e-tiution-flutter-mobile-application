import mongoose from "mongoose";

const paymentSlipSchema = new mongoose.Schema({
    studentId:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true},
    classId:{type:mongoose.Schema.Types.ObjectId, ref:'Class',required:true},
    amount:{type:Number},
    month:{type:String},
    slipFile:{type:String,required:true},
    status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
    teacherId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // who approved/rejected
  teacherComment: { type: String },
  submittedAt: { type: Date, default: Date.now },
  reviewedAt: { type: Date },
},{

 timestamps: true
  
});

export default mongoose.model('PaymentSlip', paymentSlipSchema);