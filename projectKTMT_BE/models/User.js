const mongoose = require("mongoose");

const User = new mongoose.Schema(
  {
    email: {
      type: String,
      require: true,
      unique: true,
    },
    password: {
      type: String,
      require: true,
    },
    accessToken: String,
    expirationDateToken: Date,
    resetPasswordToken: String,
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("user", User);
