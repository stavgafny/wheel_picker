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
    final c1 = WheelPickerController(initialIndex: 4);
    final c2 = WheelPickerController(initialIndex: 4, mount: c1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ItemWheelPicker(
          children: List.generate(100, (index) => index),
          builder: (context, item, index) {
            return Text("${2000 + item}");
          },
          controller: c1,
          looping: false,
          onSelectedItemChanged: (item, index) {},
        ),
        ItemWheelPicker(
          children: List.generate(12, (index) => index + 1),
          builder: (context, item, index) {
            return Text("$item".padLeft(2, '0'));
          },
          controller: c2,
        ),
      ],
    );
  }
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
