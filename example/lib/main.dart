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
      home: const Scaffold(
        body: Center(
          child: Example(),
        ),
      ),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final yearController = WheelPickerController(
      items: List.generate(100, (index) => index),
      initialIndex: 0,
    );
    final monthController = WheelPickerController(
      items: List.generate(12, (index) => index + 1),
      initialIndex: 0,
      mount: yearController,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
      ],
    );
  }
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
