import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  // Observable list of devices and scan results
  var devicesList = <BluetoothDevice>[].obs;
  var scanResults = <ScanResult>[].obs;

  // Selected device for connection
  var connectedDevice = Rx<BluetoothDevice?>(null);
  var connectionStatus = RxString('');

  Future<void> scanDevices() async {
    // Check and request permissions
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {
      final bluetoothStatus = await FlutterBluePlus.isOn;
      if (!bluetoothStatus) {
        print("Bluetooth is turned off. Please turn it on.");
        return;
      }

      // Clear previous results
      print('Printinting list $devicesList');
      devicesList.clear();
      scanResults.clear();

      // Start scanning
      FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results;
        for (ScanResult result in results) {
          if (!devicesList.any((device) => device.id == result.device.id)) {
            devicesList.add(result.device);
            print('result is $result');
            print(
                'Found device: ${result.device.platformName.isEmpty ? 'Unknown' : result.device.platformName} (${result.device.id})');
          }
        }
      });

      // Stop scanning after the timeout
      await Future.delayed(Duration(seconds: 10));
      FlutterBluePlus.stopScan();
    } else {
      print("Bluetooth permissions not granted");
    }
  }

  // Method to connect to a device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      connectionStatus.value = 'Connecting to ${device.platformName}...';

      await device.connect();
      connectedDevice.value = device;
      connectionStatus.value = 'Connected to ${device.platformName}';

      print('Connected to ${device.platformName}');
    } catch (e) {
      connectionStatus.value = 'Failed to connect';
      print('Failed to connect: $e');
    }
  }

  // Method to disconnect the device
  Future<void> disconnectDevice() async {
    if (connectedDevice.value != null) {
      await connectedDevice.value!.disconnect();
      connectionStatus.value =
          'Disconnected from ${connectedDevice.value!.platformName}';
      connectedDevice.value = null;
    }
  }
}
