const mongoose = require("mongoose");

const Device = new mongoose.Schema(
  {
    deviceId: {
      type: String,
      require: true,
      unique: true,
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user",
    },
    name: String,
    longitude: {
      type: String,
      default: "",
    },
    latitude: {
      type: String,
      default: "",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("device", Device);
