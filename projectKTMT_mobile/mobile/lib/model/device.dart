class Device {
  String? deviceId;
  String? user;
  String? name;
  String? longitude;
  String? latitude;

  Device({this.deviceId, this.user, this.name, this.longitude, this.latitude});

  Device.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    user = json['user'];
    name = json['name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['user'] = this.user;
    data['name'] = this.name;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }

  Device.empty() {
    deviceId = "";
    user = "";
    name = "";
    longitude = "";
    latitude = "";
  }
}
