import 'package:flutter/material.dart';
import 'package:odometer_bluetooth_app/Screens/scan_device_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odometer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/scanDeviceScreen': (BuildContext context) => const ScanDeviceScreen(),
      },
      home: const ScanDeviceScreen(),
    );
  }
}
