import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothLeController {
  final serviceUuid = Uuid.parse("65f7e7ee-7771-4698-a8f1-049de4643fd3");
  final characteristicMileageWriteUuid =
      Uuid.parse("45f1622c-ffd5-4347-9d30-8bdd7ca14804");
  final flutterBle = FlutterReactiveBle();

  late QualifiedCharacteristic mileageWriteCharacteristic;
  late StreamSubscription<DiscoveredDevice> scanDeviceStream;
  late String mileage;

  //Set<DiscoveredDevice> deviceScanResultSet = {}; //Set used to prevent adding the same device multiple times
  List<DiscoveredDevice> deviceScanResultList = List.empty(growable: true);

  bool deviceConnected = false;

  void beginScanForDevices() async {
    bool bluetoothPermGranted = false;

    if (Platform.isAndroid) {
      var status = await Permission.bluetooth.request();
      if (status == PermissionStatus.granted) {
        bluetoothPermGranted = true;
      } else {
        //Log here permission status result
      }
    }

    if (Platform.isIOS) {
      //IOS doesn't ask for perms for this
      bluetoothPermGranted = true;
    }

    if (!bluetoothPermGranted) {
      //If cannot access bluetooth return early request user to allow bluetooth
      return;
    }

    scanDeviceStream = flutterBle.scanForDevices(
        withServices: [serviceUuid],
        scanMode: ScanMode.lowLatency).listen((device) {
      //deviceScanResultSet.add(device);
      deviceScanResultList.add(device);
    }, onError: () {
      //Log here later when i get the log library to work
    });
  }

  void connectToDevice(DiscoveredDevice selectedDevice) {
    scanDeviceStream.cancel(); //No longer need to scan for device

    Stream<ConnectionStateUpdate> deviceConnectionStream =
        flutterBle.connectToDevice(id: selectedDevice.id);
    deviceConnectionStream.listen((event) {
      switch (event.connectionState) {
        case DeviceConnectionState.connected:
          {
            mileageWriteCharacteristic = QualifiedCharacteristic(
                characteristicId: characteristicMileageWriteUuid,
                serviceId: serviceUuid,
                deviceId: selectedDevice.id);
            deviceConnected = true;
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            //log here that device has disconnected
            deviceConnected = false;
            break;
          }
        default:
          {
            //log here other connection states
          }
      }
    });
  }

  void readMileageCharacteristic() {
    flutterBle.subscribeToCharacteristic(mileageWriteCharacteristic).listen(
        (bleData) {
      mileage = String.fromCharCodes(bleData);
    }, onError: (dynamic error) {
      //Log error here
    });
  }
}
