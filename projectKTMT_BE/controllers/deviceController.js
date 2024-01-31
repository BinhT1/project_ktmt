const Device = require("../models/Device");
const { isObjectNull } = require("../utils/index");

const deviceController = {
  createDevice: async (req, res) => {
    try {
      const { name, deviceId } = req.body;

      // check variable
      if (
        name == "" ||
        deviceId == "" ||
        isObjectNull(name) ||
        isObjectNull(deviceId)
      ) {
        return res.status(400).send({
          result: "fail",
          message: "thiếu name hoặc deviceId",
        });
      }

      // user from auth middleware
      const user = req.user;

      const devices = await Device.find({
        user: user.id,
      });

      for (var i = 0; i < devices.length; i++) {
        if (devices[i].deviceId == deviceId || devices[i].name == name) {
          return res.status(400).send({
            result: "fail",
            message: "deviceId hoặc tên đã tồn tại ",
          });
        }
      }

      const newDevice = new Device({
        user: user.id,
        deviceId: deviceId,
        name: name,
        longitude: "",
        latitude: "",
      });

      await newDevice.save();

      await newDevice.populate("user");

      return res.json({
        result: "success",
        device: newDevice,
      });
    } catch (err) {
      res.status(500).send({
        result: "fail",
        message: err.message,
      });
    }
  },
  getAll: async (req, res) => {
    try {
      const user = req.user;
      const devices = await Device.find({
        user: user.id,
      });

      return res.status(200).json({
        result: "success",
        devices: devices,
      });
    } catch (err) {
      res.status(500).send({
        result: "fail",
        message: err.message,
      });
    }
  },
  delete: async (req, res) => {
    try {
      const deviceId = req.body.deviceId;

      await Device.findOneAndDelete({ deviceId: deviceId });

      return res.send({
        result: "success",
      });
    } catch (err) {
      res.status(500).send({
        result: "fail",
        message: err.message,
      });
    }
  },
  updateData: async (data) => {
    try {
      const { deviceId, longitude, latitude } = data;

      await Device.findOneAndUpdate(
        {
          deviceId: deviceId,
        },
        {
          longitude: longitude,
          latitude: latitude,
        }
      );
    } catch (err) {
      console.log({
        result: "fail",
        message: "Không thể cập nhập dữ liệu cho phòng",
        reason: err.message,
      });
    }
  },
};

module.exports = deviceController;
