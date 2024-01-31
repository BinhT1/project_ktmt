const Device = require("../models/Device");
const { isObjectNull } = require("../utils/index");

// kiểm tra người dùng có sở hữu phòng này không
// sử dụng cho các API có sử dụng trường deviceId
const device = async (req, res, next) => {
  try {
    const user = req.user;
    const deviceId = req.body.deviceId;

    if (deviceId == "" || isObjectNull(deviceId)) {
      return res.status(400).send({
        result: "fail",
        message: "Thiếu tham số deviceId",
      });
    }

    const device = await Device.findOne({
      deviceId: deviceId,
    });

    if (!device) {
      return res.status(400).send({
        result: "fail",
        message: "deviceId không tồn tại",
      });
    }
    if (device.user.toString() !== user.id) {
      return res.status(400).send({
        result: "fail",
        message: "Người dùng không sở hữu phòng này",
      });
    }

    req.device = device;
    next();
  } catch (err) {
    res.status(500).send({
      result: "fail",
      message: err.message,
    });
  }
};

module.exports = device;
