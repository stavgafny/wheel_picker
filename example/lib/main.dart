import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: _example(),
        ),
      ),
    );
  }

  Widget _example() {
    final now = DateTime.now();
    final yearController = WheelPickerController(
      items: List.generate(100, (index) => index),
      initialIndex: now.year % 2000,
    );
    final monthController = WheelPickerController(
      items: List.generate(12, (index) => index + 1),
      initialIndex: now.month - 1,
      mount: yearController,
    );

    final dayController = WheelPickerController(
      items: List.generate(30, (index) => index + 1),
      initialIndex: now.day - 1,
      mount: monthController,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        WheelPicker(
          builder: (context, item, index) {
            return Text("${2000 + item}");
          },
          controller: yearController,
          looping: false,
        ),
        WheelPicker(
          builder: (context, item, index) {
            return Text("$item".padLeft(2, '0'));
          },
          controller: monthController,
        ),
        WheelPicker(
          builder: (context, item, index) {
            return Text("$item".padLeft(2, '0'));
          },
          controller: dayController,
        ),
      ],
    );
  }
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
