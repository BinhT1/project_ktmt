import 'package:smart_home/apis/dio.dart';

dynamic createDevice(String deviceId, String name) async {
  var res = await sendRequest(
      "/api/v1/device/create", "POST", {"deviceId": deviceId, "name": name});

  print(res);

  return res;
}

dynamic getAll() async {
  var res = await sendRequest(
    "/api/v1/device/get-all",
    "GET",
  );

  print(res);

  return res;
}

dynamic delete(String deviceId) async {
  var res = await sendRequest("/api/v1/device/delete", "POST", {
    "deviceId": deviceId,
  });

  print(res);

  return res;
}
