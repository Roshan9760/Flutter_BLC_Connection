import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbluetooth/services/ble_controller.dart';

class DeviceListPage extends StatelessWidget {
  final BleController bleController = Get.put(BleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              bleController.scanDevices();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            // Display connection status
            return Text(bleController.connectionStatus.value);
          }),
          Expanded(
            child: Obx(() {
              // Display devices list
              return ListView.builder(
                itemCount: bleController.devicesList.length,
                itemBuilder: (context, index) {
                  final device = bleController.devicesList[index];
                  return ListTile(
                    title: Text(
                        device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
                    subtitle: Text(device.remoteId.toString()),
                    onTap: () {
                      bleController.connectToDevice(device);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
