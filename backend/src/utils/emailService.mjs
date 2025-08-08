import nodemailer from "nodemailer";

// Setup Nodemailer transporter
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true, // Use SSL for port 465
  auth: {
    user: process.env.EMAIL_USERNAME,
    pass: process.env.EMAIL_PASSWORD
  },
  tls: {
    // Warning: This disables certificate validation. Use only for dev.
    rejectUnauthorized: false
  }
});

// Verify connection on server start
transporter.verify((error, success) => {
  if (error) {
    console.error("❌ SMTP Connection Error:", error);
  } else {
    console.log("📬 SMTP Server Ready");
  }
});

// Send verification email
export const sendVerificationEmail = async (email, token, userId, firstName) => {
  try {
    const verificationUrl = `${process.env.BASE_URL}/api/v1/verify-email?token=${token}&userId=${userId}`;

    const mailOptions = {
      from: `"Your App" <${process.env.EMAIL_USERNAME}>`,
      to: email,
      subject: "Verify Your Email",
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto;">
          <h2 style="color: #2563eb;">Email Verification</h2>
          <p>Hi ${firstName},</p>
          <p>Thanks for signing up! Click the button below to verify your email:</p>
          <a href="${verificationUrl}" 
             style="display: inline-block; padding: 12px 24px; background-color: #2563eb;
                    color: #ffffff; text-decoration: none; border-radius: 6px; font-weight: bold;">
            Verify Email
          </a>
          <p style="margin-top: 20px; font-size: 12px; color: #6b7280;">
            This link will expire in 24 hours. If you did not request this, please ignore this email.
          </p>
        </div>
      `,
      text: `Hi ${firstName}, please verify your email by visiting this link: ${verificationUrl}`
    };

    const info = await transporter.sendMail(mailOptions);
    console.log(`📤 Verification email sent to ${email}: ${info.messageId}`);
    return true;
  } catch (error) {
    console.error("❌ Email Sending Error:", error);
    throw new Error("Failed to send verification email");
  }
};




// import nodemailer from "nodemailer";

// // Configure transporter with explicit settings
// const transporter = nodemailer.createTransport({
//   host: "smtp.gmail.com",
//   port: 465,
//   secure: true, // true for 465, false for other ports
//   auth: {
//     user: process.env.EMAIL_USERNAME,
//     pass: process.env.EMAIL_PASSWORD
//   },
//   tls: {
//     rejectUnauthorized: false // Only for testing with self-signed certs
//   }
// });

// // Verify connection on startup
// transporter.verify((error) => {
//   if (error) {
//     console.error("SMTP Connection Error:", error);
//   } else {
//     console.log("SMTP Server Ready");
//   }
// });

// export const sendVerificationEmail = async (email, token, userId) => {
//   try {
//     const verificationUrl = `${process.env.BASE_URL}/api/auth/verify-email?token=${token}&userId=${userId}`;
    
//     const mailOptions = {
//       from: `"Your App" <${process.env.EMAIL_USERNAME}>`,
//       to: email,
//       subject: "Verify Your Email",
//       html: `
//         <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
//           <h2 style="color: #2563eb;">Email Verification</h2>
//           <p>Please click the button below to verify your email address:</p>
//           <a href="${verificationUrl}" 
//              style="display: inline-block; padding: 12px 24px; background-color: #2563eb; 
//                     color: white; text-decoration: none; border-radius: 4px; font-weight: bold;">
//             Verify Email
//           </a>
//           <p style="margin-top: 20px; font-size: 12px; color: #6b7280;">
//             This link will expire in 24 hours. If you didn't request this, please ignore this email.
//           </p>
//         </div>
//       `,
//       // Text fallback for non-HTML clients
//       text: `Verify your email by visiting: ${verificationUrl}`
//     };

//     const info = await transporter.sendMail(mailOptions);
//     console.log("Verification email sent:", info.messageId);
//     return true;
//   } catch (error) {
//     console.error("Email Sending Error:", error);
//     throw new Error("Failed to send verification email");
//   }
// };