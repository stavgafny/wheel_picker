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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ItemWheelPicker(
          children: alphabet,
          builder: (context, item, index) {
            return Text("$item-$index");
          },
          initialIndex: 3,
          looping: false,
        ),
        ItemWheelPicker(
          children: alphabet,
          builder: (context, item, index) {
            return Text("$item-$index");
          },
          initialIndex: 3,
          looping: true,
        ),
      ],
    );
  }
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
