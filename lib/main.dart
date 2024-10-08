import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbluetooth/services/ble_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final BleController bleController = Get.put(BleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Device Scanner"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              bleController.scanDevices();
            },
            child: Text("Scan for Devices"),
          ),
          Obx(() {
            return Expanded(
              child: ListView.builder(
                itemCount: bleController.devicesList.length,
                itemBuilder: (context, index) {
                  final device = bleController.devicesList[index];
                  return ListTile(
                    title: Text(device.platformName.isNotEmpty
                        ? device.platformName
                        : "Unknown Device"),
                    subtitle: Text(device.id.toString()),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
