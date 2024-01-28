import 'package:flutter/material.dart';
import 'package:odometer_bluetooth_app/BluetoothLowEnergy/bluetooth_le_controller.dart';

class ScanDeviceScreen extends StatefulWidget {
  const ScanDeviceScreen({super.key});
  @override
  ScanDeviceScreenState createState() => ScanDeviceScreenState();
}

class ScanDeviceScreenState extends State<ScanDeviceScreen> {
  late BluetoothLeController bleController;
  bool progressIndicatorVisibility = false;
  @override
  void initState() {
    super.initState();
    bleController = BluetoothLeController();
    bleController.beginScanForDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odometer app'),
      ),
      body: Stack(children: [
        Center(
            child: Visibility(
                visible: progressIndicatorVisibility,
                child: const CircularProgressIndicator())),
        ListView.builder(
          itemCount: bleController.deviceScanResultList.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(
                  bleController.deviceScanResultList.elementAt(index).name,
                ),
                onTap: () => progressIndicatorVisibility
                    ? scanItemSelected(index)
                    : null); //If already connecting to a device do nothing
          },
        )
      ]),
    );
  }

  void scanItemSelected(int index) async {
    progressIndicatorVisibility = true;
    bleController
        .connectToDevice(bleController.deviceScanResultList.elementAt(index));
    await Future.doWhile(() => Future.delayed(const Duration(seconds: 1)).then(
        (_) => !bleController.deviceConnected)); //Wait until device connected
    bleController.readMileageCharacteristic();
    progressIndicatorVisibility = false;
    //Navigator.of(context).push(MaterialPageRoute(builder: context) => const )
  }
}
