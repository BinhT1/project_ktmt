const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const device = require("../middleware/deviceMiddleware");
const deviceController = require("../controllers/deviceController");

//create device
router.post("/api/v1/device/create", auth, deviceController.createDevice);

router.get("/api/v1/device/get-all", auth, deviceController.getAll);

router.post("/api/v1/device/delete", auth, device, deviceController.delete);

module.exports = router;
