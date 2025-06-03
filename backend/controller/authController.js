// src/controllers/authController.mjs
import User from "../models/user.mjs";
import crypto from "crypto";

export const verifyEmail = async (req, res) => {
  try {
    const { token, userId } = req.query;

    if (!token || !userId) {
      return res.status(400).json({
        success: false,
        message: "Missing verification parameters"
      });
    }

    // Hash the token
    const hashedToken = crypto
      .createHash("sha256")
      .update(token)
      .digest("hex");

    // Find and verify user
    const user = await User.findOne({
      _id: userId,
      verificationToken: hashedToken,
      verificationExpires: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "Invalid or expired verification link"
      });
    }

    // Update user
    user.isVerified = true;
    user.verifiedAt = new Date();
    user.verificationToken = undefined;
    user.verificationExpires = undefined;
    await user.save();

    // Successful response
    return res.json({
      success: true,
      message: "Email verified successfully!",
      data: {
        email: user.email,
        verifiedAt: user.verifiedAt
      }
    });

  } catch (error) {
    console.error("Verification error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error during verification"
    });
  }
};