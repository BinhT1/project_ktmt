import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/apis/device_api.dart';
import 'package:smart_home/model/device.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_home/utils/websocket_helper.dart';

class DevicePage extends StatefulWidget {
  final Device args;
  const DevicePage({Key? key, required this.args}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool isConnect = true;
  final Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription _streamSubscription;
  Device device = Device.empty();
  Set<Marker> markers = {};

  LatLng _center = LatLng(21.031266941413712, 105.78513729318956);
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  @override
  void initState() {
    _streamSubscription = WebsocketHelper().stream.listen((message) {
      updateData(jsonDecode(message));
    });
    setState(() {
      device = widget.args;
      double lng =
          device.longitude == "" ? 0.0 : double.parse(device.longitude!);
      double lat =
          widget.args.latitude == "" ? 0.0 : double.parse(device.latitude!);
      if (device.longitude == "" && device.latitude == "") {
        isConnect = false;
      } else {
        isConnect = true;
        _center = LatLng(lat, lng);
        markers.add(Marker(
            markerId: const MarkerId("0"),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(
              title: 'My Current Location',
            ),
            icon: BitmapDescriptor.defaultMarker));
      }
    });

    super.initState();
  }

  void updateData(Map<dynamic, dynamic> data) {
    print(data);

    if (data["deviceId"] == device.deviceId) {
      print("true");
      double lng = double.parse(data["longitude"]);
      print(lng);
      double lat = double.parse(data["latitude"]);
      print(lat);

      setState(() {
        device.latitude = lat.toString();
        device.longitude = lng.toString();

        _center = LatLng(lat, lng);
        markers.clear();
        markers.add(Marker(
            markerId: const MarkerId("0"),
            position: LatLng(lat, lng),
            infoWindow: const InfoWindow(
              title: 'My Current Location',
            ),
            icon: BitmapDescriptor.defaultMarker));
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name!),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Bạn có chắc muốn xoá thiết bị không?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Huỷ',
                            style: TextStyle(),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            var res = await delete(device.deviceId!);

                            if (res["result"] == "success") {
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Lỗi Khi Lấy Dữ Liệu",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Đồng ý',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            onCameraMove: (position) => {},
            markers: markers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
          if (!isConnect) ...[
            const Opacity(
              opacity: 0.2,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black,
              ),
            ),
            const Center(
                child: Text(
              "Chưa kết nối thiết bị",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
          ]
        ],
      ),
    );
  }
}
