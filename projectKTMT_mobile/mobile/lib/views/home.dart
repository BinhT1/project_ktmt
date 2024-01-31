import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/apis/device_api.dart';
import 'package:smart_home/const/global.dart';
import 'package:smart_home/model/device.dart';
import 'package:smart_home/routes.dart';
import 'package:smart_home/views/device_page.dart';
import 'package:smart_home/widget/loading_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LoadingStatus _loadingStatus = LoadingStatus.initial;

  List<Device> deviceData = [];

  final TextEditingController _controllerDeviceId = TextEditingController();
  final TextEditingController _controllerDeviceName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initData() async {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });

    var res = await getAll();

    if (res["result"] == "success") {
      var listDevice = res["devices"] as List;
      var tmpDeviceData = listDevice.map((e) => Device.fromJson(e)).toList();
      setState(() {
        deviceData = tmpDeviceData;
        _loadingStatus = LoadingStatus.success;
      });
    } else {
      setState(() {
        _loadingStatus = LoadingStatus.fail;
      });

      Fluttertoast.showToast(
          msg: "Lỗi Khi Lấy Dữ Liệu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String? _validateDeviceId(String? value) {
    if (value == null || value == "") {
      return "Bạn chưa nhập mã phòng";
    } else if (!RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$')
        .hasMatch(value)) {
      return "Bạn chưa nhập đúng định dạng";
    } else {
      return null;
    }
  }

  String? _validateDeviceName(String? value) {
    if (value == null || value.isEmpty) {
      return "Bạn chưa nhập tên phòng";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            initData();
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: AppBar(
                // leading: const Icon(Icons.arrow_back),
                title: const Text("Định Vị"),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, PageNames.setting);
                    },
                    padding: const EdgeInsets.all(12),
                    icon: const Icon(
                      Icons.person,
                      size: 28,
                    ),
                  )
                ],
              ),
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.lightBlue[100]),
                          ),
                          onPressed: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              "Thêm thiét bị",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextFormField(
                                              controller: _controllerDeviceId,
                                              validator: (value) =>
                                                  _validateDeviceId(value),
                                              decoration: InputDecoration(
                                                labelText: "Mã Thiết Bị",
                                                hintText: "AB:CD:EF:12:34:56",
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              controller: _controllerDeviceName,
                                              validator: (value) =>
                                                  _validateDeviceName(value),
                                              decoration: InputDecoration(
                                                labelText: "Tên Thiết Bị",
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _loadingStatus =
                                                          LoadingStatus.loading;
                                                    });

                                                    var res = await createDevice(
                                                        _controllerDeviceId
                                                            .text,
                                                        _controllerDeviceName
                                                            .text);

                                                    if (res["result"] ==
                                                        "success") {
                                                      initData();
                                                      _controllerDeviceId.text =
                                                          "";
                                                      _controllerDeviceName
                                                          .text = "";
                                                    } else {
                                                      setState(() {
                                                        _loadingStatus =
                                                            LoadingStatus.fail;
                                                      });

                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Lỗi Khi Lấy Dữ Liệu",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                    "Thêm thiết bị")),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.red[100],
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Huỷ",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Thêm Thiết Bị",
                          )),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: deviceData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            highlightColor: Colors.lightBlue[50],
                            splashColor: Colors.lightBlue[50],
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DevicePage(
                                            args: deviceData[index],
                                          )));
                              initData();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [Text(deviceData[index].name!)],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_loadingStatus == LoadingStatus.loading) ...[
          const Opacity(
            opacity: 0.2,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          const Center(child: LoadingIndicator())
        ]
      ],
    );
  }
}
