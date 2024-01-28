import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataCard extends StatefulWidget {
  const DataCard({super.key, required this.heading, required this.data});
  final String heading;
  final String data;

  @override
  DataCardState createState() => DataCardState();
}

class DataCardState extends State<DataCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              widget.heading),
          Text(
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              widget.data),
        ],
      ),
    );
  }
}
