import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:odometer_bluetooth_app/BluetoothLowEnergy/bluetooth_le_controller.dart';
import 'package:odometer_bluetooth_app/CustomWidgets/data_card.dart';

class FirmwareDataScreen extends StatefulWidget {
  const FirmwareDataScreen(
      {super.key,
      required this.bluetoothLeController,
      required this.chosenDevice});
  final BluetoothLeController bluetoothLeController;
  final DiscoveredDevice chosenDevice;
  @override
  FirmwareDataScreenState createState() => FirmwareDataScreenState();
}

class FirmwareDataScreenState extends State<FirmwareDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chosenDevice.name),
      ),
      body: Column(
        children: [
          DataCard(
              heading: 'Distance travelled',
              data: widget.bluetoothLeController.mileage),
        ],
      ),
    );
  }
}
